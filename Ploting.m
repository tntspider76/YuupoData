clc
clearvars
close all

datafolder = 'Fupper/';
filter = '';
DataPos = 7;

tbl = struct2table(dir(datafolder));
tbl = removevars(tbl,"datenum");
nameddata = tbl(~matches(tbl.name,[".","..",".DS_Store"]),:);

[UpperLimit,LowerLimit] = FindLimit(datafolder,DataPos,filter);

for i = 1:height(nameddata)
    Name = string(nameddata.name(i));
    YuupoPlot_fun(datafolder,Name(1),1,2,DataPos,4,UpperLimit,LowerLimit,filter,true,true) %YuupoPlot_fun(location,fileName,X,Y,TargetStrengh,ColorBarLimitUpper,ColorBarLimitLower,filter,Plot2D)
end