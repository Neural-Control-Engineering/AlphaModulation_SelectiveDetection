function out = instantaneousThetaPower(lfp_data)
    ap_cell = cell(size(lfp_data,1),1);
    for i = 1:size(lfp_data,1)
        theta_power = zeros(size(lfp_data(i,:).lfp{1}));
        for j = 1:size(theta_power)
            y = bandpassFilter(lfp_data(i,:).lfp{1}(j,:), 4, 8, 500);
            theta_power(j,:) = abs(hilbert(y)).^2;
        end
        ap_cell{i} = theta_power;
    end
    out = [lfp_data, table(ap_cell, 'VariableNames', {'theta_power'})];
end

