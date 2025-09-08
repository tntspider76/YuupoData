clc
clearvars
close all

Bu = [];
Bv = []; 
Bw = [];
files = {'Vector/0.txt'};
% = {'Vector/0.txt','Vector/10.txt'};
%heights = [0, 10]; 
heights = [0]; 
longitude = []; % 經度
latitude = []; % 緯度
Z = [];
for f = 1:length(files)
    data = readmatrix(files{f});
    for i=1:height(data)
        if mod(data(i,1),10) == 0.5 && mod(data(i,2),10) == 0
            longitude = [longitude;data(i,1)]; % 經度
            latitude = [latitude;data(i,2)]; % 緯度
            Bu = [Bu;data(i,3)]; % 總磁場強度
            Bv = [Bv;data(i,4)]; % 總磁場強度
            Bw = [Bw;data(i,5)]; % 總磁場強度
            Z  = [Z;  heights(f)];
        end
    end
end
mag = sqrt(Bu.^2 + Bv.^2 + Bw.^2);
Bu = Bu ./ mag;
Bv = Bv ./ mag;
Bw = Bw ./ mag;


magZ = Bw; % 使用 Z 分量
magZnorm = magZ / max(abs(magZ));

cmap = jet(256);
colorIdx = round((magZnorm + 1) / 2 * 255) + 1;

f1 = figure(Theme="light"); hold on;
for k = 1:length(Bu)
    quiver(longitude(k)/10, latitude(k)/10, Bu(k), Bv(k), 0, ...
        'Color', cmap(colorIdx(k),:), 'LineWidth', 0.5, 'Marker',".");
end
colormap(cmap);
colorbar;
clim([-1 1]);
xlim([0 36]);
ylim([-9 9]);
xlabel('Longitude/10');
ylabel('Latitude/10');
title('2D Magnetic Field (Color Represents Z Component)');



A=1;
if A==0
    f2 = figure(Theme="light");
    quiver3(longitude, latitude, Z, Bu, Bv, Bw,0); 
    axis([min(longitude) max(longitude) ...
        min(latitude)  max(latitude)  ...
        -10 10]);       % 視情況調整Z範圍
    xlabel('Longitude');
    ylabel('Latitude');
    %zlabel('Altitude (km)');
    title('Magnetic Field Directions Only');
end

