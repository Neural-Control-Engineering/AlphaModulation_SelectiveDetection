function compareSlrtFtrs(ftr_files, visualize, out_path)
    % TODO: add hit rate, fa rate

    % compare animals 
    for i = 1:length(ftr_files)
        if iscell(ftr_files{i})
            % combine animals
            for j = 1:length(ftr_files{i})
                f = load(ftr_files{i}{j});
                if j == 1
                    ftrs = f.slrt_ftr;
                else
                    ftrs = combineTables(ftrs, f.slrt_ftr);
                end
            end
            expr = sprintf('ftr%i = ftrs;', i);
            eval(expr)
        else
            expr = sprintf('ftr%i = load(ftr_files{%i});', i, i);
            eval(expr)
            expr = sprintf('ftr%i = ftr%i.slrt_ftr;', i, i);
            eval(expr)
        end
    end

    if out_path
        mkdir(out_path)
    end

    animal1 = cell(size(ftr1,1),1);
    for s = 1:size(ftr1,1)
        sid = ftr1(s,:).subject_id{1};
        sparts = strsplit(sid, '_');
        animal1{s} = sparts{1};
    end
    animal2 = cell(size(ftr2,1),1);
    for s = 1:size(ftr2,1)
        sid = ftr2(s,:).subject_id{1};
        sparts = strsplit(sid, '_');
        animal2{s} = sparts{1};
    end

    % reaction times by outcome 
    if visualize
        fig = figure();
    else
        fig = figure('Visible', 'off');
    end
    rt_by_outcome1 = cell2mat(ftr1.rt_by_outcome);
    rt_by_outcome2 = cell2mat(ftr2.rt_by_outcome);
    bar([1,4], nanmean(rt_by_outcome1,1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'b')
    hold on
    errorbar([1,4], nanmean(rt_by_outcome1,1), nanstd(rt_by_outcome1,1) ./ sqrt(size(rt_by_outcome1,1)), 'k.')
    bar([2,5], nanmean(rt_by_outcome2,1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([2,5], nanmean(rt_by_outcome2,1), nanstd(rt_by_outcome2,1) ./ sqrt(size(rt_by_outcome2,1)), 'k.')
    xticks([1.5, 4.5])
    xticklabels({'Hit', 'FA'})
    xlabel('Outcome')
    ylabel('Reaction Time (s)')
    if out_path 
        saveas(fig, strcat(out_path, 'reaction_times.fig'))
        saveas(fig, strcat(out_path, 'reaction_times.png'))
    end

    % reaction times by outcome 
    if visualize
        fig = figure();
    else
        fig = figure('Visible', 'off');
    end
    rt_by_outcome1 = cell2mat(ftr1.qc_rt_by_outcome);
    rt_by_outcome2 = cell2mat(ftr2.qc_rt_by_outcome);
    bar([1,4], nanmean(rt_by_outcome1,1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'b')
    hold on
    errorbar([1,4], nanmean(rt_by_outcome1,1), nanstd(rt_by_outcome1,1) ./ sqrt(size(rt_by_outcome1,1)), 'k.')
    bar([2,5], nanmean(rt_by_outcome2,1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([2,5], nanmean(rt_by_outcome2,1), nanstd(rt_by_outcome2,1) ./ sqrt(size(rt_by_outcome2,1)), 'k.')
    xticks([1.5, 4.5])
    xticklabels({'Hit', 'FA'})
    xlabel('Outcome')
    ylabel('Reaction Time (s)')
    if out_path 
        saveas(fig, strcat(out_path, 'qc_reaction_times.fig'))
        saveas(fig, strcat(out_path, 'qc_reaction_times.png'))
    end

    % dprime by previous outcome 
    if visualize
        fig = figure();
    else
        fig = figure('Visible', 'off');
    end
    dprime1 = cell2mat(ftr1.dprime_by_previous_outcome);
    dprime2 = cell2mat(ftr2.dprime_by_previous_outcome);
    dprime1(:,5) = [];
    dprime2(:,5) = [];
    bar([1,4,7,10], nanmean(dprime1(:,1:4),1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'b');
    hold on
    errorbar([1,4,7,10], nanmean(dprime1(:,1:4),1), nanstd(dprime1(:,1:4),1) ./ sqrt(size(dprime1,1)), 'k.')
    bar([1,4,7,10]+1, nanmean(dprime2(:,1:4),1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'r');
    errorbar([1,4,7,10]+1, nanmean(dprime2(:,1:4),1), nanstd(dprime2(:,1:4),1) ./ sqrt(size(dprime2,1)), 'k.')
    bar([14], nanmean(dprime1(:,5)), 'EdgeColor', 'k', 'FaceColor', 'b')
    bar([15], nanmean(dprime2(:,5)), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([14], nanmean(dprime1(:,5)), nanstd(dprime1(:,5)) / sqrt(size(dprime1,1)), 'k.')
    errorbar([15], nanmean(dprime2(:,5)), nanstd(dprime2(:,5)) / sqrt(size(dprime2,1)), 'k.')
    bar([17], nanmean(dprime1(:,6)), 'EdgeColor', 'k', 'FaceColor', 'b')
    bar([18], nanmean(dprime2(:,6)), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([17], nanmean(dprime1(:,6)), nanstd(dprime1(:,6)) / sqrt(size(dprime1,1)), 'k.')
    errorbar([18], nanmean(dprime2(:,6)), nanstd(dprime2(:,6)) / sqrt(size(dprime2,1)), 'k.')
    bar([20], nanmean(dprime1(:,7)), 'EdgeColor', 'k', 'FaceColor', 'b')
    bar([21], nanmean(dprime2(:,7)), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([20], nanmean(dprime1(:,7)), nanstd(dprime1(:,7)) / sqrt(size(dprime1,1)), 'k.')
    errorbar([21], nanmean(dprime2(:,7)), nanstd(dprime2(:,7)) / sqrt(size(dprime2,1)), 'k.')
    bar([23], nanmean(dprime1(:,8)), 'EdgeColor', 'k', 'FaceColor', 'b')
    bar([24], nanmean(dprime2(:,8)), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([23], nanmean(dprime1(:,8)), nanstd(dprime1(:,8)) / sqrt(size(dprime1,1)), 'k.')
    errorbar([24], nanmean(dprime2(:,8)), nanstd(dprime2(:,8)) / sqrt(size(dprime2,1)), 'k.')
    xticks([1,4,7,10, 14, 17, 20, 23]+0.5)
    xticklabels({'Hit', 'Miss', 'CR', 'FA', 'Correct', 'Incorrect', 'Action', 'Inaction'})
    xlabel('Previous Trial Outcome')
    ylabel('D-prime')
    if out_path 
        saveas(fig, strcat(out_path,'dprime_by_previous_outcome.fig'))
        saveas(fig, strcat(out_path,'dprime_by_previous_outcome.png'))
        saveas(fig, strcat(out_path,'dprime_by_previous_outcome.svg'))
    end

    % fprintf('dprime by previous outcome:\n')
    % t1 = table(animal1, dprime1(:,1), dprime1(:,2),dprime1(:,3), dprime1(:,4), ...
    %     'VariableNames', {'subject', 'hit', 'miss', 'cr', 'fa'});
    % t2 = table(animal2, dprime2(:,1), dprime2(:,2),dprime2(:,3), dprime2(:,4), ...
    %     'VariableNames', {'subject', 'hit', 'miss', 'cr', 'fa'});
    % Meas = table([1;2;3;4], 'VariableNames', {'Measurements'});
    % rm = fitrm(t1, 'hit-fa~subject', 'WithinDesign', Meas);
    % ranovatbl1 = ranova(rm)
    % rm = fitrm(t2, 'hit-fa~subject', 'WithinDesign', Meas);
    % ranovatbl2 = ranova(rm)
    % fprintf('performance:\ndprime1:\n')
    % disp(ranksum(dprime1(:,5),dprime1(:,6)))
    % fprintf('dprime2:\n')
    % disp(ranksum(dprime2(:,5),dprime2(:,6)))
    % fprintf('action:\ndprime1:\n')
    % disp(ranksum(dprime1(:,7),dprime1(:,8)))
    % fprintf('dprime2:\n')
    % disp(ranksum(dprime2(:,7),dprime2(:,8)))

    % if visualize
    %     dprime_prev_fig = figure('Position', [1220, 1241, 864, 597]);
    % else
    %     dprime_prev_fig = figure('Visible', 'off');
    % end
    % dprime1 = cell2mat(ftr1.qc_dprime_by_previous_outcome);
    % dprime2 = cell2mat(ftr2.qc_dprime_by_previous_outcome);
    % dprime1(:,5) = [];
    % dprime2(:,5) = [];
    % bar([1,4,7,10], nanmean(dprime1(:,1:4),1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'b');
    % hold on
    % errorbar([1,4,7,10], nanmean(dprime1(:,1:4),1), nanstd(dprime1(:,1:4),1) ./ sqrt(size(dprime1,1)), 'k.')
    % bar([1,4,7,10]+1, nanmean(dprime2(:,1:4),1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'r');
    % errorbar([1,4,7,10]+1, nanmean(dprime2(:,1:4),1), nanstd(dprime2(:,1:4),1) ./ sqrt(size(dprime2,1)), 'k.')
    % bar([14], nanmean(dprime1(:,5)), 'EdgeColor', 'k', 'FaceColor', 'b')
    % bar([15], nanmean(dprime2(:,5)), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([14], nanmean(dprime1(:,5)), nanstd(dprime1(:,5)) / sqrt(size(dprime1,1)), 'k.')
    % errorbar([15], nanmean(dprime2(:,5)), nanstd(dprime2(:,5)) / sqrt(size(dprime2,1)), 'k.')
    % bar([17], nanmean(dprime1(:,6)), 'EdgeColor', 'k', 'FaceColor', 'b')
    % bar([18], nanmean(dprime2(:,6)), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([17], nanmean(dprime1(:,6)), nanstd(dprime1(:,6)) / sqrt(size(dprime1,1)), 'k.')
    % errorbar([18], nanmean(dprime2(:,6)), nanstd(dprime2(:,6)) / sqrt(size(dprime2,1)), 'k.')
    % bar([21], nanmean(dprime1(:,7)), 'EdgeColor', 'k', 'FaceColor', 'b')
    % bar([22], nanmean(dprime2(:,7)), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([21], nanmean(dprime1(:,7)), nanstd(dprime1(:,7)) / sqrt(size(dprime1,1)), 'k.')
    % errorbar([22], nanmean(dprime2(:,7)), nanstd(dprime2(:,7)) / sqrt(size(dprime2,1)), 'k.')
    % bar([24], nanmean(dprime1(:,8)), 'EdgeColor', 'k', 'FaceColor', 'b')
    % bar([25], nanmean(dprime2(:,8)), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([24], nanmean(dprime1(:,8)), nanstd(dprime1(:,8)) / sqrt(size(dprime1,1)), 'k.')
    % errorbar([25], nanmean(dprime2(:,8)), nanstd(dprime2(:,8)) / sqrt(size(dprime2,1)), 'k.')
    % xticks([1,4,7,10, 14, 17, 21, 24]+0.5)
    % xticklabels({'Hit', 'Miss', 'CR', 'FA', 'Correct', 'Incorrect', 'Action', 'Inaction'})
    % xtickangle(45)
    % xlabel('Previous Trial Outcome', 'FontSize', 14)
    % ylabel("Performance (d')", 'FontSize', 14)
    % axs = gca(dprime_prev_fig);
    % axs.XAxis.FontSize = 12;
    % if out_path 
    %     saveas(dprime_prev_fig, strcat(out_path, 'qc_dprime_by_previous_outcome.fig'))
    %     saveas(dprime_prev_fig, strcat(out_path, 'qc_dprime_by_previous_outcome.png'))
    %     saveas(dprime_prev_fig, strcat(out_path, 'qc_dprime_by_previous_outcome.svg'))
    % end
    
    % fprintf('qc dprime by previous outcome:\n')
    % t1 = table(animal1, dprime1(:,1), dprime1(:,2),dprime1(:,3), dprime1(:,4), ...
    %     'VariableNames', {'subject', 'hit', 'miss', 'cr', 'fa'});
    % t2 = table(animal2, dprime2(:,1), dprime2(:,2),dprime2(:,3), dprime2(:,4), ...
    %     'VariableNames', {'subject', 'hit', 'miss', 'cr', 'fa'});
    % Meas = table([1;2;3;4], 'VariableNames', {'Measurements'});
    % rm = fitrm(t1, 'hit-fa~subject', 'WithinDesign', Meas);
    % ranovatbl1 = ranova(rm)
    % rm = fitrm(t2, 'hit-fa~subject', 'WithinDesign', Meas);
    % ranovatbl2 = ranova(rm)
    % fprintf('performance:\ndprime1:\n')
    % disp(ranksum(dprime1(:,5),dprime1(:,6)))
    % fprintf('dprime2:\n')
    % disp(ranksum(dprime2(:,5),dprime2(:,6)))
    % fprintf('action:\ndprime1:\n')
    % disp(ranksum(dprime1(:,7),dprime1(:,8)))
    % fprintf('dprime2:\n')
    % disp(ranksum(dprime2(:,7),dprime2(:,8)))
    

    % criterion by previous outcome 
    if visualize
        fig = figure();
    else
        fig = figure('Visible', 'off');
    end
    criterion1 = cell2mat(ftr1.criterion_by_previous_outcome);
    criterion2 = cell2mat(ftr2.criterion_by_previous_outcome);
    criterion1(:,5) = [];
    criterion2(:,5) = [];
    bar([1,4,7,10], nanmean(criterion1(:,1:4),1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'b');
    hold on
    errorbar([1,4,7,10], nanmean(criterion1(:,1:4),1), nanstd(criterion1(:,1:4),1) ./ sqrt(size(criterion1,1)), 'k.')
    bar([1,4,7,10]+1, nanmean(criterion2(:,1:4),1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'r');
    errorbar([1,4,7,10]+1, nanmean(criterion2(:,1:4),1), nanstd(criterion2(:,1:4),1) ./ sqrt(size(criterion2,1)), 'k.')
    bar([14], nanmean(criterion1(:,5)), 'EdgeColor', 'k', 'FaceColor', 'b')
    bar([15], nanmean(criterion2(:,5)), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([14], nanmean(criterion1(:,5)), nanstd(criterion1(:,5)) / sqrt(size(criterion1,1)), 'k.')
    errorbar([15], nanmean(criterion2(:,5)), nanstd(criterion2(:,5)) / sqrt(size(criterion2,1)), 'k.')
    bar([17], nanmean(criterion1(:,6)), 'EdgeColor', 'k', 'FaceColor', 'b')
    bar([18], nanmean(criterion2(:,6)), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([17], nanmean(criterion1(:,6)), nanstd(criterion1(:,6)) / sqrt(size(criterion1,1)), 'k.')
    errorbar([18], nanmean(criterion2(:,6)), nanstd(criterion2(:,6)) / sqrt(size(criterion2,1)), 'k.')
    bar([20], nanmean(criterion1(:,7)), 'EdgeColor', 'k', 'FaceColor', 'b')
    bar([21], nanmean(criterion2(:,7)), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([20], nanmean(criterion1(:,7)), nanstd(criterion1(:,7)) / sqrt(size(criterion1,1)), 'k.')
    errorbar([21], nanmean(criterion2(:,7)), nanstd(criterion2(:,7)) / sqrt(size(criterion2,1)), 'k.')
    bar([23], nanmean(criterion1(:,8)), 'EdgeColor', 'k', 'FaceColor', 'b')
    bar([24], nanmean(criterion2(:,8)), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([23], nanmean(criterion1(:,8)), nanstd(criterion1(:,8)) / sqrt(size(criterion1,1)), 'k.')
    errorbar([24], nanmean(criterion2(:,8)), nanstd(criterion2(:,8)) / sqrt(size(criterion2,1)), 'k.')
    xticks([1,4,7,10, 14, 17, 20, 23]+0.5)
    xticklabels({'Hit', 'Miss', 'CR', 'FA', 'Correct', 'Incorrect', 'Action', 'Inaction'})
    xlabel('Previous Trial Outcome')
    ylabel('Criterion')
    if out_path 
        saveas(fig, strcat(out_path, 'criterion_by_previous_outcome.fig'))
        saveas(fig, strcat(out_path, 'criterion_by_previous_outcome.png'))
        saveas(fig, strcat(out_path, 'criterion_by_previous_outcome.svg'))
    end

    % fprintf('criterion by previous outcome:\n')
    % t1 = table(animal1, criterion1(:,1), criterion1(:,2),criterion1(:,3), criterion1(:,4), ...
    %     'VariableNames', {'subject', 'hit', 'miss', 'cr', 'fa'});
    % t2 = table(animal2, criterion2(:,1), criterion2(:,2),criterion2(:,3), criterion2(:,4), ...
    %     'VariableNames', {'subject', 'hit', 'miss', 'cr', 'fa'});
    % Meas = table([1;2;3;4], 'VariableNames', {'Measurements'});
    % rm = fitrm(t1, 'hit-fa~subject', 'WithinDesign', Meas);
    % ranovatbl1 = ranova(rm)
    % rm = fitrm(t2, 'hit-fa~subject', 'WithinDesign', Meas);
    % ranovatbl2 = ranova(rm)
    % fprintf('performance:\n criterion1:\n')
    % disp(ranksum(criterion1(:,5),criterion1(:,6)))
    % fprintf('criterion2:\n')
    % disp(ranksum(criterion2(:,5),criterion2(:,6)))
    % fprintf('action:\n criterion1:\n')
    % disp(ranksum(criterion1(:,7),criterion1(:,8)))
    % fprintf('criterion2:\n')
    % disp(ranksum(criterion2(:,7),criterion2(:,8)))

    % if visualize
    %     qc_prev_fig = figure('Position', [1220, 1241, 864, 597]);
    % else
    %     qc_prev_fig = figure('Visible', 'off');
    % end
    % criterion1 = cell2mat(ftr1.qc_criterion_by_previous_outcome);
    % criterion2 = cell2mat(ftr2.qc_criterion_by_previous_outcome);
    % criterion1(:,5) = [];
    % criterion2(:,5) = [];
    % bar([1,4,7,10], nanmean(criterion1(:,1:4),1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'b');
    % hold on
    % errorbar([1,4,7,10], nanmean(criterion1(:,1:4),1), nanstd(criterion1(:,1:4),1) ./ sqrt(size(criterion1,1)), 'k.')
    % bar([1,4,7,10]+1, nanmean(criterion2(:,1:4),1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'r');
    % errorbar([1,4,7,10]+1, nanmean(criterion2(:,1:4),1), nanstd(criterion2(:,1:4),1) ./ sqrt(size(criterion2,1)), 'k.')
    % bar([14], nanmean(criterion1(:,5)), 'EdgeColor', 'k', 'FaceColor', 'b')
    % bar([15], nanmean(criterion2(:,5)), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([14], nanmean(criterion1(:,5)), nanstd(criterion1(:,5)) / sqrt(size(criterion1,1)), 'k.')
    % errorbar([15], nanmean(criterion2(:,5)), nanstd(criterion2(:,5)) / sqrt(size(criterion2,1)), 'k.')
    % bar([17], nanmean(criterion1(:,6)), 'EdgeColor', 'k', 'FaceColor', 'b')
    % bar([18], nanmean(criterion2(:,6)), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([17], nanmean(criterion1(:,6)), nanstd(criterion1(:,6)) / sqrt(size(criterion1,1)), 'k.')
    % errorbar([18], nanmean(criterion2(:,6)), nanstd(criterion2(:,6)) / sqrt(size(criterion2,1)), 'k.')
    % bar([21], nanmean(criterion1(:,7)), 'EdgeColor', 'k', 'FaceColor', 'b')
    % bar([22], nanmean(criterion2(:,7)), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([21], nanmean(criterion1(:,7)), nanstd(criterion1(:,7)) / sqrt(size(criterion1,1)), 'k.')
    % errorbar([22], nanmean(criterion2(:,7)), nanstd(criterion2(:,7)) / sqrt(size(criterion2,1)), 'k.')
    % bar([24], nanmean(criterion1(:,8)), 'EdgeColor', 'k', 'FaceColor', 'b')
    % bar([25], nanmean(criterion2(:,8)), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([24], nanmean(criterion1(:,8)), nanstd(criterion1(:,8)) / sqrt(size(criterion1,1)), 'k.')
    % errorbar([25], nanmean(criterion2(:,8)), nanstd(criterion2(:,8)) / sqrt(size(criterion2,1)), 'k.')
    % xticks([1,4,7,10, 14, 17, 21, 24]+0.5)
    % xticklabels({'Hit', 'Miss', 'CR', 'FA', 'Correct', 'Incorrect', 'Action', 'Inaction'})
    % xtickangle(45)
    % xlabel('Previous Trial Outcome', 'FontSize', 14)
    % ylabel('Criterion', 'FontSize', 14)
    % axs = gca(dprime_prev_fig);
    % axs.XAxis.FontSize = 12;
    % if out_path 
    %     saveas(qc_prev_fig, strcat(out_path, 'qc_criterion_by_previous_outcome.fig'))
    %     saveas(qc_prev_fig, strcat(out_path, 'qc_criterion_by_previous_outcome.png'))
    %     saveas(qc_prev_fig, strcat(out_path, 'qc_criterion_by_previous_outcome.svg'))
    % end

    % fprintf('qc criterion by previous outcome:\n')
    % t1 = table(animal1, criterion1(:,1), criterion1(:,2),criterion1(:,3), criterion1(:,4), ...
    %     'VariableNames', {'subject', 'hit', 'miss', 'cr', 'fa'});
    % t2 = table(animal2, criterion2(:,1), criterion2(:,2),criterion2(:,3), criterion2(:,4), ...
    %     'VariableNames', {'subject', 'hit', 'miss', 'cr', 'fa'});
    % Meas = table([1;2;3;4], 'VariableNames', {'Measurements'});
    % rm = fitrm(t1, 'hit-fa~subject', 'WithinDesign', Meas);
    % ranovatbl1 = ranova(rm)
    % rm = fitrm(t2, 'hit-fa~subject', 'WithinDesign', Meas);
    % ranovatbl2 = ranova(rm)
    % fprintf('performance:\n criterion1:\n')
    % disp(ranksum(criterion1(:,5),criterion1(:,6)))
    % fprintf('criterion2:\n')
    % disp(ranksum(criterion2(:,5),criterion2(:,6)))
    % fprintf('action:\n criterion1:\n')
    % disp(ranksum(criterion1(:,7),criterion1(:,8)))
    % fprintf('criterion2:\n')
    % disp(ranksum(criterion2(:,7),criterion2(:,8)))

    % rt by previous outcome 
    if visualize
        fig = figure();
    else
        fig = figure('Visible', 'off');
    end
    rt1 = cell2mat(ftr1.rt_by_previous_outcome);
    rt2 = cell2mat(ftr2.rt_by_previous_outcome);
    rt1(:,5) = [];
    rt2(:,5) = [];
    bar([1,4,7,10], nanmean(rt1(:,1:4),1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'b');
    hold on
    errorbar([1,4,7,10], nanmean(rt1(:,1:4),1), nanstd(rt1(:,1:4),1) ./ sqrt(size(rt1,1)), 'k.')
    bar([1,4,7,10]+1, nanmean(rt2(:,1:4),1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'r');
    errorbar([1,4,7,10]+1, nanmean(rt2(:,1:4),1), nanstd(rt2(:,1:4),1) ./ sqrt(size(rt2,1)), 'k.')
    bar([14], nanmean(rt1(:,5)), 'EdgeColor', 'k', 'FaceColor', 'b')
    bar([15], nanmean(rt2(:,5)), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([14], nanmean(rt1(:,5)), nanstd(rt1(:,5)) / sqrt(size(rt1,1)), 'k.')
    errorbar([15], nanmean(rt2(:,5)), nanstd(rt2(:,5)) / sqrt(size(rt2,1)), 'k.')
    bar([17], nanmean(rt1(:,6)), 'EdgeColor', 'k', 'FaceColor', 'b')
    bar([18], nanmean(rt2(:,6)), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([17], nanmean(rt1(:,6)), nanstd(rt1(:,6)) / sqrt(size(rt1,1)), 'k.')
    errorbar([18], nanmean(rt2(:,6)), nanstd(rt2(:,6)) / sqrt(size(rt2,1)), 'k.')
    bar([20], nanmean(rt1(:,7)), 'EdgeColor', 'k', 'FaceColor', 'b')
    bar([21], nanmean(rt2(:,7)), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([20], nanmean(rt1(:,7)), nanstd(rt1(:,7)) / sqrt(size(rt1,1)), 'k.')
    errorbar([21], nanmean(rt2(:,7)), nanstd(rt2(:,7)) / sqrt(size(rt2,1)), 'k.')
    bar([23], nanmean(rt1(:,8)), 'EdgeColor', 'k', 'FaceColor', 'b')
    bar([24], nanmean(rt2(:,8)), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([23], nanmean(rt1(:,8)), nanstd(rt1(:,8)) / sqrt(size(rt1,1)), 'k.')
    errorbar([24], nanmean(rt2(:,8)), nanstd(rt2(:,8)) / sqrt(size(rt2,1)), 'k.')
    xticks([1,4,7,10, 14, 17, 20, 23]+0.5)
    xticklabels({'Hit', 'Miss', 'CR', 'FA', 'Correct', 'Incorrect', 'Action', 'Inaction'})
    xlabel('Previous Trial Outcome')
    ylabel('Reaction Time (s)')
    if out_path 
        saveas(fig, strcat(out_path,'rt_by_previous_outcome.fig'))
        saveas(fig, strcat(out_path,'rt_by_previous_outcome.png'))
        saveas(fig, strcat(out_path,'rt_by_previous_outcome.svg'))
    end

    % if visualize
    %     rt_prev_fig = figure('Position', [1220, 1241, 864, 597]);
    % else
    %     rt_prev_fig = figure('Visible', 'off');
    % end
    % rt1 = cell2mat(ftr1.qc_rt_by_previous_outcome);
    % rt2 = cell2mat(ftr2.qc_rt_by_previous_outcome);
    % rt1(:,5) = [];
    % rt2(:,5) = [];
    % bar([1,4,7,10], nanmean(rt1(:,1:4),1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'b');
    % hold on
    % errorbar([1,4,7,10], nanmean(rt1(:,1:4),1), nanstd(rt1(:,1:4),1) ./ sqrt(size(rt1,1)), 'k.')
    % bar([1,4,7,10]+1, nanmean(rt2(:,1:4),1), 0.3, 'EdgeColor', 'k', 'FaceColor', 'r');
    % errorbar([1,4,7,10]+1, nanmean(rt2(:,1:4),1), nanstd(rt2(:,1:4),1) ./ sqrt(size(rt2,1)), 'k.')
    % bar([14], nanmean(rt1(:,5)), 'EdgeColor', 'k', 'FaceColor', 'b')
    % bar([15], nanmean(rt2(:,5)), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([14], nanmean(rt1(:,5)), nanstd(rt1(:,5)) / sqrt(size(rt1,1)), 'k.')
    % errorbar([15], nanmean(rt2(:,5)), nanstd(rt2(:,5)) / sqrt(size(rt2,1)), 'k.')
    % bar([17], nanmean(rt1(:,6)), 'EdgeColor', 'k', 'FaceColor', 'b')
    % bar([18], nanmean(rt2(:,6)), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([17], nanmean(rt1(:,6)), nanstd(rt1(:,6)) / sqrt(size(rt1,1)), 'k.')
    % errorbar([18], nanmean(rt2(:,6)), nanstd(rt2(:,6)) / sqrt(size(rt2,1)), 'k.')
    % bar([21], nanmean(rt1(:,7)), 'EdgeColor', 'k', 'FaceColor', 'b')
    % bar([22], nanmean(rt2(:,7)), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([21], nanmean(rt1(:,7)), nanstd(rt1(:,7)) / sqrt(size(rt1,1)), 'k.')
    % errorbar([22], nanmean(rt2(:,7)), nanstd(rt2(:,7)) / sqrt(size(rt2,1)), 'k.')
    % bar([24], nanmean(rt1(:,8)), 'EdgeColor', 'k', 'FaceColor', 'b')
    % bar([25], nanmean(rt2(:,8)), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([24], nanmean(rt1(:,8)), nanstd(rt1(:,8)) / sqrt(size(rt1,1)), 'k.')
    % errorbar([25], nanmean(rt2(:,8)), nanstd(rt2(:,8)) / sqrt(size(rt2,1)), 'k.')
    % xticks([1,4,7,10, 14, 17, 21, 24]+0.5)
    % xticklabels({'Hit', 'Miss', 'CR', 'FA', 'Correct', 'Incorrect', 'Action', 'Inaction'})
    % xlabel('Previous Trial Outcome', 'FontSize', 14)
    % ylabel('Reaction Time (s)', 'FontSize', 14)
    % xtickangle(45)
    % axs = gca(dprime_prev_fig);
    % axs.XAxis.FontSize = 12;
    % if out_path 
    %     saveas(rt_prev_fig, strcat(out_path, 'qc_rt_by_previous_outcome.fig'))
    %     saveas(rt_prev_fig, strcat(out_path, 'qc_rt_by_previous_outcome.png'))
    %     saveas(rt_prev_fig, strcat(out_path, 'qc_rt_by_previous_outcome.svg'))
    % end

    % fprintf('qc rt by previous outcome:\n')
    % t1 = table(animal1, rt1(:,1), rt1(:,2),rt1(:,3), rt1(:,4), ...
    %     'VariableNames', {'subject', 'hit', 'miss', 'cr', 'fa'});
    % t2 = table(animal2, rt2(:,1), rt2(:,2),rt2(:,3), rt2(:,4), ...
    %     'VariableNames', {'subject', 'hit', 'miss', 'cr', 'fa'});
    % Meas = table([1;2;3;4], 'VariableNames', {'Measurements'});
    % rm = fitrm(t1, 'hit-fa~subject', 'WithinDesign', Meas);
    % ranovatbl1 = ranova(rm)
    % rm = fitrm(t2, 'hit-fa~subject', 'WithinDesign', Meas);
    % ranovatbl2 = ranova(rm)
    % fprintf('performance:\n rt1:\n')
    % disp(ranksum(rt1(:,5),rt1(:,6)))
    % fprintf('rt2:\n')
    % disp(ranksum(rt2(:,5),rt2(:,6)))
    % fprintf('action:\n rt1:\n')
    % disp(ranksum(rt1(:,7),rt1(:,8)))
    % fprintf('rt2:\n')
    % disp(ranksum(rt2(:,7),rt2(:,8)))

    % keyboard

    % dprime
    if visualize
        fig = figure();
    else
        fig = figure('Visible', 'off');
    end
    dprime1 = ftr1.dprime;
    dprime2 = ftr2.dprime;
    bar([1], nanmean(dprime1), 'EdgeColor', 'k', 'FaceColor', 'b')
    hold on
    errorbar([1], nanmean(dprime1), nanstd(dprime1) ./ sqrt(length(dprime1)), 'k.')
    bar([2], nanmean(dprime2), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([2], nanmean(dprime2), nanstd(dprime2) ./ sqrt(length(dprime2)), 'k.')
    xticks([])
    ylabel('D-prime')
    if out_path 
        saveas(fig, strcat(out_path, 'dprime.fig'))
        saveas(fig, strcat(out_path, 'dprime.png'))
    end

    fprintf('dprime:\n')
    disp(ranksum(dprime1, dprime2))

    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % dprime1 = ftr1.qc_dprime;
    % dprime2 = ftr2.qc_dprime;
    % bar([1], nanmean(dprime1), 'EdgeColor', 'k', 'FaceColor', 'b')
    % hold on
    % errorbar([1], nanmean(dprime1), nanstd(dprime1) ./ sqrt(length(dprime1)), 'k.')
    % bar([2], nanmean(dprime2), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([2], nanmean(dprime2), nanstd(dprime2) ./ sqrt(length(dprime2)), 'k.')
    % xticks([])
    % ylabel('D-prime')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'qc_dprime.fig'))
    %     saveas(fig, strcat(out_path, 'qc_dprime.png'))
    % end

    % fprintf('qc dprime:\n')
    % disp(ranksum(dprime1, dprime2))

    % avg_reaction_time
    if visualize
        fig = figure();
    else
        fig = figure('Visible', 'off');
    end
    avg_reaction_time1 = ftr1.avg_reaction_time;
    avg_reaction_time2 = ftr2.avg_reaction_time;
    bar([1], nanmean(avg_reaction_time1), 'EdgeColor', 'k', 'FaceColor', 'b')
    hold on
    errorbar([1], nanmean(avg_reaction_time1), nanstd(avg_reaction_time1) ./ sqrt(length(avg_reaction_time1)), 'k.')
    bar([2], nanmean(avg_reaction_time2), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([2], nanmean(avg_reaction_time2), nanstd(avg_reaction_time2) ./ sqrt(length(avg_reaction_time2)), 'k.')
    xticks([])
    ylabel('Reaction Time (s)')
    if out_path 
        saveas(fig, strcat(out_path, 'avg_reaction_time.fig'))
        saveas(fig, strcat(out_path, 'avg_reaction_time.png'))
    end

    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % avg_reaction_time1 = ftr1.qc_avg_reaction_time;
    % avg_reaction_time2 = ftr2.qc_avg_reaction_time;
    % bar([1], nanmean(avg_reaction_time1), 'EdgeColor', 'k', 'FaceColor', 'b')
    % hold on
    % errorbar([1], nanmean(avg_reaction_time1), nanstd(avg_reaction_time1) ./ sqrt(length(avg_reaction_time1)), 'k.')
    % bar([2], nanmean(avg_reaction_time2), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([2], nanmean(avg_reaction_time2), nanstd(avg_reaction_time2) ./ sqrt(length(avg_reaction_time2)), 'k.')
    % xticks([])
    % ylabel('Reaction Time (s)')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'qc_avg_reaction_time.fig'))
    %     saveas(fig, strcat(out_path, 'qc_avg_reaction_time.png'))
    % end

    % criterion
    if visualize
        fig = figure();
    else
        fig = figure('Visible', 'off');
    end
    criterion1 = ftr1.criterion;
    criterion2 = ftr2.criterion;
    bar([1], nanmean(criterion1), 'EdgeColor', 'k', 'FaceColor', 'b')
    hold on
    errorbar([1], nanmean(criterion1), nanstd(criterion1) ./ sqrt(length(criterion1)), 'k.')
    bar([2], nanmean(criterion2), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([2], nanmean(criterion2), nanstd(criterion2) ./ sqrt(length(criterion2)), 'k.')
    xticks([])
    ylabel('Criterion')
    if out_path 
        saveas(fig, strcat(out_path, 'criterion.fig'))
        saveas(fig, strcat(out_path, 'criterion.png'))
    end
    fprintf('criterion:\n')
    disp(ranksum(criterion1, criterion2))

    % if visualize
    %     fig = figure();
    % else
    %     fig = figure('Visible', 'off');
    % end
    % criterion1 = ftr1.qc_criterion;
    % criterion2 = ftr2.qc_criterion;
    % bar([1], nanmean(criterion1), 'EdgeColor', 'k', 'FaceColor', 'b')
    % hold on
    % errorbar([1], nanmean(criterion1), nanstd(criterion1) ./ sqrt(length(criterion1)), 'k.')
    % bar([2], nanmean(criterion2), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([2], nanmean(criterion2), nanstd(criterion2) ./ sqrt(length(criterion2)), 'k.')
    % xticks([])
    % ylabel('Criterion')
    % if out_path 
    %     saveas(fig, strcat(out_path, 'qc_criterion.fig'))
    %     saveas(fig, strcat(out_path, 'qc_criterion.png'))
    % end
    % fprintf('qc criterion:\n')
    % disp(ranksum(criterion1, criterion2))

    if visualize
        hr_fig = figure();
    else
        hr_fig = figure('Visible', 'off');
    end
    hr1 = ftr1.hr;
    hr2 = ftr2.hr;
    bar([1], nanmean(hr1), 'EdgeColor', 'k', 'FaceColor', 'b')
    hold on
    errorbar([1], nanmean(hr1), nanstd(hr1) ./ sqrt(length(hr1)), 'k.')
    bar([2], nanmean(hr2), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([2], nanmean(hr2), nanstd(hr2) ./ sqrt(length(hr2)), 'k.')
    xticks([])
    ylabel('Hit Rate')
    if out_path 
        saveas(hr_fig, strcat(out_path, 'hr.fig'))
        saveas(hr_fig, strcat(out_path, 'hr.png'))
    end

    % if visualize
    %     qc_hr_fig = figure();
    % else
    %     qc_hr_fig = figure('Visible', 'off');
    % end
    % qc_hr1 = ftr1.qc_hr;
    % qc_hr2 = ftr2.qc_hr;
    % bar([1], nanmean(qc_hr1), 'EdgeColor', 'k', 'FaceColor', 'b')
    % hold on
    % errorbar([1], nanmean(qc_hr1), nanstd(qc_hr1) ./ sqrt(length(qc_hr1)), 'k.')
    % bar([2], nanmean(hr2), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([2], nanmean(qc_hr2), nanstd(qc_hr2) ./ sqrt(length(qc_hr2)), 'k.')
    % xticks([])
    % ylabel('Hit Rate')
    % if out_path 
    %     saveas(qc_hr_fig, strcat(out_path, 'qc_hr.fig'))
    %     saveas(qc_hr_fig, strcat(out_path, 'qc_hr.png'))
    % end

    if visualize
        far_fig = figure();
    else
        far_fig = figure('Visible', 'off');
    end
    far1 = ftr1.far;
    far2 = ftr2.far;
    bar([1], nanmean(far1), 'EdgeColor', 'k', 'FaceColor', 'b')
    hold on
    errorbar([1], nanmean(far1), nanstd(far1) ./ sqrt(length(far1)), 'k.')
    bar([2], nanmean(far2), 'EdgeColor', 'k', 'FaceColor', 'r')
    errorbar([2], nanmean(far2), nanstd(far2) ./ sqrt(length(far2)), 'k.')
    xticks([])
    ylabel('False Alarm Rate')
    if out_path 
        saveas(far_fig, strcat(out_path, 'far.fig'))
        saveas(far_fig, strcat(out_path, 'far.png'))
    end

    % if visualize
    %     qc_far_fig = figure();
    % else
    %     qc_far_fig = figure('Visible', 'off');
    % end
    % qc_far1 = ftr1.qc_far;
    % qc_far2 = ftr2.qc_far;
    % bar([1], nanmean(qc_far1), 'EdgeColor', 'k', 'FaceColor', 'b')
    % hold on
    % errorbar([1], nanmean(qc_far1), nanstd(qc_far1) ./ sqrt(length(qc_far1)), 'k.')
    % bar([2], nanmean(far2), 'EdgeColor', 'k', 'FaceColor', 'r')
    % errorbar([2], nanmean(qc_far2), nanstd(qc_far2) ./ sqrt(length(qc_far2)), 'k.')
    % xticks([])
    % ylabel('False Alarm Rate')
    % if out_path 
    %     saveas(qc_far_fig, strcat(out_path, 'qc_far.fig'))
    %     saveas(qc_far_fig, strcat(out_path, 'qc_far.png'))
    % end
    % keyboard
end