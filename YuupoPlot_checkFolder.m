function [] = YuupoPlot_checkFolder(MinAlt,MaxAlt,dataDistence)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    MinAlt
    MaxAlt
    dataDistence
end

arguments (Output)
end

firstLayer = ["fig","png"];
secondLayer = ["surf","2D","vector"];
thirdLayer  = linspace(MinAlt,MaxAlt,((MaxAlt - MinAlt)/dataDistence)+1);

for i = 1:length(firstLayer)
    if ~exist(firstLayer(i),'dir'), mkdir(firstLayer(i)); end
    for j = 1:length(secondLayer)
        Ndir = append(firstLayer(i),"/",secondLayer(j));
        if ~exist(Ndir,'dir'), mkdir(Ndir); end
        for k = 1:length(thirdLayer)
            Ndir = append(firstLayer(i),"/",secondLayer(j),"/",string(thirdLayer(k)));
            if ~exist(Ndir,'dir'), mkdir(Ndir); end
        end
    end
end
end