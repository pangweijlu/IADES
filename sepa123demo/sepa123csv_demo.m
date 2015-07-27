addpath('sax\');   % added for this machine

% initialisation
% epsN = 0.000001;
epsN = 0.05;   % 0.1; % 0001;
sld_wnd_sz = 96;
lvl_low = 0.27;
lvl_high = 1.48;
st_name = 'WeisdaleMi.SG.ir.O';
fname = 'data\nura\nurafl1.csv';   % 'data\WeisdaleBurn Station.csv';
diary('sepa123csv_demo.log');

% reading input
t = cputime;
% [levels, date_srl, time_hh, time_mm] = readSEPAcsv(fname);
[levels, date_srl] = readSEPAcsv(fname);
t1 = cputime - t;
fprintf('Reading data for station %s took %g minutes of CPU time.\n', ...
    st_name, t1/60);

% t = cputime;
% [s1_data, s1_names] = readSEPAsname('data\Data.ZRXPSEND.398761362579297');
% t1 = cputime - t;
% fprintf('Reading data for set 1 took %g minutes of CPU time.\n', t1/60);
% save('sepa1snm.mat', 's1_data', 's1_names');
load('sepa1snm.mat', 's1_data', 's1_names');

% t = cputime;
% [s2_data, s2_names] = readSEPAsname('data\Data.ZRXPSEND.964521362407503');
% t2 = cputime - t;
% fprintf('Reading data for set 2 took %g minutes of CPU time.\n', t2/60);
% save('sepa2snm.mat', 's2_data', 's2_names');
load('sepa2snm.mat', 's2_data', 's2_names');

% t = cputime;
% [s3_data, s3_names] = readSEPAsname('data\Data.ZRXPSEND.978561362733168');
% t3 = cputime - t;
% fprintf('Reading data for set 3 took %g minutes of CPU time.\n', t3/60);
% save('sepa3snm.mat', 's3_data', 's3_names');
load('sepa3snm.mat', 's3_data', 's3_names');

% generating labels
t = cputime;
tst_data = cell(1, 1);
tst_data{1} = levels;
tst_names = cell(1, 1);
tst_names{1} = st_name;
tst_lbls = testSEPA123csv(tst_data, tst_names, s1_data, s1_names, ...
    s2_data, s2_names, s3_data, s3_names);
[~, tst_full] = SEPA123expandLabels(tst_lbls, tst_data, tst_names, ...
    sld_wnd_sz);
% fprintf('There are %g non-self out of total %g observations.\n', ...
    % sum(tst_lbls{1}), length(tst_lbls{1}));
t_tst = cputime - t;
fprintf('Negative selection for station %s took %g minutes of CPU time.\n', ...
    st_name, t_tst/60);
disp('-------------------------------------------------------------');

s1_levels = cell(1, 1);
s1_levels{1} = getStData(st_name, s1_names, s1_data);
t = cputime;
s1_23labels = crossValidationSEPA123(s1_levels, tst_names, s2_data, ...
    s2_names, s3_data, s3_names);
[~, s1_full] = SEPA123expandLabels(s1_23labels, s1_levels, tst_names, ...
    sld_wnd_sz);
% fprintf('There are %g non-self out of total %g observations.\n', ...
    % sum(tst_lbls{1}), length(tst_lbls{1}));
t1 = cputime - t;
fprintf('Negative selection took %g minutes of CPU time on set 1.\n', ...
    t1/60);
disp('-------------------------------------------------------------');
% disp('Paused ...');
% pause;

s2_levels = cell(1, 1);
s2_levels{1} = getStData(st_name, s2_names, s2_data);
t = cputime;
s2_13labels = crossValidationSEPA123(s2_levels, tst_names, s1_data, ...
    s1_names, s3_data, s3_names);
t1 = cputime - t;
[~, s2_full] = SEPA123expandLabels(s2_13labels, s2_levels, tst_names, ...
    sld_wnd_sz);
fprintf('Negative selection took %g minutes of CPU time on set 2.\n', ...
    t1/60);
disp('-------------------------------------------------------------');
% disp('Paused ...');
% pause;

s3_levels = cell(1, 1);
s3_levels{1} = getStData(st_name, s3_names, s3_data);
t = cputime;
s3_12labels = crossValidationSEPA123(s3_levels, tst_names, s1_data, ...
    s1_names, s2_data, s2_names);
t1 = cputime - t;
[~, s3_full] = SEPA123expandLabels(s3_12labels, s3_levels, tst_names, ...
    sld_wnd_sz);
fprintf('Negative selection took %g minutes of CPU time on set 3.\n', ...
    t1/60);
disp('-------------------------------------------------------------');
% disp('Paused ...');
% pause;


% setting unavailable labels to zeros

% plotting flood data
disp('Plotting the flood data and labels ...');
bar(tst_full{1});
hold on
p = plot(levels);
set(p, 'Color', 'red', 'LineWidth', 4);
% hold on
% levels_norm = (levels - mean(levels))/std(levels);
% p = plot(levels_norm);
% set(p, 'Color', 'green', 'LineWidth', 4);

levels_n2 = zeros(1, length(levels));
levels_n2_div = zeros(1, length(levels));
for ii = 1:(length(levels) - sld_wnd_sz + 1)
    if std(levels(ii:(ii + sld_wnd_sz - 1))) > epsN
        levels_n2(ii:(ii + sld_wnd_sz - 1)) = ...
            levels_n2(ii:(ii + sld_wnd_sz - 1)) ...
            + (levels(ii:(ii + sld_wnd_sz - 1)) ...
            - mean(levels((ii:(ii + sld_wnd_sz - 1)))))...
            /std(levels((ii:(ii + sld_wnd_sz - 1))));
    else
        levels_n2(ii:(ii + sld_wnd_sz - 1)) = ...
            levels_n2(ii:(ii + sld_wnd_sz - 1)) ...
            + (levels(ii:(ii + sld_wnd_sz - 1)) ...
            - mean(levels((ii:(ii + sld_wnd_sz - 1)))));
    end
    % size(tst_n2_div(ii:(ii + sld_wnd_sz - 1)))
    levels_n2_div(ii:(ii + sld_wnd_sz - 1)) = ...
        levels_n2_div(ii:(ii + sld_wnd_sz - 1)) + ones(1, sld_wnd_sz);
end
levels_n2 = levels_n2./levels_n2_div;
hold on 
p = plot(levels_n2);
set(p, 'Color', 'cyan', 'LineWidth', 4);

p = plot(lvl_low*ones(1, length(levels)), ':g', 'LineWidth', 2);
hold on

p = plot(lvl_high*ones(1, length(levels)), ':r', 'LineWidth', 2);
hold on

set(legend('label', 'actual', 'average', 'low flow', 'high flow', ...
    'Location', 'Best'), 'FontSize', 20);   %  'normalised',
ylabel('Rivel Level (meters)', 'FontSize', 20);
xlabel('Observations', 'FontSize', 20);
title('Weisdale Burn, 25-29/10/2014', 'FontSize', 24);
set(gca, 'FontSize', 18);
pause;

% plotting dataset 1
disp('Plotting dataset 1 and its labels ...');
figure;
bar(s1_full{1});
hold on
p = plot(s1_levels{1});
set(p, 'Color', 'red', 'LineWidth', 4);
hold on
s1_levels_norm = (s1_levels{1} - mean(s1_levels{1}))/std(s1_levels{1});
p = plot(s1_levels_norm);
set(p, 'Color', 'green', 'LineWidth', 4);

s1_levels_n2 = zeros(1, length(s1_levels{1}));
s1_levels_n2_div = zeros(1, length(s1_levels{1}));
for ii = 1:(length(s1_levels{1}) - sld_wnd_sz + 1)
    if std(s1_levels{1}(ii:(ii + sld_wnd_sz - 1))) > epsN
        s1_levels_n2(ii:(ii + sld_wnd_sz - 1)) = ...
            s1_levels_n2(ii:(ii + sld_wnd_sz - 1)) ...
            + (s1_levels{1}(ii:(ii + sld_wnd_sz - 1)) ...
            - mean(s1_levels{1}((ii:(ii + sld_wnd_sz - 1)))))...
            /std(s1_levels{1}((ii:(ii + sld_wnd_sz - 1))));
    else
        s1_levels_n2(ii:(ii + sld_wnd_sz - 1)) = ...
            s1_levels_n2(ii:(ii + sld_wnd_sz - 1)) ...
            + (s1_levels{1}(ii:(ii + sld_wnd_sz - 1)) ...
            - mean(s1_levels{1}((ii:(ii + sld_wnd_sz - 1)))));
    end
    % size(tst_n2_div(ii:(ii + sld_wnd_sz - 1)))
    s1_levels_n2_div(ii:(ii + sld_wnd_sz - 1)) = ...
        s1_levels_n2_div(ii:(ii + sld_wnd_sz - 1)) + ones(1, sld_wnd_sz);
end
s1_levels_n2 = s1_levels_n2./s1_levels_n2_div;
hold on 
p = plot(s1_levels_n2);
set(p, 'Color', 'cyan', 'LineWidth', 4);

set(legend('label', 'actual', 'normalised', 'average', 'Location', 'Best'), ...
    'FontSize', 20);
ylabel('Rivel Level (meters)', 'FontSize', 20);
xlabel('Observations', 'FontSize', 20);
title('Weisdale Burn, SEPA 1', 'FontSize', 24);   % 25-29/10/2014
set(gca, 'FontSize', 18);
pause;

% plotting dataset 2
disp('Plotting dataset 2 and its labels ...');
figure;
bar(s2_full{1});
hold on
p = plot(s2_levels{1});
set(p, 'Color', 'red', 'LineWidth', 4);
hold on
s2_levels_norm = (s2_levels{1} - mean(s2_levels{1}))/std(s2_levels{1});
p = plot(s2_levels_norm);
set(p, 'Color', 'green', 'LineWidth', 4);

s2_levels_n2 = zeros(1, length(s2_levels{1}));
s2_levels_n2_div = zeros(1, length(s2_levels{1}));
for ii = 1:(length(s2_levels{1}) - sld_wnd_sz + 1)
    if std(s2_levels{1}(ii:(ii + sld_wnd_sz - 1))) > epsN
        s2_levels_n2(ii:(ii + sld_wnd_sz - 1)) = ...
            s2_levels_n2(ii:(ii + sld_wnd_sz - 1)) ...
            + (s2_levels{1}(ii:(ii + sld_wnd_sz - 1)) ...
            - mean(s2_levels{1}((ii:(ii + sld_wnd_sz - 1)))))...
            /std(s2_levels{1}((ii:(ii + sld_wnd_sz - 1))));
    else
        s2_levels_n2(ii:(ii + sld_wnd_sz - 1)) = ...
            s2_levels_n2(ii:(ii + sld_wnd_sz - 1)) ...
            + (s2_levels{1}(ii:(ii + sld_wnd_sz - 1)) ...
            - mean(s2_levels{1}((ii:(ii + sld_wnd_sz - 1)))));
    end
    % size(tst_n2_div(ii:(ii + sld_wnd_sz - 1)))
    s2_levels_n2_div(ii:(ii + sld_wnd_sz - 1)) = ...
        s2_levels_n2_div(ii:(ii + sld_wnd_sz - 1)) + ones(1, sld_wnd_sz);
end
s2_levels_n2 = s2_levels_n2./s2_levels_n2_div;
hold on 
p = plot(s2_levels_n2);
set(p, 'Color', 'cyan', 'LineWidth', 4);

set(legend('label', 'actual', 'normalised', 'average'), 'FontSize', 20);
ylabel('Rivel Level (meters)', 'FontSize', 20);
xlabel('Observations', 'FontSize', 20);
title('Weisdale Burn, SEPA 2', 'FontSize', 24);   % 25-29/10/2014
set(gca, 'FontSize', 18);
pause;

% plotting dataset 3
disp('Plotting dataset 3 and its labels ...');
figure;
bar(s3_full{1});
hold on
p = plot(s3_levels{1});
set(p, 'Color', 'red', 'LineWidth', 4);
hold on
s3_levels_norm = (s3_levels{1} - mean(s3_levels{1}))/std(s3_levels{1});
p = plot(s3_levels_norm);
set(p, 'Color', 'green', 'LineWidth', 4);

s3_levels_n2 = zeros(1, length(s3_levels{1}));
s3_levels_n2_div = zeros(1, length(s3_levels{1}));
for ii = 1:(length(s3_levels{1}) - sld_wnd_sz + 1)
    if std(s3_levels{1}(ii:(ii + sld_wnd_sz - 1))) > epsN
        s3_levels_n2(ii:(ii + sld_wnd_sz - 1)) = ...
            s3_levels_n2(ii:(ii + sld_wnd_sz - 1)) ...
            + (s3_levels{1}(ii:(ii + sld_wnd_sz - 1)) ...
            - mean(s3_levels{1}((ii:(ii + sld_wnd_sz - 1)))))...
            /std(s3_levels{1}((ii:(ii + sld_wnd_sz - 1))));
    else
        s3_levels_n2(ii:(ii + sld_wnd_sz - 1)) = ...
            s3_levels_n2(ii:(ii + sld_wnd_sz - 1)) ...
            + (s3_levels{1}(ii:(ii + sld_wnd_sz - 1)) ...
            - mean(s3_levels{1}((ii:(ii + sld_wnd_sz - 1)))));
    end
    % size(tst_n2_div(ii:(ii + sld_wnd_sz - 1)))
    s3_levels_n2_div(ii:(ii + sld_wnd_sz - 1)) = ...
        s3_levels_n2_div(ii:(ii + sld_wnd_sz - 1)) + ones(1, sld_wnd_sz);
end
s3_levels_n2 = s3_levels_n2./s3_levels_n2_div;
hold on 
p = plot(s3_levels_n2);
set(p, 'Color', 'cyan', 'LineWidth', 4);

set(legend('label', 'actual', 'normalised'), 'FontSize', 20);
ylabel('Rivel Level (meters)', 'FontSize', 20);
xlabel('Observations', 'FontSize', 20);
title('Weisdale Burn, SEPA 3', 'FontSize', 24);   % 25-29/10/2014
set(gca, 'FontSize', 18);
pause;
close all

% writing labels to text files
% SEPA123writeLabels(tst_full,'WeisdaleMinsD.log');

% tst_data{1} = getStData(st_name, s1_names, s1_data);
% s1_self = crossValidationSEPA123(tst_data, st_names, s2_data, ...
    % s2_names, s3_data, s3_names);
% [~, s1_full] = SEPA123expandLabels(s1_self, tst_data, tst_names, ...
    % sld_wnd_sz);

diary off
