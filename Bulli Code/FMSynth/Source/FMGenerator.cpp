#include "FMGenerator.h"

#define _USE_MATH_DEFINES

#include <cmath>


FMGenerator::FMGenerator()
	: phaseCarrier(0),
	phaseModulation(0),
	freqCarrier(440),
	freqModulation(440),
	modulationIndex(1.0)
{
}

FMGenerator::FMGenerator(float carrier, float modulation, float modIndex)
	: phaseCarrier(0),
	phaseModulation(0),
	freqCarrier(carrier),
	freqModulation(modulation),
	modulationIndex(modIndex)
{

}


FMGenerator::~FMGenerator()
{
}

float FMGenerator::process(double sampleRate)
{
	const float phaseDeltaCarrier    = (2 * M_PI * freqCarrier) / sampleRate;
	const float phaseDeltaModulation = (2 * M_PI * freqModulation) / sampleRate;

	float y = sin(phaseCarrier + modulationIndex * sin(phaseModulation));

	phaseCarrier = std::fmod(phaseCarrier + phaseDeltaCarrier, M_PI * 2.0f);
	phaseModulation = std::fmod(phaseModulation + phaseDeltaModulation, M_PI * 2.0f);

	return y;
}