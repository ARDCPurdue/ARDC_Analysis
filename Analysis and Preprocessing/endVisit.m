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
addpath('DataSheets')
IRBs = readtable('IRBs.csv', 'TextType','string');
dropdown_lab = table2array(IRBs(:,"PI"));
dropdown_IRB = table2array(IRBs(:,"IRBnum"));

MEAS = readtable('Measures.csv', 'TextType','string');

dropdown_gender = {'Male', 'Female', 'Non-binary', 'No Response'};  % Replace with your options
dropdown_amplification = {'None', 'Hearing Aids', 'Cochlear Implant', 'Other'};
fields.relVer = 'v1';

%% Dimensions
app_width = 1130;
app_height = 700;

width = 200;
height = 25;
sect_height = 2*height;
x = 25:225:app_width - width -10;
y = app_height-75:-sect_height:0;

inpsz = 20;
border = 20;
pborder = 55;
% Create the app figure
app = uifigure('Name','Subject Information', 'Position',[100, 100, app_width, app_height]);
p_app = uipanel(app, 'Title', 'Enter Visit Data', 'TitlePosition', 'centertop',...
    'Position', [5,5, app_width-10, app_height-10], 'BackgroundColor', '#cfb991', ...
    'ForegroundColor', 'k' , 'FontSize', 16, 'FontWeight', 'bold');

%Define labels and edit text fields
% Subject info:
numSects = 4;
p_subject = uipanel(app, 'Title', 'Subject', 'TitlePosition', 'centertop', ...
    'Position', [x(1)-border/2, app_height-pborder-(numSects*sect_height), width+border,(numSects*sect_height+border)], ...
    "BackgroundColor", '#c4bfc0', 'FontWeight', 'bold');
labels_general(1) = uilabel(app,'Text','ARDC ID#', 'Position',[x(1), y(1), width, height]);
fields.subjID = uieditfield(app,'Value','ARDC', 'Position',[x(1), y(1)-inpsz, width, height]);
labels_general(2) = uilabel(app,'Text','Age (yrs)', 'Position',[x(1), y(2), width, height]);
fields.age = uieditfield(app, 'Value','', 'Position',[x(1), y(2)-inpsz, width, height]);
labels_general(3) = uilabel(app,'Text','Gender', 'Position',[x(1), y(3), width, height]);
fields.gender = uidropdown(app, 'Items',dropdown_gender, 'Position',[x(1), y(3)-inpsz, width, height]);
labels_general(4) = uilabel(app, 'Text', 'Amplification?', 'Position',[x(1), y(4), width, height]);
fields.amplification = uidropdown(app, 'Items', dropdown_amplification, 'Position', [x(1), y(4)-inpsz, width, height]);

% Study info:
y = app_height-90-(numSects*sect_height+border):-sect_height:0;
numSects = 8;
p_study = uipanel(app, 'Title', 'Study Info', 'TitlePosition', 'lefttop', ...
    'Position', [x(1)-border/2, border/2+5, width+border,(numSects*sect_height+border)], ...
    "BackgroundColor", '#c4bfc0', 'FontWeight', 'bold');
%'Position', [x(1)-10, 115-140, width+20, height.*17]);
label_date = uilabel(app, 'Text','Test Date (YYYY-MM-DD)', 'Position',[x(1), y(1), width, height]);
fields.testDate = uidatepicker(app,"Value",datetime('today'),'DisplayFormat','yyyy-MM-dd', 'Position',[x(1), y(1)-inpsz, width, height]);
labels_general(4) = uilabel(app,'Text','Referring Lab', 'Position',[x(1), y(2), width, height]);
fields.IRBnum = uieditfield(app, 'Value', IRBs.IRBnum(1), 'Position', [x(1), y(2) - inpsz*2-10, width, height]);
fields.referring = uidropdown(app, 'Items', dropdown_lab, 'Position', [x(1), y(2)-inpsz, width, height]);

% Add a callback to update fields.IRBnum when fields.referring value changes
fields.referring.ValueChangedFcn = @(dropdown,event) updateIRBnum(dropdown, fields.IRBnum, IRBs);
y = y - 30;
labels_general(5) = uilabel(app,'Text','ARDR Signed?', 'Position',[x(1), y(3), width, height]);
fields.ARDR = uidropdown(app, 'Items',{'Yes', 'No', 'Unknown'},'Position',[x(1), y(3)-inpsz, width, height]);
labels_general(6) = uilabel(app,'Text','Researcher', 'Position',[x(1), y(4), width, height]);
fields.Researcher = uieditfield(app, 'Value','', 'Position',[x(1), y(4)-inpsz, width, height]);
labels_general(7) = uilabel(app, 'Text', 'Other researchers', 'Position',[x(1), y(5), width, height]);
fields.ResearcherOther = uieditfield(app, 'Value', '', 'Position', [x(1), y(5)-inpsz, width, height] );

