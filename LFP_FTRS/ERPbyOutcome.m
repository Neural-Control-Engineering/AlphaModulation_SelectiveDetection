function out = ERPbyOutcome(lfp_session, lfp_data, slrt_data, event_names, t0, t1)
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    actions = {{'Hit', 'FA'}, {'Miss', 'CR'}};
    performance = {{'Hit', 'CR'}, {'Miss', 'FA'}};
    out = lfp_session;
    for i = 1:length(outcomes)
        outcome = outcomes{i};
        tmp_lfp = lfp_data(strcmp(slrt_data.categorical_outcome, outcome), :);
        variable_names = tmp_lfp.Properties.VariableNames;
        for e = 1:length(event_names)
            if ~all(cellfun(@isempty,tmp_lfp.(strcat(event_names{e}, '_aligned_lfp_time'))))
                event_name = strcat(event_names{e}, '_aligned_lfp_time');
                col_title = strcat(event_names{e}, '_aligned_erp');
                erps = cell(size(lfp_session,1),1);
                erp_times = cell(size(lfp_session,1),1);
                for c = 1:size(lfp_session,1)
                    mat = {};
                    for t = 1:size(tmp_lfp,1)
                        mat{t,1} = tmp_lfp(t,:).lfp{1}(c, tmp_lfp(t,:).(event_name){1} > t0 & tmp_lfp(t,:).(event_name){1} < t1);
                    end
                    fin = min(cellfun(@size, mat, num2cell(repmat(2,length(mat),1))));
                    m = [];
                    for j = 1:length(mat)
                        m = [m; mat{j}(1:fin)];
                    end
                    if size(m,1) > 1
                        erps{c} = mean(m);
                    else
                        erps{c} = m;
                    end
                    time = linspace(t0, t1, size(m,2));
                    erp_times{c} = time;
                end
                out = [out, table(erps, 'VariableNames', {strcat(col_title, '_', outcome)})];
            end
        end
    end
end