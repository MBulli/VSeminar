clear;

fc=100; %Hz
fm=100; %Hz
I = 10.3;

ybounds = [-1; 1];

n = -I-2:1:I+1;
j = besselj(n, I);
frequenzen = fc+n*fm;

% reflect freqs
X = [ones(length(frequenzen), 1), transpose(frequenzen), transpose(j)];
for row = 1:size(X,1)
    if X(row, 2) < 0
        X(row, 1) = -1;             % store sign info
        X(row, 2) = abs(X(row, 2)); % freq
        X(row, 3) = -X(row, 3);     % amp
    end;
end;

% Indicies for positve and negative freqs
idxPos = X(:,1)>0;
idxNeg = X(:,1)<0;

% ic enthält keys, diese werden bei accumarray summiert
[uniqFreq, ia, ic] = unique(X(:,2));
amps = accumarray(ic, X(:,3));
Xreal = [uniqFreq, amps];

% PLOTS!!
subplot(2,2,1);
stem(X(:,2).*X(:,1), X(:,3), '.');
title('1) Ausgangslage');
xlabel('Hz');
ylim(ybounds);
%# vertical line at fc
hx = graph2d.constantline(fc, 'LineStyle',':', 'Color',[.7 .7 .7]);
changedependvar(hx,'x');

subplot(2,2,2);
hold on;
stem(X(idxPos,2), X(idxPos,3), '.');
stem(X(idxNeg,2), X(idxNeg,3), '.', 'Color','red');
title('2) Reflektiert');
xlabel('Hz');
ylim(ybounds);
%# vertical line at fc
hx = graph2d.constantline(fc, 'LineStyle',':', 'Color',[.7 .7 .7]);
changedependvar(hx,'x');
hold off;


subplot(2,2,3);
stem(Xreal(:,1), Xreal(:,2), '.');
title('3) Addiert');
xlabel('Hz');
ylim(ybounds);
%# vertical line at fc
hx = graph2d.constantline(fc, 'LineStyle',':', 'Color',[.7 .7 .7]);
changedependvar(hx,'x');


% plot
subplot(2,2,4);
stem(Xreal(:,1), abs(Xreal(:,2)), '.');
title('4) Betrag Amplitude');
xlabel('Hz');
ylim([0; ybounds(2)]);
%# vertical line at fc
hx = graph2d.constantline(fc, 'LineStyle',':', 'Color',[.7 .7 .7]);
changedependvar(hx,'x');


