function out = instantaneousAlphaPhase(lfp_data)
    ap_cell = cell(size(lfp_data,1),1);
    for i = 1:size(lfp_data,1)
        alpha_phase = zeros(size(lfp_data(i,:).lfp{1}));
        for j = 1:size(alpha_phase)
            y = bandpassFilter(lfp_data(i,:).lfp{1}(j,:), 8, 12, 500);
            alpha_phase(j,:) = angle(hilbert(y));
        end
        ap_cell{i} = alpha_phase;
    end
    out = [lfp_data, table(ap_cell, 'VariableNames', {'alpha_phase'})];
end