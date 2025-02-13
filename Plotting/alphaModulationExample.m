function alphaModulationExample(lfp_data, ap_data, trial_number, probe)
    lfp = lfp_data(trial_number,:).lfp{1};
    y = bandpassFilter(lfp(5,:), 4, 8, 500);
    time = lfp_data(trial_number,:).right_trigger_aligned_lfp_time{1};
    fig = figure();
    tl = tiledlayout(2,1);
    axs(1) = nexttile;
    plot(time, y, 'k')
    title('Alpha Oscillation')
    axs(2) = nexttile;
    tmp = assignRegions(ap_data(trial_number,:).spiking_data{1}, probe.regMap);
    hold on 
    cluster_count = 1;
    for c = 1:size(tmp,1)
        if strcmp(tmp(c,:).region, 'BLAp') || strcmp(tmp(c,:).region, 'LA')
            plot(tmp(c,:).right_trigger_aligned_spike_times{1}, ...
                repmat(cluster_count,1,length(tmp(c,:).right_trigger_aligned_spike_times{1})), ...
                'k|')
            cluster_count = cluster_count + 1;
        elseif strcmp(tmp(c,:).region, 'STR') || strcmp(tmp(c,:).region, 'CP')
            plot(tmp(c,:).right_trigger_aligned_spike_times{1}, ...
                repmat(cluster_count,1,length(tmp(c,:).right_trigger_aligned_spike_times{1})), ...
                'r|')
            cluster_count = cluster_count + 1;
        elseif startsWith(tmp(c,:).region, 'SS')
            plot(tmp(c,:).right_trigger_aligned_spike_times{1}, ...
                repmat(cluster_count,1,length(tmp(c,:).right_trigger_aligned_spike_times{1})), ...
                'b|')
            cluster_count = cluster_count + 1;
        end
    end
    % keyboard
    ylim([75,250])
    axes(axs(1))
    xlim([-3.0, 0])
    yticks([])
    xticks([])
    axes(axs(2))
    xlim([-3.0, 0])
    yticks([])
    title('Spiking Activity')
    xlabel(tl, 'Time (s)')
    saveas(fig, sprintf('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/FIG/example_%i.png',trial_number))
end