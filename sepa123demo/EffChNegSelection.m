function [ self_list ] = EffChNegSelection( D, M )  % , det_pos
% eFFcHnEGsELECTION Implements the monitor phase of the the efficient chunk
%   D - a set of r-chunk patterns
%   M - a monitoring set with observation strings stored as rows 
%   self-list - a list of flags for the monitor set where '1' marks self
%               and '0' - non-self
% (c) Andriy Kharechko, University of Aberdeen, 13/11/2014

    if ~islogical(M)   % error ?
        disp('EffChNegSelection: converting data matrix to the binary format ...');
        M = logical(M);
    end
    
    [num_D, test_D] = size(D);
    % [num_M, len_M] = size(M);
    [num_M, ~] = size(M);
    
    if (test_D ~= 2)
        error('Unknown format of r-chunk detectors!');
    end
    % pause;
    
    % self_list = logical(ones(num_M, 1));
    self_list = true(num_M, 1);
    % sum(self_list)
    % det_pos = zeros(num_M, 1);
    
    for i = 1:num_M
        for j = 1:num_D
            p_len = length(D{j, 1});
            p_i = D{j, 2};
            % if ((p_i + p_len - 1) > len_M)   % out-of-bounds check
                % error('r-chunk detector %d is out of bounds: p_len = %d, p_i = %d, len = %d!', ...
                    % j, p_len, p_i, len_M);
            % end
            if M(i, p_i:(p_i + p_len - 1)) == D{j, 1}   % match
                self_list(i) = false;
                % det_pos(i) = j;
                break;
            end
        end
    end
            
end

