function [out_code, new_labels] = SEPA123expandLabels(tst_labels, ...
    tst_data, tst_names, wind_sz)  
% SEPA123TESTLABELS function for ...
%     explanation

% parsing input parameters
out_code = 0;   % successful exit 
new_labels = [];

if (nargin < 2) || (length(tst_labels) ~= length(tst_data))
     disp('Collections of data and labels are of different size:');
     fprintf('%d sets of labels for %d sets of data!\n', ...
         length(tst_labels), length(tst_data));
     disp('Testing labels failed.');
     out_code = -1;
     return;
 end
 
 if (nargin < 3) || (length(tst_names) ~= length(tst_data))
     disp('Collections of data and names are of different size:');
     fprintf('%d sets of names for %d data sets.\n', ...
         length(tst_names), length(tst_data));
     disp('The names for the data sets will be ignored.');
     out_code = 1;
 end
 
 if (nargin < 4) 
     wind_sz = 1;
 elseif (wind_sz <= 0)
     fprint('Sliding window must have positive size (not %d).\n', wind_sz);
     out_code = -1;
     return;
     % wind_sz = 0;
 end
 
 new_labels = cell(1, 1);
     
 % testing labels    
 for ii = 1:length(tst_labels)
     if (nargin > 2) && (out_code < 1)
         st_name = sprintf(' (%s)', tst_names{ii});
     else
         st_name = '';
     end
     
     % num_total = length(tst_labels{ii});
     % if nargin > 1
         fprintf('#%d%s: %d observations.\n', ii, st_name, ...
             length(tst_data{ii}));
         num_total = length(tst_data{ii});
     % end
     
     if ~isempty(tst_labels{ii})
         num_slf = length(find(tst_labels{ii} > 0));
         num_nnslf = length(find(tst_labels{ii} < 0));
         num_unav = num_total - num_slf - num_nnslf;
         fprintf('#%d%s: %d self, %d non-self and %d unavailable.\n', ...
             ii, st_name, num_slf, num_nnslf, num_unav);
         %  if (nargin > 3) && (wind_sz > 1)
         if num_unav ~= (wind_sz - 1)
             new_labels = [];
             out_code = -1;
             return;
         else
             new_labels{ii} = zeros(1, num_total);
             new_labels{ii}(wind_sz:num_total) = tst_labels{ii}(:);
             fprintf('#%d%s: sliding window has size %d.\n', ...
                 ii, st_name, wind_sz);
         end
     else
         % fprintf('#%d%s: no labels are available - all are set to zero.\n', ii, st_name);
         fprintf('#%d%s: no labels are available.\n', ii, st_name);
         new_labels{ii} = zeros(1, num_total);
     end
     disp('-------------------------------------------------------------');
 end
 
end