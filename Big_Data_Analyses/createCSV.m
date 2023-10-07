%Created By: Andrew Sivaprakasam
%Last Updated: October 2023
%Description: Compile all measures into a CSV (one for Left, one for Right)
%for statistical analysis in R

cwd = pwd();
%% Directory setup

data_dir = '~/Documents/dataTemp/All_ARDC';
output_dir = [data_dir,'/CSV_for_R'];

%%  
cd(data_dir);
filenames = dir('*.mat');
filenames = {filenames.name};

%TODO how to handle WBT??
ac_freqs = [250,500,1e3,2e3,3e3,4e3,6e3,8e3,10e3,11.2e3,12.5e3,14e3,16e3];
bc_freqs = [250,500,1e3,2e3,3e3,4e3];
dpoae_f2 = [1000,2344,3750,4781,6000,8000];
reflex_freqs = [500 1000 2000 4000];


headers = ["ID","Researcher","Time","Age",strcat("AC_",string(ac_freqs)),...
    strcat("BC_",string(bc_freqs)),strcat("DPF2_",string(dpoae_f2)),...
    strcat("REFLEX_IPS_",string(reflex_freqs)),strcat("REFLEX_CONTR_",string(reflex_freqs))];

%TODO sort by date or ARDC ID...can do this in R too 

%%

%could be more efficient
for i = 1:length(filenames)
    id = visit.subjectID;
    res = visit.researcher;
    tim = visit.time;
    
    %check for correct audiogram frequencies
    [~, inds]= intersect(visit.Audiogram.AC.R(:,1),ac_freqs)
    ac_r = visit.Audiogram.AC.R(inds,2)';

    [~, inds]= intersect(visit.Audiogram.AC.L(:,1),ac_freqs);
    ac_l = visit.Audiogram.AC.L(inds,2)';

    [~, inds]= intersect(visit.Audiogram.BC.L(:,1),bc_freqs);
    bc_l = visit.Audiogram.BC.L(inds,2)';

    [~, inds]= intersect(visit.Audiogram.BC.R(:,1),bc_freqs);
    bc_R = visit.Audiogram.BC.R(inds,2)';
%     ac_r = 
%     bc_r = 
%     ac_l = 
%     bc_l = 
end



%%
cd(cwd);