[xn,fs]=audioread('C:\Users\k28137\Desktop\output.wav');
xn=xn/((2^15)-1);
nf=65535*2; %number of point in DTFT
Y = fft(xn,nf);
f = fs/2*linspace(0,1,nf/2+1);
plot(f,abs(Y(1:nf/2+1)));
%set(gca,'XScale','log') 