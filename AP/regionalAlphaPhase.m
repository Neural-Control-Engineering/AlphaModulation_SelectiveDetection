function [ctx_p_value, bg_p_value] = regionalAlphaPhase(ap_data, slrt_data, regMap)
    ctx_p_value = cell(size(ap_data,1),1);
    ctx_theta_bar = cell(size(ap_data,1),1);
    ctx_R = cell(size(ap_data,1),1);
    ctx_kappa = cell(size(ap_data,1),1);
    ctx_p_threshold = cell(size(ap_data,1),1);
    bg_p_value = cell(size(ap_data,1),1);
    bg_theta_bar = cell(size(ap_data,1),1);
    bg_R = cell(size(ap_data,1),1);
    bg_kappa = cell(size(ap_data,1),1);
    bg_p_threshold = cell(size(ap_data,1),1);
    for t = 1:size(ap_data,1)
        spon_alpha_phase = cell(size(ap_data(t,:).spiking_data{1},1),1);
        ap_data(t,:).spiking_data{1} = assignRegions(ap_data(t,:).spiking_data{1}, regMap);
        ap_data(t,:).spiking_data{1} = ap_data(t,:).spiking_data{1}(strcmp(ap_data(t,:).spiking_data{1}.quality, 'good'),:);
        for c = 1:size(ap_data(t,:).spiking_data{1},1)
            if isempty(ap_data(t,:).spiking_data{1}(c,:).left_trigger_aligned_spike_times{1})
                spike_times = ap_data(t,:).spiking_data{1}(c,:).right_trigger_aligned_spike_times{1};
            else
                spike_times  = ap_data(t,:).spiking_data{1}(c,:).left_trigger_aligned_spike_times{1};
            end
            alpha_phases = ap_data(t,:).spiking_data{1}(c,:).spike_alpha_phase{1};
            spon_alpha_phase{c} = alpha_phases(spike_times < 0);
        end
        ctx_phases = spon_alpha_phase(startsWith(ap_data(t,:).spiking_data{1}.region, 'SS'));
        ctx_phases = cell2mat(ctx_phases');
        if ~isempty(ctx_phases)
            [ctx_p_value{t}, ~] = circ_rtest(ctx_phases);
            [~, ~, ctx_theta_bar{t}, ctx_R{t}, ctx_kappa{t}] = vonMises(ctx_phases);
            ctx_p_threshold{t} = 0.05 / length(ctx_phases);
        end
        striatum_inds = strcmp(ap_data(t,:).spiking_data{1}.region, 'STR') + strcmp(ap_data(t,:).spiking_data{1}.region, 'CP');
        bg_phases = spon_alpha_phase(logical(striatum_inds));
        bg_phases = cell2mat(bg_phases');
        if ~isempty(bg_phases)
            [bg_p_value{t}, ~] = circ_rtest(bg_phases);
            [~, ~, bg_theta_bar{t}, bg_R{t}, bg_kappa{t}] = vonMises(bg_phases);
            bg_p_threshold{t} = 0.05 / length(bg_phases);
        end
        % fig = figure('Position', [1220, 1256, 1401, 582]);
        % tl = tiledlayout(1,2);
        % axs(1) = nexttile;
        % histogram(ctx_phases, 20, 'Normalization', 'PDF', 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5])
        % [x,y, theta_bar, R, kappa] = vonMises(ctx_phases);
        % hold on 
        % plot(x,y, 'k', 'LineWidth', 2)
        % title(sprintf('Cortex: p=%.1d', ctx_p_value{t}), 'FontSize', 14)
        % xticks([-pi, 0, pi])
        % xticklabels({'-\pi', '0', '\pi'})
        % ax = gca;  % Get current axes
        % ax.XAxis.FontSize = 14;
        % ax.YAxis.FontSize = 14;
        % axs(2) = nexttile;
        % histogram(bg_phases, 20, 'Normalization', 'PDF', 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5])
        % [x,y, theta_bar, R, kappa] = vonMises(bg_phases);
        % hold on 
        % plot(x,y, 'k', 'LineWidth', 2)
        % title(sprintf('Basal Ganglia: p=%.1d', bg_p_value{t}), 'FontSize', 14)
        % xticks([-pi, 0, pi])
        % xticklabels({'-\pi', '0', '\pi'})
        % ax = gca;  % Get current axes
        % ax.XAxis.FontSize = 14;
        % ax.YAxis.FontSize = 14;
        % unifyYLimits(fig)
        % xlabel(tl, 'Alpha Phase')
        % ylabel(tl, 'Spike PDF')
        % title(tl, slrt_data(t,:).categorical_outcome)
        % keyboard
        % saveas(fig, sprintf('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/FIG/trial_15_phase_hists.png'))
        
    end
    % keyboard
    % ctx_theta_bar_hit = ctx_theta_bar(strcmp(slrt_data.categorical_outcome, 'Hit'));
    % ctx_theta_bar_miss = ctx_theta_bar(strcmp(slrt_data.categorical_outcome, 'Miss'));
    % ctx_theta_bar_cr = ctx_theta_bar(strcmp(slrt_data.categorical_outcome, 'CR'));
    % ctx_theta_bar_fa = ctx_theta_bar(strcmp(slrt_data.categorical_outcome, 'FA'));
    % ctx_theta_bar_correct = ctx_theta_bar(strcmp(slrt_data.categorical_outcome, 'Hit') | strcmp(slrt_data.categorical_outcome, 'CR'));
    % ctx_theta_bar_incorrect = ctx_theta_bar(strcmp(slrt_data.categorical_outcome, 'Miss') | strcmp(slrt_data.categorical_outcome, 'FA'));
    % ctx_theta_bar_action = ctx_theta_bar(strcmp(slrt_data.categorical_outcome, 'Hit') | strcmp(slrt_data.categorical_outcome, 'FA'));
    % ctx_theta_bar_inaction = ctx_theta_bar(strcmp(slrt_data.categorical_outcome, 'Miss') | strcmp(slrt_data.categorical_outcome, 'CR'));

    % ctx_p_value_hit = ctx_p_value(strcmp(slrt_data.categorical_outcome, 'Hit'));
    % ctx_p_value_miss = ctx_p_value(strcmp(slrt_data.categorical_outcome, 'Miss'));
    % ctx_p_value_cr = ctx_p_value(strcmp(slrt_data.categorical_outcome, 'CR'));
    % ctx_p_value_fa = ctx_p_value(strcmp(slrt_data.categorical_outcome, 'FA'));
    % ctx_p_value_correct = ctx_p_value(strcmp(slrt_data.categorical_outcome, 'Hit') | strcmp(slrt_data.categorical_outcome, 'CR'));
    % ctx_p_value_incorrect = ctx_p_value(strcmp(slrt_data.categorical_outcome, 'Miss') | strcmp(slrt_data.categorical_outcome, 'FA'));
    % ctx_p_value_action = ctx_p_value(strcmp(slrt_data.categorical_outcome, 'Hit') | strcmp(slrt_data.categorical_outcome, 'FA'));
    % ctx_p_value_inaction = ctx_p_value(strcmp(slrt_data.categorical_outcome, 'Miss') | strcmp(slrt_data.categorical_outcome, 'CR'));

    % ctx_p_threshold_hit = ctx_p_threshold(strcmp(slrt_data.categorical_outcome, 'Hit'));
    % ctx_p_threshold_miss = ctx_p_threshold(strcmp(slrt_data.categorical_outcome, 'Miss'));
    % ctx_p_threshold_cr = ctx_p_threshold(strcmp(slrt_data.categorical_outcome, 'CR'));
    % ctx_p_threshold_fa = ctx_p_threshold(strcmp(slrt_data.categorical_outcome, 'FA'));
    % ctx_p_threshold_correct = ctx_p_threshold(strcmp(slrt_data.categorical_outcome, 'Hit') | strcmp(slrt_data.categorical_outcome, 'CR'));
    % ctx_p_threshold_incorrect = ctx_p_threshold(strcmp(slrt_data.categorical_outcome, 'Miss') | strcmp(slrt_data.categorical_outcome, 'FA'));
    % ctx_p_threshold_action = ctx_p_threshold(strcmp(slrt_data.categorical_outcome, 'Hit') | strcmp(slrt_data.categorical_outcome, 'FA'));
    % ctx_p_threshold_inaction = ctx_p_threshold(strcmp(slrt_data.categorical_outcome, 'Miss') | strcmp(slrt_data.categorical_outcome, 'CR'));

    % ctx_pct_mod_hit = sum(cell2mat(ctx_p_value_hit) < cell2mat(ctx_p_threshold_hit)) / length(ctx_p_value_hit);
    % ctx_pct_mod_miss = sum(cell2mat(ctx_p_value_miss) < cell2mat(ctx_p_threshold_miss)) / length(ctx_p_value_miss);
    % ctx_pct_mod_cr = sum(cell2mat(ctx_p_value_cr) < cell2mat(ctx_p_threshold_cr)) / length(ctx_p_value_cr);
    % ctx_pct_mod_fa = sum(cell2mat(ctx_p_value_fa) < cell2mat(ctx_p_threshold_fa)) / length(ctx_p_value_fa);
    % ctx_pct_mod_correct = sum(cell2mat(ctx_p_value_correct) < cell2mat(ctx_p_threshold_correct)) / length(ctx_p_value_correct);
    % ctx_pct_mod_incorrect = sum(cell2mat(ctx_p_value_incorrect) < cell2mat(ctx_p_threshold_incorrect)) / length(ctx_p_value_incorrect);
    % ctx_pct_mod_action = sum(cell2mat(ctx_p_value_action) < cell2mat(ctx_p_threshold_action)) / length(ctx_p_value_action);
    % ctx_pct_mod_inaction = sum(cell2mat(ctx_p_value_inaction) < cell2mat(ctx_p_threshold_inaction)) / length(ctx_p_value_inaction);

    % % ctx_pct_mod_hit = sum(cell2mat(ctx_p_value_hit) < 0.01) / length(ctx_p_value_hit);
    % % ctx_pct_mod_miss = sum(cell2mat(ctx_p_value_miss) < 0.01) / length(ctx_p_value_miss);
    % % ctx_pct_mod_cr = sum(cell2mat(ctx_p_value_cr) < 0.01) / length(ctx_p_value_cr);
    % % ctx_pct_mod_fa = sum(cell2mat(ctx_p_value_fa) < 0.01) / length(ctx_p_value_fa);
    % % ctx_pct_mod_correct = sum(cell2mat(ctx_p_value_correct) < 0.01) / length(ctx_p_value_correct);
    % % ctx_pct_mod_incorrect = sum(cell2mat(ctx_p_value_incorrect) < 0.01) / length(ctx_p_value_incorrect);

    % bg_theta_bar_hit = bg_theta_bar(strcmp(slrt_data.categorical_outcome, 'Hit'));
    % bg_theta_bar_miss = bg_theta_bar(strcmp(slrt_data.categorical_outcome, 'Miss'));
    % bg_theta_bar_cr = bg_theta_bar(strcmp(slrt_data.categorical_outcome, 'CR'));
    % bg_theta_bar_fa = bg_theta_bar(strcmp(slrt_data.categorical_outcome, 'FA'));
    % bg_theta_bar_correct = bg_theta_bar(strcmp(slrt_data.categorical_outcome, 'Hit') | strcmp(slrt_data.categorical_outcome, 'CR'));
    % bg_theta_bar_incorrect = bg_theta_bar(strcmp(slrt_data.categorical_outcome, 'Miss') | strcmp(slrt_data.categorical_outcome, 'FA'));
    % bg_theta_bar_action = bg_theta_bar(strcmp(slrt_data.categorical_outcome, 'Hit') | strcmp(slrt_data.categorical_outcome, 'FA'));
    % bg_theta_bar_inaction = bg_theta_bar(strcmp(slrt_data.categorical_outcome, 'Miss') | strcmp(slrt_data.categorical_outcome, 'CR'));

    % bg_p_value_hit = bg_p_value(strcmp(slrt_data.categorical_outcome, 'Hit'));
    % bg_p_value_miss = bg_p_value(strcmp(slrt_data.categorical_outcome, 'Miss'));
    % bg_p_value_cr = bg_p_value(strcmp(slrt_data.categorical_outcome, 'CR'));
    % bg_p_value_fa = bg_p_value(strcmp(slrt_data.categorical_outcome, 'FA'));
    % bg_p_value_correct = bg_p_value(strcmp(slrt_data.categorical_outcome, 'Hit') | strcmp(slrt_data.categorical_outcome, 'CR'));
    % bg_p_value_incorrect = bg_p_value(strcmp(slrt_data.categorical_outcome, 'Miss') | strcmp(slrt_data.categorical_outcome, 'FA'));
    % bg_p_value_action = bg_p_value(strcmp(slrt_data.categorical_outcome, 'Hit') | strcmp(slrt_data.categorical_outcome, 'FA'));
    % bg_p_value_inaction = bg_p_value(strcmp(slrt_data.categorical_outcome, 'Miss') | strcmp(slrt_data.categorical_outcome, 'CR'));

    % bg_p_threshold_hit = bg_p_threshold(strcmp(slrt_data.categorical_outcome, 'Hit'));
    % bg_p_threshold_miss = bg_p_threshold(strcmp(slrt_data.categorical_outcome, 'Miss'));
    % bg_p_threshold_cr = bg_p_threshold(strcmp(slrt_data.categorical_outcome, 'CR'));
    % bg_p_threshold_fa = bg_p_threshold(strcmp(slrt_data.categorical_outcome, 'FA'));
    % bg_p_threshold_correct = bg_p_threshold(strcmp(slrt_data.categorical_outcome, 'Hit') | strcmp(slrt_data.categorical_outcome, 'CR'));
    % bg_p_threshold_incorrect = bg_p_threshold(strcmp(slrt_data.categorical_outcome, 'Miss') | strcmp(slrt_data.categorical_outcome, 'FA'));
    % bg_p_threshold_action = bg_p_threshold(strcmp(slrt_data.categorical_outcome, 'Hit') | strcmp(slrt_data.categorical_outcome, 'FA'));
    % bg_p_threshold_inaction = bg_p_threshold(strcmp(slrt_data.categorical_outcome, 'Miss') | strcmp(slrt_data.categorical_outcome, 'CR'));

    % bg_pct_mod_hit = sum(cell2mat(bg_p_value_hit) < cell2mat(bg_p_threshold_hit)) / length(bg_p_value_hit);
    % bg_pct_mod_miss = sum(cell2mat(bg_p_value_miss) < cell2mat(bg_p_threshold_miss)) / length(bg_p_value_miss);
    % bg_pct_mod_cr = sum(cell2mat(bg_p_value_cr) < cell2mat(bg_p_threshold_cr)) / length(bg_p_value_cr);
    % bg_pct_mod_fa = sum(cell2mat(bg_p_value_fa) < cell2mat(bg_p_threshold_fa)) / length(bg_p_value_fa);
    % bg_pct_mod_correct = sum(cell2mat(bg_p_value_correct) < cell2mat(bg_p_threshold_correct)) / length(bg_p_value_correct);
    % bg_pct_mod_incorrect = sum(cell2mat(bg_p_value_incorrect) < cell2mat(bg_p_threshold_incorrect)) / length(bg_p_value_incorrect);
    % bg_pct_mod_action = sum(cell2mat(bg_p_value_action) < cell2mat(bg_p_threshold_action)) / length(bg_p_value_action);
    % bg_pct_mod_inaction = sum(cell2mat(bg_p_value_inaction) < cell2mat(bg_p_threshold_inaction)) / length(bg_p_value_inaction);

    % % bg_pct_mod_hit = sum(cell2mat(bg_p_value_hit) < 0.01) / length(bg_p_value_hit);
    % % bg_pct_mod_miss = sum(cell2mat(bg_p_value_miss) < 0.01) / length(bg_p_value_miss);
    % % bg_pct_mod_cr = sum(cell2mat(bg_p_value_cr) < 0.01) / length(bg_p_value_cr);
    % % bg_pct_mod_fa = sum(cell2mat(bg_p_value_fa) < 0.01) / length(bg_p_value_fa);
    % % bg_pct_mod_correct = sum(cell2mat(bg_p_value_correct) < 0.01) / length(bg_p_value_correct);
    % % bg_pct_mod_incorrect = sum(cell2mat(bg_p_value_incorrect) < 0.01) / length(bg_p_value_incorrect);

    % ctx_correct_fig = figure();
    % ctx_correct_tl = tiledlayout(1,2);
    % ctx_correct_axs = zeros(1,2);
    % ctx_correct_axs(1) = nexttile;
    % polarhistogram(cell2mat(ctx_theta_bar_correct), 20)
    % ctx_correct_axs(2) = nexttile;
    % polarhistogram(cell2mat(ctx_theta_bar_incorrect), 20)

    % bg_correct_fig = figure();
    % bg_correct_tl = tiledlayout(1,2);
    % bg_correct_axs = zeros(1,2);
    % bg_correct_axs(1) = nexttile;
    % polarhistogram(cell2mat(bg_theta_bar_correct), 20)
    % bg_correct_axs(2) = nexttile;
    % polarhistogram(cell2mat(bg_theta_bar_incorrect), 20)

    % figure();
    % ctx_pct_fig = figure();
    % bar([1:4, 6:7, 9:10], [ctx_pct_mod_hit, ctx_pct_mod_miss, ctx_pct_mod_cr, ctx_pct_mod_fa, ...
    %     ctx_pct_mod_action, ctx_pct_mod_inaction, ctx_pct_mod_correct, ctx_pct_mod_incorrect])

    % figure();
    % bg_pct_fig = figure();
    % bar([1:4, 6:7, 9:10], [bg_pct_mod_hit, bg_pct_mod_miss, bg_pct_mod_cr, bg_pct_mod_fa, ...
    %     bg_pct_mod_action, bg_pct_mod_inaction, bg_pct_mod_correct, bg_pct_mod_incorrect])

    % keyboard
end