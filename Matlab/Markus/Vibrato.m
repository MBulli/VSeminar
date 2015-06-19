%% Synth Flute
fs = 44100;         %sampling rate
duration = 5;       %length of the tone
t = 0:1/fs:duration;%timecode for each sample

A = 0.5;
fc = 440;        %carrier frequency C4
fm = 2;        %modulation frequency
I = 200;            %modulation index

% generate signal
fluteFM = A.*sin(2*pi*fc*t + I*sin(2*pi*fm*t));



% Defaults for this blog post
width = 5;    % Width in inches
height = 3;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize


figure(1);
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties


%% create figure
figure(1);


%% plot spectrogram
myspectrogram(fluteFM, fs, 1024, [18,1], @bartlett, [-160 0], false, 'jet', true);
title('Spektrogram Vibrato');
%set(gca, 'XTick', 0:0.2:duration);
set(gca, 'YTick', 0:2000:fs/2);
xlabel('Zeit (s)'); 
ylabel('Frequenz (Hz)');



% Here we preserve the size of the image when we save it.
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);



% Save the file as PNG
print('improvedExample','-dpng','-r300');



%% play sound
sound(fluteFM,fs);