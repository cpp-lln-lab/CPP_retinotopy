% (C) Copyright 2010-2020 Sam Schwarzkopf
% (C) Copyright 2020 Remi Gau

function barsMapping(cfg)
    % barsMapping(cfg)
    %
    % Runs the drifting bar protocol for mapping population receptive fields.
    % If SaveAps is true it saves the aperture mask for each volume (for pRF).

    cfg = userInputs(cfg);
    cfg = createFilename(cfg);

    % Prepare for the output logfiles with all
    logFile.extraColumns = cfg.extraColumns;
    logFile = saveEventsFile('open', cfg, logFile);

    disp(cfg);

    %% Initialize

    % ------------------------------------------------------------------------------
    % REFACTOR THIS
    %
    % current stimulus Frame
    thisEvent.frame = 1;
    thisEvent.time = 0;
    thisEvent.volume = 0;

    ring = [];

    target.wasTarget = false;
    target.trial_type = 'target';
    target.fileID = logFile.fileID;
    target.extraColumns = logFile.extraColumns;
    target.target_width = cfg.target.size;

    barInfo.fileID = logFile.fileID;
    barInfo.extraColumns = logFile.extraColumns;
    barInfo.trial_type = 'bar';

    frameTimes = [];

    %% Set up

    % TODO
    % Randomness
    %     setUpRand;

    % targetsTimings is a vector that says when (in seconds from the start of the
    % experiment) a target should be presented.
    cfg.cyclesPerExpmt = length(cfg.conditions);
    targetsTimings = createTargetsTiming(cfg);

    try

        %% Initialize PTB

        cfg = checkGenerateLoadStim(cfg);
        cfg.refreshPerStim = 4;

        [cfg] = initPTB(cfg);

        [cfg, target] = postInitializationSetup(cfg, target);

        if strcmp(cfg.stim, 'dot')
            cfg = dotTexture('init', cfg);
        else
            bgdTextures = loadBckGrnd(cfg.stimulus, cfg.screen.win);
        end

        % Create aperture texture
        cfg = apertureTexture('init', cfg);

        % prepare the KbQueue to collect responses
        getResponse('init', cfg.keyboard.responseBox, cfg);

        [el] = eyeTracker('Calibration', cfg); %#ok<*NASGU>

        standByScreen(cfg);

        %% Wait for start of experiment
        waitForTrigger(cfg);

        eyeTracker('StartRecording', cfg);

        getResponse('start', cfg.keyboard.responseBox);

        %% Start cycling the stimulus
        cfg = getExperimentStart(cfg);
        rft = cfg.experimentStart;

        barInfo.experimentStarted = false;

        HideCursor;

        %% Run stimulus sequence
        for iTrial = 1:length(cfg.conditions)

            % Begin trial
            trialOnset = GetSecs - cfg.experimentStart;

            % Stimulation sequence
            thisEvent.condition = cfg.conditions(iTrial);

            thisEvent.volume = 1;
            thisEvent.previousVolume = 0;
            thisEvent.stim = 1;

            while thisEvent.volume <= cfg.volsPerCycle

                checkAbort(cfg);

                % ------------------------------------------------------------------------------
                % REFACTOR THIS
                %
                if strcmp(cfg.stim, 'dot')

                    thisEvent.speed = cfg.dot.speedPix;

                    if thisEvent.volume ~= thisEvent.previousVolume

                        thisEvent.direction = rand * 360;

                        dots = initDots(cfg, thisEvent);

                    end

                    [dots] = updateDots(dots, cfg);

                    thisEvent.dot.positions = (dots.positions - cfg.dot.matrixWidth / 2)';

                    dotTexture('make', cfg, thisEvent);

                else

                    % Determine current frame
                    thisEvent.frame = thisEvent.frame + 1;
                    if thisEvent.frame > cfg.refreshPerStim
                        thisEvent.frame = 1;
                        thisEvent.stim = thisEvent.stim + 1;
                    end

                    if thisEvent.stim > size(cfg.stimulus, ...
                            length(size(cfg.stimulus)))
                        thisEvent.stim = 1;
                    end

                end
                % ------------------------------------------------------------------------------

                %% Get info about this event and the bar

                thisEvent.time = GetSecs - cfg.experimentStart;
                thisEvent.barPosPix = cfg.aperture.barPosPix(thisEvent.volume);

                [cfg, thisEvent] = apertureTexture('make', cfg, thisEvent);

                %% Draw stimulus
                % we draw the background stimulus in full and overlay an aperture
                % on top of it

                if strcmp(cfg.stim, 'dot')

                    dotTexture('draw', cfg, thisEvent);

                else

                    % Draw background stimulus at a given rotation
                    bgdAngle = cos(GetSecs - trialOnset) * cfg.sineRotation;

                    % draw the background texture centered on screen
                    Screen('DrawTexture', cfg.screen.win, bgdTextures(thisEvent.stim), ...
                        cfg.stimRect, ...
                        CenterRect(cfg.destinationRect, cfg.screen.winRect), ...
                        bgdAngle + thisEvent.condition - 90);

                end

                [cfg, thisEvent] = apertureTexture('draw', cfg, thisEvent);

                drawFixation(cfg);

                [target] = drawTarget(target, targetsTimings, thisEvent, cfg);

                drawFieldOfVIew(cfg);

                %% Flip current frame
                rft = Screen('Flip', cfg.screen.win, rft + cfg.screen.ifi);

                %% Collect and save target / stim / response info if necessary

                % ------------------------------------------------------------------------------
                % REFACTOR THIS
                %
                % detect the of an event and the beginning of a new one
                if thisEvent.volume ~= thisEvent.previousVolume
                    isOffset = true && barInfo.experimentStarted;
                    isOnset = true;
                end

                barInfo.bar_width = cfg.aperture.width;

                [barInfo, isOffset] = saveOnOffset( ...
                    isOffset, ...
                    barInfo, cfg, rft);

                [barInfo, isOnset] = getOnset(isOnset, barInfo, cfg, rft);
                barInfo.experimentStarted = true;

                % update info for the next round
                barInfo.bar_width = cfg.aperture.width;
                barInfo.bar_angle = thisEvent.condition;
                barInfo.bar_position = cfg.aperture.barPos(thisEvent.volume);

                target = getOnset(target.isOnset, target, cfg, rft);
                target = saveOnOffset( ...
                    target.isOffset, ...
                    target, cfg, rft);
                % -------------------------------------------------------------------------------

                collectAndSaveResponses(cfg, logFile, cfg.experimentStart);

                %% Determine current volume
                thisEvent.previousVolume = thisEvent.volume;
                thisEvent.volume = floor((thisEvent.time - trialOnset) / ...
                    cfg.mri.repetitionTime) + 1;

            end

        end

        %% End the experiment
        cfg = getExperimentEnd(cfg);

        getResponse('stop', cfg.keyboard.responseBox);
        getResponse('release', cfg.keyboard.responseBox);

        saveEventsFile('close', cfg, logFile);

        eyeTracker('StopRecordings', cfg);
        eyeTracker('Shutdown', cfg);

        %       data = feedbackScreen(cfg);

        waitFor(cfg, 1);

        %% Save

        % clear stim from structure and a few variables to save memory
        cfg = rmfield(cfg, 'stimulus');

        createJson(cfg, cfg);

        output = bids.util.tsvread( ...
            fullfile(cfg.dir.outputSubject, cfg.fileName.modality, ...
            cfg.fileName.events));

        disp(output);

        waitFor(cfg, 4);

        %% Farewell screen
        farewellScreen(cfg);

        cleanUp;

    catch
        cleanUp;
        psychrethrow(psychlasterror);
    end

