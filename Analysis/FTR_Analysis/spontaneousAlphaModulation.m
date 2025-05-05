function spontaneousAlphaModulation(ap_session, visualize, out_path)

    if out_path
        fig_path = strcat(out_path, 'Spontaneous_Alpha_Modulation_v2/');
        mkdir(fig_path)
        mkdir(strcat(fig_path, 'Overall_Phase_Preference_v2/'));
        mkdir(strcat(fig_path, 'Phase_Preference_By_Outcome_v2/'));
        mkdir(strcat(fig_path, 'Correct_vs_Incorrect_v2/'));
        mkdir(strcat(fig_path, 'Action_vs_Inaction_v2/'));
        mkdir(strcat(fig_path, 'Lick_vs_nolick_v2/'));
        mkdir(strcat(fig_path, 'Combo_v2/'));
    end

    p_value = zeros(size(ap_session,1),1);
    p_value_lick = zeros(size(ap_session,1),1);
    p_value_nolick = zeros(size(ap_session,1),1);
    p_value_hit = zeros(size(ap_session,1),1);
    p_value_miss = zeros(size(ap_session,1),1);
    p_value_cr = zeros(size(ap_session,1),1);
    p_value_fa = zeros(size(ap_session,1),1);
    
    mi = zeros(size(ap_session,1),1);
    mi_lick = zeros(size(ap_session,1),1);
    mi_nolick = zeros(size(ap_session,1),1);
    mi_hit = zeros(size(ap_session,1),1);
    mi_miss = zeros(size(ap_session,1),1);
    mi_cr = zeros(size(ap_session,1),1);
    mi_fa = zeros(size(ap_session,1),1);

    for c = 1:size(ap_session,1)
        % spontaneous
        if ~isempty(ap_session(c,:).spon_alpha_spike_phases{1})
            [p, ~] = circ_rtest(ap_session(c,:).spon_alpha_spike_phases{1});
            p_value(c) = p;
            [N, ~] = histcounts(ap_session(c,:).spon_alpha_spike_phases{1}, 20);
            mi(c) = compute_modulation_index(N);
        else
            p_value(c) = nan;
            mi(c) = nan;
        end

        % lick
        if ~isempty(ap_session(c,:).alpha_spike_phases_lick{1})
            [p, ~] = circ_rtest(ap_session(c,:).alpha_spike_phases_lick{1});
            p_value_lick(c) = p;
            [N, ~] = histcounts(ap_session(c,:).alpha_spike_phases_lick{1}, 20);
            mi_lick(c) = compute_modulation_index(N);
        else
            p_value_lick(c) = nan;
            mi_lick(c) = nan;
        end

        % no lick
        if ~isempty(ap_session(c,:).alpha_spike_phases_nolick{1})
            [p, ~] = circ_rtest(ap_session(c,:).alpha_spike_phases_nolick{1});
            p_value_nolick(c) = p;
            [N, ~] = histcounts(ap_session(c,:).alpha_spike_phases_nolick{1}, 20);
            mi_nolick(c) = compute_modulation_index(N);
        else
            p_value_lick(c) = nan;
            mi_nolick(c) = nan;
        end

        % hit trials 
        if ~isempty(ap_session(c,:).spon_alpha_spike_phases_hit{1})
            [p, ~] = circ_rtest(ap_session(c,:).spon_alpha_spike_phases_hit{1});
            p_value_hit(c) = p;
            [N, ~] = histcounts(ap_session(c,:).spon_alpha_spike_phases_hit{1});
            mi_hit(c) = compute_modulation_index(N);
        else
            p_value_hit(c) = nan;
            mi_hit(c) = nan;
        end
        % miss trials 
        if ~isempty(ap_session(c,:).spon_alpha_spike_phases_miss{1})
            [p, ~] = circ_rtest(ap_session(c,:).spon_alpha_spike_phases_miss{1});
            p_value_miss(c) = p;
            [N, ~] = histcounts(ap_session(c,:).spon_alpha_spike_phases_miss{1});
            mi_miss(c) = compute_modulation_index(N);
        else
            p_value_miss(c) = nan;
            mi_miss(c) = nan;
        end
        % CR trials
        if ~isempty(ap_session(c,:).spon_alpha_spike_phases_cr{1}) 
            [p, ~] = circ_rtest(ap_session(c,:).spon_alpha_spike_phases_cr{1});
            p_value_cr(c) = p;
            [N, ~] = histcounts(ap_session(c,:).spon_alpha_spike_phases_cr{1});
            mi_cr(c) = compute_modulation_index(N);
        else
            p_value_cr(c) = nan;
            mi_cr(c) = nan;
        end
        % FA trials 
        if ~isempty(ap_session(c,:).spon_alpha_spike_phases_fa{1})
            [p, ~] = circ_rtest(ap_session(c,:).spon_alpha_spike_phases_fa{1});
            p_value_fa(c) = p;
            [N, ~] = histcounts(ap_session(c,:).spon_alpha_spike_phases_fa{1});
            mi_fa(c) = compute_modulation_index(N);
        else
            p_value_fa(c) = nan;
            mi_fa(c) = nan;
        end
    end

    % alpha_modulated = ap_session(cell2mat(p_value) < cell2mat(p_threshold),:);
    alpha_modulated = ap_session(p_value < (0.5 / size(ap_session,1)),:);
    pct_alpha_modulated = size(alpha_modulated,1) / size(ap_session,1);
    overall_p_threshold = (0.5 / size(ap_session,1));
    
    p_value_hit = p_value_hit(p_value < overall_p_threshold);
    p_value_miss = p_value_miss(p_value < overall_p_threshold);
    p_value_cr = p_value_cr(p_value < overall_p_threshold);
    p_value_fa = p_value_fa(p_value < overall_p_threshold);
    p_value = p_value(p_value < overall_p_threshold);

    mi = mi(p_value < overall_p_threshold);
    mi_hit = mi_hit(p_value < overall_p_threshold);
    mi_miss = mi_miss(p_value < overall_p_threshold);
    mi_cr = mi_cr(p_value < overall_p_threshold);
    mi_fa = mi_fa(p_value < overall_p_threshold);
    mi_lick = mi_lick(p_value < overall_p_threshold);
    mi_nolick = mi_nolick(p_value < overall_p_threshold);

    theta_bars = zeros(size(alpha_modulated,1),1);
    Rs = zeros(size(alpha_modulated,1),1);
    kappas = zeros(size(alpha_modulated,1),1);
    theta_bars_hit = zeros(size(alpha_modulated,1),1);
    Rs_hit = zeros(size(alpha_modulated,1),1);
    kappas_hit = zeros(size(alpha_modulated,1),1);
    theta_bars_miss = zeros(size(alpha_modulated,1),1);
    Rs_miss = zeros(size(alpha_modulated,1),1);
    kappas_miss = zeros(size(alpha_modulated,1),1);
    theta_bars_cr = zeros(size(alpha_modulated,1),1);
    Rs_cr = zeros(size(alpha_modulated,1),1);
    kappas_cr = zeros(size(alpha_modulated,1),1);
    theta_bars_fa = zeros(size(alpha_modulated,1),1);
    Rs_fa = zeros(size(alpha_modulated,1),1);
    kappas_fa = zeros(size(alpha_modulated,1),1);
    pmi = zeros(size(alpha_modulated,1),1);
    pmi_hit = zeros(size(alpha_modulated,1),1);
    pmi_miss = zeros(size(alpha_modulated,1),1);
    pmi_cr = zeros(size(alpha_modulated,1),1);
    pmi_fa = zeros(size(alpha_modulated,1),1);
    pmi_correct = zeros(size(alpha_modulated,1),1);
    pmi_incorrect = zeros(size(alpha_modulated,1),1);
    pmi_action = zeros(size(alpha_modulated,1),1);
    pmi_inaction = zeros(size(alpha_modulated,1),1);
    pmi_lick = zeros(size(alpha_modulated,1),1);
    pmi_nolick = zeros(size(alpha_modulated,1),1);
    theta_bars_correct = zeros(size(alpha_modulated,1),1);
    theta_bars_incorrect = zeros(size(alpha_modulated,1),1);
    theta_bars_action = zeros(size(alpha_modulated,1),1);
    theta_bars_inaction = zeros(size(alpha_modulated,1),1);
    theta_bars_lick = zeros(size(alpha_modulated,1),1);
    theta_bars_nolick = zeros(size(alpha_modulated,1),1);
    mses = zeros(size(alpha_modulated,1),1);
    mses_hit = zeros(size(alpha_modulated,1),1);
    mses_miss = zeros(size(alpha_modulated,1),1);
    mses_cr = zeros(size(alpha_modulated,1),1);
    mses_fa = zeros(size(alpha_modulated,1),1);
    mses_correct = zeros(size(alpha_modulated,1),1);
    mses_incorrect = zeros(size(alpha_modulated,1),1);
    mses_action = zeros(size(alpha_modulated,1),1);
    mses_inaction = zeros(size(alpha_modulated,1),1);
    mses_lick = zeros(size(alpha_modulated,1),1);
    mses_nolick = zeros(size(alpha_modulated,1),1);
    p_correct = zeros(size(alpha_modulated,1),1);
    p_incorrect = zeros(size(alpha_modulated,1),1);
    p_action = zeros(size(alpha_modulated,1),1);
    p_inaction = zeros(size(alpha_modulated,1),1);
    p_lick = zeros(size(alpha_modulated,1),1);
    p_nolick = zeros(size(alpha_modulated,1),1);

    for i = 1:size(alpha_modulated,1)
        % overall spontaneous phase modulation 
        %% computations 
        [N, edges] = histcounts(alpha_modulated(i,:).spon_alpha_spike_phases{1}, 20, 'Normalization', 'pdf');
        centers = zeros(length(edges)-1,1);
        for e = 1:(length(edges)-1)
            centers(e) = mean(edges(e:(e+1)));
        end
        [x,y, theta_bars(i), Rs(i), kappas(i)] = vonMises(alpha_modulated(i,:).spon_alpha_spike_phases{1});
        pmi(i) = compute_modulation_index(N);
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
        % title(sprintf('%s %s: p = %.2d; p-threshold=%.2d', alpha_modulated(i,:).region{1}, alpha_modulated(i,:).waveform_class{1}, p_value(i), p_threshold(i)))
        title(sprintf('*Overall: PMI: %.2f; MSE: %.1d', pmi(i), mses(i)))
        yvals = yticks;
        yticks([yvals(1), yvals(end)])
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;
        if out_path 
            fname = sprintf('%s_cluster_%i', alpha_modulated(i,:).session_id{1}, alpha_modulated(i,:).cluster_id);
            saveas(spon_fig, strcat(fig_path, 'Overall_Phase_Preference_v2/', fname, '.fig'))
            saveas(spon_fig, strcat(fig_path, 'Overall_Phase_Preference_v2/', fname, '.png'))
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
        if ~isempty(alpha_modulated(i,:).left_trigger_aligned_avg_fr_Hit{1})
            plot(linspace(-2.8,4.9,80), alpha_modulated(i,:).left_trigger_aligned_avg_fr_Hit{1}, 'k')
        end
        title('Hit')
        xlim([-3,5])
        axs(1,2) = nexttile;
        if ~isempty(alpha_modulated(i,:).left_trigger_aligned_avg_fr_Miss{1})
            plot(linspace(-2.8,4.9,80), alpha_modulated(i,:).left_trigger_aligned_avg_fr_Miss{1}, 'k')
        end
        title('Miss')
        xlim([-3,5])
        axs(1,3) = nexttile;
        if ~isempty(alpha_modulated(i,:).right_trigger_aligned_avg_fr_CR{1})
            plot(linspace(-2.8,4.9,80), alpha_modulated(i,:).right_trigger_aligned_avg_fr_CR{1}, 'k')
        end
        title('CR')
        xlim([-3,5])
        axs(1,4) = nexttile;
        if ~isempty(alpha_modulated(i,:).right_trigger_aligned_avg_fr_FA{1})
            plot(linspace(-2.8,4.9,80), alpha_modulated(i,:).right_trigger_aligned_avg_fr_FA{1}, 'k')
        end
        title('FA')
        xlim([-3,5])
        unifyYLimits(axs(1,:))
        axs(2,1) = nexttile;
        %%% plotting phase modulation
        if ~isempty(alpha_modulated(i,:).spon_alpha_spike_phases_hit{1})
            [N, edges] = histcounts(alpha_modulated(i,:).spon_alpha_spike_phases_hit{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_hit(i), Rs_hit(i), kappas_hit(i)] = vonMises(alpha_modulated(i,:).spon_alpha_spike_phases_hit{1});
            pmi_hit(i) = compute_modulation_index(N);
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
        if ~isempty(alpha_modulated(i,:).spon_alpha_spike_phases_miss{1})   
            [N, edges] = histcounts(alpha_modulated(i,:).spon_alpha_spike_phases_miss{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_miss(i), Rs_miss(i), kappas_miss(i)] = vonMises(alpha_modulated(i,:).spon_alpha_spike_phases_miss{1});
            pmi_miss(i) = compute_modulation_index(N);
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
        if ~isempty(alpha_modulated(i,:).spon_alpha_spike_phases_cr{1})
            [N, edges] = histcounts(alpha_modulated(i,:).spon_alpha_spike_phases_cr{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_cr(i), Rs_cr(i), kappas_cr(i)] = vonMises(alpha_modulated(i,:).spon_alpha_spike_phases_cr{1});
            pmi_cr(i) = compute_modulation_index(N);
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
        if ~isempty(alpha_modulated(i,:).spon_alpha_spike_phases_fa{1})
            [N, edges] = histcounts(alpha_modulated(i,:).spon_alpha_spike_phases_fa{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_fa(i), Rs_fa(i), kappas_fa(i)] = vonMises(alpha_modulated(i,:).spon_alpha_spike_phases_fa{1});
            pmi_fa(i) = compute_modulation_index(N);
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
        title(tl, sprintf('%s %s', alpha_modulated(i,:).region{1}, alpha_modulated(i,:).waveform_class{1}))
        if out_path
            fname = sprintf('%s_cluster_%i.fig', alpha_modulated(i,:).session_id{1}, alpha_modulated(i,:).cluster_id);
            saveas(outcome_fig, strcat(fig_path, 'Phase_Preference_By_Outcome_v2/', fname))
            fname = sprintf('%s_cluster_%i.png', alpha_modulated(i,:).session_id{1}, alpha_modulated(i,:).cluster_id);
            saveas(outcome_fig, strcat(fig_path, 'Phase_Preference_By_Outcome_v2/', fname))
        end

        %% correct vs incorrect
        if visualize
            correct_fig = figure('Position', [1220, 1256, 1401, 582]);
        else
            correct_fig = figure('Visible', 'off', 'Position', [1220, 1256, 1401, 582]);
        end
        correct_tl = tiledlayout(1,2);
        correct = [alpha_modulated(i,:).spon_alpha_spike_phases_hit{1}, alpha_modulated(i,:).spon_alpha_spike_phases_cr{1}];
        incorrect = [alpha_modulated(i,:).spon_alpha_spike_phases_miss{1}, alpha_modulated(i,:).spon_alpha_spike_phases_fa{1}];
        p_threshold_correct(i) = 0.05 / length(correct);
        p_threshold_incorrect(i) = 0.05 / length(incorrect);
        if ~isempty(correct) && ~isempty(incorrect)
            [p_correct(i), ~] = circ_rtest(correct);
            [p_incorrect(i), ~] = circ_rtest(incorrect);
            correct_axs(1) = nexttile;
            [N, edges] = histcounts(correct, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_correct(i), Rs_correct(i), kappas_correct(i)] = vonMises(correct);
            pmi_correct(i) = compute_modulation_index(N);
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
            pmi_incorrect(i) = compute_modulation_index(N);
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
            title(correct_tl, sprintf('%s %s', alpha_modulated(i,:).region{1}, alpha_modulated(i,:).waveform_class{1}))
            if out_path
                fname = sprintf('%s_cluster_%i.fig', alpha_modulated(i,:).session_id{1}, alpha_modulated(i,:).cluster_id);
                saveas(correct_fig, strcat(fig_path, 'Correct_vs_Incorrect_v2/', fname))
                fname = sprintf('%s_cluster_%i.png', alpha_modulated(i,:).session_id{1}, alpha_modulated(i,:).cluster_id);
                saveas(correct_fig, strcat(fig_path, 'Correct_vs_Incorrect_v2/', fname))
            end
        else
            p_correct(i) = nan;
            p_incorrect(i) = nan;
            theta_bars_correct(i) = nan;
            Rs_correct(i) = nan;
            kappas_correct(i) = nan;
            theta_bars_incorrect(i) = nan;
            Rs_incorrect(i) = nan;
            kappas_incorrect(i) = nan;
        end

        
        %% action vs inaction
        if visualize
            action_fig = figure('Position', [1220, 1256, 1401, 582]);
        else
            action_fig = figure('Visible', 'off', 'Position', [1220, 1256, 1401, 582]);
        end
        action_tl = tiledlayout(1,2);
        action = [alpha_modulated(i,:).spon_alpha_spike_phases_hit{1}, alpha_modulated(i,:).spon_alpha_spike_phases_fa{1}];
        inaction = [alpha_modulated(i,:).spon_alpha_spike_phases_miss{1}, alpha_modulated(i,:).spon_alpha_spike_phases_cr{1}];
        p_threshold_action(i) = 0.05 / length(action);
        p_threshold_inaction(i) = 0.05 / length(inaction);
        if ~isempty(action) && ~isempty(inaction)
            [p_action(i), ~] = circ_rtest(action);
            [p_inaction(i), ~] = circ_rtest(inaction);
            action_axs(1) = nexttile;
            [N, edges] = histcounts(action, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_action(i), Rs_action(i), kappas_action(i)] = vonMises(action);
            pmi_action(i) = compute_modulation_index(N);
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
            pmi_inaction(i) = compute_modulation_index(N);
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
                fname = sprintf('%s_cluster_%i.fig', alpha_modulated(i,:).session_id{1}, alpha_modulated(i,:).cluster_id);
                saveas(action_fig, strcat(fig_path, 'Action_vs_Inaction_v2/', fname))
                fname = sprintf('%s_cluster_%i.png', alpha_modulated(i,:).session_id{1}, alpha_modulated(i,:).cluster_id);
                saveas(action_fig, strcat(fig_path, 'Action_vs_Inaction_v2/', fname))
            end
        else
            p_action(i) = nan;
            p_inaction(i) = nan;
            theta_bars_action(i) = nan;
            Rs_action(i) = nan;
            kappas_action(i) = nan;
            theta_bars_inaction(i) = nan;
            Rs_inaction(i) = nan;
            kappas_inaction(i) = nan;
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
        [N, edges] = histcounts(alpha_modulated(i,:).spon_alpha_spike_phases{1}, 20, 'Normalization', 'pdf');
        centers = zeros(length(edges)-1,1);
        for e = 1:(length(edges)-1)
            centers(e) = mean(edges(e:(e+1)));
        end
        [x,y, theta_bars(i), Rs(i), kappas(i)] = vonMises(alpha_modulated(i,:).spon_alpha_spike_phases{1});
        bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
        hold on
        plot(x,y, 'k', 'LineWidth', 2);
        xticks([-pi, 0, pi])
        xticklabels({'-\pi', '0', '\pi'})
        % title(sprintf('%s %s: p = %.2d; p-threshold=%.2d', alpha_modulated(i,:).region{1}, alpha_modulated(i,:).waveform_class{1}, p_value(i), p_threshold(i)))
        title(sprintf('*Overall: PMI: %.2f; MSE: %.1d', pmi(i), mses(i)))
        yvals = yticks;
        yticks([yvals(1), yvals(end)])
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;
        axs_combo(2) = nexttile;
        if ~isempty(alpha_modulated(i,:).left_trigger_aligned_avg_fr_Hit{1})
            plot(linspace(-2.8,4.9,80), alpha_modulated(i,:).left_trigger_aligned_avg_fr_Hit{1}, 'k')
        end
        title('Hit')
        xlim([-3,5])
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;
        axs_combo(3) = nexttile;
        if ~isempty(alpha_modulated(i,:).left_trigger_aligned_avg_fr_Miss{1})
            plot(linspace(-2.8,4.9,80), alpha_modulated(i,:).left_trigger_aligned_avg_fr_Miss{1}, 'k')
        end
        title('Miss')
        xlim([-3,5])
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;
        axs_combo(4) = nexttile;
        if ~isempty(alpha_modulated(i,:).right_trigger_aligned_avg_fr_CR{1})
            plot(linspace(-2.8,4.9,80), alpha_modulated(i,:).right_trigger_aligned_avg_fr_CR{1}, 'k')
        end
        title('CR')
        xlim([-3,5])
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;
        axs_combo(5) = nexttile;
        if ~isempty(alpha_modulated(i,:).right_trigger_aligned_avg_fr_FA{1})
            plot(linspace(-2.8,4.9,80), alpha_modulated(i,:).right_trigger_aligned_avg_fr_FA{1}, 'k')
        end
        title('FA')
        xlim([-3,5])
        ax = gca;  % Get current axes
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;
        axs_combo(6) = nexttile;
        if ~isempty(alpha_modulated(i,:).spon_alpha_spike_phases_hit{1})
            [N, edges] = histcounts(alpha_modulated(i,:).spon_alpha_spike_phases_hit{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_hit(i), Rs_hit(i), kappas_hit(i)] = vonMises(alpha_modulated(i,:).spon_alpha_spike_phases_hit{1});
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
        if ~isempty(alpha_modulated(i,:).spon_alpha_spike_phases_miss{1})   
            [N, edges] = histcounts(alpha_modulated(i,:).spon_alpha_spike_phases_miss{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_miss(i), Rs_miss(i), kappas_miss(i)] = vonMises(alpha_modulated(i,:).spon_alpha_spike_phases_miss{1});
            pmi_miss(i) = compute_modulation_index(N);
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
        if ~isempty(alpha_modulated(i,:).spon_alpha_spike_phases_cr{1})
            [N, edges] = histcounts(alpha_modulated(i,:).spon_alpha_spike_phases_cr{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_cr(i), Rs_cr(i), kappas_cr(i)] = vonMises(alpha_modulated(i,:).spon_alpha_spike_phases_cr{1});
            pmi_cr(i) = compute_modulation_index(N);
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
        if ~isempty(alpha_modulated(i,:).spon_alpha_spike_phases_fa{1})
            [N, edges] = histcounts(alpha_modulated(i,:).spon_alpha_spike_phases_fa{1}, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_fa(i), Rs_fa(i), kappas_fa(i)] = vonMises(alpha_modulated(i,:).spon_alpha_spike_phases_fa{1});
            pmi_fa(i) = compute_modulation_index(N);
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
        if ~isempty(correct)
            [N, edges] = histcounts(correct, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_correct(i), Rs_correct(i), kappas_correct(i)] = vonMises(correct);
            pmi_correct(i) = compute_modulation_index(N);
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
        end
        
        axs_combo(11) = nexttile([1,2]);
        if ~isempty(incorrect)
            [N, edges] = histcounts(incorrect, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_incorrect(i), Rs_incorrect(i), kappas_incorrect(i)] = vonMises(incorrect);
            pmi_incorrect(i) = compute_modulation_index(N);
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
        end

        axs_combo(12) = nexttile([1,2]);
        if ~isempty(action)
            [N, edges] = histcounts(action, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_action(i), Rs_action(i), kappas_action(i)] = vonMises(action);
            pmi_action(i) = compute_modulation_index(N);
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
        end 

        axs_combo(13) =  nexttile([1,2]);
        if ~isempty(inaction)
            [N, edges] = histcounts(inaction, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_inaction(i), Rs_inaction(i), kappas_inaction(i)] = vonMises(inaction);
            pmi_inaction(i) = compute_modulation_index(N);
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
        end

        if startsWith(alpha_modulated(i,:).region{1}, 'SS')
            t = sprintf('Somatosensory Cortex: %s', alpha_modulated(i,:).waveform_class{1});
        elseif strcmp(alpha_modulated(i,:).region{1}, 'CP') || strcmp(alpha_modulated(i,:).region{1}, 'STR')
            t = sprintf('Basal Ganglia: %s', alpha_modulated(i,:).waveform_class{1});
        elseif startsWith(alpha_modulated(i,:).region{1}, 'IL') || startsWith(alpha_modulated(i,:).region{1}, 'PL') || ... 
            startsWith(alpha_modulated(i,:).region{1}, 'AC') || startsWith(alpha_modulated(i,:).region{1}, 'DP')
            t = sprintf('Prefrontal Cortex: %s', alpha_modulated(i,:).waveform_class{1});
        elseif startsWith(alpha_modulated(i,:).region{1}, 'LA') || startsWith(alpha_modulated(i,:).region{1}, 'BL')
            t = sprintf('Amygdala: %s', alpha_modulated(i,:).waveform_class{1});
        else
            t = sprintf('Other: %s', alpha_modulated(i,:).waveform_class{1});
        end
        title(tl_combo, t)
        unifyYLimits(axs_combo(2:5))
        unifyYLimits(axs_combo(6:9))
        unifyYLimits(axs_combo(10:13))
        if out_path 
            fname = sprintf('%s_cluster_%i.fig', alpha_modulated(i,:).session_id{1}, alpha_modulated(i,:).cluster_id);
            saveas(combo_fig, strcat(fig_path, 'Combo_v2/', fname))
            fname = sprintf('%s_cluster_%i.png', alpha_modulated(i,:).session_id{1}, alpha_modulated(i,:).cluster_id);
            saveas(combo_fig, strcat(fig_path, 'Combo_v2/', fname))
        end
        
        %% lick vs no lick trials 
        if visualize
            lick_fig = figure('Position', [1220, 1256, 1401, 582]);
        else
            lick_fig = figure('Visible', 'off', 'Position', [1220, 1256, 1401, 582]);
        end
        lick_tl = tiledlayout(1,2);
        lick = alpha_modulated(i,:).alpha_spike_phases_lick{1};
        nolick = alpha_modulated(i,:).alpha_spike_phases_nolick{1};
        p_threshold_lick(i) = 0.05 / length(lick);
        p_threshold_nolick(i) = 0.05 / length(nolick);
        if ~isempty(lick) && ~isempty(nolick)
            [p_lick(i), ~] = circ_rtest(lick);
            [p_nolick(i), ~] = circ_rtest(nolick);
            lick_axs(1) = nexttile;
            [N, edges] = histcounts(lick, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_lick(i), Rs_lick(i), kappas_lick(i)] = vonMises(lick);
            pmi_lick(i) = compute_modulation_index(N);
            y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
            mses_lick(i) = mean((N(2:end-1) - y_interpolated').^2);
            bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
            hold on
            plot(x,y, 'k', 'LineWidth', 2);
            xticks([-pi, 0, pi])
            xticklabels({'-\pi', '0', '\pi'})
            if p_lick(i) < (0.5 / size(ap_session,1))
                title(sprintf('*Lick: PMI: %.2f; MSE: %.1d', pmi_lick(i), mses_lick(i)))
            else
                title(sprintf('Lick: PMI: %.2f; MSE: %.1d', pmi_lick(i), mses_lick(i)))
            end
            axs(2) = nexttile;
            [N, edges] = histcounts(nolick, 20, 'Normalization', 'pdf');
            centers = zeros(length(edges)-1,1);
            for e = 1:(length(edges)-1)
                centers(e) = mean(edges(e:(e+1)));
            end
            [x,y, theta_bars_nolick(i), Rs_nolick(i), kappas_nolick(i)] = vonMises(nolick);
            pmi_nolick(i) = compute_modulation_index(N);
            y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
            mses_nolick(i) = mean((N(2:end-1) - y_interpolated').^2);
            bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
            hold on
            plot(x,y, 'k', 'LineWidth', 2);
            xticks([-pi, 0, pi])
            xticklabels({'-\pi', '0', '\pi'})
            if p_nolick(i) < (0.5 / size(ap_session,1))
                title(sprintf('*No Lick: PMI: %.2f; MSE: %.1d', pmi_nolick(i), mses_nolick(i)))
            else
                title(sprintf('No Lick: PMI: %.2f; MSE: %.1d', pmi_nolick(i), mses_nolick(i)))
            end
            if out_path
                fname = sprintf('%s_cluster_%i.fig', alpha_modulated(i,:).session_id{1}, alpha_modulated(i,:).cluster_id);
                saveas(lick_fig, strcat(fig_path, 'lick_vs_nolick_v2/', fname))
                fname = sprintf('%s_cluster_%i.png', alpha_modulated(i,:).session_id{1}, alpha_modulated(i,:).cluster_id);
                saveas(lick_fig, strcat(fig_path, 'lick_vs_nolick_v2/', fname))
            end
        else
            p_lick(i) = nan;
            p_nolick(i) = nan;
            theta_bars_lick(i) = nan;
            Rs_lick(i) = nan;
            kappas_lick(i) = nan;
            theta_bars_nolick(i) = nan;
            Rs_nolick(i) = nan;
            kappas_nolick(i) = nan;
        end
        
    end

    session_ids = unique(alpha_modulated.session_id);
    
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
    bar([1,2], [sum(p_correct < overall_p_threshold) / size(alpha_modulated,1), sum(p_incorrect < overall_p_threshold) / size(alpha_modulated,1)], ...
        'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    ylabel('Fraction of Modulated Neurons')
    xticks([1,2])
    xticklabels({'Correct', 'Incorrect'})
    if out_path 
        saveas(correct_fraction_fig, strcat(fig_path, 'correct_fraction_modulated.fig'))
        saveas(correct_fraction_fig, strcat(fig_path, 'correct_fraction_modulated.png'))
    end

    p_correct_bySession = cell(size(session_ids));
    p_incorrect_bySession = cell(size(session_ids));
    for s = 1:length(session_ids)
        tmp = alpha_modulated(strcmp(alpha_modulated.session_id, session_ids{s}),:);
        p_correct_bySession{s} = p_correct(strcmp(alpha_modulated.session_id, session_ids{s}));
        p_incorrect_bySession{s} = p_incorrect(strcmp(alpha_modulated.session_id, session_ids{s}));
        correct_fractions(s) = sum(p_correct_bySession{s} < overall_p_threshold) / size(tmp,1);
        incorrect_fractions(s) = sum(p_incorrect_bySession{s} < overall_p_threshold) / size(tmp,1);
    end

    if visualize
        correct_fraction_by_session_fig = figure();
    else
        correct_fraction_by_session_fig = figure('Visible', 'off');
    end
    bar([1,2], [mean(correct_fractions), mean(incorrect_fractions)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    hold on 
    errorbar(1:2, [mean(correct_fractions), mean(incorrect_fractions)], [std(correct_fractions)/sqrt(length(correct_fractions)), std(incorrect_fractions)/sqrt(length(incorrect_fractions))], 'k.')
    ylabel('Fraction of Modulated Neurons')
    xticks([1,2])
    xticklabels({'Correct', 'Incorrect'})
    if out_path 
        saveas(correct_fraction_by_session_fig, strcat(fig_path, 'correct_fraction_by_session_modulated.fig'))
        saveas(correct_fraction_by_session_fig, strcat(fig_path, 'correct_fraction_by_session_modulated.png'))
    end
    sprintf('Correct vs incorrect: %f', ranksum(correct_fractions, incorrect_fractions))
    

    p_action_bySession = cell(size(session_ids));
    p_inaction_bySession = cell(size(session_ids));
    for s = 1:length(session_ids)
        tmp = alpha_modulated(strcmp(alpha_modulated.session_id, session_ids{s}),:);
        p_action_bySession{s} = p_action(strcmp(alpha_modulated.session_id, session_ids{s}));
        p_inaction_bySession{s} = p_inaction(strcmp(alpha_modulated.session_id, session_ids{s}));
        action_fractions(s) = sum(p_action_bySession{s} < overall_p_threshold) / size(tmp,1);
        inaction_fractions(s) = sum(p_inaction_bySession{s} < overall_p_threshold) / size(tmp,1);
    end
    
    if visualize
        action_fraction_by_session_fig = figure();
    else
        action_fraction_by_session_fig = figure('Visible', 'off');
    end
    bar([1,2], [mean(action_fractions), mean(inaction_fractions)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    hold on 
    errorbar(1:2, [mean(action_fractions), mean(inaction_fractions)], [std(action_fractions)/sqrt(length(action_fractions)), std(inaction_fractions)/sqrt(length(inaction_fractions))], 'k.')
    ylabel('Fraction of Modulated Neurons')
    xticks([1,2])
    xticklabels({'Action', 'Inaction'})
    if out_path 
        saveas(action_fraction_by_session_fig, strcat(fig_path, 'action_fraction_by_session_modulated.fig'))
        saveas(action_fraction_by_session_fig, strcat(fig_path, 'action_fraction_by_session_modulated.png'))
    end
    sprintf('Action vs inaction: %f', ranksum(action_fractions, inaction_fractions))

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
    bar([1,2], [sum(p_action < overall_p_threshold) / size(alpha_modulated,1), sum(p_inaction < overall_p_threshold) / size(alpha_modulated,1)], ...
        'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    ylabel('Fraction of Modulated Neurons')
    xticks([1,2])
    xticklabels({'Action', 'Inaction'})
    if out_path 
        saveas(action_fraction_fig, strcat(fig_path, 'action_fraction_modulated.fig'))
        saveas(action_fraction_fig, strcat(fig_path, 'action_fraction_modulated.png'))
    end

    rs_frac = sum(strcmp(alpha_modulated.waveform_class, 'RS')) / sum(strcmp(ap_session.waveform_class, 'RS'));
    fs_frac = sum(strcmp(alpha_modulated.waveform_class, 'FS')) / sum(strcmp(ap_session.waveform_class, 'FS'));
    ps_frac = sum(strcmp(alpha_modulated.waveform_class, 'PS')) / sum(strcmp(ap_session.waveform_class, 'PS'));
    ts_frac = sum(strcmp(alpha_modulated.waveform_class, 'TS')) / sum(strcmp(ap_session.waveform_class, 'TS'));
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

    if visualize
        lick_pmi_fig = figure('Position', [1220, 1379, 1019, 459]);
    else
        lick_pmi_fig = figure('Visible', 'off', 'Position', [1220, 1379, 1019, 459]);
    end
    bar(1:2, [nanmean(pmi_lick), nanmean(pmi_nolick)], 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5, 0.5])
    hold on
    errorbar(1:2, [nanmean(pmi_lick), nanmean(pmi_nolick)], [nanstd(pmi_lick) ./ sqrt(length(pmi_lick)), nanstd(pmi_nolick) ./ sqrt(length(pmi_lick))], 'k.')
    xticks(1:2)
    xticklabels({'Lick', 'No Lick'})
    ylabel('Phase Modulation Index')
    if out_path 
        saveas(lick_pmi_fig, strcat(fig_path, 'lick_pmi.fig'))
        saveas(lick_pmi_fig, strcat(fig_path, 'lick_pmi.png'))
    end
    
    if visualize
        lick_mses_fig = figure('Position', [1220, 1379, 1019, 459]);
    else
        lick_mses_fig = figure('Visible', 'off', 'Position', [1220, 1379, 1019, 459]);
    end
    bar(1:2, [nanmean(mses_lick), nanmean(mses_nolick)], 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5, 0.5])
    hold on
    errorbar(1:2, [nanmean(mses_lick), nanmean(mses_nolick)], [nanstd(mses_lick) ./ sqrt(length(mses_lick)), nanstd(mses_nolick) ./ sqrt(length(mses_lick))], 'k.')
    xticks(1:2)
    xticklabels({'Lick', 'No Lick'})
    ylabel('M.S.E.')
    if out_path 
        saveas(lick_mses_fig, strcat(fig_path, 'lick_mses.fig'))
        saveas(lick_mses_fig, strcat(fig_path, 'lick_mses.png'))
    end

    if visualize
        lick_theta_fig = figure('Position', [1220, 1379, 1019, 459]);
    else
        lick_theta_fig = figure('Visible', 'off', 'Position', [1220, 1379, 1019, 459]);
    end
    attl = tiledlayout(1,2);
    ataxs(1) = nexttile;
    polarhistogram(theta_bars_lick, 36)
    title('Lick')
    ataxs(2) = nexttile;
    polarhistogram(theta_bars_nolick, 36)
    title('No Lick')
    if out_path 
        saveas(lick_theta_fig, strcat(fig_path, 'lick_theta.fig'))
        saveas(lick_theta_fig, strcat(fig_path, 'lick_theta.png'))
    end
    
    if visualize
        lick_r_fig = figure();
    else
        lick_r_fig = figure('Visible', 'off');
    end
    bar([1,2], [nanmean(Rs_lick), nanmean(Rs_nolick)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    hold on
    errorbar([1,2], [nanmean(Rs_lick), nanmean(Rs_nolick)], [nanstd(Rs_lick) ./ sqrt(length(Rs_lick)), nanstd(Rs_nolick) ./ sqrt(length(Rs_nolick))], 'k.')
    xticks([1,2])
    xticklabels({'Correct', 'No Lick'})
    ylabel('R')
    if out_path 
        saveas(lick_r_fig, strcat(fig_path, 'lick_r.fig'))
        saveas(lick_r_fig, strcat(fig_path, 'lick_r.png'))
    end
    
    if visualize
        lick_kappa_fig = figure();
    else
        lick_kappa_fig = figure('Visible', 'off');
    end
    bar([1,2], [nanmean(kappas_lick), nanmean(kappas_nolick)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    hold on
    errorbar([1,2], [nanmean(kappas_lick), nanmean(kappas_nolick)], [nanstd(kappas_lick) ./ sqrt(length(kappas_lick)), nanstd(kappas_nolick) ./ sqrt(length(kappas_nolick))], 'k.')
    xticks([1,2])
    xticklabels({'Correct', 'No Lick'})
    ylabel('Kappa')
    if out_path 
        saveas(lick_kappa_fig, strcat(fig_path, 'lick_kappa.fig'))
        saveas(lick_kappa_fig, strcat(fig_path, 'lick_kappa.png'))
    end
    
    if visualize
        lick_nolick_fig = figure();
    else
        lick_nolick_fig = figure('Visible', 'off');
    end
    bar([1,2], [sum(p_lick < overall_p_threshold) / size(alpha_modulated,1), sum(p_nolick < overall_p_threshold) / size(alpha_modulated,1)], ...
        'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    ylabel('Frlick of Modulated Neurons')
    xticks([1,2])
    xticklabels({'Lick', 'No Lick'})
    if out_path 
        saveas(lick_nolick_fig, strcat(fig_path, 'lick_nolick_modulated.fig'))
        saveas(lick_nolick_fig, strcat(fig_path, 'lick_nolick_modulated.png'))
    end

    close all 

    alpha_modulated = [alpha_modulated, ...
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
            theta_bars_correct, ...
            theta_bars_incorrect, ...
            theta_bars_action, ...
            theta_bars_inaction, ...
            theta_bars_lick, ...
            kappas_lick, ...
            Rs_lick, ...
            mses_lick, ...
            pmi_lick, ...
            theta_bars_nolick, ...
            kappas_nolick, ...
            Rs_nolick, ...
            mses_nolick, ...
            pmi_nolick, ...
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
            'mses_inaction', ...
            'theta_bars_correct', ...
            'theta_bars_incorrect', ...
            'theta_bars_action', ...
            'theta_bars_inaction', ...
            'theta_bars_lick', ...
            'kappas_lick', ...
            'Rs_lick', ...
            'mses_lick', ...
            'pmi_lick', ...
            'theta_bars_nolick', ...
            'kappas_nolick', ...
            'Rs_nolick', ...
            'mses_nolick', ...
            'pmi_nolick'})];
    alpha_modulated = [alpha_modulated, table(p_value, ...
                p_value_hit, ...
                p_value_miss, ...
                p_value_cr, ...
                p_value_fa, ...
                p_correct, ...
                p_incorrect, ...
                p_action, ...
                p_inaction, ...
                p_lick, ...
                p_nolick, ...
                'VariableNames', ...
                {'p_value', ...
                'p_value_hit', ...
                'p_value_miss', ...
                'p_value_cr', ...
                'p_value_fa', ...
                'p_correct', ...
                'p_incorrect', ...
                'p_action', ...
                'p_inaction', ...
                'p_lick', ...
                'p_nolick'})];

    out = struct();
    out.alpha_modulated = alpha_modulated;
    out.rs_frac = rs_frac;
    out.fs_frac = fs_frac;
    out.ps_frac = ps_frac;
    out.ts_frac = ts_frac;
    out.pct_alpha_modulated = pct_alpha_modulated;
    out.overall_p_threshold = overall_p_threshold;
    save(strcat(fig_path, 'data.mat'), 'out', '-v7.3');

end