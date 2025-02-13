function compareRegionalCellTypeFRs(ap_session1, ap_session2, signals, regions, ttl, visualize, out_path)
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
                    semshade(fr_mat1, 0.3, 'b', 'b', time);
                catch
                    plot(time, fr_mat1, 'b')
                end
            end
            hold on 
            if ~isempty(fr_mat2)
                time = linspace(-3,5,size(fr_mat2,2));
                try
                    semshade(fr_mat2, 0.3, 'r', 'r', time);
                catch
                    plot(time, fr_mat2, 'r')
                end
            end
            xlim([-3,5])
            signal_parts = strsplit(signals{j}, '_');
            title(signal_parts{end})
            ylims(j,:) = ylim;
        end
        t = sprintf('%s %s', ttl, cell_type);
        title(tl, t)
        xlabel(tl, 'Time (s)')
        ylabel(tl, 'Firing Rate (Hz)')
        unifyYLimits(fig);
        if out_path
            fname = sprintf('%s_%s_firing_rates_comparison', lower(ttl), cell_type);
            fname = strrep(fname, ' ', '_');
            fname = strrep(fname, '/', '-');
            fname = strrep(fname, '\', '-');
            fname = strrep(fname, ':', '');
            saveas(fig, strcat(out_path, fname, '.fig'))
            saveas(fig, strcat(out_path, fname, '.png'))
        end
    end
end