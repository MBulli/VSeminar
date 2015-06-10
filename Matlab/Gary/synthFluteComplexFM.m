%% variables
fc = 796.75;        %carrier frequency G5
fs = 44100;         %sampling rate
fm = fc + 2.5;        %modulation frequency
length = 1.3;       %length of the tone
t = 0:1/fs:length;  %timecode for each sample


%% generate ADSR-Envelope
A = adsrComplex(t);


%% modulation index various with amplitude of the signal.
%I = A;
I = 0.3;
I2 = 0.5;
I3 = 1;
I4 = 1.5;


%% generate signal
%fluteFM = A.*sin(2*pi*fc*t - I.*cos(2*pi*fm*t - I2*cos(2*pi*fm*t - I3*cos(2*pi*fm*t - I4*cos(2*pi*fm*t)))));
fluteFM = A.*sin(2*pi*fc*t + I.*sin(2*pi*fm*t + I2*sin(2*pi*fm*t + I3*sin(2*pi*fm*t + I4*sin(2*pi*fm*t)))));

%fluteFM = 0.25*sin(2*pi*fc*t + I.*sin(2*pi*fm*t+I2*sin(2*pi*fm*t+I3*sin(2*pi*fm*t+I4*sin(2*pi*fm*t)))));
%fluteFM = 0.25*sin(2*pi*fc*t + I.*sin(2*pi*fm*t));


%% add global noise 
noise1 = wgn(1,size(fluteFM,2),0);
fluteFM = fluteFM + noise1*0.0001;

%% old noises
% add white noise at the top 17500-22000 Hz
% noise4 = wgn(1,size(fluteFM,2),0);
% noise4 = filter(noiseFilterTop, noise4);
% fluteFM = fluteFM + noise4.*A*0.0005;

% add random noise with filter below 10k Hz 
% noise2 = 1.*randn(size(fluteFM));
% noise2 = filter(noisefilter,noise2);
% fluteFM = fluteFM + noise2.*A*0.005;

% % add white noise above 10k Hz for better blow sound
% noise3 = wgn(1,size(fluteFM,2),0);
% noise3 = filter(noisefilterHigh, noise3);
% fluteFM = fluteFM + noise3.*A*0.005;


%% add feedback noise
feedbackNoise = zeros(1,size(t,2));
feedbackNoise(1) = sin(2*pi*fc*0);
for i = 2:size(t,2);
    feedbackNoise(i) = sin(2*pi*fc*t(i)+1000*sin(feedbackNoise(i-1)));
end

A(t>= 0 & t <= 0.07) = linspace(0.3,0.3,size(A(t>= 0 & t <= 0.07),2));
A(t> 0.07 & t <= 0.1) = linspace(0.3,0.2,size(A(t> 0.07 & t <= 0.1),2));
A(t> 0.1 & t <= 1.2) = linspace(0.2,0.2,size(A(t> 0.1 & t <= 1.2),2));
A(t> 1.2 & t <= 1.3) = linspace(0.2,0.0,size(A(t> 1.2 & t <= 1.3),2));
HighfeedbackNoise = filter(noiseFilter24BandPassHigh, feedbackNoise);
fluteFM = fluteFM+(HighfeedbackNoise.*A*0.5);


% FilteredfeedbackNoise = filter(noiseFilter8BandPass, feedbackNoise);
% fluteFMwithoutNoise = fluteFM;
% fluteFM2 = fluteFM+(FilteredfeedbackNoise.*A*0.3);



%% create figure
figure(3);
[fluteOrig,fs2] = audioread('fluteOrigG4.wav');
fluteFM = [fluteFM, zeros(1,11025), fluteOrig(:,1)'];


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
nf=2048; %number of point in DTFT
Y = fft(fluteFM,nf);
f = fs/2*linspace(0,1,nf/2+1);


%% plot spectrum 0-5000Hz
subplot(2,2,3)
area(f,abs(Y(1:nf/2+1)));
title('Spektrum FM-Synthese 0 - 5000 Hz');
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
%audiowrite('flutesin.wav',fluteFM,44100);