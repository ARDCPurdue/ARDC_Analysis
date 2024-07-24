%% End Visit
% This script should be run at the end of a visit to save relevant
% metadata and comments about the testing.
% Author: Samantha Hauser
% Date Created: 6/25/24
% Last updated: 7/23/24 (v1)

%% Clear and set-up directories
clear;
clc;
close all;

%% Global Variables
global fields

%% More fields to add
% General comments about the patient

%% Set defaults
% Set defaults for metadata dropdowns
% Most relevant dropdowns that will need to be changed, should be changed
% in the DataSheets folder (CSV files), NOT here.

addpath('DataSheets')

% Read in IRB data
IRBs = readtable('IRBs.csv', 'TextType','string');
dropdown_lab = table2array(IRBs(:,"PI"));
dropdown_IRB = table2array(IRBs(:,"IRBnum"));

% Read in data about the measures (measure, device, protocol it's a part of)
MEAS = readtable('Measures.csv', 'TextType','string');

% Other standard dropdowns, not read from CSV. Could be edited if needed.
dropdown_gender = {'Male', 'Female', 'Non-binary', 'No Response'};  % Replace with your options
dropdown_amplification = {'None', 'Hearing Aids', 'Cochlear Implant','Other'};

% Get all locations
all_locs = dir("DataSheets\Equipment_*");
for i = 1:numel(all_locs)
    locations(i) = extractBetween(all_locs(i).name, 'Equipment_', '_');
    rms(i) = extractBetween(all_locs(i).name, sprintf('Equipment_%s_', locations{i}), '.csv'); 
end
unique_locations = unique(locations); 
% If useful to have release versions of the code, update here:
fields.releaseVersion = 'v1';

% To do: Make a dropdown for protocols based on measures csv.

%% Create the app figure
% Dimensions/Parameters for app
params.app_width = 1100;
params.app_height = 700;

% Global dimentions/parameters
params.input_width = 200;
params.input_height = 25;
params.border = 10;
params.sect_height = 2*params.input_height;
params.inpsz = 20;

% Create the app and a panel for it.
app = uifigure('Name','Visit Data', 'Position',[100, 100, params.app_width, params.app_height]);
p_app = uipanel(app, 'Title', 'Enter Visit Data', 'TitlePosition', 'centertop',...
    'Position', [5,5, params.app_width-10, params.app_height-10], 'BackgroundColor', '#555960', ...
    'ForegroundColor', 'k' , 'FontSize', 16, 'FontWeight', 'bold');

%% Subject Information Section: Create the panel and inputs
% Dimensions/Parameters
numSections = 4;
x = 5;
y = 230-params.sect_height:-params.sect_height:0;

% If this data is needed elsewhere.
params.p_subject.numSections = numSections;
params.p_subject.x = x;
params.p_subject.y = y;

% Create the panel
p_subject = uipanel(p_app, 'Title', 'Subject', 'TitlePosition', 'centertop', ...
    'Position', [params.border/2, 435, params.input_width+params.border,225], ...
    "BackgroundColor", '#9d9795', 'FontWeight', 'bold');

% Create the fields w/in the panel
labels_general(1) = uilabel(p_subject,'Text','ARDC ID#', 'Position',[x, y(1), params.input_width, params.input_height]);
fields.subjID = uieditfield(p_subject,'Value','ARDC', 'Position',[x, y(1)-params.inpsz, params.input_width, params.input_height]);
labels_general(2) = uilabel(p_subject,'Text','Age (yrs)', 'Position',[x, y(2), params.input_width, params.input_height]);
fields.age = uieditfield(p_subject, 'Value','', 'Position',[x, y(2)-params.inpsz, params.input_width, params.input_height]);
labels_general(3) = uilabel(p_subject,'Text','Gender', 'Position',[x, y(3), params.input_width, params.input_height]);
fields.gender = uidropdown(p_subject, 'Items',dropdown_gender, 'Position',[x, y(3)-params.inpsz, params.input_width, params.input_height]);
labels_general(4) = uilabel(p_subject, 'Text', 'Amplification?', 'Position',[x, y(4), params.input_width, params.input_height]);
fields.amplification = uidropdown(p_subject, 'Items', dropdown_amplification, 'Position', [x, y(4)-params.inpsz, params.input_width, params.input_height]);

%% Study Information Section: Create the panel and inputs
% Dimensions/Parameters
x = 5;
y = 430-params.sect_height:-params.sect_height:0;

% Create panel
p_study = uipanel(p_app, 'Title', 'Study Info', 'TitlePosition', 'centertop', ...
    'Position', [params.border/2, params.border/2, params.input_width+params.border,425], ...
    "BackgroundColor", '#9d9795', 'FontWeight', 'bold');

% Create inputs
label_date = uilabel(p_study, 'Text','Test Date (YYYY-MM-DD)', 'Position',[x(1), y(1), params.input_width, params.input_height]);
fields.testDate = uidatepicker(p_study,"Value",datetime('today'),'DisplayFormat','yyyy-MM-dd', 'Position',[x(1), y(1)-params.inpsz, params.input_width, params.input_height]);
labels_general(4) = uilabel(p_study,'Text','Referring Lab', 'Position',[x(1), y(2), params.input_width, params.input_height]);
fields.IRBnum = uieditfield(p_study, 'Value', IRBs.IRBnum(1), 'Position', [x(1), y(2) - params.inpsz*2-10, params.input_width, params.input_height]);
fields.referring = uidropdown(p_study, 'Items', dropdown_lab, 'Position', [x(1), y(2)-params.inpsz, params.input_width, params.input_height]);

y(3:end) = y(3:end) - 30;
labels_general(5) = uilabel(p_study,'Text','ARDR Signed?', 'Position',[x(1), y(3), params.input_width, params.input_height]);
fields.ARDR = uidropdown(p_study, 'Items',{'Yes', 'No', 'Unknown'},'Position',[x(1), y(3)-params.inpsz, params.input_width, params.input_height]);
labels_general(6) = uilabel(p_study,'Text','Researcher', 'Position',[x(1), y(4), params.input_width, params.input_height]);
fields.Researcher = uieditfield(p_study, 'Value','', 'Position',[x(1), y(4)-params.inpsz, params.input_width, params.input_height]);
labels_general(7) = uilabel(p_study, 'Text', 'Other researchers', 'Position',[x(1), y(5), params.input_width, params.input_height]);
fields.ResearcherOther = uieditfield(p_study, 'Value', '', 'Position', [x(1), y(5)-params.inpsz, params.input_width, params.input_height] );
labels_general(8) =  uilabel(p_study,'Text','ARDC Protocol', 'Position',[x(1), y(6), params.input_width, params.input_height]);
fields.ProtocolName= uidropdown(p_study, 'Items',{'Standard', 'Advanced'},'Position',[x(1), y(6)-params.inpsz, params.input_width, params.input_height]);
labels_general(9) = uilabel(p_study,'Text','Location', 'Position',[x(1), y(7), params.input_width, params.input_height]);
fields.location = uidropdown(p_study, "Items",unique_locations, 'Position', [x(1), y(7)-params.inpsz, params.input_width/2, params.input_height]);
labels_general(10) = uilabel(p_study, "Text", sprintf('ARDC Release: %s', fields.releaseVersion), 'Position',[x(1), y(8), params.input_width, params.input_height]);
fields.location_rm = uidropdown(p_study, "Items",rms(strcmp(locations, fields.location.Value)), 'Position', [x(1)+(params.input_width/2+params.border/2), y(7)-params.inpsz, params.input_width/2-params.border/2, params.input_height]);


% Saving these params in case
params.p_study.x = x;
params.p_study.y = y;

%% Measure info:

%load default data:
measures = table2array(MEAS(ismember(MEAS.(fields.ProtocolName.Value), 1),1));
devices = table2array(MEAS(ismember(MEAS.(fields.ProtocolName.Value), 1), 2));
test_location = fields.location.Value;
test_room = fields.location_rm.Value; 
equip_file = sprintf('Equipment_%s_%s.csv', test_location, test_room);
opts = detectImportOptions(equip_file);
opts = setvaropts(opts, (3:numel(opts.VariableNames)), 'InputFormat','MM/dd/uuuu', 'TreatAsMissing', 'NA');
opts = setvaropts(opts, 2, "Type", 'string');
Equipment = readtable(equip_file, opts);

% Create general panel for all measures
p_measure = uipanel(p_app, 'Title', 'Measures', 'TitlePosition', 'centertop', ...
    'Position', [params.border+params.input_width+params.border, params.border/2+40, (params.input_width*4+params.border*6.5), 615],...
    "BackgroundColor", '#9d9795', 'FontWeight', 'bold');

p_x = 5:params.input_width+params.border*1.5:params.app_width;
p_y = [params.border/2+295 params.border/2];
x = 5;
y = 300-params.sect_height:-params.sect_height:0;

for j = 1:length(measures)
    measure = measures{j};
    device = devices{j};
    if j > 4  % handle if length(measures) > 4 so that there are two rows
        k = 2;
        i = j - 4;
    else
        k = 1;
        i = j;
    end

    p_meas(j) = uipanel(p_measure, 'Title', measure, 'TitlePosition', 'centertop', ...
        'Position', [p_x(i), p_y(k), params.input_width+params.border, 290],...
        "BackgroundColor", '#c4bfc0', 'FontWeight', 'bold');

    %
    serNum = table2array(Equipment(strcmp(device,Equipment.Device), "SerialNum"));
    calDate = table2array(Equipment(strcmp(device,Equipment.Device), end));
    labels.meas.(measure).com = uilabel(p_meas(j), 'Text', 'Comments', 'Position',[x, y(1), params.input_width, params.input_height]);
    fields.meas.(measure).comment = uitextarea(p_meas(j), 'Value', '', 'Position',[x, y(1)-params.input_height-params.inpsz, params.input_width, params.input_height*2]);
    % labels.meas.(measure).protocol = uilabel(p_meas(j), 'Text', 'Protocol', 'Position',[x, y(3), params.input_width, params.input_height]);
    % fields.meas.(measure).protocol = uidropdown(p_meas(j), "Items",{'Conventional', 'Other'}, 'Position',[x, y(3)-params.inpsz, params.input_width, params.input_height]);
    labels.meas.(measure).equipment = uilabel(p_meas(j), 'Text', 'Equipment', 'Position',[x, y(4), params.input_width, params.input_height]');
    fields.meas.(measure).equipment.device = uieditfield(p_meas(j), "Value", device , 'Position',[x, y(4)-params.inpsz, params.input_width, params.input_height-5]);
    fields.meas.(measure).equipment.serialNumber = uieditfield(p_meas(j), "Value", string(serNum) , 'Position',[x, y(4)-2*params.inpsz, params.input_width, params.input_height-5]);
    fields.meas.(measure).equipment.calibDate = uieditfield(p_meas(j), "Value", string(calDate) , 'Position',[x, y(4)-3*params.inpsz, params.input_width, params.input_height-5]);

    % checkbox
    fields.meas.(measure).checkbox = uicheckbox(p_meas(j), 'Text', 'Exclude', 'Position', [190, 5, 15, 15]);
    fields.meas.(measure).checkbox.ValueChangedFcn = @(src, event) toggleMeasureFields(src, event, fields.meas.(measure), p_meas(j));
    labels.meas.(measure).cbLabel = uilabel(p_meas(j), 'Text','Did Not Test', 'Position', [130, 5, 60, 15], 'FontSize', 10);

end

%% Add actions to certain fields and the submit button

% Add a callback to update fields.IRBnum when fields.referring value changes
fields.referring.ValueChangedFcn = @(dropdown,event) updateIRBnum(dropdown, fields.IRBnum, IRBs);

% update equpiment by location
fields.location.ValueChangedFcn = @(dropdown,event) updateEquipment(dropdown, fields, MEAS, locations, rms);
fields.location_rm.ValueChangedFcn = @(dropdown,event) updateRoom(fields, MEAS, locations, rms);

% update measures by protocolName
fields.ProtocolName.ValueChangedFcn = @(dropdown,event) updateMeasures(p_measure,params, dropdown, fields,labels, MEAS);

% when closing the GUI
app.CloseRequestFcn = @(app, event) closeApp(app, fields); 
%% Submitting
% Create submit button
submit_button = uibutton(p_app,'Text','Submit', 'Position', [985, 5, 100, 35], ...
    "ButtonPushedFcn", @(src,event) submitEndVisit(app, fields), ...
    "BackgroundColor", '#cfb991', 'FontSize', 18);

%% checkbox
function toggleMeasureFields(checkbox, event, measureFields, panel)
isEnabled = checkbox.Value;
fields = fieldnames(measureFields);
for i = 1:length(fields)
    if ~strcmp(fields{i}, 'checkbox')
        measureFields.(fields{i}).Enable = isEnabled;
    end
end
if isEnabled
    panel.BackgroundColor = 'k'; % Adjust colors as needed
else
    panel.BackgroundColor = '#c4bfc0';
end
end


