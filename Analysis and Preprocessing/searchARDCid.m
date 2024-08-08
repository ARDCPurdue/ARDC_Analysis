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
testdate = extractBetween(files(1).name, '_', '.mat'); 
testdate = datetime(testdate{1}, 'InputFormat', 'MMddyyyy'); 
fields.testDate.Value = datetime(testdate, 'Format', 'yyyy-MM-dd'); 
 fields.Researcher.Value = string(visit.researcher); 
fields.Location.Value = 'Purdue'; 

end