end

function varargout = postInitializationSetup(varargin)
    % varargout = postInitializatinSetup(varargin)
    %
    % generic function to finalize some set up after psychtoolbox has been
    % initialized

    [cfg, target] = deal(varargin{:});

    % apply pixels per degree conversion
    target = degToPix('target_width', target, cfg);

    cfg.stimRect = [0 0 cfg.stimWidth cfg.stimWidth];

    % get the details about the destination rectangle where we want to draw the
    % stimulus
    cfg.destinationRect = cfg.stimRect;
    if isfield(cfg, 'stimDestWidth') && ~isempty(cfg.stimDestWidth)
        cfg.destinationRect = [0 0 cfg.stimDestWidth cfg.stimDestWidth];
        cfg.scalingFactor = cfg.destinationRect(3) / cfg.stimRect(3);
    end

    if strcmp(cfg.stim, 'dot')

        cfg.dot = degToPix('size', cfg.dot, cfg);
        cfg.dot = degToPix('speed', cfg.dot, cfg);

        cfg.dot.speedPixPerFrame = cfg.dot.speedPix / cfg.screen.monitorRefresh;

        % dots are displayed on a square
        cfg.dot.matrixWidth = cfg.destinationRect(3);
        cfg.dot.number = round(cfg.dot.density * ...
            (cfg.dot.matrixWidth / cfg.screen.ppd)^2);

    end

    varargout = {cfg, target};

end
