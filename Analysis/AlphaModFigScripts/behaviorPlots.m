delete Stats/behavior.txt 
diary Stats/behavior.txt 
init_paths;
visualize = true;
out_path = '../Figures/';
ftr_files = {'subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'};
for i = 1:length(ftr_files)
    ftr_files{i} = strcat(ftr_path, 'SLRT/', ftr_files{i});
end

 % add firing rate, fa rate 
 for i = 1:length(ftr_files)
    f = load(ftr_files{i});
    if i == 1
        ftrs = f.slrt_ftr;
    else
        ftrs = combineTables(ftrs, f.slrt_ftr);
    end
end

ftrs = ftrs(ftrs.qc_hr > 0.1,:);

% hit/false-alarm rates
if visualize
    fig = figure('Position', [[1210 1197 433 605]]);
else
    fig = figure('Visible', 'off','Position', [1215 1358 413 468]);
end
hold on 
hr = ftrs.qc_hr;
far = ftrs.qc_far;
for h = 1:length(hr)
    plot([1,2]+(rand()-0.5)*0.1, [hr(h), far(h)], 'o', 'MarkerSize', 10, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
    plot([1,2]+(rand()-0.5)*0.1, [hr(h), far(h)], '--', 'Color', [0.3, 0.3, 0.3])
end
errorbar(1, mean(hr), std(hr) / sqrt(length(hr)), 'b.', 'LineWidth', 2.5, 'CapSize', 20)
errorbar(2, mean(far), std(far) / sqrt(length(far)), 'b.', 'LineWidth', 2.5, 'CapSize', 20)
% plot(1, mean(hr), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b')
% plot(2, mean(far), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b')
% +(rand()-0.5)*0.1
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

fig = figure('Position', [[1210 1197 433 605]]);
hold on 
subjects = {'1075', '3387', '3755', '3738'};
cols = distinguishable_colors(length(subjects)+2);
cols([3,4],:) = [];
cols(end,:) = [0.5,0.5,0.5];
hrs = {};
fars = {};
for s = 1:length(subjects)
    tmp_ftr = ftrs(contains(ftrs.subject_id, subjects{s}),:);
    hr = tmp_ftr.qc_hr;
    far = tmp_ftr.qc_far;
    for h = 1:length(hr)
        x = (rand()-0.5)*0.1;
        plot([1,2]+x, [hr(h), far(h)], 'o', 'MarkerSize', 5, 'MarkerFaceColor', cols(s,:), 'MarkerEdgeColor', [1, 1, 1])
        plot([1,2]+x, [hr(h), far(h)], '--', 'Color', cols(s,:))
    end
    hrs{s} = hr;
    fars{s} = far;
end
for s = 1:length(subjects)
    tmp_ftr = ftrs(contains(ftrs.subject_id, subjects{s}),:);
    hr = tmp_ftr.qc_hr;
    far = tmp_ftr.qc_far;
    x = (rand()-0.5)*0.2;
    errorbar(1+x, mean(hr), std(hr) / sqrt(length(hr)), '.', 'LineWidth', 2.5, 'CapSize', 20, 'Color', cols(s,:))
    errorbar(2+x, mean(far), std(far) / sqrt(length(far)), '.', 'LineWidth', 2.5, 'CapSize', 20, 'Color', cols(s,:))
end
hr = ftrs.qc_hr;
far = ftrs.qc_far;
errorbar(1, mean(hr), std(hr) / sqrt(length(hr)), 'k.', 'LineWidth', 2.5, 'CapSize', 20)
errorbar(2, mean(far), std(far) / sqrt(length(far)), 'k.', 'LineWidth', 2.5, 'CapSize', 20)
xlim([0.75, 2.25])
ylim([0,1])
xticklabels({'Hit Rate', 'False Alarm Rate'})
xtickangle(45)
yticks([0,1])
xticks([1,2])
ax = gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
if out_path 
    saveas(fig, strcat(out_path, 'individual_hr_vs_far.fig'))
    saveas(fig, strcat(out_path, 'individual_hr_vs_far.svg'))
end
fprintf('\nHit Rates:\n')
[~,p] = ttest2(hrs{1}, hrs{2});
fprintf(sprintf('Animal 1 vs Animal 2 HR (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(hrs{1}, hrs{3});
fprintf(sprintf('Animal 1 vs Animal 3 HR (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(hrs{1}, hrs{4});
fprintf(sprintf('Animal 1 vs Animal 4 HR (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(hrs{2}, hrs{4});
fprintf(sprintf('Animal 2 vs Animal 4 HR (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(hrs{3}, hrs{4});
fprintf(sprintf('Animal 3 vs Animal 4 HR (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(hrs{3}, hrs{2});
fprintf(sprintf('Animal 3 vs Animal 2 HR (2-sample t-test): p = %d\n', p))
fprintf('\nFalse Alarm Rates:\n')
[~,p] = ttest2(fars{1}, fars{2});
fprintf(sprintf('Animal 1 vs Animal 2 HR (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(fars{1}, fars{3});
fprintf(sprintf('Animal 1 vs Animal 3 HR (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(fars{1}, fars{4});
fprintf(sprintf('Animal 1 vs Animal 4 HR (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(fars{2}, fars{4});
fprintf(sprintf('Animal 2 vs Animal 4 HR (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(fars{3}, fars{4});
fprintf(sprintf('Animal 3 vs Animal 4 HR (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(fars{3}, fars{2});
fprintf(sprintf('Animal 3 vs Animal 2 HR (2-sample t-test): p = %d\n', p))
fprintf('\nHit Rate vs. False Alarm Rate\n')
[~,p] = ttest(hrs{1}, fars{1});
fprintf(sprintf('Animal 1 (t-test): p = %d\n', p))
[~,p] = ttest(hrs{2}, fars{2});
fprintf(sprintf('Animal 2 (t-test): p = %d\n', p))
[~,p] = ttest(hrs{3}, fars{3});
fprintf(sprintf('Animal 3 (t-test): p = %d\n', p))
[~,p] = ttest(hrs{4}, fars{4});
fprintf(sprintf('Animal 4 (t-test): p = %d\n', p))

fig = figure('Position', [[1210 1197 433 605]]);
hold on 
subjects = {'1075', '3387', '3755', '3738'};
cols = distinguishable_colors(length(subjects)+2);
cols([3,4],:) = [];
cols(end,:) = [0.5,0.5,0.5];
hrt = {};
fart = {};
for s = 1:length(subjects)
    tmp_ftr = ftrs(contains(ftrs.subject_id, subjects{s}),:);
    rt_by_outcome = cell2mat(tmp_ftr.qc_rt_by_outcome)-0.2;
    for i = 1:size(rt_by_outcome,1)
        x = (rand()-0.5)*0.1;
        plot([1,2]+x, rt_by_outcome(i,:), 'o', 'MarkerSize', 5, 'MarkerFaceColor', cols(s,:), 'MarkerEdgeColor', [1, 1, 1])
        plot([1,2]+x, rt_by_outcome(i,:), '--', 'Color', cols(s,:))
    end
    hrt{s} = rt_by_outcome(:,1);
    fart{s} = rt_by_outcome(:,2);
end
for s = 1:length(subjects)
    x = (rand()-0.5)*0.2;
    errorbar(1+x, mean(hrt{s}), ste(hrt{s}), '.', 'LineWidth', 2.5, 'CapSize', 20, 'Color', cols(s,:))
    errorbar(2+x, mean(fart{s}), ste(fart{s}), '.', 'LineWidth', 2.5, 'CapSize', 20, 'Color', cols(s,:))
end
rt_by_outcome = cell2mat(ftrs.qc_rt_by_outcome)-0.2;
errorbar(1, nanmean(rt_by_outcome(:,1)), nanstd(rt_by_outcome(:,1)) / sqrt(length(rt_by_outcome(:,1))), 'k.', 'LineWidth', 2.5, 'CapSize', 20)
errorbar(2, nanmean(rt_by_outcome(:,2)), nanstd(rt_by_outcome(:,2)) / sqrt(length(rt_by_outcome(:,2))), 'k.', 'LineWidth', 2.5, 'CapSize', 20)
xlim([0.75, 2.25])
ylim([0,1])
xticklabels({'Hit', 'False Alarm'})
xtickangle(45)
yticks([0,1])
xticks([1,2])
xlabel('Trial Outcome')
ylabel('Reaction Time (s)')
ax = gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
if out_path 
    saveas(fig, strcat(out_path,'individual_reaction_times.fig'))
    saveas(fig, strcat(out_path,'individual_reaction_times.svg'))
end
fprintf('\nHit Reaction Time:\n')
[~,p] = ttest2(hrt{1}, hrt{2});
fprintf(sprintf('Animal 1 vs Animal 2 Hit Reaction Time (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(hrt{1}, hrt{3});
fprintf(sprintf('Animal 1 vs Animal 3 Hit Reaction Time (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(hrt{1}, hrt{4});
fprintf(sprintf('Animal 1 vs Animal 4 Hit Reaction Time (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(hrt{2}, hrt{4});
fprintf(sprintf('Animal 2 vs Animal 4 Hit Reaction Time (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(hrt{3}, hrt{4});
fprintf(sprintf('Animal 3 vs Animal 4 Hit Reaction Time (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(hrt{3}, hrt{2});
fprintf(sprintf('Animal 3 vs Animal 2 Hit Reaction Time (2-sample t-test): p = %d\n', p))
fprintf('\nFalse Alarm Reaction Time:\n')
[~,p] = ttest2(fars{1}, fars{2});
fprintf(sprintf('Animal 1 vs Animal 2 HR (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(fars{1}, fars{3});
fprintf(sprintf('Animal 1 vs Animal 3 HR (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(fars{1}, fars{4});
fprintf(sprintf('Animal 1 vs Animal 4 HR (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(fars{2}, fars{4});
fprintf(sprintf('Animal 2 vs Animal 4 HR (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(fars{3}, fars{4});
fprintf(sprintf('Animal 3 vs Animal 4 HR (2-sample t-test): p = %d\n', p))
[~,p] = ttest2(fars{3}, fars{2});
fprintf(sprintf('Animal 3 vs Animal 2 HR (2-sample t-test): p = %d\n', p))
fprintf('\nHit Rate vs. False Alarm Rate\n')
[~,p] = ttest(hrs{1}, fars{1});
fprintf(sprintf('Animal 1 (t-test): p = %d\n', p))
[~,p] = ttest(hrs{2}, fars{2});
fprintf(sprintf('Animal 2 (t-test): p = %d\n', p))
[~,p] = ttest(hrs{3}, fars{3});
fprintf(sprintf('Animal 3 (t-test): p = %d\n', p))
[~,p] = ttest(hrs{4}, fars{4});
fprintf(sprintf('Animal 4 (t-test): p = %d\n', p))

if visualize
    fig = figure('Position', [[1210 1197 433 605]]);
else
    fig = figure('Visible', 'off','Position', [1215 1358 413 468]);
end
hold on 
rt_by_outcome = cell2mat(ftrs.qc_rt_by_outcome)-0.2;
for i = 1:size(rt_by_outcome,1)
    plot([1,2]+(rand()-0.5)*0.1, rt_by_outcome(i,:), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
    plot([1,2]+(rand()-0.5)*0.1, rt_by_outcome(i,:), '--', 'Color', [0.3, 0.3, 0.3])
end
errorbar(1, nanmean(rt_by_outcome(:,1)), nanstd(rt_by_outcome(:,1)) / sqrt(length(rt_by_outcome(:,1))), 'b.', 'LineWidth', 2.5, 'CapSize', 20)
errorbar(2, nanmean(rt_by_outcome(:,2)), nanstd(rt_by_outcome(:,2)) / sqrt(length(rt_by_outcome(:,2))), 'b.', 'LineWidth', 2.5, 'CapSize', 20)
% plot(1,mean(rt_by_outcome(:,1)), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 8)
% plot(2,mean(rt_by_outcome(:,2)), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 8)
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

[~, p] = ttest(hr, far);
if p < (0.05 / length(hr))
    fprintf(sprintf('Hit Rate vs FA Rate: Wilcoxon Signed Rank **p = %d\n', p));
elseif p < 0.05
    fprintf(sprintf('Hit Rate vs FA Rate: Wilcoxon Signed Rank *p = %d\n', p));
else
    fprintf(sprintf('Hit Rate vs FA Rate: Wilcoxon Signed Rank p = %d\n', p));
end
[~, p] = ttest(rt_by_outcome(1,:), rt_by_outcome(2,:));
if p < (0.05 / length(hr))
    fprintf(sprintf('Hit RT vs FA RT: Wilcoxon Signed Rank **p = %d\n', p));
elseif p < 0.05 
    fprintf(sprintf('Hit RT vs FA RT: Wilcoxon Signed Rank *p = %d\n', p));
else
    fprintf(sprintf('Hit RT vs FA RT: Wilcoxon Signed Rank p = %d\n', p));
end

fprintf(sprintf('Mean d-prime: %d\n', nanmean(ftrs.dprime)));
fprintf(sprintf('d-prime Standard Error: %d\n', nanstd(ftrs.dprime)/sqrt(sum(~isnan(ftrs.dprime)))));
fprintf(sprintf('Avg Hit RT: %d\n', nanmean(rt_by_outcome(1,:))))
fprintf(sprintf('Hit RT Standard Error: %d\n', nanstd(rt_by_outcome(1,:))/sqrt(sum(~isnan(rt_by_outcome(1,:))))))
fprintf(sprintf('Avg FA RT: %d\n', nanmean(rt_by_outcome(2,:))))
fprintf(sprintf('FA RT Standard Error: %d\n', nanstd(rt_by_outcome(2,:))/sqrt(sum(~isnan(rt_by_outcome(2,:))))))
fprintf(sprintf('Avg. Hit Rate: %d +/ %d\n', nanmean(hr), nanstd(hr) / sqrt(sum(~isnan(hr)))))
fprintf(sprintf('Avg. FA Rate: %d +/ %d\n', nanmean(far), nanstd(far) / sqrt(sum(~isnan(far)))))

ftr_files = {'subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_all.mat'};
for i = 1:length(ftr_files)
    ftr_files{i} = strcat(ftr_path, 'SLRT/', ftr_files{i});
end

 % add firing rate, fa rate 
 for i = 1:length(ftr_files)
    f = load(ftr_files{i});
    if i == 1
        ftrs = f.slrt_ftr;
    else
        ftrs = combineTables(ftrs, f.slrt_ftr);
    end
end

fig = figure('Position', [1369 1168 795 309]);
subjects = {'1075', '3387', '3755', '3738'};
for s = 1:length(subjects)
    tmp_ftr = ftrs(contains(ftrs.subject_id, subjects{s}),:);
    plot(tmp_ftr.qc_dprime, '*-', 'Color', cols(s,:))
    hold on 
end
plot([1,10], [1,1], 'k--')
xlabel('Session Number', 'FontSize', 18)
ylabel('D-prime', 'FontSize', 18)
yticks([-0.5,4])
ax = gca;
ax.YAxis.FontSize = 16;
ax.XAxis.FontSize = 16;
ylim([-0.5,4])
xlim([1,10])
if out_path 
    saveas(fig, strcat(out_path,'dprime_vs_session.fig'))
    saveas(fig, strcat(out_path,'dprime_vs_session.svg'))
end

% load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/SLRT/date--2025-01-17_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat
% fig1 = lickRaster(slrt_data);
% saveas(fig1, strcat(out_path, 'lick_raster_example_1075.svg'))
% saveas(fig1, strcat(out_path, 'lick_raster_example_1075.fig'))
% load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/SLRT/date--2024-04-04_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat
% fig2 = lickRaster(slrt_data);
% saveas(fig2, strcat(out_path, 'lick_raster_example_3387.svg'))
% saveas(fig2, strcat(out_path, 'lick_raster_example_3387.fig'))
% load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/SLRT/date--2024-07-16_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat
% fig3 = lickRaster(slrt_data);
% saveas(fig3, strcat(out_path, 'lick_raster_example_3738.svg'))
% saveas(fig3, strcat(out_path, 'lick_raster_example_3738.fig'))
load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/SLRT/date--2024-09-05_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat
[raster_fig, sem_fig] = lickRaster(slrt_data);
saveas(raster_fig, strcat(out_path, 'lick_raster_example_3755.svg'))
saveas(raster_fig, strcat(out_path, 'lick_raster_example_3755.fig'))
saveas(sem_fig, strcat(out_path, 'lick_sem_example_3755.svg'))
saveas(sem_fig, strcat(out_path, 'lick_sem_example_3755.fig'))
clear slrt_data

session_ids = unique(ftrs.session_id);
licks = [];
for s = 1:length(session_ids)
    load(strcat(ext_path, 'SLRT/', session_ids{s}, '.mat'))
    lick_mat = lickHist(slrt_data);
    licks = [licks; mean(lick_mat)];
end
bins = -3:0.1:5;
centers = zeros(length(bins)-1,1);
for e = 1:(length(bins)-1)
    centers(e) = mean(bins(e:(e+1)));
end
all_lick_fig = figure('Position', [86 738 745 287]);
semshade(licks ./ 0.1, 0.3, 'k', 'k', centers)
xlabel('Time (s)', 'FontSize', 18)
ylabel('Lick Frequency (Hz)', 'FontSize', 18)
ax = gca;
ax.YAxis.FontSize = 16;
ax.XAxis.FontSize = 16;
xlim([-3,5])
ylim([0,2.5])
yticks([0,2.5])
saveas(all_lick_fig, strcat(out_path, 'all_lick_sem.fig'))
saveas(all_lick_fig, strcat(out_path, 'all_lick_sem.svg'))

diary off 