maxTime = 0.020;

figure ('Color',[0.9 0.9 0.9]);
%Beispiel2 - Carrier
t = linspace(0,maxTime,1000);
fC = 300;
y1 = sin(2*pi*fC*t);
subplot(3,1,1)
plot(t,y1,'LineWidth',1.0,'lineSmoothing','on')
set(gca,'XLim',[0,maxTime]);
set(gca,'XTick',0:(maxTime/(maxTime * 1000)):maxTime);
set(gca,'XTickLabel',0:2:maxTime*1000);

title('Tr�ger','FontWeight','bold')
xlabel('t (in msec)')
ylabel('A')


subplot(3,1,2)
%Beispiel2 - Modulator
t1 = linspace(0,maxTime,1000);
fM = 120;
I = 5;
y2 = I*sin(2*pi*fM*t);
plot(t1,y2,'LineWidth',1.0,'lineSmoothing','on')
set(gca,'XLim',[0,maxTime]);
set(gca,'XTick',0:(maxTime/(maxTime * 1000)):maxTime);
set(gca,'XTickLabel',0:2:maxTime*1000);

title('Modulator','FontWeight','bold');
xlabel('t (in msec)');
ylabel('A');

subplot(3,1,3)
%Beispiel2 - Modulierte Welle
t2 = linspace(0,maxTime,1000);
y3 = sin(2*pi*fC*t2 + I*sin(2*pi*fM*t2));
plot(t2,y3,'LineWidth',1.0,'lineSmoothing','on');
set(gca,'XLim',[0,maxTime]);
set(gca,'XTick',0:(maxTime/(maxTime * 1000)):maxTime);
set(gca,'XTickLabel',0:2:maxTime*1000);

title('Moduliertes Signal','FontWeight','bold');
xlabel('t (in msec)');
ylabel('A');
