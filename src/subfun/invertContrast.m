% (C) Copyright 2010-2020 Sam Schwarzkopf
% (C) Copyright 2020 Remi Gau

function imgOut = invertContrast(imgIn)
    % imgOut = InvertContrast(imgIn)
    %
    % Inverts the contrast of a greyscale image.
    %

    imgIn = double(imgIn);
    imgOut = abs(imgIn - 255);
    imgOut = uint8(imgOut);

end