% set action for changing protocol:
labels_general(8) =  uilabel(app,'Text','ARDC Protocol', 'Position',[x(1), y(6), width, height]);
fields.ProtocolName= uidropdown(app, 'Items',{'Standard', 'Advanced', 'Other'},'Position',[x(1), y(6)-inpsz, width, height]);

labels_general(9) = uilabel(app,'Text','Location', 'Position',[x(1), y(7), width, height]);
all_locs = dir("DataSheets\Equipment_*");
for i = 1:numel(all_locs)
    locations(i) = extractBetween(all_locs(i).name, 'Equipment_', '.csv');
end
fields.location = uidropdown(app, "Items",locations, 'Position', [x(1), y(7)-inpsz, width, height]);
labels_general(10) = uilabel(app, "Text", sprintf('ARDC Release: %s', fields.relVer), 'Position',[x(1), y(8)+5, width, height]);

%% Measure info:

%load default data:
measures = table2array(MEAS(ismember(MEAS.Standard, 1),1));
devices = table2array(MEAS(ismember(MEAS.Standard, 1), 2));
test_site = fields.location.Value;
equip_file = sprintf('Equipment_%s.csv', test_site);
opts = detectImportOptions(equip_file);
opts = setvaropts(opts, (3:numel(opts.VariableNames)), 'InputFormat','MM/dd/uuuu', 'TreatAsMissing', 'NA');
opts = setvaropts(opts, 2, "Type", 'string');
Equipment = readtable(equip_file, opts);

% Create panels
p_measure = uipanel(app, 'Title', 'Measures', 'TitlePosition', 'lefttop', ...
    'Position', [x(2)-border/2, border+5+30, (width*4+border*4), (12*sect_height+2*border -(border+10))],...
    "BackgroundColor", '#555960', 'FontWeight', 'bold');

p_width = 200;
p_x = 5:p_width+border:app_width;
p_y = [border+280 10];
width = 190;
height = 25;
sect_height = 2*height;
x =  p_x+5;

