function variable_names = getVariableNames(cluster_info, variable_name_part)
    variable_names = {};
    count = 1;
    for i = 1:length(cluster_info.Properties.VariableNames)
        vn = cluster_info.Properties.VariableNames{i};
        if contains(vn, variable_name_part)
            variable_names{count} = vn;
            count = count + 1;
        end
    end
end