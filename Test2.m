
    fileName = 'Ravat_surfaceB_1x1_data.txt';
    X =1;
    Y =2;
    DataPos =6;
    zlabelPos =2;

f1 = [];
%讀取數據
data = readmatrix(fileName);

        %分離.txt以利命名
TitleName = split(fileName,".");
namespilt = split(fileName,"_");
titleComp = [extract(namespilt(2),(digitsPattern(2)|digitsPattern(3)) + "km"),extract(namespilt(4),digitsPattern(3))];
        
            

        % 分離欄位
longitude = data(:,X); % 經度
latitude = data(:,Y); % 緯度
total_B = data(:,DataPos); % 總磁場強度
colorBarLable = append(namespilt(zlabelPos),"(Hz)");
ColorBarLimitUpper = max(total_B);
ColorBarLimitLower = min(total_B);
composeArray = [string(min(total_B)), string(max(total_B))]
stitleRe = compose("Btot Min= %s Max= %s",composeArray)
longitude(longitude>180) = longitude(longitude>180)-360;
lon_vec = linspace(min(longitude), max(longitude), 3600);
lat_vec = linspace(min(latitude), max(latitude), 1800);
[LON, LAT] = meshgrid(lon_vec, lat_vec);

        % 插值到規則格點
        B_grid = griddata(longitude, latitude, total_B, LON, LAT, 'cubic');

            f1 = figure(Theme="light");
            %f2.Position(3630:1760) = [3630 1760];
            axesm('robinson', 'Frame', 'on', 'Grid', 'on', 'ParallelLabel', 'on', 'MeridianLabel', 'on','maplonlimit',[-180 180]);
            % 設定經緯度範圍
            setm(gca, 'MapLatLimit', [min(latitude) max(latitude)],'MapLonLimit', [(min(longitude)) (max(longitude))]);
            % 在投影上畫磁場強度
            surfm(LAT, LON, B_grid);
            clim([ColorBarLimitLower ColorBarLimitUpper]);

            title(titleRe);
            colormap("jet");
            c1 = colorbar;
            c1.Label.String = colorBarLable;
            
            exportgraphics(f1,append("png/2D/",TitleName(1),"_1X1_2D.png"),"Resolution",300);