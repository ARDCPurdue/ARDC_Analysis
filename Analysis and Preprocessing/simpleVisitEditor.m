function simpleVisitEditor()

%%%%% STUFF TO EDIT FOR A USER %%%%%
dataDir = "C:\Users\saman\Desktop\";
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
disp("Intializing Variables...")
Subject.ID = "";
Subject.age = "";
Subject.gender = "Unknown";
Subject.amplification = "Unknown";
VisitInfo.testDate = "";
VisitInfo.referringLab = "";
VisitInfo.irbNumber = "";
VisitInfo.ARDRsigned = "";
VisitInfo.researcher = "";
VisitInfo.researcherOther = "";
VisitInfo.studyProtocol = "";
VisitInfo.location = "";
VisitInfo.room = "";
VisitInfo.dateCompiled = "";

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
% Set up Subject information from old visit file into new structure
disp("Retrieving Subject Info...")
if isfield(visit, 'subjectID')
    Subject.ID = visit.subjectID;
    VisitInfo.researcher = visit.researcher;
    try
        Subject.age = visit.Age;
    end
elseif isfield(visit, 'Subject')
    Subject.ID = visit.Subject.ID;
    Subject.age = visit.Subject.age;
    Subject.gender = visit.Subject.gender;
    Subject.amplification = visit.Subject.amplification;
end

% Set up VisitInfo from old visit file into new structure
disp("Retrieving Visit Info...")
if isfield(visit, 'VisitInfo')
    VisitInfo = visit.VisitInfo; %%I think this is overwriting prior to the try statements
    try
        VisitInfo.testDate = visit.VisitInfo.testDate;
    catch
        disp("Didn't work because of visit info test date")
    end
    try
        VisitInfo.referringLab = visit.VisitInfo.referringLab;
    catch
        disp("Didn't work because of visit info referring lab")
    end
    try
        VisitInfo.irbNumber  = visit.VisitInfo.irbNumber;
    catch
        disp("Didn't work because of visit info irb number")
    end
    try
        VisitInfo.ARDRsigned  = visit.VisitInfo.ARDRsigned;
    catch
        disp("Didn't work because of visit info ARDR signed")
    end
    try
        VisitInfo.researcher  = visit.VisitInfo.researcher;
    catch
        disp("Didn't work because of visit info researcher")
    end
    try
        VisitInfo.researcherOther  = visit.VisitInfo.researcherOther;
    catch
        disp("Didn't work because of visit info researcher other")
    end
    try
        VisitInfo.studyProtocol  = visit.VisitInfo.studyProtocol;
    catch
        disp("Didn't work because of visit info study protocol")
    end
    try
        VisitInfo.location  = visit.VisitInfo.location;
    catch
        disp("Didn't work because of visit info location")
    end
    try
        VisitInfo.room  = visit.VisitInfo.room;
    catch
        disp("Didn't work because of visit info room")
    end
    try
        VisitInfo.dateCompiled  = visit.VisitInfo.dateCompiled;
    catch
        disp("Didn't work because of visit info room")
    end
elseif isfield(visit, 'time')
    try
        VisitInfo.testDate = visit.time;
    catch
        disp("Didn't work because of visit info test date")
    end
end


%% Data for each measure
disp("Retrieving Measures...")

% for the checkboxes
audio_yes = 0; 
dp_yes = 0; 
memr_yes = 0; 
act_yes = 0; 
quicksin_yes = 0; 
wrs_yes = 0; 
wbt_yes = 0; 
oto_yes = 0; 

