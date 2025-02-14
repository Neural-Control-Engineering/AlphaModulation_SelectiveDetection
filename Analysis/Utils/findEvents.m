function eventIndices = findEvents(signal, time, threshold, minEventLength, minInterEventInterval, direction)
    % Ensure inputs are column vectors
    signal = signal(:);
    time = time(:);

    % Validate the 'direction' input
    if ~ismember(direction, {'above', 'below'})
        error("Invalid direction. Use 'above' or 'below'.");
    end

    % Identify where the signal meets the threshold condition
    if strcmp(direction, 'above')
        thresholdCrossing = signal > threshold;
    else
        thresholdCrossing = signal < threshold;
    end

    % Find the start and end indices of these regions
    thresholdCrossing = [false; thresholdCrossing; false];
    diffThreshold = diff(thresholdCrossing);
    eventStarts = find(diffThreshold == 1);
    eventEnds = find(diffThreshold == -1) - 1;

    % Filter out events shorter than the minimum event length
    eventDurations = time(eventEnds) - time(eventStarts);
    validEvents = eventDurations >= minEventLength;
    eventStarts = eventStarts(validEvents);
    eventEnds = eventEnds(validEvents);

    % Merge events separated by less than the minimum inter-event interval
    i = 1;
    while i < length(eventStarts)
        if time(eventStarts(i + 1)) - time(eventEnds(i)) < minInterEventInterval
            eventEnds(i) = eventEnds(i + 1);
            eventStarts(i + 1) = [];
            eventEnds(i + 1) = [];
        else
            i = i + 1;
        end
    end

    % Return the start and end indices of the detected events
    eventIndices = [eventStarts, eventEnds];
end
