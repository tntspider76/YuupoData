function [UpperLimit,LowerLimit] = FindLimit(location,targetPos,filter)
%input:
%   location : file's location ex. 'data_folder/'
%   targetPos : Fupper data location ex. 3
%   filter : Leave '' if not in use
%output
%   UpperLimit : Upper Limit found
%   LowerLimit : Lower Limit found
arguments (Input)
    location char
    targetPos int16
    filter char
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
nameddata = tbl(~matches(tbl.name,[".","..",".DS_Store"]),:);

for i = 1: height(nameddata)
    Name = string(nameddata.name(i))
    if isempty(filter) || contains(Name,filter)
        try 
            data = readmatrix(fullfile(location,Name));
            if max(data(:,targetPos)) > Upperlim
                Upperlim = max(data(:,targetPos));
            end
            if min(data(:,targetPos)) < Lowerlim
                Lowerlim = min(data(:,targetPos));
            end
        catch ME
            warning('Failed to read file %s: %s', Name, ME.message);
        end
    end
end
    
UpperLimit = Upperlim
LowerLimit = Lowerlim

end