function spontaneousThetaModulation(ap_session, visualize, out_path)

    if out_path
        fig_path = strcat(out_path, 'Spontaneous_Theta_Modulation/');
        mkdir(fig_path)
        mkdir(strcat(fig_path, 'Overall_Phase_Preference/'));
        mkdir(strcat(fig_path, 'Phase_Preference_By_Outcome/'));
        mkdir(strcat(fig_path, 'Correct_vs_Incorrect/'));
        mkdir(strcat(fig_path, 'Action_vs_Inaction/'));
        mkdir(strcat(fig_path, 'Combo/'));
    end

    p_value = zeros(size(ap_session,1),1);
    p_value_hit = zeros(size(ap_session,1),1);
    p_value_miss = zeros(size(ap_session,1),1);
    p_value_cr = zeros(size(ap_session,1),1);
    p_value_fa = zeros(size(ap_session,1),1);
    for c = 1:size(ap_session,1)
        % spontaneous
        if ~isempty(ap_session(c,:).spon_theta_spike_phases{1})
            [p, ~] = circ_rtest(ap_session(c,:).spon_theta_spike_phases{1});
            p_value(c) = p;
        else
            p_value(c) = nan;
        end

        % hit trials 
        if ~isempty(ap_session(c,:).spon_theta_spike_phases_hit{1})
            [p, ~] = circ_rtest(ap_session(c,:).spon_theta_spike_phases_hit{1});
            p_value_hit(c) = p;
        else
            p_value_hit(c) = nan;
        end
        % miss trials 
        if ~isempty(ap_session(c,:).spon_theta_spike_phases_miss{1})
            [p, ~] = circ_rtest(ap_session(c,:).spon_theta_spike_phases_miss{1});
            p_value_miss(c) = p;
        else
            p_value_miss(c) = nan;
        end
        % CR trials
        if ~isempty(ap_session(c,:).spon_theta_spike_phases_cr{1}) 
            [p, ~] = circ_rtest(ap_session(c,:).spon_theta_spike_phases_cr{1});
            p_value_cr(c) = p;
        else
            p_value_cr(c) = nan;
        end
        % FA trials 
        if ~isempty(ap_session(c,:).spon_theta_spike_phases_fa{1})
            [p, ~] = circ_rtest(ap_session(c,:).spon_theta_spike_phases_fa{1});
            p_value_fa(c) = p;
        else
            p_value_fa(c) = nan;
        end
    end

    % theta_modulated = ap_session(cell2mat(p_value) < cell2mat(p_threshold),:);
    theta_modulated = ap_session(p_value < (0.5 / size(ap_session,1)),:);
    pct_theta_modulated = size(theta_modulated,1) / size(ap_session,1);
    overall_p_threshold = (0.5 / size(ap_session,1));
    
    p_value_hit = p_value_hit(p_value < overall_p_threshold);
    p_value_miss = p_value_miss(p_value < overall_p_threshold);
    p_value_cr = p_value_cr(p_value < overall_p_threshold);
    p_value_fa = p_value_fa(p_value < overall_p_threshold);
    p_value = p_value(p_value < overall_p_threshold);

    theta_bars = zeros(size(theta_modulated,1),1);
    Rs = zeros(size(theta_modulated,1),1);
    kappas = zeros(size(theta_modulated,1),1);
    theta_bars_hit = zeros(size(theta_modulated,1),1);
    Rs_hit = zeros(size(theta_modulated,1),1);
    kappas_hit = zeros(size(theta_modulated,1),1);
    theta_bars_miss = zeros(size(theta_modulated,1),1);
    Rs_miss = zeros(size(theta_modulated,1),1);
    kappas_miss = zeros(size(theta_modulated,1),1);
    theta_bars_cr = zeros(size(theta_modulated,1),1);
    Rs_cr = zeros(size(theta_modulated,1),1);
    kappas_cr = zeros(size(theta_modulated,1),1);
    theta_bars_fa = zeros(size(theta_modulated,1),1);
    Rs_fa = zeros(size(theta_modulated,1),1);
    kappas_fa = zeros(size(theta_modulated,1),1);
    pmi = zeros(size(theta_modulated,1),1);
    pmi_hit = zeros(size(theta_modulated,1),1);
    pmi_miss = zeros(size(theta_modulated,1),1);
    pmi_cr = zeros(size(theta_modulated,1),1);
    pmi_fa = zeros(size(theta_modulated,1),1);
    pmi_correct = zeros(size(theta_modulated,1),1);
    pmi_incorrect = zeros(size(theta_modulated,1),1);
    pmi_action = zeros(size(theta_modulated,1),1);
    pmi_inaction = zeros(size(theta_modulated,1),1);
    mses = zeros(size(theta_modulated,1),1);
    mses_hit = zeros(size(theta_modulated,1),1);
    mses_miss = zeros(size(theta_modulated,1),1);
    mses_cr = zeros(size(theta_modulated,1),1);
    mses_fa = zeros(size(theta_modulated,1),1);
    mses_correct = zeros(size(theta_modulated,1),1);
    mses_incorrect = zeros(size(theta_modulated,1),1);
    mses_action = zeros(size(theta_modulated,1),1);
    mses_inaction = zeros(size(theta_modulated,1),1);
    p_correct = zeros(size(theta_modulated,1),1);
    p_incorrect = zeros(size(theta_modulated,1),1);
    p_action = zeros(size(theta_modulated,1),1);
    p_inaction = zeros(size(theta_modulated,1),1);

    for i = 1:size(theta_modulated,1)
        % overall spontaneous phase modulation 
        %% computations 
        [N, edges] = histcounts(theta_modulated(i,:).spon_theta_spike_phases_hit{1}, 20, 'Normalization', 'pdf');
        centers = zeros(length(edges)-1,1);
        for e = 1:(length(edges)-1)
            centers(e) = mean(edges(e:(e+1)));
        end
        [x,y, theta_bars(i), Rs(i), kappas(i)] = vonMises(theta_modulated(i,:).spon_theta_spike_phases{1});
        pmi(i) = (max(y)-min(y)) / mean(y);
        y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
        mses(i) = mean((N(2:end-1) - y_interpolated').^2);
        %% plotting 
        if visualize
            spon_fig = figure();
        else
            spon_fig = figure('Visible', 'off');
        end
        bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
        hold on
        plot(x,y, 'k', 'LineWidth', 2);
        xticks([-pi, 0, pi])
        xticklabels({'-\pi', '0', '\pi'})
        % title(sprintf('%s %s: p = %.2d; p-threshold=%.2d', theta_modulated(i,:).region{1}, theta_modulated(i,:).waveform_class{1}, p_value(i), p_threshold(i)))
        title(sprintf('*Overall: PMI: %.2f; MSE: %.1d', pmi(i), mses(i)))
        yvals = yticks;
        yticks([yvals(1), yvals(end)])
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;
        if out_path 
            fname = sprintf('%s_cluster_%i', theta_modulated(i,:).session_id{1}, theta_modulated(i,:).cluster_id);
            saveas(spon_fig, strcat(fig_path, 'Overall_Phase_Preference/', fname, '.fig'))
            saveas(spon_fig, strcat(fig_path, 'Overall_Phase_Preference/', fname, '.png'))
        end
        
        %% by outcome
        if visualize
            outcome_fig = figure('Position', [1151, 841, 1850, 1081]);
        else
            outcome_fig = figure('Position', [1151, 841, 1850, 1081], 'Visible', 'off');
        end
        tl = tiledlayout(2,4);
        axs = zeros(2,4);
        %%% plotting spike rates 
        axs(1,1) = nexttile;
        plot(linspace(-2.95,4.95,80), theta_modulated(i,:).left_trigger_aligned_avg_fr_Hit{1}, 'k')
        title('Hit')
        xlim([-3,5])
        axs(1,2) = nexttile;
        plot(linspace(-2.95,4.95,80), theta_modulated(i,:).left_trigger_aligned_avg_fr_Miss{1}, 'k')
        title('Miss')
        xlim([-3,5])
        axs(1,3) = nexttile;
        plot(linspace(-2.95,4.95,80), theta_modulated(i,:).right_trigger_aligned_avg_fr_CR{1}, 'k')
        title('CR')
        xlim([-3,5])
        axs(1,4) = nexttile;
        plot(linspace(-2.95,4.95,80), theta_modulated(i,:).right_trigger_aligned_avg_fr_FA{1}, 'k')
        title('FA')
        xlim([-3,5])
        unifyYLimits(axs(1,:))
        axs(2,1) = nexttile;
        %%% plotting phase modulation
        if ~isempty(theta_modulated(i,:).spon_theta_spike_phases_hit{1})
            [N, edges] = histcounts(theta_modulated(i,:).spon_theta_spike_phases_hit{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_hit(i), Rs_hit(i), kappas_hit(i)] = vonMises(theta_modulated(i,:).spon_theta_spike_phases_hit{1});
            pmi_hit(i) = (max(y)-min(y)) / mean(y);
            y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
            mses_hit(i) = mean((N(2:end-1) - y_interpolated').^2);
            bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
            hold on
            plot(x,y, 'k', 'LineWidth', 2);
            xticks([-pi, 0, pi])
            xticklabels({'-\pi', '0', '\pi'})
            if p_value_hit(i) < (0.5 / size(ap_session,1))
                title(sprintf('*Hit: PMI: %.2f; MSE: %.1d', pmi_hit(i), mses_hit(i)))
            else
                title(sprintf('Hit: PMI: %.2f; MSE: %.1d', pmi_hit(i), mses_hit(i)))
            end
            % title(sprintf('Kappa = %.2f; p = %.2d; p-threshold: %.2d', kappas_hit(i), p_value_hit(i),p_threshold_hit(i)))
            % title(sprintf('p = %.2d; p-threshold: %.2d', p_value_hit(i),p_threshold_hit(i)))
        end
        axs(2,2) = nexttile;
        if ~isempty(theta_modulated(i,:).spon_theta_spike_phases_miss{1})   
            [N, edges] = histcounts(theta_modulated(i,:).spon_theta_spike_phases_miss{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_miss(i), Rs_miss(i), kappas_miss(i)] = vonMises(theta_modulated(i,:).spon_theta_spike_phases_miss{1});
            pmi_miss(i) = (max(y)-min(y)) / mean(y);
            y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
            mses_miss(i) = mean((N(2:end-1) - y_interpolated').^2);
            bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
            hold on
            plot(x,y, 'k', 'LineWidth', 2);
            xticks([-pi, 0, pi])
            xticklabels({'-\pi', '0', '\pi'})
            if p_value_miss(i) < (0.5 / size(ap_session,1))
                title(sprintf('*Miss: PMI: %.2f; MSE: %.1d', pmi_miss(i), mses_miss(i)))
            else
                title(sprintf('Miss: PMI: %.2f; MSE: %.1d', pmi_miss(i), mses_miss(i)))
            end
        end
        axs(2,3) = nexttile;
        if ~isempty(theta_modulated(i,:).spon_theta_spike_phases_cr{1})
            [N, edges] = histcounts(theta_modulated(i,:).spon_theta_spike_phases_cr{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_cr(i), Rs_cr(i), kappas_cr(i)] = vonMises(theta_modulated(i,:).spon_theta_spike_phases_cr{1});
            pmi_cr(i) = (max(y)-min(y)) / mean(y);
            y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
            mses_cr(i) = mean((N(2:end-1) - y_interpolated').^2);
            bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
            hold on
            plot(x,y, 'k', 'LineWidth', 2);
            xticks([-pi, 0, pi])
            xticklabels({'-\pi', '0', '\pi'})
            if p_value_cr(i) < (0.5 / size(ap_session,1))
                title(sprintf('*CR: PMI: %.2f; MSE: %.1d', pmi_cr(i), mses_cr(i)))
            else
                title(sprintf('CR: PMI: %.2f; MSE: %.1d', pmi_cr(i), mses_cr(i)))
            end
        end
        axs(2,4) = nexttile;
        if ~isempty(theta_modulated(i,:).spon_theta_spike_phases_fa{1})
            [N, edges] = histcounts(theta_modulated(i,:).spon_theta_spike_phases_fa{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_fa(i), Rs_fa(i), kappas_fa(i)] = vonMises(theta_modulated(i,:).spon_theta_spike_phases_fa{1});
            pmi_fa(i) = (max(y)-min(y)) / mean(y);
            y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
            mses_fa(i) = mean((N(2:end-1) - y_interpolated').^2);
            bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
            hold on
            plot(x,y, 'k', 'LineWidth', 2);
            xticks([-pi, 0, pi])
            xticklabels({'-\pi', '0', '\pi'})
            if p_value_fa(i) < (0.5 / size(ap_session,1))
                title(sprintf('*FA: PMI: %.2f; MSE: %.1d', pmi_fa(i), mses_fa(i)))
            else
                title(sprintf('FA: PMI: %.2f; MSE: %.1d', pmi_fa(i), mses_fa(i)))
            end
        end
        title(tl, sprintf('%s %s', theta_modulated(i,:).region{1}, theta_modulated(i,:).waveform_class{1}))
        if out_path
            fname = sprintf('%s_cluster_%i.fig', theta_modulated(i,:).session_id{1}, theta_modulated(i,:).cluster_id);
            saveas(outcome_fig, strcat(fig_path, 'Phase_Preference_By_Outcome/', fname))
            fname = sprintf('%s_cluster_%i.png', theta_modulated(i,:).session_id{1}, theta_modulated(i,:).cluster_id);
            saveas(outcome_fig, strcat(fig_path, 'Phase_Preference_By_Outcome/', fname))
        end

        %% correct vs incorrect
        if visualize
            correct_fig = figure('Position', [1220, 1256, 1401, 582]);
        else
            correct_fig = figure('Visible', 'off', 'Position', [1220, 1256, 1401, 582]);
        end
        correct_tl = tiledlayout(1,2);
        correct = [theta_modulated(i,:).spon_theta_spike_phases_hit{1}, theta_modulated(i,:).spon_theta_spike_phases_cr{1}];
        incorrect = [theta_modulated(i,:).spon_theta_spike_phases_miss{1}, theta_modulated(i,:).spon_theta_spike_phases_fa{1}];
        p_threshold_correct(i) = 0.05 / length(correct);
        p_threshold_incorrect(i) = 0.05 / length(incorrect);
        [p_correct(i), ~] = circ_rtest(correct);
        [p_incorrect(i), ~] = circ_rtest(incorrect);
        correct_axs(1) = nexttile;
        [N, edges] = histcounts(correct, 20, 'Normalization', 'pdf');
        centers = zeros(length(edges)-1,1);
        for e = 1:(length(edges)-1)
            centers(e) = mean(edges(e:(e+1)));
        end
        [x,y, theta_bars_correct(i), Rs_correct(i), kappas_correct(i)] = vonMises(correct);
        pmi_correct(i) = (max(y)-min(y)) / mean(y);
        y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
        mses_correct(i) = mean((N(2:end-1) - y_interpolated').^2);
        bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
        hold on
        plot(x,y, 'k', 'LineWidth', 2);
        xticks([-pi, 0, pi])
        xticklabels({'-\pi', '0', '\pi'})
        if p_correct(i) < (0.5 / size(ap_session,1))
            title(sprintf('*Correct: PMI: %.2f; MSE: %.1d', pmi_correct(i), mses_correct(i)))
        else
            title(sprintf('Correct: PMI: %.2f; MSE: %.1d', pmi_correct(i), mses_correct(i)))
        end
        axs(2) = nexttile;
        [N, edges] = histcounts(incorrect, 20, 'Normalization', 'pdf');
        centers = zeros(length(edges)-1,1);
        for e = 1:(length(edges)-1)
            centers(e) = mean(edges(e:(e+1)));
        end
        [x,y, theta_bars_incorrect(i), Rs_incorrect(i), kappas_incorrect(i)] = vonMises(incorrect);
        pmi_incorrect(i) = (max(y)-min(y)) / mean(y);
        y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
        mses_incorrect(i) = mean((N(2:end-1) - y_interpolated').^2);
        bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
        hold on
        plot(x,y, 'k', 'LineWidth', 2);
        xticks([-pi, 0, pi])
        xticklabels({'-\pi', '0', '\pi'})
        if p_incorrect(i) < (0.5 / size(ap_session,1))
            title(sprintf('*Incorrect: PMI: %.2f; MSE: %.1d', pmi_incorrect(i), mses_incorrect(i)))
        else
            title(sprintf('Incorrect: PMI: %.2f; MSE: %.1d', pmi_incorrect(i), mses_incorrect(i)))
        end
        title(correct_tl, sprintf('%s %s', theta_modulated(i,:).region{1}, theta_modulated(i,:).waveform_class{1}))
        if out_path
            fname = sprintf('%s_cluster_%i.fig', theta_modulated(i,:).session_id{1}, theta_modulated(i,:).cluster_id);
            saveas(correct_fig, strcat(fig_path, 'Correct_vs_Incorrect/', fname))
            fname = sprintf('%s_cluster_%i.png', theta_modulated(i,:).session_id{1}, theta_modulated(i,:).cluster_id);
            saveas(correct_fig, strcat(fig_path, 'Correct_vs_Incorrect/', fname))
        end

        
        %% action vs inaction
        if visualize
            action_fig = figure('Position', [1220, 1256, 1401, 582]);
        else
            action_fig = figure('Visible', 'off', 'Position', [1220, 1256, 1401, 582]);
        end
        action_tl = tiledlayout(1,2);
        action = [theta_modulated(i,:).spon_theta_spike_phases_hit{1}, theta_modulated(i,:).spon_theta_spike_phases_fa{1}];
        inaction = [theta_modulated(i,:).spon_theta_spike_phases_miss{1}, theta_modulated(i,:).spon_theta_spike_phases_cr{1}];
        p_threshold_action(i) = 0.05 / length(action);
        p_threshold_inaction(i) = 0.05 / length(inaction);
        [p_action(i), ~] = circ_rtest(action);
        [p_inaction(i), ~] = circ_rtest(inaction);
        action_axs(1) = nexttile;
        [N, edges] = histcounts(action, 20, 'Normalization', 'pdf');
        centers = zeros(length(edges)-1,1);
        for e = 1:(length(edges)-1)
            centers(e) = mean(edges(e:(e+1)));
        end
        [x,y, theta_bars_action(i), Rs_action(i), kappas_action(i)] = vonMises(action);
        pmi_action(i) = (max(y)-min(y)) / mean(y);
        y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
        mses_action(i) = mean((N(2:end-1) - y_interpolated').^2);
        bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
        hold on
        plot(x,y, 'k', 'LineWidth', 2);
        xticks([-pi, 0, pi])
        xticklabels({'-\pi', '0', '\pi'})
        if p_action(i) < (0.5 / size(ap_session,1))
            title(sprintf('*Action: PMI: %.2f; MSE: %.1d', pmi_action(i), mses_action(i)))
        else
            title(sprintf('Action: PMI: %.2f; MSE: %.1d', pmi_action(i), mses_action(i)))
        end
        axs(2) = nexttile;
        [N, edges] = histcounts(inaction, 20, 'Normalization', 'pdf');
        centers = zeros(length(edges)-1,1);
        for e = 1:(length(edges)-1)
            centers(e) = mean(edges(e:(e+1)));
        end
        [x,y, theta_bars_inaction(i), Rs_inaction(i), kappas_inaction(i)] = vonMises(inaction);
        pmi_inaction(i) = (max(y)-min(y)) / mean(y);
        y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
        mses_inaction(i) = mean((N(2:end-1) - y_interpolated').^2);
        bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
        hold on
        plot(x,y, 'k', 'LineWidth', 2);
        xticks([-pi, 0, pi])
        xticklabels({'-\pi', '0', '\pi'})
        if p_inaction(i) < (0.5 / size(ap_session,1))
            title(sprintf('*Inaction: PMI: %.2f; MSE: %.1d', pmi_inaction(i), mses_inaction(i)))
        else
            title(sprintf('Inaction: PMI: %.2f; MSE: %.1d', pmi_inaction(i), mses_inaction(i)))
        end
        if out_path
            fname = sprintf('%s_cluster_%i.fig', theta_modulated(i,:).session_id{1}, theta_modulated(i,:).cluster_id);
            saveas(action_fig, strcat(fig_path, 'Action_vs_Inaction/', fname))
            fname = sprintf('%s_cluster_%i.png', theta_modulated(i,:).session_id{1}, theta_modulated(i,:).cluster_id);
            saveas(action_fig, strcat(fig_path, 'Action_vs_Inaction/', fname))
        end

        %% combo figure 
        if visualize
            combo_fig = figure('Position', [1151, 841, 925, 1081]);
        else
            combo_fig = figure('Position', [1151, 841, 925, 1081], 'Visible', 'off');
        end
        tl_combo = tiledlayout(5,4);
        axs_combo = zeros(1,13);
        axs_combo(1) = nexttile([1,4]);
        [N, edges] = histcounts(theta_modulated(i,:).spon_theta_spike_phases_hit{1}, 20, 'Normalization', 'pdf');
        centers = zeros(length(edges)-1,1);
        for e = 1:(length(edges)-1)
            centers(e) = mean(edges(e:(e+1)));
        end
        [x,y, theta_bars(i), Rs(i), kappas(i)] = vonMises(theta_modulated(i,:).spon_theta_spike_phases{1});
        bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
        hold on
        plot(x,y, 'k', 'LineWidth', 2);
        xticks([-pi, 0, pi])
        xticklabels({'-\pi', '0', '\pi'})
        % title(sprintf('%s %s: p = %.2d; p-threshold=%.2d', theta_modulated(i,:).region{1}, theta_modulated(i,:).waveform_class{1}, p_value(i), p_threshold(i)))
        title(sprintf('*Overall: PMI: %.2f; MSE: %.1d', pmi(i), mses(i)))
        yvals = yticks;
        yticks([yvals(1), yvals(end)])
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;
        axs_combo(2) = nexttile;
        plot(linspace(-2.95,4.95,80), theta_modulated(i,:).left_trigger_aligned_avg_fr_Hit{1}, 'k')
        title('Hit')
        xlim([-3,5])
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;
        axs_combo(3) = nexttile;
        plot(linspace(-2.95,4.95,80), theta_modulated(i,:).left_trigger_aligned_avg_fr_Miss{1}, 'k')
        title('Miss')
        xlim([-3,5])
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;
        axs_combo(4) = nexttile;
        plot(linspace(-2.95,4.95,80), theta_modulated(i,:).right_trigger_aligned_avg_fr_CR{1}, 'k')
        title('CR')
        xlim([-3,5])
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;
        axs_combo(5) = nexttile;
        plot(linspace(-2.95,4.95,80), theta_modulated(i,:).right_trigger_aligned_avg_fr_FA{1}, 'k')
        title('FA')
        xlim([-3,5])
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;
        axs_combo(6) = nexttile;
        if ~isempty(theta_modulated(i,:).spon_theta_spike_phases_hit{1})
            [N, edges] = histcounts(theta_modulated(i,:).spon_theta_spike_phases_hit{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_hit(i), Rs_hit(i), kappas_hit(i)] = vonMises(theta_modulated(i,:).spon_theta_spike_phases_hit{1});
            bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
            hold on
            plot(x,y, 'k', 'LineWidth', 2);
            xticks([-pi, 0, pi])
            xticklabels({'-\pi', '0', '\pi'})
            if p_value_hit(i) < (0.5 / size(ap_session,1))
                title(sprintf('*PMI: %.2f; MSE: %.1d', pmi_hit(i), mses_hit(i)))
            else
                title(sprintf('PMI: %.2f; MSE: %.1d', pmi_hit(i), mses_hit(i)))
            end
            ax = gca;  % Get current axes
            ax.XAxis.FontSize = 14;
            ax.YAxis.FontSize = 14;
        end
        axs_combo(7) = nexttile;
        if ~isempty(theta_modulated(i,:).spon_theta_spike_phases_miss{1})   
            [N, edges] = histcounts(theta_modulated(i,:).spon_theta_spike_phases_miss{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_miss(i), Rs_miss(i), kappas_miss(i)] = vonMises(theta_modulated(i,:).spon_theta_spike_phases_miss{1});
            pmi_miss(i) = (max(y)-min(y)) / mean(y);
            y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
            mses_miss(i) = mean((N(2:end-1) - y_interpolated').^2);
            bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
            hold on
            plot(x,y, 'k', 'LineWidth', 2);
            xticks([-pi, 0, pi])
            xticklabels({'-\pi', '0', '\pi'})
            if p_value_miss(i) < (0.5 / size(ap_session,1))
                title(sprintf('*PMI: %.2f; MSE: %.1d', pmi_miss(i), mses_miss(i)))
            else
                title(sprintf('PMI: %.2f; MSE: %.1d', pmi_miss(i), mses_miss(i)))
            end
            ax = gca;  % Get current axes
            ax.XAxis.FontSize = 14;
            ax.YAxis.FontSize = 14;
        end
        axs_combo(8) = nexttile;
        if ~isempty(theta_modulated(i,:).spon_theta_spike_phases_cr{1})
            [N, edges] = histcounts(theta_modulated(i,:).spon_theta_spike_phases_cr{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_cr(i), Rs_cr(i), kappas_cr(i)] = vonMises(theta_modulated(i,:).spon_theta_spike_phases_cr{1});
            pmi_cr(i) = (max(y)-min(y)) / mean(y);
            y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
            mses_cr(i) = mean((N(2:end-1) - y_interpolated').^2);
            bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
            hold on
            plot(x,y, 'k', 'LineWidth', 2);
            xticks([-pi, 0, pi])
            xticklabels({'-\pi', '0', '\pi'})
            if p_value_cr(i) < (0.5 / size(ap_session,1))
                title(sprintf('*PMI: %.2f; MSE: %.1d', pmi_cr(i), mses_cr(i)))
            else
                title(sprintf('PMI: %.2f; MSE: %.1d', pmi_cr(i), mses_cr(i)))
            end
            ax = gca;  % Get current axes
            ax.XAxis.FontSize = 14;
            ax.YAxis.FontSize = 14;
        end
        axs_combo(9) = nexttile;
        if ~isempty(theta_modulated(i,:).spon_theta_spike_phases_fa{1})
            [N, edges] = histcounts(theta_modulated(i,:).spon_theta_spike_phases_fa{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_fa(i), Rs_fa(i), kappas_fa(i)] = vonMises(theta_modulated(i,:).spon_theta_spike_phases_fa{1});
            pmi_fa(i) = (max(y)-min(y)) / mean(y);
            y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
            mses_fa(i) = mean((N(2:end-1) - y_interpolated').^2);
            bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
            hold on
            plot(x,y, 'k', 'LineWidth', 2);
            xticks([-pi, 0, pi])
            xticklabels({'-\pi', '0', '\pi'})
            if p_value_fa(i) < (0.5 / size(ap_session,1))
                title(sprintf('*PMI: %.2f; MSE: %.1d', pmi_fa(i), mses_fa(i)))
            else
                title(sprintf('PMI: %.2f; MSE: %.1d', pmi_fa(i), mses_fa(i)))
            end
            ax = gca;  % Get current axes
            ax.XAxis.FontSize = 14;
            ax.YAxis.FontSize = 14;
        end

        axs_combo(10) = nexttile([1,2]);
        [N, edges] = histcounts(correct, 20, 'Normalization', 'pdf');
        centers = zeros(length(edges)-1,1);
        for e = 1:(length(edges)-1)
            centers(e) = mean(edges(e:(e+1)));
        end
        [x,y, theta_bars_correct(i), Rs_correct(i), kappas_correct(i)] = vonMises(correct);
        pmi_correct(i) = (max(y)-min(y)) / mean(y);
        y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
        mses_correct(i) = mean((N(2:end-1) - y_interpolated').^2);
        bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
        hold on
        plot(x,y, 'k', 'LineWidth', 2);
        xticks([-pi, 0, pi])
        xticklabels({'-\pi', '0', '\pi'})
        if p_correct(i) < (0.5 / size(ap_session,1))
            title(sprintf('*Correct: PMI: %.2f; MSE: %.1d', pmi_correct(i), mses_correct(i)))
        else
            title(sprintf('Correct: PMI: %.2f; MSE: %.1d', pmi_correct(i), mses_correct(i)))
        end
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;

        axs_combo(11) = nexttile([1,2]);
        [N, edges] = histcounts(incorrect, 20, 'Normalization', 'pdf');
        centers = zeros(length(edges)-1,1);
        for e = 1:(length(edges)-1)
            centers(e) = mean(edges(e:(e+1)));
        end
        [x,y, theta_bars_incorrect(i), Rs_incorrect(i), kappas_incorrect(i)] = vonMises(incorrect);
        pmi_incorrect(i) = (max(y)-min(y)) / mean(y);
        y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
        mses_incorrect(i) = mean((N(2:end-1) - y_interpolated').^2);
        bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
        hold on
        plot(x,y, 'k', 'LineWidth', 2);
        xticks([-pi, 0, pi])
        xticklabels({'-\pi', '0', '\pi'})
        if p_incorrect(i) < (0.5 / size(ap_session,1))
            title(sprintf('*Incorrect: PMI: %.2f; MSE: %.1d', pmi_incorrect(i), mses_incorrect(i)))
        else
            title(sprintf('Incorrect: PMI: %.2f; MSE: %.1d', pmi_incorrect(i), mses_incorrect(i)))
        end
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;

        axs_combo(12) = nexttile([1,2]);
        [N, edges] = histcounts(action, 20, 'Normalization', 'pdf');
        centers = zeros(length(edges)-1,1);
        for e = 1:(length(edges)-1)
            centers(e) = mean(edges(e:(e+1)));
        end
        [x,y, theta_bars_action(i), Rs_action(i), kappas_action(i)] = vonMises(action);
        pmi_action(i) = (max(y)-min(y)) / mean(y);
        y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
        mses_action(i) = mean((N(2:end-1) - y_interpolated').^2);
        bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
        hold on
        plot(x,y, 'k', 'LineWidth', 2);
        xticks([-pi, 0, pi])
        xticklabels({'-\pi', '0', '\pi'})
        if p_action(i) < (0.5 / size(ap_session,1))
            title(sprintf('*Action: PMI: %.2f; MSE: %.1d', pmi_action(i), mses_action(i)))
        else
            title(sprintf('Action: PMI: %.2f; MSE: %.1d', pmi_action(i), mses_action(i)))
        end
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;

        axs_combo(13) =  nexttile([1,2]);
        [N, edges] = histcounts(inaction, 20, 'Normalization', 'pdf');
        centers = zeros(length(edges)-1,1);
        for e = 1:(length(edges)-1)
            centers(e) = mean(edges(e:(e+1)));
        end
        [x,y, theta_bars_inaction(i), Rs_inaction(i), kappas_inaction(i)] = vonMises(inaction);
        pmi_inaction(i) = (max(y)-min(y)) / mean(y);
        y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
        mses_inaction(i) = mean((N(2:end-1) - y_interpolated').^2);
        bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
        hold on
        plot(x,y, 'k', 'LineWidth', 2);
        xticks([-pi, 0, pi])
        xticklabels({'-\pi', '0', '\pi'})
        if p_inaction(i) < (0.5 / size(ap_session,1))
            title(sprintf('*Inaction: PMI: %.2f; MSE: %.1d', pmi_inaction(i), mses_inaction(i)))
        else
            title(sprintf('Inaction: PMI: %.2f; MSE: %.1d', pmi_inaction(i), mses_inaction(i)))
        end
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;

        if startsWith(theta_modulated(i,:).region{1}, 'SS')
            t = sprintf('Cortex: %s', theta_modulated(i,:).waveform_class{1});
        elseif strcmp(theta_modulated(i,:).region{1}, 'CP') || strcmp(theta_modulated(i,:).region{1}, 'STR')
            t = sprintf('Basal Ganglia: %s', theta_modulated(i,:).waveform_class{1});
        else
            t = sprintf('Amygdala: %s', theta_modulated(i,:).waveform_class{1});
        end
        title(tl_combo, t)
        unifyYLimits(axs_combo(2:5))
        unifyYLimits(axs_combo(6:9))
        unifyYLimits(axs_combo(10:13))
        if out_path 
            fname = sprintf('%s_cluster_%i.fig', theta_modulated(i,:).session_id{1}, theta_modulated(i,:).cluster_id);
            saveas(combo_fig, strcat(fig_path, 'Combo/', fname))
            fname = sprintf('%s_cluster_%i.png', theta_modulated(i,:).session_id{1}, theta_modulated(i,:).cluster_id);
            saveas(combo_fig, strcat(fig_path, 'Combo/', fname))
        end
        
        close all
        
    end

    if visualize
        correct_pmi_fig = figure('Position', [1220, 1379, 1019, 459]);
    else
        correct_pmi_fig = figure('Visible', 'off', 'Position', [1220, 1379, 1019, 459]);
    end
    bar(1:2, [nanmean(pmi_correct), nanmean(pmi_incorrect)], 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5, 0.5])
    hold on
    errorbar(1:2, [nanmean(pmi_correct), nanmean(pmi_incorrect)], [nanstd(pmi_correct) ./ sqrt(length(pmi_correct)), nanstd(pmi_incorrect) ./ sqrt(length(pmi_correct))], 'k.')
    xticks(1:2)
    xticklabels({'Correct', 'Incorrect'})
    ylabel('Phase Modulation Index')
    if out_path 
        saveas(correct_pmi_fig, strcat(fig_path, 'correct_pmi.fig'))
        saveas(correct_pmi_fig, strcat(fig_path, 'correct_pmi.png'))
    end

    if visualize
        correct_mses_fig = figure('Position', [1220, 1379, 1019, 459]);
    else
        correct_mses_fig = figure('Visible', 'off', 'Position', [1220, 1379, 1019, 459]);
    end
    bar(1:2, [nanmean(mses_correct), nanmean(mses_incorrect)], 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5, 0.5])
    hold on
    errorbar(1:2, [nanmean(mses_correct), nanmean(mses_incorrect)], [nanstd(mses_correct) ./ sqrt(length(mses_correct)), nanstd(mses_incorrect) ./ sqrt(length(mses_correct))], 'k.')
    xticks(1:2)
    xticklabels({'Correct', 'Incorrect'})
    ylabel('M.S.E.')
    if out_path 
        saveas(correct_mses_fig, strcat(fig_path, 'correct_mses.fig'))
        saveas(correct_mses_fig, strcat(fig_path, 'correct_mses.png'))
    end

    if visualize
        action_pmi_fig = figure('Position', [1220, 1379, 1019, 459]);
    else
        action_pmi_fig = figure('Visible', 'off', 'Position', [1220, 1379, 1019, 459]);
    end
    bar(1:2, [nanmean(pmi_action), nanmean(pmi_inaction)], 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5, 0.5])
    hold on
    errorbar(1:2, [nanmean(pmi_action), nanmean(pmi_inaction)], [nanstd(pmi_action) ./ sqrt(length(pmi_action)), nanstd(pmi_inaction) ./ sqrt(length(pmi_action))], 'k.')
    xticks(1:2)
    xticklabels({'Action', 'Inaction'})
    ylabel('Phase Modulation Index')
    if out_path 
        saveas(action_pmi_fig, strcat(fig_path, 'action_pmi.fig'))
        saveas(action_pmi_fig, strcat(fig_path, 'action_pmi.png'))
    end
    
    if visualize
        action_mses_fig = figure('Position', [1220, 1379, 1019, 459]);
    else
        action_mses_fig = figure('Visible', 'off', 'Position', [1220, 1379, 1019, 459]);
    end
    bar(1:2, [nanmean(mses_action), nanmean(mses_inaction)], 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5, 0.5])
    hold on
    errorbar(1:2, [nanmean(mses_action), nanmean(mses_inaction)], [nanstd(mses_action) ./ sqrt(length(mses_action)), nanstd(mses_inaction) ./ sqrt(length(mses_action))], 'k.')
    xticks(1:2)
    xticklabels({'Action', 'Inaction'})
    ylabel('M.S.E.')
    if out_path 
        saveas(action_mses_fig, strcat(fig_path, 'action_mses.fig'))
        saveas(action_mses_fig, strcat(fig_path, 'action_mses.png'))
    end

    

    if visualize
        correct_theta_fig = figure('Position', [1220, 1379, 1019, 459]);
    else
        correct_theta_fig = figure('Visible', 'off', 'Position', [1220, 1379, 1019, 459]);
    end
    cttl = tiledlayout(1,2);
    ctaxs(1) = nexttile;
    polarhistogram(theta_bars_correct, 36)
    title('Correct')
    ctaxs(2) = nexttile;
    polarhistogram(theta_bars_incorrect, 36)
    title('Incorrect')
    if out_path 
        saveas(correct_theta_fig, strcat(fig_path, 'correct_theta.fig'))
        saveas(correct_theta_fig, strcat(fig_path, 'correct_theta.png'))
    end

    if visualize
        correct_r_fig = figure();
    else
        correct_r_fig = figure('Visible', 'off');
    end
    bar([1,2], [nanmean(Rs_correct), nanmean(Rs_incorrect)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    hold on
    errorbar([1,2], [nanmean(Rs_correct), nanmean(Rs_incorrect)], [nanstd(Rs_correct) ./ sqrt(length(Rs_correct)), nanstd(Rs_incorrect) ./ sqrt(length(Rs_incorrect))], 'k.')
    xticks([1,2])
    xticklabels({'Correct', 'Incorrect'})
    ylabel('R')
    if out_path 
        saveas(correct_r_fig, strcat(fig_path, 'correct_r.fig'))
        saveas(correct_r_fig, strcat(fig_path, 'correct_r.png'))
    end

    if visualize
        correct_kappa_fig = figure();
    else
        correct_kappa_fig = figure('Visible', 'off');
    end
    bar([1,2], [nanmean(kappas_correct), nanmean(kappas_incorrect)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    hold on
    errorbar([1,2], [nanmean(kappas_correct), nanmean(kappas_incorrect)], [nanstd(kappas_correct) ./ sqrt(length(kappas_correct)), nanstd(kappas_incorrect) ./ sqrt(length(kappas_incorrect))], 'k.')
    xticks([1,2])
    xticklabels({'Correct', 'Incorrect'})
    ylabel('Kappa')
    if out_path 
        saveas(correct_kappa_fig, strcat(fig_path, 'correct_kappa.fig'))
        saveas(correct_kappa_fig, strcat(fig_path, 'correct_kappa.png'))
    end

    if visualize
        correct_fraction_fig = figure();
    else
        correct_fraction_fig = figure('Visible', 'off');
    end
    bar([1,2], [sum(p_correct < overall_p_threshold) / size(theta_modulated,1), sum(p_incorrect < overall_p_threshold) / size(theta_modulated,1)], ...
        'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    ylabel('Fraction of Modulated Neurons')
    xticks([1,2])
    xticklabels({'Correct', 'Incorrect'})
    if out_path 
        saveas(correct_fraction_fig, strcat(fig_path, 'correct_fraction_modulated.fig'))
        saveas(correct_fraction_fig, strcat(fig_path, 'correct_fraction_modulated.png'))
    end

    if visualize
        action_theta_fig = figure('Position', [1220, 1379, 1019, 459]);
    else
        action_theta_fig = figure('Visible', 'off', 'Position', [1220, 1379, 1019, 459]);
    end
    attl = tiledlayout(1,2);
    ataxs(1) = nexttile;
    polarhistogram(theta_bars_action, 36)
    title('Action')
    ataxs(2) = nexttile;
    polarhistogram(theta_bars_inaction, 36)
    title('Inaction')
    if out_path 
        saveas(action_theta_fig, strcat(fig_path, 'action_theta.fig'))
        saveas(action_theta_fig, strcat(fig_path, 'action_theta.png'))
    end

    if visualize
        action_r_fig = figure();
    else
        action_r_fig = figure('Visible', 'off');
    end
    bar([1,2], [nanmean(Rs_action), nanmean(Rs_inaction)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    hold on
    errorbar([1,2], [nanmean(Rs_action), nanmean(Rs_inaction)], [nanstd(Rs_action) ./ sqrt(length(Rs_action)), nanstd(Rs_inaction) ./ sqrt(length(Rs_inaction))], 'k.')
    xticks([1,2])
    xticklabels({'Correct', 'Inaction'})
    ylabel('R')
    if out_path 
        saveas(action_r_fig, strcat(fig_path, 'action_r.fig'))
        saveas(action_r_fig, strcat(fig_path, 'action_r.png'))
    end

    if visualize
        action_kappa_fig = figure();
    else
        action_kappa_fig = figure('Visible', 'off');
    end
    bar([1,2], [nanmean(kappas_action), nanmean(kappas_inaction)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    hold on
    errorbar([1,2], [nanmean(kappas_action), nanmean(kappas_inaction)], [nanstd(kappas_action) ./ sqrt(length(kappas_action)), nanstd(kappas_inaction) ./ sqrt(length(kappas_inaction))], 'k.')
    xticks([1,2])
    xticklabels({'Correct', 'Inaction'})
    ylabel('Kappa')
    if out_path 
        saveas(action_kappa_fig, strcat(fig_path, 'action_kappa.fig'))
        saveas(action_kappa_fig, strcat(fig_path, 'action_kappa.png'))
    end

    if visualize
        action_fraction_fig = figure();
    else
        action_fraction_fig = figure('Visible', 'off');
    end
    bar([1,2], [sum(p_action < overall_p_threshold) / size(theta_modulated,1), sum(p_inaction < overall_p_threshold) / size(theta_modulated,1)], ...
        'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    ylabel('Fraction of Modulated Neurons')
    xticks([1,2])
    xticklabels({'Action', 'Inaction'})
    if out_path 
        saveas(action_fraction_fig, strcat(fig_path, 'action_fraction_modulated.fig'))
        saveas(action_fraction_fig, strcat(fig_path, 'action_fraction_modulated.png'))
    end

    rs_frac = sum(strcmp(theta_modulated.waveform_class, 'RS')) / sum(strcmp(ap_session.waveform_class, 'RS'));
    fs_frac = sum(strcmp(theta_modulated.waveform_class, 'FS')) / sum(strcmp(ap_session.waveform_class, 'FS'));
    ps_frac = sum(strcmp(theta_modulated.waveform_class, 'PS')) / sum(strcmp(ap_session.waveform_class, 'PS'));
    ts_frac = sum(strcmp(theta_modulated.waveform_class, 'TS')) / sum(strcmp(ap_session.waveform_class, 'TS'));
    if visualize
        wvc_fraction_fig = figure();
    else
        wvc_fraction_fig = figure('Visible', 'off');
    end
    bar(1:4, [rs_frac, fs_frac, ps_frac, ts_frac], 'FaceColor', [0.5,0.5,0.5], 'EdgeColor', [0.5,0.5,0.5])
    xticks(1:4)
    xticklabels({'RS', 'FS', 'PS', 'TS'})
    ylabel('Fraction of Population')
    xlabel('Cell Population')
    if out_path 
        saveas(wvc_fraction_fig, strcat(fig_path, 'fraction_of_population_modulated.fig'))
        saveas(wvc_fraction_fig, strcat(fig_path, 'fraction_of_population_modulated.png'))
    end

    close all 

    theta_modulated = [theta_modulated, ...
        table(theta_bars, ...
            Rs, ...
            kappas, ...
            theta_bars_hit, ...
            Rs_hit, ...
            kappas_hit, ...
            theta_bars_miss, ...
            Rs_miss, ...
            kappas_miss, ...
            theta_bars_cr, ...
            Rs_cr, ...
            kappas_cr, ...
            theta_bars_fa, ...
            Rs_fa, ...
            kappas_fa, ...
            pmi, ...
            pmi_hit, ...
            pmi_miss, ...
            pmi_cr, ...
            pmi_fa, ...
            pmi_correct, ...
            pmi_incorrect, ...
            pmi_action, ...
            pmi_inaction, ...
            mses, ...
            mses_hit, ...
            mses_miss, ...
            mses_cr, ...
            mses_fa, ...
            mses_correct, ...
            mses_incorrect, ...
            mses_action, ...
            mses_inaction, ...
            'VariableNames', ...
            {'theta_bars', ...
            'Rs', ...
            'kappas', ...
            'theta_bars_hit', ...
            'Rs_hit', ...
            'kappas_hit', ...
            'theta_bars_miss', ...
            'Rs_miss', ...
            'kappas_miss', ...
            'theta_bars_cr', ...
            'Rs_cr', ...
            'kappas_cr', ...
            'theta_bars_fa', ...
            'Rs_fa', ...
            'kappas_fa', ...
            'pmi', ...
            'pmi_hit', ...
            'pmi_miss', ...
            'pmi_cr', ...
            'pmi_fa', ...
            'pmi_correct', ...
            'pmi_incorrect', ...
            'pmi_action', ...
            'pmi_inaction', ...
            'mses', ...
            'mses_hit', ...
            'mses_miss', ...
            'mses_cr', ...
            'mses_fa', ...
            'mses_correct', ...
            'mses_incorrect', ...
            'mses_action', ...
            'mses_inaction'})];
    theta_modulated = [theta_modulated, table(p_value, ...
                p_value_hit, ...
                p_value_miss, ...
                p_value_cr, ...
                p_value_fa, ...
                p_correct, ...
                p_incorrect, ...
                p_action, ...
                p_inaction, ...
                'VariableNames', ...
                {'p_value', ...
                'p_value_hit', ...
                'p_value_miss', ...
                'p_value_cr', ...
                'p_value_fa', ...
                'p_correct', ...
                'p_incorrect', ...
                'p_action', ...
                'p_inaction'})];

    out = struct();
    out.theta_modulated = theta_modulated;
    out.rs_frac = rs_frac;
    out.fs_frac = fs_frac;
    out.ps_frac = ps_frac;
    out.ts_frac = ts_frac;
    out.pct_theta_modulated = pct_theta_modulated;
    out.overall_p_threshold = overall_p_threshold;
    save(strcat(fig_path, 'data.mat'), 'out', '-v7.3');

end