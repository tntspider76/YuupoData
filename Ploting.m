clc
clearvars
close all

i=1;
datafolder = "data_folder/";
filter = '75kmB';

listing = dir(datafolder);
tbl = struct2table(listing);
tbl.date = datetime(tbl.datenum,ConvertFrom="datenum");
tbl = removevars(tbl,"datenum");
nameddata = tbl(~matches(tbl.name,[".",".."]),:);

[UpperLimit,LowerLimit] = FindLimit(datafolder,3,filter);

for i = 1:height(nameddata)
    Name = string(nameddata.name(i));
    YuupoPlot_fun(datafolder,Name(1),1,2,3,UpperLimit,LowerLimit,filter,true) %YuupoPlot_fun(location,fileName,X,Y,TargetStrengh,ColorBarLimitUpper,ColorBarLimitLower,filter,Plot2D)
end