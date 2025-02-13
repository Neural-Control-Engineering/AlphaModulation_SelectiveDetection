function out = isStimModByOutcome(ap_session, ap_data, slrt_data, outcome, events)
    is_stim_mod = cell(size(ap_session,1),1);
    tmp_ap = ap_data(strcmp(slrt_data.categorical_outcome, outcome),:);
    if ~isempty(tmp_ap)
        for i = 1:size(ap_session,1)
            baseline_frs = zeros(size(tmp_ap,1),1);
            evoked_frs = zeros(size(tmp_ap,1),1);
            for j = 1:size(tmp_ap,1)
                for e = 1:length(events)
                    vnb = strcat(events{e}, '_aligned_baselineFR');
                    vne = strcat(events{e}, '_aligned_evokedFR');
                    if ~isempty(tmp_ap(j,:).spiking_data{1}.(vnb){i})
                        baseline_frs(j) = tmp_ap(j,:).spiking_data{1}.(vnb){i};
                        evoked_frs(j) = tmp_ap(j,:).spiking_data{1}.(vne){i};
                    end
                end
            end
            if kstest(baseline_frs) || kstest(evoked_frs)
                p = ranksum(baseline_frs, evoked_frs);
            else
                [~, p] = ttest(baseline_frs, evoked_frs);
            end
            if p < (0.05/length(baseline_frs)) && mean(baseline_frs) > mean(evoked_frs)
                is_stim_mod{i} = -1;
            elseif p < (0.05/length(baseline_frs))
                is_stim_mod{i} = 1;
            else
                is_stim_mod{i} = 0;
            end
        end
        out = ap_session;
        vn = strcat('is_stim_modulated_', outcome);
        out = [out, table(is_stim_mod, 'VariableNames', {vn})];
    else
        out = ap_session;
    end
    
end