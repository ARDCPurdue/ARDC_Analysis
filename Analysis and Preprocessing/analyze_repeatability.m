clear
close all

subject = 'ARDC2';

start_path = pwd;
dataDir = 'D:\ARDC\Pilot Study Example\2_Visits_Compiled';

cd(dataDir)

fnames = ls([subject,'*.mat']);
%fnames = split(fnames(1:end-1));
freq_ac = [250,500,1e3,2e3,3e3,4e3,6e3,8e3,10e3,11.2e3,12.5e3,14e3,16e3];
freq_bc = [250,500,1e3,2e3,3e3,4e3];

ac_L = zeros(length(freq_ac),1);
bc_L = zeros(length(freq_bc),1);

ac_R = zeros(length(freq_ac),1);
bc_R = zeros(length(freq_bc),1);

dpoae_f2 = [1000,2344,3750,4781,6000,8000];
rflx_f =   [500 1000 2000 4000];

range_WBT = -300:1:150;
freq_226 = 1;
n = 0;

for i = 1:size(fnames,1)
 
    load(fnames(i,:));
    
    if(strcmp(visit.subjectID, subject))
        n = n+1;
        
        %Audiogram
         
         %Left
         agram = visit.Audiogram.AC.L;
         %make sure correct frequencies are included
         [~,agram_ind_a,agram_ind_b] = intersect(agram(:,1),freq_ac);
         ac_L(agram_ind_b,n) = agram(agram_ind_a,2);
         
         %Right
         agram = visit.Audiogram.AC.R;
         %make sure correct frequencies are included
         [~,agram_ind_a,agram_ind_b] = intersect(agram(:,1),freq_ac);
         ac_R(agram_ind_b,n) = agram(agram_ind_a,2);
        
         agram = visit.Audiogram.BC.R;
         %make sure correct frequencies are included
         [~,agram_ind_a,agram_ind_b] = intersect(agram(:,1),freq_bc);
         bc_R(agram_ind_b,n) = agram(agram_ind_a,2);
         
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
        
      %WBT
       %Left
           %need to do an interpolation to match the values to compare
           %across Pressures at a given freq
           [pres2, ind] = unique(visit.WBT.L.PRESSURE);
           absorb = visit.WBT.L.ABSORBANCE(ind,freq_226);
           WBT_L(:,n) = spline(pres2,absorb,range_WBT);
           
       %Right
           %need to do an interpolation to match the values to compare
           %across Pressures at a given freq
           [pres2, ind] = unique(visit.WBT.R.PRESSURE);
           absorb = visit.WBT.R.ABSORBANCE(ind,freq_226);
           WBT_R(:,n) = spline(pres2,absorb,range_WBT);
           
       %QuickSIN
       QS_L(:,n) =  visit.QuickSIN.L;
       QS_R(:,n) =  visit.QuickSIN.R;
       
       %Reflexes:
       %Probe Right:
        RFLX_R_Ips(:,n) = visit.Reflexes.ProbeR.Ipsi;
        RFLX_R_Cont(:,n) = visit.Reflexes.ProbeR.Contra;
               
       %Probe Left:
        RFLX_L_Ips(:,n) = visit.Reflexes.ProbeL.Ipsi;
        RFLX_L_Cont(:,n) = visit.Reflexes.ProbeL.Contra;
        
    end    
    
end

%% Plotting/Means

