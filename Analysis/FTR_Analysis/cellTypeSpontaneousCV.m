function cellTypeSpontaneousCV(ap_session, ttl, visualize, out_path)
    regions = unique(ap_session.region);
    for r = 1:length(regions)
        region = regions{r};
        regional = ap_session(strcmp(ap_session.region, region),:);
        cell_types = unique(regional.waveform_class);
        
        avgs = zeros(length(cell_types),4);
        errs = zeros(length(cell_types),4);
        for i = 1:length(cell_types)
            cell_type = cell_types{i};
            ct = regional(strcmp(regional.waveform_class, cell_type),:);
            avgs(i,1) = nanmean(cell2mat(ct.spontaneousCV_Hit));
            errs(i,1) = nanstd(cell2mat(ct.spontaneousCV_Hit)) / sqrt(size(ct,1));
            avgs(i,2) = nanmean(cell2mat(ct.spontaneousCV_Miss));
            errs(i,2) = nanstd(cell2mat(ct.spontaneousCV_Miss)) / sqrt(size(ct,1));
            avgs(i,3) = nanmean(cell2mat(ct.spontaneousCV_CR));
            errs(i,3) = nanstd(cell2mat(ct.spontaneousCV_CR)) / sqrt(size(ct,1));
            avgs(i,4) = nanmean(cell2mat(ct.spontaneousCV_FA));
            errs(i,4) = nanstd(cell2mat(ct.spontaneousCV_FA)) / sqrt(size(ct,1));
            if visualize
                fig = figure('Position', [1215, 1240, 740, 586]);
            else
                fig = figure('Position', [1215, 1240, 740, 586], 'Visible', 'off');
            end 
            bar(1:size(avgs,2), avgs(i,:), 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5])
            hold on 
            errorbar(1:size(avgs,2), avgs(i,:), errs(i,:), 'k.')
            xticks(1:size(avgs,2))
            xticklabels({'Hit', 'Miss', 'CR', 'FA'})
            xlabel('Outcome')
            ylabel('Spontaneous C.V.')
            t = sprintf('%s %s %s: (n=%i)', ttl, region, cell_type, size(ct,1));
            title(t)
            if out_path
                fname = sprintf('%s_%s_%s_spontaneous_cv', lower(ttl), lower(region), cell_type);
                fname = strrep(fname, ' ', '_');
                fname = strrep(fname, '/', '-');
                fname = strrep(fname, '\', '-');
                fname = strrep(fname, ':', '');
                saveas(fig, strcat(out_path, fname, '.fig'))
                saveas(fig, strcat(out_path, fname, '.png'))
            end
        end
    end
end