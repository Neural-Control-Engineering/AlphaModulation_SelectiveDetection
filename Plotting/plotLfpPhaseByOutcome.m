function plotLfpPhaseByOutcome(ap_session)
    bands = {'delta', 'theta', 'alpha', 'beta'};
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    out_dir = '~/neuralctrl/users/ck3217/Selective-Attention/Figures/expert_lfp_phase_of_spikes/';
    for c = 1:size(ap_session,1)
        session_id = ap_session(c,:).session_id{1};
        sesh_parts = strsplit(session_id, '_');
        date = sesh_parts{1};
        cluster_id = ap_session(c,:).cluster_id;
        class = ap_session(c,:).waveform_class{1};
        for b = 1:length(bands)
            fig = figure('Visible', 'off');
            tl = tiledlayout(1,length(outcomes));
            axs = zeros(1,length(outcomes));
            for o = 1:length(outcomes)
                axs(o) =nexttile;
                variable_name = strcat(bands{b}, '_spike_phases_', lower(outcomes{o}));
                hist(ap_session(c,:).(variable_name){1})
                title(outcomes{o})
            end
            xlabel(tl,strcat(bands{b}, ' phase'))
            ylabel(tl, 'Spike Count')
            title(tl, sprintf('%s, cluster %i, %s', date, cluster_id, class));
            filename = strcat(out_dir, bands{b}, '_byOutcome/', session_id, '_cluster-', num2str(cluster_id), '.png');
            saveas(fig, filename)
            close();

            fig = figure('Visible', 'off');
            tl = tiledlayout(1,length(outcomes));
            axs = zeros(1,length(outcomes));
            for o = 1:length(outcomes)
                axs(o) =nexttile;
                variable_name = strcat('spon_', bands{b}, '_spike_phases_', lower(outcomes{o}));
                hist(ap_session(c,:).(variable_name){1})
                title(outcomes{o})
            end
            xlabel(tl,strcat(bands{b}, ' phase'))
            ylabel(tl, 'Spike Count')
            title(tl, sprintf('%s, cluster %i, %s', date, cluster_id, class));
            filename = strcat(out_dir, 'spon_', bands{b}, '_byOutcome/', session_id, '_cluster-', num2str(cluster_id), '.png');
            saveas(fig, filename)
            close();
        end
    end
end



            
