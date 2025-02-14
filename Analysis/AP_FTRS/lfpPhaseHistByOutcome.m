function out = lfpPhaseHistByOutcome(ap_session, ap_data, slrt_data, event_names)
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    bands = {'delta', 'theta', 'alpha', 'beta'};
    for b = 1:length(bands)
        for o = 1:length(outcomes)
            expression = sprintf('%s_%s = cell(size(ap_session,1),1);', bands{b}, lower(outcomes{o}));
            eval(expression)
            expression = sprintf('spon_%s_%s = cell(size(ap_session,1),1);', bands{b}, lower(outcomes{o}));
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
                            spon_inds = find(tmp_ap(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                                tmp_ap(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
                            for b = 1:length(bands)
                                expression = sprintf('spon_%s_%s{c} = [spon_%s_%s{c}, tmp_ap(t,:).spiking_data{1}(c,:).spike_%s_phase{1}(spon_inds)];', ...
                                    bands{b}, lower(outcomes{o}), bands{b}, lower(outcomes{o}), bands{b});
                                eval(expression)
                            end
                            % spon_delta{c} = [spon_delta{c}, tmp_ap(t,:).spiking_data{1}(c,:).spike_delta_phase{1}(spon_inds)];
                            % spon_theta{c} = [spon_theta{c}, tmp_ap(t,:).spiking_data{1}(c,:).spike_theta_phase{1}(spon_inds)];
                            % spon_alpha{c} = [spon_alpha{c}, tmp_ap(t,:).spiking_data{1}(c,:).spike_alpha_phase{1}(spon_inds)];
                            % spon_beta{c} = [spon_beta{c}, tmp_ap(t,:).spiking_data{1}(c,:).spike_beta_phase{1}(spon_inds)];
                        end
                    end
                end
            end
        end
    end

    out = [ap_session, table(delta_hit, theta_hit, alpha_hit, beta_hit, ...
        delta_miss, theta_miss, alpha_miss, beta_miss, ...
        delta_cr, theta_cr, alpha_cr, beta_cr, ...
        delta_fa, theta_fa, alpha_fa, beta_fa, ...
        spon_delta_hit, spon_theta_hit, spon_alpha_hit, spon_beta_hit, ...
        spon_delta_miss, spon_theta_miss, spon_alpha_miss, spon_beta_miss, ...
        spon_delta_cr, spon_theta_cr, spon_alpha_cr, spon_beta_cr, ...
        spon_delta_fa, spon_theta_fa, spon_alpha_fa, spon_beta_fa, ...
        'VariableNames', {'delta_spike_phases_hit', 'theta_spike_phases_hit', 'alpha_spike_phases_hit', 'beta_spike_phases_hit', ...
        'delta_spike_phases_miss', 'theta_spike_phases_miss', 'alpha_spike_phases_miss', 'beta_spike_phases_miss', ...
        'delta_spike_phases_cr', 'theta_spike_phases_cr', 'alpha_spike_phases_cr', 'beta_spike_phases_cr', ...
        'delta_spike_phases_fa', 'theta_spike_phases_fa', 'alpha_spike_phases_fa', 'beta_spike_phases_fa', ...
        'spon_delta_spike_phases_hit', 'spon_theta_spike_phases_hit', 'spon_alpha_spike_phases_hit', 'spon_beta_spike_phases_hit', ...
        'spon_delta_spike_phases_miss', 'spon_theta_spike_phases_miss', 'spon_alpha_spike_phases_miss', 'spon_beta_spike_phases_miss', ...
        'spon_delta_spike_phases_cr', 'spon_theta_spike_phases_cr', 'spon_alpha_spike_phases_cr', 'spon_beta_spike_phases_cr', ...
        'spon_delta_spike_phases_fa', 'spon_theta_spike_phases_fa', 'spon_alpha_spike_phases_fa', 'spon_beta_spike_phases_fa'})];
end