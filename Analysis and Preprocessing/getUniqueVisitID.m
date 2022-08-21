function [subjectID,idStrings] = getUniqueVisitID(dataDir)
%This could use some improvement...not efficient but gets the job done
%checks the entire data directory and subdirectories 
    fnames = dir(strcat([dataDir,'*/*/*']));
    nms = {fnames.name}';
    pat = '(?<subjID>\w+)_(?<date>\d+)';
    idinfo = regexp(nms,pat,'names');

    %this is dumb...if Windows supported UNIX wouldn't have to do this
    ind = 0;
    for i = 1:length(idinfo)
        if ~isempty(idinfo{i})
            ind = ind + 1;
            allids{ind} = [idinfo{i}.subjID,'_',idinfo{i}.date];
            allsubs{ind} = idinfo{i}.subjID;
        end
    end    
    idStrings = unique(allids)';
    subjectID = unique(allsubs)';
end

