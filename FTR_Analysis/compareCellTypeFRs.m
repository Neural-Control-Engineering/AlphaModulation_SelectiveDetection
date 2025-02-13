function compareCellTypeFRs(ap_session1, ap_session2, signals, labels, ttl, visualize, out_path)
    regions = unique(ap_session1.region);
    for r = 1:length(regions)
        region = regions{r};
        regional1 = ap_session1(strcmp(ap_session1.region, region),:);
        regional2 = ap_session2(strcmp(ap_session2.region, region),:);
        cell_types = unique(regional1.waveform_class);
        for i = 1:length(cell_types)
            cell_type = cell_types{i};
            ct1 = regional1(strcmp(regional1.waveform_class, cell_type),:);
            ct2 = regional2(strcmp(regional2.waveform_class, cell_type),:);
            if visualize
                fig = figure('Position', [1220, 1414, 1628, 424]);
            else
                fig = figure('Position', [1220, 1414, 1628, 424], 'Visible', 'off');
            end
            tl = tiledlayout(1,4);
            axs = zeros(1,4);
            ylims = zeros(4,2);
            for j = 1:length(signals)
                fr_mat1 = cell2mat(ct1.(signals{j}));
                fr_mat2 = cell2mat(ct2.(signals{j}));
                axs(j) = nexttile;
                if ~isempty(fr_mat1)
                    time = linspace(-3,5,size(fr_mat1,2));
                    try
                        semshade(fr_mat1, 0.3, 'b', 'b', time, 1, labels{1});
                    catch
                        plot(time, fr_mat1, 'b')
                    end
                end
                hold on
                if ~isempty(fr_mat2)
                    time = linspace(-3,5,size(fr_mat2,2));
                    try
                        semshade(fr_mat2, 0.3, 'r', 'r', time, 1, labels{2});
                    catch
                        plot(time, fr_mat2, 'r')
                    end
                end
                xlim([-3,5])
                signal_parts = strsplit(signals{j}, '_');
                title(signal_parts{end})
                ylims(j,:) = ylim;
            end
            t = sprintf('%s %s %s', ttl, region, cell_type);
            legend()
            title(tl, t)
            xlabel(tl, 'Time (s)')
            ylabel(tl, 'Firing Rate (Hz)')
            unifyYLimits(fig)
            if out_path
                fname = sprintf('%s_%s_%s_firing_rates_comparison', lower(ttl), lower(region), cell_type);
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