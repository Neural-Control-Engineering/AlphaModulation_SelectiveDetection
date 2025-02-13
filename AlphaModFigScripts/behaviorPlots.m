visualize = true;
out_path = false; %'Figures/';
ftr_files = {'subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'};
for i = 1:length(ftr_files)
    ftr_files{i} = strcat('~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/', ftr_files{i});
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

p = signrank(hr, far);
if p < (0.05 / length(hr))
    fprintf(sprintf('Hit Rate vs FA Rate: Wilcoxon Signed Rank **p = %d\n', p));
elseif p < 0.05
    fprintf(sprintf('Hit Rate vs FA Rate: Wilcoxon Signed Rank *p = %d\n', p));
else
    fprintf(sprintf('Hit Rate vs FA Rate: Wilcoxon Signed Rank p = %d\n', p));
end
p = signrank(rt_by_outcome(1,:), rt_by_outcome(2,:));
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