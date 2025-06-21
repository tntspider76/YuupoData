clc
clearvars
close all

datafolder = 'data_folder/';
filter = '90kmB';
DataPos = 3;
zlabelPos = 6

tbl = struct2table(dir(datafolder));
tbl = removevars(tbl,"datenum");
nameddata = tbl(~matches(tbl.name,[".","..",".DS_Store"]),:);

[UpperLimit,LowerLimit] = FindLimit(datafolder,DataPos,filter);

for i = 1:height(nameddata)
    Name = string(nameddata.name(i));
    YuupoPlot_fun(datafolder,Name(1),1,2,DataPos,zlabelPos,UpperLimit,LowerLimit,filter,true,false) %YuupoPlot_fun(location,fileName,X,Y,TargetStrengh,ColorBarLimitUpper,ColorBarLimitLower,filter,Plot2D)
end