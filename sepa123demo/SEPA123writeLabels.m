function [out_code] = SEPA123writeLabels(tst_labels, fname)  
% SEPA123TESTLABELS function for ...
%     explanation

% parsing input parameters
 
 out_code = 0;   % successful exit 
 if (nargin < 1) || (length(tst_labels) < 1)
     disp('No labels received. Terminated.\n');
     out_code = -1;
     return;
 end
 
 if nargin < 2
     fname = 'sepa123xl.log';
 end

 fid = fopen(fname, 'w');
 
 if fid < 0
     fprintf('Cannot open file %s. Terminated.\n', fname);
     out_code = -1;
     return;
 end
 
 for ii = 1:length(tst_labels)
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

