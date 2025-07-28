function simpleVisitEditor()

%%%%% STUFF TO EDIT FOR A USER %%%%%
dataDir = "C:\Users\saman\Desktop\Code\ARDC_Analysis\";
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load .mat file (you can customize the path)
[file,path] = uigetfile(sprintf('%s*.mat', dataDir),'Select the MAT-file');

% Actually load that file
loaded = load(fullfile(path, file));

if ~isfield(loaded, 'visit')
    error('The selected file does not contain a ''visit'' structure.');
end

visit = loaded.visit;

dateOfTest = datetime(extractBetween(file, '_', '.mat'), 'InputFormat', 'MMddyyyy');

% ==== Initialize Visit ====
% Set initial data structure
Subject.ID = "";
Subject.age = "";
Subject.gender = "";
Subject.amplification = "";
VisitInfo.testDate = "";
VisitInfo.referringLab = "";
VisitInfo.irbNumber = "";
VisitInfo.ARDRsigned = "";
VisitInfo.researcher = "";
VisitInfo.researcherOther = "";
VisitInfo.studyProtocol = "";
VisitInfo.location = "";
VisitInfo.room = "";
VisitInfo.dateComplied = "";
VisitInfo.testDate = dateOfTest;


Measures.Audiometry.AC.R = [];
Measures.Audiometry.AC.L = [];
Measures.Audiometry.BC.R = [];
Measures.Audiometry.BC.L = [];
Measures.Audiometry.equipment.AC_transducer = "";
Measures.Audiometry.equipment.BC_transducer = "";
Measures.Audiometry.equipment.AC_HardwareLimits = "";
Measures.Audiometry.equipment.BC_HardwareLimits = "";
Measures.Audiometry.equipment.device = "";
Measures.Audiometry.equipment.calibDate = "";
Measures.Audiometry.equipment.serialNumber = "";
Measures.Audiometry.comments = "";

Measures.QuickSIN.R = "";
Measures.QuickSIN.L = "";
Measures.QuickSIN.Bin = "";
Measures.QuickSIN.equipment.device = "";
Measures.QuickSIN.equipment.calibDate = "";
Measures.QuickSIN.equipment.serialNumber = "";
Measures.QuickSIN.comments = "";

Measures.DPOAE.R.noisefloor = "";
Measures.DPOAE.R.mean_response = "";
Measures.DPOAE.R.f1 = "";
Measures.DPOAE.R.f2 = "";
Measures.DPOAE.R.DP = "";
Measures.DPOAE.R.f1_rec_dB = "";
Measures.DPOAE.R.f2_rec_dB = "";
Measures.DPOAE.R.fs = "";
Measures.DPOAE.L.noisefloor = "";
Measures.DPOAE.L.mean_response = "";
Measures.DPOAE.L.f1 = "";
Measures.DPOAE.L.f2 = "";
Measures.DPOAE.L.DP = "";
Measures.DPOAE.L.f1_rec_dB = "";
Measures.DPOAE.L.f2_rec_dB = "";
Measures.DPOAE.L.fs = "";
Measures.DPOAE.other.researcher  = "";
Measures.DPOAE.equipment.device = "";
Measures.DPOAE.equipment.calibDate = "";
Measures.DPOAE.equipment.serialNumber = "";
Measures.DPOAE.comments = "";

Measures.Reflexes.Frequencies = [500 1e3 2e3 4e3];
Measures.Reflexes.ProbeR.Ipsi = "";
Measures.Reflexes.ProbeR.Contra = "";
Measures.Reflexes.ProbeL.Ipsi = "";
Measures.Reflexes.ProbeL.Contra = "";
Measures.Reflexes.equipment.device = "";
Measures.Reflexes.equipment.calibDate = "";
Measures.Reflexes.equipment.serialNumber = "";
Measures.Reflexes.comments = "";

Measures.WRS.R.speechLevel = "";
Measures.WRS.R.maskingLevel = "";
Measures.WRS.R.numberWordCorrect = "";
Measures.WRS.R.totalWordsPresented = "";
Measures.WRS.R.list = "";
Measures.WRS.R.listNumber = "";
Measures.WRS.R.percentCorrect = "";
Measures.WRS.L.speechLevel = "";
Measures.WRS.L.maskingLevel = "";
Measures.WRS.L.numberWordCorrect = "";
Measures.WRS.L.totalWordsPresented = "";
Measures.WRS.L.list = "";
Measures.WRS.L.listNumber = "";
Measures.WRS.L.percentCorrect = "";
Measures.WRS.equipment.device = "";
Measures.WRS.equipment.calibDate = "";
Measures.WRS.equipment.serialNumber = "";
Measures.WRS.comments = "";

