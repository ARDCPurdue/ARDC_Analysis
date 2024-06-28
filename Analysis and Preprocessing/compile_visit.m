function compile_visit(dataDir, outputDir)
%Description: Compiles all the data from a specified ARDC visit directory
%   into a .mat file that can easily be accessed. Default directory outputDir
%   is the 'Visits_Compiled' directory, unless otherwise specified. It is
%   assumed the Qualtrics data form with QuickSIN/Reflexes/etc is in the
%   same directory as the Visit folders.
%
%
%  compile_visit(visitList, dataDir, outputDir)
%
%  visitList may be specified as an array of visits or a single visit, but the entries must be
%  string not char. i.e. ["V1","V2"] not ['V1','V2']
%Author: Andrew Sivaprakasam
%Email: asivapr@purdue.edu

%TODO:
% - Otoscopy data, but need from endVisit
% - 

%File Text Pattern:
if nargin == 0
    %dataDir = 'D:\ARDC\ARDC_AllData\1_Raw_Data'
    dataDir = 'C:\Users\ARDC User\Desktop\ALLRAWDATA'
end

if nargin == 1 || nargin == 0
    %outputDir = 'D:\ARDC\ARDC_AllData\2_Visits_Compiled';
    outputDir = 'C:\Users\ARDC User\Desktop\Compiled'
end

addpath(pwd);
addpath(genpath(dataDir));

%get all unique Visit IDs
All_IDs = getUniqueVisitID(dataDir);

for n = 1:length(All_IDs)
    
    visitID = All_IDs{n};
    scors = strfind(visitID,'_');
    subjectID = visitID(1:scors(1)-1)
    
    pd = pwd;
    
    %Find ARCDC Prefix, these are the files for a given visit:
    fnames = dir(strcat([dataDir,'/',visitID,'*']));
    files = {fnames.name}';
    folders = {fnames.folder}';
    
    %Also declares the Visit struct
    visit.subjectID = subjectID;
    
    %At this time,
    visit.researcher = 'Unknown';
    visit.time = 'Unknown';
    
    % reflex flag
    reflex_found = 0;
    
    for i = 1:length(files)
        if ~isempty(files{i})
            
            underscore = strfind(files{i},'_');
            dataType = files{i}(underscore(2)+1:underscore(2)+3);
            
            switch dataType
                
                case 'COM'
                    visit.SubjInfo = subj;
                    visit.VisitInfo = study;
                    
                
                case 'AUD'
                    [AC_R, BC_R, AC_L, BC_L, QS_R, QS_L, Age, AC_transduc, BC_transduc, AC_maxOut, BC_maxOut] = parseAudiogram(files{i}, folders{i});
                    Audiogram.AC.R = AC_R;
                    Audiogram.AC.L = AC_L;
                    Audiogram.BC.R = BC_R;
                    Audiogram.BC.L = BC_L;
                    Audiogram.AC_transducer = AC_transduc;
                    Audiogram.AC_HardwareLimits = AC_maxOut;
                    Audiogram.BC_transducer = BC_transduc;
                    Audiogram.BC_HardwareLimits = BC_maxOut;
                    QuickSIN.R = QS_R;
                    QuickSIN.L = QS_L;
                    
                    visit.Measures.Audio = Audiogram;
                    visit.Measures.QuickSin = QuickSIN;
                    
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
                            dpOAE.L.noisefloor = noisefloor_dp;
                            dpOAE.L.mean_response = mean_response;
                            dpOAE.L.f1 = f1;
                            visit.dpOAE.L.f2 = f2;
                            dpOAE.L.DP = DP;
                            dpOAE.L.f1_rec_dB = f1_rec_dB;
                            dpOAE.L.f2_rec_dB = f2_rec_dB;
                            dpOAE.L.fs = 44100; %WARNING! Assumes this is unchanged from my Titan dpOAE code.
                            dpOAE.other.researcher = researcher;
                            disp('Left OAE Loaded');
                            
                        case 'R'
                            dpOAE.R.noisefloor = noisefloor_dp;
                            dpOAE.R.mean_response = mean_response;
                            dpOAE.R.f1 = f1;
                            dpOAE.R.f2 = f2;
                            dpOAE.R.DP = DP;
                            dpOAE.R.f1_rec_dB = f1_rec_dB;
                            dpOAE.R.f2_rec_dB = f2_rec_dB;
                            dpOAE.R.fs = 44100; %WARNING! Assumes this is unchanged from my Titan dpOAE code.
                            dpOAE.other.researcher = researcher;
                            disp('Right OAE Loaded');
                            
                            visit.Measures.dpOAE = dpOAE;
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
        
        
        %Visits are listed in opposite descending order
        
        visit.time = datetime;
        
        if ~exist(visit.researcher)
            visit.researcher = researcher;
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
    
    cd(outputDir);
    
    save([visitID,'.mat'], 'visit');
    
    cd(pd);
    
end

