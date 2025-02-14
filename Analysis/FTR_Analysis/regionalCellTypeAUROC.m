function regionalCellTypeAUROC(ap_session, regions, ttl, visualize, out_path)
    regional_inds = zeros(size(ap_session,1),1);
    for r = 1:length(regions)
        regional_inds = regional_inds + strcmp(ap_session.region, regions{r});
    end
    regional = ap_session(logical(regional_inds),:);
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
        avgs(i) = mean(cell2mat(ct.auROC));
        errs(i) = std(cell2mat(ct.auROC)) / sqrt(size(ct,1));
    end
    bar(1:length(avgs), avgs, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5])
    hold on 
    errorbar(1:length(avgs), avgs, errs, 'k.')
    xticks(1:length(avgs))
    xticklabels(cell_types)
    ylabel('|auROC - 0.5|')
    xlabel('Cell Types')
    title(ttl)
    fname = sprintf('%s_auroc', ttl);
    fname = strrep(fname, ' ', '_');
    fname = strrep(fname, '/', '-');
    fname = strrep(fname, '\', '-');
    fname = strrep(fname, ':', '');
    saveas(fig, strcat(out_path, fname, '.fig'))
    saveas(fig, strcat(out_path, fname, '.svg'))
    close all
end