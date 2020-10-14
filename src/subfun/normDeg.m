% (C) Copyright 2010-2020 Sam Schwarzkopf
% (C) Copyright 2020 Remi Gau

function ndegs = normDeg(degs, rng)
    % ndegs = NormDeg(Degs, Rng)
    %
    % Returns the normalized (0-359.9999 deg) angle of Degs.
    % Rng denotes the range and it can only be 180 or 360 (default).
    % If Rng is any other number, it will default to 360.

    if nargin == 1 || (rng ~= 360 && rng ~= 180)
        rng = 360;
    end

    ndegs = mod(degs, rng);

end
