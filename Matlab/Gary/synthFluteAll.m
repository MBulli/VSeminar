%% Synth Flute
fs = 44100;         %sampling rate
length = 1.3;       %length of the tone
t = 0:1/fs:length;  %timecode for each sample

A = 0.22;
fc = 796.75;        %carrier frequency G5
fm = fc;        %modulation frequency
I = 2;            %modulation index

% generate signal
fluteFM = A.*sin(2*pi*fc*t + I*sin(2*pi*fm*t));

%% Synth Flute + 4 Mod
fm = fc;        %modulation frequency
fm1 = fm;
fm2 = fm;
fm3 = fm;
fm4 = fm;
I1 = 0.3;            %modulation index
I2 = 0.5;            %modulation index
I3 = 1;            %modulation index
I4 = 1;            %modulation index

% generate signal
fluteFM = A.*sin(2*pi*fc*t + I1.*sin(2*pi*fm1*t + I2*sin(2*pi*fm2*t + I3*sin(2*pi*fm3*t + I4*sin(2*pi*fm4*t)))));

%% Synth Flute + 4 Mod + Vibrato
fm = fc+2.5;        %modulation frequency
fm1 = fm;
fm2 = fm;
fm3 = fm;
fm4 = fm;

% generate signal
fluteFM = A.*sin(2*pi*fc*t + I1.*sin(2*pi*fm1*t + I2*sin(2*pi*fm2*t + I3*sin(2*pi*fm3*t + I4*sin(2*pi*fm4*t)))));

%% Synth Flute + 4 Mod + Vibrato + ADSR
A = adsrComplex(t);

% generate signal
fluteFM = A.*sin(2*pi*fc*t + I1.*sin(2*pi*fm1*t + I2*sin(2*pi*fm2*t + I3*sin(2*pi*fm3*t + I4*sin(2*pi*fm4*t)))));

%% Synth Flute + 4 Mod + Vibrato + ADSR + VARI
I1 = A;            %modulation index

% generate signal
fluteFM = A.*sin(2*pi*fc*t + I1.*sin(2*pi*fm1*t + I2*sin(2*pi*fm2*t + I3*sin(2*pi*fm3*t + I4*sin(2*pi*fm4*t)))));

%% Synth Flute + 4 Mod + Vibrato + ADSR + VARI + Noise
% noise
feedbackNoise = zeros(1,size(t,2));
feedbackNoise(1) = sin(2*pi*fc*0);
for i = 2:size(t,2);
    feedbackNoise(i) = sin(2*pi*fc*t(i)+1000*sin(feedbackNoise(i-1)));
end
% global noise
fluteFM = fluteFM + feedbackNoise*0.0004;

% envelope for noise
A(t>= 0 & t <= 0.07) = linspace(0.3,0.3,size(A(t>= 0 & t <= 0.07),2));
A(t> 0.07 & t <= 0.1) = linspace(0.3,0.2,size(A(t> 0.07 & t <= 0.1),2));
A(t> 0.1 & t <= 1.2) = linspace(0.2,0.2,size(A(t> 0.1 & t <= 1.2),2));
A(t> 1.2 & t <= 1.3) = linspace(0.2,0.0,size(A(t> 1.2 & t <= 1.3),2));

HighfeedbackNoise = filter(noiseFilter24BandPassHigh, feedbackNoise);
fluteFM = fluteFM+(HighfeedbackNoise.*A);

%% Synth Flute + 4 Mod + Vibrato + ADSR + VARI + Noise + Blow
% envelope for discrete blow sound
A(t >= 0.0 & t <= 0.01) = 1;
A(t > 0.01 & t <= 0.05) = linspace(1,0,size(t(t> 0.01 & t <= 0.05),2));
A(t > 0.05 & t <= 1.3) = 0;

blow = 0.01*A.*sin(2*pi*904.3*t);
blow2 = 0.01*A.*sin(2*pi*1182*t);
fluteFM = fluteFM+blow+blow2;

%% create figure
figure(1);


%% plot spectrogram
subplot(2,2,1)
myspectrogram(fluteFM, fs, 1024, [18,1], @bartlett, [-160 0], false, 'jet', true);
title('Spektrogram FM-Synthese');
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
nf=2^12; %number of point in DTFT
Y = fft(fluteFM,nf);
f = fs/2*linspace(0,1,nf/2+1);
absY = abs(Y(1:nf/2+1))/(nf/2);
YProz = absY*100;
%dbY = 20*log10(absY/(nf/2));


%% plot spectrum 0-5000Hz
subplot(2,2,3)
area(f, YProz);
title('Spektrum FM-Synthese 0 - 5000 Hz');
xlabel('Frequenz (Hz)'); 
ylabel('Amplitude (%)');
set(gca, 'XLim', [0, 5000]);


%% plot spectrum 700-1800 Hz
subplot(2,2,4)
area(f,YProz);
title('Spektrum Querflöte 700 - 1800 Hz');
xlabel('Frequenz (Hz)'); 
ylabel('Amplitude (%)');
set(gca, 'XLim', [700, 1800]);

%set(gca, 'XTick', 700:100:1800);
%set(gca, 'XTickLabel', 700/1000:0.1:1800/1000);


%% play sound
sound(fluteFM,fs);