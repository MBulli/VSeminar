#pragma once
#include "DefaultEnvelope.h"
#include "Generator.h"

class FeedbackFMGenerator : public Generator
{
public:
	FeedbackFMGenerator(float carrier = 440, float modulation = 440, float modIndex = 1.0, Envelope* env = new DefaultEnvelope(1, 1, 1, 1, 1));
	~FeedbackFMGenerator();

	float process(double sampleRate, long long currentTime);
	void reset();


public:
	// FM Parameters
	float freqCarrier;
	float freqModulation;
	float modulationIndex;
	bool Attack;

private:

	float phaseCarrier;
	float phaseModulation;
	Envelope* envelope;
	float previousValue;
};

