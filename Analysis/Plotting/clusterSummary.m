function clusterSummary(ap_session, cluster_id)
    ap_session = ap_session(ap_session.cluster_id == cluster_id,:);
    fig = figure('Position', [ 1151 841 925 1081]);
    tl = tiledlayout(4,2);
    axs = zeros(4,2);
    % spike waveform
    axs(1,1) = nexttile;
    plot(linspace(0,length(wvfrm)/metrics.fs, length(wvfrm)), wvfrm)
    title(spk_class)
    xlabel('Time (s)')
    % ISI
    axs(1,2) = nexttile;
    isi_trim = isi(isi<mean(isi)*2);
    histogram(isi_trim, 200);
    xlabel('ISI (s)')
    title(sprintf('Mean ISI = %.2fs', mean(isi)))
    [N, edges] = histcounts(isi_trim, 100);
    centers = zeros(1,length(edges)-1);
    for i = 1:length(edges)-1
        centers(i) = mean([edges(i), edges(i+1)]);
    end
    % lick histogram 
    axs(2,1) = nexttile;
    bar(-2.9:0.1:5.0, sum(targets), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    hold on
    ylims = ylim;
    plot([0,0],[0, ylims(2)], 'k--')
    plot([1.2,1.2],[0, ylims(2)], 'k--')
    title('Target')
    ylabel('Lick Count')
    axs(2,2) = nexttile;
    bar(-2.9:0.1:5.0, sum(distractors), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    hold on
    ylims = ylim;
    plot([0,0],[0, ylims(2)], 'k--')
    title('Distractor')
    % spike rasters 
    axs(3,1) = nexttile;
    hold on
    for i = 1:length(rasters{1})
        if ~isempty(rasters{1}{i})
            plot(rasters{1}{i}, ...
                repmat(stim_counts{1}{i}, 1, length(rasters{1}{i})), 'b|')
        end
    end
    for i = 1:length(rasters{2})
        if ~isempty(rasters{2}{i})
            plot(rasters{2}{i}, ...
                repmat(stim_counts{2}{i}, 1, length(rasters{2}{i})), 'r|')
        end
    end
    ylims = ylim;
    plot([0,0], [ylims(1), ylims(2)], 'k-', 'LineWidth', 1.5)
    plot([1.2,1.2], [ylims(1), ylims(2)], 'k-', 'LineWidth', 1.5)
    ylabel('Trial Number')
    xlim([-3,5])
    axs(3,2) = nexttile;
    hold on
    for i = 1:length(rasters{3})
        if ~isempty(rasters{3}{i})
            plot(rasters{3}{i}, ...
                repmat(stim_counts{3}{i}, 1, length(rasters{3}{i})), 'r|')
        end
    end
    for i = 1:length(rasters{4})
        if ~isempty(rasters{4}{i})
            plot(rasters{4}{i}, ...
                repmat(stim_counts{4}{i}, 1, length(rasters{4}{i})), 'b|')
        end
    end
    ylims = ylim;
    plot([0,0], [ylims(1), ylims(2)], 'k-', 'LineWidth', 1.5)
    xlim([-3,5])
    % firing rates 
    axs(4,1) = nexttile;
    hold on
    if size(firing_rates{2},1) > 1
        plot(linspace(-3,5,size(firing_rates{2},2)), ...
            nanmean(firing_rates{2}), 'r')
    else
        plot(linspace(-3,5,size(firing_rates{2},2)), ...
            firing_rates{2}, 'r')
    end
    if size(firing_rates{1},1) > 1
        plot(linspace(-3,5,size(firing_rates{1},2)), ...
            nanmean(firing_rates{1}), 'b')
    else
        plot(linspace(-3,5,size(firing_rates{1},2)), ...
            firing_rates, 'b')
    end
    xlim([-3,5])
    ylims = ylim;
    ylabel('Firing Rate (Hz)')
    axs(4,2) = nexttile;
    hold on
    if size(firing_rates{3},1) > 1
        plot(linspace(-3,5,size(firing_rates{3},2)), ...
            nanmean(firing_rates{3}), 'r')
    else
        plot(linspace(-3,5,size(firing_rates{3},2)), ...
            firing_rates{3}, 'r')
    end
    if size(firing_rates{4},1) > 1
        plot(linspace(-3,5,size(firing_rates{4},2)), ...
            nanmean(firing_rates{4}), 'b')
    else
        plot(linspace(-3,5,size(firing_rates{4},2)), ...
            firing_rates, 'b')
    end
    xlim([-3,5])
    ylims = [ylims; ylim];
    % ylim([min(ylims(:,1), max(ylims(:,2)))])
    % plot([0,0], [min(ylims(:,1), max(ylims(:,2)))], 'k--')
    xlabel(tl, 'Time (s)')
    region_str = cluster_region{1};
    title(tl, sprintf('Cluster %i: %s', cluster_id, region_str))
    axes(axs(4,1))
    hold on
    ylim([min(ylims(:,1)), max(ylims(:,2))])
    plot([0,0], [min(ylims(:,1)), max(ylims(:,2))], 'k--')
    plot([1.2,1.2], [min(ylims(:,1)), max(ylims(:,2))], 'k--')
    axes(axs(4,2))
    hold on
    ylim([min(ylims(:,1)), max(ylims(:,2))])
    plot([0,0], [min(ylims(:,1)), max(ylims(:,2))], 'k--')
end