%Audiometry
AC_L_Mean = mean(ac_L,2);
AC_L_STD = std(double(ac_L'));
AC_R_Mean = mean(ac_R,2);
AC_R_STD = std(double(ac_R'));

BC_R_Mean = mean(bc_R,2);
BC_R_STD = std(double(bc_R'));

sgtitle(subject)
ax1 = subplot(4,2,1);
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
xlim([200,8100]);
ylim([-10,120]);
yticks([-10:10:120]);
xticks(freq_ac(1:8))

ax2 = subplot(4,2,2);
hold on
title(['Bone Conduction'])
errorbar(freq_bc,BC_R_Mean,BC_R_STD,'<r--','LineWidth',1.5);
set(gca,'ydir','reverse');
ylabel('Hearing Level (dB HL)');
set(gca,'XScale','log');
xlabel('Frequency (Hz)');
legend('R_{BC}', 'Location','Southwest')
grid on
hold off
xlim([200,8100]);
ylim([-10,120]);
yticks([-10:10:120]);
xticks(freq_ac(1:8))
linkaxes([ax1,ax2],'x');

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


ax3 = subplot(4,2,3);
hold on
errorbar(dpoae_f2,dp_L_Mean,dp_L_STD,'Ob-','LineWidth',1.5);
errorbar(dpoae_f2,nf_L_Mean,nf_L_STD,'Ok-','LineWidth',1.5);
xticks(dpoae_f2);
xticklabels(dpoae_f2);
xlim([900,10000]);

ylabel('DP Level (dB SPL)');
xlabel('Frequency (Hz)');
title(['DPgram L'])
grid on
set(gca,'XScale','log');
set(gca,'FontSize',9);
legend('DP','Noise Floor','Location','NorthEast')

ax4 = subplot(4,2,4);
hold on
errorbar(dpoae_f2,dp_R_Mean,dp_R_STD,'Or-','LineWidth',1.5);
errorbar(dpoae_f2,nf_R_Mean,nf_R_STD,'Ok-','LineWidth',1.5);
xticks(dpoae_f2);
xticklabels(dpoae_f2);
xlim([900,10000]);

ylabel('DP Level (dB SPL)');
xlabel('Frequency (Hz)');
title(['DPgram R'])
set(gca,'XScale','log');
set(gca,'FontSize',9);
legend('DP','Noise Floor','Location','NorthEast')

linkaxes([ax3,ax4],'xy');
grid on

%Reflexes

RFLX_L_C_Mean = mean(RFLX_L_Cont,2);
RFLX_L_C_std = std(RFLX_L_Cont');

RFLX_L_I_Mean = mean(RFLX_L_Ips,2);
RFLX_L_I_std = std(RFLX_L_Ips');

RFLX_R_C_Mean = mean(RFLX_R_Cont,2);
RFLX_R_C_std = std(RFLX_R_Cont');

RFLX_R_I_Mean = mean(RFLX_R_Ips,2);
RFLX_R_I_std = std(RFLX_R_Ips');

ax5 = subplot(4,2,5);
hold on
errorbar(rflx_f,RFLX_L_I_Mean,RFLX_L_I_std,'sqb','LineWidth',1.5);
errorbar(rflx_f,RFLX_L_C_Mean,RFLX_L_C_std,'sqr','LineWidth',1.5);

legend('Ipsilateral Elicitor','Contralateral Elicitor','Location','North')
ylabel('Reflex Threshold');
xlabel('Frequency (Hz)');
title(['Probe Left | Reflexes'])
grid on
set(gca,'XScale','log');
set(gca,'FontSize',9);
xticks([0,rflx_f]);
xticklabels([0,rflx_f]);
xlim([400,5e3])

ax6 = subplot(4,2,6);
hold on
errorbar(rflx_f,RFLX_R_I_Mean,RFLX_R_I_std,'sqr','LineWidth',1.5);
errorbar(rflx_f,RFLX_R_C_Mean,RFLX_R_C_std,'sqb','LineWidth',1.5);

legend('Ipsilateral Elicitor','Contralateral Elicitor','Location','North')
ylabel('Reflex Threshold');
xlabel('Frequency (Hz)');
title(['Probe Right | Reflexes'])
grid on
set(gca,'XScale','log');
set(gca,'FontSize',9);
xticks([0,rflx_f]);
xticklabels([0,rflx_f]);
xlim([400,5e3])

% WBT:
WBT_L_Mean = mean(WBT_L,2);
WBT_L_STD = std(WBT_L');
WBT_R_Mean = mean(WBT_R,2);
WBT_R_STD = std(WBT_R');

ax7 = subplot(4,2,7);
hold on;
plot(range_WBT, WBT_L_Mean, 'b','LineWidth',1.5);
plot(range_WBT, WBT_R_Mean, 'r','LineWidth',1.5);


plot(range_WBT, WBT_L_Mean+WBT_L_STD', 'b--');
plot(range_WBT, WBT_L_Mean-WBT_L_STD', 'b--');
plot(range_WBT, WBT_R_Mean+WBT_R_STD', 'r--');
plot(range_WBT, WBT_R_Mean-WBT_R_STD', 'r--');

legend('Left','Right','Location','NorthEast')
xlabel('Pressure (dPa)');
ylabel('Admittance (mmho)');
title(['Wide-Band Tymp @226Hz'])
ylim([0,max(WBT_L_Mean+WBT_L_STD')+0.005])
grid on

%QuickSIN
ax8 = subplot(4,2,8);

QS_L_Mean = mean(QS_L);
QS_L_STD = std(QS_L);
QS_R_Mean = mean(QS_R);
QS_R_STD = std(QS_R);
hold on
errorbar(1,QS_L_Mean,QS_L_STD,'sqb','LineWidth',1.5);
errorbar(2,QS_R_Mean,QS_R_STD,'sqr','LineWidth',1.5);
xticks([1,2]);
xticklabels({"Left","Right"});
xlim([0,3])
ylabel('Words Correct');
title(['QuickSIN'])
grid on

%set(gcf,'Position',[1925,-5,1920,1200])
set(gcf,'Position',[-1199 -253 1200 1803],'Units','pixels');
cd(dataDir);

exportgraphics(gcf,[subject,'_compiled.png'],'Resolution',300)

cd(start_path)

%% Figures for talk:
% 
% figure;
% subplot(1,3,1:2)
% hold on
% plot(freq_ac(1:8), AC_R_Mean(1:8),'Or-','LineWidth',3,'MarkerSize',15)
% plot(freq_ac(1:8), AC_L_Mean(1:8),'Xb-','LineWidth',3,'MarkerSize',15)
% plot(freq_bc, BC_R_Mean,'<r--','LineWidth',1.5,'MarkerSize',15)
% set(gca,'ydir','reverse');
% ylabel('Hearing Level (dB HL)');
% set(gca,'XScale','log');
% hold off
% grid on
% xlim([200,8100]);
% ylim([-10,120]);
% yticks([-10:10:120]);
% xticks(freq_ac(1:8))
% set(gca,'FontSize',12);
% 
% subplot(1,3,3);
% hold on
% plot(freq_ac(9:end), AC_R_Mean(9:end),'Or-','LineWidth',3,'MarkerSize',15)
% plot(freq_ac(9:end), AC_L_Mean(9:end),'Xb-','LineWidth',3,'MarkerSize',15)
% set(gca,'ydir','reverse');
% set(gca,'XScale','log');
% set(gca,'FontSize',12);
% hold off
% grid on
% xlim([9000,16100]);
% ylim([-10,120]);
% yticks([-10:10:120]);
% yticklabels([]);
% xticks(freq_ac(9:end))
% 
% %%
% 
% figure;
% hold on
% plot(dpoae_f2,dp_R_Mean,'Or-','LineWidth',3,'MarkerSize',15);
% plot(dpoae_f2,dp_L_Mean,'Xb-','LineWidth',3,'MarkerSize',15);
% plot(dpoae_f2,mean([nf_R_Mean,nf_L_Mean],2),'k-','LineWidth',3,'MarkerSize',15);
% xticks(dpoae_f2);
% xticklabels(dpoae_f2);
% xlim([900,10000]);
% grid on
% 
% ylabel('DP Level (dB SPL)');
% xlabel('Frequency (Hz)');
% set(gca,'XScale','log');
% set(gca,'FontSize',12);
% legend('DP-Right','DP-Left','Noise Floor','Location','NorthEast')
% 
% %% 
% 
% figure;
% hold on;
% plot(range_WBT, WBT_L_Mean, 'b','LineWidth',3);
% plot(range_WBT, WBT_R_Mean, 'r','LineWidth',3);
% legend('Left','Right','Location','NorthEast')
% xlabel('Pressure (dPa)');
% ylabel('Admittance (mmho)');
% ylim([0,max(WBT_L_Mean+WBT_L_STD')+0.005])
% grid on