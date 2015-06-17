


% %logarithmic
% y(i > 0 & i <= 0.1) = 0;
% y(i > 0.1 & i <= 0.3) = (i(i>0.1 & i <= 0.3)/0.3).^4;
% y(i > 0.3 & i <= 0.5) = 0.6+(((i(i > 0.3 & i <= 0.5) - 0.5)*0.4^(1/4)/0.2).^4);
% y(i > 0.5 & i <= 0.8) = 1-i(i > 0.5 & i <= 0.8)/2-0.15;
% y(i > 0.8 & i <= 1) = (((i(i > 0.8 & i <= 1) - 1)*0.45^(1/4)/0.2).^4);
% %y(i > 0.2 & i <= 0.4) = 1-(i - 0.4).^2;

%% default
% x = [0,0.2,0.4,0.8,1];
% y = [0,1,0.6,0.6,0];
% plot(x,y, 'LineWidth',1);
% 
% xlabel('Zeit(s)')
% ylabel('Amplitude')
% title('Standard ADSR-Hüllkurve')
% set(gca, 'XLim', [0 1]);

%% brass
x = [0,0.1,0.2,0.5,0.6];
y = [0,1,0.75,0.6,0];
subplot(1,2,1);
plot(x,y, 'LineWidth',1);

xlabel('Zeit(s)')
ylabel('Amplitude')
title('Blechblas ADSR-Hüllkurve')
set(gca, 'XLim', [0 0.6]);

%% piano
i = linspace(0,1,10000);
%y = zeros(10000,1);
y(i < 0.05) = linspace(0,1,0.05*10000);

y(i >= 0.05) = (((i(i >= 0.05)-0.05 - 1)*1^(1/4)/1).^4);
subplot(1,2,2);
plot(i,y, 'LineWidth',1);

xlabel('Zeit(s)')
ylabel('Amplitude')
title('Klavier ADSR-Hüllkurve')
