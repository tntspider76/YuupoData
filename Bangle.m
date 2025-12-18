clearvars
close all
clc
files = ["Ravatetal_JGR2020_LunarL1MagneticModelFields_LPgrad.dat", ...
         "Ravat_surfaceB_1x1_data.txt"];

nFiles = numel(files);

Grids = cell(nFiles,1);      % 裡面會放一個 struct，有 Btot/Br/... 的格點
LonGrids = cell(nFiles,1);   % 對應的 LON
LatGrids = cell(nFiles,1);   % 對應的 LAT
AngleGrids = cell(nFiles,1); % 存放每個格點的夾角
ZenithAngleGrids = cell(nFiles,1); % 存放天頂夾角

FileBaseNames = cell(nFiles,1);

for k = 1:nFiles
    data = readmatrix(files(k));
    tmp = split(files(k), ".");
    FileBaseNames{k} = tmp(1);

    lon = data(:,1);
    lat = data(:,2);

    Btot   = data(:,6);
    Br     = data(:,3);  % 徑向分量

    % 計算每個點的夾角，單位是弧度，然後轉換為度
    angle = asind(abs(Br) ./ Btot);
    zenithAngle = acos(Br ./ Btot) * (180 / pi);  % 計算天頂夾角，0~180 度

    lon_u = unique(lon);
    lat_u = unique(lat);
    nlon = numel(lon_u);
    nlat = numel(lat_u);

    [~, idx_lon] = ismember(lon, lon_u);
    [~, idx_lat] = ismember(lat, lat_u);

    toGrid = @(v) accumarray([idx_lat, idx_lon], v, [nlat, nlon], @mean, NaN);

    G = struct();
    G.Angle = toGrid(angle);  % 把夾角網格化
    G.ZenithAngle = toGrid(zenithAngle);  % 把天頂夾角網格化

    [LON, LAT] = meshgrid(lon_u, lat_u);

    Grids{k}    = G;
    LonGrids{k} = LON;
    LatGrids{k} = LAT;
    AngleGrids{k} = G.Angle;  % 存儲每個檔案的夾角網格
    ZenithAngleGrids{k} = G.ZenithAngle;  % 存儲每個檔案的天頂夾角網格
end

titlesave = {'Angle', 'ZenithAngle'};
titles_data = {'0.1^\circx0.1^\circ', '1^\circx1^\circ'};
for k = 1:nFiles
    G   = Grids{k};
    LON = LonGrids{k};
    LAT = LatGrids{k};
    Angle = AngleGrids{k};  % 拿到每個檔案的夾角數據
    ZenithAngle = ZenithAngleGrids{k};  % 拿到每個檔案的天頂夾角數據

    % 顯示磁場夾角圖
    f = figure(Theme="light");
    axesm('eckert4','Frame','on','Grid','on','ParallelLabel','off', ...
          'MeridianLabel','on','MLabelLocation',60,'maplonlimit',[0 360]);

    setm(gca, 'MapLatLimit',[min(LAT,[],'all') max(LAT,[],'all')], ...
             'MapLonLimit',[min(LON,[],'all') max(LON,[],'all')]);

    pcolorm(LAT, LON, Angle);  % 顯示磁場與地面夾角圖
    hM = findall(gca, 'Tag', 'MLabel');
        for L = 1:numel(hM)
            str = hM(L).String
            str = regexprep(str, '\s*[E]$', '');
            hM(L).String = str;
        end
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
   
    clim([0 90]);  % 夾角範圍從 0 到 90 度
    cb = colorbar;
    cb.Label.String = "degree";
    colormap("jet");
    box off;

    title(sprintf('%s (%s)', titlesave{1}, titles_data{k}), 'FontSize', 16);

    % 存檔
    outName = "png/2D/" + FileBaseNames{k} + "_" + titlesave{1} + ".png";
    exportgraphics(f, outName, "Resolution", 300);

    % 顯示天頂夾角圖
    f = figure(Theme="light");
    axesm('eckert4','Frame','on','Grid','on','ParallelLabel','off', ...
          'MeridianLabel','on','MLabelLocation',60,'maplonlimit',[0 360]);

    setm(gca, 'MapLatLimit',[min(LAT,[],'all') max(LAT,[],'all')], ...
             'MapLonLimit',[min(LON,[],'all') max(LON,[],'all')]);
    pcolorm(LAT, LON, ZenithAngle);  % 顯示 B 與天頂的夾角
    hM = findall(gca, 'Tag', 'MLabel');
        for L = 1:numel(hM)
            str = hM(L).String
            str = regexprep(str, '\s*[E]$', '');
            hM(L).String = str;
        end
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
    
    cb = colorbar;
    cb.Label.String = "degree"
    clim([0 180]);  % 天頂夾角範圍從 0 到 180 度

    colormap("jet");
    box off;

    title(sprintf('%s (%s)', titlesave{2}, titles_data{k}), 'FontSize', 16);

    % 存檔
    outName = "png/2D/" + FileBaseNames{k} + "_" + titlesave{2} + ".png";
    exportgraphics(f, outName, "Resolution", 300);
end
