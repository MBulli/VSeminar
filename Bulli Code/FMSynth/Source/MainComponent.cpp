/*
  ==============================================================================

    This file was auto-generated!

  ==============================================================================
*/

#ifndef MAINCOMPONENT_H_INCLUDED
#define MAINCOMPONENT_H_INCLUDED

#include "../JuceLibraryCode/JuceHeader.h"
#include "FMGenerator.h"

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
		: amplitude(0.5f),
		sampleRate(0.0),
		expectedSamplesPerBlock(0)
    {
        setSize (800, 600);

        // specify the number of input and output channels that we want to open
        setAudioChannels(1, 1);

		setWantsKeyboardFocus(true);

		FM1  = FMGenerator(440, 440, 1);
		FM2 = FMGenerator(440, 880, 1);
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

    void getNextAudioBlock (const AudioSourceChannelInfo& bufferToFill) override
    {
        // Your audio-processing code goes here!

        // For more details, see the help for AudioProcessor::getNextAudioBlock()
		bufferToFill.clearActiveBufferRegion();
		// const float originalPhase = phase;

		for (int chan = 0; chan < bufferToFill.buffer->getNumChannels(); ++chan)
		{
			// phase = originalPhase;

			float* const channelData = bufferToFill.buffer->getWritePointer(chan, bufferToFill.startSample);

			for (int i = 0; i < bufferToFill.numSamples; ++i)
			{
				channelData[i] = amplitude * FM1.process(sampleRate);

				// increment the phase step for the next sample
				//phaseDelta = (2.0f * float_Pi * frequency) / sampleRate;
				//phase = std::fmod(phase + phaseDelta, float_Pi * 2.0f);
			}
		}
    }

	bool keyPressed(const KeyPress& key)
	{
		return false;
	}

	bool keyStateChanged(bool isKeyDown) override
	{
		if (KeyPress::isKeyCurrentlyDown(KeyPress::escapeKey))
			JUCEApplication::quit();

		if (KeyPress::isKeyCurrentlyDown('1'))	{
			FM1.modulationIndex = 1;
		} else if (KeyPress::isKeyCurrentlyDown('2')) {
			FM1.modulationIndex = 2;
		} else if (KeyPress::isKeyCurrentlyDown('3')) {
			FM1.modulationIndex = 3;
		} else if (KeyPress::isKeyCurrentlyDown('4')) {
			FM1.modulationIndex = 4;
		}
		
		amplitude = isKeyDown ? 0.5f : 0.0f;

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
