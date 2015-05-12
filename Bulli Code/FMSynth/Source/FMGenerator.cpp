#include "FMGenerator.h"

#define _USE_MATH_DEFINES

#include <cmath>
#include "TimeHelper.h"

FMGenerator::FMGenerator()
	: phaseCarrier(0),
	phaseModulation(0),
	freqCarrier(440),
	freqModulation(440),
	modulationIndex(1.0),
	AttackTime(500),
	DecayTime(500),
	ReleaseTime(500),
	AttackValue(1.0),
	DecayValue(0.5)
{
}

FMGenerator::FMGenerator(float carrier, float modulation, float modIndex)
	: phaseCarrier(0),
	phaseModulation(0),
	freqCarrier(carrier),
	freqModulation(modulation),
	modulationIndex(modIndex),
	AttackTime(500),
	DecayTime(500),
	ReleaseTime(500),
	AttackValue(1.0),
	DecayValue(0.5)
{

}
FMGenerator::FMGenerator(float carrier, float modulation, float modIndex, int attackTime, int decayTime, int releaseTime, float attackValue, float decayValue)
	: phaseCarrier(0),
	phaseModulation(0),
	freqCarrier(carrier),
	freqModulation(modulation),
	modulationIndex(modIndex),
	AttackTime(attackTime),
	DecayTime(decayTime),
	ReleaseTime(releaseTime),
	AttackValue(attackValue),
	DecayValue(decayValue)
{

}



FMGenerator::~FMGenerator()
{
}

float FMGenerator::Envelope(long long time, bool release){
	long long currentTime = TimeHelper::GetCurrentTimeAsMilliseconds();
	if (!release){
		int timeSinceAttack = currentTime - time;
		if (timeSinceAttack <= AttackTime){
			return (AttackValue / AttackTime)*timeSinceAttack;
		} else if (timeSinceAttack <= AttackTime + DecayTime){
			return AttackValue - (((AttackValue - DecayValue) / DecayTime)*(timeSinceAttack - AttackTime));
		} else {
			return DecayValue;
		}
	} else {
		int timeSinceRelease = currentTime - time;
		return DecayValue - ((DecayValue / ReleaseTime)*(timeSinceRelease));
	}
	return 0.0;
}

float FMGenerator::process(double sampleRate, bool attack)
{
	if (attack && AttackTimeStamp == 0){
		AttackTimeStamp = TimeHelper::GetCurrentTimeAsMilliseconds();
		ReleaseTimeStamp = 0;
	}
	const float phaseDeltaCarrier    = (2 * M_PI * freqCarrier) / sampleRate;
	const float phaseDeltaModulation = (2 * M_PI * freqModulation) / sampleRate;

	float y = sin(phaseCarrier + modulationIndex * sin(phaseModulation));

	phaseCarrier = std::fmod(phaseCarrier + phaseDeltaCarrier, M_PI * 2.0f);
	phaseModulation = std::fmod(phaseModulation + phaseDeltaModulation, M_PI * 2.0f);
	
	if (!attack && ReleaseTimeStamp == 0){ //release = !attack
		ReleaseTimeStamp = TimeHelper::GetCurrentTimeAsMilliseconds();
	}

	long long time = attack  ? AttackTimeStamp : ReleaseTimeStamp; 

	float amplitude = Envelope(time, !attack); 

	if (amplitude <= 0.0){
		AttackTimeStamp = 0;
		amplitude = 0.0; ///amplitude can fall to a lower level than 0.0 after release, set to 0.0 to prevent that because negative values are also hearable
	}

	return amplitude*y;
}