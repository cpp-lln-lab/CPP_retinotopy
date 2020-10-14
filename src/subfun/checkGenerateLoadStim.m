% (C) Copyright 2010-2020 Sam Schwarzkopf
% (C) Copyright 2020 Remi Gau

function cfg = checkGenerateLoadStim(cfg)
    % cfg = loadStim(cfg)
    %
    % load background stimulus or generate if it does not exist or if it does
    % not match the requirement
    %
    % output
    %
    % cfg.stimulus: the stimulus itself
    % cfg.refreshPerStim: number of screen refresh spent on each frame of the
    %   stimulus
    %
    % See: generateStimulus()

    if strcmpi(cfg.stim, 'dot')
        cfg.refreshPerStim = 1;  % Video frames per stimulus frame
        return
    end

    fprintf('Loading file: %s\n', cfg.stimFile);

    if ~exist(cfg.stimFile, 'file')
        fprintf('File not found.\n');
        generateStimulus(cfg);
    end

    load(cfg.stimFile);

    if size(stimulus, 1) ~= cfg.stimWidth
        fprintf('Stimulus does not have the right dimension.\n');
        generateStimulus(cfg);
        load(cfg.stimFile);
    end

    if strcmpi(cfg.stim, 'checkerboard')

        cfg.stimulus(:, :, 1) = stimulus;
        cfg.stimulus(:, :, 2) = uint8(invertContrastCogent(cogentImage(stimulus)) * 255);

    else

        cfg.stimulus = stimulus;

    end

    cfg.refreshPerStim = stimFrames;  % Video frames per stimulus frame

end

function imgCogent = cogentImage(Img8bit)
    % ImgCogent = CogentImage(Img8bit)
    % Converts the 8 bit image (0-255) into a cogent image (0-1).

    imgCogent = (double(Img8bit) + 1) / 256;
end

function imgOut = invertContrastCogent(imgIn)
    % imgOut = InvertContrastCogent(imgIn)
    % Inverts the contrast of a greyscale image.

    imgOut = abs(imgIn - 1);
end
