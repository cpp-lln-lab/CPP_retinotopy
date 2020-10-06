% (C) Copyright 2010-2020 Sam Schwarzkopf
% (C) Copyright 2020 Remi Gau

function y = isodd(x)
    % y = isodd(x)
    %
    % Returns 1 if x is an odd number, 0 if it is an even number.
    %

    y = mod(x, 2);
    y = logical(y);

end
