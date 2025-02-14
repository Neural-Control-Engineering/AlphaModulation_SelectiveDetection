function out = instantaneousHighGammaPhase(lfp_data)
    ap_cell = cell(size(lfp_data,1),1);
    for i = 1:size(lfp_data,1)
        high_gamma_phase = zeros(size(lfp_data(i,:).lfp{1}));
        for j = 1:size(high_gamma_phase)
            y = bandpassFilter(lfp_data(i,:).lfp{1}(j,:), 50, 100, 500);
            high_gamma_phase(j,:) = angle(hilbert(y));
        end
        ap_cell{i} = high_gamma_phase;
    end
    out = [lfp_data, table(ap_cell, 'VariableNames', {'high_gamma_phase'})];
end