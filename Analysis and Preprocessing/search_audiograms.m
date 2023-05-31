%Written By: Andrew Sivaprakasam
%Last Updated: May 2023

function [id_list_L,L_lvl_list,id_list_R, R_lvl_list] = search_audiograms(freqlist,range_min,range_max,fldr)
%TODO:
%-default directory
%-frequency range
%-date range?
%-plotting toggle
%-efficient reading
%-documentation

plot_select_flag = 1;

if ~exist('freqlist','var')
    freqlist = [250, 500, 1000, 2000, 3000, 4000, 6000, 8000, 10000, 11200,...
        12500, 14000, 16000];
end

%default plots all, even with NR/NaN. But if specifying freqs will return
%specific subjects

if ~exist('range_min','var')
%     range_min = -20*ones(length(freqlist),1);
    plot_select_flag = 0;
end

if ~exist('range_max','var')
%     range_max = 120*ones(length(freqlist),1);
    plot_select_flag = 0;
end

if ~exist('fldr','var')
    fldr = '/media/sivaprakasaman/AndrewNVME/Pitch_Study/F30_Full_Data/ARDC_compiledVisits/ALL_ARDC';
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
    subjID = visit.subjectID;
    id_list(i) = string(subjID);
    [~,locL] = ismember(freqlist,visit.Audiogram.AC.L(:,1));
    [~,locR] = ismember(freqlist,visit.Audiogram.AC.R(:,1));

    %handle absent values (return NaN if loc is 0)
    %this can be cleaned up later and made more efficient

    for j = 1:length(freqlist)
        if locL(j) == 0
            L_lvl(j) = NaN;
            disp([subjID,' missing record at ', num2str(freqlist(j)),' Hz on Left.']);
        else
            L_lvl(j) = visit.Audiogram.AC.L(locL(j),2);
        end

        if locR(j) == 0
            R_lvl(j) = NaN;
            disp([subjID,' missing record at ', num2str(freqlist(j)),' Hz on Right.']);
        else
            R_lvl(j) = visit.Audiogram.AC.R(locR(j),2);
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
    
    id_list_L = id_list(find(L_subjs_exc));
    id_list_R = id_list(find(R_subjs_exc));
else 
    %handle default case
    id_list_L = id_list;
    id_list_R = id_list;
end

%plotting
figure;
hold on;

plot(freqlist,R_lvl_list,'Color',[clrs_r, alp],'linewidth',1.5);
plot(freqlist,L_lvl_list,'Color',[clrs_l, alp],'linewidth',1.5);

plot(freqlist,mean(R_lvl_list,2,'omitnan'),'color',clrs_r,'LineWidth',3.5);
plot(freqlist,mean(L_lvl_list,2,'omitnan'),'color',clrs_l,'LineWidth',3.5);

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
cd(cwd);

end