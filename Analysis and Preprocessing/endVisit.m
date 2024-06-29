%% End Visit
% This script should be run at the end of a visit to save relevant
% metadata and comments about the testing.
% Author: Samantha Hauser
% Date Created: 6/25/24

%% Clear and set-up directories
clear;
clc;
close all;

%Be sure to update the dataPath as needed.
%dataPath = 'C:\Users\ARDC User\Desktop\DATA'; % use this
% for debugging
dataPath = 'C:\Users\saman\Desktop\Code\ARDC_Analysis\Analysis and Preprocessing';
origPath = pwd;

%% More fields to add 
% General comments about the patient 
% otoscopy result
% HA? CI%  


%% Set defaults
relVer = 'v1'; 

%% Dimensions
width = 200; 
height = 25; 
x = 25:225:800; 
y = 575:-50:0;
inpsz = 20; 

% Set defaults for metadata dropdowns
IRBs = readtable('IRBs.csv', 'TextType','string'); 
dropdown_lab = table2array(IRBs(:,"PI")); 
dropdown_IRB = table2array(IRBs(:,"IRBnum")); 
dropdown_gender = {'Male', 'Female', 'Non-binary', 'No Response'};  % Replace with your options
fields.relVer = 'v1'; 
% Create the app figure
app = uifigure('Name','Subject Information', 'Position',[100, 100, 1200, 650]);

%Define labels and edit text fields

% Subject info: 
p_subject = uipanel(app, 'Title', 'Subject', 'TitlePosition', 'lefttop', 'Position', [x(1)-10, 445, width+20, height.*7]); 
labels(1) = uilabel(app,'Text','ARDC ID#', 'Position',[x(1), y(1), width, height]);
fields.subjID = uieditfield(app,'Value','ARDC', 'Position',[x(1), y(1)-inpsz, width, height]);
labels(2) = uilabel(app,'Text','Age (yrs)', 'Position',[x(1), y(2), width, height]);
fields.age = uieditfield(app, 'Value','', 'Position',[x(1), y(2)-inpsz, width, height]);
labels(3) = uilabel(app,'Text','Gender', 'Position',[x(1), y(3), width, height]);
fields.gender = uidropdown(app, 'Items',dropdown_gender, 'Position',[x(1), y(3)-inpsz, width, height]);

y = y + 20; 
% Study info: 
p_study = uipanel(app, 'Title', 'Study Info', 'TitlePosition', 'lefttop', 'Position', [x(1)-10, 115-100, width+20, height.*17]); 
label_date = uilabel(app, 'Text','Test Date (YYYY-MM-DD)', 'Position',[x(1), y(5), width, height]); 
fields.testDate = uidatepicker(app,"Value",datetime('today'),'DisplayFormat','yyyy-MM-dd', 'Position',[x(1), y(5)-inpsz, width, height]); 
labels(4) = uilabel(app,'Text','Referring Lab', 'Position',[x(1), y(6), width, height]);
fields.IRBnum = uieditfield(app, 'Value', IRBs.IRBnum(1), 'Position', [x(1), y(6) - inpsz*2-10, width, height]); 
fields.referring = uidropdown(app, 'Items', dropdown_lab, 'Position', [x(1), y(6)-inpsz, width, height]);

% Add a callback to update fields.IRBnum when fields.referring value changes
fields.referring.ValueChangedFcn = @(dropdown,event) updateIRBnum(dropdown, fields.IRBnum, IRBs);

% Define the callback function
function updateIRBnum(referringDropdown, irbnumEditField, irbData)
    selectedLab = referringDropdown.Value;
    idx = find(strcmp(irbData.PI, selectedLab));
    if ~isempty(idx)
        irbNumber = irbData.IRBnum(idx);
        irbnumEditField.Value = irbNumber;
    else
        irbnumEditField.Value = 'IRB not found'; % Handle if lab not found in IRB data
    end
end


