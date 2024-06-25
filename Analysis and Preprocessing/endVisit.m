%% End Visit
% This script should be run at the end of a visit to save relevant
% metadata and comments about the testing. 
% Author: Samantha Hauser
% Date Created: 6/25/24
%% 

clear;
clc;
close all;

%Be sure to update the dataPath as needed. 
dataPath = 'C:\Users\ARDC User\Desktop\DATA';

orig_path = pwd;
%% Relevant Metadata that is set by default
info.univ = 'Purdue'; 
info.room = 'LYLE3069'; 

%% Ask for additional Metadata

prompt = {'Subject ID: ','Researcher Name: '};
defaults = {'',''}; 
entries = inputdlg(prompt); 
researcher = entries{2};

start_time = datetime('now');
start_time.Format = 'MMddyyyy';
filename = strcat(entries{1},'_',string(start_time),'_comments');

%check for duplicates
files = dir(fullfile(dataDir,'*.mat'));

%% Save to data drive

cd(dataPath)
save([filename,'.mat'],'-struct','info');

cd(orig_path);