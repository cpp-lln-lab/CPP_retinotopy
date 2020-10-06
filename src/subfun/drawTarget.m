% (C) Copyright 2010 Sam Schwarzkopf
% (C) Copyright 2010 Tim Rohe
% (C) Copyright 2020 Remi Gau

function [target] = drawTarget(target, events, thisEvent, cfg)

    win = cfg.screen.win;
    winRect =  cfg.screen.winRect;

    isTarget = false;

    target.isOnset = false;
    target.isOffset = false;

    wasTarget = target.wasTarget;
    target_width = target.target_widthPix;

    % check that the current time is superior to the start time and inferior to the end time of at
    % least one event
    currTargets = events - thisEvent.time;
    if  any(all([currTargets > 0, currTargets < cfg.target.duration], 2))
        isTarget = true;
    end

    % we wait for rings to be large enough to present some targets if
    % they are not just a change of color of the fixation dot
    if ~cfg.target.central && ...
            strcmp(cfg.aperture.type, 'ring') && ...
            cfg.ring.ring_inner_rim < cfg.target.size
        isTarget = false;
    end

    if isTarget

        % make sure that we don't change the position of this target
        % for the time it is presented
        if ~wasTarget
            target.rndAngle = randOri;
            target.rndScale = round(rand * (winRect(4) / 2));
            target.isOnset = true;
            wasTarget = true;
        end

        % target location: flicker the fixation dot by default
        X = 0;
        Y = 0;
        % or display the target in the ring or wedge
        if ~cfg.target.central && strcmp(cfg.aperture.type, 'ring')
            outerRimPix = cfg.ring.outerRimPix;
            innerRimPix = cfg.ring.innerRimPix;
            [X, Y] = pol2cart(target.rndAngle / 180 * pi, (outerRimPix / 2 + innerRimPix / 2) / 2);
        elseif ~cfg.target.central && strcmp(cfg.aperture.type, 'wedge')
            [X, Y] = pol2cart((90 + thisEvent.angle + cfg.aperture.width / 2) / ...
                180 * pi, target.rndScale);
        end

        target.x_target_pos = X;
        target.y_target_pos = Y;

        % actual target position in pixel
        X = cfg.screen.center(1) - X;
        Y = cfg.screen.center(2) - Y;

        % Draw event
        Screen('FillOval', win, ...
            cfg.target.color, ...
            [X - target_width / 2 ...
            Y - target_width / 2 ...
            X + target_width / 2 ...
            Y + target_width / 2]);

    else

        if wasTarget
            target.isOffset = true;
        end
        wasTarget = false;

    end

    target.isTarget = isTarget;
    target.wasTarget = wasTarget;

end
