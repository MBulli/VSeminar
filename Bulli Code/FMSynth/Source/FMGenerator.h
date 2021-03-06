#pragma once
#include "DefaultEnvelope.h"
#include "Generator.h"

class FMGenerator : public Generator
{
public:
	FMGenerator(float carrier = 440, float modulation = 440, float modIndex = 1.0, Envelope* env = new DefaultEnvelope(1,1,1,1,1));
	~FMGenerator();

	float process(double sampleRate, long long currentTime);
	void reset();


public:
	// FM Parameters
	float freqCarrier;
	float freqModulation;
	float modulationIndex;
	bool Attack;
	Envelope* envelope;

private:

	float phaseCarrier;
	float phaseModulation;

};

