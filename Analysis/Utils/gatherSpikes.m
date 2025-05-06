function spks = gatherSpikes(ap_data, cluster_id)
    ind = find(ap_data(1,:).spiking_data{1}.cluster_id == cluster_id);
    spks = [];
    for t = 1:size(ap_data,1)
        spks = [spks, ap_data(t,:).spiking_data{1}(ind,:).spike_times{1}];
    end
    spks = unique(spks);
end

