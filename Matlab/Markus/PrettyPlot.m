fc = 9;
fm = 1;
ypm = @(t) sin(fc*t + 3*sin(fm*t));
y = @(t) cos(fm*t);

dmn = -2*pi:0.001:2*pi;

% Defaults for this blog post
width = 3;    % Width in inches
height = 5;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize

% Plot settings
xbounds = [-2*pi 2*pi]; % x axis
ybounds = [-1 1];       % y axis
ytick = 0.5;         % y step size


figure(1);
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

% Plot 1
subplot(2,1,1)
plot(dmn, y(dmn), 'LineWidth',lw); %<- Specify plot properites

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







