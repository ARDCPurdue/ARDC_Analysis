function [id_list, age_list] = search_age(min_age, max_age,fldr)
% Description: Compiles audiograms with a given hearing loss profile, returns ARDC IDs, and levels. If run
%without arguments, compiles and plots ALL audiograms in a given folder of
%ARDC visit files.
%Input:
%min_age = the lower bound of audibility (dB HL) to include
%max_age = the upper bound of audibility (dB HL) to include 
%fldr = folder with ARDC visit files

%Output:
%id_list = list of subjects of that age
%Written By: Samantha Hauser based on search_audiogram code by Andrew Sivaprakasam
%Last Updated: June 2024

plot_select_flag = 1; 

if ~exist('min_age','var') || isempty(min_age)
    plot_select_flag = 0;
end

if ~exist('max_age','var') || isempty(max_age)
    plot_select_flag = 0;
end

if ~exist('fldr','var') || isempty(fldr)
    fldr = 'C:\Users\ARDC User\Desktop\Compiled';
end

cwd = pwd;
cd(fldr);

%load all files
fnames = {dir(fullfile(cd,'ARDC*.mat')).name};

for i = 1:length(fnames)

    load(fnames{i});
    subjID = visit.subjectID;
    
    id_list(i) = string(subjID);
    age_list(i) = visit.Age; 

end


if plot_select_flag
    in_range = age_list>=min_age & age_list<=max_age; 

    age_list = age_list(1,in_range);
    id_list = id_list(1,in_range);
end

if isempty(age_list)
    cd(cwd);
    error('No data found with specified range');
end

fprintf('%d Subjects found\n',numel(age_list)); 
cd(cwd);

end