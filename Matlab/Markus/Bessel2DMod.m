j0 = @(x) besselj(0,x);
j1 = @(x) besselj(1,x);
j2 = @(x) besselj(2,x);
j3 = @(x) besselj(3,x);

dmn = 0:0.001:6000;

% Defaults for this blog post
width = 6;    % Width in inches
height = 3;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize

% Plot settings
xbounds = [-1 300]; % x axis
ybounds = [-0.5 1.1];       % y axis
ytick = 0.25;         % y step size


figure(1);
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

% Plot 1
plot(dmn,j0(dmn), dmn,j1(dmn), dmn,j2(dmn),   'LineWidth',lw); %<- Specify plot properites

xlim(xbounds);
ylim(ybounds);

set(gca, 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
axis off;

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







