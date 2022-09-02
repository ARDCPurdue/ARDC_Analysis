function [AC_R, BC_R, AC_L, BC_L, QS_R, QS_L] = parseAudiogram(filename, Data_Dir)
%Description: Text parser for AC/BC Thresholds and QuickSIN
% from custom Audiostar Output template.
%Consider the fact that some subjects may have additional frequencies
%tested. This will return [NaN, NaN] for any test that was not
%collected.
%AC_R, BC_R, AC_L, BC_L are all Nx3 matrices with Freq in column 1, threshold in col 2, and masking in col 3:
%
%  [AC_R, BC_R, AC_L, BC_L] = parseAudiogram(filename, Data_Dir)
%
%Author: Andrew Sivaprakasam
%Email: asivapr@purdue.edu

dir = cd;
cd(Data_Dir);

txt = extractFileText(filename);
txt = char(txt);

try 
    s = strfind(txt,'Group 1 (dBHL)');
    QS_L = textscan(txt(s(1)+14:s(2)),'%f');
    QS_L = double(QS_L{1});
    QS_R = textscan(txt(s(2)+14:s(3)),'%f');
    QS_R = double(QS_R{1});

catch
    disp('No QuickSIN data found');
    QS_R = NaN;
    QS_L = NaN;
end

k = strfind(txt, 'EM Aided');


%Very Un-elegant lol.
BC_R_str = txt((k(1)+11):(k(2)-35));
AC_R_str = txt(k(2)+11:k(3)-35);
AC_L_str = txt(k(3)+11:k(4)-35);
BC_L_str = txt(k(4)+11:end);

%Convert to cell arrays:
%I added some corrections so that if only partial data is collected (i.e.
%one side, data can still be processed...but will return NaN for
%everything not processed.

if ~isempty(AC_R_str)
    AC_R = readAUDTable(AC_R_str);
else 
    AC_R = [NaN, NaN, NaN];
end

if ~isempty(BC_R_str)
    BC_R = readAUDTable(BC_R_str);
else 
    BC_R = [NaN, NaN, NaN];
end

if ~isempty(AC_L_str)
    AC_L = readAUDTable(AC_L_str);
else 
    AC_L = [NaN, NaN, NaN];
end

if ~isempty(BC_L_str)
    BC_L = readAUDTable(BC_L_str);
else 
    BC_L = [NaN, NaN, NaN];
end

cd(dir);

end

