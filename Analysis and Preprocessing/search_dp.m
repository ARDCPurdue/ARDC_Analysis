function [id_list_L,L_lvl_list,L_nf_list,id_list_R, R_lvl_list,R_nf_list] = search_dp(freqlist,range_min,range_max,fldr,fig_flag)
% [id_list_L,L_lvl_list,L_nf_list,id_list_R, R_lvl_list,R_nf_list] = SEARCH_DP(freqlist,range_min,range_max,fldr,fig_flag)
% 
% Description: Compiles dpOAEs with a given hearing loss profile, returns ARDC IDs, and levels. If run
%without arguments, compiles and plots ALL dps in a given folder of
%ARDC visit files.
%Input:
%freqlist = a vector of frequencies to search/plot (defaults is ARDC
%standard protocol)
%range_min = the lower bound of DP (dbSPL) to include (size must be equal to freqlist)
%range_max = the upper bound of DP (dbSPL) to include (size must be equal to freqlist)
%fldr = folder with ARDC visit files
%fig_flag = plot the DPs (defaults to 1, 0 = off)
%
%Output:
%id_list_L = list of subjects with left ears that match criteria
%L_lvl_lst = dB SPL values (each column corresponds to subject in id_list_L)
%L_nf_list = dB SPL values of noisefloor
%id_list_R = list of subjects with right ears that match criteria 
%R_lvl_lst = dB SPL values (each column corresponds to subject in id_list_R)
%R_nf_list = dB SPL values of noisefloor

%Written By: Andrew Sivaprakasam
%Last Updated: June 2023

plot_select_flag = 1;

if ~exist('freqlist','var') || isempty(freqlist)
    freqlist = [ 1000 2344 3750 4781 6000 8000];
end

%default plots all, even with NR/NaN. But if specifying freqs will return
%specific subjects

if ~exist('range_min','var') || isempty(range_min)
    plot_select_flag = 0;
end

if ~exist('range_max','var') || isempty(range_max)
    plot_select_flag = 0;
end

if ~exist('fldr','var')  || isempty(fldr)
    fldr = 'C:\Users\ARDC User\Desktop\Compiled';
end

if ~exist('fig_flag','var') || isempty(fig_flag)
    fig_flag = 1;
end

cwd = pwd;
clrs_l = [52, 119, 235]./256;
clrs_r = [153, 24, 24]./256;
alp = .2;
skip_flag = 0;

cd(fldr);

%load all files
fnames = {dir(fullfile(cd,'ARDC*.mat')).name};

for i = 1:length(fnames)

    load(fnames{i});
    subjID = visit.subjectID;
    id_list(i) = string(subjID);
    
    try
        [~,locL] = ismember(freqlist,visit.dpOAE.L.f2);
        [~,locR] = ismember(freqlist,visit.dpOAE.R.f2); 
        dp_struct = visit.dpOAE;
        
    catch
        
        try
            [~,locL] = ismember(freqlist,visit.Measures.dpOAE.L.f2(:,1));
            [~,locR] = ismember(freqlist,visit.Measures.dpOAE.R.f2(:,1));
            dp_struct = visit.Measures.dpOAE;
            disp([subjID, ' has the new format!']);
        catch
            warning([subjID,' visit has invalid format']);
            skip_flag = 1;
        end 
        
    end 

    %handle absent values (return NaN if loc is 0)
    %this can be cleaned up later and made more efficient

 if ~skip_flag
     
    for j = 1:length(freqlist)
        if locL(j) == 0 %bad coding...just preallocate...
            L_lvl(j) = NaN;
            L_nf(j) = NaN;
            
            disp([subjID,' missing record at ', num2str(freqlist(j)),' Hz on Left.']);
        else
            L_lvl(j) = dp_struct.L.DP(locL(j));
            L_nf(j) = dp_struct.L.noisefloor(locL(j));
        end

        if locR(j) == 0
            R_lvl(j) = NaN;
            R_nf(j) = NaN;
            
            disp([subjID,' missing record at ', num2str(freqlist(j)),' Hz on Right.']);
        else
            R_lvl(j) = dp_struct.R.DP(locR(j));
            R_nf(j) = dp_struct.R.noisefloor(locR(j));

        end
    end

    R_lvl_list(:,i) = R_lvl;
    L_lvl_list(:,i) = L_lvl;
    R_nf_list(:,i) = R_nf;
    L_nf_list(:,i) = L_nf;
    
    clear R_lvl L_lvl locL locR;
 end 
 
end

if plot_select_flag
    in_range_L = L_lvl_list>range_min' & L_lvl_list<range_max';
    in_range_R = R_lvl_list>range_min' & R_lvl_list<range_max';

    L_subjs_exc = any(in_range_L==0,1);
    R_subjs_exc = any(in_range_R==0,1);

    L_lvl_list = L_lvl_list(:,find(L_subjs_exc==0));
    R_lvl_list = R_lvl_list(:,find(R_subjs_exc==0));
    L_nf_list = L_nf_list(:,find(L_subjs_exc==0));
    R_nf_list = R_nf_list(:,find(R_subjs_exc==0));

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
    
    plot(freqlist,R_lvl_list,'o-','Color',[clrs_r, alp],'linewidth',1.5,'HandleVisibility','off');
    plot(freqlist,L_lvl_list,'x-','Color',[clrs_l, alp],'linewidth',1.5,'HandleVisibility','off');
    
    plot(freqlist,R_nf_list,'--','Color',[clrs_r, .25*alp],'linewidth',1.5,'HandleVisibility','off');
    plot(freqlist,L_nf_list,'--','Color',[clrs_l, .25*alp],'linewidth',1.5,'HandleVisibility','off');

    plot(freqlist,mean(R_lvl_list,2,'omitnan'),'color',clrs_r,'LineWidth',3.5);
    plot(freqlist,mean(L_lvl_list,2,'omitnan'),'color',clrs_l,'LineWidth',3.5);
    
    plot(freqlist,mean(R_nf_list,2,'omitnan'),'--','color',[clrs_r,alp],'LineWidth',3.5);
    plot(freqlist,mean(L_nf_list,2,'omitnan'),'--','color',[clrs_l,alp],'LineWidth',3.5);

    legend('R_{dpOAE}','L_{dpOAE}','R_{noisefloor}','L_{noisefloor}','Location','Southwest');

    xticks(freqlist);
    set(gca,'XScale','log');
    set(gcf,'Position',[1925,-5,1920,1200])
    xlabel('F2 Frequency (Hz)');
    ylabel('DP (dB SPL)');
    xlim([500,10e3])
    ylim([-50,30])
    grid on 
    title(['dpOAEs | N = ',num2str(length(unique([id_list_L, id_list_R]))),' Unique Subjects'])
    xlim([min(freqlist)-2,max(freqlist)+100])
    xtickangle(55)
    set(findall(gcf,'-property','FontSize'),'FontSize',12)
    set(gcf,'Position',[675 282 981 683]);
    grid on
    hold off
end 

cd(cwd)


end

