% (C) Copyright 2010-2020 Sam Schwarzkopf
% (C) Copyright 2020 Remi Gau

function generateStimulus(cfg)
    % generateStimulus(cfg)
    %
    % The mat file of the background stimulus is saved in the folder ['..', '..', 'input']
    % can also generate a figure of the stimulus.
    %
    % Generating the stimulus can be VERY slow on octave.
    %
    % main "inputs"
    %
    % - cfg.stim can be 'Ripples', 'checkerboard', 'colRipples'
    % - width is that of the stimulus in pixels
    %
    % stimulus dimensions are:
    % - [width height number_of_frames]
    % - [width height colors number_of_frames] for colRipples
    %
    % stimFrames is the number of screen refresh that will be spent on each
    % stimulus frame: increase this number to get something that changes slower
    %
    % See checkGenerateLoadStim()

    pringFig = false;
    if nargin < 1
        close all;
        width = 1080;
        cfg.stim = 'Ripples'; % ripples %checkerboard %colRipples
        pringFig = false;
    else
        width = cfg.stimWidth;
    end

    fprintf('Generating background stimulus.\n');

    switch lower(cfg.stim)

        case 'checkerboard'

            stimulus = radialCheckerBoard([width / 2 0], [-180 180], [7 5]); %#ok<*NASGU>

            stimFrames = 8;

            outputFile = 'checkerboard';

            pngToSave = stimulus;

        case 'ripples'

            stimulus = genRipples(width);

            outputFile = 'ripples';

            stimFrames = 1;

        case 'colripples'

            stimulus = genRipples(width);

            stimulus = genColRipples(stimulus);

            stimFrames = 2;

            outputFile = 'colRipples';
    end

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', '..', 'input');

    save(fullfile(outputDir, [outputFile '.mat']), ...
        'stimulus', 'stimFrames');

    if pringFig
        for iStim = 1:size(stimulus, 3)
            figure('name', 'stimulus', 'position', [0 0 800 800]);
            imagesc(stimulus(:, :, iStim));
            axis square;
            box off;
            axis off;
            colormap gray;
            print(gcf, fullfile(outputDir, [outputFile '_' num2str(iStim) '.png']), '-dpng');
            clf;
        end
    end

    fprintf('Done.\n');
end
