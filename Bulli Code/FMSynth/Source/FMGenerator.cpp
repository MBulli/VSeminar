#include "FMGenerator.h"

#define _USE_MATH_DEFINES

#include <cmath>
#include "TimeHelper.h"
#include "Envelope.h"

FMGenerator::FMGenerator(float carrier, float modulation, float modIndex, Envelope* env)
	: phaseCarrier(0),
	phaseModulation(0),
	freqCarrier(carrier),
	freqModulation(modulation),
	modulationIndex(modIndex),
	envelope(env),
	Attack(false)
{
}

FMGenerator::~FMGenerator()
{
}


float FMGenerator::process(double sampleRate, long long currentTime)
{
	const float phaseDeltaCarrier    = (2 * M_PI * freqCarrier) / sampleRate;
	const float phaseDeltaModulation = (2 * M_PI * freqModulation) / sampleRate;

	float y = sin(phaseCarrier + modulationIndex * sin(phaseModulation));

	phaseCarrier = std::fmod(phaseCarrier + phaseDeltaCarrier, M_PI * 2.0f);
	phaseModulation = std::fmod(phaseModulation + phaseDeltaModulation, M_PI * 2.0f);

	float amplitude = envelope->GetAmplitude(!Attack, currentTime); 

	if (amplitude < 0.0){
		amplitude = 0.0; ///amplitude can fall to a lower level than 0.0 after release, set to 0.0 to prevent that because negative values are also hearable
	}

	return amplitude*y;
}

void FMGenerator::reset()
{
	phaseCarrier = 0;
	phaseModulation = 0;
}