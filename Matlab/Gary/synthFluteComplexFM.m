%% variables
fc = 783.991;       %carrier frequency G4
fs = 44100;         %sampling rate
fm = fc+1.5;        %modulation frequency
length = 1.3;       %length of the tone
t = 0:1/fs:length;  %timecode for each sample

%A = adsrLin(t,[0,0],[0,0.05],[0.05,0.1],[0.1,1.18],[1.18,1.3],[0,0],[0,0.3],[0.3,0.25],[0.25,0.23],[0.33,0.0]);

%% generate ADSR-Envelope
attackTime = [0,0.055];
decayTime = [0.055,0.15];
sustainTime = [0.15,1.18];
releaseTime = [1.18,1.3];
attackValue = [0,0.3];
decayValue = [0.3,0.25];
sustainValue = [0.25,0.23];
releaseValue = [0.28,0.0];
AttackSize = size(t(t>=attackTime(1) & t < attackTime(2)),2);
DecaySize = size(t(t>=decayTime(1) & t < decayTime(2)),2);
SustainSize = size(t(t>=sustainTime(1) & t < 0.6),2);
ReleaseSize = size(t(t>=releaseTime(1) & t < releaseTime(2)),2);

SustainTimes1 = t(t>=sustainTime(1) & t < 0.6);
SustainTimes2 = t(t>=0.6 & t < 0.85);
SustainTimes3 = t(t>=0.85 & t < sustainTime(2));
AttackTimes = t(t>=attackTime(1) & t < attackTime(2));
ReleaseTimes = t(t>=releaseTime(1) & t <= releaseTime(2));

Attack = sin(2*pi*4.5*AttackTimes)*attackValue(2);
Decay = linspace(decayValue(1), decayValue(2), DecaySize); 
Sustain1 = linspace(sustainValue(1), sustainValue(2), SustainSize);
Sustain2 = 0.03*sin(2*pi*4*SustainTimes2-1/2*pi+1/8*pi)+sustainValue(2)-0.025;
Sustain3 = 0.02*sin(2*pi*4*SustainTimes3-pi-1/2*pi+1/4*pi)+sustainValue(2)+0.026;
Release = ((sin(2*pi*3.5*ReleaseTimes+1/2*pi-1/4*pi)+1)/2)*releaseValue(1)-0.023;

A = [Attack,Decay,Sustain1,Sustain2,Sustain3,Release];


%% modulation index various with amplitude of the signal.
I = A*1.8;


%% generate signal
fluteFM = A.*sin(2*pi*fc*t + I.*sin(2*pi*fc*t+0.5*sin(2*pi*fc*t+1*sin(2*pi*fc*t+1*sin(2*pi*fc*t)))));


%% add global noise 
noise1 = wgn(1,size(fluteFM,2),0);
fluteFM = fluteFM + noise1*0.0001;

% add random noise with filter below 10k Hz 
noise2 = 1.*randn(size(fluteFM));
noise2 = filter(noisefilter,noise2);
fluteFM = fluteFM + noise2.*A*0.015;

% add white noise above 10k Hz for better blow sound
noise3 = wgn(1,size(fluteFM,2),0);
noise3 = filter(noisefilterHigh, noise3);
fluteFM = fluteFM + noise3.*A*0.01;

% add white noise around the carrier
noise4 = wgn(1,size(fluteFM,2),0);
noise4 = filter(noiseFilterLowPass, noise4);
fluteFM = fluteFM + noise4.*A*0.02;

% add white noise at the top 17500-22000 Hz
noise4 = wgn(1,size(fluteFM,2),0);
noise4 = filter(noiseFilterTop, noise4);
fluteFM = fluteFM + noise4.*A*0.0005;


%% create figure
figure(1);


%% plot spectrogram
subplot(2,2,1)
myspectrogram(fluteFM, fs, 1024, [18,1], @bartlett, [-160 0], false, 'jet', true);
title('Spektrogram Querflöte');
set(gca, 'XTick', 0:0.2:length);
set(gca, 'YTick', 0:2000:fs/2);
xlabel('Zeit (s)'); 
ylabel('Frequenz (Hz)');


%% plot waveform
subplot(2,2,2)
plot(fluteFM);
title('Waveform Querflöte');
set(gca, 'XTick', 0:4410:length*fs);
set(gca, 'YTick', -1:0.2:1);
set(gca, 'YLim', [-1,1]);
set(gca, 'XLim', [0, length*fs]);
set(gca, 'XTickLabel', 0:4410/44100:length);
xlabel('Zeit (s)'); 
ylabel('Amplitde');


%% calculate FFT for spectrum
nf=2048; %number of point in DTFT
Y = fft(fluteFM,nf);
f = fs/2*linspace(0,1,nf/2+1);


%% plot spectrum 0-5000Hz
subplot(2,2,3)
area(f,abs(Y(1:nf/2+1)));
title('Spektrum Querflöte 0 - 5000 Hz');
xlabel('Frequenz (Hz)'); 
ylabel('Amplitude');
set(gca, 'XLim', [0, 5000]);


%% plot spectrum 700-1800 Hz
subplot(2,2,4)
area(f,abs(Y(1:nf/2+1)));
title('Spektrum Querflöte 700 - 1800 Hz');
xlabel('Frequenz (Hz)'); 
ylabel('Amplitude');
set(gca, 'XLim', [700, 1800]);
%set(gca, 'XTick', 700:100:1800);
%set(gca, 'XTickLabel', 700/1000:0.1:1800/1000);


%% play sound
sound(fluteFM,fs);