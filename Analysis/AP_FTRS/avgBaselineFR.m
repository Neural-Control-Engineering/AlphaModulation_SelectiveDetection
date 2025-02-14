function out = avgBaselineFR(npxls_session, ap_data, events)
    avg_baseline_frs = cell(size(npxls_session,1),1);
    for i = 1:size(npxls_session,1)
        baseline_frs = zeros(size(ap_data,1),1);
        for j = 1:size(ap_data,1)
            for e = 1:length(events)
                vn = strcat(events{e}, '_aligned_baselineFR');
                if ~isempty(ap_data(j,:).spiking_data{1}.(vn){i})
                    baseline_frs(j) = ap_data(j,:).spiking_data{1}.(vn){i};
                end
            end
        end
        avg_baseline_frs{i} = mean(baseline_frs);
    end
    out = [npxls_session, table(avg_baseline_frs, 'VariableNames', {'avg_baseline_fr'})];
end