if isfield(visit, 'Measures') %% works if measures are stored in a 'Measures' structure
    meas = fieldnames(visit.Measures);
    for f = 1:length(meas)

        %Check For Audiogram Data
        %%%There is a 1x1 cell for comments that was initialized in
        %%%Measures.Audiometry
        if contains(meas{f}, 'audio', 'IgnoreCase', 1)
            disp("    Retrieving Audiogram Data...")
            audio_yes = 1; 
            Measures.Audiometry.AC.R = visit.Measures.(meas{f}).AC.R;
            Measures.Audiometry.AC.L = visit.Measures.(meas{f}).AC.L;
            Measures.Audiometry.BC.R = visit.Measures.(meas{f}).BC.R;
            Measures.Audiometry.BC.L = visit.Measures.(meas{f}).BC.L;

            if isfield(visit.Measures.(meas{f}), 'equipment')
                Measures.Audiometry.equipment.AC_transducer = visit.Measures.(meas{f}).equipment.AC_transducer;
                Measures.Audiometry.equipment.BC_transducer = visit.Measures.(meas{f}).equipment.BC_transducer;
                Measures.Audiometry.equipment.AC_HardwareLimits = visit.Measures.(meas{f}).equipment.AC_HardwareLimits;
                Measures.Audiometry.equipment.BC_HardwareLimits = visit.Measures.(meas{f}).equipment.BC_HardwareLimits;
                Measures.Audiometry.equipment.device = visit.Measures.(meas{f}).equipment.device;
                Measures.Audiometry.equipment.calibDate = visit.Measures.(meas{f}).equipment.calibDate;
                Measures.Audiometry.equipment.serialNumber = visit.Measures.(meas{f}).equipment.serialNumber;
                Measures.Audiometry.comments = visit.Measures.(meas{f}).comments;
            else
                Measures.Audiometry.equipment.AC_transducer = visit.Measures.(meas{f}).AC_transducer;
                Measures.Audiometry.equipment.BC_transducer = visit.Measures.(meas{f}).BC_transducer;
                Measures.Audiometry.equipment.AC_HardwareLimits = visit.Measures.(meas{f}).AC_HardwareLimits;
                Measures.Audiometry.equipment.BC_HardwareLimits = visit.Measures.(meas{f}).BC_HardwareLimits;
            end

            %Check for QuickSIN Data
        elseif contains(meas{f}, 'Quick', 'IgnoreCase', 1)
            quicksin_yes = 1; 
            disp("    Retrieving QuickSIN Data...")
            Measures.QuickSIN.R = visit.Measures.(meas{f}).R;
            Measures.QuickSIN.L = visit.Measures.(meas{f}).L;
            try
                Measures.QuickSIN.Bin = visit.Measures.(meas{f}).Bin;
            catch
                Measures.QuickSIN.Bin = "";
            end
            try
                Measures.QuickSIN.equipment.device = visit.Measures.(meas{f}).equipment.device;
            catch
                disp('Measures.QuickSIN.equipment.device not obtained')
            end
            try
                Measures.QuickSIN.equipment.calibDate = visit.Measures.(meas{f}).equipment.calibDate;
            catch
                disp('Measures.QuickSIN.equipment.calibDate not obtained')
            end
            try
                Measures.QuickSIN.equipment.serialNumber = visit.Measures.(meas{f}).equipment.serialNumber;
            catch
                disp('Measures.QuickSIN.equipment.serialNumber not found')
            end
            try
                Measures.QuickSIN.comments = visit.Measures.(meas{f}).comments;
            catch
                disp('Measures.QuickSIN.comments not found')
            end
            % Check for DPOAE Data
        elseif contains(meas{f}, 'dpoae', 'IgnoreCase', 1)
            disp("    Retrieving DPOAE Data...")
            dp_yes = 1; 
            Measures.DPOAE.R = visit.Measures.(meas{f}).R;
            Measures.DPOAE.L = visit.Measures.(meas{f}).L;
            Measures.DPOAE.other.researcher  = visit.Measures.(meas{f}).other.researcher;
            try
                Measures.DPOAE.equipment = visit.Measures.(meas{f}).equipment;
                Measures.DPOAE.comments = visit.Measures.(meas{f}).comments;
            end

            % Check for Reflexes Data
        elseif contains(meas{f}, 'Reflex', 'IgnoreCase', 1)
            disp("    Retrieving Reflexes Data...")
            memr_yes = 1; 
            Measures.Reflexes.ProbeR = visit.Measures.(meas{f}).ProbeR;
            Measures.Reflexes.ProbeL = visit.Measures.(meas{f}).ProbeL;
            try
                Measures.Reflexes.equipment = visit.Measures.(meas{f}).equipment;
            catch
                disp("reflex data does not contain equipment info")
            end

            try
                Measures.Reflexes.comments = visit.Measures.(meas{f}).comments;
            catch
                disp("reflex data does not contain comments")
            end

            % Check for WRS Data
        elseif contains(meas{f}, 'WRS', 'IgnoreCase', 1)
            disp("    Retrieving WRS Data...")
            wrs_yes = 1; 
            Measures.WRS.R = visit.Measures.(meas{f}).R;
            Measures.WRS.L = visit.Measures.(meas{f}).L;

            try
                Measures.WRS.equipment= visit.Measures.(meas{f}).equipment;
                Measures.WRS.comments = visit.Measures.(meas{f}).comments;
            end
            %%% This section is overwriting the origional initialized variables. When
            %%% ACT is present in the comment it removes the scores so it cannot be
            %%% plotted later

            % Check for ACT Data
        elseif contains(meas{f}, 'ACT', 'IgnoreCase', 1)
            disp("    Retrieving ACT Data...")
            act_yes =1; 
            try
                Measures.ACT.scores = visit.Measures.ACT.scores; %not real
            catch
                Measures.ACT.scores = "";
            end
            try
                Measures.ACT.comments = visit.Measures.ACT.comments;
            catch
                Measures.ACT.comments = "";
            end
            try
                Measures.ACT.equipment.device = visit.Measures.ACT.equipment.device;
            catch
                Measures.ACT.equipment.device = "";
            end
            try
                Measures.ACT.equipment.calibDate = visit.Measures.ACT.equipment.calibDate;
            catch
                Measures.ACT.equipment.calibDate = "";
            end
            try
                Measures.ACT.equipment.serialNumber = visit.Measures.ACT.equipment.serialNumber;
            catch
                Measures.ACT.equipment.serialNumber = "";
            end

            % try
            %     Measures.ACT = visit.Measures.ACT;
            % catch
            %     warning("Does not have ACT info")
            %
            % end

            %Check for WBT Data
        elseif contains(meas{f}, 'WBT', 'IgnoreCase', 1)
            disp("    Retrieving WBT Data...")
            wbt_yes = 1; 
            Measures.WBT.R = visit.Measures.(meas{f}).R;
            Measures.WBT.L = visit.Measures.(meas{f}).L;

            try
                Measures.WBT.equipment = visit.Measures.(meas{f}).equipment;
                Measures.WBT.comments = visit.Measures.(meas{f}).comments;
            catch
                disp("Does not have WBT equipment info")
            end

            % % Check for Otoscopy Data Error
        elseif contains(meas{f}, 'otoscopy', 'IgnoreCase', 1)
            disp("    Retrieving Otoscopy Data...")
            oto_yes = 1; 
            Measures.Otoscopy.comments = visit.Measures.Otoscopy.comments;
            Measures.Otoscopy.equipment = visit.Measures.Otoscopy.equipment;
        end
    end
end

%% if the measures are stored in the visit. structure ie. ARDC 37
%%% i tried to set this up as an if, ifelse loop, but it was not working in
%%% that format
if isfield(visit, 'Audiogram')
    disp('    Retrieving Audiogram data...')
    audio_yes = 1; 
    try
        Measures.Audiometry.AC.R = visit.Audiogram.AC.R;
    catch
        disp('Measures.Audiometry.AC.R not retrieved')
    end
    try
        Measures.Audiometry.AC.L = visit.Audiogram.AC.L;
    catch
        disp('Measures.Audiometry.AC.L not retrieved')
    end
    try
        Measures.Audiometry.BC.R = visit.Audiogram.BC.R;
    catch
        disp('Measures.Audiometry.BC.R not retrieved')
    end
    try
        Measures.Audiometry.BC.L = visit.Audiogram.BC.L;
    catch
        disp('Measures.Audiometry.BC.L not retrieved')
    end

    try
        Measures.Audiometry.equipment.AC_transducer = visit.Audiogram.AC_transducer;
    catch
        disp('Measures.Audiometry.equipment.AC_transducer not retrieved')
    end
    try
        Measures.Audiometry.equipment.BC_transducer = visit.Audiogram.BC_transducer;
    catch
        disp('Measures.Audiometry.equipment.BC_transducer not retrieved')
    end
    try
        Measures.Audiometry.equipment.AC_HardwareLimits = visit.Audiogram.AC_HardwareLimits;
    catch
        disp('Measures.Audiometry.equipment.AC_HardwareLimits not retrieved')
    end
    try
        Measures.Audiometry.equipment.BC_HardwareLimits = visit.Audiogram.BC_HardwareLimits;
    catch
        disp('Measures.Audiometry.equipment.BC_HardwareLimits not retrieved')
    end
end
if isfield(visit, 'QuickSIN')
    disp('    Retrieving QuickSIN data...')
    quicksin_yes = 1;
    try
        Measures.QuickSIN.R = visit.QuickSIN.R;
    catch
        disp('Measures.QuickSIN.R not retrieved')
    end
    try
        Measures.QuickSIN.L = visit.QuickSIN.L;
    catch
        disp('Measures.QuickSIN.L not retrieved')
    end
