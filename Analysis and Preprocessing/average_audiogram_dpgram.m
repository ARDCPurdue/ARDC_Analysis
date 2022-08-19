clear
close all

subjects = ["NS1","NS2","NS3"];

start_path = pwd;

cd ../
cd Data/Data_NS/Visits_Compiled

fnames = ls('V*');
fnames = split(fnames(1:end-1));
freq_ac = [250,500,1e3,2e3,3e3,4e3,6e3,8e3,10e3,11.2e3,12.5e3,14e3,16e3];
%freq_bc = [250,500,1e3,2e3,3e3,4e3];
dpoae_f2 = [1000,2344,3750,4781,6000,8000];
%rflx_f =   [500 1000 2000 4000];

%range_WBT = -300:1:150;
%freq_226 = 1;
n = 0;

for i = 1:length(fnames)
    
    subject = subjects(i);
    load(fnames{i});
    
    if(strcmp(visit.subjectID, subject))
        n = n+1;
        
        %Audiogram
         
         %Left
         agram = visit.Audiogram.AC.L;
         %make sure correct frequencies are included
         [~,agram_ind] = intersect(agram(:,1),freq_ac);
         ac_L(1:length(agram_ind),n) = agram(agram_ind,2);
         
         %Right
         agram = visit.Audiogram.AC.R;
         %make sure correct frequencies are included
         [~,agram_ind] = intersect(agram(:,1),freq_ac);
         ac_R(1:length(agram_ind),n) = agram(agram_ind,2);
         
       %dpoae
        %Left:
            dpoae = visit.dpOAE.L;
            nf_L(:,n) = dpoae.noisefloor;
            DP_L(:,n) = dpoae.DP;
            f1_rec_dB_L(:,n) = dpoae.f1_rec_dB;
            f2_rec_dB_L(:,n) = dpoae.f2_rec_dB;
            
         %Right:
            dpoae = visit.dpOAE.R;
            nf_R(:,n) = dpoae.noisefloor;
            DP_R(:,n) = dpoae.DP;
            f1_rec_dB_R(:,n) = dpoae.f1_rec_dB;
            f2_rec_dB_R(:,n) = dpoae.f2_rec_dB;
        
    end    
    
end

%% Plotting/Means

%Audiometry
AC_L_Mean = mean(ac_L,2);
AC_L_STD = std(double(ac_L'));
AC_R_Mean = mean(ac_R,2);
AC_R_STD = std(double(ac_R'));
% 
% BC_R_Mean = mean(bc_R,2);
% BC_R_STD = std(double(bc_R'));

hold on
title(['Air Conduction'])
errorbar(freq_ac,AC_R_Mean,AC_R_STD,'Or-','LineWidth',1.5);
errorbar(freq_ac,AC_L_Mean,AC_L_STD,'Xb-','LineWidth',1.5);
set(gca,'ydir','reverse');
ylabel('Hearing Level (dB HL)');
set(gca,'XScale','log');
legend('R_{AC}','L_{AC}', 'Location','Southwest')
xlabel('Frequency (Hz)');
grid on
hold off
xlim([140,18000]);


% ax2 = subplot(4,2,2);
% hold on
% title(['Bone Conduction'])
% errorbar(freq_bc,BC_R_Mean,BC_R_STD,'<r--','LineWidth',1.5);
% set(gca,'ydir','reverse');
% ylabel('Hearing Level (dB HL)');
% set(gca,'XScale','log');
% xlabel('Frequency (Hz)');
% legend('R_{BC}', 'Location','Southwest')
% grid on
% hold off
% 
% linkaxes([ax1,ax2],'x');

%DPOAEs
%Left
dp_L_Mean = mean(DP_L,2);
dp_L_STD = std(double(DP_L'));
nf_L_Mean = mean(nf_L,2);
nf_L_STD = std(double(nf_L'));

dp_R_Mean = mean(DP_R,2);
dp_R_STD = std(double(DP_R'));
nf_R_Mean = mean(nf_R,2);
nf_R_STD = std(double(nf_R'));

nf_combined = (nf_L_Mean + nf_R_Mean)/2;
figure;
hold on
errorbar(dpoae_f2,dp_L_Mean,dp_L_STD,'Ob-','LineWidth',1.5);
errorbar(dpoae_f2,dp_R_Mean,dp_R_STD,'Or-','LineWidth',1.5);
plot(dpoae_f2,nf_combined,'Ok-','LineWidth',1.5);
xticks(dpoae_f2);
xticklabels(dpoae_f2);
xlim([900,10000]);
legend('DP-L','DP-R','Noise Floor','Location','SouthWest')

ylabel('DP Level (dB SPL)');
xlabel('Frequency (Hz)');
title(['Mean dpOAE'])
grid on
set(gca,'XScale','log');
set(gca,'FontSize',9);

% hold on
% errorbar(dpoae_f2,dp_R_Mean,dp_R_STD,'Or-','LineWidth',1.5);
% errorbar(dpoae_f2,nf_R_Mean,nf_R_STD,'Ok-','LineWidth',1.5);
% xticks(dpoae_f2);
% xticklabels(dpoae_f2);
% xlim([900,10000]);

% ylabel('DP Level (dB SPL)');
% xlabel('Frequency (Hz)');
% title(['DPgram R'])
% set(gca,'XScale','log');
% set(gca,'FontSize',9);
% legend('DP','Noise Floor','Location','NorthEast')
% grid on

cd(start_path)