function thetaModulation(ap_session, visualize, out_path)

    if out_path
        fig_path = strcat(out_path, 'Theta_Modulation/');
        mkdir(fig_path)
    end
    theta_modulated = ap_session(cell2mat(ap_session.p_value_theta_hit) < cell2mat(ap_session.p_threshold_theta_hit),:);

    for i = 1:size(theta_modulated,1)
        if visualize
            fig = figure('Position', [ 1151, 841, 1850, 1081]);
        else
            fig = figure('Position', [ 1151, 841, 1850, 1081], 'Visible', 'off');
        end
        tl = tiledlayout(2,4);
        axs = zeros(2,4);
        axs(1,1) = nexttile;
        plot(linspace(-3,5,80), theta_modulated(i,:).left_trigger_aligned_avg_fr_Hit{1}, 'k')
        title('Hit')
        xlim([-3,5])
        axs(1,2) = nexttile;
        plot(linspace(-3,5,80), theta_modulated(i,:).left_trigger_aligned_avg_fr_Miss{1}, 'k')
        title('Miss')
        xlim([-3,5])
        axs(1,3) = nexttile;
        plot(linspace(-3,5,80), theta_modulated(i,:).right_trigger_aligned_avg_fr_CR{1}, 'k')
        title('CR')
        xlim([-3,5])
        axs(1,4) = nexttile;
        plot(linspace(-3,5,80), theta_modulated(i,:).right_trigger_aligned_avg_fr_FA{1}, 'k')
        title('FA')
        xlim([-3,5])

        unifyYLimits(axs(1,:))

        axs(2,1) = nexttile;
        if ~isempty(theta_modulated(i,:).hists_theta_hit{1})
            histogram(theta_modulated(i,:).theta_spike_phases_hit{1}, 20, 'Normalization', 'pdf');
            [x,y] = vonMises(theta_modulated(i,:).theta_spike_phases_hit{1});
            hold on
            plot(x,y, 'LineWidth', 2);
            title(sprintf('Kappa = %.2f; p = %.2d', theta_modulated(i,:).kappa_theta_hit{1}, theta_modulated(i,:).p_value_theta_hit{1}))
        end
        axs(2,2) = nexttile;
        if ~isempty(theta_modulated(i,:).hists_theta_miss{1})   
            histogram(theta_modulated(i,:).theta_spike_phases_miss{1}, 20, 'Normalization', 'pdf');
            [x,y] = vonMises(theta_modulated(i,:).theta_spike_phases_miss{1});
            hold on
            plot(x,y, 'LineWidth', 2);
            title(sprintf('Kappa = %.2f; p = %.2d', theta_modulated(i,:).kappa_theta_miss{1}, theta_modulated(i,:).p_value_theta_miss{1}))
        end
        axs(2,3) = nexttile;
        if ~isempty(theta_modulated(i,:).hists_theta_cr{1})
            histogram(theta_modulated(i,:).theta_spike_phases_cr{1}, 20, 'Normalization', 'pdf');
            title(sprintf('Kappa = %.2f; p = %.2d', theta_modulated(i,:).kappa_theta_cr{1}, theta_modulated(i,:).p_value_theta_cr{1}))
            [x,y] = vonMises(theta_modulated(i,:).theta_spike_phases_cr{1});
            hold on
            plot(x,y, 'LineWidth', 2);
        end
        axs(2,4) = nexttile;
        if ~isempty(theta_modulated(i,:).hists_theta_fa{1})
            histogram(theta_modulated(i,:).theta_spike_phases_fa{1}, 20, 'Normalization', 'pdf');
            title(sprintf('Kappa = %.2f; p = %.2d', theta_modulated(i,:).kappa_theta_fa{1}, theta_modulated(i,:).p_value_theta_fa{1}))
            [x,y] = vonMises(theta_modulated(i,:).theta_spike_phases_fa{1});
            hold on
            plot(x,y, 'LineWidth', 2);
        end

        title(tl, sprintf('%s %s', theta_modulated(i,:).region{1}, theta_modulated(i,:).waveform_class{1}))
        if out_path
            fname = sprintf('%s%s_cluster_%i.fig', fig_path, theta_modulated(i,:).session_id{1}, theta_modulated(i,:).cluster_id);
            saveas(fig, fname)
            fname = sprintf('%s%s_cluster_%i.png', fig_path, theta_modulated(i,:).session_id{1}, theta_modulated(i,:).cluster_id);
            saveas(fig, fname)
        end
    end
    
    close all
    % stim_theta_mod = theta_modulated(cell2mat(theta_modulated.is_left_trigger_stim_modulated) == 1,:);
    % figure(); semshade(cell2mat(stim_theta_mod.left_trigger_aligned_avg_fr_Hit), 0.3, 'k', 'k', linspace(-3,5,80))


    % stim_supp_theta_mod = theta_modulated(cell2mat(theta_modulated.is_left_trigger_stim_modulated) == -1,:);
    % figure(); semshade(cell2mat(stim_supp_theta_mod.left_trigger_aligned_avg_fr_Hit), 0.3, 'k', 'k', linspace(-3,5,80))
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