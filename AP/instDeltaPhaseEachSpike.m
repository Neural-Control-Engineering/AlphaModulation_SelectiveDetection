function out = instDeltaPhaseEachSpike(ap_data, lfp_data)
    out = ap_data;
    for t = 1:size(ap_data,1)
        phases = cell(size(ap_data(t,:).spiking_data{1},1),1);
        for c = 1:size(ap_data(t,:).spiking_data{1},1)
            if ~isempty(ap_data(t,:).spiking_data{1}(c,:).left_trigger_aligned_spike_times{1})
                spike_times = ap_data(t,:).spiking_data{1}(c,:).left_trigger_aligned_spike_times{1};
                lfp_times = lfp_data(t,:).left_trigger_aligned_lfp_time{1};
            else
                spike_times = ap_data(t,:).spiking_data{1}(c,:).right_trigger_aligned_spike_times{1};
                lfp_times = lfp_data(t,:).right_trigger_aligned_lfp_time{1};
            end
            cluster_channel = ap_data(t,:).spiking_data{1}(c,:).channel{1};
            lfp = lfp_data(t,:).lfp{1}(cluster_channel,:);
            y = bandpassFilter(lfp, 1, 4, 500);
            phi = angle(hilbert(y));
            spike_phases = zeros(1,length(spike_times));
            for i = 1:length(spike_times)
                [~, tind] = min((lfp_times - spike_times(i)).^2);
                spike_phases(i) = phi(tind);
            end
            phases{c} = spike_phases;
        end
        out(t,:).spiking_data{1} = [out(t,:).spiking_data{1}, table(phases, 'VariableNames', {'spike_delta_phase'})];
    end
end