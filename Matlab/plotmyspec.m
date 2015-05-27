[song, fs] = audioread('C:\Users\k28137\Desktop\output.wav');
myspectrogram(song, fs, 1024, [18,1], @bartlett, [-160 0], false, 'jet', true);
