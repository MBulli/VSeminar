/*
  ==============================================================================

    This file was auto-generated!

  ==============================================================================
*/

#ifndef MAINCOMPONENT_H_INCLUDED
#define MAINCOMPONENT_H_INCLUDED

#include "../JuceLibraryCode/JuceHeader.h"
#include "FMGenerator.h"
#include <vector>
#include "Wave.h"
#include "TimeHelper.h"
#include "RepaintTimer.h"
#include <map>
#include <string>

#define ToneA 880.000
#define ToneB 987.766
#define ToneC 523.251
#define ToneD 587.330
#define ToneE 659.255
#define ToneF 698.456
#define ToneG 783.991

//==============================================================================
/*
    This component lives inside our window, and this is where you should put all
    your controls and content.
*/
void* TimerCallBack(void *obj);

class MainContentComponent   : public AudioAppComponent
{
public:
    //==============================================================================
	MainContentComponent()
		: amplitude(0.0f),
		sampleRate(0.0),
		expectedSamplesPerBlock(100),
		timer([this]()
			{
				MessageManager* manager = MessageManager::getInstance();
				if(!manager->hasStopMessageBeenSent())
					manager->callFunctionOnMessageThread(TimerCallBack, this);
			})
    {
        setSize (800, 600);

        // specify the number of input and output channels that we want to open
		// don't change - code assumes stereo
        setAudioChannels(2, 2);

		setWantsKeyboardFocus(true);
		toneMap['A'] = ToneA;
		toneMap['B'] = ToneB;
		toneMap['C'] = ToneC;
		toneMap['D'] = ToneD;
		toneMap['E'] = ToneE;
		toneMap['F'] = ToneF;
		toneMap['G'] = ToneG;
		FM1 = FMGenerator(ToneC, ToneC, 2, 50,50,50,1.0,0.5);
		timer.startTimer(50);


		auto var = AudioDeviceManager::AudioDeviceSetup();
    }



    ~MainContentComponent()
    {
		timer.stopTimer();
        shutdownAudio();
    }

    //=======================================================================
    void prepareToPlay (int samplesPerBlockExpected, double newSampleRate) override
    {
        // This function will be called when the audio device is started, or when
        // its settings (i.e. sample rate, block size, etc) are changed.

        // You can use this function to initialise any resources you might need,
        // but be careful - it will be called on the audio thread, not the GUI thread.

        // For more details, see the help for AudioProcessor::prepareToPlay()
		sampleRate = newSampleRate;
		expectedSamplesPerBlock = samplesPerBlockExpected;
    }
    
	void getNextAudioBlock (const AudioSourceChannelInfo& bufferToFill) override
    {
        // Your audio-processing code goes here!
		long long time = TimeHelper::GetCurrentTimeAsMilliseconds();
		
        // For more details, see the help for AudioProcessor::getNextAudioBlock()
		bufferToFill.clearActiveBufferRegion();

		float* const leftChannelData  = bufferToFill.buffer->getWritePointer(0, bufferToFill.startSample);
		float* const rightChannelData = bufferToFill.buffer->getWritePointer(1, bufferToFill.startSample);
		for (int i = 0; i < bufferToFill.numSamples; ++i)
		{
			const float y = FM1.process(sampleRate, time+i*1000/sampleRate);
			leftChannelData[i]  = y;
			rightChannelData[i] = y;
			result.push_back(static_cast<short>(y * SHRT_MAX));
		}
    }
	
	void paint(Graphics& g) override
	{
		// (Our component is opaque, so we must completely fill the background with a solid colour)
		g.fillAll(Colours::black);
		g.setColour(Colours::white);
		float fontHeight = g.getCurrentFont().getHeight();

		String str = "FM Carrier frequency: " + std::to_string(FM1.freqCarrier);
		g.drawSingleLineText(str, 0, fontHeight);
		str = "FM Modulation frequency: " + std::to_string(FM1.freqModulation);
		g.drawSingleLineText(str, 0, fontHeight * 2);
		str = "FM Modulation Index: " + std::to_string(FM1.modulationIndex);
		g.drawSingleLineText(str, 0, fontHeight * 3);

		const float centreY = getHeight() / 2.0f;
		Path wavePath;
		int span = getWidth();
		float bla = getWidth() / (span*1.0);
		FM2 = FM1;
		FM2.Attack = FM1.Attack;
		FM2.reset();

		for (int i = 0; i <= span; i += 1){
			float fm = FM2.process(sampleRate, TimeHelper::GetCurrentTimeAsMilliseconds());
			float value = (fm + 1)*getHeight() / 2;
			if (i == 0)
				wavePath.startNewSubPath(i*bla, value);
			else
				wavePath.lineTo(i*bla, value);
		}

		g.strokePath(wavePath, PathStrokeType(2.0f));
	}


