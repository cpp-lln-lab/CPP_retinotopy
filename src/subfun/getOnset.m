% (C) Copyright 2020 Remi Gau

function [inputStructure, isOnset] = getOnset(isOnset, inputStructure, cfg, rft)
    % isOnset = getOnset(isOnset, inputStructure, cfg, rft)
    %

    if isOnset
        inputStructure.onset = rft - cfg.experimentStart;
        isOnset = false;
    end
end
