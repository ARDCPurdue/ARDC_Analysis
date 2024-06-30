%% End Visit
% This script should be run at the end of a visit to save relevant
% metadata and comments about the testing.
% Author: Samantha Hauser
% Date Created: 6/25/24

%TODO: (from AS/BH/AGS) Should we be saving time to the minute? Current saving of 
%datetime doesn't have this info -- SH: I think hour/min would be more
%useful attached to the individual measure. 

%% Clear and set-up directories
clear;
clc;
close all;

%Be sure to update the dataPath as needed.
dataPath = 'C:\Users\ARDC User\Desktop\DATA'; % use this
% for debugging
%dataPath = '/Users/lizzyjensen/Desktop/Code/ARDC/ARDC_Analysis/Analysis and Preprocessing';
origPath = pwd;

%% More fields to add 
% General comments about the patient 
% otoscopy result
% HA? CI%  


%% Set defaults
% These can/should also be stored in CSVs instead
% Set defaults for metadata dropdowns
IRBs = readtable('IRBs.csv', 'TextType','string'); 
dropdown_lab = table2array(IRBs(:,"PI")); 
dropdown_IRB = table2array(IRBs(:,"IRBnum")); 

opts = detectImportOptions('Equipment.csv');
opts = setvaropts(opts,"CalibDate",'inputFormat','MM/dd/uuuu');
Equipment = readtable('Equipment.csv', opts); 

dropdown_gender = {'Male', 'Female', 'Non-binary', 'No Response'};  % Replace with your options
fields.relVer = 'v1'; 

%% Dimensions
app_width = 1200; 
app_height = 650; 

width = 200; 
height = 25; 
x = 25:225:app_width - width -10; 
y = app_height-75:-50:0;
inpsz = 20; 

% Create the app figure
app = uifigure('Name','Subject Information', 'Position',[100, 100, app_width, app_height]);

%Define labels and edit text fields
% Subject info: 
p_subject = uipanel(app, 'Title', 'Subject', 'TitlePosition', 'lefttop', 'Position', [x(1)-10, 445, width+20, height.*7]); 
labels_general(1) = uilabel(app,'Text','ARDC ID#', 'Position',[x(1), y(1), width, height]);
fields.subjID = uieditfield(app,'Value','ARDC', 'Position',[x(1), y(1)-inpsz, width, height]);
labels_general(2) = uilabel(app,'Text','Age (yrs)', 'Position',[x(1), y(2), width, height]);
fields.age = uieditfield(app, 'Value','', 'Position',[x(1), y(2)-inpsz, width, height]);
labels_general(3) = uilabel(app,'Text','Gender', 'Position',[x(1), y(3), width, height]);
fields.gender = uidropdown(app, 'Items',dropdown_gender, 'Position',[x(1), y(3)-inpsz, width, height]);

y = y + 20; 
% Study info: 
p_study = uipanel(app, 'Title', 'Study Info', 'TitlePosition', 'lefttop', 'Position', [x(1)-10, 115-100, width+20, height.*17]); 
label_date = uilabel(app, 'Text','Test Date (YYYY-MM-DD)', 'Position',[x(1), y(5), width, height]); 
fields.testDate = uidatepicker(app,"Value",datetime('today'),'DisplayFormat','yyyy-MM-dd', 'Position',[x(1), y(5)-inpsz, width, height]); 
labels_general(4) = uilabel(app,'Text','Referring Lab', 'Position',[x(1), y(6), width, height]);
fields.IRBnum = uieditfield(app, 'Value', IRBs.IRBnum(1), 'Position', [x(1), y(6) - inpsz*2-10, width, height]); 
fields.referring = uidropdown(app, 'Items', dropdown_lab, 'Position', [x(1), y(6)-inpsz, width, height]);

% Add a callback to update fields.IRBnum when fields.referring value changes
fields.referring.ValueChangedFcn = @(dropdown,event) updateIRBnum(dropdown, fields.IRBnum, IRBs);

y = y -30; 
labels_general(5) = uilabel(app,'Text','ARDR Signed?', 'Position',[x(1), y(7), width, height]);
fields.ARDR = uidropdown(app, 'Items',{'Yes', 'No', 'Unknown'},'Position',[x(1), y(7)-inpsz, width, height]);
labels_general(6) = uilabel(app,'Text','Researcher', 'Position',[x(1), y(8), width, height]);
fields.Researcher = uieditfield(app, 'Value','', 'Position',[x(1), y(8)-inpsz, width, height]);
labels_general(7) = uilabel(app, 'Text', 'Other researchers', 'Position',[x(1), y(9), width, height]); 
fields.ResearcherOther = uieditfield(app, 'Value', '', 'Position', [x(1), y(9)-inpsz, width, height] ); 
labels_general(8) =  uilabel(app,'Text','ARDC Protocol', 'Position',[x(1), y(10), width, height]);
fields.ARDCrelVer = uidropdown(app, 'Items',{'Standard', 'Advanced', 'Other'},'Position',[x(1), y(10)-inpsz, width, height]);
labels_general(9) = uilabel(app,'Text','Location', 'Position',[x(1), y(11), width, height]);
fields.location = uidropdown(app, "Items",unique(table2array(Equipment(:,'Location'))), 'Position', [x(1), y(11)-inpsz, width, height]); 
labels_general(10) = uilabel(app, "Text", sprintf('ARDC Release: %s', fields.relVer), 'Position',[x(1), y(12), width, height]); 

