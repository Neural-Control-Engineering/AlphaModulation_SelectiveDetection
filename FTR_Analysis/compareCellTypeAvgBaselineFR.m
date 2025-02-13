function compareCellTypeAvgBaselineFR(ap_session1, ap_session2, ttl, visualize, out_path)
    regions = unique(ap_session1.region);
    for r = 1:length(regions)
        region = regions{r};
        regional1 = ap_session1(strcmp(ap_session1.region, region),:);
        regional2 = ap_session2(strcmp(ap_session2.region, region),:);
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
            ct2 = regional2(strcmp(regional2.waveform_class, cell_type),:);
            avgs1(i) = mean(cell2mat(ct1.avg_baseline_fr));
            errs1(i) = std(cell2mat(ct1.avg_baseline_fr)) / sqrt(size(ct1,1));
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
        title(sprintf('%s: %s', region, ttl))
        fname = sprintf('%s_%s_baseline_firing_rate_comparison', region, ttl);
        fname = strrep(fname, ' ', '_');
        fname = strrep(fname, '/', '-');
        fname = strrep(fname, '\', '-');
        fname = strrep(fname, ':', '');
        saveas(fig, strcat(out_path, fname, '.fig'))
        saveas(fig, strcat(out_path, fname, '.png'))
    end
end