function testDeeStation(sname)

 if nargin < 1
     sname = 'Garthdee';
 end
 
 testfile = [sname '.SG.mat'];
 lhfile = [sname 'LH.mat'];
 trainfile = [sname 'S123.mat'];
 
 load(testfile, 'name', 'times', 'levels');
 tst_times = times;
 tst_levels = levels;
 
 load(lhfile, 'lvl_low', 'lvl_high');
 load(trainfile, 'name', 'times', 'levels');
 
 testNSsepa(name, times, levels, tst_times, tst_levels, lvl_low, lvl_high);
 
end


