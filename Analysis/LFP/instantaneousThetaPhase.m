function out = instantaneousThetaPhase(lfp_data)
    ap_cell = cell(size(lfp_data,1),1);
    for i = 1:size(lfp_data,1)
        theta_phase = zeros(size(lfp_data(i,:).lfp{1}));
        for j = 1:size(theta_phase)
            y = bandpassFilter(lfp_data(i,:).lfp{1}(j,:), 4, 8, 500);
            theta_phase(j,:) = angle(hilbert(y));
        end
        ap_cell{i} = theta_phase;
    end
    out = [lfp_data, table(ap_cell, 'VariableNames', {'theta_phase'})];
end