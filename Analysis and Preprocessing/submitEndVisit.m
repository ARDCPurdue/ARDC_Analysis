%% Relevant functions for button press:
% When Submit btn is pressed, saves the values entered in a "comments"
% structure which can then be added to the final compiled format.

function submitEndVisit(app, fields)

global fields

% Subject information
subj.ID = get(fields.subjID, 'Value');
subj.age = get(fields.age, 'Value');
subj.gender = get(fields.gender, 'Value');
subj.amplification = get(fields.amplification, 'Value'); 

% Study information
study.testDate = get(fields.testDate, 'Value');
study.referringLab = get(fields.referring, 'Value');
study.irbNumber = get(fields.IRBnum, 'Value');
ardr_yes = get(fields.ARDR, 'Value');
if strcmp(ardr_yes, 'Yes')
    study.ARDRsigned = 1;
else
    study.ARDRsigned = 0;
end
study.researcher = get(fields.Researcher, 'Value');
study.researcherOther = get(fields.ResearcherOther, 'Value');
study.studyProtocol = get(fields.ProtocolName, 'Value'); 
study.location = get(fields.location, 'Value'); 
study.room = get(fields.location_rm, 'Value'); 

% Data for each measure
measures = fieldnames(fields.meas); 
for k = 1:length(measures)
    if ~fields.meas.(measures{k}).checkbox.Value
        data.Measure.(measures{k}).comments = get(fields.meas.(measures{k}).comment, 'Value');
        %data.(measures{k}).protocol = get(fields.(measures{k}).protocol, 'Value');
        data.Measure.(measures{k}).equipment.device = get(fields.meas.(measures{k}).equipment.device, 'Value');
        data.Measure.(measures{k}).equipment.calibDate = get(fields.meas.(measures{k}).equipment.calibDate, 'Value');
        data.Measure.(measures{k}).equipment.serialNumber = get(fields.meas.(measures{k}).equipment.serialNumber, 'Value');
    end
end

% Metadata about compiling
comp_time = datetime('now');
compiled_version = fields.releaseVersion; 
study.dateCompiled = comp_time;
study.testDate.Format = 'MMddyyyy';

%cd(dataPath)

% do we want to save this separate? 
%save(filename, 'study', 'data', 'subj');

% compile with raw data
compile_visit_wCOM(data, study, subj); 

% close app and make sure the global variable is cleared for no other
% issues
closeApp(app, fields)
end