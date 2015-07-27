
diary('deeData.log');

fpath = '..\deeData\DeeData1\';
st_codes{1} = 'Garthdee.SG';
st_codes{2} = 'Mar Lodge.SG';
readZRXsaveMAT(st_codes, fpath);

fpath = '..\deeData\DeeData2\';
st_codes{1} = 'Park.SG';
st_codes{2} = 'Polhollick.SG';
readZRXsaveMAT(st_codes, fpath);

clear st_codes
fpath = '..\deeData\DeeData3\';
st_codes{1} = 'Woodend.SG';
readZRXsaveMAT(st_codes, fpath);

% fpath = '..\deeData\Polhollick\';
% st_codes{1} = 'Polhollick.SG';
% readZRXsaveMAT(st_codes, fpath);

diary off