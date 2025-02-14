function MI = compute_modulation_index(amplitude_counts)
    % COMPUTE_MODULATION_INDEX Calculate the modulation index from binned amplitude counts.
    %   MI = COMPUTE_MODULATION_INDEX(amplitude_counts) computes the modulation
    %   index (MI) based on the observed amplitude counts in each phase bin.
    %
    %   Input:
    %       amplitude_counts - A vector containing the counts or mean amplitudes
    %                         in each phase bin.
    %
    %   Output:
    %       MI - The modulation index, a measure of phase-amplitude coupling.

    % Ensure the input is a column vector
    amplitude_counts = amplitude_counts(:);

    % Number of phase bins
    num_bins = length(amplitude_counts);

    % Normalize the amplitude counts to obtain a probability distribution
    P = amplitude_counts / sum(amplitude_counts);
    if any(P == 0)
        P(P == 0) = 0.0001;
    end

    % Compute the Kullback-Leibler (KL) divergence between P and the uniform distribution
    uniform_dist = ones(num_bins, 1) / num_bins;
    KL_divergence = sum(P .* log(P ./ uniform_dist));

    % Compute the modulation index (MI)
    MI = KL_divergence / log(num_bins);

end
