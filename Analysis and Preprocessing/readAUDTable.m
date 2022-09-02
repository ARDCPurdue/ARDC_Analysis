function [dataOut] = readAUDTable(sect)
%This function takes in a 'chunk' of regex separated data and parses it for
%values. It can handle 2 or 3 columns, designed to handle masked data.
%Returns a 3 column row of NaNs if space is empty/un parse-able

allrows = splitlines(string(sect));

try
    for i = 1:length(allrows)
        
        if length(strfind(allrows(i),' '))==2
            dbEM(i) = NaN;
            out = textscan(allrows(i), '%d %d %s');
            freq(i) = out{1};
            dbHL(i) = out{2};
            
        elseif length(strfind(allrows(i),' '))==3
            out = textscan(allrows(i), '%d %d %d %s');
            freq(i) = out{1};
            dbHL(i) = out{2};
            dbEM(i) = out{3};
        end
        
    end
    
    dataOut = [double(freq'),double(dbHL'),double(dbEM')];
catch
    dataOut = [NaN,NaN,NaN];
end

end

