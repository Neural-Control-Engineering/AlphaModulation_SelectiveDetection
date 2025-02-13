function out = avgPSTHbyPrevAndCurrentOutcome(npxls_data, slrt_data, ap_data, outcome, edges)
    outcome_inds = find(strcmp(slrt_data.categorical_outcome, outcome));
    next_inds = outcome_inds + 1;
    next_inds = next_inds(next_inds < size(slrt_data,1));
    ap_data = ap_data(next_inds,:);
    slrt_data = slrt_data(next_inds,:);
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    out = npxls_data;
    if ~isempty(ap_data)

        for o = 1:length(outcomes)
            tmp_data = ap_data(strcmp(slrt_data.categorical_outcome, outcomes{o}), :);

            if ~isempty(tmp_data)
                cluster_info = tmp_data(1,:).spiking_data{1};

                % get relevant psths (stim and reward aligned where applicable)
                variable_names = {};
                count = 1;
                for t = 1:size(tmp_data,1)
                    cluster_info = tmp_data(t,:).spiking_data{1};
                    for i = 1:length(cluster_info.Properties.VariableNames)
                        vn = cluster_info.Properties.VariableNames{i};
                        if contains(vn, 'aligned_psth')  && ~all(cellfun(@isempty, cluster_info.(vn))) && ~any(strcmp(variable_names, vn))
                            variable_names{count} = vn;
                            count = count + 1;
                        end
                    end
                end

                % compute avg PSTH across trials for each PSTH type
                
                for v = 1:length(variable_names)
                    variable_name = variable_names{v};
                    avg_psths = cell(sum(strcmp(cluster_info.quality, 'good')),1);
                    count = 1;
                    for i = 1:size(cluster_info, 1)
                        if strcmp(cluster_info(i,:).quality, 'good')
                            psth_mat = [];
                            for j = 1:size(tmp_data,1)
                                if any(strcmp(tmp_data(j,:).spiking_data{1}.Properties.VariableNames, variable_name))
                                    if ~isempty(tmp_data(j,:).spiking_data{1}(i,:).(variable_name){1})
                                        psth_mat = [psth_mat; tmp_data(j,:).spiking_data{1}(i,:).(variable_name){1}];
                                    end
                                end
                            end
                            avg_psths{count} = mean(psth_mat, 1);
                            count = count + 1;
                        end
                    end
                    vn_parts = strsplit(variable_name, 'psth');
                    col_title = strcat(vn_parts{1}, outcomes{o}, '_psth_after', outcome);
                    out = [out, table(avg_psths, 'VariableNames', {col_title})];
                end
            end
        end
    else
        out = npxls_data;
    end
end