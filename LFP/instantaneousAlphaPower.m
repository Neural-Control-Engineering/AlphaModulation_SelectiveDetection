function out = instantaneousAlphaPower(lfp_data)
    ap_cell = cell(size(lfp_data,1),1);
    for i = 1:size(lfp_data,1)
        alpha_power = zeros(size(lfp_data(i,:).lfp{1}));
        for j = 1:size(alpha_power)
            y = bandpassFilter(lfp_data(i,:).lfp{1}(j,:), 8, 12, 500);
            alpha_power(j,:) = abs(hilbert(y)).^2;
        end
        ap_cell{i} = alpha_power;
    end
    out = [lfp_data, table(ap_cell, 'VariableNames', {'alpha_power'})];
end

