function compareRegionalCellTypeAvgBaselineFR(ap_session1, ap_session2, regions, ttl, visualize, out_path)
    regional_inds = zeros(size(ap_session1,1),1);
    for r = 1:length(regions)
        regional_inds = regional_inds + strcmp(ap_session1.region, regions{r});
    end
    regional1 = ap_session1(logical(regional_inds),:);

    regional_inds = zeros(size(ap_session2,1),1);
    for r = 1:length(regions)
        regional_inds = regional_inds + strcmp(ap_session2.region, regions{r});
    end
    regional2 = ap_session2(logical(regional_inds),:);

    cell_types = unique(regional1.waveform_class);
    if visualize
        fig = figure('Position', [1220, 1414, 1628, 424]);
    else
        fig = figure('Position', [1220, 1414, 1628, 424], 'Visible', 'off');
    end 
    avgs1 = zeros(1,length(cell_types));
    errs1 = zeros(1,length(cell_types));
    avgs2 = zeros(1,length(cell_types));
    errs2 = zeros(1,length(cell_types));
    for i = 1:length(cell_types)
        cell_type = cell_types{i};
        ct1 = regional1(strcmp(regional1.waveform_class, cell_type),:);
        avgs1(i) = mean(cell2mat(ct1.avg_baseline_fr));
        errs1(i) = std(cell2mat(ct1.avg_baseline_fr)) / sqrt(size(ct1,1));
        ct2 = regional2(strcmp(regional2.waveform_class, cell_type),:);
        avgs2(i) = mean(cell2mat(ct2.avg_baseline_fr));
        errs2(i) = std(cell2mat(ct2.avg_baseline_fr)) / sqrt(size(ct2,1));
    end
    bar(1:2:length(avgs1)*2, avgs1, 0.3, 'EdgeColor', 'k', 'FaceColor', [0,0,1])
    hold on 
    errorbar(1:2:length(avgs1)*2, avgs1, errs1, 'k.')
    bar(2:2:(length(avgs2)*2+1), avgs2, 0.3, 'EdgeColor', 'k', 'FaceColor', [1,0,0])
    errorbar(2:2:(length(avgs2)*2+1), avgs2, errs2, 'k.')
    xticks(1.5:2:(length(avgs2)*2+2))
    xticklabels(cell_types)
    ylabel('Baseline Firing Rate (Hz)')
    xlabel('Cell Types')
    title(ttl)
    if out_path
        fname = sprintf('%s_baseline_firing_rate_comparison', ttl);
        fname = strrep(fname, ' ', '_');
        fname = strrep(fname, '/', '-');
        fname = strrep(fname, '\', '-');
        fname = strrep(fname, ':', '');
        saveas(fig, strcat(out_path, fname, '.fig'))
        saveas(fig, strcat(out_path, fname, '.png'))
    end
end