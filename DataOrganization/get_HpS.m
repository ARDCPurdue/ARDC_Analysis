function hrs_perSession = get_HpS(response)

%%  Get hours per session
% This survey will calculate the approximate number of hours per session.
%  It is for the Noise Exposure Survey. This is based on subject responses.


if strcmp(response, 'Less than 1 hour')
    hrs_perSession = 1;
elseif strcmp(response, '1 hour up to 4 hours')
    hrs_perSession = 3;
elseif strcmp(response, '4 to 8 hours')
    hrs_perSession = 6;
elseif strcmp(response, '8 hours or more')
    hrs_perSession = 8;
else
    hrs_perSession = nan;
end
