function [AC_R, BC_R, AC_L, BC_L] = parseAudiogram(filename, Data_Dir)
%Description: Text parser for AC/BC Thresholds from custom Audiostar Output template.
%Consider the fact that some subjects may have additional frequencies
%tested. This will return [NaN, NaN] for any test that was not
%collected.
%AC_R, BC_R, AC_L, BC_L are all Nx2 matrices with Freq in column 1 and threshold in col 2:
%
%  [AC_R, BC_R, AC_L, BC_L] = parseAudiogram(filename, Data_Dir)
%
%Author: Andrew Sivaprakasam
%Email: asivapr@purdue.edu

dir = cd;
cd(Data_Dir);

txt = extractFileText(filename);
k = strfind(txt, 'EM Aided');

txt = char(txt);

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
    AC_R = textscan(AC_R_str, '%d %d %s');
    AC_R = cell2mat(AC_R(1:2));
else 
    AC_R = [NaN, NaN];
end

if ~isempty(BC_R_str)
    BC_R = textscan(BC_R_str, '%d %d %s');
    BC_R = cell2mat(BC_R(1:2));
else
    BC_R = [NaN, NaN]; 
end

if ~isempty(AC_L_str)
    AC_L = textscan(AC_L_str, '%d %d %s');
    AC_L = cell2mat(AC_L(1:2));
else 
    BC_R = [NaN, NaN]; 
end

if ~isempty(BC_L_str)
BC_L = textscan(BC_L_str, '%d %d %s');
BC_L = cell2mat(BC_L(1:2));
else
    BC_L = [NaN, NaN];
end 

cd(dir);

end

