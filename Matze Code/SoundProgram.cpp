// SoundProgram.cpp : Definiert den Einstiegspunkt für die Konsolenanwendung.

#include "stdafx.h"

#define _USE_MATH_DEFINES

#include <vector>
#include <cmath>
#include <iostream>
#include <fstream>
#include <stdint.h>
#include <utility>
#include <windows.h>
#include <limits>

using namespace std;

const int numberOfChannels = 1;
//Deprecated
vector<short> createSine(int samplerate,int dauerInSekunden, int hertz) {

	vector<short> sine;
	
	double sinePosition;
	double sineWave = 2 * M_PI * hertz * dauerInSekunden;
	double sampleZahlGesamt = samplerate * dauerInSekunden;

	for(int i = 0; i < samplerate * dauerInSekunden; i++) {

		sinePosition = i * sineWave;
		short val = static_cast<short>(sin(sinePosition / sampleZahlGesamt) * MAXSHORT);
		for (int j = 0; j < numberOfChannels; j++)
			sine.push_back(val);
	}

	return sine;
}

//Mod-Index = 0 gibt hier den einfachen Sinuston
vector<short> modulateSine(int samplerate, int dauerInSekunden, double carrierFrequenzInHertz, double modulatorFrequenzInHertz, double modI) {

	vector<short> sine;
	const double sampleZahlGesamt = samplerate * dauerInSekunden;
	const double stepCarrier = ((2*M_PI*carrierFrequenzInHertz) * dauerInSekunden) / sampleZahlGesamt;
	const double stepSine = ((2*M_PI*modulatorFrequenzInHertz) * dauerInSekunden) / sampleZahlGesamt;
	

	double modulator = 0;
	double carrier = 0;

	for(int i = 0; i < samplerate * dauerInSekunden; i++) {

		carrier   += stepCarrier;
		modulator += stepSine;

		short val = static_cast<short>(cos(carrier + modI * sin(modulator)) * MAXSHORT);
		for (int j = 0; j < numberOfChannels;j++)
			sine.push_back(val);
	}

	return sine;
}

struct Headerdata {
	char riff[4];
	int filesize;
	char wave[4];
	char fmt[4];
	int fmtLength;
	short typeOfFormatPCMis1;
	short numberOfChannels2;
	int sampleRate;
	int sampleRateTBitsPerSampleTChannelsDiv8;
	short bitsPerSampleTChannelsDiv8;
	short bitsPerSample;
	char data[4];
	int datasize;
};


void writeWaveHeader(ofstream& waveOut) {
	Headerdata header;
	memcpy(header.riff,"RIFF",4);
	header.filesize = 0;
	memcpy(header.wave,"WAVE",4);
	memcpy(header.fmt,"fmt ",4);
	header.fmtLength = 16;
	header.typeOfFormatPCMis1 = 1;
	header.numberOfChannels2 = numberOfChannels;
	header.sampleRate = 44100;
	header.sampleRateTBitsPerSampleTChannelsDiv8 = 44100*16*header.numberOfChannels2/8;
	header.bitsPerSampleTChannelsDiv8 = header.numberOfChannels2*16/8;
	header.bitsPerSample = 16;
	memcpy(header.data,"data",4);
	header.datasize = 0;

	waveOut.write(reinterpret_cast<char*>(&header),sizeof(header));
}

void writeWaveData(ofstream& waveOut, vector<short> data) {

	for(int i = 0; i < data.size(); i++) {
		waveOut.write(reinterpret_cast<char*>(&data[i]),sizeof(short));
	}

	int datalength = data.size() * sizeof(short);
	waveOut.seekp(40,ios::beg);
	waveOut.write(reinterpret_cast<char*>(&datalength),sizeof(int));

	waveOut.seekp(0,ios::end);
	int rifflength = waveOut.tellp();

	rifflength -= 8;
	waveOut.seekp(4,ios::beg);
	waveOut.write(reinterpret_cast<char*>(&rifflength),sizeof(int));
}



int _tmain(int argc, _TCHAR* argv[])
{
	//Modulierten Sinuston generieren
	vector<short> sineWave = modulateSine(44100,2,200,201.5,1);

	//Binärstream erzeugen
	ofstream waveOutRef("output.wav",ios::binary);

	//Header schreiben
	writeWaveHeader(waveOutRef);

	//Data schreiben
	writeWaveData(waveOutRef,sineWave);

	//Stream schließen
	waveOutRef.close();

	//Soundfile abspielen
	PlaySound(TEXT("output.wav"), NULL, SND_FILENAME);
}