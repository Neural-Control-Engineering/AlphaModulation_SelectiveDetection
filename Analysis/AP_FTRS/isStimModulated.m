function out = isStimModulated(npxls_session, ap_data, events)
    is_stim_mod = cell(size(npxls_session,1),length(events));
    for i = 1:size(npxls_session,1)
        baseline_frs = cell(1,length(events));
        evoked_frs = cell(1,length(events));
        for j = 1:size(ap_data,1)
            for e = 1:length(events)
                vnb = strcat(events{e}, '_aligned_baselineFR');
                vne = strcat(events{e}, '_aligned_evokedFR');
                if ~isempty(ap_data(j,:).spiking_data{1}.(vnb){i})
                    baseline_frs{e} = [baseline_frs{e}, ap_data(j,:).spiking_data{1}.(vnb){i}];
                    evoked_frs{e} = [evoked_frs{e}, ap_data(j,:).spiking_data{1}.(vne){i}];
                end
            end
        end
        for e = 1:length(events)
            if kstest(baseline_frs{e}) || kstest(evoked_frs{e})
                p = ranksum(baseline_frs{e}, evoked_frs{e});
            else
                [~, p] = ttest(baseline_frs{e}, evoked_frs{e});
            end
            if p < (0.05/length(baseline_frs{e})) && mean(baseline_frs{e}) > mean(evoked_frs{e})
                is_stim_mod{i,e} = -1;
            elseif p < (0.05/length(baseline_frs{e}))
                is_stim_mod{i,e} = 1;
            else
                is_stim_mod{i,e} = 0;
            end
        end
    end
    out = npxls_session;
    for i = 1:length(events)
        vn = strcat('is_', events{i}, '_stim_modulated');
        out = [out, table(is_stim_mod(:,i), 'VariableNames', {vn})];
    end
    
end