function simpleVisitEditor()

%%%%% STUFF TO EDIT FOR A USER %%%%%
dataDir = "C:\Users\annik\OneDrive\Desktop\Code\ARDC_Analysis\"; 
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
    
    % Data for each measure
    if isfield(visit, 'Measures')
        meas = fieldnames(visit.Measures);
        for f = 1:length(meas)
            if contains(meas{f}, 'audio', 'IgnoreCase', 1)
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
            end
        end
    end
    

    % Create figure window
    boxheight = 20; 
    figheight = 600; 
    fig = figure('Name', 'Visit Editor', 'Position', [100 100 1200 figheight]);
   

    % ==== SUBJECT INFO ====
    uicontrol(fig,'Style','text','String','Subject ID','Position',[20 570 60 boxheight],'HorizontalAlignment','left');
    subjID = uicontrol(fig,'Style','edit','String',visit.Subject.ID,'Position',[80 570 100 boxheight]);

    uicontrol(fig,'Style','text','String','Age','Position',[20 550 60 20],'HorizontalAlignment','left');
    age = uicontrol(fig,'Style','edit','String',num2str(visit.Subject.age),'Position',[80 550 100 20]);

    uicontrol(fig,'Style','text','String','Gender','Position',[20 530 60 20],'HorizontalAlignment','left');
    gender = uicontrol(fig,'Style','edit','String',visit.Subject.gender,'Position',[80 530 100 20]);

    uicontrol(fig,'Style','text','String','Amplification','Position',[20 510 60 20],'HorizontalAlignment','left');
    amplification = uicontrol(fig,'Style','edit','String',visit.Subject.amplification,'Position',[80 510 100 20]);

    % ==== VISIT INFO ====
    uicontrol(fig,'Style','text','String','Test Date','Position',[20 480 60 20],'HorizontalAlignment','left');
    testDate = uicontrol(fig, 'Style', 'edit','String', string(visit.VisitInfo.testDate),'Position',[80 480 100 20]);

    uicontrol(fig,'Style','text','String','Refer Lab','Position',[20 460 60 20],'HorizontalAlignment','left');
    referringLab = uicontrol(fig,'Style','edit','String',visit.VisitInfo.referringLab,'Position',[80 460 100 20]);

    uicontrol(fig,'Style','text','String','IRB Number','Position',[20 440 60 20],'HorizontalAlignment','left');
    irbNumber = uicontrol(fig,'Style','edit','String',visit.VisitInfo.irbNumber,'Position',[80 440 100 20]);

    %%

    uicontrol(fig,'Style', 'text', 'String', 'QuickSIN', 'Position', [880 570 60 20], 'HorizontalAlignment','left', 'FontSize', 10);

    uicontrol(fig,'Style', 'text', 'String','RE QuickSIN', 'Position', [880 550 150 boxheight], 'HorizontalAlignment','left');
    RquickSIN = uicontrol(fig,'Style','edit', 'String', Measures.QuickSIN.R, 'Position',[950 550 30 boxheight]); 

    uicontrol(fig,'Style', 'text', 'String','DNT', 'Position', [985 550 150 boxheight], 'HorizontalAlignment','left');
    RquickSINDNT = uicontrol(fig,'Style','checkbox', 'Position',[1010 550 25 boxheight]);

    uicontrol(fig,'Style', 'text', 'String','Equip', 'Position', [1030 550 150 boxheight], 'HorizontalAlignment','left');
    QSequipdevice = uicontrol(fig,'Style','edit', 'String', Measures.QuickSIN.equipment.device, 'Position',[1060 550 110 boxheight]);

    uicontrol(fig, 'Style', 'text', 'String','LE QuickSIN', 'Position', [880 510 150 boxheight], 'HorizontalAlignment','left');
    LquickSIN = uicontrol(fig,'Style','edit', 'String', Measures.QuickSIN.L, 'Position',[950 510 30 boxheight]); 

     uicontrol(fig,'Style', 'text', 'String','DNT', 'Position', [985 510 150 boxheight], 'HorizontalAlignment','left');
    LquickSINDNT = uicontrol(fig,'Style','checkbox', 'Position',[1010 510 25 boxheight]);

    uicontrol(fig,'Style', 'text', 'String','Calib', 'Position', [1030 510 150 boxheight], 'HorizontalAlignment','left');
    QSequipcalib = uicontrol(fig,'Style','edit', 'String', Measures.QuickSIN.equipment.calibDate, 'Position',[1060 510 110 boxheight]);

    uicontrol(fig, 'Style', 'text', 'String','Bin QuickSIN', 'Position', [880 470 150 boxheight], 'HorizontalAlignment','left');
    BquickSIN = uicontrol(fig,'Style','edit', 'String', Measures.QuickSIN.Bin, 'Position',[950 470 30 boxheight]);
    
    uicontrol(fig,'Style', 'text', 'String','DNT', 'Position', [985 470 150 boxheight], 'HorizontalAlignment','left');
    BquickSINDNT = uicontrol(fig,'Style','checkbox', 'Position',[1010 470 25 boxheight]);
    
    uicontrol(fig,'Style', 'text', 'String','SN', 'Position', [1030 470 150 boxheight], 'HorizontalAlignment','left');
    QSequipSN = uicontrol(fig,'Style','edit', 'String', Measures.QuickSIN.equipment.serialNumber, 'Position',[1060 470 110 boxheight]);

    uicontrol(fig,'Style', 'text', 'String','Comments', 'Position', [880 440 150 boxheight], 'HorizontalAlignment','left');
    QScomments = uicontrol(fig,'Style','edit', 'String', Measures.QuickSIN.comments, 'Position',[950 420 220 40]);

%% WRS %%
%  Measures.WRS.R.speechLevel = ""; 
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
    % 
uicontrol(fig,'Style', 'text', 'String', 'WRS', 'Position', [880 400 60 20], 'HorizontalAlignment','left', 'FontSize', 10);

uicontrol(fig,'Style', 'text', 'String','RE QuickSIN', 'Position', [880 550 150 boxheight], 'HorizontalAlignment','left');
rWRS = uicontrol(fig,'Style','edit', 'String', Measures.QuickSIN.R, 'Position',[950 550 30 boxheight]); 


%%%%
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
