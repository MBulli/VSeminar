%% variables
fs = 44100;         %sampling rate
length = 1.3;       %length of the tone
t = 0:1/fs:length;  %timecode for each sample

fc = 796.75;        %carrier frequency G5
fm = fc+2.5;        %modulation frequency
fm1 = fm;
fm2 = fm;
fm3 = fm;
fm4 = fm;
A = 0.25;           %amplitude
I1 = 0.3;            %modulation index
I2 = 0.5;            %modulation index
I3 = 1;            %modulation index
I4 = 1;            %modulation index

%% generate signal
fluteFM = A*sin(2*pi*fc*t + I1*sin(2*pi*fm1*t+I2*sin(2*pi*fm2*t+I3*sin(2*pi*fm3*t+I4*sin(2*pi*fm4*t)))));


%% create figure
figure(1);


%% plot spectrogram
% subplot(1,2,1)
% myspectrogram(fluteFM, fs, 1024, [18,1], @bartlett, [-160 0], false, 'jet', true);
% title('Spektrogram FM-Synthese');
% set(gca, 'XTick', 0:0.2:length);
% set(gca, 'YTick', 0:2000:fs/2);
% xlabel('Zeit (s)'); 
% ylabel('Frequenz (Hz)');

% 
% %% plot waveform
% subplot(2,2,2)
% plot(fluteFM);
% title('Waveform Querflöte');
% set(gca, 'XTick', 0:4410:length*fs);
% set(gca, 'YTick', -1:0.2:1);
% set(gca, 'YLim', [-1,1]);
% set(gca, 'XLim', [0, length*fs]);
% set(gca, 'XTickLabel', 0:4410/44100:length);
% xlabel('Zeit (s)'); 
% ylabel('Amplitde');


%% calculate FFT for spectrum
nf=2048; %number of point in DTFT
Y = fft(fluteFM,nf);
f = fs/2*linspace(0,1,nf/2+1);


%% plot spectrum 0-5000Hz
%subplot(1,2,2)
area(f,abs(Y(1:nf/2+1)));
title('Spektrum FM-Synthese 0 - 5000 Hz');
xlabel('Frequenz (Hz)'); 
ylabel('Amplitude');
set(gca, 'XLim', [0, 5000]);


%% plot spectrum 700-1800 Hz
% subplot(2,2,4)
% area(f,abs(Y(1:nf/2+1)));
% title('Spektrum Querflöte 700 - 1800 Hz');
% xlabel('Frequenz (Hz)'); 
% ylabel('Amplitude');
% set(gca, 'XLim', [700, 1800]);
% %set(gca, 'XTick', 700:100:1800);
% %set(gca, 'XTickLabel', 700/1000:0.1:1800/1000);
% 

%% play sound
%sound(fluteFM,fs);