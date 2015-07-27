function res = matchvec(vec1, vec2, eps_cmp)
% matchvec CONTINUE HERE ...
% (c) Andriy Kharechko, University of Aberdeen, 06/11/2014
    
 res = false;
  
 if nargin < 2
     error('There must be at least two parameters!');
 end
 
 if length(vec1) ~= length(vec2)
     error('Arrays must be of the same size!');
 end
 
 if nargin < 3
     eps_cmp = 0.001;
 end
 
 if norm(vec1 - vec2, 2) <= eps_cmp
     res = true;
 end
 