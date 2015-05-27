#pragma once
#include "Envelope.h"

class DefaultEnvelope : public Envelope
{
public:
	virtual float DefaultEnvelope::GetAmplitude(bool release, long long currentTimeStamp);
	DefaultEnvelope::DefaultEnvelope(int attackTime, int decayTime, int releaseTime, float attackValue, float decayValue);
private:
	int AttackTime, DecayTime, ReleaseTime;
	float AttackValue, DecayValue;

};