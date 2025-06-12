clc
clearvars
close all

i=1;
datafolder = "data_folder/";
filter = '90kmB';

listing = dir(datafolder);
tbl = struct2table(listing);
tbl.date = datetime(tbl.datenum,ConvertFrom="datenum");
tbl = removevars(tbl,"datenum");
nameddata = tbl(~matches(tbl.name,[".",".."]),:);
datasize = size(nameddata,1);

[UpperLimit,LowerLimit] = FindLimit("data_folder/",3,filter);


while i <= datasize
    Name = string(nameddata.name(i));
    YuupoPlot_fun('data_folder/',Name(1),1,2,3,UpperLimit,LowerLimit,filter,true)
    i=i+1;
end