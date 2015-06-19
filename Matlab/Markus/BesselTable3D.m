fc=100; %Hz
fm=100; %Hz
Imax=20;


for I = 0:Imax
    magic=I+ceil(log2(abs(I)+1))*2; 
    n = -magic:1:magic;
    j = besselj(n, I);
    frequenzen = fc+n*fm;

    figure(1);
    stem(frequenzen, j, '.');
    xlabel('Hz');
    ylim([-1; 1]);
    xlim([-3000 3000]);
    title(strcat('I=', num2str(I)));
    %# vertical line
    hx = graph2d.constantline(fc, 'LineStyle',':', 'Color',[.7 .7 .7]);
    changedependvar(hx,'x');


    % Defaults for this blog post
    width = 6;    % Width in inches
    height = 4;    % Height in inches
    alw = 0.75;    % AxesLineWidth
    fsz = 11;      % Fontsize
    lw = 1.5;      % LineWidth
    msz = 8;       % MarkerSize

    pos = get(gcf, 'Position');
    set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
    set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

    % Here we preserve the size of the image when we save it.
    set(gcf,'InvertHardcopy','on');
    set(gcf,'PaperUnits', 'inches');
    papersize = get(gcf, 'PaperSize');
    left = (papersize(1)- width)/2;
    bottom = (papersize(2)- height)/2;
    myfiguresize = [left, bottom, width, height];
    set(gcf,'PaperPosition', myfiguresize);

    % Save the file as PNG
    print(strcat('Spektrum_I', num2str(I)),'-dpng','-r72');
end;