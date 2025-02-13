function out = avgBaselineFRbyOutcome(slrt_data, npxls_data, variable_names, outcome)
    npxls_data = npxls_data(strcmp(slrt_data.categorical_outcome, outcome),:);
    cluster_info = npxls_data(1,:).spiking_data{1};

    % compute avg baseline across trials for each baseline type
    out = [];
    for v = 1:length(variable_names)
        variable_name = variable_names{v};
        avg_baseline = cell(size(cluster_info,1),1);
        for i = 1:size(cluster_info, 1)
            baseline_mat = zeros(size(npxls_data,1), 1);
            for j = 1:size(npxls_data,1)
                baseline_mat(j) = npxls_data(j,:).spiking_data{1}(i,:).(variable_name){1};
            end
            avg_baseline{i} = mean(baseline_mat);
        end
        vn_parts = strsplit(variable_name, 'baselineFR');
        col_title = strcat(vn_parts{1}, 'avg_baselineFR');
        if isempty(out)
            out = table(cluster_info.cluster_id, avg_baseline, 'VariableNames', {'cluster_id', col_title});
        else
            out = [out, table(avg_baseline, 'VariableNames', {col_title})];
        end
    end

end