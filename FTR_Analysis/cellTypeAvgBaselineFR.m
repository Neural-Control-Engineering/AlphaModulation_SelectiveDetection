function cellTypeAvgBaselineFR(ap_session, ttl, visualize, out_path)
    regions = unique(ap_session.region);
    for r = 1:length(regions)
        region = regions{r};
        regional = ap_session(strcmp(ap_session.region, region),:);
        cell_types = unique(regional.waveform_class);
        if visualize
            fig = figure('Position', [1220, 1414, 1628, 424]);
        else
            fig = figure('Position', [1220, 1414, 1628, 424], 'Visible', 'off');
        end  
        avgs = zeros(1,length(cell_types));
        errs = zeros(1,length(cell_types));
        for i = 1:length(cell_types)
            cell_type = cell_types{i};
            ct = regional(strcmp(regional.waveform_class, cell_type),:);
            avgs(i) = mean(cell2mat(ct.avg_baseline_fr));
            errs(i) = std(cell2mat(ct.avg_baseline_fr)) / sqrt(size(ct,1));
        end
        bar(1:length(avgs), avgs, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5])
        hold on 
        errorbar(1:length(avgs), avgs, errs, 'k.')
        xticks(1:length(avgs))
        xticklabels(cell_types)
        ylabel('Baseline Firing Rate (Hz)')
        xlabel('Cell Types')
        title(sprintf('%s: %s', region, ttl))
        fname = sprintf('%s_%s_baseline_firing_rate', region, ttl);
        fname = strrep(fname, ' ', '_');
        fname = strrep(fname, '/', '-');
        fname = strrep(fname, '\', '-');
        fname = strrep(fname, ':', '');
        saveas(fig, strcat(out_path, fname, '.fig'))
        saveas(fig, strcat(out_path, fname, '.svg'))
    end
    close all
end