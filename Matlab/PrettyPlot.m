fc = 15;
fm = 1;
ypm = @(t) sin(fc*t + 9* sin(fm*t));

dmn = -2*pi:0.001:2*pi;

% Defaults for this blog post
width = 7;     % Width in inches
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

%plot(dmn, ypm(dmn), 'LineWidth',lw); %<- Specify plot properites

% xlim(xbounds);
% ylim(ybounds);
% set(gca, 'ytick', ybounds(1):ytick:ybounds(2))
% 
% xlabel('t');
% title('Improved Example Figure');


% Here we preserve the size of the image when we save it.
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

% Save the file as PNG
print('adsrFluteComplex','-dpng','-r300');