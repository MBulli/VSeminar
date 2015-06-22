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
y(i < 0.05) = linspace(0,1,0.05*10000);

y(i >= 0.05) = (((i(i >= 0.05)-0.05 - 1)*1^(1/4)/1).^4);
subplot(1,2,2);
plot(i,y, 'LineWidth',1);

xlabel('Zeit(s)')
ylabel('Amplitude')
title('Klavier ADSR-Hüllkurve')
