#include "FMGenerator.h"

#define _USE_MATH_DEFINES

#include <cmath>
#include "TimeHelper.h"

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
	DecayValue(decayValue),
	Attack(false),
	AttackTimeStamp(0),
	ReleaseTimeStamp(0)
{
}

FMGenerator::~FMGenerator()
{
}

float FMGenerator::Envelope(bool release, long long currentTime){
	//long long currentTime = TimeHelper::GetCurrentTimeAsMilliseconds();
	if (!release || currentTime - AttackTimeStamp <= (AttackTime + DecayTime)){
		ReleaseTimeStamp = currentTime;
		int timeSinceAttack = currentTime - AttackTimeStamp;
		if (timeSinceAttack <= AttackTime){
			return (AttackValue / AttackTime)*timeSinceAttack;
		} else if (timeSinceAttack <= AttackTime + DecayTime){
			return AttackValue - (((AttackValue - DecayValue) / DecayTime)*(timeSinceAttack - AttackTime));
		} else {
			return DecayValue;
		}
	} else {
		int timeSinceRelease = currentTime - ReleaseTimeStamp;
		return DecayValue - ((DecayValue / ReleaseTime)*(timeSinceRelease));
	}
	return 0.0;
}

float FMGenerator::process(double sampleRate, long long currentTime)
{
	if (Attack && AttackTimeStamp == 0){
		AttackTimeStamp = currentTime;
		ReleaseTimeStamp = 0;
	}
	const float phaseDeltaCarrier    = (2 * M_PI * freqCarrier) / sampleRate;
	const float phaseDeltaModulation = (2 * M_PI * freqModulation) / sampleRate;

	float y = sin(phaseCarrier + modulationIndex * sin(phaseModulation));

	phaseCarrier = std::fmod(phaseCarrier + phaseDeltaCarrier, M_PI * 2.0f);
	phaseModulation = std::fmod(phaseModulation + phaseDeltaModulation, M_PI * 2.0f);

	float amplitude = Envelope(!Attack, currentTime); 

	if (amplitude < 0.0){
		AttackTimeStamp = 0;
		amplitude = 0.0; ///amplitude can fall to a lower level than 0.0 after release, set to 0.0 to prevent that because negative values are also hearable
	}

	return amplitude*y;
}

void FMGenerator::reset(){
	phaseCarrier = 0;
	phaseModulation = 0;
}