%function simpleVisitEditor()

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
fields.Subject.ID = "";
fields.Subject.age = "";
fields.Subject.gender = "";
fields.Subject.amplification = "";
fields.VisitInfo.testDate = "";
fields.VisitInfo.referringLab = "";
fields.VisitInfo.irbNumber = "";
fields.VisitInfo.ARDRsigned = "";
fields.VisitInfo.researcher = "";
fields.VisitInfo.researcherOther = "";
fields.VisitInfo.studyProtocol = "";
fields.VisitInfo.location = "";
fields.VisitInfo.room = "";
fields.VisitInfo.dateCompiled = "";

fields.Measures.Audiometry.AC.R = [];
fields.Measures.Audiometry.AC.L = [];
fields.Measures.Audiometry.BC.R = [];
fields.Measures.Audiometry.BC.L = [];
fields.Measures.Audiometry.equipment.AC_transducer = "";
fields.Measures.Audiometry.equipment.BC_transducer = "";
fields.Measures.Audiometry.equipment.AC_HardwareLimits = "";
fields.Measures.Audiometry.equipment.BC_HardwareLimits = "";
fields.Measures.Audiometry.equipment.device = "";
fields.Measures.Audiometry.equipment.calibDate = "";
fields.Measures.Audiometry.equipment.serialNumber = "";
fields.Measures.Audiometry.comments = "";

fields.Measures.QuickSIN.R = "";
fields.Measures.QuickSIN.L = "";
fields.Measures.QuickSIN.Bin = "";
fields.Measures.QuickSIN.equipment.device = "";
fields.Measures.QuickSIN.equipment.calibDate = "";
fields.Measures.QuickSIN.equipment.serialNumber = "";
fields.Measures.QuickSIN.comments = "";

fields.Measures.DPOAE.R.noisefloor = "";
fields.Measures.DPOAE.R.mean_response = "";
fields.Measures.DPOAE.R.f1 = "";
fields.Measures.DPOAE.R.f2 = "";
fields.Measures.DPOAE.R.DP = "";
fields.Measures.DPOAE.R.f1_rec_dB = "";
fields.Measures.DPOAE.R.f2_rec_dB = "";
fields.Measures.DPOAE.R.fs = "";
fields.Measures.DPOAE.L.noisefloor = "";
fields.Measures.DPOAE.L.mean_response = "";
fields.Measures.DPOAE.L.f1 = "";
fields.Measures.DPOAE.L.f2 = "";
fields.Measures.DPOAE.L.DP = "";
fields.Measures.DPOAE.L.f1_rec_dB = "";
fields.Measures.DPOAE.L.f2_rec_dB = "";
fields.Measures.DPOAE.L.fs = "";
fields.Measures.DPOAE.other.researcher  = "";
fields.Measures.DPOAE.equipment.device = "";
fields.Measures.DPOAE.equipment.calibDate = "";
fields.Measures.DPOAE.equipment.serialNumber = "";
fields.Measures.DPOAE.comments = "";

fields.Measures.Reflexes.Frequencies = [500 1e3 2e3 4e3];
fields.Measures.Reflexes.ProbeR.Ipsi = "";
fields.Measures.Reflexes.ProbeR.Contra = "";
fields.Measures.Reflexes.ProbeL.Ipsi = "";
fields.Measures.Reflexes.ProbeL.Contra = "";
fields.Measures.Reflexes.equipment.device = "";
fields.Measures.Reflexes.equipment.calibDate = "";
fields.Measures.Reflexes.equipment.serialNumber = "";
fields.Measures.Reflexes.comments = "";

fields.Measures.WRS.R.speechLevel = "";
fields.Measures.WRS.R.maskingLevel = "";
fields.Measures.WRS.R.numberWordCorrect = "";
fields.Measures.WRS.R.totalWordsPresented = "";
fields.Measures.WRS.R.list = "";
fields.Measures.WRS.R.listNumber = "";
fields.Measures.WRS.R.percentCorrect = "";
fields.Measures.WRS.L.speechLevel = "";
fields.Measures.WRS.L.maskingLevel = "";
fields.Measures.WRS.L.numberWordCorrect = "";
fields.Measures.WRS.L.totalWordsPresented = "";
fields.Measures.WRS.L.list = "";
fields.Measures.WRS.L.listNumber = "";
fields.Measures.WRS.L.percentCorrect = "";
fields.Measures.WRS.equipment.device = "";
fields.Measures.WRS.equipment.calibDate = "";
fields.Measures.WRS.equipment.serialNumber = "";
fields.Measures.WRS.comments = "";

fields.Measures.ACT.scores = "";
fields.Measures.ACT.comments = "";
fields.Measures.ACT.equipment.device = "";
fields.Measures.ACT.equipment.calibDate = "";
fields.Measures.ACT.equipment.serialNumber = "";

fields.Measures.WBT.L.PRESSURE = "";
fields.Measures.WBT.L.FREQ = "";
fields.Measures.WBT.L.ABSORBANCE = "";
fields.Measures.WBT.R.PRESSURE = "";
fields.Measures.WBT.R.FREQ = "";
fields.Measures.WBT.R.ABSORBANCE = "";
fields.Measures.WBT.comments = "";
fields.Measures.WBT.equipment.device = "";
fields.Measures.WBT.equipment.calibDate = "";
fields.Measures.WBT.equipment.serialNumber = "";

