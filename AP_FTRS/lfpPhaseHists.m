function out = lfpPhaseHists(ap_session, ap_data, event_names)
    delta = cell(size(ap_session,1),1);
    theta = cell(size(ap_session,1),1);
    alpha = cell(size(ap_session,1),1);
    beta = cell(size(ap_session,1),1);
    spon_delta = cell(size(ap_session,1),1);
    spon_theta = cell(size(ap_session,1),1);
    spon_alpha = cell(size(ap_session,1),1);
    spon_beta = cell(size(ap_session,1),1);
    for c = 1:size(ap_session,1)
        for t = 1:size(ap_data,1)
            delta{c} = [delta{c}, ap_data(t,:).spiking_data{1}(c,:).spike_delta_phase{1}];
            theta{c} = [theta{c}, ap_data(t,:).spiking_data{1}(c,:).spike_theta_phase{1}];
            alpha{c} = [alpha{c}, ap_data(t,:).spiking_data{1}(c,:).spike_alpha_phase{1}];
            beta{c} = [beta{c}, ap_data(t,:).spiking_data{1}(c,:).spike_beta_phase{1}];
            for e = 1:length(event_names)
                if ~all(cellfun(@isempty, ap_data(t,:).spiking_data{1}.(strcat(event_names{e}, '_aligned_spike_times'))))
                    variable_name = strcat(event_names{e}, '_aligned_spike_times');
                    spon_inds = find(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                        ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
                    spon_delta{c} = [spon_delta{c}, ap_data(t,:).spiking_data{1}(c,:).spike_delta_phase{1}(spon_inds)];
                    spon_theta{c} = [spon_theta{c}, ap_data(t,:).spiking_data{1}(c,:).spike_theta_phase{1}(spon_inds)];
                    spon_alpha{c} = [spon_alpha{c}, ap_data(t,:).spiking_data{1}(c,:).spike_alpha_phase{1}(spon_inds)];
                    spon_beta{c} = [spon_beta{c}, ap_data(t,:).spiking_data{1}(c,:).spike_beta_phase{1}(spon_inds)];
                end
            end
        end
    end
    out = [ap_session, table(delta, theta, alpha, beta, spon_delta, spon_theta, spon_alpha, spon_beta, ...
        'VariableNames', {'delta_spike_phases', 'theta_spike_phases', 'alpha_spike_phases', 'beta_spike_phases', ...
        'spon_delta_spike_phases', 'spon_theta_spike_phases', 'spon_alpha_spike_phases', 'spon_beta_spike_phases'})];
end