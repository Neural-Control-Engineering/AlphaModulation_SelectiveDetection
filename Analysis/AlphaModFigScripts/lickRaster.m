load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/SLRT/date--2025-01-17_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat
t = linspace(-3,5,8501);
figure();
hold on 
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
    end
end
xlabel('Time (s)')
ylabel('Trial #')
ylim([1,size(slrt_data,1)])