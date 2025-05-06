function [acf, binCenters] = compute_autocorrelogram(spikeTimes, binSize, maxLag)
    % Compute the autocorrelogram of spike times
    %
    % Inputs:
    %   spikeTimes - vector of spike times (in seconds)
    %   binSize    - bin size for histogram (in seconds)
    %   maxLag     - maximum lag to consider (in seconds)
    %
    % Outputs:
    %   acf        - autocorrelogram counts
    %   binCenters - centers of the histogram bins

    % Ensure column vector
    spikeTimes = spikeTimes(:);
    nSpikes = length(spikeTimes);

    % Initialize array for time differences
    timeDiffs = [];

    % Compute all pairwise time differences
    for i = 1:nSpikes
        diffs = spikeTimes - spikeTimes(i);
        % Exclude zero lag
        diffs(diffs == 0) = [];
        timeDiffs = [timeDiffs; diffs];
    end

    % Define bin edges
    edges = -maxLag:binSize:maxLag;
    binCenters = edges(1:end-1) + binSize/2;

    % Compute histogram
    acf = histcounts(timeDiffs, edges);
end
