% function [out_code] = SEPAwriteZRXPSEND(levels, date_srl, time_hh, ...
    % time_mm, fname)
function [out_code] = SEPAwriteZRXPSEND(st_names, st_lvls, st_date, ...
    st_time_hh, st_time_mm, fname)
% tst_labels, fname)  
% SEPA123TESTLABELS function for ...
%     explanation
% WeisdaleMi.SG.ir.O

% parsing input parameters
 
 out_code = 0;   % successful exit 
 if (nargin < 5) % || (length(tst_labels) < 1)
     disp('Not enough data received. Terminated.\n');
     out_code = -1;
     return;
 end
 
 if nargin < 6
     fname = 'sepa123xl.log';
 end

 fid = fopen(fname, 'w');
 
 if fid < 0
     fprintf('Cannot open file %s. Terminated.\n', fname);
     out_code = -1;
     return;
 end
 
 
 
 % for ii = 1:length(tst_labels)
 for ii = 1:length(st_names) 
     dot_pos = strfind(st_names{ii}, '.');
     st_loc = '';
     if ~isempty(dot_pos) && (dot_pos(1) > 1)
         st_loc = st_names{ii}(1:(dot_pos(1) - 1));
     end
         
     fprintf(fid, '## Exported ZRXP Block for %s\n', st_names{ii});
     fprintf(fid, '##TSNAME%s;*', st_names{ii});
     fprintf(fid, '#ZRXPVERSION2206.235;*;ZRXPCREATORZEXP3.9.5;*;\n');
     fprintf(fid, '#ZRXPMODEextended;*;\n');
     fprintf(fid, '#CUNITm;*;\n');
     fprintf(fid, '#SNAME%s;*;SANR116008;*;SWATER%s;*;CNR3033705;*;\n', ...
         st_loc, st_loc);
     fprintf(fid, '#CNAMESG;*;CMW86400;*;CTYPEn-min-ip;*;\n');
     fprintf(fid, '#RTYPEMomentanwerte;*;RTIMELVLHochaufloesend;*;RORPRoriginal;*;CNTYPE1;*;\n');
     fprintf(fid, '##DAYSTART0000\n');
     fprintf(fid, '#REXCHANGE%s;*;\n', st_names{ii});
     fprintf(fid, '#RSTATEW6;*\n');

        if ~isempty(tst_labels{ii})
         for j = 1:length(tst_labels{ii})
             % fid
             fprintf(fid, '%d\n', tst_labels{ii}(j));
             out_code = out_code + 1;
         end
     end
 end
     
 fclose(fid);
end

% function [ output_args ] = Untitled7( input_args )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here


% end

