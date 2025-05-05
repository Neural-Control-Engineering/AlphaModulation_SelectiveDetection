function out = lfpPhaseHistSponLicking(ap_session, ap_data, slrt_data, event_names)
    spon_delta_lick = cell(size(ap_session,1),1);
    spon_theta_lick = cell(size(ap_session,1),1);
    spon_alpha_lick = cell(size(ap_session,1),1);
    spon_beta_lick = cell(size(ap_session,1),1);
    spon_delta_nolick = cell(size(ap_session,1),1);
    spon_theta_nolick = cell(size(ap_session,1),1);
    spon_alpha_nolick = cell(size(ap_session,1),1);
    spon_beta_nolick = cell(size(ap_session,1),1);
    contains_lick = spontaneousLicks(slrt_data);

    for c = 1:size(ap_session,1)
        for t = 1:size(ap_data,1)
            for e = 1:length(event_names)
                if ~all(cellfun(@isempty, ap_data(t,:).spiking_data{1}.(strcat(event_names{e}, '_aligned_spike_times'))))
                    variable_name = strcat(event_names{e}, '_aligned_spike_times');
                    spon_inds = find(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                        ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
                    if contains_lick(t)
                        spon_delta_lick{c} = [spon_delta_lick{c}, ap_data(t,:).spiking_data{1}(c,:).spike_delta_phase{1}(spon_inds)];
                        spon_theta_lick{c} = [spon_theta_lick{c}, ap_data(t,:).spiking_data{1}(c,:).spike_theta_phase{1}(spon_inds)];
                        spon_alpha_lick{c} = [spon_alpha_lick{c}, ap_data(t,:).spiking_data{1}(c,:).spike_alpha_phase{1}(spon_inds)];
                        spon_beta_lick{c} = [spon_beta_lick{c}, ap_data(t,:).spiking_data{1}(c,:).spike_beta_phase{1}(spon_inds)];
                    else
                        spon_delta_nolick{c} = [spon_delta_nolick{c}, ap_data(t,:).spiking_data{1}(c,:).spike_delta_phase{1}(spon_inds)];
                        spon_theta_nolick{c} = [spon_theta_nolick{c}, ap_data(t,:).spiking_data{1}(c,:).spike_theta_phase{1}(spon_inds)];
                        spon_alpha_nolick{c} = [spon_alpha_nolick{c}, ap_data(t,:).spiking_data{1}(c,:).spike_alpha_phase{1}(spon_inds)];
                        spon_beta_nolick{c} = [spon_beta_nolick{c}, ap_data(t,:).spiking_data{1}(c,:).spike_beta_phase{1}(spon_inds)];
                    end
                end
            end
        end
    end
    out = [ap_session, table(spon_delta_lick, spon_theta_lick, spon_alpha_lick, spon_beta_lick, ...
        spon_delta_nolick, spon_theta_nolick, spon_alpha_nolick, spon_beta_nolick, ...
        'VariableNames', {'delta_spike_phases_lick', 'theta_spike_phases_lick', 'alpha_spike_phases_lick', 'beta_spike_phases_lick', ...
        'delta_spike_phases_nolick', 'theta_spike_phases_nolick', 'alpha_spike_phases_nolick', 'beta_spike_phases_nolick'})];
end