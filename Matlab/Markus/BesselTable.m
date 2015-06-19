fc=100; %Hz
fm=200; %Hz
I=20;

n = -I-2:1:I+1;
j = besselj(n, I);
frequenzen = fc+n*fm;

figure(1);
subplot(2,2,1);
stem(frequenzen, j, '.');
title('1) Ausgangslage');
xlabel('Hz');
ylim([-1; 1]);

% reflect
subplot(2,2,2);
R1 = []; % j for negative freq
R2 = []; % j for postive  freq
for c = 1:size(frequenzen, 2)
    if frequenzen(c) < 0
        R1(length(R1)+1, 1) = -1*j(c);
    else
        R2(length(R2)+1, 1) = j(c);
    end
end

%if ~isempty(R2)
    stem(frequenzen(frequenzen>=0), R2, '.');
%end;
if ~isempty(R1)
    hold on;
    stem(abs(frequenzen(frequenzen<0)), R1, '.', 'Color','red');
    hold off;
end;

title('2) Reflektiert');
xlabel('Hz');
ylim([-1; 1]);


% add
subplot(2,2,3);

% 0Hz tritt nur auf wenn fc ganzzahliges Vielfaches von fm ist
% Beim Sortieren nach +/- wird die Null bei + einsortiert.
% Daher muss sie bei - nachträglich hinzugefügt werden.
if mod(fc,fm) == 0 
    R1 = [R1; 0];
end
R1=flipud(R1);

sizeR1 = max(size(R1));
sizeR2 = max(size(R2));

if sizeR1 > sizeR2
    R2=[R2; zeros(sizeR1-sizeR2, 1)];
else
    R1=[R1; zeros(sizeR2-sizeR1, 1)];
end

R=R1+R2;

positiveFreq = frequenzen(frequenzen>=0); 
negativeFreq = frequenzen(frequenzen<=0);

if length(positiveFreq) > length(negativeFreq)
    frequencies2 = positiveFreq;
else 
    frequencies2 = negativeFreq;
end

stem(frequencies2, R, '.');
title('3) Addiert');
xlabel('Hz');
ylim([-1; 1]);

% y abs
subplot(2,2,4);
if length(positiveFreq) > length(negativeFreq)
    frequencies3 = positiveFreq;
else 
    frequencies3 = abs(negativeFreq);
end

stem(frequencies3, abs(R), '.');
title('4) Betrag Amplitude');
xlabel('Hz');
ylim([-1; 1]);