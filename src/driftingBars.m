% (C) Copyright 2010-2020 Sam Schwarzkopf
% (C) Copyright 2020 Remi Gau

function driftingBars(debug, stim, emul)
    % driftingBars(stim, emul, debug)
    %
    % Drifting bars for mapping population receptive fields
    %   Subj :  String with subject ID
    %   Stim :  Stimulus file name e.g. 'Checkerboard'
    %   Emul :  0 = Triggered by scanner, 1 = Trigger by keypress

    if nargin < 1 || isempty(debug)
        debug = 0;
    end
    if nargin < 2  || isempty(stim)
        stim = 'dot'; % ripples dot
    end
    if nargin < 3  || isempty(emul)
        emul = 0;
    end

    initEnv();

    %% Experimental Parameters

    cfg.task.name = 'retinotopy drifting bar';

    % Stimulus type
    cfg.aperture.type = 'bar';

    % Stimulus conditions in each block defined by number
    cfg.conditions = repmat([90 45 135 270 225 315], 1, 3);

    %% Set defaults

    cfg.stim = stim;

    cfg.debug.do = debug;

    
    cfg.testingDevice = 'mri';
    if emul
        cfg.testingDevice = 'pc';
    end

    cfg.extraColumns.bar_angle = struct( ...
        'length', 1, ...
        'bids', struct( ...
        'LongName', 'bar angle', ...
        'Description', '', ...
        'Units', 'degrees'));

    cfg.extraColumns.bar_width = struct( ...
        'length', 1, ...
        'bids', struct( ...
        'LongName', 'width of the bar', ...
        'Description', '', ...
        'Units', 'degrees'));

    cfg.extraColumns.bar_position = struct( ...
        'length', 1, ...
        'bids', struct( ...
        'LongName', '', ...
        'Description', 'bar position with respoect to the fixation cross', ...
        'Units', 'degrees'));

    [cfg] = setParameters(cfg);

    %% Run the experiment
    barsMapping(cfg);
