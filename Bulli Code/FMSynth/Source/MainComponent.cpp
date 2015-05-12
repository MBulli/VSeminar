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

//==============================================================================
/*
    This component lives inside our window, and this is where you should put all
    your controls and content.
*/
class MainContentComponent   : public AudioAppComponent
{
public:
    //==============================================================================
    MainContentComponent()
		: amplitude(0.0f),
		sampleRate(0.0),
		expectedSamplesPerBlock(0)
    {
        setSize (800, 600);

        // specify the number of input and output channels that we want to open
		// don't change - code assumes stereo
        setAudioChannels(2, 2);

		setWantsKeyboardFocus(true);

		FM1 = FMGenerator(200, 400, 2);
		FM2 = FMGenerator(440, 880, 5);
    }

    ~MainContentComponent()
    {
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
	bool attack = false;
	std::vector<short> result = std::vector<short>();
    void getNextAudioBlock (const AudioSourceChannelInfo& bufferToFill) override
    {
        // Your audio-processing code goes here!

        // For more details, see the help for AudioProcessor::getNextAudioBlock()
		bufferToFill.clearActiveBufferRegion();

		float* const leftChannelData  = bufferToFill.buffer->getWritePointer(0, bufferToFill.startSample);
		float* const rightChannelData = bufferToFill.buffer->getWritePointer(1, bufferToFill.startSample);

		for (int i = 0; i < bufferToFill.numSamples; ++i)
		{
			const float y = amplitude * FM1.process(sampleRate, attack);
			leftChannelData[i]  = y;
			rightChannelData[i] = y;
			result.push_back(static_cast<short>(y * SHRT_MAX));
			//result.push_back(static_cast<short>(y * SHRT_MAX));
		}
    }
	
	bool keyPressed(const KeyPress& key)
	{
		return false;
	}
	bool keyStateChanged(bool isKeyDown) override
	{
		if (KeyPress::isKeyCurrentlyDown(KeyPress::escapeKey)){
			Wave::WriteWave(result, 1, sampleRate);
			JUCEApplication::quit();
		}

		if (KeyPress::isKeyCurrentlyDown('1'))	{
			FM1.modulationIndex = 1;
		} else if (KeyPress::isKeyCurrentlyDown('2')) {
			FM1.modulationIndex = 2;
		} else if (KeyPress::isKeyCurrentlyDown('3')) {
			FM1.modulationIndex = 3;
		} else if (KeyPress::isKeyCurrentlyDown('4')) {
			FM1.modulationIndex = 4;
		}
		if (KeyPress::isKeyCurrentlyDown('A'))	{
			FM1.freqCarrier = 440;
			FM1.freqModulation = FM1.freqCarrier;
		}
		else if (KeyPress::isKeyCurrentlyDown('B')) {
			FM1.freqCarrier = 493.883;
			FM1.freqModulation = FM1.freqCarrier;
		}
		else if (KeyPress::isKeyCurrentlyDown('C')) {
			FM1.freqCarrier = 523.251;
			FM1.freqModulation = FM1.freqCarrier;
		}
		else if (KeyPress::isKeyCurrentlyDown('D')) {
			FM1.freqCarrier = 587.330;
			FM1.freqModulation = FM1.freqCarrier;
		}
		else if (KeyPress::isKeyCurrentlyDown('E')) {
			FM1.freqCarrier = 659.255;
			FM1.freqModulation = FM1.freqCarrier;
		}
		else if (KeyPress::isKeyCurrentlyDown('F')) {
			FM1.freqCarrier = 698.456;
			FM1.freqModulation = FM1.freqCarrier;
		}
		else if (KeyPress::isKeyCurrentlyDown('G')) {
			FM1.freqCarrier = 783.991;
			FM1.freqModulation = FM1.freqCarrier;
		}
		//amplitude = isKeyDown ? 0.5f : 0.0f;
		//amplitude = isKeyDown ? Envelope(AnschlagZeit, 500, 1.0, 500, 0.75, 2000, 500) : 0.0;
		amplitude = 1.0;
		attack = isKeyDown;
		return true;
	}

    void releaseResources() override
    {
        // This will be called when the audio device stops, or when it is being
        // restarted due to a setting change.

        // For more details, see the help for AudioProcessor::releaseResources()
    }

    //=======================================================================
    void paint (Graphics& g) override
    {
        // (Our component is opaque, so we must completely fill the background with a solid colour)
        g.fillAll (Colours::black);


        // You can add your drawing code here!
    }

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

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (MainContentComponent)
};


// (This function is called by the app startup code to create our main component)
Component* createMainContentComponent()     { return new MainContentComponent(); }


#endif  // MAINCOMPONENT_H_INCLUDED
