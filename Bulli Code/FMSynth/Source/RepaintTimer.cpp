#include "RepaintTimer.h"


RepaintTimer::RepaintTimer(std::function<void()> func) : HighResolutionTimer()
{
	function = func;
}

RepaintTimer::RepaintTimer() : HighResolutionTimer()
{
}

RepaintTimer::~RepaintTimer()
{
	stopTimer();
}

void RepaintTimer::hiResTimerCallback() 
{
	function();
}