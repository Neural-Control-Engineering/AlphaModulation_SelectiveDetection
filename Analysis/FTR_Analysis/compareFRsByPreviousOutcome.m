function compareFRsByPreviousOutcome(ap_session1, ap_session2, signals, regions, ttl, visualize, out_path)
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
            fig = figure('Position', [1220, 1206, 1613, 632]);
        else
            fig = figure('Position', [1220, 1206, 1613, 632], 'Visible', 'off');
        end     
        tl = tiledlayout(2,4);
        axs = zeros(2,4);
        for s = 1:length(signals)
            for j = 1:length(signals{s})
                fr_mat1 = cell2mat(ct1.(signals{s}{j}));
                fr_mat2 = cell2mat(ct2.(signals{s}{j}));
                axs(j) = nexttile;
                if ~isempty(fr_mat1)
                    time = linspace(-2.9,5.2,size(fr_mat1,2));
                    try
                        semshade(fr_mat1 ./ 0.1, 0.3, 'b', 'b', time);
                    catch
                        plot(time, fr_mat1 ./ 0.1, 'b')
                    end
                end
                hold on 
                if ~isempty(fr_mat2)
                    time = linspace(-2.9,5.2,size(fr_mat2,2));
                    try
                        semshade(fr_mat2 ./ 0.1, 0.3, 'r', 'r', time);
                    catch
                        plot(time, fr_mat2 ./ 0.1, 'r')
                    end
                end
                xlim([-3,5])
                signal_parts = strsplit(signals{s}{j}, '_');
                sps = strsplit(signal_parts{end}, 'after');
                prev_out = sps{end};
                if strcmp(prev_out, 'FA')
                    prev_out = 'False Alarm';
                elseif strcmp(prev_out, 'CR')
                    prev_out = 'Correct Rejection';
                end
                title(sprintf('After %s', prev_out))
            end
        end
        t = sprintf('%s %s', ttl, cell_type);
        title(tl, t)
        xlabel(tl, 'Time (s)')
        ylabel(tl, 'Firing Rate (Hz)')
        unifyYLimits(fig);
        if out_path
            fname = sprintf('%s_%s_history_based_firing_rates_comparison', lower(ttl), cell_type);
            fname = strrep(fname, ' ', '_');
            fname = strrep(fname, '/', '-');
            fname = strrep(fname, '\', '-');
            fname = strrep(fname, ':', '');
            saveas(fig, strcat(out_path, fname, '.fig'))
            saveas(fig, strcat(out_path, fname, '.png'))
        end
    end
end