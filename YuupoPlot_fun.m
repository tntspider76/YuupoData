function [f1,f2] = YuupoPlot_fun(location,fileName,X,Y,TargetStrengh,filter,Plot2D)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    location
    fileName
    X
    Y
    TargetStrengh
    filter
    Plot2D
end

arguments (Output)
    f1
    f2
end

if findstr(fileName,filter) == 0
elseif findstr(fileName,filter) ~= 0
    %讀取數據
    data = readmatrix(fullfile(location,fileName));

    %創建存檔資料夾
    mkdir fig/;
    mkdir png/;

    %分離.txt以利命名
    TitleName = split(fileName,".");

    % 分離欄位
    longitude = data(:,X); % 經度
    latitude = data(:,Y); % 緯度
    total_B = data(:,TargetStrengh); % 總磁場強度
    longitude(longitude>180) = longitude(longitude>180)-360;
    lon_vec = linspace(min(longitude), max(longitude), 4096);
    lat_vec = linspace(min(latitude), max(latitude), 4096);
    [LON, LAT] = meshgrid(lon_vec, lat_vec);

    % 插值到規則格點
    B_grid = griddata(longitude, latitude, total_B, LON, LAT, 'cubic');

    % 繪圖
    f1 = figure
    surf(LON, LAT, B_grid) ;  
    shading interp; % 平滑色彩
    colormap jet;
    colorbar;
    xlabel('經度 (deg)');
    ylabel('緯度 (deg)');
    zlabel('TODO')%TODO
    title(replace(TitleName,"_"," "));
    set(gca,'YDir','normal'); % 緯度由下往上增加
    view(45,30); % 調整視角，可自由修改
    exportgraphics(f1,append("png/",TitleName(1),"_3D.png"),"Resolution",300);
    savefig(f1,append("fig/",TitleName(1),"_3D"));
    %繪製2D圖
    if Plot2D == true
        f2 = figure
        axesm('robinson', 'Frame', 'on', 'Grid', 'on', 'ParallelLabel', 'on', 'MeridianLabel', 'on');
        % 設定經緯度範圍
        setm(gca, 'MapLatLimit', [min(latitude) max(latitude)],'MapLonLimit', [(min(longitude)) (max(longitude))]);
        % 在投影上畫磁場強度
        surfm(LAT, LON, B_grid);
        colormap jet;
        title(replace(TitleName,"_"," "));
        colorbar;
        exportgraphics(f2,append("png/",TitleName(1),"_2D.png"),"Resolution",300);
        savefig(f2,append("fig/",TitleName(1),"_2D"));
    end
end


end