Measures.ACT.scores = "";
Measures.ACT.comments = "";
Measures.ACT.equipment.device = "";
Measures.ACT.equipment.calibDate = "";
Measures.ACT.equipment.serialNumber = "";

Measures.WBT.L.PRESSURE = "";
Measures.WBT.L.FREQ = "";
Measures.WBT.L.ABSORBANCE = "";
Measures.WBT.R.PRESSURE = "";
Measures.WBT.R.FREQ = "";
Measures.WBT.R.ABSORBANCE = "";
Measures.WBT.comments = "";
Measures.WBT.equipment.device = "";
Measures.WBT.equipment.calibDate = "";
Measures.WBT.equipment.serialNumber = "";

Measures.Otoscopy.comments = "";
Measures.Otoscopy.equipment = "";

% ===== Fill in what's there from orig visit ====
if isfield(visit, 'subjectID')
    Subject.ID = visit.subjectID;
    VisitInfo.researcher = visit.researcher;
elseif isfield(visit, 'Subject')
    Subject.ID = visit.Subject.ID;
    Subject.age = visit.Subject.age;
    Subject.gender = visit.Subject.gender;
    Subject.amplification = visit.Subject.amplification;
end

% % Data for each measure
% if isfield(visit, 'Measures')
%     meas = fieldnames(visit.Measures);
%     for f = 1:length(meas)
%
%         % Check For Audiogram Data
%         if contains(meas{f}, 'audio', 'IgnoreCase', 1)
%             Measures.Audiometry.AC.R = visit.Measures.(meas{f}).AC.R;
%             Measures.Audiometry.AC.L = visit.Measures.(meas{f}).AC.L;
%             Measures.Audiometry.BC.R = visit.Measures.(meas{f}).BC.R;
%             Measures.Audiometry.BC.L = visit.Measures.(meas{f}).BC.L;
%
%             if isfield(visit.Measures.(meas{f}), 'equipment')
%                 Measures.Audiometry.equipment.AC_transducer = visit.Measures.(meas{f}).equipment.AC_transducer;
%                 Measures.Audiometry.equipment.BC_transducer = visit.Measures.(meas{f}).equipment.BC_transducer;
%                 Measures.Audiometry.equipment.AC_HardwareLimits = visit.Measures.(meas{f}).equipment.AC_HardwareLimits;
%                 Measures.Audiometry.equipment.BC_HardwareLimits = visit.Measures.(meas{f}).equipment.BC_HardwareLimits;
%                 Measures.Audiometry.equipment.device = visit.Measures.(meas{f}).equipment.device;
%                 Measures.Audiometry.equipment.calibDate = visit.Measures.(meas{f}).equipment.calibDate;
%                 Measures.Audiometry.equipment.serialNumber = visit.Measures.(meas{f}).equipment.serialNumber;
%                 Measures.Audiometry.comments = visit.Measures.(meas{f}).comments;
%             else
%                 Measures.Audiometry.equipment.AC_transducer = visit.Measures.(meas{f}).AC_transducer;
%                 Measures.Audiometry.equipment.BC_transducer = visit.Measures.(meas{f}).BC_transducer;
%                 Measures.Audiometry.equipment.AC_HardwareLimits = visit.Measures.(meas{f}).AC_HardwareLimits;
%                 Measures.Audiometry.equipment.BC_HardwareLimits = visit.Measures.(meas{f}).BC_HardwareLimits;
%             end
%
%         % Check for QuickSIN Data
%         elseif contains(meas{f}, 'Quick', 'IgnoreCase', 1)
%             Measures.QuickSIN.R = visit.Measures.(meas{f}).R;
%             Measures.QuickSIN.L = visit.Measures.(meas{f}).L;
%             try
%                 Measures.QuickSIN.Bin = visit.Measures.(meas{f}).Bin;
%             catch
%                 Measures.QuickSIN.Bin = "";
%             end
%
%             Measures.QuickSIN.equipment.device = visit.Measures.(meas{f}).equipment.device;
%             Measures.QuickSIN.equipment.calibDate = visit.Measures.(meas{f}).equipment.calibDate;
%             Measures.QuickSIN.equipment.serialNumber = visit.Measures.(meas{f}).equipment.serialNumber;
%             Measures.QuickSIN.comments = visit.Measures.(meas{f}).comments;
%
%         % Check for DPOAE Data
%         elseif contains(meas{f}, 'dpoae', 'IgnoreCase', 1)
%             Measures.DPOAE.R = visit.Measures.(meas{f}).R;
%             Measures.DPOAE.L = visit.Measures.(meas{f}).L;
%             Measures.DPOAE.other.researcher  = visit.Measures.(meas{f}).other.researcher;
%             try
%                 Measures.DPOAE.equipment = visit.Measures.(meas{f}).equipment;
%                 Measures.DPOAE.comments = visit.Measures.(meas{f}).comments;
%             end
%
%         % Check for Reflexes Data
%         elseif contains(meas{f}, 'Reflex', 'IgnoreCase', 1)
%             Measures.Reflexes.ProbeR = visit.Measures.(meas{f}).ProbeR;
%             Measures.Reflexes.ProbeL = visit.Measures.(meas{f}).ProbeL;
%             try
%                 Measures.Reflexes.equipment = visit.Measures.(meas{f}).equipment;
%             catch
%                 disp("reflex data does not contain equipment info")
%             end
%
%             try
%                 Measures.Reflexes.comments = visit.Measures.(meas{f}).comments;
%             catch
%                 disp("reflex data does not contain comments")
%             end
%
%         % Check for WRS Data
%         elseif contains(meas{f}, 'WRS', 'IgnoreCase', 1)
%             Measures.WRS.R = visit.Measures.(meas{f}).R;
%             Measures.WRS.L = visit.Measures.(meas{f}).L;
%
%             try
%                 Measures.WRS.equipment= visit.Measures.(meas{f}).equipment;
%                 Measures.WRS.comments = visit.Measures.(meas{f}).comments;
%             end
%
%         % Check for ACT Data
%         elseif contains(meas{f}, 'ACT', 'IgnoreCase', 1)
%             try
%                 Measures.ACT = visit.Measures.ACT;
%             catch
%                 warning("Does not have ACT info")
%             end
%
%         % Check for WBT Data
%         elseif contains(meas{f}, 'WBT', 'IgnoreCase', 1)
%             Measures.WBT.R = visit.Measures.(meas{f}).R;
%             Measures.WBT.L = visit.Measures.(meas{f}).L;
%
%             try
%                 Measures.WBT.equipment = visit.Measures.(meas{f}).equipment;
%                 Measures.WBT.commments = visit.Measures.(meas{f}).comments;
%             catch
%                 disp("Does not have WBT equipment info")
%             end
%
%         % Check for Otoscopy Data
%         elseif contains(meas{f}, 'otoscopy', 'IgnoreCase', 1)
%             Measures.Otoscopy.comments = visit.Measures.Otoscopy.comments;
%             Measures.Otoscopy.equipment = visit.Measures.Otoscopy.equipment;
%         end
%     end
% end


