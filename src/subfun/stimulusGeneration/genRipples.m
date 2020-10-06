% (C) Copyright 2010-2020 Sam Schwarzkopf
% (C) Copyright 2020 Remi Gau

function stimulus = genRipples(width)

    phases = 0:10:350;

    stimulus = zeros(width, width, length(phases));

    [X, Y] = meshgrid([-width / 2:-1 1:width / 2], [-width / 2:-1 1:width / 2]);

    [~, R] = cart2pol(X, Y);

    outside = R > width / 2;

    f = 1;
    for pha = phases
        img = prettyPattern(sin(pha / 180 * pi) / 2 + 1, pha, width);
        img(img > 0) = 255;
        img(outside) = 127;
        stimulus(:, :, f) = img;
        f = f + 1;
    end

end
