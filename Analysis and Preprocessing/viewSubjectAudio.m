%% viewSubjectAudio

AC_R = visit.Measures.Audiometry.AC.R; 
AC_L = visit.Measures.Audiometry.AC.L; 

BC_R = visit.Measures.Audiometry.BC.R; 
BC_L = visit.Measures.Audiometry.BC.L; 

disp(visit.Subject.age)

%load all files
hold on;
plot(AC_R(:,1),AC_R(:,2),'Or-','LineWidth',1.5);
plot(AC_L(:,1),AC_L(:,2),'Xb-','LineWidth',1.5);
plot(BC_R(:,1),BC_R(:,2),'<r--','LineWidth',1.5);
plot(BC_L(:,1),BC_L(:,2),'>b--','LineWidth',1.5);
plot(AC_R(:,1), 20*ones(size(AC_R(:,1))), 'k--', 'linew', 1)
ylim([-20,120])
yticks([-20:10:120]);
set(gca,'ydir','reverse');
ylabel('Hearing Level (dB HL)');
set(gca,'XScale','log');
xlabel('Frequency (Hz)');
legend('R_{AC}','L_{AC}','R_{BC}','L_{BC}','Location','Southwest')
grid on
hold off
sgtitle('Audiogram');
