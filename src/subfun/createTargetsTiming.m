% (C) Copyright 2020 Remi Gau

function targetsTimings = createTargetsTiming(cfg)

    TR = cfg.mri.repetitionTime;
    eventDuration = cfg.target.duration;
    cyclesPerExpmt = cfg.cyclesPerExpmt;
    volsPerCycle = cfg.volsPerCycle;

    e = TR:eventDuration:(cyclesPerExpmt * volsPerCycle * TR);
    tmp = rand(length(e), 1);
    targetsTimings = e(tmp < cfg.target.probability)';

    % remove events that are less than 1.5 seconds appart
    targetsTimings(find(diff(targetsTimings) < 1) + 1) = [];

end
