fc = 100;
fm = 100;
ypm = @(t) sin(fc*t + 2*sin(fm*t));
y = @(t) cos(fm*t);


y1=@(t) 0.15*sin(2*pi*1*t);
y2=@(t) 0.75*sin(2*pi*2*t);
y3=@(t) 0.30*sin(2*pi*3*t);
y4=@(t) 0.14*sin(2*pi*4*t);

yx=@(t) 0.15*sin(2*pi*1*t) + 0.75*sin(2*pi*2*t) + 0.30*sin(2*pi*3*t) + 0.14*sin(2*pi*4*t);

dmn = 0:0.001:4*pi;

signal = ypm(dmn);

N = length(signal);
fs = 62.5; % 62.5 samples per second
fnyquist = fs/2; %Nyquist frequency

X_mags = abs(fft(signal))/6000;
bin_vals = [0 : N-1];
fax_Hz = bin_vals*fs/N;
N_2 = ceil(N/2);
N_3 = ceil(N/3);


% Defaults for this blog post
width = 3;    % Width in inches
height = 5;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize

% Plot settings
xbounds = [0 1]; % x axis
ybounds = [-1 1];       % y axis
ytick = 0.5;         % y step size


figure(1);
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

% Plot 1
subplot(2,1,1)
N_30 = ceil(N/8);
plot(fax_Hz(1:N_30), X_mags(1:N_30))
xlabel('Frequency (Hz)')
ylabel('Magnitude');
title('Single-sided Magnitude spectrum (Hertz)');
axis tight

% Plot 2
subplot(2,1,2)
plot(dmn, ypm(dmn), 'LineWidth',lw); %<- Specify plot properites

xlim(xbounds);
ylim(ybounds);
set(gca, 'ytick', ybounds(1):ytick:ybounds(2))
xlabel('t');

%# vertical line
hx = graph2d.constantline(0, 'LineStyle',':', 'Color',[.7 .7 .7]);
changedependvar(hx,'x');
%# horizontal line
hy = graph2d.constantline(0, 'LineStyle',':', 'Color',[.7 .7 .7]);
changedependvar(hy,'y');


hold on
plot(dmn, y1(dmn), 'Color', 'red');
plot(dmn, y2(dmn), 'Color', 'red');
plot(dmn, y3(dmn), 'Color', 'red');
plot(dmn, y4(dmn), 'Color', 'red');
plot(dmn, yx(dmn), 'Color', 'green');
hold off

% Here we preserve the size of the image when we save it.
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

% Save the file as PNG
print('improvedExample','-dpng','-r300');







