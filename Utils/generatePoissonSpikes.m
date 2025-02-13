function spikeTimes = generatePoissonSpikes(meanFiringRate, duration)
    % generatePoissonSpikes generates spike times for a neuron modeled by a Poisson process.
    %
    % Inputs:
    %   meanFiringRate - Mean firing rate in Hz (spikes per second)
    %   duration       - Simulation duration in seconds
    %
    % Output:
    %   spikeTimes     - Vector of spike times in seconds

    % Initialize variables
    spikeTimes = [];
    currentTime = 0;

    % Loop to generate spikes until the current time exceeds the duration
    while currentTime < duration
        % Generate the next inter-spike interval (ISI) from an exponential distribution
        isi = exprnd(1 / meanFiringRate);

        % Update the current time by adding the ISI
        currentTime = currentTime + isi;

        % If the updated time is within the simulation duration, record the spike time
        if currentTime < duration
            spikeTimes = [spikeTimes; currentTime]; %#ok<AGROW>
        end
    end
end
