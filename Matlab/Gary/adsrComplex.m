function A = adsrComplex(t)
length = 1.3;       %length of the tone
fs = 44100;
t = 0:1/fs:length;  %timecode for each sample


attackTime = [0,0.05];
decayTime = [0.05,0.15];
sustainTime1 = [0.15,0.6];
sustainTime2 = [0.6,0.82];
sustainTime3 = [0.82,1.2];
releaseTime = [1.2,1.3];
attackValue = [0,0.3];
decayValue = [0.3,0.25];
sustainValue = [0.25,0.24];
releaseValue = [0.25505,0.0];

AttackSize = size(t(t>=attackTime(1) & t < attackTime(2)),2);
DecaySize = size(t(t>=decayTime(1) & t < decayTime(2)),2);
SustainSize = size(t(t>=sustainTime1(1) & t < sustainTime1(2)),2);
ReleaseSize = size(t(t>=releaseTime(1) & t < releaseTime(2)),2);

AttackTimes = t(t>=attackTime(1) & t < attackTime(2));
DecayTimes = t(t>=decayTime(1) & t < decayTime(2));
SustainTimes2 = t(t>=sustainTime2(1) & t < sustainTime2(2));
SustainTimes3 = t(t>=sustainTime3(1) & t < sustainTime3(2));
ReleaseTimes = t(t>=releaseTime(1) & t <= releaseTime(2));

Attack = ((cos(2*pi*(1/((attackTime(2)-attackTime(1))*2))*AttackTimes-attackTime(1)+pi)+1)/2)*attackValue(2);
Decay = ((((cos(2*pi*(1/((decayTime(2)-decayTime(1))*2))*(DecayTimes-decayTime(1)))+1)/2)*(decayValue(1)-decayValue(2))))+decayValue(2);
Sustain1 = linspace(sustainValue(1), sustainValue(2), SustainSize);
Sustain2 = 0.03*(cos(2*pi*5*SustainTimes2)-1)/4+sustainValue(2);
Sustain3 = 0.03*(sin(2*pi*7*SustainTimes3-1/4*pi)+1)/3+sustainValue(2)-0.00482;
Release = (cos(2*pi*(1/((releaseTime(2)-releaseTime(1))*2))*(ReleaseTimes-releaseTime(1)))+1)/2*releaseValue(1);
 
A = [Attack,Decay,Sustain1,Sustain2,Sustain3,Release];

subplot(1,2,2);
plot(A, 'LineWidth',1);
set(gca, 'XTick', 0:4410:length*fs);
set(gca, 'XTickLabel', 0:4410/fs:length);
set(gca, 'XLim', [0, length*fs]);
xlabel('Sekunden'); 
ylabel('Amplitude');
title('ADSR-Hüllkurve Querflöte Komplex');
end