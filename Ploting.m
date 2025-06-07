clc
clearvars
close all
listing = dir("data_folder/");
tbl = struct2table(listing);
tbl.date = datetime(tbl.datenum,ConvertFrom="datenum");
tbl = removevars(tbl,"datenum");
nameddata = tbl(~matches(tbl.name,[".",".."]),:);
datasize = size(nameddata,1);
i=1;
while i <= datasize
    Name = string(nameddata.name(i));
    disp(Name(1))
    YuupoPlot_fun('data_folder/',Name(1),1,2,3,'global_50km',true)
    i=i+1;
end