% Create figure window
boxheight = 20;
figheight = 600;
fig = figure('Name', 'Visit Editor', 'Position', [100 100 1200 figheight]);
labelboxwidth = 100;

% ==== SUBJECT INFO ====
uicontrol(fig,'Style','text','String','Subject ID','Position',[20 570 labelboxwidth 20],'HorizontalAlignment','left');
subjID = uicontrol(fig,'Style','edit','String',visit.Subject.ID,'Position',[80 570 100 20]);

uicontrol(fig,'Style','text','String','Age','Position',[20 550 labelboxwidth 20],'HorizontalAlignment','left');
age = uicontrol(fig,'Style','edit','String',num2str(visit.Subject.age),'Position',[80 550 100 20]);

uicontrol(fig,'Style','text','String','Gender','Position',[20 530 labelboxwidth 20],'HorizontalAlignment','left');
gender = uicontrol(fig,'Style','edit','String',visit.Subject.gender,'Position',[80 530 100 20]);

uicontrol(fig,'Style','text','String','Amplification','Position',[20 510 labelboxwidth 20],'HorizontalAlignment','left');
amplification = uicontrol(fig,'Style','edit','String',visit.Subject.amplification,'Position',[80 510 100 20]);

% ==== VISIT INFO ====
uicontrol(fig,'Style','text','String','Test Date','Position',[20 480 labelboxwidth 20],'HorizontalAlignment','left');
testDate = uicontrol(fig, 'Style', 'edit','String', string(VisitInfo.testDate),'Position',[80 480 100 20]);

