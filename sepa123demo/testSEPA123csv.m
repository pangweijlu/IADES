function [tst_self] = testSEPA123csv(tst_data, tst_names, tr1_data, ...
    tr1_names, tr2_data, tr2_names, tr3_data, tr3_names)
% function [tst_self] = crossValidationSEPA123(tst_data, tst_names, tr1_data, ...
    % tr1_names, tr2_data, tr2_names)

    if nargin < 4
        error('testSEPA123csv: not enough parameters!');
        % fname = 'Data.ZRXPSEND.398761362579297';
    end
    
    n_symb = 8;   % number of symbols in a SAX approximation
    alpha_sz = 4;   % size of the alphabet
    
    wind_sz = 96;   % size of the sliding window - 24 hours
    symb_len = ceil(log2(alpha_sz));
    
     tst_self = cell(1, 1);
     for ii = 1:length(tst_names)
         if (length(tst_data{ii}) < wind_sz)
             % fprintf('No. %d: not enought data from station %s in the test set.\n', ...
                 % ii, tst_names{ii});
             fprintf('No. %d: there are only %d measurements from station %s in the test set.\n', ...
                 ii, length(tst_data{ii}), tst_names{ii});
             tst_self{ii} = [];
             continue;
         else 
              fprintf('No. %d: test set for station %s contains %d observations.\n', ...
                  ii, tst_names{ii}, length(tst_data{ii}));
         end
         fprintf('No. %d: generating training set for station %s ... \n', ...
             ii, tst_names{ii});
         ts_bin = [];   % binary representation of SAX approximations
         % move ts_bin here and ts_length and init to zero 
         
         % forming the training set
         ts_index = find(strcmp(tr1_names, tst_names{ii}), 1);
         if isempty(ts_index)
             fprintf('No. %d: nothing from station %s in set 1\n', ...
                 ii, tst_names{ii});
         else
             fprintf('No. %d: training set 1 for station %s contains %d observations.\n', ...
                  ii, tst_names{ii}, length(tr1_data{ts_index}));
             ts_bin = timeseries2binary(tr1_data{ts_index}, wind_sz, ...
                 n_symb, alpha_sz);
             % ts_bin = timeseries2saxbinary(tr1_data{ts_index}, wind_sz, ...
                 % n_symb, alpha_sz);   % MODIFICATION 1
         end
         
         if nargin >= 6
             ts_index = find(strcmp(tr2_names, tst_names{ii}), 1);
             if  (isempty(ts_index) || (length(tr2_data{ts_index}) < wind_sz)) 
                 fprintf('No. %d: not enought data from station %s in set 2.\n', ...
                     ii, tst_names{ii});
                 if isempty(ts_index) % (length(tr2_data{ts_index}) < wind_sz)
                     fprintf('No. %d: there are no observations from station %s in set 2.\n', ...
                         ii, tst_names{ii});
                 else
                     fprintf('No. %d: there are only %d measurements from station %s in set 2.\n', ...
                         ii, length(tr2_data{ts_index}), tst_names{ii});
                 end
             else
                 fprintf('No. %d: training set 2 for station %s contains %d observations.\n', ...
                     ii, tst_names{ii}, length(tr2_data{ts_index}));
                 ts_bin((size(ts_bin, 1) + 1):(size(ts_bin, 1) + ...
                     length(tr2_data{ts_index}) + 1 - wind_sz), 1:(n_symb*symb_len)) = ...
                     timeseries2binary(tr2_data{ts_index}, wind_sz, n_symb, ...
                     alpha_sz);   % _debug
             end
         end
         
         if nargin >= 8
             ts_index = find(strcmp(tr3_names, tst_names{ii}), 1);
             if  (isempty(ts_index) || (length(tr3_data{ts_index}) < wind_sz)) 
                 fprintf('No. %d: not enought data from station %s in set 3.\n', ...
                     ii, tst_names{ii});
                 if isempty(ts_index) % (length(tr2_data{ts_index}) < wind_sz)
                     fprintf('No. %d: there are no observations from station %s in set 3.\n', ...
                         ii, tst_names{ii});
                 else
                     fprintf('No. %d: there are only %d measurements from station %s in set 3.\n', ...
                         ii, length(tr3_data{ts_index}), tst_names{ii});
                 end
             else
                 fprintf('No. %d: training set 3 for station %s contains %d observations.\n', ...
                     ii, tst_names{ii}, length(tr3_data{ts_index}));
                 ts_bin((size(ts_bin, 1) + 1):(size(ts_bin, 1) + ...
                     length(tr3_data{ts_index}) + 1 - wind_sz), 1:(n_symb*symb_len)) = ...
                     timeseries2binary(tr3_data{ts_index}, wind_sz, n_symb, ...
                     alpha_sz);   % _debug
             end
         end
         
         % training negative selestion
         D = [];
         if isempty(ts_bin)
             fprintf('No. %d: nothing from station %s to form the traing set \n', ...
                 ii, tst_names{ii});
             tst_self{ii} = [];   % false( , 1);
         else
             fprintf('No. %d: training the negative election for station %s ... \n', ...
                 ii, tst_names{ii});
             D = ChunkPatterns(ts_bin);
             tst_bin = timeseries2binary(tst_data{ii}, wind_sz, n_symb, ...
                 alpha_sz);
             tst_ns = EffChNegSelection(D, tst_bin);
             tst_self{ii} = tst_ns.*2 - ones(length(tst_ns), 1);   % mapping
         end
     end
       
end