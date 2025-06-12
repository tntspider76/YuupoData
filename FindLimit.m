function [UpperLimit,LowerLimit] = FindLimit(location,target,filter)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    location
    target
    filter
end

arguments (Output)
    UpperLimit
    LowerLimit
end
Upperlim = 0;
Lowerlim = 0;
listing = dir(location);
tbl = struct2table(listing);
tbl.date = datetime(tbl.datenum,ConvertFrom="datenum");
tbl = removevars(tbl,"datenum");
nameddata = tbl(~matches(tbl.name,[".",".."]),:);
datasize = size(nameddata,1);

i=1;
while i <= datasize
    Name = string(nameddata.name(i));
    if findstr(Name,filter) == 0
    elseif findstr(Name,filter) ~= 0
        data = readmatrix(fullfile(location,Name));
        if max(data(:,target)) > Upperlim
            Upperlim = max(data(:,target));
        end
    
        if min(data(:,target)) < Lowerlim
            Lowerlim = min(data(:,target));
        end
        
    end
    i=i+1;
end
    
    UpperLimit = Upperlim
    LowerLimit = Lowerlim

end