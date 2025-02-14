function out = evokedFRs(npxls_data, variable_names, t0, t1)
    out = npxls_data;
    for t = 1:size(out,1)
        spiking_data = out(t,:).spiking_data{1};
        for vn = 1:length(variable_names)
            variable_name = variable_names{vn};
            if contains(variable_name, 'aligned_spike_times')
                if ~all(cellfun(@isempty, spiking_data.(variable_name)))
                    baselines = cell(size(spiking_data,1),1);
                    for c = 1:size(spiking_data,1)
                        spike_times = spiking_data(c,:).(variable_name){1};
                        baselines{c} = sum(spike_times > t0 & spike_times < t1) / (t1-t0);
                    end
                    vn_parts = strsplit(variable_name, 'spike');
                    col_title = strcat(vn_parts{1}, 'evokedFR');
                    out(t,:).spiking_data{1} = ...
                        [out(t,:).spiking_data{1}, ...
                        table(baselines, 'VariableNames', {col_title})];
                else
                    baselines = cell(size(spiking_data,1),1);
                    vn_parts = strsplit(variable_name, 'spike');
                    col_title = strcat(vn_parts{1}, 'evokedFR');
                    out(t,:).spiking_data{1} = ...
                        [out(t,:).spiking_data{1}, ...
                        table(baselines, 'VariableNames', {col_title})];
                end
            else
                error('Variable needs to contain spike times\n')
            end
        end
    end
end