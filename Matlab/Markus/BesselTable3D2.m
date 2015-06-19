writePNG = 0;

fc=440; %Hz
fm=20; %Hz

Imin=0;
Istep=1;
Imax=10;

maxBandwidth = (Imax+2)*fm + fc;

for I = Imin:Istep:Imax
    magic=I+ceil(log2(abs(I)+1))*2; 
    n = -magic:1:magic;
    j = besselj(n, I);
    frequenzen = fc+n*fm;
      
    % reflect freqs
    X = [transpose(frequenzen), transpose(j)];
    for row = 1:size(X,1)
        if X(row, 1) < 0
            X(row, 1) = abs(X(row, 1)); % freq
            X(row, 2) = -X(row, 2);     % amp
        end;
    end;
    
    % ic enthält keys, diese werden bei accumarray summiert
    [uniqFreq, ia, ic] = unique(X(:,1));
    amps = accumarray(ic, X(:,2));
    Xreal = [uniqFreq, amps];
    
    % calc sound 
    Fs=44100;
    t  = 0:1/Fs:1;
    x = sin(2*pi*fc*t + I*sin(2*pi*fm*t));
    sound(x, Fs);


    % plot
    figure(1);
    stem(Xreal(:,1), Xreal(:,2), '.');
    xlabel('Hz');
    ylim([0; 1]);
    xlim([0; maxBandwidth]);
    title(strcat('I=', num2str(I)));
    %# vertical line
    hx = graph2d.constantline(fc, 'LineStyle',':', 'Color',[.7 .7 .7]);
    changedependvar(hx,'x');


    % Defaults for this blog post
    if writePNG > 0
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
        %print(strcat('Spektrum_real_I', num2str(I)),'-dpng','-r300');
    end; % writePNG
    
    pause(1.5);
end;