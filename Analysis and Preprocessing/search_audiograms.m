%Written By: Andrew Sivaprakasam
%Last Updated: May 2023

function [outputArg1,outputArg2] = search_audiograms(freqlist,fldr)
%TODO:
%-default directory
%-frequency range
%-date range?
%-plotting toggle
%-efficient reading
%-documentation

if ~exist('freqlist','var')
    freqlist = [250, 500, 1000, 2000, 3000, 4000, 6000, 8000, 10000, 11200,...
       12500, 14000, 16000]; 
end

if ~exist('fldr','var')
    fldr = '/home/sivaprakasaman/Documents/dataTemp/ALL_ARDC';
end

cwd = pwd;
clrs_l = [52, 119, 235]./256;
clrs_r = [153, 24, 24]./256;
alp = .2;

cd(fldr);

%load all files
fnames = {dir(fullfile(cd,'ARDC*.mat')).name};

figure;
hold on;

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

    
    plot(freqlist,R_lvl,'Color',[clrs_r, alp],'linewidth',1.5);
    plot(freqlist,L_lvl,'Color',[clrs_l, alp],'linewidth',1.5);

    clear R_lvl L_lvl locL locR;
end

plot(freqlist,mean(R_lvl_list,2,'omitnan'),'color',clrs_r,'LineWidth',3.5);
plot(freqlist,mean(L_lvl_list,2,'omitnan'),'color',clrs_l,'LineWidth',3.5);


ylim([-20,120])
yticks([-20:10:120]);
xticks(freqlist);
set(gca,'ydir','reverse');
ylabel('Hearing Level (dB HL)','FontWeight','bold');
set(gca,'XScale','log');
xlabel('Frequency (kHz)','FontWeight','bold');
title(['Audiograms | N = ',num2str(length(unique(id_list))),' Unique Subjects'])
xlim([min(freqlist)-2,max(freqlist)+100])
xtickangle(55)
set(findall(gcf,'-property','FontSize'),'FontSize',12)
set(gcf,'Position',[675 282 981 683]);
grid on
hold off
cd(cwd);

end