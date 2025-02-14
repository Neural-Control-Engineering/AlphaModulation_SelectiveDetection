function out = ERPbyLeftMinusRight(lfp_session, lfp_data, slrt_data, t0, t1)
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    actions = {{'Hit', 'FA'}, {'Miss', 'CR'}};
    performance = {{'Hit', 'CR'}, {'Miss', 'FA'}};
    out = lfp_session;
    for i = 1:length(outcomes)
        event_name = strcat('left_trigger_aligned_lfp');
        lmr = unique(cell2mat(slrt_data.left_minus_right_amp));
        lmr = lmr(~isnan(lmr));
        for a = 1:length(lmr)
            amp = lmr(a);
            tmp_lfp = lfp_data(cell2mat(slrt_data.left_minus_right_amp) == amp, :);
            col_title = sprintf('amp_%i_aligned_erp', amp);
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