uicontrol(fig,'Style','text','String','Refer Lab','Position',[20 460 labelboxwidth 20],'HorizontalAlignment','left');
referringLab = uicontrol(fig,'Style','edit','String',VisitInfo.referringLab,'Position',[80 460 100 20]);

uicontrol(fig,'Style','text','String','IRB Number','Position',[20 440 labelboxwidth 20],'HorizontalAlignment','left');
irbNumber = uicontrol(fig,'Style','edit','String',VisitInfo.irbNumber,'Position',[80 440 100 20]);

uicontrol(fig,'Style','text','String','ARDRsigned','Position',[20 420 labelboxwidth 20],'HorizontalAlignment','left');
ARDRsigned = uicontrol(fig,'Style','edit','String',VisitInfo.ARDRsigned,'Position',[80 420 100 20]);

uicontrol(fig,'Style','text','String','researcher','Position',[20 400 labelboxwidth 20],'HorizontalAlignment','left');
researcher = uicontrol(fig,'Style','edit','String',VisitInfo.researcher,'Position',[80 400 100 20]);

uicontrol(fig,'Style','text','String','researcherOther','Position',[20 380 labelboxwidth 20],'HorizontalAlignment','left');
researcherOther = uicontrol(fig,'Style','edit','String',VisitInfo.researcherOther,'Position',[80 380 100 20]);

uicontrol(fig,'Style','text','String','studyProtocol','Position',[20 360 labelboxwidth 20],'HorizontalAlignment','left');
studyProtocol = uicontrol(fig,'Style','edit','String',VisitInfo.studyProtocol,'Position',[80 360 100 20]);

uicontrol(fig,'Style','text','String','location','Position',[20 340 labelboxwidth 20],'HorizontalAlignment','left');
location = uicontrol(fig,'Style','edit','String',VisitInfo.location,'Position',[80 340 100 20]);

uicontrol(fig,'Style','text','String','room','Position',[20 320 labelboxwidth 20],'HorizontalAlignment','left');
room = uicontrol(fig,'Style','edit','String',VisitInfo.room,'Position',[80 320 100 20]);

uicontrol(fig,'Style','text','String','dateComplied','Position',[20 300 labelboxwidth 20],'HorizontalAlignment','left');
dateCompiled = uicontrol(fig,'Style','edit','String',string(VisitInfo.dateComplied),'Position',[80 300 100 20]);

% ==== Audiometry ====
uicontrol(fig,'Style','text','String','Audiometry','Position',[20 280 labelboxwidth 20],'HorizontalAlignment','Center', 'FontWeight', 'bold');

uicontrol(fig,'Style','text','String','AC_trans','Position',[20 260 labelboxwidth 20],'HorizontalAlignment','left');
AC_trans = uicontrol(fig,'Style','edit','String', Measures.Audiometry.equipment.AC_transducer,'Position',[80 260 100 20]);

uicontrol(fig,'Style','text','String','BC_trans','Position',[20 240 labelboxwidth 20],'HorizontalAlignment','left');
BC_trans = uicontrol(fig,'Style','edit','String', Measures.Audiometry.equipment.BC_transducer,'Position',[80 240 100 20]);

uicontrol(fig,'Style','text','String','AC_Limit','Position',[20 220 labelboxwidth 20],'HorizontalAlignment','left');
AC_Limit = uicontrol(fig,'Style','edit','String', Measures.Audiometry.equipment.AC_HardwareLimits,'Position',[80 220 100 20]);

uicontrol(fig,'Style','text','String','BC_Limit','Position',[20 200 labelboxwidth 20],'HorizontalAlignment','left');
BC_Limit = uicontrol(fig,'Style','edit','String', Measures.Audiometry.equipment.BC_HardwareLimits,'Position',[80 200 100 20]);

