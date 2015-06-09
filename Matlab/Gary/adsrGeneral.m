length = 1.3;       %length of the tone
fs = 44100;
t = 0:1/fs:length;  %timecode for each sample

attackTime = [0,0.1];
decayTime = [0.1,0.2];
sustainTime = [0.2,1.2];
releaseTime = [1.2,1.3];
attackValue = [0,0.3];
decayValue = [0.3,0.25];
sustainValue = [0.25,0.23];
releaseValue = [0.23,0.0];

AttackSize = size(t(t>=attackTime(1) & t < attackTime(2)),2);
DecaySize = size(t(t>=decayTime(1) & t < decayTime(2)),2);
SustainSize = size(t(t>=sustainTime(1) & t < sustainTime(2)),2);
ReleaseSize = size(t(t>=releaseTime(1) & t < releaseTime(2)),2);

AttackTimes = t(t>=attackTime(1) & t < attackTime(2));
ReleaseTimes = t(t>=releaseTime(1) & t <= releaseTime(2));
DecayTimes = t(t>=decayTime(1) & t < decayTime(2));

Attack = ((cos(2*pi*(1/((attackTime(2)-attackTime(1))*2))*AttackTimes-attackTime(1)+pi)+1)/2)*attackValue(2);
Decay = ((((cos(2*pi*(1/((decayTime(2)-decayTime(1))*2))*(DecayTimes-decayTime(1)))+1)/2)*(decayValue(1)-decayValue(2))))+decayValue(2);
Sustain = linspace(sustainValue(1),sustainValue(2),SustainSize);
Release = (cos(2*pi*(1/((releaseTime(2)-releaseTime(1))*2))*(ReleaseTimes-releaseTime(1)))+1)/2*releaseValue(1);

A = [Attack,Decay,Sustain,Release];

plot(A);
set(gca, 'XTick', 0:4410:length*fs);
set(gca, 'XTickLabel', 0:4410/fs:length);
set(gca, 'XLim', [0, length*fs]);
xlabel('Sekunden'); 
ylabel('Amplitude');
title('ADSR-Hüllkurve Querflöte Allgemein');