function [amps, rt_avg] = singleSessionReactionTimes(slrt_data, fig_path, visualize)
    slrt_data = slrt_data(~strcmp(slrt_data.categorical_outcome, 'Pass'), :);
    amps = unique(cell2mat(slrt_data.left_minus_right_amp));
    rt_avg = zeros(1,length(amps));
    rt_err = zeros(1,length(amps));
    for a = 1:length(amps)
        tmp_slrt = slrt_data(cell2mat(slrt_data.left_minus_right_amp) == amps(a),:);
        rt_avg(a) = mean(cell2mat(tmp_slrt.reaction_time));
        rt_err(a) = std(cell2mat(tmp_slrt.reaction_time)) / sqrt(length(tmp_slrt.reaction_time));
    end
    if visualize
        fig = figure();
    else
        fig = figure('Visible', 'off');
    end
    errorbar(amps, rt_avg, rt_err, 'ko-')
    hold on
    plot([0,0], [0,1], 'k--')
    xlabel('Left - Right Amplitude')
    ylabel('Reaction Time (s)')
    if fig_path
        saveas(fig, 'psych_curve.fig')
    end
    if ~visualize
        close()
    end
end