numSects = 11;
for j = 1:length(measures) % handle if length(measures) > 5
    measure = measures{j};
    device = devices{j};
    if j > 4
        k = 2;
        i = j - 4;
        y = 255:-sect_height:0;

    else
        k = 1;
        i = j;
        y = app_height-150:-sect_height:300;
    end
    % p_meas(j) = uipanel(p_measure, 'Title', measure, 'TitlePosition', 'centertop', ...
    %         'Position', [p_x(i)-border/2, p_y(k), (p_width+border/2), (numSects*height+border/2)],...
    %     "BackgroundColor", '#c4bfc0', 'FontWeight', 'bold');
    p_meas(j) = uipanel(p_measure, 'Title', measure, 'TitlePosition', 'centertop', ...
        'Position', [p_x(i), p_y(k), (p_width+border/2), (numSects*height+border/2)],...
        "BackgroundColor", '#c4bfc0', 'FontWeight', 'bold');
    serNum = table2array(Equipment(strcmp(device,Equipment.Device), "SerialNum"));
    calDate = table2array(Equipment(strcmp(device,Equipment.Device), end));
    labels.meas.(measure).com = uilabel(p_measure, 'Text', 'Comments', 'Position',[x(i), y(1)-4, width, height]);
    fields.meas.(measure).comment = uitextarea(p_measure, 'Value', '', 'Position',[x(i), y(1)-height-inpsz-4, width, height*2]);
    labels.meas.(measure).protocol = uilabel(p_measure, 'Text', 'Protocol', 'Position',[x(i), y(3), width, height]);
    fields.meas.(measure).protocol = uidropdown(p_measure, "Items",{'Conventional', 'Other'}, 'Position',[x(i), y(3)-inpsz, width, height]);
    labels.meas.(measure).equipment = uilabel(p_measure, 'Text', 'Equipment', 'Position',[x(i), y(4), width, height]');
    fields.meas.(measure).equipment.device = uieditfield(p_measure, "Value", device , 'Position',[x(i), y(4)-inpsz, width, height-5]);
    fields.meas.(measure).equipment.serialNumber = uieditfield(p_measure, "Value", string(serNum) , 'Position',[x(i), y(4)-2*inpsz, width, height-5]);
    fields.meas.(measure).equipment.calibDate = uieditfield(p_measure, "Value", string(calDate) , 'Position',[x(i), y(4)-3*inpsz, width, height-5]);
end

% update equpiment by location
fields.location.ValueChangedFcn = @(dropdown,event) updateEquipment(dropdown, fields, MEAS);

% update measures by protocolName
fields.ProtocolName.ValueChangedFcn = @(dropdown,event) updateMeasures(p_measure, dropdown, fields,labels, MEAS, Equipment);

% Create submit button
submit_button = uibutton(app,'Text','Submit', 'Position', [550, 15, 100, 30], ...
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
function updateEquipment(locationDropdown, fields, MEAS)
selectedLocation = locationDropdown.Value;
measures = table2array(MEAS(ismember(MEAS.Standard, 1),1));
devices = table2array(MEAS(ismember(MEAS.Standard, 1), 2));

equip_file = sprintf('Equipment_%s.csv', selectedLocation);
opts = detectImportOptions(equip_file);
opts = setvaropts(opts, (3:numel(opts.VariableNames)), 'InputFormat','MM/dd/uuuu', 'TreatAsMissing', 'NA');
opts = setvaropts(opts, 2, "Type", 'string');
Equipment = readtable(equip_file, opts);

for i = 1:size(measures,1)
    meas = measures(i);
    device = devices(i);
    serNum = table2array(Equipment(strcmp(device,Equipment.Device), "SerialNum"));
    calDate = table2array(Equipment(strcmp(device,Equipment.Device), end));
    fields.(meas).equipment.device.Value = device;
    fields.(meas).equipment.serialNumber.Value = string(serNum);
    fields.(meas).equipment.calibDate.Value = string(calDate);
end
end


% function to decide what measures to use based on the protocol selected.
% update when changing fields.ProtocolName
function updateMeasures(p_measure, protocolDropdown, fields,labels, MEAS, Equipment)
selectedProtocol = protocolDropdown.Value;
measures = table2array(MEAS(ismember(MEAS.(selectedProtocol), 1),1));
devices = table2array(MEAS(ismember(MEAS.(selectedProtocol), 1), 2));

fields = rmfield(fields, "meas");
labels = rmfield(labels, "meas");
delete(p_measure.Children)
app_width = 1130;
app_height = 700;

inpsz = 20;
border = 20;
pborder = 55;
p_width = 200;

p_x = 5:p_width+border:app_width;
p_y = [border+280 10];
width = 190;
height = 25;
sect_height = 2*height;
x =  p_x+5;

numSects = 11;
for j = 1:length(measures) % handle if length(measures) > 5
    measure = measures{j};
    device = devices{j};
    if j > 4
        k = 2;
        i = j - 4;
        y = 255:-sect_height:0;

    else
        k = 1;
        i = j;
        y = app_height-150:-sect_height:300;
    end
    % p_meas(j) = uipanel(p_measure, 'Title', measure, 'TitlePosition', 'centertop', ...
    %         'Position', [p_x(i)-border/2, p_y(k), (p_width+border/2), (numSects*height+border/2)],...
    %     "BackgroundColor", '#c4bfc0', 'FontWeight', 'bold');
    p_meas(j) = uipanel(p_measure, 'Title', measure, 'TitlePosition', 'centertop', ...
        'Position', [p_x(i), p_y(k), (p_width+border/2), (numSects*height+border/2)],...
        "BackgroundColor", '#c4bfc0', 'FontWeight', 'bold');
    serNum = table2array(Equipment(strcmp(device,Equipment.Device), "SerialNum"));
    calDate = table2array(Equipment(strcmp(device,Equipment.Device), end));
    labels.meas.(measure).com = uilabel(p_measure, 'Text', 'Comments', 'Position',[x(i), y(1)-4, width, height]);
    fields.meas.(measure).comment = uitextarea(p_measure, 'Value', '', 'Position',[x(i), y(1)-height-inpsz-4, width, height*2]);
    labels.meas.(measure).protocol = uilabel(p_measure, 'Text', 'Protocol', 'Position',[x(i), y(3), width, height]);
    fields.meas.(measure).protocol = uidropdown(p_measure, "Items",{'Conventional', 'Other'}, 'Position',[x(i), y(3)-inpsz, width, height]);
    labels.meas.(measure).equipment = uilabel(p_measure, 'Text', 'Equipment', 'Position',[x(i), y(4), width, height]');
    fields.meas.(measure).equipment.device = uieditfield(p_measure, "Value", device , 'Position',[x(i), y(4)-inpsz, width, height-5]);
    fields.meas.(measure).equipment.serialNumber = uieditfield(p_measure, "Value", string(serNum) , 'Position',[x(i), y(4)-2*inpsz, width, height-5]);
    fields.meas.(measure).equipment.calibDate = uieditfield(p_measure, "Value", string(calDate) , 'Position',[x(i), y(4)-3*inpsz, width, height-5]);
end

end