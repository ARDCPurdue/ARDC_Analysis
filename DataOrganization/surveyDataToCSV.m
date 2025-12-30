%% Get ARDC Survey Data from CSV
cwd = pwd; 
datadir = "D:\fromBox\Compiled"; %needs to be folder where your surveys are saved
cd(datadir)

initial = readtable("ARDC_initial.csv"); 
annoyance = readtable("ARDC_annoyance.csv"); 
main = readtable("ARDC_main.csv"); 
noise = readtable("ARDC_noise.csv"); 
cd(cwd)

% Gather questions from initial 
init_Qs = {'Q4', 'Q5', 'Q6', 'Q26', 'Q17_1', 'Q13', 'Q19_1'}; 
init_Qs_labels = {'SubjectID', 'DOB', 'Gender', 'NativeSpeaker', 'HL', 'RegularNoiseExp', 'FreqTinnitus'}; 
initial2 = initial(:,init_Qs); 
initial2.Properties.VariableNames = init_Qs_labels; 

% Gather questions from loudness/annoyance survey
annoy_Qs = 22:2:44; 
loud_Qs = 21:2:43; 
QoL_Qs = 45:54;
all_Qs = 21:54; 
subj_Q = table2array(annoyance(:,19)); 

avg_all = num2cell(table2array(annoyance(:,all_Qs))); 
avg_annoyance = num2cell(mean(table2array(annoyance(:,annoy_Qs)),2)); 
avg_loudness = num2cell(mean(table2array(annoyance(:,loud_Qs)),2)); 
avg_qol = num2cell(mean(table2array(annoyance(:,QoL_Qs)),2)); 

annoyance2 = array2table([subj_Q avg_all avg_annoyance  avg_loudness avg_qol]); 
annoyance2.Properties.VariableNames = {'SubjectID', ...
    'BarkingDog_Loudness', 'BarkingDog_Annoyance', ...
    'Dishes_Loudness', 'Dishes_Annoyance', ...
    'CarRadio_Loudness', 'CarRadio_Annoyance', ...
    'RoomRadio_Loudness', 'RoomRadio_Annoyance', ...
    'PhoneRing_Loudness', 'PhoneRing_Annoyance', ...
    'TV_Loudness', 'TV_Annoyance', ...
    'LawnMower_Loudness', 'LawnMower_Annoyance', ...
    'CarDoor_Loudness', 'CarDoor_Annoyance', ...
    'RestaurantTalk_Loudness', 'RestaurantTalk_Annoyance', ...
    'BabyCry_Loudness', 'BabyCry_Annoyance', ...
    'Chewing_Loudness', 'Chewing_Annoyance', ...
    'Sniffling_Loudness', 'Sniffling_Annoyance', ...
    'AvoidShopping', 'AvoidFriends', 'NoHobbies', ...
    'NoRestaurants', 'AvoidCrowds', 'FeelDepressed', ...
    'FeelAnxious', 'CantConcentrate', 'PoorQualityLife', ...
    'ReducedJobPerformance' 'AvgAnnoyance','AvgLoudness', 'AvgQOL'}; 

% Gather questions from main survey
main_Qs = {'Q80_1', 'Q5', 'Q9', 'Q13', 'Q18', 'Q20', 'Q48', 'Q49','Q96','Q97'}; 
ssq = {'Q67', 'Q68','Q69', 'Q71', 'Q72','Q73', 'Q74', 'Q75'}; 
ssq_speech_Qs = 94:2:102; 
ssq_spatial_Qs = 104:2:108; 

main2 = main(:,[main_Qs ssq]); 
main2.Properties.VariableNames = {'SubjectID', 'OccNE', 'RecNE', ...
    'TinnitusAfterNE', 'Distortion', 'SiNdifficulty'...
    'SoundsIrritating', 'SoundIrritDescription', 'Amplification', 'AmpDescription', ...
    'GroupInQ', 'OneWithBgnd', 'BusyRestaurant', ...
    'Echos', 'OneWithMany', 'MeetingLoc', 'TwoPeopleLoc', ...
    'DoorSlamLoc'}; 

avg_speech_ssq = num2cell(mean(table2array(main(:,ssq_speech_Qs)),2)); 
main2.("avg_SSQ_speech") = avg_speech_ssq;

avg_spatial_ssq = num2cell(mean(table2array(main(:,ssq_spatial_Qs)),2)); 
main2.("avg_SSQ_spatial") = avg_spatial_ssq;


% Convert some questions into 1/0 instead of text 
amp = table2array(main2(:,"Amplification")); 
amp_interested = zeros(size(amp)); 
amp_current = zeros(size(amp)); 
amp_previous = zeros(size(amp)); 
amp_CI = zeros(size(amp)); 
amp_satisfied = zeros(size(amp)); 

for i = 1:size(amp,1)
    if contains(amp(i,1), "Interested")
        amp_interested(i,1) = 1; 
    end
    
    if contains(amp(i,1), "Currently")
        amp_current(i,1) = 1; 
    end
    
    if contains(amp(i,1), "Previous")
        amp_previous(i,1) = 1; 
    end

    if contains(amp(i,1), "Cochlear")
        amp_CI(i,1) = 1; 
    end

    if contains(amp(i,1), "Satisfied")
        amp_satisfied(i,1) = 1; 
    end
end



% Gather questions from noise exposure survey
for i = 1:size(noise,1)
    noise_out(i) = calculateLAeq8760h(noise(i,:)); 
end

noise3 = noise(:, "Q72_1"); 
noise3.("L_Aeq8760h") = noise_out'; 
noise3.Properties.VariableNames = {'SubjectID', 'L_Aeq8760h'}; 

% Combine relevant survey questions into one. 
[~, i] = unique(main2(:,"SubjectID")); 
main3 = main2(i,:); 
[~,i] = unique(initial2(:,"SubjectID")); 
initial3 = initial2(i,:); 
[~,i] = unique(annoyance2(:,"SubjectID")); 
annoyance3 = annoyance2(i,:); 

survey = outerjoin(  main3, initial3, 'MergeKeys', 1, 'keys', 'SubjectID'); 
survey = outerjoin(annoyance3, survey, 'MergeKeys', 1, 'keys', 'SubjectID'); 
survey = outerjoin(noise3, survey, 'MergeKeys', 1, 'keys', 'SubjectID'); 

cd(datadir)
writetable(survey,'ARDC_surveys_combined.csv')
cd(cwd)




