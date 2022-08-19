function plt_aud(AC_R, BC_R, AC_L, BC_L)
%Description: Plots audiogram using the output variables from
%parseAudiogram.m function. This should match directly what is acquired
%from Audiostar. 
%
%  plt_aud(AC_R, BC_R, AC_L, BC_L)
%
%Author: Andrew Sivaprakasam
%Email: asivapr@purdue.edu

hold on;
plot(AC_R(:,1),AC_R(:,2),'Or-','LineWidth',1.5);
plot(AC_L(:,1),AC_L(:,2),'Xb-','LineWidth',1.5);
plot(BC_R(:,1),BC_R(:,2),'<r--','LineWidth',1.5);
plot(BC_L(:,1),BC_L(:,2),'>b--','LineWidth',1.5);
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

end