	bool keyPressed(const KeyPress& key) override
	{
		if (key.getKeyCode() == 'A'
			|| key.getKeyCode() == 'B'
			|| key.getKeyCode() == 'C'
			|| key.getKeyCode() == 'D'
			|| key.getKeyCode() == 'E'
			|| key.getKeyCode() == 'F'
			|| key.getKeyCode() == 'G'
			)
		{
			FM1.freqCarrier = toneMap[key.getKeyCode()] * 2 * octave;
			FM1.freqModulation = FM1.freqCarrier;
		}

		return false;
	}

	bool keyStateChanged(bool isKeyDown) override
	{
		if (KeyPress::isKeyCurrentlyDown(KeyPress::escapeKey)){
			JUCEApplication::quit();
		}

		if (KeyPress::isKeyCurrentlyDown('S'))	{
			Wave::WriteWave(result, 1, sampleRate);
		}
		if (KeyPress::isKeyCurrentlyDown('1'))	{
			FM1.modulationIndex -= 1;
		} else if (KeyPress::isKeyCurrentlyDown('2')) {
			FM1.modulationIndex += 1;
		} 

		if (KeyPress::isKeyCurrentlyDown(KeyPress::upKey)){
			FM1.freqModulation *= 2;
			std::cout << FM1.freqModulation << std::endl;
		} else if (KeyPress::isKeyCurrentlyDown(KeyPress::downKey)){
			FM1.freqModulation /= 2;
			std::cout << FM1.freqModulation << std::endl;
		}

		if (KeyPress::isKeyCurrentlyDown('+'))	{
			octave *= 2;
			FM1.freqCarrier *= 2;
			FM1.freqModulation = FM1.freqCarrier;
		} else if (KeyPress::isKeyCurrentlyDown('-')) {
			octave /= 2;
			FM1.freqCarrier /= 2;
			FM1.freqModulation = FM1.freqCarrier;
		}

		amplitude = 1.0;
		if (KeyPress::isKeyCurrentlyDown('C')
			|| KeyPress::isKeyCurrentlyDown('D')
			|| KeyPress::isKeyCurrentlyDown('E')
			|| KeyPress::isKeyCurrentlyDown('F')
			|| KeyPress::isKeyCurrentlyDown('G')
			|| KeyPress::isKeyCurrentlyDown('B')
			|| KeyPress::isKeyCurrentlyDown('A')
			)
			FM1.Attack = true;
		else
			FM1.Attack = false;
		
		//repaint();
		return true;
	}

    void releaseResources() override
    {
        // This will be called when the audio device stops, or when it is being
        // restarted due to a setting change.

        // For more details, see the help for AudioProcessor::releaseResources()
    }

    //=======================================================================
    //void paint (Graphics& g) override
    //{
    //    // (Our component is opaque, so we must completely fill the background with a solid colour)
    //    g.fillAll (Colours::black);


    //    // You can add your drawing code here!
    //}

    void resized() override
    {
        // This is called when the MainContentComponent is resized.
        // If you add any child components, this is where you should
        // update their positions.
    }

private:
    //==============================================================================

    // Your private member variables go here...
	float amplitude;

	double sampleRate;
	int expectedSamplesPerBlock;

	FMGenerator FM1;
	FMGenerator FM2;

	RepaintTimer timer;

	std::vector<short> result;
	std::map<int, float> toneMap;
	float octave = 1;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (MainContentComponent)
};

void* TimerCallBack(void *obj)
{
	static_cast<MainContentComponent*>(obj)->repaint();
	return nullptr;
}
// (This function is called by the app startup code to create our main component)
Component* createMainContentComponent()     { return new MainContentComponent(); }


#endif  // MAINCOMPONENT_H_INCLUDED
