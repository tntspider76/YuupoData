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
%NeedsLog(bool) : does Data need Log2
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

        %創建存檔資料夾
        if ~exist('fig','dir'), mkdir('fig'); end
        if ~exist('png','dir'), mkdir('png'); end
        

        %分離.txt以利命名
        TitleName = split(fileName,".");
        namespilt = split(fileName,"_");
        mkdir(append("fig/surf/",namespilt(2)));
        mkdir(append("fig/2D/",namespilt(2)));
        mkdir(append("png/surf/",namespilt(2)));
        mkdir(append("png/2D/",namespilt(2)));

        % 分離欄位
        longitude = data(:,X); % 經度
        latitude = data(:,Y); % 緯度
        total_B = data(:,DataPos); % 總磁場強度
        colorBarLable = namespilt(zlabelPos);
        if needsLog
            total_B = log2(total_B);
            ColorBarLimitUpper = log2(ColorBarLimitUpper);
            ColorBarLimitLower = log2(ColorBarLimitLower);
            colorBarLable = append(namespilt(zlabelPos),"(log2)")
        end
        %longitude(longitude>180) = longitude(longitude>180)-360;
        lon_vec = linspace(min(longitude), max(longitude), 1000);
        lat_vec = linspace(min(latitude), max(latitude), 1000);
        [LON, LAT] = meshgrid(lon_vec, lat_vec);

        % 插值到規則格點
        B_grid = griddata(longitude, latitude, total_B, LON, LAT, 'cubic');

        % 繪圖
        f1 = figure(Theme="light")
        surf(LON, LAT, B_grid) ;

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
        zlabel(namespilt(zlabelPos));%changeThis if error
        title(append(namespilt(2)," ",namespilt(4)));
        set(gca,'YDir','normal'); % 緯度由下往上增加
        view(45,30); % 調整視角，可自由修改
    
        %存圖
        exportgraphics(f1,append("png/surf/",namespilt(2),"/",TitleName(1),"_Surf.png"),"Resolution",300);
        savefig(f1,append("fig/surf/",namespilt(2),"/",TitleName(1),"_Surf"));
    
        %繪製2D圖
        if Plot2D == true
            f2 = figure(Theme="light")
            axesm('robinson', 'Frame', 'on', 'Grid', 'on', 'ParallelLabel', 'on', 'MeridianLabel', 'on','maplonlimit',[0 360]);
            % 設定經緯度範圍
            setm(gca, 'MapLatLimit', [min(latitude) max(latitude)],'MapLonLimit', [(min(longitude)) (max(longitude))]);
            % 在投影上畫磁場強度
            surfm(LAT, LON, B_grid);
            clim([ColorBarLimitLower ColorBarLimitUpper]);

            title(append(namespilt(2)," ",namespilt(4)));
            colormap("jet");
            c2 = colorbar;
            c2.Label.String = colorBarLable;
            
            exportgraphics(f2,append("png/2D/",namespilt(2),"/",TitleName(1),"_2D.png"),"Resolution",300);
            savefig(f2,append("fig/2D/",namespilt(2),"/",TitleName(1),"_2D"));
        end
    catch ME
        warning('Failed to read file %s: %s', fileName, ME.message);
    end
end
    
end