#include "DoubleFMGenerator.h"

#define _USE_MATH_DEFINES

#include <cmath>
#include "TimeHelper.h"
#include "Envelope.h"

DoubleFMGenerator::DoubleFMGenerator(float carrier, float modulation1, float modIndex1, float modulation2, float modIndex2, Envelope* env)
	: phaseCarrier(0),
	phaseModulation(0),
	freqCarrier(carrier),
	freqModulation(modulation1),
	modulationIndex(modIndex1),
	freqModulation2(modulation2),
	modulationIndex2(modIndex2),
	envelope(env),
	Attack(false)
{
}

DoubleFMGenerator::~DoubleFMGenerator()
{
}


float DoubleFMGenerator::process(double sampleRate, long long currentTime)
{
	const float phaseDeltaCarrier    = (2 * M_PI * freqCarrier) / sampleRate;
	const float phaseDeltaModulation = (2 * M_PI * freqModulation) / sampleRate;
	const float phaseDeltaModulation2 = (2 * M_PI * freqModulation2) / sampleRate;

	float y = sin(phaseCarrier + modulationIndex * sin(phaseModulation) + modulationIndex2*sin(phaseDeltaModulation2));

	phaseCarrier = std::fmod(phaseCarrier + phaseDeltaCarrier, M_PI * 2.0f);
	phaseModulation = std::fmod(phaseModulation + phaseDeltaModulation, M_PI * 2.0f);
	phaseModulation2 = std::fmod(phaseModulation2 + phaseDeltaModulation2, M_PI * 2.0f);

	float amplitude = envelope->GetAmplitude(!Attack, currentTime); 

	if (amplitude < 0.0){
		amplitude = 0.0; ///amplitude can fall to a lower level than 0.0 after release, set to 0.0 to prevent that because negative values are also hearable
	}

	return amplitude*y;
}

void DoubleFMGenerator::reset()
{
	phaseCarrier = 0;
	phaseModulation = 0;
}