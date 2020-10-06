% (C) Copyright 2020 Remi Gau

function [inputStructure, isOffset] = saveOnOffset(isOffset, inputStructure, cfg, rft)

    if isOffset

        inputStructure.duration = (rft - cfg.experimentStart) - inputStructure.onset;
        inputStructure.keyName = 'n/a';

        saveEventsFile('save', cfg, inputStructure);

        isOffset = false;
    end

end
