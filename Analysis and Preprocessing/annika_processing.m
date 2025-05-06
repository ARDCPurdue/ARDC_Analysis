
%ardcinitial = readtable("C:\Users\ARDC User\Desktop\ardc_initial"); 
load annika_data.mat
HL = ardcinitial.Q17_1; 

for i = 1:size(HL,1)
    if strcmp(HL(i,1), 'Yes, I or others suspect I have a hearing loss.')
        HL_num(i,1) = 1; 
    elseif strcmp(HL(i,1), 'Yes, I have a diagnosed hearing loss.')
        HL_num(i,1) = 2; 
    elseif strcmp(HL(i,1), 'No')
        HL_num(i,1) = 0; 
    else
        HL_num(i,1) = NaN; 
    end
end

for i = 1:length(ardcinitial.Q4)
    subj{i,1} = ardcinitial.Q4{i,1}; 
end

idx = nan(size(id_list));
for id_index = 1:length(id_list)
    test_id = id_list(id_index); 
    
    location = find(ismember(subj,test_id), 1, 'first');
    
    if location > 0
        idx(1, id_index) = location;
    end

end

count = 0; 
for y = 1:length(idx)
    if ~isnan(idx(y))
        count = count + 1; 
       result(count, 1) = HL_num(idx(y), 1); 
       right_audio = any(R_lvl_list(1:8, y) > 25); 
       left_audio = any(L_lvl_list(1:8, y) > 25); 
       result(count, 2) = right_audio + left_audio; 
    end
end

% think normal 
thinkNH_hasHL = result(result(:,1) == 0, 1) - result(result(:,1) == 0, 2); 
sum(thinkNH_hasHL < 0) / numel(thinkNH_hasHL)

% think HL 
thinkHL_hasHL = result(result(:,1) == 1, 1) - result(result(:,1) == 1, 2); 
sum(thinkHL_hasHL < 1) / numel(thinkHL_hasHL)

% diag HL, but normal
diagHL_NH = result(result(:,1) == 2, 1) - result(result(:,1) == 2, 2); 
sum(diagHL_NH > 1) / numel(diagHL_NH)

%save annika_data.mat



