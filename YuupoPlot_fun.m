function [f1,f2] = YuupoPlot_fun(location,fileName,X,Y,DataPos,zlabelPos,ColorBarLimitUpper,ColorBarLimitLower,filter,Plot2D,needsLog)
%location(Char) : file's location ex. 'data_folder/'
%fileName(Char) : file's name for plotting ex. 'global_50kmB_T150_Vsw300_fupper_fobs_output_inu.txt'
%X(int) : X axis (longitude) ex. 1
%Y(int) : Y axis (latitude) ex. 2
%DataPos(int) : Fupper data location ex. 3
%ColorBarLimitUpper : using FindLimit function to find Max and Min Fobs
%ColorBarLimitLower : using FindLimit function to find Max and Min Fobs
%filter(char) : Leave '' if not in use
%Plot2D(bool) : boolen for going to plot 2D fig
%NeedsLog(bool) : does Data need Log10
arguments (Input)
    location char
    fileName char
    X int16
    Y int16
    DataPos int16
    zlabelPos int16
    ColorBarLimitUpper
    ColorBarLimitLower
    filter
    Plot2D
    needsLog
end

arguments (Output)
    f1
    f2
end

f1 = [];
f2 = [];

if isempty(filter) || contains(fileName,filter)
    try
        %讀取數據
        data = readmatrix(fullfile(location,fileName));

        %分離.txt以利命名
        TitleName = split(fileName,".");
        namespilt = split(fileName,"_");
        titleComp = [extract(namespilt(2),(digitsPattern(2)|digitsPattern(3)) + "km"),extract(namespilt(4),digitsPattern(3))];
        titleComp(1) = regexprep(titleComp(1), '(\d+)\s*km', '$1 km')
        if length(titleComp) == 1
            titleRe = titleComp(1);
        else
            titleRe = compose("%s Vsw= %s km/s",string(titleComp));
        end

        % 分離欄位
        longitude = data(:,X); % 經度
        latitude = data(:,Y); % 緯度
        total_B = data(:,DataPos); % 總磁場強度
        
        tokens = regexp(string(namespilt(6)), '^([A-Za-z])([A-Za-z0-9_]*)$', 'tokens');
        if ~isempty(tokens)
            head = tokens{1}{1};
            tail = tokens{1}{2};

            if tail ~= ""
                colorBarLable = head + "_{" + tail + "} (Hz)"
            else
                colorBarLable = head
            end
        else
            colorBarLable = targetName;
        end
        if needsLog
            total_B = log10(total_B);
            ColorBarLimitUpper = log10(ColorBarLimitUpper);
            ColorBarLimitLower = log10(ColorBarLimitLower);
            colorBarLable = append("log10(",namespilt(zlabelPos),",Hz)");
        end
        %longitude = wrapTo180(longitude);
        %longitude(longitude>180) = longitude(longitude>180)-360;
        lon_vec = linspace(min(longitude), max(longitude), 1000);
        lat_vec = linspace(min(latitude), max(latitude), 1000);
        [LON, LAT] = meshgrid(lon_vec, lat_vec);

        % 插值到規則格點
        B_grid = griddata(longitude, latitude, total_B, LON, LAT, 'cubic');

        % 繪圖
        f1 = figure(Theme="light");
        %f1.Position(3630:1760) = [3630 1760];
        surf(LON, LAT, B_grid);

        %增加軸向限制
        xlim([0 360]);
        ylim([-90 90]);
        clim([ColorBarLimitLower ColorBarLimitUpper]);

        shading interp; % 平滑色彩
        colormap("jet");
        c1 = colorbar;
        c1.Label.String = colorBarLable;

    
        %軸標
        xlabel('經度 (deg)');
        ylabel('緯度 (deg)');
        zlabel(append(namespilt(zlabelPos),"(Hz)"));
        title(titleRe,'FontSize',16);
        set(gca,'YDir','normal');
        view(45,30); % 調整視角，可修改
        box off;
    
        %存圖
        exportgraphics(f1,append("png/surf/",extract(namespilt(2),(digitsPattern(2)|digitsPattern(3))),"/",TitleName(1),"_Surf.png"),"Resolution",300);
        close
        %savefig(f1,append("fig/surf/",namespilt(2),"/",TitleName(1),"_Surf"));
    
        %繪製2D圖
        if Plot2D == true
            f2 = figure(Theme="light");
            %f2.Position(3630:1760) = [3630 1760];
            axesm('eckert4','Frame','on','Grid','on','ParallelLabel','off','MeridianLabel','on','MLabelLocation',60,'maplonlimit',[0 360]);
            % 設定經緯度範圍
            setm(gca, 'MapLatLimit', [min(latitude) max(latitude)],'MapLonLimit', [(min(longitude)) (max(longitude))]);
            % 在投影上畫磁場強度
            
            drawnow

            latLabels  = [-90 -75 -60 -45 -30 -15 0 15 30 45 60 75 90];
            lonLabelAt = min(LON,[],'all');
    
            hLat = gobjects(numel(latLabels),1);   % 存緯度文字 handle
    
            for j = 1:numel(latLabels)
                latv = latLabels(j);
    
                if latv > 0
                    txt = sprintf('%d° N', latv);
                elseif latv < 0
                txt = sprintf('%d° S', abs(latv));
                else
                    txt = '0°';
                end
    
                hLat(j) = textm(latv, lonLabelAt, txt, ...
                    'HorizontalAlignment','right', ...
                    'FontSize',9, ...
                    'Clipping','off');   % 重要：避免被裁切
            end
        
            drawnow;  % 確保座標軸範圍已確定
        
            xl = xlim(gca);
            dx = 0.015 * range(xl);
        
            for j = 1:numel(hLat)
                latv = latLabels(j);
                p = hLat(j).Position;
                dx1 = 0.015 + latv^2 * 0.00003 + dx * abs(latv) *0.01
                p(1) = p(1) - dx1;    % 往左移
                hLat(j).Position = p;
            end
            surfm(LAT, LON, B_grid);
            clim([ColorBarLimitLower ColorBarLimitUpper]);

            title(titleRe,'FontSize',36);
            colormap("jet");
            c2 = colorbar;
            c2.Label.String = colorBarLable;
            box off;hM = findall(gca, 'Tag', 'MLabel');
            for L = 1:numel(hM)
                str = hM(L).String
                str = regexprep(str, '\s*[E]$', '');
                hM(L).String = str;
            end


            exportgraphics(f2,append("png/2D/",extract(namespilt(2),(digitsPattern(2)|digitsPattern(3))),"/",TitleName(1),"_2D.png"),"Resolution",300);
            close
            %savefig(f2,append("fig/2D/",namespilt(2),"/",TitleName(1),"_2D"));
        end
    catch ME
        warning('%s: %s', fileName, ME.message);
    end
end
    
end