function regionalSpontaneousCV(ap_session, regions, ttl, visualize, out_path)
    regional_inds = zeros(size(ap_session,1),1);
    for r = 1:length(regions)
        regional_inds = regional_inds + strcmp(ap_session.region, regions{r});
    end
    regional = ap_session(logical(regional_inds),:);
    cell_types = unique(regional.waveform_class);
    for i = 1:length(cell_types)
        cell_type = cell_types{i};
        ct = regional(strcmp(regional.waveform_class, cell_type),:);
        if visualize
            fig = figure();
        else
            fig = figure('Visible', 'off');
        end
        mat = [cell2mat(ct.spontaneousCV_Hit), ...
            cell2mat(ct.spontaneousCV_Miss), ...
            cell2mat(ct.spontaneousCV_CR), ...
            cell2mat(ct.spontaneousCV_FA)];
        bar(1:4, nanmean(mat), 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5, 0.5])
        hold on
        errorbar(1:4, nanmean(mat), nanstd(mat) ./ sqrt(size(mat,1)), 'k.')
        bar(6:7, [nanmean([mat(:,1); mat(:,4)]), nanmean([mat(:,2); mat(:,3)])], 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5, 0.5])
        bar(9:10, [nanmean([mat(:,1); mat(:,3)]), nanmean([mat(:,2); mat(:,4)])], 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5, 0.5])
        errorbar(6:7, [nanmean([mat(:,1); mat(:,4)]), nanmean([mat(:,2); mat(:,3)])], [nanstd([mat(:,1); mat(:,4)]) ./ sqrt(size(mat,1)*2), nanstd([mat(:,2); mat(:,3)]) ./ sqrt(size(mat,1)*2)], 'k.')
        errorbar(9:10, [nanmean([mat(:,1); mat(:,3)]), nanmean([mat(:,2); mat(:,4)])], [nanstd([mat(:,1); mat(:,3)]) ./ sqrt(size(mat,1)*2), nanstd([mat(:,2); mat(:,4)]) ./ sqrt(size(mat,1)*2)], 'k.')
        xticks([1:4,6,7,9,10])
        xticklabels({'Hit', 'Miss', 'CR', 'FA', 'Action', 'Withhold', 'Correct', 'Incorrect'})
        ylabel('Spontaneous C.V')
        title(sprintf('%s %s: (n=%i)', ttl, cell_type, size(ct,1)))
        if out_path
            fname = sprintf('%s_%s_spontaneous_cv', lower(ttl), cell_type);
            fname = strrep(fname, ' ', '_');
            fname = strrep(fname, '/', '-');
            fname = strrep(fname, '\', '-');
            fname = strrep(fname, ':', '');
            saveas(fig, strcat(out_path, fname, '.fig'))
            saveas(fig, strcat(out_path, fname, '.png'))
        end
    end
end