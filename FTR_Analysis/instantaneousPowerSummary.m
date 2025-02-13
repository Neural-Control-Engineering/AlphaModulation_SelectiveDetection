function instantaneousPowerSummary(ftr_path, session_ids)
    % wrangle baseline lfp power in each band from all session ids
    alpha = zeros(385,3999,length(session_ids),4);
    beta = alpha; theta = alpha; delta = alpha;
    bands = {'delta', 'theta', 'alpha', 'beta'};
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    for sid = 1:length(session_ids)
        session_id = session_ids{sid};
        lfp_ftr = load(strcat(ftr_path, session_id, '.mat'));
        for b = 1:length(bands)
            for o = 1:length(outcomes)
                mat = eval(sprintf('cell2mat(lfp_ftr.lfp_session.avg_%s_power_%s)', bands{b}, outcomes{o}));
                assignment = sprintf('%s(:,:,sid,o)=mat(:,1:3999);', ...
                    bands{b});
                eval(assignment)
            end
        end
    end

    % plotting 
    for b = 1:length(bands)
        assignment = sprintf('%s_fig = figure();', bands{b});
        eval(assignment)
        tl = tiledlayout(1,length(outcomes));
        axs = zeros(1,length(outcomes));
        
        for o = 1:length(outcomes)
            axs(o) = nexttile;
            assignment = sprintf('mat = %s(:,:,:,o);', bands{b});
            eval(assignment)
            imagesc(linspace(-3,5,3999), 1:385, mean(mat,3))
            xlim([-2,3]);
            title(outcomes{o})
        end
        xlabel(tl, 'Time (s)');
        ylabel(tl, 'Channel Number')
        ttl = bands{b};
        ttl(1) = upper(ttl(1));
        title(tl, ttl);
    end

    keyboard
    
    for b = 1:length(bands)
        fig_name = sprintf('~/neuralctrl/users/ck3217/Selective-Attention/Figures/expert_lfp_power_by_channel/%s.fig', bands{b});
        expression = sprintf('saveas(%s_fig, fig_name)', bands{b});
        eval(expression)
        fig_name = sprintf('~/neuralctrl/users/ck3217/Selective-Attention/Figures/expert_lfp_power_by_channel/%s.png', bands{b});
        eval(expression)
    end

end