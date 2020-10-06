% (C) Copyright 2010-2020 Sam Schwarzkopf
% (C) Copyright 2020 Remi Gau

function stimulus = genColRipples(stim)

    frames = size(stim, 3);

    stimulus = zeros([size(stim, 1) size(stim, 2) 3 size(stim, 3)]);
    stimulus(:, :, 1, :) = stim;
    stimulus(:, :, 2, :) = stim(:, :, [frames / 2 + 1:frames 1:frames / 2]);
    stimulus(:, :, 3, :) = stim(:, :, [frames * (3 / 4) + 1:frames 1:frames * (3 / 4)]);

end
