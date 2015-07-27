function [D] = MinPrefix(S)
%mINpREFIX implements Construct-Minimal-Prefix-Patterns Algorithm
%   S - a set of strings stored as rows
%   D - cell array which contains the smallest set of prefix patterns that
%       describe exactly the strings in the closure of S
% (c) Andriy Kharechko, University of Aberdeen, 13/11/2014


    [num, r] = size(S);
    % insert check if S is binary
    if ~islogical(S)   % error?
        disp('MinPrefix: converting data matrix to the binary format ...');
        S = logical(S);
    end
    % try to sort S
    
    % D = cell(0, 0);
    D = cell(0); % , 0);
    sz_D = 0;
    for j = 1:num
        pi = ~S(j, 1);
        if ~isprefix(pi, S)
            if ~isincell(pi, D)
                sz_D = sz_D + 1;
                D{sz_D} = pi;
            end
        end
            
        
        for i = 2:r
            pi = [S(j, 1:(i - 1)), ~S(j, i)];
            if ~isprefix(pi, S)
                if ~isincell(pi, D)
                    sz_D = sz_D + 1;
                    D{sz_D} = pi;
                end
            end
        end
        
    end

end

