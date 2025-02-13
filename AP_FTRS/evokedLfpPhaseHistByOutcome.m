function out = evokedLfpPhaseHistByOutcome(ap_session, ap_data, slrt_data, event_names)
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    bands = {'delta', 'theta', 'alpha', 'beta'};
    for b = 1:length(bands)
        for o = 1:length(outcomes)
            expression = sprintf('%s_%s = cell(size(ap_session,1),1);', bands{b}, lower(outcomes{o}));
            eval(expression)
            expression = sprintf('evoked_%s_%s = cell(size(ap_session,1),1);', bands{b}, lower(outcomes{o}));
            eval(expression)
        end
    end

    for c = 1:size(ap_session,1)
        for o = 1:length(outcomes)
            tmp_ap = ap_data(strcmp(slrt_data.categorical_outcome, outcomes{o}),:);
            if ~isempty(tmp_ap)
                for t = 1:size(tmp_ap,1)
                    for b = 1:length(bands)
                        expression = sprintf('%s_%s{c} = [%s_%s{c}, tmp_ap(t,:).spiking_data{1}(c,:).spike_%s_phase{1}];', ...
                            bands{b}, lower(outcomes{o}), bands{b}, lower(outcomes{o}), bands{b});
                        eval(expression)
                    end
                    for e = 1:length(event_names)
                        if ~all(cellfun(@isempty, tmp_ap(t,:).spiking_data{1}.(strcat(event_names{e}, '_aligned_spike_times'))))
                            variable_name = strcat(event_names{e}, '_aligned_spike_times');
                            evoked_inds = find(tmp_ap(t,:).spiking_data{1}(c,:).(variable_name){1} > 0 & ...
                                tmp_ap(t,:).spiking_data{1}(c,:).(variable_name){1} < 5);
                            for b = 1:length(bands)
                                expression = sprintf('evoked_%s_%s{c} = [evoked_%s_%s{c}, tmp_ap(t,:).spiking_data{1}(c,:).spike_%s_phase{1}(evoked_inds)];', ...
                                    bands{b}, lower(outcomes{o}), bands{b}, lower(outcomes{o}), bands{b});
                                eval(expression)
                            end
                        end
                    end
                end
            end
        end
    end

    out = [ap_session, table(evoked_delta_hit, evoked_theta_hit, evoked_alpha_hit, evoked_beta_hit, ...
        evoked_delta_miss, evoked_theta_miss, evoked_alpha_miss, evoked_beta_miss, ...
        evoked_delta_cr, evoked_theta_cr, evoked_alpha_cr, evoked_beta_cr, ...
        evoked_delta_fa, evoked_theta_fa, evoked_alpha_fa, evoked_beta_fa, ...
        'VariableNames', {'evoked_delta_spike_phases_hit', 'evoked_theta_spike_phases_hit', 'evoked_alpha_spike_phases_hit', 'evoked_beta_spike_phases_hit', ...
        'evoked_delta_spike_phases_miss', 'evoked_theta_spike_phases_miss', 'evoked_alpha_spike_phases_miss', 'evoked_beta_spike_phases_miss', ...
        'evoked_delta_spike_phases_cr', 'evoked_theta_spike_phases_cr', 'evoked_alpha_spike_phases_cr', 'evoked_beta_spike_phases_cr', ...
        'evoked_delta_spike_phases_fa', 'evoked_theta_spike_phases_fa', 'evoked_alpha_spike_phases_fa', 'evoked_beta_spike_phases_fa'})];
end