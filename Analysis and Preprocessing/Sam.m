%% Get all ARDC data into spreadsheet
    fldr = 'C:\Users\ARDC User\Desktop\ARDR Data'; 
cwd = pwd;

cd(fldr);

%load all files
fnames = {dir(fullfile(cd,'ARDC*.mat')).name};

for i = 1:length(fnames)

    load(fnames{i});
    try
        subjID = visit.subjectID;
    catch
        subjID = visit.Subject.ID; 
    end
        disp([subjID]); 
        
    id_list(i) = string(subjID);
    
    %updated to handle new format!
    try 
        [~,locL] = ismember(freqlist,visit.Audiogram.AC.L(:,1));
        [~,locR] = ismember(freqlist,visit.Audiogram.AC.R(:,1));
        aud_struct = visit.Audiogram;
    catch
        try
            [~,locL] = ismember(freqlist,visit.Measures.Audio.AC.L(:,1));
            [~,locR] = ismember(freqlist,visit.Measures.Audio.AC.R(:,1));
            aud_struct = visit.Measures.Audio;
            disp([subjID, ' has the new format (Audio)!']);
        catch
            try
                [~,locL] = ismember(freqlist,visit.Measures.Audiometry.AC.L(:,1));
                [~,locR] = ismember(freqlist,visit.Measures.Audiometry.AC.R(:,1));
                aud_struct = visit.Measures.Audiometry;
                disp([subjID, ' has the new format (Audiometry)!']);
            catch
                disp([subjID,' visit has invalid format']);
                continue; 
            end
        end
    end
    
    %handle absent values (return NaN if loc is 0)
    %this can be cleaned up later and made more efficient

    for j = 1:length(freqlist)
        if locL(j) == 0
            L_lvl(j) = NaN;
            disp([subjID,' missing record at ', num2str(freqlist(j)),' Hz on Left.']);
        else
            L_lvl(j) = aud_struct.AC.L(locL(j),2);
        end

        if locR(j) == 0
            R_lvl(j) = NaN;
            disp([subjID,' missing record at ', num2str(freqlist(j)),' Hz on Right.']);
        else
            R_lvl(j) = aud_struct.AC.R(locR(j),2);
        end
    end

    R_lvl_list(:,i) = R_lvl;
    L_lvl_list(:,i) = L_lvl;

    clear R_lvl L_lvl locL locR; 
end
