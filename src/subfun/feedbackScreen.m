% (C) Copyright 2020 Remi Gau

function data = feedbackScreen(cfg)
    % data = feedbackScreen(cfg, expParameters);
    % gives feedback to the participant
    % the hit rate can be overestimated if there are 2 targets close to each
    % other then a response to the second target can also be counted as a
    % reponse for the first one

    target = 4;
    response = 5;

    isTarget = find(data(:, 2) == target);
    isResp = data(:, 2) == response;

    hit = 0;
    miss = 0;

    % we check if there is a response in the response window (defined with
    % logical indexing) and update the appropriate counter
    for iTarget = 1:numel(isTarget)

        respWin = all([ ...
                       data(:, 1) >= data(isTarget(iTarget), 1), ...
                       data(:, 1) < (data(isTarget(iTarget), 1) + cfg.respWin)], 2);

        if any(all([respWin IsResp], 2))
            hit = hit + 1;
        else
            miss = miss + 1;
        end

    end

    fa = sum(IsResp) - hit;

    Screen('FillRect', cfg.screen.win, cfg.color.background, cfg.screen.winRect);

    DrawFormattedText(cfg.screen.win, sprintf(cfg.hit, hit, numel(isTarget)), ...
                      'center', cfg.screen.winRect(4) / 4, [0 255 0]);

    DrawFormattedText(cfg.screen.win, sprintf(cfg.miss, miss, numel(isTarget)), ...
                      'center', cfg.screen.winRect(4) / 2, [255 0 0]);

    DrawFormattedText(cfg.screen.win, sprintf(cfg.fA, fa), ...
                      'center', cfg.screen.winRect(4) * 3 / 4, [255 0 0]);

    Screen('Flip', cfg.screen.win);

end
