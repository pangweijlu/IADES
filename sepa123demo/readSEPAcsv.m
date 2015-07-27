function [levels, date_srl] = readSEPAcsv(fname)
% function [levels, date_srl, time_hh, time_mm] = readSEPAcsv(fname)
% function [st_Data] = readSEPAcsv(fname)
%READsepa reads a file 'fname' in the ZRXP format and outputs  a cell array
%   which contains arrays of river levels for each observation station
% (c) Andriy Kharechko, University of Aberdeen, 06/11/2014
    
 levels = [];
 date_srl = [];
 % time_hh = [];
 % time_mm = [];   
    
 % opening the file 
 if nargin < 1
     disperror('No file to read data from.');
 end
 fid = fopen(fname);
 if (fid < 0)
     fprintf('Cannot open file %s!', fname);
     return;
 else
     fprintf('File %s opened correctly.\n', fname);
 end
    
 % 
 tline = fgetl(fid);
 count = 0;
 tmplvl = [];
 
 while ischar(tline)
     count = count + 1;
     tmpstr = strsplit(tline);
     
     % check if the line cotains at least three values
     if (length(tmpstr) < 2) && (length(tmpstr{1}) ~= 10)
         error('Wrong date format!');
     else
         % fprintf('#%d: %s %s\n', count, tmpstr{1}, tmpstr{2});
         % date_srl(count) = datenum(sprintf('%s-%s-%s', tmpstr{1}(7:10), ...
             % tmpstr{1}(4:5), tmpstr{1}(1:2)), 'yyyy-mm-dd');
             
         tmlvl = strsplit(tmpstr{2}, ',');
         if (length(tmplvl) < 2) && (length(tmlvl{1}) ~= 5)
             error('Wrong time format!');
         else
             date_srl(count) = datenum(sprintf('%s-%s-%s %s:%s:00' , ...
                 tmpstr{1}(7:10), tmpstr{1}(4:5), tmpstr{1}(1:2), ...
                 tmlvl{1}(1:2), tmlvl{1}(4:5)), 'yyyy-mm-dd HH:MM:SS');
             % fprintf('#%d: %s %s\n', count, tmlvl{1}, tmlvl{2});
             % time_hh(count) = str2num(tmlvl{1}(1:2));
             % time_mm(count) = str2num(tmlvl{1}(4:5));
             % time_ss(count) = str2num(tmpstr{1}(13:14));
         end
     end
     
     levels(count) = str2num(tmlvl{2});
     tline = fgetl(fid);
 end
 
 fprintf('Data in put from file %s is completed.\n', fname);
 fprintf('Total observations have been read: %d.\n', count);
 fclose(fid);
end