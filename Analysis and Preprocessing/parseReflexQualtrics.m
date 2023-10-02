function [researcher,datetime,Probe_R_Ipsi,Probe_R_Contr,Probe_L_Ipsi,Probe_L_Contr] = parseReflexQualtrics(dataCSV, visitID)
   scors = strfind(visitID,'_');
   subjectID = visitID(1:scors(1)-1);
   dtimeID = visitID(scors(1)+1:scors(1)+8);
   
   %This could be loaded earlier in compile_visit in order to save time
   csv_string = readmatrix(dataCSV, 'OutputType', 'string');
   
   %CNT/NR must be differentiated. Allow researcher to handle accordingly.
   %Some may choose NaN for both, some may choose to drop freqs that are
   %CNT from analysis. Our job is to get the data out as openly/cleanly as
   %possible. Easy to convert to double. 
   
%    csv_double = readmatrix(dataCSV, 'OutputType', 'double');
   
    csv_dt = readmatrix(dataCSV, 'OutputType', 'datetime');    
   
   for visit_row = 1:size(csv_string,1)
       csv_subj_ID = csv_string(visit_row,18);
       csv_dtime = csv_dt(visit_row,8);
       csv_dtime.Format = 'MMddyyyy';
       dt_ID = char(csv_dtime);
       dt_ID = erase(dt_ID,'-');
       dt_ID = dt_ID(1:8);

       if(strcmp(string(subjectID),csv_subj_ID)&&strcmp(dt_ID,dtimeID))
            disp('Reflex Match Found in Qualtrics');
            researcher = csv_string(visit_row,19);
            datetime = csv_dt(visit_row,1);
            Probe_R_Ipsi = csv_string(visit_row,20:23);
            Probe_R_Contr = csv_string(visit_row,24:27);
            Probe_L_Ipsi = csv_string(visit_row,28:31);
            Probe_L_Contr = csv_string(visit_row,32:35);

       end

   end    
   
end

