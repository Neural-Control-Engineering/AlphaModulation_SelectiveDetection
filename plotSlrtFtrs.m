function plotSlrtFtrs(ftr_files, visualize, out_path)
    % add firing rate, fa rate 
    for i = 1:length(ftr_files)
        f = load(ftr_files{i});
        if i == 1
            ftrs = f.slrt_ftr;
        else
            ftrs = combineTables(ftrs, f.slrt_ftr);
        end
    end

    if out_path
        mkdir(out_path)
    end

    % % reaction times by outcome 
    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % rt_by_outcome = cell2mat(ftrs.rt_by_outcome);
    % bar([1,2], mean(rt_by_outcome,1), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    % hold on
    % errorbar([1,2], mean(rt_by_outcome,1), std(rt_by_outcome,1) ./ sqrt(size(rt_by_outcome,1)), 'k.')
    % xticks([1,2])
    % xticklabels({'Hit', 'FA'})
    % xlabel('Outcome')
    % ylabel('Reaction Time (s)')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'reaction_times.fig'))
    %     saveas(fig, strcat(out_path, 'reaction_times.svg'))
    % end

    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % qc_rt_by_outcome = cell2mat(ftrs.qc_rt_by_outcome);
    % bar([1,2], mean(qc_rt_by_outcome,1), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
    % hold on
    % errorbar([1,2], mean(qc_rt_by_outcome,1), std(qc_rt_by_outcome,1) ./ sqrt(size(qc_rt_by_outcome,1)), 'k.')
    % xticks([1,2])
    % xticklabels({'Hit', 'FA'})
    % xlabel('Outcome')
    % ylabel('Reaction Time (s)')
    % if out_path 
    %     saveas(fig, strcat(out_path,'qc_reaction_times.fig'))
    %     saveas(fig, strcat(out_path,'qc_reaction_times.svg'))
    % end

    % % dprime by previous outcome 
    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % dprime = cell2mat(ftrs.dprime_by_previous_outcome);
    % dprime(:,5) = [];
    % bar(1:4, mean(dprime(:,1:4),1), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5]);
    % hold on
    % errorbar(1:4, mean(dprime(:,1:4),1), std(dprime(:,1:4),1) ./ sqrt(size(dprime,1)), 'k.')
    % xticks(1:4)
    % xticklabels({'Hit', 'Miss', 'CR', 'FA'})
    % xlabel('Previous Trial Outcome')
    % ylabel('D-prime')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'dprime_by_previous_outcome.fig'))
    %     saveas(fig, strcat(out_path, 'dprime_by_previous_outcome.svg'))
    % end

    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % qc_dprime = cell2mat(ftrs.qc_dprime_by_previous_outcome);
    % qc_dprime(:,5) = [];
    % bar(1:4, mean(qc_dprime(:,1:4),1), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5]);
    % hold on
    % errorbar(1:4, mean(qc_dprime(:,1:4),1), std(qc_dprime(:,1:4),1) ./ sqrt(size(qc_dprime,1)), 'k.')
    % xticklabels({'Hit', 'Miss', 'CR', 'FA'})
    % xlabel('Previous Trial Outcome')
    % ylabel('D-prime')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'qc_dprime_by_previous_outcome.fig'))
    %     saveas(fig, strcat(out_path, 'qc_dprime_by_previous_outcome.svg'))
    % end

    % % criterion by previous outcome 
    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % criterion = cell2mat(ftrs.criterion_by_previous_outcome);
    % criterion(:,5) = [];
    % bar(1:4, mean(criterion(:,1:4),1), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5]);
    % hold on
    % errorbar(1:4, mean(criterion(:,1:4),1), std(criterion(:,1:4),1) ./ sqrt(size(criterion,1)), 'k.')
    % xticks(1:4)
    % xticklabels({'Hit', 'Miss', 'CR', 'FA'})
    % xlabel('Previous Trial Outcome')
    % ylabel('Criterion')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'criterion_by_previous_outcome.fig'))
    %     saveas(fig, strcat(out_path, 'criterion_by_previous_outcome.svg'))
    % end

    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % qc_criterion = cell2mat(ftrs.qc_criterion_by_previous_outcome);
    % qc_criterion(:,5) = [];
    % bar(1:4, mean(qc_criterion(:,1:4),1), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5]);
    % hold on
    % errorbar(1:4, mean(qc_criterion(:,1:4),1), std(qc_criterion(:,1:4),1) ./ sqrt(size(qc_criterion,1)), 'k.')
    % xticklabels({'Hit', 'Miss', 'CR', 'FA'})
    % xlabel('Previous Trial Outcome')
    % ylabel('Criterion')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'qc_criterion_by_previous_outcome.fig'))
    %     saveas(fig, strcat(out_path, 'qc_criterion_by_previous_outcome.svg'))
    % end

    % % reaction time by previous outcome 
    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % rt = cell2mat(ftrs.rt_by_previous_outcome);
    % rt(:,5) = [];
    % bar(1:4, mean(rt(:,1:4),1,'omitnan'), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5]);
    % hold on
    % errorbar(1:4, mean(rt(:,1:4),1,'omitnan'), std(rt(:,1:4),0,1,'omitnan') ./ sqrt(size(rt,1)), 'k.')
    % xticks(1:4)
    % xticklabels({'Hit', 'Miss', 'CR', 'FA'})
    % xlabel('Previous Trial Outcome')
    % ylabel('Reaction Time (s)')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'reaction_time_by_previous_outcome.fig'))
    %     saveas(fig, strcat(out_path, 'reaction_time_by_previous_outcome.svg'))
    % end


    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % qc_rt = cell2mat(ftrs.qc_rt_by_previous_outcome);
    % qc_rt(:,5) = [];
    % bar(1:4, mean(qc_rt(:,1:4),1,'omitnan'), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5]);
    % hold on
    % errorbar(1:4, mean(qc_rt(:,1:4),1,'omitnan'), std(qc_rt(:,1:4),0,1,'omitnan') ./ sqrt(size(qc_rt,1)), 'k.')
    % xticklabels({'Hit', 'Miss', 'CR', 'FA'})
    % xlabel('Previous Trial Outcome')
    % ylabel('Reaction Time (s)')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'qc_reaction_time_by_previous_outcome.fig'))
    %     saveas(fig, strcat(out_path, 'qc_reaction_time_by_previous_outcome.svg'))
    % end

    % % dprime by session
    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % sessions = 1:size(ftrs,1);
    % plot(sessions, ftrs.dprime, 'k*-', 'LineWidth', 2)
    % xlabel('Session')
    % ylabel('D-Prime')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'dprime_by_session.fig'))
    %     saveas(fig, strcat(out_path, 'dprime_by_session.svg'))
    % end
    
    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % sessions = 1:size(ftrs,1);
    % plot(sessions, ftrs.qc_dprime, 'k*-', 'LineWidth', 2)
    % xlabel('Session')
    % ylabel('D-Prime')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'qc_dprime_by_session.fig'))
    %     saveas(fig, strcat(out_path, 'qc_dprime_by_session.svg'))
    % end

    % % criterion by session
    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % sessions = 1:size(ftrs,1);
    % plot(sessions, ftrs.criterion, 'k*-', 'LineWidth', 2)
    % xlabel('Session')
    % ylabel('Criterion')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'criterion_by_session.fig'))
    %     saveas(fig, strcat(out_path, 'criterion_by_session.svg'))
    % end
    
    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % sessions = 1:size(ftrs,1);
    % plot(sessions, ftrs.qc_criterion, 'k*-', 'LineWidth', 2)
    % xlabel('Session')
    % ylabel('Criterion')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'qc_criterion_by_session.fig'))
    %     saveas(fig, strcat(out_path, 'qc_criterion_by_session.svg'))
    % end

    % % avg_reaction_time by session
    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % sessions = 1:size(ftrs,1);
    % plot(sessions, ftrs.avg_reaction_time, 'k*-', 'LineWidth', 2)
    % xlabel('Session')
    % ylabel('Reaction Time (s)')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'avg_reaction_time_by_session.fig'))
    %     saveas(fig, strcat(out_path, 'avg_reaction_time_by_session.svg'))
    % end

    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % sessions = 1:size(ftrs,1);
    % plot(sessions, ftrs.qc_avg_reaction_time, 'k*-', 'LineWidth', 2)
    % xlabel('Session')
    % ylabel('Reaction Time (s)')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'qc_avg_reaction_time_by_session.fig'))
    %     saveas(fig, strcat(out_path, 'qc_avg_reaction_time_by_session.svg'))
    % end

    % % reaction times by outcome 
    % if visualize
    %     fig = figure('Position', [1215 1358 413 468]);
    % else
    %     fig = figure('Visible', 'off','Position', [1215 1358 413 468]);
    % end
    % hold on 
    % hr = ftrs.hr;
    % far = ftrs.far;
    % for h = 1:length(hr)
    %     plot([1,2], [hr, far], 'ko--')
    % end
    % xticks([1,2])
    % xticklabels({'Hit Rate', 'False Alarm Rate'})
    % xtickangle(45)
    % xlim([0.75, 2.25])
    % ylim([0,1])
    % yticks([0,1])
    % if out_path 
    %     saveas(fig, strcat(out_path, 'hr_vs_far.fig'))
    %     saveas(fig, strcat(out_path, 'hr_vs_far.svg'))
    % end

    % hit/false-alarm rates
    if visualize
        fig = figure('Position', [1215 1358 413 468]);
    else
        fig = figure('Visible', 'off','Position', [1215 1358 413 468]);
    end
    hold on 
    hr = ftrs.qc_hr;
    far = ftrs.qc_far;
    for h = 1:length(hr)
        plot([1,2], [hr, far], 'k.--', 'MarkerSize',20)
    end
    xticks([1,2])
    xticklabels({'Hit Rate', 'False Alarm Rate'})
    xtickangle(45)
    xlim([0.75, 2.25])
    ylim([0,1])
    yticks([0,1])
    ylabel('Performance')
    ax = gca;
    ax.XAxis.FontSize = 16;
    ax.YAxis.FontSize = 16;
    if out_path 
        saveas(fig, strcat(out_path, 'hr_vs_far.fig'))
        saveas(fig, strcat(out_path, 'hr_vs_far.svg'))
    end

    %  % qc hit/false-alarm reaction times
    %  if visualize
    %     fig = figure('Position', [1215 1358 413 468]);
    % else
    %     fig = figure('Visible', 'off');
    % end
    % hold on
    % rt_by_outcome = cell2mat(ftrs.rt_by_outcome);
    % for i = 1:size(rt_by_outcome,1)
    %     plot([1,2], rt_by_outcome(i,:), 'k.--', 'MarkerSize', 20)
    % end
    % xticks([1,2])
    % xticklabels({'Hit', 'False Alarm'})
    % xtickangle(45)
    % xlim([0.75, 2.25])
    % ylim([0,1])
    % yticks([0,1])
    % xlabel('Trial Outcome')
    % ylabel('Reaction Time (s)')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'individual_reaction_times.fig'))
    %     saveas(fig, strcat(out_path, 'individual_reaction_times.svg'))
    % end

    if visualize
        fig = figure('Position', [1215 1358 413 468]);
    else
        fig = figure('Visible', 'off','Position', [1215 1358 413 468]);
    end
    hold on 
    rt_by_outcome = cell2mat(ftrs.qc_rt_by_outcome)-0.2;
    for i = 1:size(rt_by_outcome,1)
        plot([1,2], rt_by_outcome(i,:), 'k.--', 'MarkerSize',20)
    end
    xticks([1,2])
    xticklabels({'Hit', 'False Alarm'})
    xtickangle(45)
    xlim([0.75, 2.25])
    ylim([0,1])
    yticks([0,1])
    xlabel('Trial Outcome')
    ylabel('Reaction Time (s)')
    ax = gca;
    ax.XAxis.FontSize = 16;
    ax.YAxis.FontSize = 16;
    if out_path 
        saveas(fig, strcat(out_path,'qc_individual_reaction_times.fig'))
        saveas(fig, strcat(out_path,'qc_individual_reaction_times.svg'))
    end

    keyboard 

end