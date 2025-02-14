function baselineBandPowerSummary(ftr_path, session_ids)
    % wrangle baseline lfp power in each band from all session ids
    alpha = zeros(385,4,length(session_ids));
    beta = alpha; theta = alpha; delta = alpha; gamma = alpha;
    bands = {'delta', 'theta', 'alpha', 'beta', 'gamma'};
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    for sid = 1:length(session_ids)
        session_id = session_ids{sid};
        lfp_ftr = load(strcat(ftr_path, session_id, '.mat'));
        for b = 1:length(bands)
            for o = 1:length(outcomes)
                assignment = sprintf('%s(:,o,sid)=cell2mat(lfp_ftr.lfp_session.avg_baseline_%s_power_%s);', ...
                    bands{b}, bands{b}, outcomes{o});
                eval(assignment)
            end
        end
    end

    % plotting 
    for b = 1:length(bands)
        assignment = sprintf('%s_fig = figure();', bands{b});
        eval(assignment)
        assignment = sprintf('mean(%s,3)', bands{b});
        imagesc(1:4, 1:385, eval(assignment))
        colorbar()
        xticks(1:4)
        xticklabels(outcomes)
        ttl = bands{b};
        ttl(1) = upper(ttl(1));
        title(ttl)
        xlabel('Outcome')
        ylabel('Channel Number')
    end

    keyboard

    for b = 1:length(bands)
        fig_name = sprintf('~/neuralctrl/users/ck3217/Selective-Attention/Figures/expert_baseline_lfp_power_by_channel/%s.fig', bands{b});
        expression = sprintf('saveas(%s_fig, fig_name)', bands{b});
        eval(expression)
        fig_name = sprintf('~/neuralctrl/users/ck3217/Selective-Attention/Figures/expert_baseline_lfp_power_by_channel/%s.png', bands{b});
        eval(expression)
    end
end