end
%%
if isfield(visit, 'dpOAE')
    disp('    DPOAEs')
    dp_yes = 1;
    %Right
    try
        Measures.DPOAE.R.noisefloor = visit.dpOAE.R.noisefloor;
    catch
        disp('Measures.DPOAE.R.noisefloor not retrieved')
    end
    try
        Measures.DPOAE.R.mean_response = visit.dpOAE.R.mean_response;
    catch
        disp('Measures.DPOAE.R.mean_response not retrieved')
    end
    try
        Measures.DPOAE.R.f1 = visit.dpOAE.R.f1;
    catch
        disp('Measures.DPOAE.R.f1 not retrieved')
    end
    try
        Measures.DPOAE.R.f2 = visit.dpOAE.R.f2;
    catch
        disp('Measures.DPOAE.R.f2 not retrieved')
    end
    try
        Measures.DPOAE.R.DP = visit.dpOAE.R.DP;
    catch
        disp('Measures.DPOAE.R.DP not retrieved')
    end
    try
        Measures.DPOAE.R.f1_rec_dB = visit.dpOAE.R.f1_rec_dB;
    catch
        disp('Measures.DPOAE.R.f1_rec_dB not retrieved')
    end
    try
        Measures.DPOAE.R.f2_rec_dB = visit.dpOAE.R.f2_rec_dB;
    catch
        disp('Measures.DPOAE.R.f2_rec_dB not retrieved')
    end
    try
        Measures.DPOAE.R.fs = visit.dpOAE.R.fs;
    catch
        disp('Measures.DPOAE.R.f2_rec_dB not retrieved')
    end

    %Left
    try
        Measures.DPOAE.L.noisefloor = visit.dpOAE.L.noisefloor;
    catch
        disp('Measures.DPOAE.L.noisefloor not retrieved')
    end
    try
        Measures.DPOAE.L.mean_response = visit.dpOAE.L.mean_response;
    catch
        disp('Measures.DPOAE.L.mean_response not retrieved')
    end
    try
        Measures.DPOAE.L.f1 = visit.dpOAE.L.f1;
    catch
        disp('Measures.DPOAE.L.f1 not retrieved')
    end
    try
        Measures.DPOAE.L.f2 = visit.dpOAE.L.f2;
    catch
        disp('Measures.DPOAE.L.f2 not retrieved')
    end
    try
        Measures.DPOAE.L.DP = visit.dpOAE.L.DP;
    catch
        disp('Measures.DPOAE.L.DP not retrieved')
    end
    try
        Measures.DPOAE.L.f1_rec_dB = visit.dpOAE.L.f1_rec_dB;
    catch
        disp('Measures.DPOAE.L.f1_rec_dB not retrieved')
    end
    try
        Measures.DPOAE.L.f2_rec_dB = visit.dpOAE.L.f2_rec_dB;
    catch
        disp('Measures.DPOAE.L.f2_rec_dB not retrieved')
    end
    try
        Measures.DPOAE.L.fs = visit.dpOAE.L.fs;
    catch
        disp('Measures.DPOAE.L.f2_rec_dB not retrieved')
    end
end

if isfield(visit, 'WBT')
    disp ('    WBT...')
    wbt_yes = 1;
    try
        Measures.WBT.L.PRESSURE = visit.WBT.L.PRESSURE;
    catch
        disp('Measures.WBT.L.PRESSURE not retrieved')
    end
    try
        Measures.WBT.L.FREQ = visit.WBT.L.FREQ;
    catch
        disp('Measures.WBT.L.FREQ not retrieved')
    end
    try
        Measures.WBT.L.ABSORBANCE = visit.WBT.L.ABSORBANCE;
    catch
        disp('Measures.WBT.L.FREQ not retrieved')
    end

    try
        Measures.WBT.R.PRESSURE = visit.WBT.R.PRESSURE;
    catch
        disp('Measures.WBT.R.PRESSURE not retrieved')
    end
    try
        Measures.WBT.R.FREQ = visit.WBT.R.FREQ;
    catch
        disp('Measures.WBT.R.FREQ not retrieved')
    end
    try
        Measures.WBT.R.ABSORBANCE = visit.WBT.R.ABSORBANCE;
    catch
        disp('Measures.WBT.R.FREQ not retrieved')
    end
end

%%

% Set some defaults for dropdowns and other fancy ui controls
addpath('DataSheets')

% Read in IRB data
IRBs = readtable('IRBs.csv', 'TextType','string');
dropdown_lab = table2array(IRBs(:,"PI"));
dropdown_IRB = table2array(IRBs(:,"IRBnum"));

% Other standard dropdowns, not read from CSV. Could be edited if needed.
dropdown_gender = {'Male', 'Female', 'Non-binary', 'Unknown'};  % Replace with your options
dropdown_amplification = {'None', 'Hearing Aids', 'Cochlear Implant','Other', 'Unknown'};

% % Get all locations
% all_locs = dir("DataSheets\Equipment_*");
% for i = 1:numel(all_locs)
%     locations(i) = extractBetween(all_locs(i).name, 'Equipment_', '_');
%     rms(i) = extractBetween(all_locs(i).name, sprintf('Equipment_%s_', locations{i}), '.csv');
% end
% unique_locations = unique(locations);

% Create figure window
boxheight = 20;
figheight = 600;
fig = uifigure('Name', 'Visit Editor', 'Position', [100 100 760 figheight]);
labelboxwidth = 140;
labelboxhieght = 20;


