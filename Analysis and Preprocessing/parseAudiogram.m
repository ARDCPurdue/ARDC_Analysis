function [AC_R, BC_R, AC_L, BC_L, QS_R, QS_L, Age, AC_transduc, BC_transduc, AC_maxOut, BC_maxOut] = parseAudiogram(filename, Data_Dir)
%Description: Text parser for AC/BC Thresholds and QuickSIN
% from custom Audiostar Output template.
%Consider the fact that some subjects may have additional frequencies
%tested. This will return [NaN, NaN] for any test that was not
%collected.
%AC_R, BC_R, AC_L, BC_L are all Nx3 matrices with Freq in column 1, threshold in col 2, and masking in col 3:
% QS_R, and QS_L are the reported QuickSIN SNRs
% Age is subject age (automatically determined by the 1/1/YYYY input in
% otoaccess which gets transferred to the PDF audiogram report.
%  [AC_R, BC_R, AC_L, BC_L, QS_R, QS_L, Age] = parseAudiogram(filename, Data_Dir)
%
%Author: Andrew Sivaprakasam
%Email: asivapr@purdue.edu

dir = cd;
cd(Data_Dir);

txt = extractFileText(filename);
txt = char(txt);

%NR Max Levels
maxOut = readmatrix('NR_limits.csv');

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

%get age from audiogram
a = strfind(txt, 'Age');
y = strfind(txt, 'years');
age_found = textscan(txt(a+3:y-1),' %d ');
Age = age_found{1};

%Find Transducers

%bad coding but should work for now. Need to get some reports with inserts
%& Supra-aural too...need the model number output in report

t1 = strfind(txt,'HTL Full');
t2 = strfind(txt,'Hz');
ac_found = txt(t1(2)+8:t2(3)-4);
AC_transduc = textscan(ac_found, '%s');
AC_transduc = char(AC_transduc{1});

%NEED TAG FOR SupraAural and Inserts!!!
%output the mapping at all freqs...since otherwise would need to have
%separate right and left variable. Should be easy to frequency match the
%values from AC_R and AC_L when needed.
switch AC_transduc
    %HF 
    case 'DD450'
        AC_maxOut = [maxOut(:,1),maxOut(:,3)];
    %FILL IN
    case 'sup'
        AC_maxOut = [maxOut(:,1),maxOut(:,4)];
    %FIll IN
    case 'ins'
        AC_maxOut = [maxOut(:,1),maxOut(:,2)];
    otherwise
        AC_maxOut = NaN;
end

%only have one BC transducer...so can hard code for now
BC_transduc = 'B81';
BC_maxOut = [maxOut(:,1),maxOut(:,5)];

k = strfind(txt, 'EM Aided');
z = strfind(txt,'Unaided'); %this is the end

%Very Un-elegant lol.
BC_R_str = txt((k(1)+11):(k(2)-35));
AC_R_str = txt(k(2)+11:k(3)-35);
AC_L_str = txt(k(3)+11:k(4)-35);
BC_L_str = txt(k(4)+11:z(end)+6);

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

