%Text parser for AC/BC Thresholds from custom Audiostar Output template.
%Consider the fact that some subjects may have additional frequencies
%tested. This code will output:
% 
%Author: Andrew Sivaprakasam
%Email: asivapr@purdue.edu

txt = extractFileText('ARDC1_06032021_AUD.pdf');
k = strfind(txt, 'EM Aided');

txt = char(txt);

%Very Un-elegant lol.
BC_R_str = txt((k(1)+11):(k(2)-35));
AC_R_str = txt(k(2)+11:k(3)-35);
AC_L_str = txt(k(3)+11:k(4)-35);
BC_L_str = txt(k(4)+11:end);

%Convert to cell arrays:

AC_R = textscan(AC_R_str, '%d %d %s');
AC_R = cell2mat(AC_R(1:2));

BC_R = textscan(BC_R_str, '%d %d %s');
BC_R = cell2mat(BC_R(1:2));

AC_L = textscan(AC_L_str, '%d %d %s');
AC_L = cell2mat(AC_L(1:2));

BC_L = textscan(BC_L_str, '%d %d %s');
BC_L = cell2mat(BC_L(1:2));