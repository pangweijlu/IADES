% function [ts_alpha, ts_bin] = getSEPAstation(stData, stNames, station_name)
function [ts_bin, ts_alpha] = timeseries2saxbinary(ts_data, wind_sz, n_symb, ...
    alpha_sz, short_ts)
 % stNames, station_name)
 %converts time series data to a binary repesentation using SAX
 
    % length(tr1_data{i1}), n_symb, alpha_sz
    
    ts_bin = [];   % binary representation of SAX approximations
    ts_alpha = [];   % symbolic SAX approximations
    if (nargin < 1) || isempty(ts_data)
        return;
    end
    
    if nargin < 2
        wind_sz = 96;   % size of the sliding window - 24 hours x 4
    end
    
    if nargin < 3
        n_symb = 8;   % number of symbols in a SAX approximation
    end
    
    if nargin < 4
        alpha_sz = 4;   % size of the alphabet
    end
    
    if nargin < 5
        short_ts = 0;   % size of the alphabet
    end
        
    symb_len = ceil(log2(alpha_sz));   % length of a binary code of a symbol
    
    if length(ts_data) >= wind_sz
        ts_bin_length = length(ts_data) - wind_sz + 1;   % number of time series strings
        ts_alpha = cell(ts_bin_length, 1);
        ts_bin = false(ts_bin_length, n_symb*symb_len);
        
        % testing sliding window from SAX
        ts_alpha_saxsw = timeseries2symbol0sigma(ts_data, wind_sz, n_symb, ...
            alpha_sz);
        
        for j = 1:ts_bin_length 
            % ts_alpha{j} = timeseries2symbol(ts_data(j:(j + wind_sz - 1)), ... 
                % wind_sz, n_symb, alpha_sz);   % sliding window with the unit step
            ts_alpha{j} = timeseries2symbol_fixed(ts_data(j:(j + wind_sz - 1)), ... 
                wind_sz, n_symb, alpha_sz);   % sliding window with the unit step
            
            % testing
            if (sum(abs(ts_alpha_saxsw(j, :) - ts_alpha{j}))) > 0
                disp('SAX with sliding window returned something else!');
                pause;
            end
            
            for k = 1:n_symb   % converting to binary
                ts_bin(j, ((k - 1)*symb_len + 1):(k*symb_len)) = ...
                    logical(str2num(dec2bin(ts_alpha{j}(k) - 1)));
            end
        end
        
    else
        fprintf('Number of observations (%d) is less than window size (%d).\n', ...
            length(ts_data), wind_sz);
        
        if short_ts > 0
            disp('Compressing the whole time series to one string');   % CONSIDER OTHER OPTIONS
            
            ts_bin_length = 1;
            ts_alpha = cell(1, ts_bin_length);
            % ts_alpha{ts_bin_length} = timeseries2symbol(ts_data(:), ... 
                % length(ts_data), n_symb, alpha_sz);
            ts_alpha{ts_bin_length} = timeseries2symbol_fixed(ts_data(:), ... 
                length(ts_data), n_symb, alpha_sz);
        
            ts_bin = false(1, n_symb*symb_len);   % logical(dec2bin(ts_alpha{1})); 
            for k = 1:n_symb   % converting to binary
                ts_bin(1, ((k - 1)*symb_len + 1):(k*symb_len)) = ...
                    logical(str2num(dec2bin(ts_alpha{1}(k) - 1))); 
            end
        else
            disp('Cannot process!');   % CONSIDER OTHER OPTIONS
        end
        
    end
end