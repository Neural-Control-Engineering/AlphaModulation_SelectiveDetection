function regions = assignBrainRegions(cluster_positions, probe)

    probe_depth = probe.probe_areas{1,1}.probe_depth;
    new_probe_depths = zeros(size(probe_depth));

    lowest = max(max(probe_depth));
    count = 1;
    for i = size(probe_depth,1):-1:1
        dist = diff(probe_depth(i,:));
        new_probe_depths(count,1) = lowest;
        new_probe_depths(count,2) = lowest - dist;
        lowest = new_probe_depths(count,2);
        count = count + 1;
    end

    regions = cell(size(cluster_positions,1),1);
    for i = 1:size(cluster_positions,1)
        y_pos = cluster_positions(i,2);
        dist = (mean(new_probe_depths,2)-y_pos).^2;
        [~, ind] = min(dist);
        regions{i} = probe.probe_areas{1,1}.name{ind};
    end
end
