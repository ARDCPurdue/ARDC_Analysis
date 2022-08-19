function [idStrings] = getUniqueVisitID(dataDir)
%This could use some improvement...not efficient but gets the job done
%checks the entire data directory and subdirectories 
    fnames = dir(strcat([dataDir,'*\*\*']));
    nms = {fnames.name}';
    pat = '(?<subjID>\d+)_(?<date>\d+)';
    idinfo = regexp(nms,pat,'names');
    allids = cell(length(idinfo),1);
    
    %this is dumb...if Windows supported UNIX wouldn't have to do this
    for i = 1:length(idinfo)
        allids{i} = [idinfo{i}.subjID,'_',idinfo{i}.date];
    end    
    temp = unique(allids);
    for i = 1:length(temp)
        if(~strcmp(temp{i},'_'))
            idStrings{i} = temp{i};
        end
    end
    idStrings = idStrings';
end

