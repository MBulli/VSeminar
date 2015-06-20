function [] = prettyPlotEx(width, height, imgName, fontSize)

    if ~exist('width',   'var')  width    = 5; end; % Width in inches
    if ~exist('height',  'var')  height   = 5; end; % Height in inches
    if ~exist('imgName', 'var')  imgName  = 'prettyplot'; end; % Image file name
    if ~exist('fontSize', 'var') fontSize = 11; end; % Font size for title, axis etc.


    % Parameters
    alw = 0.75;    % AxesLineWidth
    lw = 1.5;      % LineWidth
    msz = 8;       % MarkerSize
    
    
    pos = get(gcf, 'Position');
    set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
    set(gca, 'FontSize', fontSize, 'LineWidth', alw); %<- Set properties
    

    % Here we preserve the size of the image when we save it.
    set(gcf,'InvertHardcopy','on');
    set(gcf,'PaperUnits', 'inches');
    papersize = get(gcf, 'PaperSize');
    left = (papersize(1)- width)/2;
    bottom = (papersize(2)- height)/2;
    myfiguresize = [left, bottom, width, height];
    set(gcf,'PaperPosition', myfiguresize);

    % Save the file as PNG
    print(imgName,'-dpng','-r300');
end

