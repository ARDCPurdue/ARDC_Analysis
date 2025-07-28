
% Initialize directories
allDataDir = 'C:\Users\ARDC User\Desktop\fromBox\Compiled'; 
currentDir = pwd; 

% Go into the data directory
cd(allDataDir);

% Initialize table to store
M = [{"Subject"}, {"date"}, {"QuickSIN_R"}, {"QuickSIN_L"}, {'ACT'},...
    {"AC_R_250"},{"AC_R_500"}, {"AC_R_1000"},{"AC_R_2000"},	{"AC_R_3000"},	...
    {"AC_R_4000"},	{"AC_R_6000"},	{"AC_R_8000"},	{"AC_R_10000"}, {"AC_R_11200"}, ...
    {"AC_R_12500"},	{"AC_R_14000"},	{"AC_R_16000"},	{"AC_L_250"},	{"AC_L_500"}, ...
    {"AC_L_1000"},	{"AC_L_2000"},	{"AC_L_3000"},	{"AC_L_4000"},	{"AC_L_6000"},	{"AC_L_8000"},	...
    {"AC_L_10000"},	{"AC_L_11200"},	{"AC_L_12500"},	{"AC_L_14000"},	{"AC_L_16000"},...
    {"BC_R_250"},	{"BC_R_500"},	{"BC_R_1000"},	{"BC_R_2000"},	{"BC_R_3000"},	{"BC_R_4000"},	...
    {"BC_L_250"},	{"BC_L_500"},	{"BC_L_1000"},	{"BC_L_2000"},	{"BC_L_3000"},	{"BC_L_4000"},	...
    {"reflex_R_ipsi_500"},	{"reflex_R_ipsi_1000"},	{"reflex_R_ipsi_2000"},	{"reflex_R_ipsi_4000"},	...
    {"reflex_R_contra_500"},	{"reflex_R_contra_1000"},	{"reflex_R_contra_2000"},	{"reflex_R_contra_4000"}, ...
    {"reflex_L_ipsi_500"},	{"reflex_L_ipsi_1000"},	{"reflex_L_ipsi_2000"},	{"reflex_L_ipsi_4000"},	...
    {"reflex_L_contra_500"},	{"reflex_L_contra_1000"},	{"reflex_L_contra_2000"},	{"reflex_L_contra_4000"},	...
    {"dp_R_1000"},	{"dp_R_2344"},	{"dp_R_3750"},	{"dp_R_4781"},	{"dp_R_6000"},	{"dp_R_8000"},	...
    {"nf_R_1000"},	{"nf_R_2344"},	{"nf_R_3750"},	{"nf_R_4781"},	{"nf_R_6000"},	{"nf_R_8000"},	...
    {"dp_L_1000"},	{"dp_L_2344"},	{"dp_L_3750"},	{"dp_L_4781"},	{"dp_L_6000"},	{"dp_L_8000"},	...
    {"nf_L_1000"},	{"nf_L_2344"},	{"nf_L_3750"},	{"nf_L_4781"},	{"nf_L_6000"},	{"nf_L_8000"}
]; 

% Get list of all ARDC in-person data files
fnames = {dir(fullfile(cd,'ARDC*.mat')).name};

