function out = instantaneousDeltaPhase(lfp_data)
    ap_cell = cell(size(lfp_data,1),1);
    for i = 1:size(lfp_data,1)
        delta_phase = zeros(size(lfp_data(i,:).lfp{1}));
        for j = 1:size(delta_phase)
            y = bandpassFilter(lfp_data(i,:).lfp{1}(j,:), 1, 4, 500);
            delta_phase(j,:) = angle(hilbert(y));
        end
        ap_cell{i} = delta_phase;
    end
    out = [lfp_data, table(ap_cell, 'VariableNames', {'delta_phase'})];
end