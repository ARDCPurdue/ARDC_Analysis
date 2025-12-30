%% STM/ZaarACT Data Parser and Analyzer
% This script parses JSON data and analyzes STM results
% Code based on other measures. Created by SH 12/2025.

%% Part 1: Parse JSON and create individual subject CSVs

% Set directories
current_dir = pwd; % where Analysis code is
data_load_dir = 'C:\Users\saman\Desktop\SLO\raw_data\'; %Location where the json file is
data_save_dir = 'C:\Users\saman\Desktop\SLO\processed_data\'; %Location where the output of the data should go
group_data_dir = 'C:\Users\saman\Desktop\SLO\group_data\'; %Location where the summary data will go

% Load the JSON file
json_path = fullfile(data_load_dir, 'ardcSTM_ardc_results_Dec30_2025.json');
fid = fopen(json_path, 'r', 'n', 'UTF-8');
raw_json = fread(fid, inf, 'uint8=>char')';
fclose(fid);
all_subjects_data = jsondecode(raw_json);

% Output folders
stm_dir = fullfile(data_save_dir, 'STM_data');
if ~exist(stm_dir, 'dir')
    mkdir(stm_dir);
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


            if ~isempty(condname)
                count = count + 1;

                response(count).Subject = string(subject_name);
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
            out_path = fullfile(stm_dir, [safe_subject '_STM.csv']);
            T = struct2table(response);
            writetable(T, out_path);
        end

    end
end

fprintf('✅ All STM  subject CSVs saved to: %s\n', stm_dir);

%% Part 2: Analyze STM  results
% Analyzes STM data, fits logistic functions, and generates threshold estimates

% Set up directories
input_dir = fullfile(data_save_dir, 'STM_data');
plot_dir = fullfile(data_save_dir, 'STM_Plots');
if ~exist(plot_dir, 'dir')
    mkdir(plot_dir);
end

% Load all subject files
files = dir(fullfile(input_dir, '*_STM.csv'));
stm_results = {};

for f = 1:length(files)
    data = readtable(fullfile(input_dir, files(f).name));

    % Clean data
    data.correct = logical(data.correct);
    data.condname = string(data.condname);
    data.Subject = string(data.Subject);

    % Extract depth from condname
    depth_dB = zeros(height(data), 1);
    for i = 1:height(data)
        tokens = regexp(char(data.condname(i)), '(\d+(?:\.\d+)?)', 'tokens');
        if ~isempty(tokens)
            depth_dB(i) = -1.*str2double(tokens{1}{1});
        else
            depth_dB(i) = NaN;
        end
    end
    data.depth_dB = depth_dB;

    % Logistic function
    logistic = @(params, x) 1 ./ (1 + exp(-(params(1) + params(2) * x)));

    % Threshold criterion (d' = 2.0 for 6AFC)
    threshold_pc = 0.825;

    % Initialize results
    results(f).subject = data.Subject(1);

    % Calculate average by SNR
    depth_list = unique(data.depth_dB);
    avg_by_depth = [];

    for i = 1:length(depth_list)
        depth_val = depth_list(i);
        correct_vals = data.correct(data.depth_dB == depth_val);
        avg_correct = mean(correct_vals);
        avg_by_depth = [avg_by_depth; depth_val, avg_correct];
    end

    % Need at least 4 data points to fit
    if size(avg_by_depth, 1) >= 4
        x_vals = avg_by_depth(:, 1);
        y_vals = avg_by_depth(:, 2);

        try
            % Fit logistic function using nonlinear least squares
            initial_params = [0, .05];
            options = optimset('Display', 'off');
            params = lsqcurvefit(logistic, initial_params, x_vals, y_vals, ...
                [], [], options);

            a = params(1);
            b = params(2);

            % Calculate threshold SNR
            thresh = (log(threshold_pc / (1 - threshold_pc)) - a) / b;

            % Store basic results
            results(f).threshold = thresh;

            % Store raw % correct for each SNR
            for i = 1:size(avg_by_depth, 1)
                depth_val = round(avg_by_depth(i, 1));
                if depth_val < 0
                    depth_label = sprintf('depth_neg%ddB', abs(depth_val));
                else
                    depth_label = sprintf('depth_%ddB', depth_val);
                end
                results(f).(depth_label) = avg_by_depth(i, 2);
            end

            % Plotting
            x_fit = linspace(min(x_vals), max(x_vals), 200);
            y_fit = logistic(params, x_fit);

            figure('Visible', 'on');
            plot(x_fit, y_fit, 'b-', 'LineWidth', 2, 'DisplayName', 'Logistic Fit');
            hold on;
            scatter(x_vals, y_vals, 100, 'k', 'filled', 'DisplayName', 'Observed Data');
            yline(threshold_pc, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1, ...
                'HandleVisibility', 'off');
            xline(thresh, '--r', 'LineWidth', 1.5, ...
                'DisplayName', sprintf('Threshold = %.2f dB', thresh));

            title(sprintf('Psychometric Function: %s', char(data.Subject(1))));
            xlabel('Depth (dB)');
            ylabel('Proportion Correct');
            ylim([0, 1]);
            legend('Location', 'best');
            grid on;

            plot_path = fullfile(plot_dir, sprintf('%s_psychometric.png', char(data.Subject(1))));
            saveas(gcf, plot_path);
            close(gcf);

        catch
            % If fitting fails, store NaN
            results(f).subject = char(data.Subject(1));
            results(f).threshold = NaN;
        end
    else
        % Not enough data points
        results(f).subject = char(data.Subject(1));
        results(f).threshold = NaN;
    end

    % Build result row
    result_row = {results(f).subject, results(f).threshold, results(f).depth_neg24dB, ...
        results(f).depth_neg20dB, results(f).depth_neg16dB, results(f).depth_neg12dB, ...
        results(f).depth_neg8dB, results(f).depth_neg4dB, results(f).depth_0dB};

    stm_results = [stm_results; result_row];

end

% Reorder columns: subject, threshold, then sorted SNR columns
col_names = {'subject', 'threshold', 'pc_neg24dB', 'pc_neg20dB', 'pc_neg16dB', ...
    'pc_neg12dB', 'pc_neg8dB', 'pc_neg4dB', 'pc_0dB'};
stm_table = cell2table(stm_results, 'VariableNames',col_names);
% Save final output
output_path = fullfile(group_data_dir, 'STM_threshold_estimates.csv');
writetable(stm_table, output_path);

fprintf('✅ Threshold estimates with raw %% correct saved to: %s\n', output_path);
fprintf('✅ Psychometric plots saved to folder: %s\n', plot_dir);