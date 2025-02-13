function [amps, response_prob] = singleSessionPsychCurve(slrt_data, fig_path, visualize)
    slrt_data = slrt_data(~strcmp(slrt_data.categorical_outcome, 'Pass'), :);
    amps = unique(cell2mat(slrt_data.left_minus_right_amp));
    response_prob = zeros(1,length(amps));
    for a = 1:length(amps)
        tmp_slrt = slrt_data(cell2mat(slrt_data.left_minus_right_amp) == amps(a),:);
        respond = sum(strcmp(tmp_slrt.categorical_outcome, 'Hit')) + sum(strcmp(tmp_slrt.categorical_outcome, 'FA'));
        response_prob(a) = respond / size(tmp_slrt,1);
    end
    if visualize
        fig = figure();
    else
        fig = figure('Visible', 'off');
    end
    plot(amps, response_prob, 'ko-')
    hold on 
    plot([0,0], [0,1], 'k--')
    xlabel('Left - Right Amplitude')
    ylabel('Response Probability')
    if fig_path
        saveas(fig, 'psych_curve.fig')
    end
    if ~visualize
        close()
    end
end