#include "TimeHelper.h"
#include <chrono>
using namespace std::chrono;
long long TimeHelper::GetCurrentTimeAsMilliseconds(){
	auto time = system_clock::now(); // get the current time

	auto since_epoch = time.time_since_epoch(); // get the duration since epoch

	// I don't know what system_clock returns
	// I think it's uint64_t nanoseconds since epoch
	// Either way this duration_cast will do the right thing
	auto millis = duration_cast<milliseconds>(since_epoch);

	long long now = millis.count(); // just like java (new Date()).getTime();
	return now;
}