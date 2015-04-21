// SimpleAudio.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

#define _USE_MATH_DEFINES
#include <math.h>
#include <vector>
#include <iostream>
#include <fstream>
#include <utility>
#include <string>
#include <stdint.h>

#include <Windows.h>

#define NUM_CHANNELS 1


struct FMSettings {
	double FC;
	double FM;
	double MI;

	FMSettings(double fc = 0, double fm = 0, double mi = 0)
		: FC(fc), FM(fm), MI(mi)
	{
	}
};

FMSettings bla[2] = {
	FMSettings(440, 880, 2),
	FMSettings(1100, 2200, 5)
};


template<typename T>
std::ostream& binary_write(std::ostream& stream, const T& value){
    return stream.write(reinterpret_cast<const char*>(&value), sizeof(T));
}

double ToneToFrequence(char t)
{
	switch (t)
	{
	case 'c': return 264;
	case 'd': return 297;
	case 'e': return 330;
	case 'f': return 352;
	case 'g': return 396;
	case 'a': return 440;
	case 'h': return 495;
	// case 'cc'
	default: return 0;
	}
}

//std::vector<short> FMSyn(int sampleRate, int lengthInSec, double magnitude, FMSettings& settings)
//{
//	return FMSyn(sampleRate, lengthInSec, magnitude, settings.FC, settings.FM, settings.MI);
//}

std::vector<short> FMSyn(int sampleRate, int lengthInSec, double magnitude, double fc, double fm, double modIndex)
{
	std::vector<short> result;

	const int numSamples = lengthInSec * sampleRate * NUM_CHANNELS;
	const double TWO_PI_OVER_SAMPLE_RATE = 2*M_PI/sampleRate;

    double carrierFrequency = fc;
	double modulatorFrequency = fm;
    double modulationIndex = modIndex; 
       
	double carrierAngle = 0;
	double modulatorAngle = 0; 

	for(int i=0; i < numSamples; i += NUM_CHANNELS)
    {

		//if ((i % (sampleRate/40)) == 0)
		//{
		//	modulationIndex += 2;
		//	carrierFrequency++;
		//	modulatorFrequency++;

		//	if (modulationIndex > 40)
		//	{
		//		//carrierFrequency = fc;
		//		modulationIndex = 0;
		//	}
		//}
				

		float value = sin(carrierAngle);
		result.push_back(static_cast<short>(value * magnitude * SHRT_MAX));

		carrierAngle += (carrierFrequency + sin(modulatorAngle) * carrierFrequency * modulationIndex) * TWO_PI_OVER_SAMPLE_RATE;
		modulatorAngle += modulatorFrequency * TWO_PI_OVER_SAMPLE_RATE;
    }

	return result;
}

std::vector<short> FMSynWithRatio(int sampleRate, int lengthInSec, double magnitude, double fc, double fratio, double modIndex)
{
	double fm = fc * fratio;

	return FMSyn(sampleRate, lengthInSec, magnitude, fc, fm, modIndex);
}

std::vector<short> CreateSinWave(int sampleRate, double frequency, int length, double magnitude)
{
	int sampleCount = sampleRate * length;
	std::vector<short> result;
	double step = M_PI*2 / frequency;
	double current = 0;

	for (int i = 0; i < sampleCount; i++)
	{
		short value = sin(current) * magnitude * SHRT_MAX;
		current += step;

		result.push_back(value);
	}

	return result;
}

void WriteWaveHeader(std::ostream& stream, int byteStreamSize, int channelCount, int sampleRate)
{
	const uint16_t BYTES_PER_SAMPLE = 2;
	const uint32_t FMT_CHUNKSIZE = 16;
	const uint16_t PCM_FORMAT = 0x0001;

	int byteRate = sampleRate * channelCount * BYTES_PER_SAMPLE;
    int blockAlign = channelCount * BYTES_PER_SAMPLE;

	// header
	// filesize = data + RIFF header + fmt chunk + data chunk
	uint32_t fileSize = byteStreamSize + 12 + 24 + 8;

	stream.write("RIFF", 4);
	binary_write(stream, static_cast<uint32_t>(fileSize - 8));
	stream.write("WAVE", 4);

	// fmt chunk
	stream.write("fmt ", 4); // note whitespace
	binary_write(stream, FMT_CHUNKSIZE);
	//stream.write(reinterpret_cast<char*>(FMT_CHUNKSIZE), 4); // fmt length
	binary_write(stream, PCM_FORMAT);
	binary_write(stream, static_cast<uint16_t>(channelCount));
	binary_write(stream, static_cast<uint32_t>(sampleRate));
	binary_write(stream, static_cast<uint32_t>(byteRate));
	binary_write(stream, static_cast<uint16_t>(blockAlign));
	binary_write(stream, static_cast<uint16_t>(BYTES_PER_SAMPLE*8));
}

void WriteData(std::ostream& stream, std::vector<short>& data)
{
	const uint32_t byteStreamSize = data.size()*sizeof(short);

	// data chunk
	stream.write("data", 4);
	binary_write(stream, static_cast<uint32_t>(byteStreamSize - 44));

	for(std::vector<short>::iterator it = data.begin(); it != data.end(); ++it) 
	{
		binary_write(stream, *it);
	}
}
 

void WriteToneToFile(char tone)
{
	double freq = ToneToFrequence(tone);
	std::vector<short> audioData = CreateSinWave(44000, freq, 1, 1);

	char fileName[6];
	sprintf_s(fileName, sizeof(fileName), "%c.wav", tone);
	std::ofstream output(fileName, std::ios::binary);

	WriteWaveHeader(output, audioData.size()*sizeof(short), 1, 44100); 
	WriteData(output, audioData);
	output.close();
}

int _tmain(int argc, _TCHAR* argv[])
{
	//char c;
	//do {
	//	c = getchar();
	//	putchar (c);
	//	if (c == 'q')
	//		break;
	//
	//	wchar_t fileName[6];
	//	swprintf_s(fileName, sizeof(fileName), _T("%c.wav"), c);
	//	PlaySound(fileName, NULL, SND_FILENAME);
	//} while (1);


	//std::vector<short> audioData = FMSyn(44000, // sample rate
	//								     3,		// länge in sec
	//									 1,   	// magnitute
	//									 440,	// träger frequenz
	//									 880,   // modulations frequenz
	//									 0.01   // modulations index
	//									 );


	std::vector<short> audioData = FMSynWithRatio(44100, // sample rate
									     1,		// länge in sec
										 1,   	// magnitute
										 440,	// träger frequenz
										 1,   // ratio
										 M_PI/2.0   // modulations index
										 );
	std::ofstream output("output2.wav", std::ios::binary);
	WriteWaveHeader(output, audioData.size()*sizeof(short), 1, 44100); 
	WriteData(output, audioData);
	output.close();
	
	PlaySound(TEXT("output2.wav"), NULL, SND_FILENAME);

	return 0;
}

