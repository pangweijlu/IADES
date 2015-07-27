function [ ts_sepa_bin ] = sepa2binary( rvr_lvls, n_symb, alpha_sz )
%SEPA2BINARY converts a set of SEPA observations to their binary string
%   representations 
%   rvr_lvls - a cell array which contains arrays of river levels recorded
%              at observation stations 
%   n_symb - number of symbols in string representation of a time series
%   alpha_sz - size of an alphabet for string representation
% (c) Andriy Kharechko, University of Aberdeen, 13/11/2014

    % parsing the input
    if nargin < 2
        n_symb = 8;
    end
    
    if nargin < 3
        alpha_sz = 4;
    end
    
    % getting SAX representations using SAX_2006_ver
    for i = 1:length(rvr_lvls)
        ts_sepa(i, :) = timeseries2symbol(rvr_lvls{i}, ...
            length(rvr_lvls{i}), n_symb, alpha_sz);
    end
    
    % size(ts_sepa);
    % ts_sepa(1, :);
    % pause;
    
    symb_len = ceil(log2(alpha_sz));
    % pause;
    ts_sepa_bin = false(length(rvr_lvls), n_symb*symb_len);
    
    for i = 1:length(rvr_lvls)
        for j = 1:n_symb
        % for j = 1:length(ts_sepa(i, :))   % n_symb
            % FIX THIS PART - CONVERT SYMBOLS ONE BY ONE !!!
            tmp_str = dec2bin(ts_sepa(i, j) - 1); % to start from '0', not '1'
            % size(tmp_str)
            % size(ts_sepa)
            % j*symb_len
            bin_str = zeros(1, symb_len);
            if length(tmp_str) < symb_len
                bin_str((symb_len - length(tmp_str) + 1):symb_len) = ...
                    str2num(tmp_str); % tmp_str;(:)
                % j
                % pause;
            else
                % length(bin_str)
                % str2num(tmp_str)
                bin_str = str2num(tmp_str);  % tmp_str;
            end
            
            % i
            
            ts_sepa_bin(i, ((j - 1)*symb_len + 1):(j*symb_len)) = ...
                logical(bin_str);  % (:)
                % logical(str2num(tmp_str(:)));
            % size(ts_sepa_bin)
            if mod(i, 400) == 0
                disp(sprintf('Binary encoding, for time series %d', i));
            end
        end
    end
    
end

