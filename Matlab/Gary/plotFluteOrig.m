%% read audio file
[fluteOrig, fs] = audioread('fluteOrigG4.wav');
figure(1);
length = size(fluteOrig,1)/fs;


%% plot spectrogram
subplot(2,2,1)
myspectrogram(fluteOrig(:,1), fs, 1024, [18,1], @bartlett, [-160 0], false, 'jet', true);
title('Spektrogram Querflöte');
set(gca, 'XTick', 0:0.2:length);
set(gca, 'YTick', 0:2000:fs/2);
xlabel('Zeit (s)'); 
ylabel('Frequenz (Hz)');


%% plot waveform
subplot(2,2,2)
plot(fluteOrig(:,1));
title('Waveform Querflöte');
set(gca, 'XTick', 0:4410:length*fs);
set(gca, 'YTick', -1:0.2:1);
set(gca, 'YLim', [-1,1]);
set(gca, 'XLim', [0, length*fs]);
set(gca, 'XTickLabel', 0:4410/44100:length);
xlabel('Zeit (s)'); 
ylabel('Amplitude');


%% calculate FFT for spectrum
nf=2048; %number of point in DTFT
Y = fft(fluteOrig,nf);
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
sound(fluteOrig,fs);