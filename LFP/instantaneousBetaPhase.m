function out = instantaneousBetaPhase(lfp_data)
    ap_cell = cell(size(lfp_data,1),1);
    for i = 1:size(lfp_data,1)
        beta_phase = zeros(size(lfp_data(i,:).lfp{1}));
        for j = 1:size(beta_phase)
            y = bandpassFilter(lfp_data(i,:).lfp{1}(j,:), 13, 30, 500);
            beta_phase(j,:) = angle(hilbert(y));
        end
        ap_cell{i} = beta_phase;
    end
    out = [lfp_data, table(ap_cell, 'VariableNames', {'beta_phase'})];
end