fields.Measures.Otoscopy.comments = "";
fields.Measures.Otoscopy.equipment = "";

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
            fields.Measures.Audiometry.AC.R = visit.Measures.(meas{f}).AC.R;
            fields.Measures.Audiometry.AC.L = visit.Measures.(meas{f}).AC.L;
            fields.Measures.Audiometry.BC.R = visit.Measures.(meas{f}).BC.R;
            fields.Measures.Audiometry.BC.L = visit.Measures.(meas{f}).BC.L;

            if isfield(visit.Measures.(meas{f}), 'equipment')
                fields.Measures.Audiometry.equipment.AC_transducer = visit.Measures.(meas{f}).equipment.AC_transducer;
                fields.Measures.Audiometry.equipment.BC_transducer = visit.Measures.(meas{f}).equipment.BC_transducer;
                fields.Measures.Audiometry.equipment.AC_HardwareLimits = visit.Measures.(meas{f}).equipment.AC_HardwareLimits;
                fields.Measures.Audiometry.equipment.BC_HardwareLimits = visit.Measures.(meas{f}).equipment.BC_HardwareLimits;
                fields.Measures.Audiometry.equipment.device = visit.Measures.(meas{f}).equipment.device;
                fields.Measures.Audiometry.equipment.calibDate = visit.Measures.(meas{f}).equipment.calibDate;
                fields.Measures.Audiometry.equipment.serialNumber = visit.Measures.(meas{f}).equipment.serialNumber;
                fields.Measures.Audiometry.comments = visit.Measures.(meas{f}).comments;
            else
                fields.Measures.Audiometry.equipment.AC_transducer = visit.Measures.(meas{f}).AC_transducer;
                fields.Measures.Audiometry.equipment.BC_transducer = visit.Measures.(meas{f}).BC_transducer;
                fields.Measures.Audiometry.equipment.AC_HardwareLimits = visit.Measures.(meas{f}).AC_HardwareLimits;
                fields.Measures.Audiometry.equipment.BC_HardwareLimits = visit.Measures.(meas{f}).BC_HardwareLimits;
            end

            %Check for QuickSIN Data
        elseif contains(meas{f}, 'Quick', 'IgnoreCase', 1)
            quicksin_yes = 1;
            disp("    Retrieving QuickSIN Data...")
            fields.Measures.QuickSIN.R = visit.Measures.(meas{f}).R;
            fields.Measures.QuickSIN.L = visit.Measures.(meas{f}).L;
            try
                fields.Measures.QuickSIN.Bin = visit.Measures.(meas{f}).Bin;
            catch
                fields.Measures.QuickSIN.Bin = "";
            end
            try
                fields.Measures.QuickSIN.equipment.device = visit.Measures.(meas{f}).equipment.device;
            catch
                disp('Measures.QuickSIN.equipment.device not obtained')
            end
            try
                fields.Measures.QuickSIN.equipment.calibDate = visit.Measures.(meas{f}).equipment.calibDate;
            catch
                disp('Measures.QuickSIN.equipment.calibDate not obtained')
            end
            try
                fields.Measures.QuickSIN.equipment.serialNumber = visit.Measures.(meas{f}).equipment.serialNumber;
            catch
                disp('Measures.QuickSIN.equipment.serialNumber not found')
            end
            try
                fields.Measures.QuickSIN.comments = visit.Measures.(meas{f}).comments;
            catch
                disp('Measures.QuickSIN.comments not found')
            end
            % Check for DPOAE Data
        elseif contains(meas{f}, 'dpoae', 'IgnoreCase', 1)
            disp("    Retrieving DPOAE Data...")
            dp_yes = 1;
            fields.Measures.DPOAE.R = visit.Measures.(meas{f}).R;
            fields.Measures.DPOAE.L = visit.Measures.(meas{f}).L;
            fields.Measures.DPOAE.other.researcher  = visit.Measures.(meas{f}).other.researcher;
            try
                fields.Measures.DPOAE.equipment = visit.Measures.(meas{f}).equipment;
                fields.Measures.DPOAE.comments = visit.Measures.(meas{f}).comments;
            end

            % Check for Reflexes Data
        elseif contains(meas{f}, 'Reflex', 'IgnoreCase', 1)
            disp("    Retrieving Reflexes Data...")
            memr_yes = 1;
            fields.Measures.Reflexes.ProbeR = visit.Measures.(meas{f}).ProbeR;
            fields.Measures.Reflexes.ProbeL = visit.Measures.(meas{f}).ProbeL;
            try
                fields.Measures.Reflexes.equipment = visit.Measures.(meas{f}).equipment;
            catch
                disp("reflex data does not contain equipment info")
            end

            try
                fields.Measures.Reflexes.comments = visit.Measures.(meas{f}).comments;
            catch
                disp("reflex data does not contain comments")
            end

            % Check for WRS Data
        elseif contains(meas{f}, 'WRS', 'IgnoreCase', 1)
            disp("    Retrieving WRS Data...")
            wrs_yes = 1;
            fields.Measures.WRS.R = visit.Measures.(meas{f}).R;
            fields.Measures.WRS.L = visit.Measures.(meas{f}).L;

            try
                fields.Measures.WRS.equipment= visit.Measures.(meas{f}).equipment;
                fields.Measures.WRS.comments = visit.Measures.(meas{f}).comments;
            end
            %%% This section is overwriting the origional initialized variables. When
            %%% ACT is present in the comment it removes the scores so it cannot be
            %%% plotted later

            % Check for ACT Data
        elseif contains(meas{f}, 'ACT', 'IgnoreCase', 1)
            disp("    Retrieving ACT Data...")
            act_yes =1;
            try
                fields.Measures.ACT.scores = visit.Measures.ACT.scores; %not real
            catch
                fields.Measures.ACT.scores = "";
            end
            try
                fields.Measures.ACT.comments = visit.Measures.ACT.comments;
            catch
                fields.Measures.ACT.comments = "";
            end
            try
                fields.Measures.ACT.equipment.device = visit.Measures.ACT.equipment.device;
            catch
                fields.Measures.ACT.equipment.device = "";
            end
            try
                fields.Measures.ACT.equipment.calibDate = visit.Measures.ACT.equipment.calibDate;
            catch
                fields.Measures.ACT.equipment.calibDate = "";
            end
            try
                fields.Measures.ACT.equipment.serialNumber = visit.Measures.ACT.equipment.serialNumber;
            catch
                fields.Measures.ACT.equipment.serialNumber = "";
            end

            % try
            %     fields.Measures.ACT = visit.Measures.ACT;
            % catch
            %     warning("Does not have ACT info")
            %
            % end

            %Check for WBT Data
        elseif contains(meas{f}, 'WBT', 'IgnoreCase', 1)
            disp("    Retrieving WBT Data...")
            wbt_yes = 1;
            fields.Measures.WBT.R = visit.Measures.(meas{f}).R;
            fields.Measures.WBT.L = visit.Measures.(meas{f}).L;

            try
                fields.Measures.WBT.equipment = visit.Measures.(meas{f}).equipment;
                fields.Measures.WBT.comments = visit.Measures.(meas{f}).comments;
            catch
                disp("Does not have WBT equipment info")
            end

            % % Check for Otoscopy Data Error
        elseif contains(meas{f}, 'otoscopy', 'IgnoreCase', 1)
            disp("    Retrieving Otoscopy Data...")
            oto_yes = 1;
            fields.Measures.Otoscopy.comments = visit.Measures.Otoscopy.comments;
            fields.Measures.Otoscopy.equipment = visit.Measures.Otoscopy.equipment;
        end
    end
end

%% if the measures are stored in the visit. structure ie. ARDC 37
%%% i tried to set this up as an if, ifelse loop, but it was not working in
%%% that format
if isfield(visit, 'Audiogram')
    disp('    Retrieving Audiogram data...')
    try
        fields.Measures.Audiometry.AC.R = visit.Audiogram.AC.R;
    catch
        disp('Measures.Audiometry.AC.R not retrieved')
    end
    try
        fields.Measures.Audiometry.AC.L = visit.Audiogram.AC.L;
    catch
        disp('Measures.Audiometry.AC.L not retrieved')
    end
    try
        fields.Measures.Audiometry.BC.R = visit.Audiogram.BC.R;
    catch
        disp('Measures.Audiometry.BC.R not retrieved')
    end
    try
        fields.Measures.Audiometry.BC.L = visit.Audiogram.BC.L;
    catch
        disp('Measures.Audiometry.BC.L not retrieved')
    end

    try
        fields.Measures.Audiometry.equipment.AC_transducer = visit.Audiogram.AC_transducer;
    catch
        disp('Measures.Audiometry.equipment.AC_transducer not retrieved')
    end
    try
        fields.Measures.Audiometry.equipment.BC_transducer = visit.Audiogram.BC_transducer;
    catch
        disp('Measures.Audiometry.equipment.BC_transducer not retrieved')
    end
    try
        fields.Measures.Audiometry.equipment.AC_HardwareLimits = visit.Audiogram.AC_HardwareLimits;
    catch
        disp('Measures.Audiometry.equipment.AC_HardwareLimits not retrieved')
    end
    try
        fields.Measures.Audiometry.equipment.BC_HardwareLimits = visit.Audiogram.BC_HardwareLimits;
    catch
        disp('Measures.Audiometry.equipment.BC_HardwareLimits not retrieved')
    end
