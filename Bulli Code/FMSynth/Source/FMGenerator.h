#pragma once
class FMGenerator
{
public:
	FMGenerator();
	FMGenerator(float carrier, float modulation, float modIndex);
	FMGenerator(float carrier, float modulation, float modIndex, int attackTime, int decayTime, int releaseTime, float attackValue, float decayValue);
	~FMGenerator();

	float process(double sampleRate, long long currentTime);

private:
	float FMGenerator::Envelope(bool release, long long currentTime);

public:
	// FM Parameters
	float freqCarrier;
	float freqModulation;
	float modulationIndex;
	bool Attack;

private:

	float phaseCarrier;
	float phaseModulation;

	long long AttackTimeStamp;
	long long ReleaseTimeStamp;

	int AttackTime;
	int DecayTime;
	int ReleaseTime;
	float AttackValue;
	float DecayValue;
};

