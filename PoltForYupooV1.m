clc
clearvars
close all
% 讀取資料
data = readmatrix('global_50kmB_T150_Vsw300_fupper_fobs_output_inu.txt'); 

% 分離欄位
longitude = data(:,1); % 經度
latitude = data(:,2); % 緯度
total_B = data(:,3); % 總磁場強度

% 建立規則格點
lon_vec = linspace(min(longitude), max(longitude), 1000);
lat_vec = linspace(min(latitude), max(latitude), 1000);
[LON, LAT] = meshgrid(lon_vec, lat_vec);

% 插值到規則格點
B_grid = griddata(longitude, latitude, total_B, LON, LAT, 'cubic');
% 繪圖
figure
surf(LON, LAT, B_grid) ;  
shading interp % 平滑色彩
colormap jet
colorbar
xlabel('經度 (deg)')
ylabel('緯度 (deg)')
zlabel('磁場強度')
title('')
set(gca,'YDir','normal') % 緯度由下往上增加
view(225,30) % 調整視角，可自由修改

figure
axesm('robinson', 'Frame', 'on', 'Grid', 'on', 'ParallelLabel', 'on', 'MeridianLabel', 'on');
        % 設定經緯度範圍
setm(gca, 'MapLatLimit', [min(latitude) max(latitude)],'MapLonLimit', [(min(longitude)-180) (max(longitude)-180)]);
        % 在投影上畫磁場強度
surfm(LAT, LON, B_grid);
colormap jet;
colorbar;
%log數值呈現