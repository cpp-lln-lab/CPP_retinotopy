% (C) Copyright 2010-2020 Sam Schwarzkopf
% (C) Copyright 2020 Remi Gau

function polar(debug, direc, stim, emul)
    % polar(debug, direc, stim, emul)
    %
    % Polar mapping: does the retinotopy with a rotating wedge
    %   direc : '+' or '-' for clockwise or anticlockwise
    %   stim :  Stimulus file name e.g. 'Checkerboard'
    %   emul :  0 = Triggered by scanner, 1 = Trigger by keypress
    %   debug : will play the experiment with PTB transparency

    if nargin < 4 || isempty(emul)
        emul = 1;
    end
    if nargin < 3 || isempty(stim)
        stim = 'dot'; % 'checkerboard';
    end
    if nargin < 2 || isempty(dir)
        direc = '-';
    end
    if nargin < 1 || isempty(debug)
        debug = 1;
    end

    initEnv();

    %% Experiment parameters

    cfg.task.name = 'retinotopy polar';

    % Stimulus type
    cfg.aperture.type = 'wedge';
    % Width of wedge in degrees
    cfg.aperture.width = 70;
    % Direction of cycling
    cfg.direction = direc;

    %% Set defaults

    cfg.stim = stim;
    cfg.debug.do = debug;

    if ~emul
        cfg.testingDevice = 'mri';
    else
        cfg.testingDevice = 'pc';
    end

    cfg.extraColumns.angle = struct( ...
        'length', 1, ...
        'bids', struct( ...
        'LongName', 'position of the center of the wedge', ...
        'Units', 'degrees'));

    cfg.extraColumns.wedge_angle = struct( ...
        'length', 1, ...
        'bids', struct( ...
        'LongName', 'angular width of the wedge', ...
        'Units', 'degrees'));

    [cfg] = setParameters(cfg);

    %% Run the experiment
    [data, cfg] = retinotopicMapping(cfg);

    %     plotResults(data, expParameters);

end
