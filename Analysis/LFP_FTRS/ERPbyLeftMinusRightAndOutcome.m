function out = ERPbyLeftMinusRightAndOutcome(lfp_session, lfp_data, slrt_data, t0, t1)
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    out = lfp_session;
    event_name = 'left_trigger_aligned_lfp';
    for i = 1:length(outcomes)
        outcome = outcomes{i};
        oc_lfp = lfp_data(strcmp(slrt_data.categorical_outcome, outcome), :);
        oc_slrt = slrt_data(strcmp(slrt_data.categorical_outcome, outcome), :);
        lmr = unique(cell2mat(oc_slrt.left_minus_right_amp));
        lmr = lmr(~isnan(lmr));
        for a = 1:length(lmr)
            amp = lmr(a);
            col_title = sprintf('amp_%s_aligned_erp_%s', amp, outcome);
            tmp_lfp = oc_lfp(cell2mat(oc_slrt.left_minus_right_amp) == amp, :);             
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
            out = [out, table(erps, 'VariableNames', {col_title})];
        end
    end
end