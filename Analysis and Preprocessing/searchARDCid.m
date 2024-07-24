function searchARDCid(app, fields)

global fields

currDir = pwd; 
allCompiledDataDir = 'C:\Users\ARDC User\Desktop\Compiled'; 
subj = fields.subjID.Value; 
files = dir(fullfile(allCompiledDataDir, sprintf('%s_*.mat', subj)))
cd(allCompiledDataDir)
load(files(1).name)
cd(currDir); 
fields.age.Value = string(visit.Age); 
% date = extractBetween(files(1).name, '_', '.mat'); 
% date = datetime(date{1}, 'InputFormat', 'MMddyyyy'); 
% date = date.Format('uuuu-MM-dd'); 
fields.testDate.Value = datetime(date, 'yyyy-MM-dd'); 
 fields.Researcher.Value = string(visit.researcher); 
fields.Location.Value = 'Purdue'; 

end