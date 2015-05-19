#pragma once
class FMGenerator
{
public:
	FMGenerator(float carrier = 440, float modulation = 440, float modIndex = 1.0, int attackTime = 50, int decayTime = 50, int releaseTime = 50, float attackValue = 1.0, float decayValue = 0.5);
	~FMGenerator();

	float process(double sampleRate, long long currentTime);
	void reset();

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

