% (C) Copyright 2020 Remi Gau

function plotResults(data, cfg)

    if isempty(data)
        return
    end

    close all;

    figure(1);

    hold on;

    IsStim = data(:, 2) < 3;
    IsTarget = data(:, 2) == 3;
    IsResp = data(:, 2) == 4;

    % plot stim
    switch cfg.Apperture
        case 'Ring'
            plot(data(IsStim, 1), data(IsStim, 9));
            plot(data(IsStim, 1), data(IsStim, 10));
            Legend = {'outer', 'inner', 'target', 'response'};

        case 'Wedge'
            plot(data(IsStim, 1), data(IsStim, 4));
            Legend = {'angle', 'target', 'response'};
    end

    % plot target and responses
    stem(data(IsTarget, 1), 5 * ones(sum(IsTarget), 1), '-k');
    stem(data(IsResp, 1), 5 * ones(sum(IsResp), 1), '-r');

    legend(Legend);

    plot([0 data(end, 1)], [0 0], '-k');

    axis tight;

    xlabel('time (seconds)');

end
