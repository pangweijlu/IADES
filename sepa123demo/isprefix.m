function [output] = isprefix(pref, str)
%ISPREFIX checks whether string 'pref' is a prefix of 'str'
% (c) Andriy Kharechko, University of Aberdeen, 13/11/2014

    l_pref = length(pref);
    [l1_str, l2_str] = size(str);
    if (l_pref > l2_str)   % length(str)
        error('isprefix: prefix is longer than string(s) stored as row(s)');
    end
    
    if ~islogical(pref)   % error?
        disp('isprefix: converting prefix to the binary format ...');
        pref = logical(pref);
    end
    
    if ~islogical(str)   % error?
        disp('isprefix: converting string to the binary format ...');
        str = logical(str);
    end
    
    output = false;
    for j = 1:l1_str
        if pref == str(j, 1:l_pref)
            output = true;
            break;
        end
    end
    % if pref == str(1:l_pref)
        % output = true;
    % else
        % output = false;
    % end
    
end

