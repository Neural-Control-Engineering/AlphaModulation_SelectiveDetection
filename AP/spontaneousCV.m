function out = spontaneousCV(ap_data, variable_names)
    out = ap_data;
    for t = 1:size(out,1)
        spiking_data = out(t,:).spiking_data{1};
        for vn = 1:length(variable_names)
            variable_name = variable_names{vn};
            if contains(variable_name, 'aligned_spike_times')
                if ~all(cellfun(@isempty, spiking_data.(variable_name)))
                    cvs = cell(size(spiking_data,1),1);
                    for c = 1:size(spiking_data,1)
                        spike_times = spiking_data(c,:).(variable_name){1};
                        spike_times = spike_times(spike_times >= -3 & spike_times < 0);
                        isis = diff(spike_times);
                        cvs{c} = std(isis) / mean(isis);
                    end
                    vn_parts = strsplit(variable_name, 'spike');
                    col_title = strcat(vn_parts{1}, 'spontaneousCV');
                    out(t,:).spiking_data{1} = ...
                        [out(t,:).spiking_data{1}, ...
                        table(cvs, 'VariableNames', {col_title})];
                % else
                %     cvs = cell(size(spiking_data,1),1);
                %     vn_parts = strsplit(variable_name, 'spike');
                %     col_title = strcat(vn_parts{1}, 'spontaneousCV');
                %     out(t,:).spiking_data{1} = ...
                %         [out(t,:).spiking_data{1}, ...
                %         table(cvs, 'VariableNames', {col_title})];
                end
            end
        end
    end
end