% Measure info: 
p_measure = uipanel(app, 'Title', 'Measures', 'TitlePosition', 'lefttop', 'Position', [x(2)-10, 115-50, width*4.6, 555]); 

y = app_height -75:-50:0;
x = 250:180:app_width; 
width = 175; 

init_equip = Equipment(strcmp(Equipment.Location, fields.location.Value), 1:4);

measures = unique(init_equip.Measure); 
for j = 1:length(measures) % handle if length(measures) > 5
    measure = measures{j}; 
    device = table2array(init_equip(strcmp(init_equip.Measure, measure), "Device"));
    serNum = table2array(init_equip(strcmp(init_equip.Measure, measure), "SerialNum"));
    calDate = table2array(init_equip(strcmp(init_equip.Measure, measure), "CalibDate"));
    labels.(measure).name = uilabel(app, 'Text', measure, 'Position', [x(j), y(1), width, height], 'FontWeight', 'bold');
    labels.(measure).com = uilabel(app, 'Text', 'Comments', 'Position',[x(j), y(1)-inpsz, width, height]);
    fields.(measure).comment = uitextarea(app, 'Value', '', 'Position',[x(j), y(1)-height-inpsz*2, width, height*2]);
    labels.(measure).protocol = uilabel(app, 'Text', 'Protocol', 'Position',[x(j), y(3), width, height]);
    fields.(measure).protocol = uidropdown(app, "Items",{'Conventional', 'Other'}, 'Position',[x(j), y(3)-inpsz, width, height]);
    labels.(measure).equipment = uilabel(app, 'Text', 'Equipment', 'Position',[x(j), y(4), width, height]');
    fields.(measure).equipment.device = uieditfield(app, "Value", device{1,1} , 'Position',[x(j), y(4)-inpsz, width, height]);
    fields.(measure).equipment.serialNumber = uieditfield(app, "Value", string(serNum) , 'Position',[x(j), y(4)-2*inpsz, width, height]);
    fields.(measure).equipment.calibDate = uieditfield(app, "Value", string(calDate) , 'Position',[x(j), y(4)-3*inpsz, width, height]);
end

% update equpiment by location 
fields.location.ValueChangedFcn = @(dropdown,event) updateEquipment(dropdown, fields, Equipment); 

% Create submit button
submit_button = uibutton(app,'Text','Submit', 'Position', [550, 25, 100, 30], ...
    "ButtonPushedFcn", @(src,event) submit_action(app, fields, dataPath, origPath, measures), ...
    "BackgroundColor", 'g', 'FontSize', 18);

%% Relevant functions for button press:
% When Submit btn is pressed, saves the values entered in a "comments"
% structure which can then be added to the final compiled format. 

function submit_action(app, fields, dataPath, origPath, measures)
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

for k = 1:length(measures)
    data.(measures{k}).comments = get(fields.(measures{k}).comment, 'Value');
    data.(measures{k}).protocol = get(fields.(measures{k}).protocol, 'Value');
    data.(measures{k}).equipment.device = get(fields.(measures{k}).equipment.device, 'Value');
    data.(measures{k}).equipment.calibDate = get(fields.(measures{k}).equipment.calibDate, 'Value');
    data.(measures{k}).equipment.serialNumber = get(fields.(measures{k}).equipment.serialNumber, 'Value');
end

%Should we save the time (minutes/hours??)
study.location = 'Purdue LYLE3069'; 
comp_time = datetime('now');
comp_time.Format = 'MMddyyyy';
study.dateCompiled = comp_time; 

%For filename...we should use study date?? so it all gets compiled - AS/LJ
% SH: I agree fixed. 
testDate = study.testDate;
testDate.Format = 'MMddyyyy';
study.testDate = testDate;

%cd(dataPath)
filename = strcat(subj.ID,'_',string(study.testDate),'_COM');

% if data should go to certain folders, set where it goes here: 

save(filename, 'study', 'data', 'subj'); 
cd(origPath);
close(app)
end

%% Other functions needed for callbacks: 

% Update IRB number based on the PI that was selected. 
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

% function to decide what equipment sheet to use based on the location. 
% update when changing fields.location
function updateEquipment(locationDropdown, fields, Equipment)
    selectedLocation = locationDropdown.Value; 
    equip_list = Equipment(strcmp(Equipment.Location, selectedLocation),:);
    for i = 1:size(equip_list,1)
        meas = table2array(equip_list(i,"Measure")); 
        meas = meas{1,1}; 
        device = equip_list.Device(i);
        calDate = equip_list.CalibDate(i); 
        serNum = equip_list.SerialNum(i); 
        fields.(meas).equipment.device.Value = device{1,1};
        fields.(meas).equipment.serialNumber.Value = string(serNum);
        fields.(meas).equipment.calibDate.Value = string(calDate);
    end
end