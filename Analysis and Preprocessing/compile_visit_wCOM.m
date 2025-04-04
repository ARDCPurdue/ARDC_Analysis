function visit = compile_visit_wCOM(data, study, subj)
%Description: Compiles all the data from a specified ARDC visit directory
%   into a .mat file that can easily be accessed. Default directory outputDir
%   is the 'Visits_Compiled' directory, unless otherwise specified. It is
%   assumed the Qualtrics data form with QuickSIN/Reflexes/etc is in the
%   same directory as the Visit folders.
%
%  compile_visit(visitList, dataDir, outputDir)
%
%  visitList may be specified as an array of visits or a single visit, but the entries must be
%  string not char. i.e. ["V1","V2"] not ['V1','V2']
% Author: Andrew Sivaprakasam
% Email: asivapr@purdue.edu
% Updated: Samantha Hauser, hauser23@purdue.edu, 7/24/24 (adding
% functionality to EndVisit process)

dataDir = 'C:\Users\ARDC User\Desktop\ALLRAWDATA';
outputDir = 'C:\Users\ARDC User\Desktop\';

ARDClabDir = ['ARDCLab Data\'];
ARDRDir = ['ARDR Data\'];
extDir = ['External Labs TEMP\'];

addpath(pwd);
addpath(dataDir);

visitID = subj.ID;

pd = pwd;

%Find ARCDC Prefix, these are the files for a given visit:
fnames = dir(strcat([dataDir,'/',visitID,'*']));
files = {fnames.name}';
folders = {fnames.folder}';

% Sets the subject and study details, also declares the Visit struct
visit.Subject = subj;
visit.VisitInfo = study;

% reflex flag
reflex_found = 0;

for i = 1:length(files)
    if ~isempty(files{i})

        underscore = strfind(files{i},'_');
        dataType = files{i}(underscore(2)+1:underscore(2)+3);

        switch dataType

            case 'AUD'
                [AC_R, BC_R, AC_L, BC_L, QS_R, QS_L, Age, AC_transduc, BC_transduc, AC_maxOut, BC_maxOut] = parseAudiogram(files{i}, folders{i});
                Audiometry.AC.R = AC_R;
                Audiometry.AC.L = AC_L;
                Audiometry.BC.R = BC_R;
                Audiometry.BC.L = BC_L;
                Audiometry.equipment.AC_transducer = AC_transduc;
                Audiometry.equipment.AC_HardwareLimits = AC_maxOut;
                Audiometry.equipment.BC_transducer = BC_transduc;
                Audiometry.equipment.BC_HardwareLimits = BC_maxOut;
                QuickSIN.R = QS_R;
                QuickSIN.L = QS_L;

                visit.Measures.Audiometry = Audiometry;
                visit.Measures.QuickSIN = QuickSIN;

                disp('Audiometry Loaded');

            case 'WBT'

                %TODO: Pull all the data from WBT!!!!! Andrew didn't
                %copy everything :(

                %Verify this is working after changing to Measure

                %CHECK LR
                run(files{i});
                vars = who('-regexp', 'WBT*');
                structname = vars{1};

                switch files{i}(underscore(3)+1:end-2)

                    case 'L'
                        eval(['L.PRESSURE = ',structname,'.PRESSURE;']);
                        eval(['L.FREQ = ',structname,'.FREQ;']);
                        eval(['L.ABSORBANCE = ', structname,'.ABSORBANCE;']);
                        clear(vars{:})
                        disp('Left WBT Loaded');

                        visit.Measures.WBT.L = L;

                    case 'R'
                        eval(['R.PRESSURE = ',structname,'.PRESSURE;']);
                        eval(['R.FREQ = ',structname,'.FREQ;']);
                        eval(['R.ABSORBANCE = ', structname,'.ABSORBANCE;']);
                        clear(vars{:})
                        disp('Right WBT Loaded');

                        visit.Measures.WBT.R = R;
                end


            case 'OAE'
                %CHECK LR
                load(files{i});
                switch files{i}(underscore(3)+1:end-4)
                    case 'L'
                        DPOAE.L.noisefloor = noisefloor_dp;
                        DPOAE.L.mean_response = mean_response;
                        DPOAE.L.f1 = f1;
                        DPOAE.L.f2 = f2;
                        DPOAE.L.DP = DP;
                        DPOAE.L.f1_rec_dB = f1_rec_dB;
                        DPOAE.L.f2_rec_dB = f2_rec_dB;
                        DPOAE.L.fs = 44100; %WARNING! Assumes this is unchanged from my Titan dpOAE code.
                        DPOAE.other.researcher = researcher;
                        disp('Left OAE Loaded');

                    case 'R'
                        DPOAE.R.noisefloor = noisefloor_dp;
                        DPOAE.R.mean_response = mean_response;
                        DPOAE.R.f1 = f1;
                        DPOAE.R.f2 = f2;
                        DPOAE.R.DP = DP;
                        DPOAE.R.f1_rec_dB = f1_rec_dB;
                        DPOAE.R.f2_rec_dB = f2_rec_dB;
                        DPOAE.R.fs = 44100; %WARNING! Assumes this is unchanged from my Titan dpOAE code.
                        DPOAE.other.researcher = researcher;
                        disp('Right OAE Loaded');

                        visit.Measures.DPOAE = DPOAE;
                end

            case 'RFX'
                load(files{i});

                Reflex_Frequencies = [500, 1e3, 2e3, 4e3];
                Reflexes.Frequencies = Reflex_Frequencies;
                Reflexes.ProbeR.Ipsi = Probe_R_Ipsi;
                Reflexes.ProbeR.Contra = Probe_R_Contra;
                Reflexes.ProbeL.Ipsi = Probe_L_Ipsi;
                Reflexes.ProbeL.Contra = Probe_L_Contra;
                disp('Reflexes Loaded');

                visit.Measures.Reflexes = Reflexes;

                reflex_found = 1;

                % Also get WRS info from this gui
                if reflex_data.wrs.R.didNotTest == 0
                    WRS.R.speechLevel = reflex_data.wrs.R.speechLevel;
                    WRS.R.maskingLevel = reflex_data.wrs.R.maskingLevel;
                    WRS.R.numberWordsCorrect = reflex_data.wrs.R.correct;
                    WRS.R.totalWordsPresented = reflex_data.wrs.R.totalWords;
                    WRS.R.list = reflex_data.wrs.R.list;
                    WRS.R.listNumber = reflex_data.wrs.R.listNumber;
                    WRS.R.percentCorrect = 100.*(reflex_data.wrs.R.correct ./ reflex_data.wrs.R.totalWords );
                end

                if reflex_data.wrs.L.didNotTest == 0
                    WRS.L.speechLevel = reflex_data.wrs.L.speechLevel;
                    WRS.L.maskingLevel = reflex_data.wrs.L.RmaskingLevel;
                    WRS.L.numberWordsCorrect = reflex_data.wrs.L.correct;
                    WRS.L.totalWordsPresented = reflex_data.wrs.L.totalWords;
                    WRS.L.list = reflex_data.wrs.L.list;
                    WRS.L.listNumber = reflex_data.wrs.L.listNumber;
                    WRS.L.percentCorrect = 100.*(reflex_data.wrs.L.correct ./ reflex_data.wrs.L.totalWords );
                end

                % for ACT data
                if reflex_data.act.didNotTest == 0
                    if reflex_data.act.couldNotTest == 0
                        ACT.scores = reflex_data.act;
                    else
                        ACT.scores = 'Could not test';
                    end
                else
                    ACT.scores = 'Did not test';
                end



        end
    end
end

%Date/Time/Researcher/Reflexes/QuickSIN Performance
%Assumes that Qualtrics Survey Results are saved in directory directly
%above.

cd([dataDir])
if reflex_found == 0

    %datetime and string inputs for Date and Researcher
    dataCSV = 'ARDC Reflexes.csv';

    try
        [researcher,datetime,Probe_R_Ipsi,Probe_R_Contr,Probe_L_Ipsi,Probe_L_Contr]...
            = parseReflexQualtrics(dataCSV, visitID);

    catch
        disp('No Reflex Match Found');
        researcher = NaN;
        datetime = NaN;
        Probe_R_Ipsi = NaN;
        Probe_R_Contr = NaN;
        Probe_L_Ipsi = NaN;
        Probe_L_Contr = NaN;

    end

    Reflex_Frequencies = [500, 1e3, 2e3, 4e3];
    Reflexes.Frequencies = Reflex_Frequencies;
    Reflexes.ProbeR.Ipsi = Probe_R_Ipsi;
    Reflexes.ProbeR.Contra = Probe_R_Contr;
    Reflexes.ProbeL.Ipsi = Probe_L_Ipsi;
    Reflexes.ProbeL.Contra = Probe_L_Contr;

    visit.Measures.Reflexes = Reflexes;

end
%     %Saving (This may need to be edited depending on file structure)



% now add in data/comments
measures = fieldnames(data.Measure);
for i = 1:length(measures)
    measure = measures{i};
    visit.Measures.(measure).comments = data.Measure.(measure).comments;
    visit.Measures.(measure).equipment.device = data.Measure.(measure).equipment.device;
    visit.Measures.(measure).equipment.calibDate = data.Measure.(measure).equipment.calibDate;
    visit.Measures.(measure).equipment.serialNumber = data.Measure.(measure).equipment.serialNumber;
end

% if data should go to certain folders, set where it goes here:
cd(outputDir);
filename = strcat(subj.ID,'_',string(study.testDate));

if strcmp(visit.VisitInfo.referringLab, 'ARDC Lab')
    cd(ARDClabDir);
else
    cd(extDir)
    refPI = visit.VisitInfo.referringLab;
    if ~exist(refPI, 'dir')
        mkdir(refPI)
    end
    cd(visit.VisitInfo.referringLab)
end

save(filename, 'visit');
cd(outputDir)

% if ARDR is signed and data can go to repo, also save it to that folder.
if visit.VisitInfo.ARDRsigned
    cd(ARDRDir)
    save(filename, 'visit');
end

cd(pd)
rmpath(pwd);
rmpath(dataDir);

end


