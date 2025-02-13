function erpSummary(ftr_path, session_ids)
    left_trigger = zeros(385,3689,length(session_ids));
    right_trigger = left_trigger;
    for sid = 1:length(session_ids)
        session_id = session_ids{sid};
        lfp_ftr = load(strcat(ftr_path, session_id, '.mat'));
        mat = cell2mat(lfp_ftr.lfp_session.left_trigger_aligned_erp);
        left_trigger(:,:,sid) = (mat(:,1:3689)-mean(mat(:,1:1499),2));
        mat = cell2mat(lfp_ftr.lfp_session.right_trigger_aligned_erp);
        right_trigger(:,:,sid) = (mat(:,1:3689)-mean(mat(:,1:1499),2));
    end

    fig = figure();
    tl = tiledlayout(1,2);
    axs = zeros(1,2);
    axs(1) = nexttile;
    imagesc(linspace(-3,4.8,3689), 1:385, mean(left_trigger,3))
    title('Left Trigger')
    axs(2) = nexttile;
    imagesc(linspace(-3,4.8,3689), 1:385, mean(right_trigger,3))
    title('Right Trigger')
    xlabel(tl, 'Time (s)')
    ylabel(tl, 'Channel Number')

    hit = zeros(385,3999,length(session_ids));
    miss = hit; cr = hit; fa = hit;
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    for sid = 1:length(session_ids)
        session_id = session_ids{sid};
        lfp_ftr = load(strcat(ftr_path, session_id, '.mat'));
        variable_names = lfp_ftr.lfp_session.Properties.VariableNames;
        for o = 1:length(outcomes)
            ind = find(contains(variable_names, strcat('aligned_erp_', outcomes{o})));
            mat = cell2mat(lfp_ftr.lfp_session.(variable_names{ind}));
            mat = mat(:,1:3999)-mean(mat(:,1:1499),2);
            assignment = sprintf('%s(:,:,sid) = mat;', lower(outcomes{o}));
            eval(assignment);
        end
    end

    outcome_fig = figure();
    outcome_tl = tiledlayout(1,4);
    outcome_axs = zeros(1,4);
    for o = 1:length(outcomes)
        outcome_axs(o) = nexttile;
        assignment = sprintf('mean(%s,3)', lower(outcomes{o}));
        imagesc(linspace(-3,5,3999), 1:385, eval(assignment))
        title(outcomes{o})
    end
    xlabel(outcome_tl, 'Time (s)')
    ylabel(outcome_tl, 'Channel Number')

    keyboard

    saveas(fig, '~/neuralctrl/users/ck3217/Selective-Attention/Figures/expert_erps/erps_by_channel.fig')
    saveas(outcome_fig, '~/neuralctrl/users/ck3217/Selective-Attention/Figures/expert_erps/erps_by_channel_and_outcome.fig')
    saveas(fig, '~/neuralctrl/users/ck3217/Selective-Attention/Figures/expert_erps/erps_by_channel.png')
    saveas(outcome_fig, '~/neuralctrl/users/ck3217/Selective-Attention/Figures/expert_erps/erps_by_channel_and_outcome.png')
    
end