% ==== SUBJECT INFO ====
uicontrol(fig,'Style','text','String','Subject ID','Position',[20 570 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
subjID = uicontrol(fig,'Style','edit','String',Subject.ID,'Position',[90 570 140 20]);

uicontrol(fig,'Style','text','String','Age','Position',[20 550 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
age = uicontrol(fig,'Style','edit','String',num2str(Subject.age),'Position',[90 550 140 20]);

uicontrol(fig,'Style','text','String','Gender','Position',[20 530 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
gender = uidropdown(fig,'Value',Subject.gender,'Items',dropdown_gender, 'Position',[90 530 140 20]);

uicontrol(fig,'Style','text','String','Amplification','Position',[20 510 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
amplification = uidropdown(fig,'Value',Subject.amplification,'Items', dropdown_amplification, 'Position',[90 510 140 20]);


% ==== VISIT INFO ====
uicontrol(fig,'Style','text','String','Test Date','Position',[20 480 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
testDate = uicontrol(fig, 'Style', 'edit','String', string(VisitInfo.testDate),'Position',[90 480 140 20]);

% Needs to be dropdowns:
uicontrol(fig,'Style','text','String','Refer Lab','Position',[20 460 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
referringLab = uicontrol(fig,'Style','edit','String',VisitInfo.referringLab,'Position',[90 460 140 20]);

uicontrol(fig,'Style','text','String','IRB #','Position',[20 440 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
irbNumber = uicontrol(fig,'Style','edit','String',VisitInfo.irbNumber,'Position',[90 440 140 20]);

uicontrol(fig,'Style','text','String','ARDRsigned','Position',[20 420 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
isARDRsigned = 'unknown';
if strcmp(VisitInfo.ARDRsigned, "1")
    isARDRsigned = 'Yes';
elseif strcmp(VisitInfo.ARDRsigned, "0")
    isARDRsigned = 'No';
end
ARDRsigned = uidropdown(fig, 'Value',isARDRsigned, 'Items', {'Yes', 'No', 'unknown'}, 'Position',[90 420 140 20]);

uicontrol(fig,'Style','text','String','researcher','Position',[20 400 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
researcher = uicontrol(fig,'Style','edit','String',VisitInfo.researcher,'Position',[90 400 140 20]);

uicontrol(fig,'Style','text','String','researcherOther','Position',[20 380 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
researcherOther = uicontrol(fig,'Style','edit','String',VisitInfo.researcherOther,'Position',[90 380 140 20]);

uicontrol(fig,'Style','text','String','studyProtocol','Position',[20 360 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
studyProtocol = uicontrol(fig,'Style','edit','String',VisitInfo.studyProtocol,'Position',[90 360 140 20]);

uicontrol(fig,'Style','text','String','location','Position',[20 340 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
location = uicontrol(fig,'Style','edit','String',VisitInfo.location,'Position',[90 340 140 20]);

uicontrol(fig,'Style','text','String','room','Position',[20 320 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
room = uicontrol(fig,'Style','edit','String',VisitInfo.room,'Position',[90 320 140 20]);

uicontrol(fig,'Style','text','String','dateCompiled','Position',[20 300 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
dateCompiled = uicontrol(fig,'Style','edit','String',string(VisitInfo.dateCompiled),'Position',[90 300 140 20]);

% ==== Audiometry ====
aud_checkbox = uicontrol(fig,'Style','checkbox','Value',audio_yes,'Position',[20 280 labelboxwidth labelboxhieght],'HorizontalAlignment','left', 'FontWeight', 'bold');
uicontrol(fig,'Style','text','String','Audiometry','Position',[20+20 280 labelboxwidth-20 labelboxhieght],'HorizontalAlignment','left', 'FontWeight', 'bold');

uicontrol(fig,'Style','text','String','AC_trans','Position',[20 260 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
AC_trans = uicontrol(fig,'Style','edit','String', Measures.Audiometry.equipment.AC_transducer,'Position',[90 260 140 20]);

uicontrol(fig,'Style','text','String','BC_trans','Position',[20 240 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
BC_trans = uicontrol(fig,'Style','edit','String', Measures.Audiometry.equipment.BC_transducer,'Position',[90 240 140 20]);

uicontrol(fig,'Style','text','String','AC_Limit','Position',[20 220 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
AC_Limit = uicontrol(fig,'Style','edit','String', Measures.Audiometry.equipment.AC_HardwareLimits,'Position',[90 220 140 20]);

uicontrol(fig,'Style','text','String','BC_Limit','Position',[20 200 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
BC_Limit = uicontrol(fig,'Style','edit','String', Measures.Audiometry.equipment.BC_HardwareLimits,'Position',[90 200 140 20]);

uicontrol(fig,'Style','text','String','device','Position',[20 180 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
Auddevice = uicontrol(fig,'Style','edit','String', Measures.Audiometry.equipment.device,'Position',[90 180 140 20]);

uicontrol(fig,'Style','text','String','Serial #','Position',[20 160 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
Audserialnum = uicontrol(fig,'Style','edit','String', Measures.Audiometry.equipment.serialNumber,'Position',[90 160 140 20]);

uicontrol(fig,'Style','text','String','calibDate','Position',[20 140 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
AudcalibDate = uicontrol(fig,'Style','edit','String', Measures.Audiometry.equipment.calibDate,'Position',[90 140 140 20]);

uicontrol(fig,'Style','text','String','comments','Position',[20 120 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
Audcomments = uicontrol(fig,'Style','edit','String', Measures.Audiometry.comments,'Position',[90 40 140 100]);

% ==== DPOAEs ====
dp_checkbox = uicontrol(fig,'Style','checkbox','Value',dp_yes,'Position',[240 570 labelboxwidth labelboxhieght],'HorizontalAlignment','left', 'FontWeight', 'bold');
uicontrol(fig,'Style','text','String','DPOAEs','Position',[240+20 570 labelboxwidth-20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');

uicontrol(fig,'Style','text','String','researcher','Position',[240 550 labelboxwidth 20],'HorizontalAlignment','left');
DPOAEresearcher = uicontrol(fig,'Style','edit','String', Measures.DPOAE.other.researcher,'Position',[300 550 140 20]);

uicontrol(fig,'Style','text','String','device','Position',[240 530 labelboxwidth 20],'HorizontalAlignment','left');
DPOAEdevice = uicontrol(fig,'Style','edit','String', Measures.DPOAE.equipment.device,'Position',[300 530 140 20]);

uicontrol(fig,'Style','text','String','calibDate','Position',[240 510 labelboxwidth 20],'HorizontalAlignment','left');
DPOAEcalibDate = uicontrol(fig,'Style','edit','String', Measures.DPOAE.equipment.calibDate,'Position',[300 510 140 20]);

uicontrol(fig,'Style','text','String','Serial #','Position',[240 490 labelboxwidth 20],'HorizontalAlignment','left');
DPOAEserialnum = uicontrol(fig,'Style','edit','String', Measures.DPOAE.equipment.serialNumber,'Position',[300 490 140 20]);

uicontrol(fig,'Style','text','String','comments','Position',[240 470 labelboxwidth 20],'HorizontalAlignment','left');
DPOAEcomments = uicontrol(fig,'Style','edit','String', Measures.DPOAE.comments,'Position',[300 430 140 60]);

%====MEMR====
memr_checkbox = uicontrol(fig,'Style','checkbox','Value',memr_yes,'Position',[240 410 labelboxwidth labelboxhieght],'HorizontalAlignment','left', 'FontWeight', 'bold');
uicontrol(fig,'Style','text','String','MEMR','Position',[240+20 410 labelboxwidth-20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');

uicontrol(fig,'Style','text','String','equipment','Position',[240 390 labelboxwidth 20],'HorizontalAlignment','left');
MEMRequipment = uicontrol(fig,'Style','edit','String', Measures.Reflexes.equipment.device,'Position',[300 390 140 20]);

uicontrol(fig,'Style','text','String','calibDate','Position',[240 370 labelboxwidth 20],'HorizontalAlignment','left');
MEMRcalibDate = uicontrol(fig,'Style','edit','String', Measures.Reflexes.equipment.calibDate,'Position',[300 370 140 20]);

uicontrol(fig,'Style','text','String','Serial #','Position',[240 350 labelboxwidth 20],'HorizontalAlignment','left');
MEMRserialNum = uicontrol(fig,'Style','edit','String', Measures.Reflexes.equipment.serialNumber,'Position',[300 350 140 20]);

uicontrol(fig,'Style','text','String','comments','Position',[240 330 labelboxwidth 20],'HorizontalAlignment','left');
MEMRcomments = uicontrol(fig,'Style','edit','String', Measures.Reflexes.comments,'Position',[300 290 140 60]);

% ==== ACT ==== %
act_checkbox = uicontrol(fig,'Style','checkbox','Value',act_yes,'Position',[240 270 20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');
uicontrol(fig,'Style','text','String','ACT','Position',[240+20 270 140-20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');

%%Error
uicontrol(fig,'Style', 'text', 'String','Trial 1', 'Position', [240 250 140 20], 'HorizontalAlignment','left');
ACTTrialOne = uicontrol(fig,'Style','edit', 'String', Measures.ACT.scores, 'Position',[275 250 50 20]);

uicontrol(fig,'Style', 'text', 'String','Trial 2', 'Position', [330 250 140 20], 'HorizontalAlignment','left');
ACTTrialTwo = uicontrol(fig,'Style','edit', 'String', Measures.ACT.scores, 'Position',[365 250 50 20]);

uicontrol(fig,'Style', 'text', 'String','One Trial Only', 'Position', [240 230 140 20], 'HorizontalAlignment','left');
ACTSingleTrial = uicontrol(fig,'Style','checkbox', 'Position', [310 230 140 20]);

uicontrol(fig,'Style', 'text', 'String','CNT', 'Position', [330 230 140 20], 'HorizontalAlignment','left');
ACTCNT = uicontrol(fig,'Style','checkbox', 'Position', [360 230 140 20]);

uicontrol(fig,'Style', 'text', 'String','Equipment', 'Position', [240 210 140 20], 'HorizontalAlignment','left');
ACTEquipment = uicontrol(fig,'Style','edit', 'String', Measures.ACT.equipment.device, 'Position',[300 210 140 20]);

uicontrol(fig,'Style', 'text', 'String','Calib', 'Position', [240 190 140 20], 'HorizontalAlignment','left');
ACTCalib = uicontrol(fig,'Style','edit', 'String', Measures.ACT.equipment.calibDate, 'Position',[300 190 140 20]);

uicontrol(fig,'Style', 'text', 'String','Serial #', 'Position', [240 170 140 20], 'HorizontalAlignment','left');
ACTSerialNum = uicontrol(fig,'Style','edit', 'String', Measures.ACT.equipment.serialNumber, 'Position',[300 170 140 20]);

uicontrol(fig,'Style','text','String','old comments','Position',[240 150 140 20],'HorizontalAlignment','left');
ACToldComments = uicontrol(fig,'Style','edit', 'String', Measures.ACT.comments, 'Position', [320 130 120 40]);

uicontrol(fig,'Style','text','String','new comments','Position',[240 110 140 20],'HorizontalAlignment','left')
ACTnewComments = uicontrol(fig,'Style','edit', 'String', Measures.ACT.comments, 'Position', [320 90 120 40]);


% ==== Otoscopy ====
otoscopy_checkbox = uicontrol(fig,'Style','checkbox','Value',oto_yes,'Position',[1070-430 190 20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');
uicontrol(fig,'Style','text','String','Otoscopy','Position',[1070-430+20 190 140-20 20],'HorizontalAlignment','left', 'FontWeight','bold');

uicontrol(fig,'Style','text','String','Equipment','Position',[1070-430 170 60 20],'HorizontalAlignment','left');
otoEquipment = uicontrol(fig,'Style','edit','String', Measures.Otoscopy.equipment,'Position',[1070-430 150 110 20]);

uicontrol(fig,'Style','text','String','Comment','Position',[1070-430 120 60 20],'HorizontalAlignment','left');
otoComments = uicontrol(fig,'Style','edit','String', Measures.Otoscopy.comments,'Position',[1070-430 40 110 80]);

% ==== WBT ====
wbt_checkbox = uicontrol(fig,'Style','checkbox','Value',wbt_yes,'Position',[880-430 190 20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');
uicontrol(fig,'Style','text','String','Wideband Tymp','Position',[880-430+20 190 140-20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');
uicontrol(fig,'Style','text','String','L','Position',[940-430 170 60 20],'HorizontalAlignment','center');
uicontrol(fig,'Style','text','String','R','Position',[1000-430 170 60 20],'HorizontalAlignment','center');

uicontrol(fig,'Style','text','String','Has WBT Data?','Position',[880-430 150 60 40],'HorizontalAlignment','left');

if isnumeric(Measures.WBT.R.PRESSURE(1))
    hasDataR = "Data";
else
    hasDataR = "No Data";
end

if isnumeric(Measures.WBT.L.PRESSURE(1))
    hasDataL = "Data";
else
    hasDataL = "No Data";
end

WBTdataL = uicontrol(fig,'Style','text','String', hasDataL,'Position',[940-430 150 60 20]);
WBTdataR = uicontrol(fig,'Style','text','String',hasDataR,'Position',[1000-430 150 60 20]);


uicontrol(fig,'Style','text','String','Comment','Position',[880-430 130 60 20],'HorizontalAlignment','left');
WBTComments = uicontrol(fig,'Style','edit','String', Measures.WBT.comments,'Position',[940-430 100 120 50]);

uicontrol(fig,'Style','text','String','Equipment','Position',[880-430 80 60 20],'HorizontalAlignment','left');
WBTEquipment = uicontrol(fig,'Style','edit','String', Measures.WBT.equipment.device,'Position',[940-430 80 120 20]);

uicontrol(fig,'Style','text','String','Calib Date','Position',[880-430 60 60 20],'HorizontalAlignment','left');
WBTEquipmentCalibDate = uicontrol(fig,'Style','edit','String', Measures.WBT.equipment.calibDate,'Position',[940-430 60 120 20]);

uicontrol(fig,'Style','text','String','Serial #','Position',[880-430 40 60 20],'HorizontalAlignment','left');
WBTEquipmentSerialNumber = uicontrol(fig,'Style','edit','String', Measures.WBT.equipment.serialNumber,'Position',[940-430 40 120 20]);

% ==== QuickSIN ====
quicksin_checkbox = uicontrol(fig,'Style','checkbox','Value',quicksin_yes,'Position',[880-430 570 20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');
uicontrol(fig,'Style', 'text', 'String', 'QuickSIN', 'Position', [880-430+20 570 60-20 20], 'HorizontalAlignment','left','FontWeight','bold');

uicontrol(fig,'Style', 'text', 'String','RE QuickSIN', 'Position', [880-430 550 150 boxheight], 'HorizontalAlignment','left', 'ForegroundColor', 'red');
RquickSIN = uicontrol(fig,'Style','edit', 'String', Measures.QuickSIN.R, 'Position',[945-430 550 30 boxheight]);

uicontrol(fig,'Style', 'text', 'String','DNT', 'Position',[980-430 550 150 boxheight], 'HorizontalAlignment','left','ForegroundColor', 'red');
RquickSINDNT = uicontrol(fig,'Style','checkbox', 'Position',[1005-430 550 25 boxheight]);

uicontrol(fig,'Style', 'text', 'String','Equip', 'Position',[1025-430 550 150 boxheight], 'HorizontalAlignment','left');
QSequipdevice = uicontrol(fig,'Style','edit', 'String', Measures.QuickSIN.equipment.device, 'Position',[1060-430 550 120 boxheight]);

uicontrol(fig, 'Style', 'text', 'String','LE QuickSIN', 'Position', [880-430 530 150 boxheight], 'HorizontalAlignment','left','ForegroundColor', 'blue');
LquickSIN = uicontrol(fig,'Style','edit', 'String', Measures.QuickSIN.L, 'Position',[945-430 530 30 boxheight]);

uicontrol(fig,'Style', 'text', 'String','DNT', 'Position', [980-430 530 150 boxheight], 'HorizontalAlignment','left','ForegroundColor', 'blue');
LquickSINDNT = uicontrol(fig,'Style','checkbox', 'Position',[1005-430 530 25 boxheight]);

uicontrol(fig,'Style', 'text', 'String','Calib', 'Position', [1025-430 530 150 boxheight], 'HorizontalAlignment','left');
QSequipcalib = uicontrol(fig,'Style','edit', 'String', Measures.QuickSIN.equipment.calibDate, 'Position',[1060-430 530 120 boxheight]);

uicontrol(fig, 'Style', 'text', 'String','Bin QuickSIN', 'Position', [880-430 510 150 boxheight], 'HorizontalAlignment','left','ForegroundColor', 'green');
BquickSIN = uicontrol(fig,'Style','edit', 'String', Measures.QuickSIN.Bin, 'Position',[945-430 510 30 boxheight]);

uicontrol(fig,'Style', 'text', 'String','DNT', 'Position', [980-430 510 150 boxheight], 'HorizontalAlignment','left','ForegroundColor', 'green');
BquickSINDNT = uicontrol(fig,'Style','checkbox', 'Position',[1005-430 510 25 boxheight]);

uicontrol(fig,'Style', 'text', 'String','Serial#', 'Position', [1025-430 510 150 boxheight], 'HorizontalAlignment','left');
QSequipSN = uicontrol(fig,'Style','edit', 'String', Measures.QuickSIN.equipment.serialNumber, 'Position',[1060-430 510 120 boxheight]);

uicontrol(fig,'Style', 'text', 'String','Comments', 'Position', [880-430 490 150 boxheight], 'HorizontalAlignment','left');
QScomments = uicontrol(fig,'Style','edit', 'String', Measures.QuickSIN.comments, 'Position',[945-430 470 235 40]);


% ==== WRS ==== %
wrs_checkbox = uicontrol(fig,'Style','checkbox','Value',wrs_yes,'Position',[880-430 450 20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');
uicontrol(fig,'Style', 'text', 'String', 'WRS', 'Position', [880-430+20 450 60 20], 'HorizontalAlignment','left', 'FontWeight', 'bold');
uicontrol(fig,'Style', 'text', 'String','Right Ear:', 'Position', [880-430 430 60 20], 'HorizontalAlignment','left', 'ForegroundColor','red');

uicontrol(fig,'Style', 'text', 'String','List', 'Position', [930-430 430 60 20], 'HorizontalAlignment','left');
RwrsList = uicontrol(fig,'Style','edit', 'String', Measures.WRS.R.list, 'Position',[950-430 430 100 20]);

uicontrol(fig,'Style', 'text', 'String','by diff', 'Position', [1060-430 430 150 boxheight], 'HorizontalAlignment','left');
RwrsListDiff = uicontrol(fig,'Style','checkbox', 'Position',[1090-430 430 25 boxheight]);

uicontrol(fig,'Style', 'text', 'String','List #', 'Position', [1110-430 430 150 boxheight], 'HorizontalAlignment','left');
RwrsListNum = uicontrol(fig,'Style','edit', 'String', Measures.WRS.R.listNumber, 'Position',[1140-430 430 40 boxheight]);

uicontrol(fig,'Style', 'text', 'String','Speech Level', 'Position', [880-430 410 150 boxheight], 'HorizontalAlignment','left');
RwrsSLevel = uicontrol(fig,'Style','edit', 'String', Measures.WRS.R.speechLevel, 'Position',[950-430 410 50 20]);

uicontrol(fig,'Style', 'text', 'String','Masking Level', 'Position', [1005-430 410 150 boxheight], 'HorizontalAlignment','left');
RwrsMlevel = uicontrol(fig,'Style','edit', 'String', Measures.WRS.R.maskingLevel, 'Position',[1080-430 410 50 20]);

uicontrol(fig,'Style', 'text', 'String','# correct', 'Position', [880-430 390 150 boxheight], 'HorizontalAlignment','left');
RwrsNumCorrect = uicontrol(fig,'Style','edit', 'String', Measures.WRS.R.numberWordCorrect, 'Position',[930-430 390 50 20]);

uicontrol(fig,'Style', 'text', 'String','total #', 'Position', [990-430 390 150 boxheight], 'HorizontalAlignment','left');
RwrsTotalNum = uicontrol(fig,'Style','edit', 'String', Measures.WRS.R.totalWordsPresented, 'Position',[1020-430 390 50 20]);

uicontrol(fig,'Style', 'text', 'String','% correct', 'Position', [1080-430 390 150 boxheight], 'HorizontalAlignment','left');
RwrsPercentCorrect = uicontrol(fig,'Style','edit', 'String', Measures.WRS.R.percentCorrect, 'Position',[1130-430 390 50 20]);

uicontrol(fig,'Style', 'text', 'String','Left Ear:', 'Position', [880-430 350 60 20], 'HorizontalAlignment','left','ForegroundColor', 'blue');

uicontrol(fig,'Style', 'text', 'String','List', 'Position', [930-430 350 60 20], 'HorizontalAlignment','left');
LwrsList = uicontrol(fig,'Style','edit', 'String', Measures.WRS.L.list, 'Position',[950-430 350 100 20]);

uicontrol(fig,'Style', 'text', 'String','by diff', 'Position', [1060-430 350 150 boxheight], 'HorizontalAlignment','left');
LwrsListDiff = uicontrol(fig,'Style','checkbox', 'Position',[1090-430 350 25 boxheight]);

uicontrol(fig,'Style', 'text', 'String','List #', 'Position', [1110-430 350 150 boxheight], 'HorizontalAlignment','left');
LwrsListNum = uicontrol(fig,'Style','edit', 'String', Measures.WRS.L.listNumber, 'Position',[1140-430 350 40 boxheight]);

uicontrol(fig,'Style', 'text', 'String','Speech Level', 'Position', [880-430 330 150 boxheight], 'HorizontalAlignment','left');
LwrsSLevel = uicontrol(fig,'Style','edit', 'String', Measures.WRS.L.speechLevel, 'Position',[950-430 330 50 20]);

uicontrol(fig,'Style', 'text', 'String','Masking Level', 'Position', [1005-430 330 150 boxheight], 'HorizontalAlignment','left');
LwrsMLevel = uicontrol(fig,'Style','edit', 'String', Measures.WRS.L.maskingLevel, 'Position',[1080-430 330 50 20]);

uicontrol(fig,'Style', 'text', 'String','# correct', 'Position', [880-430 310 150 boxheight], 'HorizontalAlignment','left');
LwrsNumCorrect = uicontrol(fig,'Style','edit', 'String', Measures.WRS.L.numberWordCorrect, 'Position',[930-430 310 50 20]);

uicontrol(fig,'Style', 'text', 'String','total #', 'Position', [990-430 310 150 boxheight], 'HorizontalAlignment','left');
LwrsTotalNum = uicontrol(fig,'Style','edit', 'String', Measures.WRS.L.totalWordsPresented, 'Position',[1020-430 310 50 20]);

uicontrol(fig,'Style', 'text', 'String','% correct', 'Position', [1080-430 310 150 boxheight], 'HorizontalAlignment','left');
LwrsPercentCorrect = uicontrol(fig,'Style','edit', 'String', Measures.WRS.L.percentCorrect, 'Position',[1130-430 310 50 20]);


uicontrol(fig,'Style','text','String','Equipment','Position',[880-430 280 60 20],'HorizontalAlignment','left');
WRSEquipment = uicontrol(fig,'Style','edit','String', Measures.WRS.equipment.device,'Position',[940-430 280 120 20]);

uicontrol(fig,'Style','text','String','Calib Date','Position',[880-430 260 60 20],'HorizontalAlignment','left');
WRSEquipmentCalibDate = uicontrol(fig,'Style','edit','String', Measures.WRS.equipment.calibDate,'Position',[940-430 260 120 20]);

uicontrol(fig,'Style','text','String','Serial #','Position',[880-430 240 60 20],'HorizontalAlignment','left');
WRSEquipmentSerialNumber = uicontrol(fig,'Style','edit','String', Measures.WRS.equipment.serialNumber,'Position',[940-430 240 120 20]);

uicontrol(fig,'Style','text','String','WRS Comment','Position',[1070-430 280 100 20],'HorizontalAlignment','left');
WRSComments = uicontrol(fig,'Style','edit','String', Measures.WRS.comments,'Position',[1070-430 220 110 60]);


% ==== SUBMIT BUTTON ====
uicontrol(fig,'Style', 'pushbutton','String','Submit & Save','ForegroundColor','k','BackgroundColor','g', 'FontSize', 14, 'FontWeight', 'bold','Position', [260 40 150 40],...
    'Callback', @(src, event)submitCallback());

% ==== CALLBACK FUNCTION ====
    function submitCallback()
        % Update visit struct from GUI
        disp('Saving Subject Info...')
        visit2.Subject.ID = subjID.String;
        visit2.Subject.age = str2double(age.String);
        visit2.Subject.gender = gender.Value;
        visit2.Subject.amplification = amplification.Value;

        disp('Saving Visit Info...')
        visit2.VisitInfo.testDate = datetime(testDate.String, 'InputFormat', 'MMddyyyy');
        visit2.VisitInfo.referringLab = referringLab.String;
        visit2.VisitInfo.irbNumber = irbNumber.String; %type?
        visit2.VisitInfo.ARDRsigned = ARDRsigned.Value; %type?
        visit2.VisitInfo.researcher = researcher.String;
        visit2.VisitInfo.researcherOther = researcherOther.String;
        visit2.VisitInfo.studyProtocol = studyProtocol.String;
        visit2.VisitInfo.location = location.String;
        visit2.VisitInfo.room = room.String;
        visit2.VisitInfo.dateCompiled = dateCompiled.String; %type

        disp('Saving Measures...')

        if aud_checkbox.Value == 0
            disp('No Audiometry to Save')
        else
            disp('    Audiometry...')
            visit2.Measures.Audiometry.AC.R = cleanAudio(Measures.Audiometry.AC.R);
            visit2.Measures.Audiometry.AC.L = cleanAudio(Measures.Audiometry.AC.L);
            visit2.Measures.Audiometry.BC.R = cleanAudio(Measures.Audiometry.BC.R);
            visit2.Measures.Audiometry.BC.L = cleanAudio(Measures.Audiometry.BC.L);
            visit2.Measures.Audiometry.equipment.AC_transducer = AC_trans.String;
            visit2.Measures.Audiometry.equipment.BC_transducer = BC_trans.String;
            visit2.Measures.Audiometry.equipment.AC_HardwareLimits = AC_Limit.String;
            visit2.Measures.Audiometry.equipment.BC_HardwareLimits = BC_Limit.String;
            visit2.Measures.Audiometry.equipment.device = Auddevice.String;
            visit2.Measures.Audiometry.equipment.calibDate = AudcalibDate.String; %Type
            visit2.Measures.Audiometry.equipment.serialNumber = Audserialnum.String; %Type
            visit2.Measures.Audiometry.comments = Audcomments.String;
        end

        if quicksin_checkbox.Value == 0
            disp('No QuickSIN data')
        else
            disp('    QuickSIN...')
            visit2.Measures.QuickSIN.R = RquickSIN.String; %DNT Checkbox
            visit2.Measures.QuickSIN.L = LquickSIN.String; %DNT Checkbox
            visit2.Measures.QuickSIN.Bin = BquickSIN.String; %DNT Checkbox
            visit2.Measures.QuickSIN.equipment.device = QSequipdevice.String;
            visit2.Measures.QuickSIN.equipment.calibDate = QSequipcalib.String; %Type
            visit2.Measures.QuickSIN.equipment.serialNumber = QSequipSN.String; %Type
            visit2.Measures.QuickSIN.comments = QScomments.String;
        end

        if dp_checkbox.Value == 0
            disp('no DPOAE Data')
        else
            disp('    DPOAEs...')
            visit2.Measures.DPOAE.R.noisefloor = Measures.DPOAE.R.noisefloor;
            visit2.Measures.DPOAE.R.mean_response = Measures.DPOAE.R.mean_response;
            visit2.Measures.DPOAE.R.f1 = Measures.DPOAE.R.f1;
            visit2.Measures.DPOAE.R.f2 = Measures.DPOAE.R.f2;
            visit2.Measures.DPOAE.R.DP = Measures.DPOAE.R.DP;
            visit2.Measures.DPOAE.R.f1_rec_dB = Measures.DPOAE.R.f1_rec_dB;
            visit2.Measures.DPOAE.R.f2_rec_dB = Measures.DPOAE.R.f2_rec_dB;
            visit2.Measures.DPOAE.R.fs = Measures.DPOAE.R.fs;
            visit2.Measures.DPOAE.L.noisefloor = Measures.DPOAE.L.noisefloor;
            visit2.Measures.DPOAE.L.mean_response = Measures.DPOAE.L.mean_response;
            visit2.Measures.DPOAE.L.f1 = Measures.DPOAE.L.f1;
            visit2.Measures.DPOAE.L.f2 = Measures.DPOAE.L.f2;
            visit2.Measures.DPOAE.L.DP = Measures.DPOAE.L.DP;
            visit2.Measures.DPOAE.L.f1_rec_dB = Measures.DPOAE.L.f1_rec_dB;
            visit2.Measures.DPOAE.L.f2_rec_dB = Measures.DPOAE.L.f2_rec_dB;
            visit2.Measures.DPOAE.L.fs = Measures.DPOAE.L.fs;
            visit2.Measures.DPOAE.other.researcher  = DPOAEresearcher.String;
            visit2.Measures.DPOAE.equipment.device = DPOAEdevice.String;
            visit2.Measures.DPOAE.equipment.calibDate = DPOAEcalibDate.String; %Type
            visit2.Measures.DPOAE.equipment.serialNumber = DPOAEserialnum.String; %Type
            visit2.Measures.DPOAE.comments = DPOAEcomments.String;
        end

        if memr_checkbox.Value == 0
            disp('No MEMR data')
        else
            disp('    MEMR...')
            visit2.Measures.Reflexes.Frequencies = [500 1e3 2e3 4e3];
            visit2.Measures.Reflexes.ProbeR.Ipsi = Measures.Reflexes.ProbeR.Ipsi;
            visit2.Measures.Reflexes.ProbeR.Contra = Measures.Reflexes.ProbeR.Contra;
            visit2.Measures.Reflexes.ProbeL.Ipsi = Measures.Reflexes.ProbeL.Ipsi;
            visit2.Measures.Reflexes.ProbeL.Contra = Measures.Reflexes.ProbeL.Contra;
            visit2.Measures.Reflexes.equipment.device = MEMRequipment.String;
            visit2.Measures.Reflexes.equipment.calibDate = MEMRcalibDate.String; %Type
            visit2.Measures.Reflexes.equipment.serialNumber = MEMRserialNum.String; %Type
            visit2.Measures.Reflexes.comments = MEMRcomments.String;
        end

        if wrs_checkbox.Value == 0
            disp('No WRS data')
        else
            disp('    WRS...') %add by difficulty checkbox
            visit2.Measures.WRS.R.speechLevel = RwrsSLevel.String; %Type;
            visit2.Measures.WRS.R.maskingLevel = RwrsMlevel.String; %Type
            visit2.Measures.WRS.R.numberWordCorrect = RwrsNumCorrect.String; %Type
            visit2.Measures.WRS.R.totalWordsPresented = RwrsTotalNum.String; %Type
            visit2.Measures.WRS.R.list = RwrsList.String;
            visit2.Measures.WRS.R.listNumber = RwrsListNum.String; %Type
            visit2.Measures.WRS.R.percentCorrect = RwrsPercentCorrect.String; %Type
            visit2.Measures.WRS.L.speechLevel = LwrsSLevel.String; %Type
            visit2.Measures.WRS.L.maskingLevel = LwrsMLevel.String; %Type;
            visit2.Measures.WRS.L.numberWordCorrect = LwrsNumCorrect.String; %Type;
            visit2.Measures.WRS.L.totalWordsPresented = LwrsTotalNum.String; %Type;
            visit2.Measures.WRS.L.list = LwrsList.String;
            visit2.Measures.WRS.L.listNumber = LwrsListNum.String; %Type
            visit2.Measures.WRS.L.percentCorrect = LwrsPercentCorrect.String; %Type
            visit2.Measures.WRS.equipment.device = WRSEquipment.String;
            visit2.Measures.WRS.equipment.calibDate = WRSEquipmentCalibDate.String; %Type
            visit2.Measures.WRS.equipment.serialNumber = WRSEquipmentSerialNumber.String; %Type
            visit2.Measures.WRS.comments = WRSComments.String;
        end

        if act_checkbox.Value == 0
            disp('    No ACT...')
        else
            visit2.Measures.ACT.scores = ""; %% need to add this
            visit2.Measures.ACT.comments = ""; %% need to add this (old and new)
            visit2.Measures.ACT.equipment.device = ACTEquipment.String;
            visit2.Measures.ACT.equipment.calibDate = ACTCalib.String; %Type
            visit2.Measures.ACT.equipment.serialNumber = ACTSerialNum.String; %Type
        end

        if wbt_checkbox.Value == 0
            disp('No WBT data')
        else
            disp('    WBT...') %Some of these are not editable
            visit2.Measures.WBT.L.PRESSURE = Measures.WBT.L.PRESSURE;
            visit2.Measures.WBT.L.FREQ = Measures.WBT.L.FREQ;
            visit2.Measures.WBT.L.ABSORBANCE = Measures.WBT.L.ABSORBANCE;
            visit2.Measures.WBT.R.PRESSURE = Measures.WBT.R.PRESSURE;
            visit2.Measures.WBT.R.FREQ = Measures.WBT.R.FREQ;
            visit2.Measures.WBT.R.ABSORBANCE = Measures.WBT.R.ABSORBANCE;
            visit2.Measures.WBT.comments = WBTComments.String;
            visit2.Measures.WBT.equipment.device = WBTEquipment.String;
            visit2.Measures.WBT.equipment.calibDate = WBTEquipmentCalibDate.String; %Type
            visit2.Measures.WBT.equipment.serialNumber = WBTEquipmentSerialNumber.String; %Type
        end

        if otoscopy_checkbox == 0
            disp("No otoscopy info")
        else
            visit2.Measures.Otoscopy.comments = otoComments.String;
            visit2.Measures.Otoscopy.equipment = otoEquipment.String;
        end
        visit3 = visit2;

        dirToSave = path;
        fileToSave = [extractBefore(file, '.mat'), '_new.mat']

        % Save updated struct back to file
        save(fullfile(dirToSave, fileToSave), 'visit3');
        msgbox('visit data saved successfully!', 'Success');
    end
end