for i = 1:length(fnames) % cycle through list of files and upload data from each
    
    % load in each data file
    load(fnames{i});
    
    %% Get subject ID
    try
        subjID = visit.subjectID;
    catch
        subjID = visit.Subject.ID; 
    end
    fprintf("Running %s now\n", subjID)
        
    testDate = extractBetween(fnames{i}, '_', '.mat');
    testDate = cell2mat(testDate);
    date = datetime(str2double(testDate(5:8)), str2double(testDate(3:4)), str2double(testDate(1:2)));
    date = cellstr(date); 
    
    %% Load Data
    if isfield(visit, "Measures")
        if isfield(visit.Measures, "Audio")
            audio = visit.Measures.Audio;
        elseif isfield(visit.Measures, "Audiometry")
            audio = visit.Measures.Audiometry;
        else
            audio = nan;
        end
        if isfield(visit.Measures, "QuickSIN")
            quicksin = visit.Measures.QuickSIN;
        elseif isfield(visit.Measures, "QuickSin")
            quicksin = visit.Measures.QuickSin; 
        else
            quicksin = nan;
        end

        if isfield(visit.Measures, "Reflexes")
            reflex = visit.Measures.Reflexes;
        else
            reflex = nan;
        end

        if isfield(visit.Measures, "dpOAE")
            dpoae = visit.Measures.dpOAE;
        elseif isfield(visit.Measures, "DPOAE")
            dpoae = visit.Measures.DPOAE; 
        else
            dpoae = nan;
        end
        
        if isfield(visit.Measures, "ACT")
            if isfield(visit.Measures.ACT, "scores")
                act = mean(str2double( visit.Measures.ACT.scores)); 
            else
                stringz = ''; 
                for i = 1:numel(visit.Measures.ACT.comments)
                    stringz = stringz + string(visit.Measures.ACT.comments(i)); 
                end
                act = stringz;
            end
        else
            act = "NaN"; 
        end

    elseif isfield(visit, "Audiogram")
        audio = visit.Audiogram;
        if isfield(visit, "QuickSIN")
            quicksin = visit.QuickSIN;
        else
            quicksin = nan;
        end

        if isfield(visit, "Reflexes")
            reflex = visit.Reflexes;
        else
            reflex = nan;
        end

        if isfield(visit, "dpOAE")
            dpoae = visit.dpOAE;
        elseif isfield(visit, "Measures")
            if isfield(visit.Measures, "DPOAE")
                dpoae = visit.Measures.DPOAE; 
            else
                dpoae = nan; 
            end
        else
            dpoae = nan;
        end   
    else
        disp("weird fields")
    end

    %% Organize data
    audio_f = [250, 500, 1000, 2000, 3000, 4000, 6000, 8000, 10000, 11200, 12500, 14000, 16000];
    bc_f = [250, 500, 1000, 2000, 3000, 4000];
    dpoae_f = [1000, 2344, 3750, 4781, 6000, 8000];
    
    % audiogram (AC)
    if isfield(audio, "AC")
        for i = 1:length(audio_f)
            if ismember(audio_f(i), audio.AC.R(:,1))        % right ear
                AC_R(i) = audio.AC.R(find(audio.AC.R(:,1)==audio_f(i), 1, "last"),2);
            else
                AC_R(i) = nan;
            end
            
            if ismember(audio_f(i), audio.AC.L(:,1))        % left ear
                AC_L(i) = audio.AC.L(find(audio.AC.L(:,1)==audio_f(i), 1, "last"),2);
            else
                AC_L(i) = nan;
            end
        end
    else
        AC_R = nan(size(audio_f));
        AC_L = nan(size(audio_f));
    end
    
    % audiogram (BC)
    if isfield(audio, "BC")
        for i = 1:length(bc_f)
            if ismember(bc_f(i), audio.BC.R(:,1))        % right ear
                BC_R(i) = audio.BC.R(find(audio.BC.R(:,1)==bc_f(i), 1, "last"),2);
            else
                BC_R(i) = nan;
            end
            
            if ismember(bc_f(i), audio.BC.L(:,1))        % left ear
                BC_L(i) =audio.BC.L(find(audio.BC.L(:,1)==bc_f(i),1,"last"),2);
            else
                BC_L(i) = nan;
            end
        end
    else
        BC_R = nan(size(audio_f));
        BC_L = nan(size(audio_f));
    end

    % QuickSIN
    if isfield(quicksin, "R")
        quicksin_R = quicksin.R;
        quicksin_L = quicksin.L;
    else
        quicksin_R = nan;
        quicksin_L = nan;
    end

    % Reflexes
    if isa(reflex.ProbeR.Ipsi, 'string')
        reflex_R_ipsi = reflex.ProbeR.Ipsi;
    else
        reflex_R_ipsi = nan(1,4);
    end
    if isa(reflex.ProbeL.Ipsi, 'string')
        reflex_L_ipsi = reflex.ProbeL.Ipsi;
    else
        reflex_L_ipsi = nan(1,4);
    end
    if isa(reflex.ProbeR.Contra, 'string')
        reflex_R_contra = reflex.ProbeR.Contra;
    else
        reflex_R_contra = nan(1,4);
    end
    if isa(reflex.ProbeL.Contra, 'string')
        reflex_L_contra = reflex.ProbeL.Contra;
    else
        reflex_L_contra = nan(1,4);
    end
    
    % DPOAE
    if isfield(dpoae, "R")
        for i = 1:length(dpoae_f)
            if ismember(dpoae_f(i), dpoae.R.f2(1,:))
                dp_R(i) = dpoae.R.DP(1,find(dpoae.R.f2(1,:)==dpoae_f(i)));
                nf_R(i) = dpoae.R.noisefloor(1,find(dpoae.R.f2(1,:)==dpoae_f(i)));
            else
                dp_R(i) = nan;
                nf_R(i) = nan;
            end

            if ismember(dpoae_f(i), dpoae.L.f2(1,:))
                dp_L(i) = dpoae.L.DP(1,find(dpoae.L.f2(1,:)==dpoae_f(i)));
                nf_L(i) = dpoae.L.noisefloor(1,find(dpoae.L.f2(1,:)==dpoae_f(i)));

            else
                dp_L(i) = nan;
                nf_L(i) = nan;
            end
        end
    else
        dp_R = nan(1,6);
        dp_L = nan(1,6);
        nf_R = nan(1,6);
        nf_L = nan(1,6);
    end
   
    %% Add the data to the CSV
    cellData = {subjID, date, quicksin_R, quicksin_L, act, ...
        AC_R(1), AC_R(2), AC_R(3),AC_R(4), AC_R(5),AC_R(6), AC_R(7),...
        AC_R(8), AC_R(9),AC_R(10), AC_R(11),AC_R(12), AC_R(13),...
        AC_L(1), AC_L(2),AC_L(3),AC_L(4), AC_L(5),AC_L(6), AC_L(7),...
        AC_L(8), AC_L(9), AC_L(10), AC_L(11),AC_L(12), AC_L(13), ...
        BC_R(1), BC_R(2), BC_R(3),BC_R(4), BC_R(5),BC_R(6),...
        BC_L(1), BC_L(2), BC_L(3),BC_L(4), BC_L(5),BC_L(6),...
        reflex_R_ipsi(1), reflex_R_ipsi(2),reflex_R_ipsi(3),reflex_R_ipsi(4),...
        reflex_R_contra(1), reflex_R_contra(2),reflex_R_contra(3),reflex_R_contra(4),...
        reflex_L_ipsi(1), reflex_L_ipsi(2),reflex_L_ipsi(3),reflex_L_ipsi(4),...
        reflex_L_contra(1), reflex_L_contra(2),reflex_L_contra(3),reflex_L_contra(4),...
        dp_R(1), dp_R(2), dp_R(3), dp_R(4), dp_R(5), dp_R(6),...
        nf_R(1), nf_R(2), nf_R(3), nf_R(4), nf_R(5), nf_R(6),...
        dp_L(1), dp_L(2), dp_L(3), dp_L(4), dp_L(5), dp_L(6),...
        nf_L(1), nf_L(2), nf_L(3), nf_L(4), nf_L(5), nf_L(6),...
        };
    M = [M; cellData];

    cd(allDataDir);
end
cd(allDataDir)
M = cell2table(M);
writetable(M, "Data_ARDC.csv")
disp("------------------Done!------------------")