end
if isfield(visit, 'QuickSIN')
    disp('    Retrieving QuickSIN data...')
    try
        fields.Measures.QuickSIN.R = visit.QuickSIN.R;
    catch
        disp('Measures.QuickSIN.R not retrieved')
    end
    try
        fields.Measures.QuickSIN.L = visit.QuickSIN.L;
    catch
        disp('Measures.QuickSIN.L not retrieved')
    end
end
%%
if isfield(visit, 'dpOAE')
    disp('    DPOAEs')
    %Right
    try
        fields.Measures.DPOAE.R.noisefloor = visit.dpOAE.R.noisefloor;
    catch
        disp('Measures.DPOAE.R.noisefloor not retrieved')
    end
    try
        fields.Measures.DPOAE.R.mean_response = visit.dpOAE.R.mean_response;
    catch
        disp('Measures.DPOAE.R.mean_response not retrieved')
    end
    try
        fields.Measures.DPOAE.R.f1 = visit.dpOAE.R.f1;
    catch
        disp('Measures.DPOAE.R.f1 not retrieved')
    end
    try
        fields.Measures.DPOAE.R.f2 = visit.dpOAE.R.f2;
    catch
        disp('Measures.DPOAE.R.f2 not retrieved')
    end
    try
        fields.Measures.DPOAE.R.DP = visit.dpOAE.R.DP;
    catch
        disp('Measures.DPOAE.R.DP not retrieved')
    end
    try
        fields.Measures.DPOAE.R.f1_rec_dB = visit.dpOAE.R.f1_rec_dB;
    catch
        disp('Measures.DPOAE.R.f1_rec_dB not retrieved')
    end
    try
        fields.Measures.DPOAE.R.f2_rec_dB = visit.dpOAE.R.f2_rec_dB;
    catch
        disp('Measures.DPOAE.R.f2_rec_dB not retrieved')
    end
    try
        fields.Measures.DPOAE.R.fs = visit.dpOAE.R.fs;
    catch
        disp('Measures.DPOAE.R.f2_rec_dB not retrieved')
    end

    %Left
    try
        fields.Measures.DPOAE.L.noisefloor = visit.dpOAE.L.noisefloor;
    catch
        disp('Measures.DPOAE.L.noisefloor not retrieved')
    end
    try
        fields.Measures.DPOAE.L.mean_response = visit.dpOAE.L.mean_response;
    catch
        disp('Measures.DPOAE.L.mean_response not retrieved')
    end
    try
        fields.Measures.DPOAE.L.f1 = visit.dpOAE.L.f1;
    catch
        disp('Measures.DPOAE.L.f1 not retrieved')
    end
    try
        fields.Measures.DPOAE.L.f2 = visit.dpOAE.L.f2;
    catch
        disp('Measures.DPOAE.L.f2 not retrieved')
    end
    try
        fields.Measures.DPOAE.L.DP = visit.dpOAE.L.DP;
    catch
        disp('Measures.DPOAE.L.DP not retrieved')
    end
    try
        fields.Measures.DPOAE.L.f1_rec_dB = visit.dpOAE.L.f1_rec_dB;
    catch
        disp('Measures.DPOAE.L.f1_rec_dB not retrieved')
    end
    try
        fields.Measures.DPOAE.L.f2_rec_dB = visit.dpOAE.L.f2_rec_dB;
    catch
        disp('Measures.DPOAE.L.f2_rec_dB not retrieved')
    end
    try
        fields.Measures.DPOAE.L.fs = visit.dpOAE.L.fs;
    catch
        disp('Measures.DPOAE.L.f2_rec_dB not retrieved')
    end
end

if isfield(visit, 'WBT')
    disp ('    WBT...')
    try
        fields.Measures.WBT.L.PRESSURE = visit.WBT.L.PRESSURE;
    catch
        disp('Measures.WBT.L.PRESSURE not retrieved')
    end
    try
        fields.Measures.WBT.L.FREQ = visit.WBT.L.FREQ;
    catch
        disp('Measures.WBT.L.FREQ not retrieved')
    end
    try
        fields.Measures.WBT.L.ABSORBANCE = visit.WBT.L.ABSORBANCE;
    catch
        disp('Measures.WBT.L.FREQ not retrieved')
    end

    try
        fields.Measures.WBT.R.PRESSURE = visit.WBT.R.PRESSURE;
    catch
        disp('Measures.WBT.R.PRESSURE not retrieved')
    end
    try
        fields.Measures.WBT.R.FREQ = visit.WBT.R.FREQ;
    catch
        disp('Measures.WBT.R.FREQ not retrieved')
    end
    try
        fields.Measures.WBT.R.ABSORBANCE = visit.WBT.R.ABSORBANCE;
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
dropdown_lab(end+1) = "";
dropdown_IRB = table2array(IRBs(:,"IRBnum"));
dropdown_IRB(end+1) = "";

% Other standard dropdowns, not read from CSV. Could be edited if needed.
dropdown_gender = {'Male', 'Female', 'Non-binary', 'No Response'};  % Replace with your options
dropdown_amplification = {'None', 'Hearing Aids', 'Cochlear Implant','Other', 'Unknown'};

% Get all locations
all_locs = dir("DataSheets\Equipment_*");
for i = 1:numel(all_locs)
    locations(i) = extractBetween(all_locs(i).name, 'Equipment_', '_');
    rms(i) = extractBetween(all_locs(i).name, sprintf('Equipment_%s_', locations{i}), '.csv');
end
unique_locations = unique(locations);

% Create figure window
boxheight = 20;
figheight = 600;
fig = uifigure('Name', 'Visit Editor', 'Position', [100 100 760 figheight]);
labelboxwidth = 140;
labelboxhieght = 20;


