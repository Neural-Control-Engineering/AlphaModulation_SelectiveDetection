function [fig, fig2] = lickRaster(slrt_data)
    t = linspace(-3,5,8501);
    fig = figure('Position', [89 1125 729 588]);
    hold on 
    bins = -3:0.1:5;
    lick_mat = [];
    for i = 1:size(slrt_data,1)
        licks = slrt_data(i,:).left_trigger_aligned_lick_detector{1};
        if isempty(licks)
            licks = slrt_data(i,:).right_trigger_aligned_lick_detector{1};
        end
        inds = find(licks);
        lick_times = t(inds);
        if ~isempty(lick_times)
            if length(lick_times) > 1 
                keep = true(size(lick_times));
                last = lick_times(1);
                for k = 2:numel(lick_times)
                    if lick_times(k) - last < 0.1
                        keep(k) = false;
                    else
                        last = lick_times(k);
                    end
                end
                lick_times = lick_times(keep);
            end
            plot(lick_times, repmat(i,1,length(lick_times)), '.', 'Color', [0.5,0.5,0.5])
            [N, ~] = histcounts(lick_times, bins);
            lick_mat = [lick_mat; N];
        else 
            lick_mat = [lick_mat; zeros(1,size(bins,2)-1)];
        end
    end
    xlabel('Time (s)', 'FontSize', 18)
    ylabel('Trial #', 'FontSize', 18)
    ylim([1,size(slrt_data,1)])
    xlim([-3,5])
    ax = gca;
    ax.YAxis.FontSize = 16;
    ax.XAxis.FontSize = 16;

    centers = zeros(length(bins)-1,1);
    for e = 1:(length(bins)-1)
        centers(e) = mean(bins(e:(e+1)));
    end
     
    fig2 = figure('Position', [86 738 745 287]); 
    semshade(lick_mat ./ 0.1, 0.3, 'k', 'k', centers);
    xlabel('Time (s)', 'FontSize', 18)
    ylabel('Lick Frequency (Hz)', 'FontSize', 18)
    xlim([-3,5])
    ax = gca;
    ax.YAxis.FontSize = 16;
    ax.XAxis.FontSize = 16;
end