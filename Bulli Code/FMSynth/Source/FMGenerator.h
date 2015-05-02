#pragma once
class FMGenerator
{
public:
	FMGenerator();
	FMGenerator(float carrier, float modulation, float modIndex);
	~FMGenerator();

	float process(double sampleRate);

public:
	// FM Parameters
	float freqCarrier;
	float freqModulation;
	float modulationIndex;

private:
	float phaseCarrier;
	float phaseModulation;
};

