#pragma once
#include "Envelope.h"

class Generator
{
public:
	virtual float process(double sampleRate, long long currentTime) = 0;
	virtual void reset() = 0;

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

};

