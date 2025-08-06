
pta_freqs = [.5 8];
freq = [.25 .5 1 2 3 4 8 ];
subj1 = [0 10 15 5 15 10 5];
subj2 = [25 35 40 45 45 40 55];
subj4 = [0 10 20 25 20 10 5];
subj3 = [15 35 50 45 nan 40 55];
subj5 = [20 20 20 20 20 20 nan];


all_subjects = [subj1 ; subj2; subj3; subj4; subj5]

for x = 1:size(all_subjects,1)
    for y = 1:size(pta_freqs,2)
        if size(all_subjects, 1) > 0 
            just_pta_thresholds(y) = all_subjects(x, freq == pta_freqs(y))
            pta(x,1) = mean(just_pta_thresholds)
        end

    end
end

%% 
frequencies = [.25 .5 1 2 3 4 6 8];
thresholds = [0 10 5 15 20 30 55 60; 
              10 10 15 10 25 25 45 65]; 

figure_prop_name = {'PaperPositionMode', 'units', 'Position'};
figure_prop_val = {'auto', 'inches', [1 1 6 5]}; % xcor, ycor, xwid, yheight

audiogram = figure(44); clf
set(gcf,figure_prop_name,figure_prop_val);

fontsize = 50


hold on; 
plot([.2, 10], [20 20], "Color", 'k', 'LineStyle','--', 'LineWidth', 1.5, "HandleVisibility","off")
plot(frequencies, thresholds(1,:), 'o-', "Color", "#ca0020", "LineWidth",2, ...
    "MarkerSize", 10)
plot(frequencies, thresholds(2,:), 'x-', "Color", "#0571b0", "LineWidth",2, ...
    "MarkerSize", 10)
xlabel("Frequency (kHz)", "FontSize", fontsize)
ylabel("Hearing Level (dB HL)", "FontSize", fontsize)
xticks(frequencies)
yticks([-10:10:120])
ylim([-10, 120])
xlim([.2 10])
set(gca, 'YDir','reverse', 'XAxisLocation', 'top','XScale', 'log' )
legend("Right", "Left", "Location","southwest")
grid on
box on 

result = polyfit(frequencies, thresholds(1,:), 1)
newx = [.25:.1:8]
newy = result(1)*newx + result(2); 
plot(newx, newy, 'g')
text(.4, 70, sprintf("Linear fit: y = %d*x + %d", round(result(1), 3), round(result(2), 3)))

hold off; 

print(gcf,'myAudio','-dpng','-r600');

