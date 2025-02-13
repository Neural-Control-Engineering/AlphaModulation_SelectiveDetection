function out = evokedLfpPhaseHists(ap_session, ap_data, event_names)
    evoked_delta = cell(size(ap_session,1),1);
    evoked_theta = cell(size(ap_session,1),1);
    evoked_alpha = cell(size(ap_session,1),1);
    evoked_beta = cell(size(ap_session,1),1);
    for c = 1:size(ap_session,1)
        for t = 1:size(ap_data,1)
            for e = 1:length(event_names)
                if ~all(cellfun(@isempty, ap_data(t,:).spiking_data{1}.(strcat(event_names{e}, '_aligned_spike_times'))))
                    variable_name = strcat(event_names{e}, '_aligned_spike_times');
                    evoked_inds = find(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > 0 & ...
                        ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 5);
                    evoked_delta{c} = [evoked_delta{c}, ap_data(t,:).spiking_data{1}(c,:).spike_delta_phase{1}(evoked_inds)];
                    evoked_theta{c} = [evoked_theta{c}, ap_data(t,:).spiking_data{1}(c,:).spike_theta_phase{1}(evoked_inds)];
                    evoked_alpha{c} = [evoked_alpha{c}, ap_data(t,:).spiking_data{1}(c,:).spike_alpha_phase{1}(evoked_inds)];
                    evoked_beta{c} = [evoked_beta{c}, ap_data(t,:).spiking_data{1}(c,:).spike_beta_phase{1}(evoked_inds)];
                end
            end
        end
    end
    out = [ap_session, table(evoked_delta, evoked_theta, evoked_alpha, evoked_beta, ...
        'VariableNames', {'evoked_delta_spike_phases', 'evoked_theta_spike_phases', 'evoked_alpha_spike_phases', 'evoked_beta_spike_phases'})];
end