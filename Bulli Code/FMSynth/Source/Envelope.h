#pragma once
class Envelope
{
public:
	virtual float Envelope::GetAmplitude(bool release, long long currentTimeStamp) = 0;
protected:
	long long AttackTimeStamp, ReleaseTimeStamp;
};