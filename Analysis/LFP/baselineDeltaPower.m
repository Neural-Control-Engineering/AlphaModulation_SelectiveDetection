function out = baselineDeltaPower(lfp_data, variable_names, t0, t1)
    out = lfp_data;
    for vn = 1:length(variable_names)
        variable_name = variable_names{vn};
        if contains(variable_name, 'aligned_lfp_time')
            baseline_delta_power = cell(size(lfp_data,1),1);
            for i = 1:size(lfp_data,1)    
                if ~all(cellfun(@isempty, lfp_data(i,:).(variable_name)))
                    baselines = zeros(size(lfp_data(i,:).lfp{1},1),1);
                    for j = 1:size(baselines, 1)
                        y = bandpassFilter(lfp_data(i,:).lfp{1}(j,:), 1, 4, 500);
                        delta_power = abs(hilbert(y)).^2;
                        delta_power = delta_power(:, ... 
                        lfp_data(i,:).(variable_name){1} >= t0 & ...
                        lfp_data(i,:).(variable_name){1} <= t1);
                        baselines(j) = mean(delta_power,2);
                    end
                    baseline_delta_power{i} = baselines;
                end
            end
            vn_parts = strsplit(variable_name, 'lfp');
            col_title = strcat(vn_parts{1}, 'baseline_delta_power');
            out = [out, table(baseline_delta_power, 'VariableNames', {col_title})];
        else
            error('Variable needs to contained aligned lfp\n')
        end
    end
end