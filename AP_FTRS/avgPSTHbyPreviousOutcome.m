function out = avgPSTHbyPreviousOutcome(npxls_data, slrt_data, ap_data, outcome, edges)
    outcome_inds = find(strcmp(slrt_data.categorical_outcome, outcome));
    next_inds = outcome_inds + 1;
    next_inds = next_inds(next_inds < size(slrt_data,1));
    ap_data = ap_data(next_inds,:);
    if ~isempty(ap_data)
        cluster_info = ap_data(1,:).spiking_data{1};

        % get relevant psths (stim and reward aligned where applicable)
        variable_names = {};
        count = 1;
        for t = 1:size(ap_data,1)
            cluster_info = ap_data(t,:).spiking_data{1};
            for i = 1:length(cluster_info.Properties.VariableNames)
                vn = cluster_info.Properties.VariableNames{i};
                if contains(vn, 'aligned_psth')  && ~all(cellfun(@isempty, cluster_info.(vn))) && ~any(strcmp(variable_names, vn))
                    variable_names{count} = vn;
                    count = count + 1;
                end
            end
        end

        % compute avg PSTH across trials for each PSTH type
        out = npxls_data;
        for v = 1:length(variable_names)
            variable_name = variable_names{v};
            avg_psths = cell(size(cluster_info,1),1);
            for i = 1:size(cluster_info, 1)
                psth_mat = [];
                for j = 1:size(ap_data,1)
                    if any(strcmp(ap_data(j,:).spiking_data{1}.Properties.VariableNames, variable_name))
                        if ~isempty(ap_data(j,:).spiking_data{1}(i,:).(variable_name){1})
                            psth_mat = [psth_mat; ap_data(j,:).spiking_data{1}(i,:).(variable_name){1}];
                        end
                    end
                end
                avg_psths{i} = mean(psth_mat, 1);
            end
            vn_parts = strsplit(variable_name, 'psth');
            col_title = strcat(vn_parts{1}, 'avg_psth_after', outcome);
            out = [out, table(avg_psths, 'VariableNames', {col_title})];
        end
    else
        out = npxls_data;
    end
end