function [levels] = getStData(st_id, st_names, st_data)
% getStData function for ...
%     explanation

% parsing input parameters
 if nargin < 3
     error('Not enough parameters.');  
 end
 
 if ~iscell(st_data)
     error('River levels data must be stored in a cell array.');
 end
 
 if ~iscell(st_names)
     error('Station names must be stored in a cell array.');
 end
 
 if isempty(st_id) || isempty(st_names) || isempty(st_data)
     error('Input parameters must be must non-empty.');
 end
 
 if length(st_names) ~= length(st_data)
     error('Sizes of arrays with stations names and data must be the same.');
 end
 
% extracting data set
 st_index = find(strcmp(st_names, st_id));
 % levels = [];
 switch length(st_index)
     case 0
         fprintf('Nothing from station %s in given data set.\n', st_id);
         levels = [];
     case 1
         levels = st_data{st_index};
     otherwise
         fprintf('Multiple occurences of %s has been found:\n', st_id);
         disp('    data sets will be returned in cell array.');
         levels = cell(1, length(st_index));
         % j = 1:length(st_index);
         levels{:} = st_data{st_index(:)};
         % end
 end 