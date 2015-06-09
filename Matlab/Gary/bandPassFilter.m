fc = 796.75;        %carrier frequency G5
fs = 44100;         %sampling rate
fm = fc + 2.5;        %modulation frequency
length = 1.3;       %length of the tone
t = 0:1/fs:length;  %timecode for each sample

feedbackNoise = zeros(1,size(t,2));
feedbackNoise(1) = sin(2*pi*fc*0);
for i = 2:size(t,2);
    feedbackNoise(i) = sin(2*pi*fc*t(i)+1000*sin(feedbackNoise(i-1)));
end

% A(t>= 0 & t <= 0.07) = linspace(0.3,0.3,size(A(t>= 0 & t <= 0.07),2));
% A(t> 0.07 & t <= 0.1) = linspace(0.3,0.2,size(A(t> 0.07 & t <= 0.1),2));
% A(t> 0.1 & t <= 1.2) = linspace(0.2,0.2,size(A(t> 0.1 & t <= 1.2),2));
% A(t> 1.2 & t <= 1.3) = linspace(0.2,0.0,size(A(t> 1.2 & t <= 1.3),2));
HighfeedbackNoise = filter(noiseFilter24BandPassHigh, feedbackNoise);

myspectrogram(HighfeedbackNoise, fs, 1024, [18,1], @bartlett, [-160 0], false, 'jet', true);
title('Spektrogram FM-Synthese');
set(gca, 'XTick', 0:0.2:length);
set(gca, 'YTick', 0:2000:fs/2);
xlabel('Zeit (s)'); 
ylabel('Frequenz (Hz)');