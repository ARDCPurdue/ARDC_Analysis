%Written By: Andrew Sivaprakasam
%Last Updated: May 2023

function [outputArg1,outputArg2] = search_audiograms()
%TODO:
%-default directory
%-frequency range
%-date range?
%-plotting toggle
%-efficient reading

cwd = pwd;

%temp default directory
fldr = '/media/sivaprakasaman/AndrewNVME/Pitch_Study/F30_Full_Data/ARDC_compiledVisits/ALL_ARDC';
cd(fldr);

%load all files
fnames = {dir(fullfile(cd,'ARDC*.mat')).name};

for i = 1:length(fnames)
    
    load(fnames{i});
    subjID = visit.subjectID;
%     Lfreqs{i} =  ;
%     Rfreqs{i} =
end



cd(cwd);

end