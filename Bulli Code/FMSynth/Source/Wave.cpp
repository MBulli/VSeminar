#include "Wave.h"
#include <iostream>
#include <stdint.h>
#include <fstream>
#include <vector>

template<typename T>
std::ostream& binary_write(std::ostream& stream, const T& value){
	return stream.write(reinterpret_cast<const char*>(&value), sizeof(T));
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
	binary_write(stream, static_cast<uint16_t>(BYTES_PER_SAMPLE * 8));
}
void WriteData(std::ostream& stream, std::vector<short>& data)
{
	const uint32_t byteStreamSize = data.size()*sizeof(short);

	// data chunk
	stream.write("data", 4);
	binary_write(stream, static_cast<uint32_t>(byteStreamSize - 44));

	for (std::vector<short>::iterator it = data.begin(); it != data.end(); ++it)
	{
		binary_write(stream, *it);
	}
}
void Wave::WriteWave(std::vector<short> audioData, int channelCount = 1, int sampleRate = 44100){
	std::ofstream output("output2.wav", std::ios::binary);
	WriteWaveHeader(output, audioData.size()*sizeof(short), channelCount, sampleRate);
	WriteData(output, audioData);
}