function out = instantaneousBetaPower(lfp_data)
    ap_cell = cell(size(lfp_data,1),1);
    for i = 1:size(lfp_data,1)
        beta_power = zeros(size(lfp_data(i,:).lfp{1}));
        for j = 1:size(beta_power)
            y = bandpassFilter(lfp_data(i,:).lfp{1}(j,:), 13, 30, 500);
            beta_power(j,:) = abs(hilbert(y)).^2;
        end
        ap_cell{i} = beta_power;
    end
    out = [lfp_data, table(ap_cell, 'VariableNames', {'beta_power'})];
end

