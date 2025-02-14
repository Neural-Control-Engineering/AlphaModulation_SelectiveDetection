function plotLFPphase(ap_session)
    bands = {'delta', 'theta', 'alpha', 'beta'};
    out_dir = '~/neuralctrl/users/ck3217/Selective-Attention/Figures/expert_lfp_phase_of_spikes/';
    for c = 1:size(ap_session,1)
        session_id = ap_session(c,:).session_id{1};
        sesh_parts = strsplit(session_id, '_');
        date = sesh_parts{1};
        cluster_id = ap_session(c,:).cluster_id;
        class = ap_session(c,:).waveform_class{1};
        for b = 1:length(bands)
            fig = figure('Visible', 'off');
            variable_name = strcat(bands{b}, '_spike_phases');
            hist(ap_session(c,:).(variable_name){1})
            xlabel(strcat(bands{b}, ' phase'))
            ylabel('Spike Count')
            filename = strcat(out_dir, bands{b}, '/', session_id, '_cluster-', num2str(cluster_id), '.png');
            title(sprintf('%s, cluster %i, %s', date, cluster_id, class));
            saveas(fig, filename)
            close()
            fig = figure('Visible', 'off');
            variable_name = strcat('spon_', bands{b}, '_spike_phases');
            hist(ap_session(c,:).(variable_name){1})
            xlabel(strcat(bands{b}, ' phase'))
            ylabel('Spike Count')
            filename = strcat(out_dir, 'spon_', bands{b}, '/', session_id, '_cluster-', num2str(cluster_id), '.png');
            title(sprintf('%s, cluster %i, %s', date, cluster_id, class));
            saveas(fig, filename)
            close()
        end
    end
end



            