y = y -30; 
labels(5) = uilabel(app,'Text','ARDR Signed?', 'Position',[x(1), y(7), width, height]);
fields.ARDR = uidropdown(app, 'Items',{'Yes', 'No', 'Unknown'},'Position',[x(1), y(7)-inpsz, width, height]);
labels(6) = uilabel(app,'Text','Researcher', 'Position',[x(1), y(8), width, height]);
fields.Researcher = uieditfield(app, 'Value','', 'Position',[x(1), y(8)-inpsz, width, height]);
labels(7) = uilabel(app, 'Text', 'Other researchers', 'Position',[x(1), y(9), width, height]); 
fields.ResearcherOther = uieditfield(app, 'Value', '', 'Position', [x(1), y(9)-inpsz, width, height] ); 
labels(8) =  uilabel(app,'Text','ARDC Protocol', 'Position',[x(1), y(10), width, height]);
fields.ARDCrelVer = uidropdown(app, 'Items',{'Standard', 'Advanced', 'Other'},'Position',[x(1), y(10)-inpsz, width, height]);
labels(9) = uilabel(app,'Text','Location', 'Position',[x(1), y(11), width, height]);
fields.location = uidropdown(app, "Items",{'Purdue LYLE 3069', 'APARC-Indy'}, 'Position', [x(1), y(11)-inpsz, width, height]);
labels(10) = uilabel(app, "Text", sprintf('ARDC Release: %s', relVer), 'Position',[x(1), y(12), width, height]); 

y = 575:-50:0;
% Measure info: 
p_measure = uipanel(app, 'Title', 'Measures', 'TitlePosition', 'lefttop', 'Position', [x(2)-10, 115-50, width*4, 555]); 

