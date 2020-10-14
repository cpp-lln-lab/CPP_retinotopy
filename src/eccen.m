% (C) Copyright 2010-2020 Sam Schwarzkopf
% (C) Copyright 2020 Remi Gau

function eccen(debug, direc, stim, emul)
    % eccen(debug, direc, stim, emul)
    %
    % Eccentricity mapping: does the retinotopy with an contracting or
    % expanding ring
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

    cfg.task.name = 'retinotopy eccen';

    % Stimulus type
    cfg.aperture.type = 'ring';
    % Width of wedge in degrees
    cfg.aperture.width = 1;
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

    defaultStruct = struct('LongName', '', ...
                           'Units', '');

    cfg.extraColumns.ring_inner_rim = struct( ...
                                             'length', 1, ...
                                             'bids', defaultStruct);
    cfg.extraColumns.ring_inner_rim.bids.LongName = 'position of ring inner rim';
    cfg.extraColumns.ring_inner_rim.bids.Units = 'degrees  of visual angles';

    cfg.extraColumns.ring_outer_rim = struct( ...
                                             'length', 1, ...
                                             'bids', defaultStruct);
    cfg.extraColumns.ring_outer_rim.bids.LongName = 'position of ring outer rim';
    cfg.extraColumns.ring_outer_rim.bids.Units = 'degrees  of visual angles';

    [cfg] = setParameters(cfg);

    %% Run the experiment
    [~, ~] = retinotopicMapping(cfg);

    %     plotResults(data, expParameters);

end
