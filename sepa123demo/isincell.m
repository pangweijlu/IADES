function [ output ] = isincell(value, C)
% ISINCELL checks if a value belongs to a cell array
% (c) Andriy Kharechko, University of Aberdeen, 13/11/2014

    [l1, l2] = size(C);
    
    output = false;
    for i = 1:l1
        for j = 1:l2
            if size(C{i, j}) == size(value)
                if C{i, j} == value
                    output = true;
                    return;
                end
            end
        end
    end
            
end

