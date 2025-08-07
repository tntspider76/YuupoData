close all 
clc
clearvars

MaxAlt = 100;
MinAlt = 50;
dataDistence = 5;

firstLayer = ["test1","test2"];
secondLayer = ["surf","2D"];
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

%if ~exist('fig','dir'), mkdir('fig'); end
