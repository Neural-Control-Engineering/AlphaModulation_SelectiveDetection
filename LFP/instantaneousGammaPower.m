function out = instantaneousGammaPower(lfp_data)
    ap_cell = cell(size(lfp_data,1),1);
    for i = 1:size(lfp_data,1)
        gamma_power = zeros(size(lfp_data(i,:).lfp{1}));
        for j = 1:size(gamma_power)
            y = bandpassFilter(lfp_data(i,:).lfp{1}(j,:), 30, 100, 500);
            gamma_power(j,:) = abs(hilbert(y)).^2;
        end
        ap_cell{i} = gamma_power;
    end
    out = [lfp_data, table(ap_cell, 'VariableNames', {'gamma_power'})];
end

