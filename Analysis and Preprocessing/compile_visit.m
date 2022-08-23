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
% - Allow visitID to be array of strings
% - Re-format file names

%File Text Pattern:
if nargin == 0
    dataDir = 'D:\ARDC\Pilot Study Example\1_Raw_Data'
end 

if nargin == 1 || nargin == 0
    outputDir = 'D:\ARDC\Pilot Study Example\2_Visits_Compiled';
end

addpath(pwd);
addpath(genpath(dataDir));

%get all unique Visit IDs
All_IDs = getUniqueVisitID(dataDir);

for n = 1:length(All_IDs)

    visitID = All_IDs{n};
    %AGH just fix this to pull from All_IDs...
    scors = strfind(visitID,'_');
    subjectID = visitID(1:scors(1)-1)
    
    pd = pwd;
%     subj_dir = [dataDir, '/', visitID];
%     cd(subj_dir);

    %Find ARCDC Prefix, these are the files for a given visit:
    fnames = dir(strcat([dataDir,'*/*/',All_IDs{n},'*']));
    files = {fnames.name}';
    folders = {fnames.folder}';

    %Also declares the Visit struct
    visit.subjectID = subjectID;

    %At this time, 
    visit.researcher = 'Unknown';
    visit.time = 'Unknown';
    
    for i = 1:length(files) 
        if ~isempty(files{i})

            underscore = strfind(files{i},'_');
            dataType = files{i}(underscore(2)+1:underscore(2)+3);

            switch dataType

                case 'AUD'
                    [AC_R, BC_R, AC_L, BC_L] = parseAudiogram(files{i}, folders{i});
                    visit.Audiogram.AC.R = AC_R;
                    visit.Audiogram.AC.L = AC_L;
                    visit.Audiogram.BC.R = BC_R;
                    visit.Audiogram.BC.L = BC_L;

                    disp('Audiometry Loaded');
                case 'WBT'
                    %CHECK LR
                    run(files{i});
                    vars = who('-regexp', 'WBT*');
                    structname = vars{1};

                    switch files{i}(underscore(3)+1:end-2)

                        case 'L'
                            eval(['visit.WBT.L.PRESSURE = ',structname,'.PRESSURE;']);
                            eval(['visit.WBT.L.FREQ = ',structname,'.FREQ;']);
                            eval(['visit.WBT.L.ABSORBANCE = ', structname,'.ABSORBANCE;']);
                            clear(vars{:})
                            disp('Left WBT Loaded');


                        case 'R'
                            eval(['visit.WBT.R.PRESSURE = ',structname,'.PRESSURE;']);
                            eval(['visit.WBT.R.FREQ = ',structname,'.FREQ;']);
                            eval(['visit.WBT.R.ABSORBANCE = ', structname,'.ABSORBANCE;']);
                            clear(vars{:})
                            disp('Right WBT Loaded');
                    end

                case 'OAE'
                    %CHECK LR
                    load(files{i});
    %                 eval([visitID,'.researcher = researcher']);
    %                 eval([visitID,'.time = time']);

                    switch files{i}(underscore(3)+1:end-4)
                        case 'L'
                            visit.dpOAE.L.noisefloor = noisefloor_dp;
                            visit.dpOAE.L.mean_repsonse = mean_response;
                            visit.dpOAE.L.f1 = f1;
                            visit.dpOAE.L.f2 = f2;
                            visit.dpOAE.L.DP = DP;
                            visit.dpOAE.L.f1_rec_dB = f1_rec_dB;
                            visit.dpOAE.L.f2_rec_dB = f2_rec_dB;
                            disp('Left OAE Loaded');

                        case 'R'
                            visit.dpOAE.R.noisefloor = noisefloor_dp;
                            visit.dpOAE.R.mean_repsonse = mean_response;
                            visit.dpOAE.R.f1 = f1;
                            visit.dpOAE.R.f2 = f2;
                            visit.dpOAE.R.DP = DP;
                            visit.dpOAE.R.f1_rec_dB = f1_rec_dB;
                            visit.dpOAE.R.f2_rec_dB = f2_rec_dB;
                            disp('Right OAE Loaded');
                    end
            end
        end
    end

    %Date/Time/Researcher/Reflexes/QuickSIN Performance
    %Assumes that Qualtrics Survey Results are saved in directory directly
    %above.

    cd([dataDir,'/Reflexes'])
    %datetime and string inputs for Date and Researcher
    dataCSV = 'Reflex_Entry.csv';
   
    [researcher,datetime,R_QuickSIN,L_QuickSIN,Probe_R_Ipsi,Probe_R_Contr,Probe_L_Ipsi,Probe_L_Contr]...
        = parseReflexQualtrics(dataCSV, visitID);
    
    %Visits are listed in opposite descending order

    visit.time = datetime;
    visit.researcher = researcher;

    Reflex_Frequencies = [500, 1e3, 2e3, 4e3];

    visit.QuickSIN.R = R_QuickSIN;
    visit.QuickSIN.L = L_QuickSIN;

    visit.Reflexes.Frequencies = Reflex_Frequencies;
    visit.Reflexes.ProbeR.Ipsi = Probe_R_Ipsi;
    visit.Reflexes.ProbeR.Contra = Probe_R_Contr;
    visit.Reflexes.ProbeL.Ipsi = Probe_L_Ipsi;
    visit.Reflexes.ProbeL.Contra = Probe_L_Contr;

%     %Saving (This may need to be edited depending on file structure)
    cd(dataDir);
    cd(outputDir);

    save([visitID,'.mat'], 'visit');

    cd(pd);

end

