clc; clearvars; close all

files = 'Ravatetal_JGR2020_LunarL1MagneticModelFields_LPgrad.dat';
data = readmatrix(files);

cmap = [0.75 0 1;
    0.25 0 1;
    0 0.25 1;
    0 0.75 1;
    0 1 0.5;
    0.25 1 0;
    0.75 1 0;
    1 0.75 0;
    1 0.25 0];

% 1) 讀取並單位轉成 nT（你的檔看起來是 µT）
lon = data(:,1);
lat = data(:,2);
Btot   = data(:,3) * 100;
Br     = data(:,4) * 100;
Btheta = data(:,5) * 100;
Bphi   = data(:,6) * 100;

% 2) 把經度包到 [-180,180]，避免 0/360 撕裂
lon = wrapTo180(lon);

% 3) 建立規則格網(不假設原始排列)，用索引拼回矩陣
lon_u = unique(lon);
lat_u = unique(lat);
nlon = numel(lon_u);
nlat = numel(lat_u);

[~, idx_lon] = ismember(lon, lon_u);
[~, idx_lat] = ismember(lat, lat_u);

toGrid = @(v) accumarray([idx_lat, idx_lon], v, [nlat, nlon], @mean, NaN);

G = struct();
G.Btot   = toGrid(Btot);
G.Br     = toGrid(Br);
G.Btheta = toGrid(Btheta);
G.Bphi   = toGrid(Bphi);

[LON, LAT] = meshgrid(lon_u, lat_u);
fields = {G.Btot, G.Br , G.Btheta, G.Bphi};
titles = {'B_{tot}', 'B_{r}', 'B_{\theta}', 'B_{\phi}'};

for i = 1:4
    figure(Theme="light");
    axesm('robinson','Frame','on','Grid','on','ParallelLabel','on','MeridianLabel','on','maplonlimit',[-180 180]);
    setm(gca,'MapLatLimit',[min(lat) max(lat)], 'MapLonLimit',[min(lon) max(lon)]);
    pcolorm(LAT, LON, fields{i});
    shading flat; tightmap
    title(fields{i});
    cb = colorbar;
    ticks = [-400 -200 -10 -5 -1 1 5 10 200 400];
    cb.Ticks = ticks;
    cb.TickLabels = arrayfun(@(x) sprintf('%g',x), ticks, 'UniformOutput', false);
    cb.Label.String = 'nT';
    clim([-400 400]);
    colormap(cmap);
    title(titles{i});
end