function lick_mat = lickHist(slrt_data)
    t = linspace(-3,5,8501);
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
            [N, ~] = histcounts(lick_times, bins);
            lick_mat = [lick_mat; N];
        else 
            lick_mat = [lick_mat; zeros(1,size(bins,2)-1)];
        end
    end
    
end