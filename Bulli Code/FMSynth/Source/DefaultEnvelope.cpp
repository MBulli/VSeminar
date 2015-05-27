#pragma once

#include "DefaultEnvelope.h"
DefaultEnvelope::DefaultEnvelope(int attackTime, int decayTime, int releaseTime, float attackValue, float decayValue)
	: AttackTime(attackTime),
	DecayTime(decayTime),
	ReleaseTime(releaseTime),
	AttackValue(attackValue),
	DecayValue(decayValue)
{
	AttackTimeStamp = 0;
	ReleaseTimeStamp = 0;
}

float DefaultEnvelope::GetAmplitude(bool release, long long currentTimeStamp)
{
	float amplitude = 0;
	if (!release && AttackTimeStamp == 0){
		AttackTimeStamp = currentTimeStamp;
		ReleaseTimeStamp = 0;
	}
	if (!release || currentTimeStamp - AttackTimeStamp <= (AttackTime + DecayTime)){
		if (AttackTimeStamp == 0){
			return 0;
		}
		ReleaseTimeStamp = currentTimeStamp;
		int timeSinceAttack = currentTimeStamp - AttackTimeStamp;
		if (timeSinceAttack <= AttackTime){
			amplitude = (AttackValue / AttackTime)*timeSinceAttack;
		}
		else if (timeSinceAttack <= AttackTime + DecayTime){
			amplitude = AttackValue - (((AttackValue - DecayValue) / DecayTime)*(timeSinceAttack - AttackTime));
		}
		else {
			amplitude = DecayValue;
		}
	}
	else {
		if (ReleaseTimeStamp == 0){
			return 0;
		}
		int timeSinceRelease = currentTimeStamp - ReleaseTimeStamp;
		amplitude = DecayValue - ((DecayValue / ReleaseTime)*(timeSinceRelease));
	}
	if (amplitude < 0.0){
		AttackTimeStamp = 0;
		amplitude = 0.0;
	}
	return amplitude;
}
