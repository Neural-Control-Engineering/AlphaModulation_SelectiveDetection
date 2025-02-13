function cellTypeFRs(ap_session, signals, ttl, visualize, out_path)
    regions = unique(ap_session.region);
    for r = 1:length(regions)
        region = regions{r};
        regional = ap_session(strcmp(ap_session.region, region),:);
        cell_types = unique(regional.waveform_class);
        for i = 1:length(cell_types)
            cell_type = cell_types{i};
            ct = regional(strcmp(regional.waveform_class, cell_type),:);
            if visualize
                fig = figure('Position', [1220, 1414, 1628, 424]);
            else
                fig = figure('Position', [1220, 1414, 1628, 424], 'Visible', 'off');
            end
            tl = tiledlayout(1,4);
            axs = zeros(1,4);
            ylims = zeros(4,2);
            for j = 1:length(signals)
                fr_mat = cell2mat(ct.(signals{j}));
                time = linspace(-3,5,size(fr_mat,2));
                axs(j) = nexttile;
                try
                    semshade(fr_mat, 0.3, 'k', 'k', time);
                catch
                    plot(time, fr_mat, 'k')
                end
                xlim([-3,5])
                signal_parts = strsplit(signals{j}, '_');
                title(signal_parts{end})
                ylims(j,:) = ylim;
            end
            t = sprintf('%s %s %s: (n=%i)', ttl, region, cell_type, size(ct,1));
            title(tl, t)
            xlabel(tl, 'Time (s)')
            ylabel(tl, 'Firing Rate (Hz)')
            unifyYLimits(fig)
            if out_path
                fname = sprintf('%s_%s_%s_firing_rates', lower(ttl), lower(region), cell_type);
                fname = strrep(fname, ' ', '_');
                fname = strrep(fname, '/', '-');
                fname = strrep(fname, '\', '-');
                fname = strrep(fname, ':', '');
                saveas(fig, strcat(out_path, fname, '.fig'))
                saveas(fig, strcat(out_path, fname, '.svg'))
            end
        end
    end
    close all
end