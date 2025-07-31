function cleaned_threshold_matrix = cleanAudio(threshold_matrix)

% A = [ ...
%     250	5	NaN;
%     500	5	NaN;
%     500 15   25;
%     1000	5	NaN;
%     2000	0	NaN;
%     3000	-5	NaN;
%     4000	0	NaN;
%     4000    15  25;
%     6000	5	NaN;
%     8000	0	NaN;
%     10000	5	NaN;
%     11200	5	NaN;
%     12500	5	NaN;
%     14000	10	NaN;
%     16000	15	NaN ];
% 
% newRow = [250, 10, 5];  % The row to insert

% Find duplicates in column 1
[uniqueVals, ~, ic] = unique(threshold_matrix(:,1));
dupCounts = histc(threshold_matrix(:,1), uniqueVals);
dupVals = uniqueVals(dupCounts > 1);

rows_to_delete = [];

for i = 1:length(dupVals)
    val = dupVals(i);
    idx = find(threshold_matrix(:,1) == val);
    
    % Check third column values
    col3 = threshold_matrix(idx,3);
    
    % If one is a number and one is NaN, delete the NaN row
    if sum(~isnan(col3)) >= 1 && sum(isnan(col3)) >= 1
        rows_to_delete = [rows_to_delete; idx(isnan(col3))];
    end
end

% Delete rows
threshold_matrix(rows_to_delete,:) = [];
cleaned_threshold_matrix = threshold_matrix; 

% Show cleaned matrix
disp("Matrix has been cleaned");

end
