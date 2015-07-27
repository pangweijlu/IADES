function [ Dis ] = GetMinPrefixSets( S, r )
%gETmINpREFIXsETS generates sets of r-chunk detectors for set S using
%   Construct-Minimal-Prefix-Patterns algorithm 
%   S - self-set with strings stored as rows 
%   r - parameter of r-chunk detection
%   D - a cell array that contains sets of r-chunk patterns (Di)
% (c) Andriy Kharechko, University of Aberdeen, 02/12/2014

    [num, L] = size(S);
    if ~islogical(S)   % error?
        disp('ChunkPattern: converting data matrix to the binary format ...');
        S = logical(S);
    end
    % try to sort S
    
    if nargin < 2
        r = L;
    else if r > L
            disp('GetMinPrefixSets: the chunk size is greater than the string length!');
            disp(sprintf('GetMinPrefixSets: the chunk size is reset from %d to the string length %d.', r, L));
            r = L;
        end
    end
    
    Dis = cell(L - r + 1, 1);   % contains sets Di as cell arrays
    % D = cell(0, 0);
    sz_D = 0;
    
    for i = 1:(L - r + 1)
        Si = S(:, i:(i + r - 1)); 
        % PI = MinPrefix(Si);
        Dis{i} = MinPrefix(Si);
        % Dis{i} = cell(length(PI));
        % for j = 1:length(PI)
            % sz_D = sz_D + 1;S
            % D{sz_D, 1} = PI{j};
            % D{sz_D, 2} = i;
         % end
    end
    
end

