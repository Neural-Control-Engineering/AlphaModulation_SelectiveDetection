function betaModulation(ap_session, visualize, out_path)

    if out_path
        fig_path = strcat(out_path, 'Beta_Modulation/');
        mkdir(fig_path)
    end
    beta_modulated = ap_session(cell2mat(ap_session.p_value_beta_hit) < cell2mat(ap_session.p_threshold_beta_hit),:);

    for i = 1:size(beta_modulated,1)
        if visualize
            fig = figure('Position', [ 1151, 841, 1850, 1081]);
        else
            fig = figure('Position', [ 1151, 841, 1850, 1081], 'Visible', 'off');
        end
        tl = tiledlayout(2,4);
        axs = zeros(2,4);
        axs(1,1) = nexttile;
        plot(linspace(-3,5,80), beta_modulated(i,:).left_trigger_aligned_avg_fr_Hit{1}, 'k')
        title('Hit')
        xlim([-3,5])
        axs(1,2) = nexttile;
        plot(linspace(-3,5,80), beta_modulated(i,:).left_trigger_aligned_avg_fr_Miss{1}, 'k')
        title('Miss')
        xlim([-3,5])
        axs(1,3) = nexttile;
        plot(linspace(-3,5,80), beta_modulated(i,:).right_trigger_aligned_avg_fr_CR{1}, 'k')
        title('CR')
        xlim([-3,5])
        axs(1,4) = nexttile;
        plot(linspace(-3,5,80), beta_modulated(i,:).right_trigger_aligned_avg_fr_FA{1}, 'k')
        title('FA')
        xlim([-3,5])

        unifyYLimits(axs(1,:))

        axs(2,1) = nexttile;
        if ~isempty(beta_modulated(i,:).hists_beta_hit{1})
            histogram(beta_modulated(i,:).beta_spike_phases_hit{1}, 20, 'Normalization', 'pdf');
            [x,y] = vonMises(beta_modulated(i,:).beta_spike_phases_hit{1});
            hold on
            plot(x,y, 'LineWidth', 2);
            title(sprintf('Kappa = %.2f; p = %.2d', beta_modulated(i,:).kappa_beta_hit{1}, beta_modulated(i,:).p_value_beta_hit{1}))
        end
        axs(2,2) = nexttile;
        if ~isempty(beta_modulated(i,:).hists_beta_miss{1})   
            histogram(beta_modulated(i,:).beta_spike_phases_miss{1}, 20, 'Normalization', 'pdf');
            [x,y] = vonMises(beta_modulated(i,:).beta_spike_phases_miss{1});
            hold on
            plot(x,y, 'LineWidth', 2);
            title(sprintf('Kappa = %.2f; p = %.2d', beta_modulated(i,:).kappa_beta_miss{1}, beta_modulated(i,:).p_value_beta_miss{1}))
        end
        axs(2,3) = nexttile;
        if ~isempty(beta_modulated(i,:).hists_beta_cr{1})
            histogram(beta_modulated(i,:).beta_spike_phases_cr{1}, 20, 'Normalization', 'pdf');
            title(sprintf('Kappa = %.2f; p = %.2d', beta_modulated(i,:).kappa_beta_cr{1}, beta_modulated(i,:).p_value_beta_cr{1}))
            [x,y] = vonMises(beta_modulated(i,:).beta_spike_phases_cr{1});
            hold on
            plot(x,y, 'LineWidth', 2);
        end
        axs(2,4) = nexttile;
        if ~isempty(beta_modulated(i,:).hists_beta_fa{1})
            histogram(beta_modulated(i,:).beta_spike_phases_fa{1}, 20, 'Normalization', 'pdf');
            title(sprintf('Kappa = %.2f; p = %.2d', beta_modulated(i,:).kappa_beta_fa{1}, beta_modulated(i,:).p_value_beta_fa{1}))
            [x,y] = vonMises(beta_modulated(i,:).beta_spike_phases_fa{1});
            hold on
            plot(x,y, 'LineWidth', 2);
        end

        title(tl, sprintf('%s %s', beta_modulated(i,:).region{1}, beta_modulated(i,:).waveform_class{1}))
        if out_path
            fname = sprintf('%s%s_cluster_%i.fig', fig_path, beta_modulated(i,:).session_id{1}, beta_modulated(i,:).cluster_id);
            saveas(fig, fname)
            fname = sprintf('%s%s_cluster_%i.png', fig_path, beta_modulated(i,:).session_id{1}, beta_modulated(i,:).cluster_id);
            saveas(fig, fname)
        end
    end

    close all
    
    % stim_beta_mod = beta_modulated(cell2mat(beta_modulated.is_left_trigger_stim_modulated) == 1,:);
    % figure(); semshade(cell2mat(stim_beta_mod.left_trigger_aligned_avg_fr_Hit), 0.3, 'k', 'k', linspace(-3,5,80))


    % stim_supp_beta_mod = beta_modulated(cell2mat(beta_modulated.is_left_trigger_stim_modulated) == -1,:);
    % figure(); semshade(cell2mat(stim_supp_beta_mod.left_trigger_aligned_avg_fr_Hit), 0.3, 'k', 'k', linspace(-3,5,80))
end

function [x,y] = vonMises(data)

    % Compute the mean direction
    theta_bar = circ_mean(data);
    
    % Compute the resultant length
    R = circ_r(data);
    
    % Estimate the concentration parameter kappa
    kappa = circ_kappa(R);

    % Define the range for plotting the von Mises distribution
    x = linspace(-pi, pi, 100);
    
    % Evaluate the PDF of the fitted von Mises distribution
    y = exp(kappa * cos(x - theta_bar)) / (2 * pi * besseli(0, kappa));

end