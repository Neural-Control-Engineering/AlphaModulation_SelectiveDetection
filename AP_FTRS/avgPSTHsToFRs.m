function out = avgPSTHsToFRs(npxls_session, psth_bin_size, gauss_bin_size)
    variable_names = npxls_session.Properties.VariableNames;
    out = npxls_session;
    for vn = 1:length(variable_names)
        if contains(variable_names{vn}, 'avg_psth')
            frs = cell(size(npxls_session,1),1);
            for i = 1:size(npxls_session,1)
                y = npxls_session(i,:).(variable_names{vn}){1} ./ psth_bin_size;
                frs{i} = y; %smoothdata(y, 'gaussian', gauss_bin_size);
            end
            col_title = strrep(variable_names{vn}, 'psth', 'fr');
            out = [out, table(frs, 'VariableNames', {col_title})];
        end
    end
end