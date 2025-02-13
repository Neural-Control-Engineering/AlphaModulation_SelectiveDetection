function covarianceSummary(ap_data, slrt_data)
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    actions = {{'Hit', 'FA'}, {'Miss', 'CR'}};
    performance = {{'Hit', 'CR'}, {'FA', 'Miss'}};

    avg_cov_mats = pairwiseCovarianceAnalysis(ap_data, slrt_data);

    [fig_outcome, axs_outcome, t_outcome, cb_outcome] = plotHeatmaps(avg_cov_mats(1:4), outcomes);
    adjustColorLimits(fig_outcome, [-3,3]);
    xlabel(t_outcome, 'Cell ID')
    ylabel(t_outcome, 'Cell ID')

    titles = {'Action', 'Withheld'};
    [fig_action, axs_action, t_action, cb_action] = plotHeatmaps(avg_cov_mats(5:6), titles);
    adjustColorLimits(fig_action, [-3,3]);
    xlabel(t_action, 'Cell ID')
    ylabel(t_action, 'Cell ID')

    titles = {'Correct', 'Incorrect'};
    [fig_performance, axs_performance, t_performance, cb_performance] = plotHeatmaps(avg_cov_mats(7:8), titles);
    adjustColorLimits(fig_performance, [-3,3]);
    xlabel(t_performance, 'Cell ID')
    ylabel(t_performance, 'Cell ID')
end



