function testNSsepa(st_name, tr_times, tr_levels, tst_times, ...
    tst_levels, lvl_low, lvl_high)

 addpath('sax\');   % added for this machine

 % initialisation
 % lvl_low = 0.27;
 % lvl_high = 1.48;
 epsN = 0.000001;
 sld_wnd_sz = 96;
 % st_name = 'WeisdaleMi.SG.ir.O';
 % diaryname = [st_name '.log'];
 % diary('weisdaleburn_demo.log');
 % diary(diaryname);

 % generating labels
 t = cputime;
 tst_data = cell(1, 1);
 tst_data{1} = tst_levels;
 tr_data = cell(1, 1);
 tr_data{1} = tr_levels;
 tst_names = cell(1, 1);
 tst_names{1} = st_name;
 tst_lbls = testSEPA123csv(tst_data, tst_names, tr_data, tst_names);
 [~, tst_full] = SEPA123expandLabels(tst_lbls, tst_data, tst_names, ...
     sld_wnd_sz);
 % fprintf('There are %g non-self out of total %g observations.\n', ...
 % sum(tst_lbls{1}), length(tst_lbls{1}));
 t_tst = cputime - t;
 fprintf('Negative selection for station %s took %g minutes of CPU time.\n', ...
     st_name, t_tst/60);
 disp('-------------------------------------------------------------');
 
 % pause;

% plotting flood data
disp('Plotting the flood data and labels ...');

tst_levels_n2 = zeros(1, length(tst_levels));
tst_n2_div = zeros(1, length(tst_levels));
for ii = 1:(length(tst_levels) - sld_wnd_sz + 1)
    if std(tst_levels(ii:(ii + sld_wnd_sz - 1))) > epsN
        tst_levels_n2(ii:(ii + sld_wnd_sz - 1)) = ...
            tst_levels_n2(ii:(ii + sld_wnd_sz - 1)) ...
            + (tst_levels(ii:(ii + sld_wnd_sz - 1)) ...
            - mean(tst_levels((ii:(ii + sld_wnd_sz - 1)))))...
            /std(tst_levels((ii:(ii + sld_wnd_sz - 1))));
    else
        tst_levels_n2(ii:(ii + sld_wnd_sz - 1)) = ...
            tst_levels_n2(ii:(ii + sld_wnd_sz - 1)) ...
            + (tst_levels(ii:(ii + sld_wnd_sz - 1)) ...
            - mean(tst_levels((ii:(ii + sld_wnd_sz - 1)))));
    end
    % size(tst_n2_div(ii:(ii + sld_wnd_sz - 1)))
    tst_n2_div(ii:(ii + sld_wnd_sz - 1)) = ...
        tst_n2_div(ii:(ii + sld_wnd_sz - 1)) + ones(1, sld_wnd_sz);
end
tst_levels_n2 = tst_levels_n2./tst_n2_div;
p = plot(tst_levels_n2);
set(p, 'Color', 'cyan', 'LineWidth', 2); % 4);
hold on 

p = plot(tst_levels);
% ts_tst = timeseries(tst_levels, datestr(tst_date_srl));  % timeseries class
% p = plot(ts_tst, 'Color', 'red', 'LineWidth', 4);
set(p, 'Color', 'red', 'LineWidth', 2); % 4);

hold on
% tst_levels_norm = (tst_levels - mean(tst_levels))/std(tst_levels);
% p = plot(tst_levels_norm);
% set(p, 'Color', 'green', 'LineWidth', 4);
bar(tst_full{1});
% plot(tst_full{1}, '*b');
% hold on
% plotting normalised time series
% for ii = 1:(length(tst_levels) - sld_wnd_sz + 1)
    % if std(tst_levels(ii:(ii + sld_wnd_sz - 1))) > epsN
        % tmp_ts = (tst_levels(ii:(ii + sld_wnd_sz - 1)) ...
            % - mean(tst_levels((ii:(ii + sld_wnd_sz - 1)))))...
            % /std(tst_levels((ii:(ii + sld_wnd_sz - 1))));
        
        % hold on 
        % p = plot(ii:(ii + sld_wnd_sz - 1), tmp_ts);
        % set(p, 'Color', 'black', 'LineWidth', 1);
        % pause;
    % end
% end 

% ts_tr_low = timeseries(lvl_low*ones(1, length(tr_date_srl)), ...
    % datestr(tr_date_srl));   % TS  lvl_low*ones(1, length(tr_date_srl))
% p = plot(ts_tr_low, ':b', 'LineWidth', 1);
p = plot(lvl_low*ones(1, length(tst_times)), ':b', 'LineWidth', 2);
hold on

