y = @(t) 1/2.4 * (...
          -0.260051958*cos(2*pi*t*1000) ...
         +0.339058958*(cos(2*pi*t*1100) + cos(2*pi*t*900)) ... 
         +0.486091263*(cos(2*pi*t*1200) + cos(2*pi*t*800)) ...
         +0.309062865*(cos(2*pi*t*1300) + cos(2*pi*t*700)) ...
         +0.132034184*(cos(2*pi*t*1400) + cos(2*pi*t*600)) ...
         +0.043028435*(cos(2*pi*t*1500) + cos(2*pi*t*500)) ...
         +0.011393932*(cos(2*pi*t*1600) + cos(2*pi*t*400)));
     
fm = @(t) sin(2*pi*1000*t + 3*sin(2*pi*100*t));

fs=44100;
t = 0:1/fs:2;

subplot(2,2,1)
plot(t, y(t));
set(gca, 'XLim', [0.005, 0.015]);

subplot(2,2,2)
plot(t, fm(t));
set(gca, 'XLim', [0.005, 0.015]);

%% calculate FFT for spectrum

nf=2048; %number of point in DTFT
Y = fft(y(t),nf);
f = fs/2*linspace(0,1,nf/2+1);
 
 
%% plot spectrum 0-5000Hz
subplot(2,2,3)
area(f,abs(Y(1:nf/2+1)));
title('add synth');
set(gca, 'XLim', [0, 2000]);


%% calculate FFT for spectrum
Yfm = fft(fm(t),nf);
ffm = fs/2*linspace(0,1,nf/2+1);
 
 
%% plot spectrum 0-5000Hz
subplot(2,2,4)
area(ffm,abs(Yfm(1:nf/2+1)));
title('FM');
set(gca, 'XLim', [0, 2000]);


audiowrite('add.wav', y(t), fs);
audiowrite('fm.wav',  fm(t), fs);
%sound(y(t), fs);
%sound(fm(t), fs);