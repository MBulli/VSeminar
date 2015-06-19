j0 = @(x) besselj(0,x);
j1 = @(x) besselj(1,x);
j2 = @(x) besselj(2,x);

dmn = 0:0.001:30;

% Defaults for this blog post
width = 6;    % Width in inches
height = 3;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize

% Plot settings
xbounds = [-1 30]; % x axis
ybounds = [-0.5 1.1];       % y axis
ytick = 0.25;         % y step size


figure(1);
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

% Plot 1
plot(dmn, j0(dmn), dmn, j1(dmn), dmn, j2(dmn),   'LineWidth',lw); %<- Specify plot properites

xlim(xbounds);
ylim(ybounds);
set(gca, 'ytick', ybounds(1):ytick:ybounds(2))
ylabel('J_n(x)');
xlabel('x');

grid on

legend('J_0(x)', 'J_1(x)', 'J_2(x)');

%# vertical line
hx = graph2d.constantline(0, 'LineStyle','-', 'Color',[0 0 0]);
changedependvar(hx,'x');
%# horizontal line
hy = graph2d.constantline(0, 'LineStyle','-', 'Color',[0 0 0]);
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







