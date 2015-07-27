function readZRXsaveMAT(st_codes, fpath)

 if nargin < 2
     fpath = '';
 end
 
 if (nargin < 1) || isempty(st_codes)
     disp('No station codes were passed.');
     return;
 end
 
 fprintf('Reading %d collections %s ...\n', length(st_codes), fpath);
 
 count = 0;
 while count < length(st_codes)
     count = count + 1;
     % fname = ['..\deeData\DeeData3\' st_code{count} '.zrx'];
     fname = [fpath st_codes{count} '.zrx'];
     t = cputime;
     [st_Names, st_Time, st_Levels] = readZRXPfile(fname); 
     t = cputime - t;
     fprintf('Reading data %s took %g minutes of CPU time.\n', ...
         st_codes{count}, t/60);
     fmat = sprintf('%s.mat', st_codes{count});
     name = st_Names{1};
     times = st_Time{1};
     levels = st_Levels{1};
     save(fmat, 'name', 'times', 'levels');
     fprintf('Observations for station %s have been saved in %s file\n', ...
         name, fmat);
 end
 
 fprintf('Collections %s have been input.\n', fpath);
 
end