% ==== SUBJECT INFO ====
uilabel(fig,'Text','Subject ID','Position',[20 570 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.subjID = uieditfield(fig, 'Value',Subject.ID,'Position',[90 570 140 20]);

uilabel(fig,'Text','Age','Position',[20 550 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.age = uieditfield(fig, 'Value',num2str(Subject.age),'Position',[90 550 140 20]);

uilabel(fig,'Text','Gender','Position',[20 530 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.gender = uidropdown(fig,'Value', Subject.gender,'Items',dropdown_gender, 'Position',[90 530 140 20]);

uilabel(fig,'Text', 'Amplification','Position',[20 510 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.amplification = uidropdown(fig,'Value', Subject.amplification,'Items', dropdown_amplification, 'Position',[90 510 140 20]);


% ==== VISIT INFO ====
uilabel(fig,'Text','Test Date','Position',[20 480 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.testDate = uidatepicker(fig, 'Value', VisitInfo.testDate,'Position',[90 480 140 20]);

% Needs to be dropdowns:
uilabel(fig,'Text','Refer Lab','Position',[20 460 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.referringLab = uidropdown(fig, 'Value',VisitInfo.referringLab,'Items', dropdown_lab, 'Position',[90 460 140 20]);

uilabel(fig,'Text','IRB #','Position',[20 440 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.irbNumber = uidropdown(fig, 'Value',VisitInfo.irbNumber, 'Items', dropdown_IRB, 'Position',[90 440 140 20]);

uilabel(fig,'Text','ARDRsigned','Position',[20 420 labelboxwidth labelboxhieght],'HorizontalAlignment','left');

fields.isARDRsigned = 'unknown';
if strcmp(VisitInfo.ARDRsigned, "1")
    isARDRsigned = 'Yes';
elseif strcmp(VisitInfo.ARDRsigned, "0")
    isARDRsigned = 'No';
end
fields2edit.ARDRsigned = uidropdown(fig, 'Value',fields.isARDRsigned, 'Items', {'Yes', 'No', 'unknown'}, 'Position',[90 420 140 20]);

uilabel(fig,'Text','researcher','Position',[20 400 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.researcher = uieditfield(fig, 'Value',VisitInfo.researcher,'Position',[90 400 140 20]);

uilabel(fig,'Text','researcherOther','Position',[20 380 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.researcherOther = uieditfield(fig, 'Value',VisitInfo.researcherOther,'Position',[90 380 140 20]);

uilabel(fig,'Text','studyProtocol','Position',[20 360 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.studyProtocol = uieditfield(fig, 'Value',VisitInfo.studyProtocol,'Position',[90 360 140 20]);

uilabel(fig,'Text','location','Position',[20 340 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.location = uieditfield(fig, 'Value',VisitInfo.location,'Position',[90 340 140 20]);

uilabel(fig,'Text','room','Position',[20 320 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.room = uieditfield(fig, 'Value',VisitInfo.room,'Position',[90 320 140 20]);

uilabel(fig,'Text','dateCompiled','Position',[20 300 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.dateCompiled = uieditfield(fig, 'Value',string(VisitInfo.dateCompiled),'Position',[90 300 140 20]);

% ==== Audiometry ====
fields2edit.aud_checkbox = uicheckbox(fig,'Value',audio_yes,'Position',[20 280 labelboxwidth labelboxhieght]);
uilabel(fig,'Text','Audiometry','Position',[20+20 280 labelboxwidth-20 labelboxhieght],'HorizontalAlignment','left', 'FontWeight', 'bold');

uilabel(fig,'Text','AC_trans','Position',[20 260 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.AC_trans = uieditfield(fig, 'Value', fields.Measures.Audiometry.equipment.AC_transducer,'Position',[90 260 140 20]);

uilabel(fig,'Text','BC_trans','Position',[20 240 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.BC_trans = uieditfield(fig, 'Value', fields.Measures.Audiometry.equipment.BC_transducer,'Position',[90 240 140 20]);

uilabel(fig,'Text','AC_Limit','Position',[20 220 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.AC_Limit = uieditfield(fig, 'Value', string(fields.Measures.Audiometry.equipment.AC_HardwareLimits(1,1)),'Position',[90 220 140 20]);

uilabel(fig,'Text', 'BC_Limit','Position',[20 200 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.BC_Limit = uieditfield(fig, 'Value', string(fields.Measures.Audiometry.equipment.BC_HardwareLimits(1,1)),'Position',[90 200 140 20]);

uilabel(fig,'Text','device','Position',[20 180 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.Auddevice = uieditfield(fig, 'Value', fields.Measures.Audiometry.equipment.device,'Position',[90 180 140 20]);

uilabel(fig,'Text', 'Serial #','Position',[20 160 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.Audserialnum = uieditfield(fig, 'Value', fields.Measures.Audiometry.equipment.serialNumber,'Position',[90 160 140 20]);

uilabel(fig,'Text','calibDate','Position',[20 140 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.AudcalibDate = uieditfield(fig, 'Value', fields.Measures.Audiometry.equipment.calibDate,'Position',[90 140 140 20]);

uilabel(fig,'Text','comments','Position',[20 120 labelboxwidth labelboxhieght],'HorizontalAlignment','left');
fields2edit.Audcomments = uieditfield(fig, 'Value', fields.Measures.Audiometry.comments{1,1},'Position',[90 40 140 100]);

% ==== DPOAEs ====
fields2edit.dp_checkbox = uicontrol(fig,'Style','checkbox','Value',dp_yes,'Position',[240 570 labelboxwidth labelboxhieght],'HorizontalAlignment','left', 'FontWeight', 'bold');
uilabel(fig,'Text','DPOAEs','Position',[240+20 570 labelboxwidth-20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');

uilabel(fig,'Text','researcher','Position',[240 550 labelboxwidth 20],'HorizontalAlignment','left');
fields2edit.DPOAEresearcher = uieditfield(fig, 'Value', fields.Measures.DPOAE.other.researcher,'Position',[300 550 140 20]);

uilabel(fig,'Text','device','Position',[240 530 labelboxwidth 20],'HorizontalAlignment','left');
fields2edit.DPOAEdevice = uieditfield(fig, 'Value', fields.Measures.DPOAE.equipment.device,'Position',[300 530 140 20]);

uilabel(fig,'Text','calibDate','Position',[240 510 labelboxwidth 20],'HorizontalAlignment','left');
fields2edit.DPOAEcalibDate = uieditfield(fig, 'Value', fields.Measures.DPOAE.equipment.calibDate,'Position',[300 510 140 20]);

uilabel(fig,'Text','Serial #','Position',[240 490 labelboxwidth 20],'HorizontalAlignment','left');
fields2edit.DPOAEserialnum = uieditfield(fig, 'Value', fields.Measures.DPOAE.equipment.serialNumber,'Position',[300 490 140 20]);

uilabel(fig,'Text','comments','Position',[240 470 labelboxwidth 20],'HorizontalAlignment','left');
fields2edit.DPOAEcomments = uieditfield(fig, 'Value', fields.Measures.DPOAE.comments{1,1},'Position',[300 430 140 60]);

%====MEMR====
fields2edit.memr_checkbox = uicontrol(fig,'Style','checkbox','Value',memr_yes,'Position',[240 410 labelboxwidth labelboxhieght],'HorizontalAlignment','left', 'FontWeight', 'bold');
uilabel(fig,'Text','MEMR','Position',[240+20 410 labelboxwidth-20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');

uilabel(fig,'Text','equipment','Position',[240 390 labelboxwidth 20],'HorizontalAlignment','left');
fields2edit.MEMRequipment = uieditfield(fig, 'Value', fields.Measures.Reflexes.equipment.device,'Position',[300 390 140 20]);

uilabel(fig,'Text','calibDate','Position',[240 370 labelboxwidth 20],'HorizontalAlignment','left');
fields2edit.MEMRcalibDate = uieditfield(fig, 'Value', fields.Measures.Reflexes.equipment.calibDate,'Position',[300 370 140 20]);

uilabel(fig,'Text','Serial #','Position',[240 350 labelboxwidth 20],'HorizontalAlignment','left');
fields2edit.MEMRserialNum = uieditfield(fig, 'Value', fields.Measures.Reflexes.equipment.serialNumber,'Position',[300 350 140 20]);

uilabel(fig,'Text','comments','Position',[240 330 labelboxwidth 20],'HorizontalAlignment','left');
fields2edit.MEMRcomments = uieditfield(fig, 'Value', fields.Measures.Reflexes.comments{1,1},'Position',[300 290 140 60]);

% ==== ACT ==== %
fields2edit.act_checkbox = uicontrol(fig,'Style','checkbox','Value',act_yes,'Position',[240 270 20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');
uilabel(fig,'Text','ACT','Position',[240+20 270 140-20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');

%%Error
uilabel(fig,'Text','Trial 1', 'Position', [240 250 140 20], 'HorizontalAlignment','left');
fields2edit.ACTTrialOne = uieditfield(fig,'Value', fields.Measures.ACT.scores, 'Position',[275 250 50 20]);

uilabel(fig,'Text','Trial 2', 'Position', [330 250 140 20], 'HorizontalAlignment','left');
fields2edit.ACTTrialTwo = uieditfield(fig,'Value', fields.Measures.ACT.scores, 'Position',[365 250 50 20]);

uilabel(fig,'Text','One Trial Only', 'Position', [240 230 140 20], 'HorizontalAlignment','left');
fields2edit.ACTSingleTrial = uicontrol(fig,'Style','checkbox', 'Position', [310 230 140 20]);

uilabel(fig,'Text','CNT', 'Position', [330 230 140 20], 'HorizontalAlignment','left');
fields2edit.ACTCNT = uicontrol(fig,'Style','checkbox', 'Position', [360 230 140 20]);

uilabel(fig,'Text','Equipment', 'Position', [240 210 140 20], 'HorizontalAlignment','left');
fields2edit.ACTEquipment = uieditfield(fig,'Value', fields.Measures.ACT.equipment.device, 'Position',[300 210 140 20]);

uilabel(fig,'Text','Calib', 'Position', [240 190 140 20], 'HorizontalAlignment','left');
fields2edit.ACTCalib = uieditfield(fig,'Value', fields.Measures.ACT.equipment.calibDate, 'Position',[300 190 140 20]);

uilabel(fig,'Text','Serial #', 'Position', [240 170 140 20], 'HorizontalAlignment','left');
fields2edit.ACTSerialNum = uieditfield(fig,'Value', fields.Measures.ACT.equipment.serialNumber, 'Position',[300 170 140 20]);

uilabel(fig,'Text','old comments','Position',[240 150 140 20],'HorizontalAlignment','left');
fields2edit.ACToldComments = uieditfield(fig,'Value', fields.Measures.ACT.comments{1,1}, 'Position', [320 130 120 40]);

uilabel(fig,'Text','new comments','Position',[240 110 140 20],'HorizontalAlignment','left')
fields2edit.ACTnewComments = uieditfield(fig,'Value', fields.Measures.ACT.comments{1,1}, 'Position', [320 90 120 40]);


% ==== Otoscopy ====
fields2edit.otoscopy_checkbox = uicontrol(fig,'Style','checkbox','Value',oto_yes,'Position',[1070-430 190 20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');
uilabel(fig,'Text','Otoscopy','Position',[1070-430+20 190 140-20 20],'HorizontalAlignment','left', 'FontWeight','bold');

uilabel(fig,'Text','Equipment','Position',[1070-430 170 60 20],'HorizontalAlignment','left');
fields2edit.otoEquipment = uieditfield(fig, 'Value', fields.Measures.Otoscopy.equipment.device,'Position',[1070-430 150 110 20]);

uilabel(fig,'Text','Comment','Position',[1070-430 120 60 20],'HorizontalAlignment','left');
fields2edit.otoComments = uieditfield(fig, 'Value', fields.Measures.Otoscopy.comments{1,1},'Position',[1070-430 40 110 80]);

% ==== WBT ====
fields2edit.wbt_checkbox = uicontrol(fig,'Style','checkbox','Value',wbt_yes,'Position',[880-430 190 20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');
uilabel(fig,'Text','Wideband Tymp','Position',[880-430+20 190 140-20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');
uilabel(fig,'Text','L','Position',[940-430 170 60 20],'HorizontalAlignment','center');
uilabel(fig,'Text','R','Position',[1000-430 170 60 20],'HorizontalAlignment','center');

uilabel(fig,'Text','Has WBT Data?','Position',[880-430 150 60 40],'HorizontalAlignment','left');

if isnumeric(fields.Measures.WBT.R.PRESSURE(1))
    hasDataR = "Data";
else
    hasDataR = "No Data";
end

if isnumeric(fields.Measures.WBT.L.PRESSURE(1))
    hasDataL = "Data";
else
    hasDataL = "No Data";
end

WBTdataL = uilabel(fig,'Text', hasDataL,'Position',[940-430 150 60 20]);
WBTdataR = uilabel(fig,'Text',hasDataR,'Position',[1000-430 150 60 20]);


uilabel(fig,'Text','Comment','Position',[880-430 130 60 20],'HorizontalAlignment','left');
fields2edit.WBTComments = uieditfield(fig, 'Value', fields.Measures.WBT.comments{1,1},'Position',[940-430 100 120 50]);

uilabel(fig,'Text','Equipment','Position',[880-430 80 60 20],'HorizontalAlignment','left');
fields2edit.WBTEquipment = uieditfield(fig, 'Value', fields.Measures.WBT.equipment.device,'Position',[940-430 80 120 20]);

uilabel(fig,'Text','Calib Date','Position',[880-430 60 60 20],'HorizontalAlignment','left');
fields2edit.WBTEquipmentCalibDate = uieditfield(fig, 'Value', fields.Measures.WBT.equipment.calibDate,'Position',[940-430 60 120 20]);

uilabel(fig,'Text','Serial #','Position',[880-430 40 60 20],'HorizontalAlignment','left');
fields2edit.WBTEquipmentSerialNumber = uieditfield(fig, 'Value', fields.Measures.WBT.equipment.serialNumber,'Position',[940-430 40 120 20]);

% ==== QuickSIN ====
fields2edit.quicksin_checkbox = uicheckbox(fig, 'Value',quicksin_yes,'Position',[880-430 570 20 20]);
uilabel(fig,'Text', 'QuickSIN', 'Position', [880-430+20 570 60 20], 'HorizontalAlignment','left','FontWeight','bold');

uilabel(fig,'Text','RE QuickSIN', 'Position', [880-430 550 150 boxheight], 'HorizontalAlignment','left',  'FontColor', 'red');
fields2edit.RquickSIN = uieditfield(fig, 'Value', string(fields.Measures.QuickSIN.R), 'Position',[945-430 550 30 boxheight]);

uilabel(fig,'Text','DNT', 'Position',[980-430 550 150 boxheight], 'HorizontalAlignment','left','FontColor', 'red');
fields2edit.RquickSINDNT = uicheckbox(fig, 'Position',[1005-430 550 25 boxheight]);

uilabel(fig,'Text','Equip', 'Position',[1025-430 550 150 boxheight], 'HorizontalAlignment','left');
fields2edit.QSequipdevice = uieditfield(fig, 'Value', fields.Measures.QuickSIN.equipment.device, 'Position',[1060-430 550 120 boxheight]);

uilabel(fig,'Text','LE QuickSIN', 'Position', [880-430 530 150 boxheight], 'HorizontalAlignment','left','FontColor', 'blue');
fields2edit.LquickSIN = uieditfield(fig,'Value', string(fields.Measures.QuickSIN.L), 'Position',[945-430 530 30 boxheight]);

uilabel(fig,'Text','DNT', 'Position', [980-430 530 150 boxheight], 'HorizontalAlignment','left','FontColor', 'blue');
fields2edit.LquickSINDNT = uicheckbox(fig, 'Position',[1005-430 530 25 boxheight]);

uilabel(fig,'Text','Calib', 'Position', [1025-430 530 150 boxheight], 'HorizontalAlignment','left');
fields2edit.QSequipcalib = uieditfield(fig,'Value', fields.Measures.QuickSIN.equipment.calibDate, 'Position',[1060-430 530 120 boxheight]);

uilabel(fig,'Text','Bin QuickSIN', 'Position', [880-430 510 150 boxheight], 'HorizontalAlignment','left','FontColor', 'green');
fields2edit.BquickSIN = uieditfield(fig,'Value', string(fields.Measures.QuickSIN.Bin), 'Position',[945-430 510 30 boxheight]);

uilabel(fig,'Text','DNT', 'Position', [980-430 510 150 boxheight], 'HorizontalAlignment','left','FontColor', 'green');
fields2edit.BquickSINDNT = uicontrol(fig,'Style','checkbox', 'Position',[1005-430 510 25 boxheight]);

uilabel(fig,'Text','Serial#', 'Position', [1025-430 510 150 boxheight], 'HorizontalAlignment','left');
fields2edit.QSequipSN = uieditfield(fig,'Value', fields.Measures.QuickSIN.equipment.serialNumber, 'Position',[1060-430 510 120 boxheight]);

uilabel(fig,'Text','Comments', 'Position', [880-430 490 150 boxheight], 'HorizontalAlignment','left');
fields2edit.QScomments = uieditfield(fig,'Value', fields.Measures.QuickSIN.comments{1,1}, 'Position',[945-430 470 235 40]);


% ==== WRS ==== %
fields2edit.wrs_checkbox = uicontrol(fig,'Style','checkbox','Value',wrs_yes,'Position',[880-430 450 20 20],'HorizontalAlignment','left', 'FontWeight', 'bold');
uilabel(fig,'Text','WRS', 'Position', [880-430+20 450 60 20], 'HorizontalAlignment','left', 'FontWeight', 'bold');
uilabel(fig,'Text', 'Right Ear:', 'Position', [880-430 430 60 20], 'HorizontalAlignment','left', 'FontColor','red');

uilabel(fig,'Text','List', 'Position', [930-430 430 60 20], 'HorizontalAlignment','left');
fields2edit.RwrsList = uieditfield(fig,'Value', fields.Measures.WRS.R.list, 'Position',[950-430 430 100 20]);

uilabel(fig,'Text','by diff', 'Position', [1060-430 430 150 boxheight], 'HorizontalAlignment','left');
fields2edit.RwrsListDiff = uicontrol(fig,'Style','checkbox', 'Position',[1090-430 430 25 boxheight]);

uilabel(fig,'Text','List #', 'Position', [1110-430 430 150 boxheight], 'HorizontalAlignment','left');
fields2edit.RwrsListNum = uieditfield(fig,'Value', fields.Measures.WRS.R.listNumber, 'Position',[1140-430 430 40 boxheight]);

uilabel(fig,'Text','Speech Level', 'Position', [880-430 410 150 boxheight], 'HorizontalAlignment','left');
fields2edit.RwrsSLevel = uieditfield(fig,'Value', fields.Measures.WRS.R.speechLevel, 'Position',[950-430 410 50 20]);

uilabel(fig,'Text','Masking Level', 'Position', [1005-430 410 150 boxheight], 'HorizontalAlignment','left');
fields2edit.RwrsMlevel = uieditfield(fig,'Value', fields.Measures.WRS.R.maskingLevel, 'Position',[1080-430 410 50 20]);

uilabel(fig,'Text','# correct', 'Position', [880-430 390 150 boxheight], 'HorizontalAlignment','left');
fields2edit.RwrsNumCorrect = uieditfield(fig,'Value', fields.Measures.WRS.R.numberWordCorrect, 'Position',[930-430 390 50 20]);

uilabel(fig,'Text','total #', 'Position', [990-430 390 150 boxheight], 'HorizontalAlignment','left');
fields2edit.RwrsTotalNum = uieditfield(fig,'Value', fields.Measures.WRS.R.totalWordsPresented, 'Position',[1020-430 390 50 20]);

uilabel(fig,'Text','% correct', 'Position', [1080-430 390 150 boxheight], 'HorizontalAlignment','left');
RwrsPercentCorrect = uieditfield(fig,'Value', fields.Measures.WRS.R.percentCorrect, 'Position',[1130-430 390 50 20]);

uilabel(fig,'Text','Left Ear:', 'Position', [880-430 350 60 20], 'HorizontalAlignment','left','FontColor', 'blue');

uilabel(fig,'Text','List', 'Position', [930-430 350 60 20], 'HorizontalAlignment','left');
fields2edit.LwrsList = uieditfield(fig,'Value', fields.Measures.WRS.L.list, 'Position',[950-430 350 100 20]);

uilabel(fig,'Text','by diff', 'Position', [1060-430 350 150 boxheight], 'HorizontalAlignment','left');
fields2edit.LwrsListDiff = uicontrol(fig,'Style','checkbox', 'Position',[1090-430 350 25 boxheight]);

uilabel(fig,'Text','List #', 'Position', [1110-430 350 150 boxheight], 'HorizontalAlignment','left');
fields2edit.LwrsListNum = uieditfield(fig,'Value', fields.Measures.WRS.L.listNumber, 'Position',[1140-430 350 40 boxheight]);

uilabel(fig,'Text','Speech Level', 'Position', [880-430 330 150 boxheight], 'HorizontalAlignment','left');
fields2edit.LwrsSLevel = uieditfield(fig,'Value', fields.Measures.WRS.L.speechLevel, 'Position',[950-430 330 50 20]);

uilabel(fig,'Text','Masking Level', 'Position', [1005-430 330 150 boxheight], 'HorizontalAlignment','left');
fields2edit.LwrsMLevel = uieditfield(fig,'Value', fields.Measures.WRS.L.maskingLevel, 'Position',[1080-430 330 50 20]);

uilabel(fig,'Text','# correct', 'Position', [880-430 310 150 boxheight], 'HorizontalAlignment','left');
fields2edit.LwrsNumCorrect = uieditfield(fig,'Value', fields.Measures.WRS.L.numberWordCorrect, 'Position',[930-430 310 50 20]);

uilabel(fig,'Text','total #', 'Position', [990-430 310 150 boxheight], 'HorizontalAlignment','left');
fields2edit.LwrsTotalNum = uieditfield(fig,'Value', fields.Measures.WRS.L.totalWordsPresented, 'Position',[1020-430 310 50 20]);

uilabel(fig,'Text','% correct', 'Position', [1080-430 310 150 boxheight], 'HorizontalAlignment','left');
fields2edit.LwrsPercentCorrect = uieditfield(fig,'Value', fields.Measures.WRS.L.percentCorrect, 'Position',[1130-430 310 50 20]);


uilabel(fig,'Text','Equipment','Position',[880-430 280 60 20],'HorizontalAlignment','left');
fields2edit.WRSEquipment = uieditfield(fig, 'Value', fields.Measures.WRS.equipment.device,'Position',[940-430 280 120 20]);

uilabel(fig,'Text','Calib Date','Position',[880-430 260 60 20],'HorizontalAlignment','left');
fields2edit.WRSEquipmentCalibDate = uieditfield(fig, 'Value', fields.Measures.WRS.equipment.calibDate,'Position',[940-430 260 120 20]);

uilabel(fig,'Text','Serial #','Position',[880-430 240 60 20],'HorizontalAlignment','left');
fields2edit.WRSEquipmentSerialNumber = uieditfield(fig, 'Value', fields.Measures.WRS.equipment.serialNumber,'Position',[940-430 240 120 20]);

uilabel(fig,'Text','WRS Comment','Position',[1070-430 280 100 20],'HorizontalAlignment','left');
fields2edit.WRSComments = uieditfield(fig, 'Value', fields.Measures.WRS.comments{1,1},'Position',[1070-430 220 110 60]);


% ==== SUBMIT BUTTON ====
uibutton(fig,'text','Submit & Save','FontColor','k','BackgroundColor','g', 'FontSize', 14, 'FontWeight', 'bold','Position', [260 40 150 40],...
    'ButtonPushedFcn', @(src, event)submitCallback(fields, fields2edit));

% ==== CALLBACK FUNCTION ====
function submitCallback(fields, fields2edit)
% Update visit struct from GUI
disp('Saving Subject Info...')
visit2.Subject.ID = fields2edit.subjID.Value;
visit2.Subject.age = str2double(fields2edit.age.Value);
visit2.Subject.gender = fields2edit.gender.Value;
visit2.Subject.amplification = fields2edit.amplification.Value;

disp('Saving Visit Info...')
visit2.VisitInfo.testDate = datetime(fields2edit.testDate.Value, 'InputFormat', 'MMddyyyy');
visit2.VisitInfo.referringLab = fields2edit.referringLab.Value;
visit2.VisitInfo.irbNumber = fields2edit.irbNumber.Value; %type?
visit2.VisitInfo.ARDRsigned = fields2edit.ARDRsigned.Value; %type?
visit2.VisitInfo.researcher = fields2edit.researcher.Value;
visit2.VisitInfo.researcherOther = fields2edit.researcherOther.Value;
visit2.VisitInfo.studyProtocol = fields2edit.studyProtocol.Value;
visit2.VisitInfo.location = fields2edit.location.Value;
visit2.VisitInfo.room = fields2edit.room.Value;
visit2.VisitInfo.dateCompiled = fields2edit.dateCompiled.Value; %type

disp('Saving Measures...')

if fields2edit.aud_checkbox.Value == 0
    disp('No Audiometry to Save')
else
    disp('    Audiometry...')
    visit2.Measures.Audiometry.AC.R = cleanAudio(fields.Measures.Audiometry.AC.R);
    visit2.Measures.Audiometry.AC.L = cleanAudio(fields.Measures.Audiometry.AC.L);
    visit2.Measures.Audiometry.BC.R = cleanAudio(fields.Measures.Audiometry.BC.R);
    visit2.Measures.Audiometry.BC.L = cleanAudio(fields.Measures.Audiometry.BC.L);
    visit2.Measures.Audiometry.equipment.AC_transducer = fields2edit.AC_trans.Value;
    visit2.Measures.Audiometry.equipment.BC_transducer = fields2edit.BC_trans.Value;
    visit2.Measures.Audiometry.equipment.AC_HardwareLimits = fields.Measures.Audiometry.equipment.AC_HardwareLimits;
    visit2.Measures.Audiometry.equipment.BC_HardwareLimits = fields.Measures.Audiometry.equipment.BC_HardwareLimits;
    visit2.Measures.Audiometry.equipment.device = fields2edit.Auddevice.Value;
    visit2.Measures.Audiometry.equipment.calibDate = fields2edit.AudcalibDate.Value; %Type
    visit2.Measures.Audiometry.equipment.serialNumber = fields2edit.Audserialnum.Value; %Type
    visit2.Measures.Audiometry.comments = fields2edit.Audcomments.Value;
end

if fields2edit.quicksin_checkbox.Value == 0
    disp('No QuickSIN data')
else
    disp('    QuickSIN...')
    visit2.Measures.QuickSIN.R = fields2edit.RquickSIN.Value; %DNT Checkbox
    visit2.Measures.QuickSIN.L = fields2edit.LquickSIN.Value; %DNT Checkbox
    visit2.Measures.QuickSIN.Bin = fields2edit.BquickSIN.Value; %DNT Checkbox
    visit2.Measures.QuickSIN.equipment.device = fields2edit.QSequipdevice.Value;
    visit2.Measures.QuickSIN.equipment.calibDate = fields2edit.QSequipcalib.Value; %Type
    visit2.Measures.QuickSIN.equipment.serialNumber = fields2edit.QSequipSN.Value; %Type
    visit2.Measures.QuickSIN.comments = fields2edit.QScomments.Value;
end

if dp_checkbox.Value == 0
    disp('no DPOAE Data')
else
    disp('    DPOAEs...')
    visit2.Measures.DPOAE.R.noisefloor = fields.Measures.DPOAE.R.noisefloor;
    visit2.Measures.DPOAE.R.mean_response = fields.Measures.DPOAE.R.mean_response;
    visit2.Measures.DPOAE.R.f1 = fields.Measures.DPOAE.R.f1;
    visit2.Measures.DPOAE.R.f2 = fields.Measures.DPOAE.R.f2;
    visit2.Measures.DPOAE.R.DP = fields.Measures.DPOAE.R.DP;
    visit2.Measures.DPOAE.R.f1_rec_dB = fields.Measures.DPOAE.R.f1_rec_dB;
    visit2.Measures.DPOAE.R.f2_rec_dB = fields.Measures.DPOAE.R.f2_rec_dB;
    visit2.Measures.DPOAE.R.fs = fields.Measures.DPOAE.R.fs;
    visit2.Measures.DPOAE.L.noisefloor = fields.Measures.DPOAE.L.noisefloor;
    visit2.Measures.DPOAE.L.mean_response = fields.Measures.DPOAE.L.mean_response;
    visit2.Measures.DPOAE.L.f1 = fields.Measures.DPOAE.L.f1;
    visit2.Measures.DPOAE.L.f2 = fields.Measures.DPOAE.L.f2;
    visit2.Measures.DPOAE.L.DP = fields.Measures.DPOAE.L.DP;
    visit2.Measures.DPOAE.L.f1_rec_dB = fields.Measures.DPOAE.L.f1_rec_dB;
    visit2.Measures.DPOAE.L.f2_rec_dB = fields.Measures.DPOAE.L.f2_rec_dB;
    visit2.Measures.DPOAE.L.fs = fields.Measures.DPOAE.L.fs;
    visit2.Measures.DPOAE.other.researcher  = fields2edit.DPOAEresearcher.Value;
    visit2.Measures.DPOAE.equipment.device = fields2edit.DPOAEdevice.Value;
    visit2.Measures.DPOAE.equipment.calibDate = fields2edit.DPOAEcalibDate.Value; %Type
    visit2.Measures.DPOAE.equipment.serialNumber = fields2edit.DPOAEserialnum.Value; %Type
    visit2.Measures.DPOAE.comments = fields2edit.DPOAEcomments.Value;
end

if fields2edit.memr_checkbox.Value == 0
    disp('No MEMR data')
else
    disp('    MEMR...')
    visit2.Measures.Reflexes.Frequencies = [500 1e3 2e3 4e3];
    visit2.Measures.Reflexes.ProbeR.Ipsi = fields.Measures.Reflexes.ProbeR.Ipsi;
    visit2.Measures.Reflexes.ProbeR.Contra = fields.Measures.Reflexes.ProbeR.Contra;
    visit2.Measures.Reflexes.ProbeL.Ipsi = fields.Measures.Reflexes.ProbeL.Ipsi;
    visit2.Measures.Reflexes.ProbeL.Contra = fields.Measures.Reflexes.ProbeL.Contra;
    visit2.Measures.Reflexes.equipment.device = fields2edit.MEMRequipment.Value;
    visit2.Measures.Reflexes.equipment.calibDate = fields2edit.MEMRcalibDate.Value; %Type
    visit2.Measures.Reflexes.equipment.serialNumber = fields2edit.MEMRserialNum.Value; %Type
    visit2.Measures.Reflexes.comments = MEMRcomments.Value;
end

if fields2edit.wrs_checkbox.Value == 0
    disp('No WRS data')
else
    disp('    WRS...') %add by difficulty checkbox
    visit2.Measures.WRS.R.speechLevel = field2edit.RwrsSLevel.Value; %Type;
    visit2.Measures.WRS.R.maskingLevel = field2edit.RwrsMlevel.Value; %Type
    visit2.Measures.WRS.R.numberWordCorrect = field2edit.RwrsNumCorrect.Value; %Type
    visit2.Measures.WRS.R.totalWordsPresented = field2edit.RwrsTotalNum.Value; %Type
    visit2.Measures.WRS.R.list = field2edit.RwrsList.Value;
    visit2.Measures.WRS.R.listNumber = field2edit.RwrsListNum.Value; %Type
    visit2.Measures.WRS.R.percentCorrect = field2edit.RwrsPercentCorrect.Value; %Type
    visit2.Measures.WRS.L.speechLevel = field2edit.LwrsSLevel.Value; %Type
    visit2.Measures.WRS.L.maskingLevel = field2edit.LwrsMLevel.Value; %Type;
    visit2.Measures.WRS.L.numberWordCorrect = field2edit.LwrsNumCorrect.Value; %Type;
    visit2.Measures.WRS.L.totalWordsPresented = field2edit.LwrsTotalNum.Value; %Type;
    visit2.Measures.WRS.L.list = field2edit.LwrsList.Value;
    visit2.Measures.WRS.L.listNumber = field2edit.LwrsListNum.Value; %Type
    visit2.Measures.WRS.L.percentCorrect = field2edit.LwrsPercentCorrect.Value; %Type
    visit2.Measures.WRS.equipment.device = field2edit.WRSEquipment.Value;
    visit2.Measures.WRS.equipment.calibDate = field2edit.WRSEquipmentCalibDate.Value; %Type
    visit2.Measures.WRS.equipment.serialNumber = field2edit.WRSEquipmentSerialNumber.Value; %Type
    visit2.Measures.WRS.comments = field2edit.WRSComments.Value;
end

if fields2edit.act_checkbox.Value == 0
    disp('    No ACT...')
else
    visit2.Measures.ACT.scores = ""; %% need to add this
    visit2.Measures.ACT.comments = ""; %% need to add this (old and new)
    visit2.Measures.ACT.equipment.device = field2edit.ACTEquipment.Value;
    visit2.Measures.ACT.equipment.calibDate = field2edit.ACTCalib.Value; %Type
    visit2.Measures.ACT.equipment.serialNumber = field2edit.ACTSerialNum.Value; %Type
end

if fields2edit.wbt_checkbox.Value == 0
    disp('No WBT data')
else
    disp('    WBT...') %Some of these are not editable
    visit2.Measures.WBT.L.PRESSURE = fields.Measures.WBT.L.PRESSURE;
    visit2.Measures.WBT.L.FREQ = fields.Measures.WBT.L.FREQ;
    visit2.Measures.WBT.L.ABSORBANCE = fields.Measures.WBT.L.ABSORBANCE;
    visit2.Measures.WBT.R.PRESSURE = fields.Measures.WBT.R.PRESSURE;
    visit2.Measures.WBT.R.FREQ = fields.Measures.WBT.R.FREQ;
    visit2.Measures.WBT.R.ABSORBANCE = fields.Measures.WBT.R.ABSORBANCE;
    visit2.Measures.WBT.comments = field2edit.WBTComments.Value;
    visit2.Measures.WBT.equipment.device = field2edit.WBTEquipment.Value;
    visit2.Measures.WBT.equipment.calibDate = field2edit.WBTEquipmentCalibDate.Value; %Type
    visit2.Measures.WBT.equipment.serialNumber = field2edit.WBTEquipmentSerialNumber.Value; %Type
end

if fields2edit.otoscopy_checkbox == 0
    disp("No otoscopy info")
else
    visit2.Measures.Otoscopy.comments = field2edit.otoComments.Value;
    visit2.Measures.Otoscopy.equipment = field2edit.otoEquipment.Value;
end
visit3 = visit2;

dirToSave = path;
fileToSave = [extractBefore(file, '.mat'), '_new.mat']

% Save updated struct back to file
save(fullfile(dirToSave, fileToSave), 'visit3');
msgbox('visit data saved successfully!', 'Success');
end
%end
