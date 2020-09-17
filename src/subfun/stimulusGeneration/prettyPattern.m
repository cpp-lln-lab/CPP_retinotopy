% (C) Copyright 2010-2020 Sam Schwarzkopf
% (C) Copyright 2020 Remi Gau

function img = prettyPattern(lambda, phase, width)
    % img = PrettyPattern(lambda, phase, width)
    %
    % Draws a pretty pattern stimulus.
    %
    % Parameters:
    %   lambda :    Wavelength of the sinusoid
    %   phase :     Phase of the sinusoid
    %   width :     Width of the image
    %
    % The function returns the new image.
    %

    % Grating
    % Parameters for all pixels
    [X, Y] = meshgrid(-width / 2:width / 2 - 1, -width / 2:width / 2 - 1);
    [~, R] = cart2pol(X, Y);

    % Luminance modulation at each pixel
    G = R .* (cos(2 * pi .* (sind(X) + cosd(Y)) ./ lambda + phase));

    % Image matrix
    img = uint8(G);

end
