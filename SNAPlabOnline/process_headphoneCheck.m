%% Headphone Check Data Parser and Analyzer
% This script parses JSON data and analyzes headphone check results
% Code initially from Joshua Alexander. Converted to Matlab by Sam Hauser
% 12/2025.

%% Part 1: Parse JSON and create individual subject CSVs

% Set directories
current_dir = pwd; % where Analysis code is
data_load_dir = 'C:\Users\saman\Desktop\SLO\raw_data\'; %Location where the json file is
data_save_dir = 'C:\Users\saman\Desktop\SLO\processed_data\'; %Location where the output of the data should go
group_data_dir = 'C:\Users\saman\Desktop\SLO\group_data\'; %Location where the summary data will go

% Load the JSON file
json_path = fullfile(data_load_dir, 'ardcheadphonecheck_ardc_results_Apr25_2025.json');
fid = fopen(json_path, 'r', 'n', 'UTF-8');
raw_json = fread(fid, inf, 'uint8=>char')';
fclose(fid);
all_subjects_data = jsondecode(raw_json);

% Output folders
headphone_dir = fullfile(data_save_dir, 'Headphone_data');
if ~exist(headphone_dir, 'dir')
    mkdir(headphone_dir);
end

% Loop through each subject's trials
for s = 1:length(all_subjects_data)
    subject_trials = all_subjects_data(s);
    subject_name = [];
    trials = struct([]);
    count = 0;
    
    % Access trials (handle both struct array and cell array)
    if isstruct(subject_trials)
        trials = subject_trials;
    else
        trials = subject_trials{1};
    end
    
    for t = 1:length(trials)
        trial = trials(t);
        trial = trial{1,1};
        
        % Check if this is an audio response trial
        if isfield(trial, 'trial_type') && strcmp(trial.trial_type, 'hari-audio-button-response')
            if isfield(trial, 'subject')
                subject_name = trial.subject;
            end
            
            % Parse annot to identify trial type
            condname = [];
            info = [];
            
            if isfield(trial, 'annot') && ~isempty(trial.annot)
                try
                    % Try to parse the annot field
                    annot_str = strrep(trial.annot, '''', '"');
                    annot_data = jsondecode(annot_str);
                    if isfield(annot_data, 'condname')
                        condname = annot_data.condname;
                    end
                    if isfield(annot_data, 'info')
                        info = annot_data.info;
                    end
                catch
                    % Skip if parsing fails
                end
            end
            
            % Save Woods et al., 2017 trials  abd BMLD trials (headphone check)
            if ~isempty(condname) && strcmp(condname, 'Woods et al., 2017') || strcmp(condname, 'BMLDhard')
                count = count + 1;
                
                response(count).trialnum = getFieldOrEmpty(trial, 'trialnum');
                response(count).stimulus = getFieldOrEmpty(trial, 'stimulus');
                response(count).rt = getFieldOrEmpty(trial, 'rt');
                response(count).correct = getFieldOrEmpty(trial, 'correct');
                response(count).button_pressed = getFieldOrEmpty(trial, 'button_pressed');
                response(count).cond = getFieldOrEmpty(trial, 'cond');
                response(count).condname = condname;
                response(count).info = info;
            end
           
        end
    end
    
    % Clean subject name for filename
    if ~isempty(subject_name)
        safe_subject = regexprep(subject_name, '[^\w\-]', '_');
        
        % Save Woods trials to CSV
        if ~isempty(response)
            out_path = fullfile(headphone_dir, [safe_subject '_headphonecheck.csv']);
            T = struct2table(response);
            writetable(T, out_path);
        end

    end
end

fprintf('✅ All headphone check subject CSVs saved to: %s\n', headphone_dir);

%% Part 2: Analyze headphone check results

headphone_output_file = fullfile(group_data_dir, 'Headphone_check_results.csv');

% Get list of headphone check files
files = dir(fullfile(headphone_dir, '*_headphonecheck.csv'));

% Initialize results cell array
col_names
% Process each subject's headphone check file
for f = 1:length(files)
    file = files(f).name;
    
    % Extract subject ID
    subject_id = regexprep(file, '_headphonecheck\.csv$', '');
    
    % Read the CSV file
    data = readtable(fullfile(headphone_dir, file));
    
    conds  = unique(data.condname);
    % loop for both headphone check tests
    for t = 1:numel(conds)

    % Get correct responses
    condname = conds{t};
    correct_list = data.correct(strcmp(data.condname,condname));
    num_correct = sum(correct_list);
    
    % Determine outcome (pass if >= 5 correct)
    if num_correct >= 5
        outcome = 'pass';
    else
        outcome = 'fail';
    end
    
    % Build result row
    result_row = {subject_id, condname, num_correct, outcome};
    
    headphone_results = [headphone_results; result_row];

    end
end

% Create output table for headphone check
column_names = {'subject', 'condname', 'num_correct', 'outcome'};
headphone_table = cell2table(headphone_results, 'VariableNames', column_names);

% Save headphone check results to CSV
writetable(headphone_table, headphone_output_file);
fprintf('✅ Headphone check results saved to: %s\n', headphone_output_file);

