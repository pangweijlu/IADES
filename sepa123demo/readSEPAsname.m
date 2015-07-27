function [st_Data, st_Names] = readSEPAsname(fname)
%READsepa reads a file 'fname' in the ZRXP format and outputs  a cell array
%   which contains arrays of river levels for each observation station
% (c) Andriy Kharechko, University of Aberdeen, 06/11/2014
    
    st_Data = [];
    st_Names = [];
    
    % opening the file 
    if nargin < 1
        fname = 'Data.ZRXPSEND.398761362579297';
    end
    fid = fopen(fname);
    if (fid < 0)
        % disp(sprintf('Cannot open file %s!', fname));
        fprintf('Cannot open file %s!', fname);
        return;
    else
        disp(sprintf('File %s opened correctly.', fname));
    end
    
    % by-passing the header - PREPARE
    % reading the first station data
    tline = fgetl(fid);
    
    st_No = 0;
    count = 0;
    
    date_srl = [];
    time_hh = [];
    time_mm = [];   
    time_ss = [];
    
    levels = [];   % ?
    snm = '';   % ?
    
    st_Data = cell(0);
    while ischar(tline)
        if (tline(1) ~= '#')
            if count < 1
                % disp('Header block is by-passed.');
            end
            
            count = count + 1;
            tmpstr = strsplit(tline);
            
            % check if the line cotains at least three values
            if (length(tmpstr{1}) ~= 14)
                error('Wrong date and time format!');
            else
                time_hh(count) = str2num(tmpstr{1}(9:10));
                time_mm(count) = str2num(tmpstr{1}(11:12));
                time_ss(count) = str2num(tmpstr{1}(13:14));
                date_srl(count) = datenum(sprintf('%s-%s-%s', ...
                    tmpstr{1}(1:4), tmpstr{1}(5:6), tmpstr{1}(7:8)), ...
                    'yyyy-mm-dd');
            end
        
            levels(count) = str2num(tmpstr{2});
        else
            if (count > 0)
                st_No = st_No + 1;
                st_Data{st_No} = levels;
                st_Names{st_No} = snm;
                disp(sprintf('Data input for station %d (%s) is over.', st_No, snm));
                disp(sprintf('Total observations: %d.', count));
                
                count = 0;
                levels = [];
                snm = '';
                date_srl = [];
                time_hh = [];
                time_mm = [];   
                time_ss = [];
                
            else
                snm_pos = strfind(tline, 'TSNAME');
                % st_No = st_No + 1;
                % st_Names{st_No + 1} = levels;
                if length(snm_pos) > 0
                    snm_i = 6;
                    while(((snm_pos + snm_i) <= length(tline)) ...
                            && (tline(snm_pos + snm_i) ~= ';'))
                        snm_i = snm_i + 1;
                    end
                    snm_i = snm_i - 1;
                    if ((snm_pos + snm_i) <= length(tline))
                        snm = tline((snm_pos + 6):(snm_pos + snm_i));
                    end
                end
            end
           
        end
        
        tline = fgetl(fid);
    end
    
    if (count > 0)
        st_No = st_No + 1;
        st_Data{st_No} = levels;
        st_Names{st_No} = snm;
        fprintf('Data input for station %d (%s) is over.\n', st_No, snm);
        fprintf('Total observations: %d.\n', count);
    end
    
    fprintf('Data in put from file %s is completed.\n', fname);
    fprintf('In total, observations from %d stations were read.\n', st_No);
    fclose(fid);
end