% ts_tr_high = timeseries(lvl_high*ones(1, length(tr_date_srl)), ...
    % datestr(tr_date_srl));   % TS
% p = plot(ts_tr_high, ':r', 'LineWidth', 1);
p = plot(lvl_high*ones(1, length(tst_times)), ':r', 'LineWidth', 2);
hold on

% set(legend('label', 'actual', 'normalised', 'average', 'Location', 'Best'), ...
    % 'FontSize', 20);
set(legend('av. norm.', 'actual', 'label', 'low flow', 'high flow', ...
    'Location', 'Best'), 'FontSize', 20);
ylabel('Rivel Level (meters)', 'FontSize', 20);
xlabel('Observations', 'FontSize', 20);
% title('Weisdale Burn, 25-29/10/2014', 'FontSize', 24);
% title('Weisdale Burn', 'FontSize', 24);
gtitle = sprintf('%s, %s - %s', st_name, datestr(tst_times(1)), ...
     datestr(tst_times(length(tst_times))));
title(gtitle, 'FontSize', 24);
set(gca, 'FontSize', 18);
% pause;

% plotting dataset 1
disp('Plotting the training set and its labels ...');
figure;
% bar(tr_full{1});
% hold on
p = plot(tr_levels);
set(p, 'Color', 'red', 'LineWidth', 4);
% hold on
% tr_levels_norm = (tr_levels - mean(tr_levels))/std(tr_levels);
% p = plot(tr_levels_norm);
% set(p, 'Color', 'green', 'LineWidth', 4);

tr_levels_n2 = zeros(1, length(tr_levels));
tr_n2_div = zeros(1, length(tr_levels));
for ii = 1:(length(tr_levels) - sld_wnd_sz + 1)
    if std(tr_levels(ii:(ii + sld_wnd_sz - 1))) > epsN
        tr_levels_n2(ii:(ii + sld_wnd_sz - 1)) = ...
            tr_levels_n2(ii:(ii + sld_wnd_sz - 1)) ...
            + (tr_levels(ii:(ii + sld_wnd_sz - 1)) ...
            - mean(tr_levels((ii:(ii + sld_wnd_sz - 1)))))...
            /std(tr_levels((ii:(ii + sld_wnd_sz - 1))));
    else
        fprintf('Standard deviation is below threshold at %d: %d', ...
            ii, std(tr_levels(ii:(ii + sld_wnd_sz - 1))));
        tr_levels_n2(ii:(ii + sld_wnd_sz - 1)) = ...
            tr_levels_n2(ii:(ii + sld_wnd_sz - 1)) ...
            + (tr_levels(ii:(ii + sld_wnd_sz - 1)) ...
            - mean(tr_levels((ii:(ii + sld_wnd_sz - 1)))));
    end
    % size(tst_n2_div(ii:(ii + sld_wnd_sz - 1)))
    tr_n2_div(ii:(ii + sld_wnd_sz - 1)) = ...
        tr_n2_div(ii:(ii + sld_wnd_sz - 1)) + ones(1, sld_wnd_sz);
end
tr_levels_n2 = tr_levels_n2./tr_n2_div;
hold on 
p = plot(tr_levels_n2);
set(p, 'Color', 'cyan', 'LineWidth', 4);

% plotting normalised time series
% for ii = 1:(length(tr_levels) - sld_wnd_sz + 1)
    % if std(tr_levels(ii:(ii + sld_wnd_sz - 1))) > epsN
        % tmp_ts = (tr_levels(ii:(ii + sld_wnd_sz - 1)) ...
            % - mean(tr_levels((ii:(ii + sld_wnd_sz - 1)))))...
            % /std(tr_levels((ii:(ii + sld_wnd_sz - 1))));
        
        % hold on 
        % p = plot(ii:(ii + sld_wnd_sz - 1), tmp_ts);
        % set(p, 'Color', 'black', 'LineWidth', 1);
        % pause;
    % end
% end

p = plot(lvl_low*ones(1, length(tr_times)), ':b', 'LineWidth', 2);
hold on

p = plot(lvl_high*ones(1, length(tr_times)), ':r', 'LineWidth', 2);
hold on

set(legend('actual', 'av. norm.', 'low flow', 'high flow',   ...
    'Location', 'Best'), 'FontSize', 20);   % 'label',  'average',
ylabel('Rivel Level (meters)', 'FontSize', 20);
xlabel('Observations', 'FontSize', 20);
gtitle = sprintf('%s, %s - %s', st_name, datestr(tr_times(1)), ...
     datestr(tr_times(length(tr_times))));
 % title('Weisdale Burn, 25-29/10/2014', 'FontSize', 24);
 title(gtitle, 'FontSize', 24);
 set(gca, 'FontSize', 18);
pause;

close all
diary off

end