uicontrol(fig,'Style','text','String','device','Position',[20 180 labelboxwidth 20],'HorizontalAlignment','left');
Auddevice = uicontrol(fig,'Style','edit','String', Measures.Audiometry.equipment.device,'Position',[80 180 100 20]);

uicontrol(fig,'Style','text','String','serialnum','Position',[20 160 labelboxwidth 20],'HorizontalAlignment','left');
Audserialnum = uicontrol(fig,'Style','edit','String', Measures.Audiometry.equipment.serialNumber,'Position',[80 160 100 20]);

uicontrol(fig,'Style','text','String','calibDate','Position',[20 140 labelboxwidth 20],'HorizontalAlignment','left');
AudcalibDate = uicontrol(fig,'Style','edit','String', Measures.Audiometry.equipment.calibDate,'Position',[80 140 100 20]);

uicontrol(fig,'Style','text','String','comments','Position',[20 120 labelboxwidth 20],'HorizontalAlignment','left');
Audcomments = uicontrol(fig,'Style','edit','String', Measures.Audiometry.comments,'Position',[80 120 100 20]);

% ==== DPOAEs ====
uicontrol(fig,'Style','text','String','DPOAEs','Position',[20 100 labelboxwidth 20],'HorizontalAlignment','Center', 'FontWeight', 'bold');

uicontrol(fig,'Style','text','String','researcher','Position',[20 80 labelboxwidth 20],'HorizontalAlignment','left');
DPOAEresearcher = uicontrol(fig,'Style','edit','String', Measures.DPOAE.other.researcher,'Position',[80 80 100 20]);

uicontrol(fig,'Style','text','String','device','Position',[20 60 labelboxwidth 20],'HorizontalAlignment','left');
DPOAEdevice = uicontrol(fig,'Style','edit','String', Measures.DPOAE.equipment.device,'Position',[80 60 100 20]);

uicontrol(fig,'Style','text','String','calibDate','Position',[20 40 labelboxwidth 20],'HorizontalAlignment','left');
DPOAEcalibDate = uicontrol(fig,'Style','edit','String', Measures.DPOAE.equipment.calibDate,'Position',[80 40 100 20]);

uicontrol(fig,'Style','text','String','serialnum','Position',[20 20 labelboxwidth 20],'HorizontalAlignment','left');
DPOAEserialnum = uicontrol(fig,'Style','edit','String', Measures.DPOAE.equipment.serialNumber,'Position',[80 20 100 20]);

uicontrol(fig,'Style','text','String','DPOAEs Cont','Position',[200 570 labelboxwidth 20],'HorizontalAlignment','Center', 'FontWeight', 'bold');

uicontrol(fig,'Style','text','String','comments','Position',[200 550 labelboxwidth 20],'HorizontalAlignment','left');
DPOAEcomments = uicontrol(fig,'Style','edit','String', Measures.DPOAE.comments,'Position',[260 550 100 20]);

%====MEMR====
uicontrol(fig,'Style','text','String','MEMR','Position',[200 530 labelboxwidth 20],'HorizontalAlignment','Center', 'FontWeight', 'bold');

uicontrol(fig,'Style','text','String','equipment','Position',[200 510 labelboxwidth 20],'HorizontalAlignment','left');
MEMRequipment = uicontrol(fig,'Style','edit','String', Measures.Reflexes.equipment.device,'Position',[260 510 100 20]);

uicontrol(fig,'Style','text','String','calibDate','Position',[200 490 labelboxwidth 20],'HorizontalAlignment','left');
MEMRcalibDate = uicontrol(fig,'Style','edit','String', Measures.Reflexes.equipment.calibDate,'Position',[260 490 100 20]);

uicontrol(fig,'Style','text','String','serialNum','Position',[200 470 labelboxwidth 20],'HorizontalAlignment','left');
MEMRserialNum = uicontrol(fig,'Style','edit','String', Measures.Reflexes.equipment.serialNumber,'Position',[260 470 100 20]);

uicontrol(fig,'Style','text','String','comments','Position',[200 450 labelboxwidth 20],'HorizontalAlignment','left');
MEMRcomments = uicontrol(fig,'Style','edit','String', Measures.Reflexes.comments,'Position',[260 450 100 20]);



