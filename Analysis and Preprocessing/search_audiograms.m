function [id_list_L,L_lvl_list,id_list_R, R_lvl_list] = search_audiograms(freqlist,range_min,range_max,fldr,fig_flag)
% [id_list_L,L_lvl_list,id_list_R, R_lvl_list] = SEARCH_AUDIOGRAMS(freqlist,range_min,range_max,fldr,fig_flag)
% 
% Description: Compiles audiograms with a given hearing loss profile, returns ARDC IDs, and levels. If run
%without arguments, compiles and plots ALL audiograms in a given folder of
%ARDC visit files.
%Input:
%freqlist = a vector of frequencies to search/plot (defaults is ARDC
%standard protocol)
%range_min = the lower bound of audibility (dB HL) to include (size must be equal to freqlist)
%range_max = the upper bound of audibility (dB HL) to include (size must be equal to freqlist)
%fldr = folder with ARDC visit files
%fig_flag = plot the audiogram (defaults to 1, 0 = off)
%
%Output:
%id_list_L = list of subjects with left ears that match criteria
%L_lvl_lst = dB HL values (each column corresponds to subject in id_list_L)
%id_list_R = list of subjects with right ears that match criteria 
%R_lvl_lst = dB HL values (each column corresponds to subject in id_list_R)

%Written By: Andrew Sivaprakasam
%Last Updated: June 2023

%TODO: NR should be reported 

if ~exist('freqlist','var') || isempty(freqlist)
    freqlist = [250, 500, 1000, 2000, 3000, 4000, 6000, 8000, 10000, 11200,...
        12500, 14000, 16000];
end

%default plots all, even with NR/NaN. But if specifying freqs will return
%specific subjects
plot_select_flag = 1; %SH added 11/15/23 (not working without)

if ~exist('range_min','var') || isempty(range_min)
    plot_select_flag = 0;
end

if ~exist('range_max','var') || isempty(range_max)
    plot_select_flag = 0;
end

if ~exist('fldr','var') || isempty(fldr)
    fldr = 'C:\Users\ARDC User\Desktop\Compiled';
end

if ~exist('fig_flag','var') || isempty(fig_flag)
    fig_flag = 1;
end

cwd = pwd;
clrs_l = [52, 119, 235]./256;
clrs_r = [153, 24, 24]./256;
alp = .2;

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
                break; 
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


if plot_select_flag
    in_range_L = L_lvl_list>range_min' & L_lvl_list<range_max';
    in_range_R = R_lvl_list>range_min' & R_lvl_list<range_max';

    L_subjs_exc = any(in_range_L==0,1);
    R_subjs_exc = any(in_range_R==0,1);

    L_lvl_list = L_lvl_list(:,find(L_subjs_exc==0));
    R_lvl_list = R_lvl_list(:,find(R_subjs_exc==0));
    
    id_list_L = id_list(find(L_subjs_exc==0));
    id_list_R = id_list(find(R_subjs_exc==0));
else 
    %handle default case
    id_list_L = id_list;
    id_list_R = id_list;
end

if isempty(L_lvl_list) || isempty(R_lvl_list)
    cd(cwd);
    error('No data found with specified range');
end

if fig_flag
    figure;
    hold on;
    
    plot(freqlist,R_lvl_list,'Color',[clrs_r, alp],'linewidth',1.5,'HandleVisibility','off');
    plot(freqlist,L_lvl_list,'Color',[clrs_l, alp],'linewidth',1.5,'HandleVisibility','off');
    
    plot(freqlist,mean(R_lvl_list,2,'omitnan'),'color',clrs_r,'LineWidth',3.5);
    plot(freqlist,mean(L_lvl_list,2,'omitnan'),'color',clrs_l,'LineWidth',3.5);
    

    legend('Right','Left','location','southwest');
    ylim([-20,120])
    yticks([-20:10:120]);
    xticks(freqlist);
    set(gca,'ydir','reverse');
    ylabel('Hearing Level (dB HL)','FontWeight','bold');
    set(gca,'XScale','log');
    xlabel('Frequency (Hz)','FontWeight','bold');
    title(['Audiograms | N = ',num2str(length(unique([id_list_L, id_list_R]))),' Unique Subjects'])
    xlim([min(freqlist)-2,max(freqlist)+100])
    xtickangle(55)
    set(findall(gcf,'-property','FontSize'),'FontSize',12)
    set(gcf,'Position',[675 282 981 683]);
    grid on
    hold off
end 

cd(cwd);

end