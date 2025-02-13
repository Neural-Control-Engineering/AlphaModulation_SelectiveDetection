function out = PSTHs(npxls_data, t0, t1, bin_size)
    edges = t0:bin_size:t1;
    out = npxls_data;
    for t = 1:size(out,1)
        spiking_data = out(t,:).spiking_data{1};
        cols = [];
        for vn = 1:length(spiking_data.Properties.VariableNames)
            variable_name = spiking_data.Properties.VariableNames{vn};
            if contains(variable_name, 'aligned_spike_times') && ~all(cellfun(@isempty,spiking_data.(variable_name)))
                cluster_spike_times = spiking_data.(variable_name);
                psths = cell(length(cluster_spike_times),1);
                for i = 1:length(cluster_spike_times)
                    if ~isempty(cluster_spike_times{i})
                        psths{i} = histcounts(cluster_spike_times{i}, edges);
                    else
                        psths{i} = zeros(1,length(edges)-1);
                    end
                end
                vn_parts = strsplit(variable_name, 'spike');
                col_title = strcat(vn_parts{1}, 'psth');
                if isempty(cols)
                    cols = table(psths, 'VariableNames', {col_title});
                else
                    cols = [cols, table(psths, 'VariableNames', {col_title})];
                end
            end
        end
        out(t,:).spiking_data{1} = [out(t,:).spiking_data{1}, cols];
    end
end