% ==== Otoscopy ====
uicontrol(fig,'Style','text','String','Otoscopy','Position',[820 310 140 20],'HorizontalAlignment','center');

uicontrol(fig,'Style','text','String','Comment','Position',[820 280 60 20],'HorizontalAlignment','left');
otoComments = uicontrol(fig,'Style','edit','String', Measures.Otoscopy.comments,'Position',[880 280 120 20]);

uicontrol(fig,'Style','text','String','Equipment','Position',[820 260 60 20],'HorizontalAlignment','left');
otoEquipment = uicontrol(fig,'Style','edit','String', Measures.Otoscopy.equipment,'Position',[880 260 120 20]);


% ==== WBT ====
uicontrol(fig,'Style','text','String','Wideband Tymp','Position',[820 210 140 20],'HorizontalAlignment','center');
uicontrol(fig,'Style','text','String','L','Position',[880 190 60 20],'HorizontalAlignment','center');
uicontrol(fig,'Style','text','String','R','Position',[940 190 60 20],'HorizontalAlignment','center');

uicontrol(fig,'Style','text','String','Pressure','Position',[820 170 60 20],'HorizontalAlignment','left');
WBTpressureL = uicontrol(fig,'Style','edit','String', Measures.WBT.L.PRESSURE,'Position',[880 170 60 20]);
WBTpressureR = uicontrol(fig,'Style','edit','String', Measures.WBT.R.PRESSURE,'Position',[940 170 60 20]);

uicontrol(fig,'Style','text','String','Freq','Position',[820 150 60 20],'HorizontalAlignment','left');
WBTfreqL = uicontrol(fig,'Style','edit','String', Measures.WBT.L.FREQ,'Position',[880 150 60 20]);
WBTfreqR = uicontrol(fig,'Style','edit','String', Measures.WBT.R.FREQ,'Position',[940 150 60 20]);

uicontrol(fig,'Style','text','String','Absorbance','Position',[820 130 60 20],'HorizontalAlignment','left');
WBTabsorbanceL = uicontrol(fig,'Style','edit','String', Measures.WBT.L.ABSORBANCE,'Position',[880 130 60 20]);
WBTabsorbanceR = uicontrol(fig,'Style','edit','String', Measures.WBT.R.ABSORBANCE,'Position',[940 130 60 20]);

uicontrol(fig,'Style','text','String','Comment','Position',[820 100 60 20],'HorizontalAlignment','left');
WBTComments = uicontrol(fig,'Style','edit','String', Measures.Otoscopy.comments,'Position',[880 100 120 20]);

uicontrol(fig,'Style','text','String','Equipment','Position',[820 80 60 20],'HorizontalAlignment','left');
WBTEquipment = uicontrol(fig,'Style','edit','String', Measures.WBT.equipment.device,'Position',[880 80 120 20]);

uicontrol(fig,'Style','text','String','Calib Date','Position',[820 60 60 20],'HorizontalAlignment','left');
WBTEquipmentCalibDate = uicontrol(fig,'Style','edit','String', Measures.WBT.equipment.calibDate,'Position',[880 60 120 20]);

uicontrol(fig,'Style','text','String','Serial #','Position',[820 40 60 20],'HorizontalAlignment','left');
WBTEquipmentSerialNumber = uicontrol(fig,'Style','edit','String', Measures.WBT.equipment.serialNumber,'Position',[880 40 120 20]);


% ==== SUBMIT BUTTON ====
uicontrol(fig,'Style','pushbutton','String','Submit & Save','Position',[600 20 150 40],...
    'Callback', @(src, event)submitCallback());


% ==== CALLBACK FUNCTION ====
    function submitCallback()
        % Update visit struct from GUI
        visit2.Subject.ID = subjID.String;
        visit2.Subject.age = str2double(age.String);
        visit2.Subject.gender = gender.String;
        visit2.Subject.amplification = amplification.String;

        visit2.VisitInfo.testDate = testDate.String;
        visit2.VisitInfo.referringLab = referringLab.String;
        visit2.VisitInfo.irbNumber = irbNumber.String;

        % Save updated struct back to file
        %save(fullfile(path, 'New\', file), 'visit');
        msgbox('visit data saved successfully!', 'Success');
    end
end
