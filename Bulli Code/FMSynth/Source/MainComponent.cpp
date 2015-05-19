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
#include <map>

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
class MainContentComponent   : public AudioAppComponent
{
public:
    //==============================================================================
    MainContentComponent()
		: amplitude(0.0f),
		sampleRate(0.0),
		expectedSamplesPerBlock(100)
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
		//FM1 = FMGenerator(3300, 8, 80, 200,400,800,1.0,0.9);
		FM1 = FMGenerator(440, 880, 2, 1000,1000,1000,1.0,0.5);
		
		auto var = AudioDeviceManager::AudioDeviceSetup();
		//deviceManager.getAudioDeviceSetup(var);
		//var.bufferSize = 100;
		//deviceManager.setAudioDeviceSetup(var,true);
		//deviceManager.addAudioCallback(juce::AudioIODeviceCallback
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

		const float centreY = getHeight() / 2.0f;
		Path wavePath;
		if (FM1.Attack){
			int span = 500;
			float bla = getWidth() / (span*1.0);
			//FM2 = FM1;
			//FM2.reset();
			FM2 = FMGenerator(FM1.freqCarrier, FM1.freqModulation, FM1.modulationIndex, 1, 1, 1, 1, 1);
			FM2.Attack = true;
			long long time = TimeHelper::GetCurrentTimeAsMilliseconds();
			for (int i = 0; i <= span; i += 1){
				//float fm = FM2.process(sampleRate, TimeHelper::GetCurrentTimeAsMilliseconds());
				float fm = FM2.process(sampleRate, i == 0 ? time : time+1);
				float value = (fm + 1)*getHeight() / 2;
				if (i == 0)
					wavePath.startNewSubPath(i*bla, value);
				else
					wavePath.lineTo(i*bla, value);
			}
		}
		else{
			wavePath.startNewSubPath(0, centreY);
			wavePath.lineTo(getWidth(), centreY);
		}
		g.setColour(Colours::grey);
		g.strokePath(wavePath, PathStrokeType(2.0f));
	}


	bool keyPressed(const KeyPress& key)
	{
		FM1.freqCarrier = toneMap[key.getKeyCode()]*2*octave;
		FM1.freqModulation = FM1.freqCarrier;
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
		} /*else if (KeyPress::isKeyCurrentlyDown('3')) {
			FM1.modulationIndex = 3*2;
		} else if (KeyPress::isKeyCurrentlyDown('4')) {
			FM1.modulationIndex = 4*4;
		} else if (KeyPress::isKeyCurrentlyDown('0')){
			FM1.modulationIndex = 0;
		}*/
		if (KeyPress::isKeyCurrentlyDown(KeyPress::upKey)){
			FM1.freqModulation *= 2;
		} else if (KeyPress::isKeyCurrentlyDown(KeyPress::downKey)){
			FM1.freqModulation /= 2;
		}

<<<<<<< HEAD
		if (KeyPress::isKeyCurrentlyDown('+'))	{
			octave *= 2;
		} else if (KeyPress::isKeyCurrentlyDown('-')) {
			octave /= 2;
		}
		
=======
		if (KeyPress::isKeyCurrentlyDown('A'))	{
			FM1.freqCarrier = 2*440;
			FM1.freqModulation = FM1.freqCarrier;
		}
		else if (KeyPress::isKeyCurrentlyDown('B')) {
			FM1.freqCarrier = 2*493.883;
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
>>>>>>> origin/master
		amplitude = 1.0;
		FM1.Attack = isKeyDown;
		repaint();
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

	std::vector<short> result;
	std::map<int, float> toneMap;
	float octave = 1;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (MainContentComponent)
};


// (This function is called by the app startup code to create our main component)
Component* createMainContentComponent()     { return new MainContentComponent(); }


#endif  // MAINCOMPONENT_H_INCLUDED
