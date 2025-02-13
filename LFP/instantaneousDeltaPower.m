function out = instantaneousDeltaPower(lfp_data)
    ap_cell = cell(size(lfp_data,1),1);
    for i = 1:size(lfp_data,1)
        delta_power = zeros(size(lfp_data(i,:).lfp{1}));
        for j = 1:size(delta_power)
            y = bandpassFilter(lfp_data(i,:).lfp{1}(j,:), 1, 4, 500);
            delta_power(j,:) = abs(hilbert(y)).^2;
        end
        ap_cell{i} = delta_power;
    end
    out = [lfp_data, table(ap_cell, 'VariableNames', {'delta_power'})];
end

