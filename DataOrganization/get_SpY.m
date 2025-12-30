function sessions_perYear = get_SpY(response)

%% Get sessions per year
%  this script will convert the written response from the survey data to
%  the approximate number of sessions the person completed per year. This is for the noise exposure survey.

if strcmp(response, 'Every few months')
    sessions_perYear = 1;
elseif strcmp(response, 'Monthly')
    sessions_perYear = 12;
elseif strcmp(response, 'Weekly')
    sessions_perYear = 50;
elseif strcmp(response, 'Daily')
    sessions_perYear = 200;
else
    sessions_perYear = NaN;
end

end