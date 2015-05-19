#pragma once
//#include "../JuceLibraryCode/juce_HighResolutionTimer.h"
#include "../JuceLibraryCode/JuceHeader.h"
#include <functional>

class RepaintTimer : public HighResolutionTimer
{
private:
	std::function<void()> function;
public:
	RepaintTimer::RepaintTimer();
	RepaintTimer(std::function<void()> func);
	~RepaintTimer();
	void RepaintTimer::hiResTimerCallback() override;
};

