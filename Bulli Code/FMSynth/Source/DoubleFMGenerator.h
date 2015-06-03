#pragma once
#include "DefaultEnvelope.h"
#include "Generator.h"

class DoubleFMGenerator : public Generator
{
public:
	DoubleFMGenerator(float carrier = 440, float modulation1 = 440, float modIndex1 = 1.0, float modulation2 = 440, float modIndex2 = 1.0, Envelope* env = new DefaultEnvelope(1, 1, 1, 1, 1));
	~DoubleFMGenerator();

	float process(double sampleRate, long long currentTime);
	void reset();


public:
	// FM Parameters
	float freqCarrier;
	float freqModulation;
	float freqModulation2;
	float modulationIndex;
	float modulationIndex2;
	bool Attack;

private:

	float phaseCarrier;
	float phaseModulation;
	float phaseModulation2;
	Envelope* envelope;

};

