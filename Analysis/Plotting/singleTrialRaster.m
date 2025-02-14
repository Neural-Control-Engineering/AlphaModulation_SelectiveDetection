function singleTrialRaster(ap_data, trial_number, probe)
    tmp = assignRegions(ap_data(trial_number,:).spiking_data{1}, probe.regMap);
    % tmp = tmp(strcmp(tmp.quality, 'good'), :);
    figure();
    hold on 
    cluster_count = 1;
    for c = 1:size(tmp,1)
        if strcmp(tmp(c,:).region, 'BLAp') || strcmp(tmp(c,:).region, 'LA')
            plot(tmp(c,:).left_trigger_aligned_spike_times{1}, ...
                repmat(cluster_count,1,length(tmp(c,:).left_trigger_aligned_spike_times{1})), ...
                'k|')
            cluster_count = cluster_count + 1;
        elseif strcmp(tmp(c,:).region, 'STR') || strcmp(tmp(c,:).region, 'CP')
            plot(tmp(c,:).left_trigger_aligned_spike_times{1}, ...
                repmat(cluster_count,1,length(tmp(c,:).left_trigger_aligned_spike_times{1})), ...
                'r|')
            cluster_count = cluster_count + 1;
        elseif startsWith(tmp(c,:).region, 'SS')
            plot(tmp(c,:).left_trigger_aligned_spike_times{1}, ...
                repmat(cluster_count,1,length(tmp(c,:).left_trigger_aligned_spike_times{1})), ...
                'b|')
            cluster_count = cluster_count + 1;
        end
    end
    yticks([])
    xlim([-3,5])
end