% Audiogram
labels(10) = uilabel(app, 'Text', 'Audiogram', 'Position', [x(2), y(1), width, height], 'FontWeight', 'bold'); 
labels(11) = uilabel(app, 'Text', 'Comments', 'Position',[x(2), y(1)-inpsz, width, height]);
fields.audio.comment = uitextarea(app, 'Value', '', 'Position',[x(2), y(1)-height-inpsz*2, width, height*2]); 
labels(12) = uilabel(app, 'Text', 'Protocol', 'Position',[x(2), y(3), width, height]); 
fields.audio.protocol = uidropdown(app, "Items",{'Conventional', 'CPA', 'VRA'}, 'Position',[x(2), y(3)-inpsz, width, height]); 
labels(13) = uilabel(app, 'Text', 'Equipment', 'Position',[x(2), y(4), width, height]'); 
labels(14) = uilabel(app, "Text", 'Audiostar Pro', 'Position',[x(2), y(4)-inpsz, width, height]);

% QuickSIN
labels(15) = uilabel(app, 'Text', 'QuickSIN', 'Position', [x(2), y(5), width, height], 'FontWeight', 'bold'); 
labels(16) = uilabel(app, 'Text', 'Comments', 'Position',[x(2), y(5)-inpsz, width, height]);
fields.QS.comment = uitextarea(app, 'Value', '', 'Position',[x(2), y(5)-height-inpsz*2, width, height*2]); 
labels(17) = uilabel(app, 'Text', 'Protocol', 'Position',[x(2), y(7), width, height]); 
fields.QS.protocol = uidropdown(app, "Items",{'Standard', 'UCL-5', 'Other'}, 'Position',[x(2), y(7)-inpsz, width, height]); 
labels(18) = uilabel(app, 'Text', 'Equipment', 'Position',[x(2), y(8), width, height]'); 
labels(19) = uilabel(app, "Text", 'Audiostar Pro', 'Position',[x(2), y(8)-inpsz, width, height]);

% DPOAEs
labels(20) = uilabel(app, 'Text', 'DPOAEs', 'Position', [x(3), y(1), width, height], 'FontWeight', 'bold'); 
labels(21) = uilabel(app, 'Text', 'Comments', 'Position',[x(3), y(1)-inpsz, width, height]);
fields.dp.comment = uitextarea(app, 'Value', '', 'Position',[x(3), y(1)-height-inpsz*2, width, height*2]); 
labels(22) = uilabel(app, 'Text', 'Protocol', 'Position',[x(3), y(3), width, height]); 
fields.dp.protocol = uidropdown(app, "Items",{'Standard', 'Other'}, 'Position',[x(3), y(3)-inpsz, width, height]); 
labels(23) = uilabel(app, 'Text', 'Equipment', 'Position',[x(3), y(4), width, height]'); 
labels(24) = uilabel(app, "Text", 'Titan', 'Position',[x(3), y(4)-inpsz, width, height]);

% WBT
labels(25) = uilabel(app, 'Text', 'Tymps', 'Position', [x(3), y(5), width, height], 'FontWeight', 'bold'); 
labels(26) = uilabel(app, 'Text', 'Comments', 'Position',[x(3), y(5)-inpsz, width, height]);
fields.wbt.comment = uitextarea(app, 'Value', '', 'Position',[x(3), y(5)-height-inpsz*2, width, height*2]); 
labels(27) = uilabel(app, 'Text', 'Protocol', 'Position',[x(3), y(7), width, height]); 
fields.wbt.protocol = uidropdown(app, "Items",{'Standard', 'Other'}, 'Position',[x(3), y(7)-inpsz, width, height]); 
labels(28) = uilabel(app, 'Text', 'Equipment', 'Position',[x(3), y(8), width, height]'); 
labels(29) = uilabel(app, "Text", 'Titan', 'Position',[x(3), y(8)-inpsz, width, height]);

% Reflexes
labels(30) = uilabel(app, 'Text', 'Reflexes', 'Position', [x(4), y(1), width, height], 'FontWeight', 'bold'); 
labels(31) = uilabel(app, 'Text', 'Comments', 'Position',[x(4), y(1)-inpsz, width, height]);
fields.memr.comment = uitextarea(app, 'Value', '', 'Position',[x(4), y(1)-height-inpsz*2, width, height*2]); 
labels(32) = uilabel(app, 'Text', 'Protocol', 'Position',[x(4), y(3), width, height]); 
fields.memr.protocol = uidropdown(app, "Items",{'Standard', 'Other'}, 'Position',[x(4), y(3)-inpsz, width, height]); 
labels(33) = uilabel(app, 'Text', 'Equipment', 'Position',[x(4), y(4), width, height]'); 
labels(34) = uilabel(app, "Text", 'Titan', 'Position',[x(4), y(4)-inpsz, width, height]);

% Create submit button
submit_button = uibutton(app,'Text','Submit', 'Position', [550, 25, 100, 30], ...
    "ButtonPushedFcn", @(src,event) submit_action(app, fields, dataPath, origPath), ...
    "BackgroundColor", 'g', 'FontSize', 18);

%% Relevant functions for button press:
% When Submit btn is pressed, saves the values entered in a "comments"
% structure which can then be added to the final compiled format. 

function submit_action(app, fields, dataPath, origPath)
subj.ID = get(fields.subjID, 'Value'); 
subj.age = get(fields.age, 'Value'); 
subj.gender = get(fields.gender, 'Value'); 

study.testDate = get(fields.testDate, 'Value'); 
study.referringLab = get(fields.referring, 'Value'); 
study.irbNumber = get(fields.IRBnum, 'Value'); 
ardryes = get(fields.ARDR); 
if strcmp(ardryes, 'Yes')
    study.ARDRsigned = 1; 
else
    study.ARDRsigned = 0; 
end
study.researcher = get(fields.Researcher, 'Value');
study.researcherOther = get(fields.ResearcherOther, 'Value');
%study.ARDCprotocol = get(fields.protocol, 'Value'); 
% study.ARDCreleaseVersion = get(fields.version, 'Value'); 

data.audiogram.comments = get(fields.audio.comment, 'Value'); 
data.audiogram.protocol = get(fields.audio.protocol, 'Value'); 
% data.audiogram.equipment = get(fields.audio.equipment, 'Value'); 

data.QuickSIN.comments = get(fields.QS.comment, 'Value'); 
data.QuickSIN.protocol = get(fields.QS.protocol, 'Value'); 
% data.QuickSIN.equipment = get(fields.QS.equipment, 'Value'); 

data.DPOAE.comments = get(fields.dp.comment, 'Value'); 
data.DPOAE.protocol = get(fields.dp.protocol, 'Value'); 
% data.DPOAE.equipment = get(fields.dp.equipment, 'Value'); 

data.WBT.comments = get(fields.wbt.comment, 'Value'); 
data.WBT.protocol = get(fields.wbt.protocol, 'Value'); 
% data.WBT.equipment = get(fields.wbt.equipment, 'Value'); 

data.MEMR.comments = get(fields.memr.comment, 'Value'); 
data.MEMR.protocol = get(fields.memr.protocol, 'Value'); 
% data.MEMR.equipment = get(fields.memr.equipment, 'Value'); 

study.location = 'Purdue LYLE3069'; 
comp_time = datetime('now');
comp_time.Format = 'MMddyyyy';
study.dateCompiled = comp_time; 

cd(dataPath)
filename = strcat(subj.ID,'_',string(comp_time),'_comments');

% if data should go to certain folders, set where it goes here: 

save(filename, 'study', 'data', 'subj'); 
cd(origPath);
close(app)
end