addpath('sax\');   % added for this machine

% initialisation
sld_wnd_sz = 96;
st_name = 'WeisdaleMi.SG.ir.O';
diary('weisdaleburn_demo.log');

% reading input
t = cputime;
tr_fname = 'data\WeisdaleBurn150222-.csv';
[tr_levels, tr_date_srl, tr_time_hh, tr_time_mm] = readSEPAcsv(tr_fname);
t1 = cputime - t;
fprintf('Reading training data for station %s took %g minutes of CPU time.\n', ...
    st_name, t1/60);

t = cputime;
tst_fname = 'data\WeisdaleBurn Station.csv';
[tst_levels, tst_date_srl, tst_time_hh, tst_time_mm] = ...
    readSEPAcsv(tst_fname);
t = cputime - t;
fprintf('Reading training data for station %s took %g minutes of CPU time.\n', ...
    st_name, t/60);
% [tr_levels, tr_date_srl] = readSEPAcsv('');

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

% plotting flood data
disp('Plotting the flood data and labels ...');
bar(tst_full{1});
hold on
p = plot(tst_levels);
set(p, 'Color', 'red', 'LineWidth', 4);
hold on
tst_levels_norm = (tst_levels - mean(tst_levels))/std(tst_levels);
p = plot(tst_levels_norm);
set(p, 'Color', 'green', 'LineWidth', 4);
set(legend('label', 'actual', 'normalised', 'Location', 'Best'), ...
    'FontSize', 20);
ylabel('Rivel level', 'FontSize', 20);
xlabel('Observations', 'FontSize', 20);
set(gca, 'FontSize', 18);
pause;

% plotting dataset 1
disp('Plotting the training set and its labels ...');
figure;
% bar(tr_full{1});
% hold on
p = plot(tr_levels);
set(p, 'Color', 'red', 'LineWidth', 4);
hold on
tr_levels_norm = (tr_levels - mean(tr_levels))/std(tr_levels);
p = plot(tr_levels_norm);
set(p, 'Color', 'green', 'LineWidth', 4);
set(legend('actual', 'normalised', 'Location', 'Best'), ...
    'FontSize', 20);   % 'label', 
ylabel('Rivel level', 'FontSize', 20);
xlabel('Observations', 'FontSize', 20);
set(gca, 'FontSize', 18);
pause;

close all
diary off

