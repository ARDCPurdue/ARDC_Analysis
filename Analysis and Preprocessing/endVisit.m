%% End Visit
% This script should be run at the end of a visit to save relevant
% metadata and comments about the testing.
% Author: Samantha Hauser
% Date Created: 6/25/24


%%%%%% 
% Metadata to add 
% Whether or not they signed ARDR
% Check metadata for individual measures (protocols, headphone types, etc) 


%%%%%%%
%% Clear and set-up directories
clear;
clc;
close all;

%Be sure to update the dataPath as needed.
%dataPath = 'C:\Users\ARDC User\Desktop\DATA'; % use this
% for debugging
dataPath = 'C:\Users\saman\Desktop\Code\ARDC_Analysis\Analysis and Preprocessing';
origPath = pwd;

%% Set defaults for metadata dropdowns
dropdown_lab = {'ARDC Lab', 'J. Alexander', 'H. Bharadwaj', 'Other'};  % Replace with your options
dropdown_gender = {'Male', 'Female', 'Non-binary', 'No Response'};  % Replace with your options

%% Ask for additional Metadata
prompt = {'Researcher Name: ', 'Referring Lab: ', 'Subject ID: ', 'Gender: '};

% Create the app figure
app = uifigure('Name','Subject Information', 'Units','centimeters');

% Define labels and edit text fields
labels(1) = uilabel(app,'Text',prompt{1,1}, 'Position',[75, 375, 200, 25]);
fields(1) = uieditfield(app,'Value','', 'Position',[75, 325, 200, 25]);

labels(2) = uilabel(app,'Text',prompt{1,2}, 'Position',[75, 275, 200, 25]);
fields(2) = uidropdown(app, 'Items',dropdown_lab, 'Position',[75, 225, 200, 25]);

labels(3) = uilabel(app,'Text',prompt{1,3}, 'Position',[275, 375, 200, 25]);
fields(3) = uieditfield(app,'Value','', 'Position',[275, 325, 200, 25]);

labels(4) = uilabel(app,'Text',prompt{1,4}, 'Position',[275, 275, 200, 25]);
fields(4) = uidropdown(app, 'Items',dropdown_gender, 'Position',[275, 225, 200, 25]);

% Create submit button
submit_button = uibutton(app,'Text','Submit', 'Position', [150, 100, 200, 25], ...
    "ButtonPushedFcn", @(src,event) submit_action(app, fields, dataPath, origPath));

%% Relevant functions for button press:
% When Submit btn is pressed, saves the values entered in a "comments"
% structure which can then be added to the final compiled format. 

function submit_action(app, fields, dataPath, origPath)
result.researcher = get(fields(1), 'Value');
result.referringPI = get(fields(2), 'Value');
result.subjID = get(fields(3), 'Value');
result.subjGender = get(fields(4), 'Value');

start_time = datetime('now');
start_time.Format = 'MMddyyyy';

result.univ = 'Purdue';
result.room = 'LYLE3069';

cd(dataPath)
filename = strcat(result.subjID,'_',string(start_time),'_comments');
save(filename, 'result')
cd(origPath);
close(app)
end