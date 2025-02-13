function out = instantaneousLowGammaPhase(lfp_data)
    ap_cell = cell(size(lfp_data,1),1);
    for i = 1:size(lfp_data,1)
        low_gamma_phase = zeros(size(lfp_data(i,:).lfp{1}));
        for j = 1:size(low_gamma_phase)
            y = bandpassFilter(lfp_data(i,:).lfp{1}(j,:), 30, 50, 500);
            low_gamma_phase(j,:) = angle(hilbert(y));
        end
        ap_cell{i} = low_gamma_phase;
    end
    out = [lfp_data, table(ap_cell, 'VariableNames', {'low_gamma_phase'})];
end