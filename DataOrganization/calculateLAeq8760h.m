function noise_out = calculateLAeq8760h(noise)

% function just takes one row of data at a time. 

% L_Aeq8760h = A weighted, eq, 8760 for all hours
% 100% dose is 85 for NIOSH, which woul dbe an annual equivalent of 78.6


% EF = episodic freq, category responses: never, every frew months,
% monthly, weekly, daily + estimated hours: 8+, 4-8, 1-4, <1
% EL = episodic level
% EE dose (D) = (C/T) * 100, C=number of hours, T=hours/year that are
% hazardous T = 8760/2^((L-79)/3)

% RF = routine freq
% RL = routine level = 64 

% LAeq8760h = [10 * log(D/100)] + 70, D = overall dose with 3dB exchange
% rate

% Noise levels: 
level.powertools = 98; 
level.machines = 97; 
level.sporting = 94; 
level.vehicles = 94; 
level.aircraft = 91; 
%level.instrument = 87; 
level.musicearphone = 76; 
level.musicspeaker = 78; 
level.noisyjob = 90; 
level.routine = 64; 

% powertools, machine, sporting, veh, aircraft, shoot, fireworks,
% instrument, listening to music earphones, speakers, dancing at 
levels = [94; 97; 94; 98; 91; 76; 78; 64]; 
ref_dur = [109; 137; 274; 274; 548; 17520; 11037; 274; 690; 280320]; 
subj_dur(1,1) = get_SpY(noise.Q7{1,1}) .* get_HpS(noise.Q7_1{1,1});
subj_dur(2,1) = get_SpY(noise.Q8{1,1}) .* get_HpS(noise.Q8_1{1,1});
subj_dur(3,1) = get_SpY(noise.Q9{1,1}) .* get_HpS(noise.Q9_1{1,1});
subj_dur(4,1) = get_SpY(noise.Q10{1,1}) .* get_HpS(noise.Q10_1{1,1});
subj_dur(5,1) = get_SpY(noise.Q11{1,1}) .* get_HpS(noise.Q11_1{1,1});
%subj_dur(6,1) = get_SpY(noise.Q14{1,1}) .* 1; %get_HpS(noise.Q14_1{1,1}); %missing 
subj_dur(6,1) = get_SpY(noise.Q15{1,1}) .* get_HpS(noise.Q15_1{1,1});
subj_dur(7,1) = get_SpY(noise.Q16{1,1}) .* get_HpS(noise.Q16_1{1,1});
subj_dur(8,1) = get_SpY(noise.Q17{1,1}) .* get_HpS(noise.Q17_1{1,1}); 
if strcmp('Yes', noise.Q20{1,1})
    subj_dur(9,1) = noise.Q20_2_1_TEXT * 50; 
else
    subj_dur(9,1) = NaN; 
end
subj_dur(10,1) = 8760 - sum(subj_dur(1:9,1), "omitnan"); 

dose = subj_dur ./ref_dur; 
overall_AE = sum(dose, "omitnan") .* 100; 

noise_out = 3*log2(overall_AE/100) + 79; 
% Past 12 months

% Section 1: 
% Q1 to Q6 
% 
% if strcmp(Q7.1, 'Less than 1 hour')
%     hrs_perSession = 1; 
% elseif strcmp(Q7.1, '1 hour up to 4 hours')
%     hrs_perSession = 3; 
% elseif strcmp(Q7.1, '4 to 8 hours')
%     hrs_perSession = 6; 
% elseif strcmp(Q7.1, '8 hours or more')
%     hrs_perSession = 8; 
% else
%     hrs_perSession = nan; 
% end
% 
% 
% % Impulse Noise
% Qs_impulse = {"Q12", "Q13"}
% if strcmp(Q7, 'Every few months')
%     sessions_perYear = 1; 
% elseif strcmp(Q7, 'Monthly')
%     sessions_perYear = 12; 
% elseif strcmp(Q7, 'Weekly')
%     sessions_perYear = 50; 
% elseif strcmp(Q7, 'Daily')
%     sessions_perYear = 200; 
% else
%     sessions_perYear = NaN; 
% end
% 
% shots_perSession = Q12; 
% shots_perYear = sessions_perYear .* shots_perSession; 
% 
% % Occupational Noise 
% if job == summer
%     weeks_perYear = 10; 
% else 
%     weeks_perYear = 40; 
% end
% hours_perWeek_summer = Q17 
% hours_perWeek_FT = Q17 










end