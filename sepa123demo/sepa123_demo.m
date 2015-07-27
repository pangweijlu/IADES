addpath(['sax' filesep]);   % added for this machine

sld_wnd_sz = 96;

diary('sepa123demo.log');

% reading SEPA logs and saving river levels and names of stations
t = cputime;
[s1_data, s1_names] = readSEPAsname(['data' filesep 'sepa' filesep 'Data.ZRXPSEND.398761362579297']);
t1 = cputime - t;
fprintf('Reading data for set 1 took %g minutes of CPU time.\n', t1/60);
% save('sepa1snm.mat', 'sepa1_Data', 'sepa1_Names');

t = cputime;
[s2_data, s2_names] = readSEPAsname(['data' filesep 'sepa' filesep 'Data.ZRXPSEND.964521362407503']);
t2 = cputime - t;
fprintf('Reading data for set 2 took %g minutes of CPU time.\n', t2/60);
% save('sepa2snm.mat', 'sepa2_Data', 'sepa2_Names');

t = cputime;
[s3_data, s3_names] = readSEPAsname(['data' filesep 'sepa' filesep 'Data.ZRXPSEND.978561362733168']);
t3 = cputime - t;
fprintf('Reading data for set 3 took %g minutes of CPU time.\n', t3/60);
% save('sepa3snm.mat', 'sepa3_Data', 'sepa3_Names');


% generating labels using string-based negative selection
t = cputime;
lbls1_23 = crossValidationSEPA123(s1_data, s1_names, s2_data, s2_names, ... 
    s3_data, s3_names);
t1 = cputime - t;
fprintf('Negative selection took %g minutes of CPU time on set 1.\n', ...
    t1/60);

t = cputime;
lbls2_13 = crossValidationSEPA123(s2_data, s2_names, s1_data, s1_names, ... 
    s3_data, s3_names);
t2 = cputime - t;
fprintf('Negative selection took %g minutes of CPU time on set 2.\n', ...
    t2/60);

t = cputime;
lbls3_12 = crossValidationSEPA123(s3_data, s3_names, s1_data, s1_names, ...
    s2_data, s2_names);
t3 = cputime - t;
fprintf('Negative selection took %g minutes of CPU time on set 3.\n', ...
    t3/60);

% setting unavailable labels to zeros
[~, sepa1l23_full] = SEPA123expandLabels(lbls1_23, s1_data, s1_names, ...
    sld_wnd_sz);
[~, sepa2l13_full] = SEPA123expandLabels(lbls2_13, s2_data, s2_names, ...
    sld_wnd_sz);
[~, sepa3l12_full] = SEPA123expandLabels(lbls3_12, s3_data, s3_names, ...
    sld_wnd_sz);

% writing labels to text files
SEPA123writeLabels(sepa1l23_full, 'sepa1nsD.log');
SEPA123writeLabels(sepa2l13_full, 'sepa2nsD.log');
SEPA123writeLabels(sepa3l12_full, 'sepa3nsD.log');

diary off