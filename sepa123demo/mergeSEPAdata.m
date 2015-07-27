function [joint_time, joint_levels] = mergeSEPAdata(time1, levels1, ...
    time2, levels2)
%READsepaTIME reads a file 'fname' in the ZRXP format and outputs  a cell array
%   which contains arrays of river levels for each observation station
% (c) Andriy Kharechko, University of Aberdeen, 06/11/2014
    
 joint_time = [];
 joint_levels = [];
 
 if nargin ~= 4
     error('There must be four parameters!');
 end
 
 if (length(time1) ~= length(levels1)) || ...
         (length(time2) ~= length(levels2))
     error('Array with time and level vaues must be of the same size!');
 end
 
 if isempty(time1) 
     if isempty(time2)
         disp('No data is given.');
     else
         disp('Data set 1 is empty.');
         joint_time = time2;
         joint_levels = levels2;
     end
     return;
 else
     if isempty(time2)
         disp('Data set 1 is empty.');
         joint_time = time1;
         joint_levels = levels1;
         return;
     end
 end
 
 if time1(1) < time2(1)
     if time1(length(time1)) < time2(1)
         disp('Two time series do not overlap!')
         return;
     else   % time1(length(time1)) >= time2(1)
         if time2(length(time2)) <= time1(length(time1))
             t1t21 = find(time1 == time2(1), 1);
             t1t22 = find(time1 == time2(length(time2)), 1);
             if matchvec(time2, time1(t1t21:t1t22)) && ...
                     matchvec(levels2, levels1(t1t21:t1t22))
                 disp('Time series 1 contains time series 2.');
                 return;
             else
                 error('Time series 1 should contain time series 2')
             end
         else
             t1midi = find(time1 == time2(1), 1);
             over_pos = length(time1) - t1midi + 1;
             if matchvec(time2(1:(over_pos - 1)), time1(t1midi:length(time1))) ...
                     && matchvec(levels2(1:(over_pos - 1)), levels1(t1midi:length(time1)))
                 disp('Time series 1 contains time series 2.');
                 return;
             else
                 error('Time series 1 should contain time series 2')
             end
         end
     end
 end
 % opening the file 
 if nargin < 1
     fname = 'Data.ZRXPSEND.398761362579297';
 end
 fid = fopen(fname);
 if fid < 0
     fprintf('Cannot open file %s!', fname);
     return;
 else
     fprintf('File %s opened correctly.\n', fname);
 end
 
 % by-passing the header - PREPARE
 % reading the first station data
 