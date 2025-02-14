init_paths;
out_path = true; %% toggle to save figures
mkdir('./Figures/')

ftr_files = {strcat(ftr_path, 'AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat')};
% combine animals
for i = 1:length(ftr_files)
    f = load(ftr_files{i});
    if i == 1
        ftrs = f.ap_ftr;
    else
        ftrs = combineTables(ftrs, f.ap_ftr);
    end
end
ss = ftrs(startsWith(ftrs.region, 'SS'),:);
striatum_inds = strcmp(ftrs.region, 'STR') + strcmp(ftrs.region, 'CP');
bg = ftrs(logical(striatum_inds), :);
ag_inds = strcmp(ftrs.region, 'BLAp') + strcmp(ftrs.region, 'LA');
ag = ftrs(logical(ag_inds),:);

ftr_files = {strcat(ftr_path, 'AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'AP/subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat')};
for i = 1:length(ftr_files)
    f = load(ftr_files{i});
    if i == 1
        ftrs = f.ap_ftr;
    else
        ftrs = combineTables(ftrs, f.ap_ftr);
    end
end
pfc_inds = startsWith(ftrs.region, 'DP') + startsWith(ftrs.region, 'AC') ...
    + startsWith(ftrs.region, 'PL') + startsWith(ftrs.region, 'IL') ...
    + startsWith(ftrs.region, 'OR');
pfc = ftrs(logical(pfc_inds),:);

ss_rs = ss(strcmp(ss.waveform_class, 'RS'),:);
ss_fs = ss(strcmp(ss.waveform_class, 'FS'),:);
bg_rs = bg(strcmp(bg.waveform_class, 'RS'),:);
bg_fs = bg(strcmp(bg.waveform_class, 'FS'),:);
ag_rs = ag(strcmp(ag.waveform_class, 'RS'),:);
ag_fs = ag(strcmp(ag.waveform_class, 'FS'),:);
pfc_rs = pfc(strcmp(pfc.waveform_class, 'RS'),:);
pfc_fs = pfc(strcmp(pfc.waveform_class, 'FS'),:);

signals = {'left_trigger_aligned_avg_fr_Hit', ...
    'left_trigger_aligned_avg_fr_Miss', ...
    'right_trigger_aligned_avg_fr_CR', ...
    'right_trigger_aligned_avg_fr_FA'};
ttls = {'Hit', 'Miss', 'Correct Rejection', 'False Alarm'};
time = linspace(-2.8,4.9,80);

% rs figure 
rs_fig = figure('Position', [1220 881 1314 957]);
tl = tiledlayout(4,4);
axs = zeros(4,4);
r = 1;
for c = 1:length(signals)
    axs(r,c) = nexttile;
    mat = cell2mat(ss_rs.(signals{c}));
    semshade(mat, 0.3, 'k', 'k', time, 1);
    title(ttls{c}, 'FontSize', 16, 'FontWeight','Normal');
    xlim([-2.8,4.9])
    ylim([5,10])
    yticks([5,10])
    if c == 1
        yticks([5,10])
        ax = gca;
        ax.YAxis.FontSize = 12;
        ylabel('S1', 'FontSize', 16)
    else
        yticks([])
    end
    xticklabels({})
end
r = 2;
for c = 1:length(signals)
    axs(r,c) = nexttile;
    mat = cell2mat(pfc_rs.(signals{c}));
    semshade(mat, 0.3, 'k', 'k', time, 1);
    %title(ttls{c});
    xlim([-2.8,4.9])
    ylim([2.5,4])
    if c == 1
        yticks([2.5,4])
        ax = gca;
        ax.YAxis.FontSize = 12;
        ylabel('PFC', 'FontSize', 16)
    else
        yticks([])
    end
    xticklabels({})
end
r = 3;
for c = 1:length(signals)
    axs(r,c) = nexttile;
    mat = cell2mat(bg_rs.(signals{c}));
    semshade(mat, 0.3, 'k', 'k', time, 1);
    %title(ttls{c});
    xlim([-2.8,4.9])
    ylim([2,12])
    if c == 1
        yticks([2,12])
        ax = gca;
        ax.YAxis.FontSize = 12;
        ylabel('Striatum', 'FontSize', 16)
    else
        yticks([])
    end
    ax = gca;
    ax.XAxis.FontSize = 12;
end
r = 4;
for c = 1:length(signals)
    axs(r,c) = nexttile;
    mat = cell2mat(ag_rs.(signals{c}));
    semshade(mat, 0.3, 'k', 'k', time, 1);
    %title(ttls{c});
    xlim([-2.8,4.9])
    ylim([15,50])
    if c == 1
        yticks([15,50])
        ax = gca;
        ax.YAxis.FontSize = 12;
        ylabel('Amygdala', 'FontSize', 16)
    else
        yticks([])
    end
    ax = gca;
    ax.XAxis.FontSize = 12;
end
xlabel(tl, 'Time (s)', 'FontSize', 16)
ylabel(tl, 'Avg. Firing Rate (Hz)', 'FontSize', 16)
title(tl, 'Regular Spiking Units', 'FontSize', 16)
if out_path
    saveas(rs_fig, 'Figures/rs_avg_frs.svg')
    saveas(rs_fig, 'Figures/rs_avg_frs.fig')
end

% fs figure 
fs_fig = figure('Position', [1220 881 1314 957]);
tl = tiledlayout(4,4);
axs = zeros(4,4);
r = 1;
for c = 1:length(signals)
    axs(r,c) = nexttile;
    mat = cell2mat(ss_fs.(signals{c}));
    semshade(mat, 0.3, 'k', 'k', time, 1);
    title(ttls{c}, 'FontSize', 16, 'FontWeight','Normal');
    xlim([-2.8,4.9])
    ylim([8,25])
    if c == 1
        yticks([8,25])
        ax = gca;
        ax.YAxis.FontSize = 12;
        ylabel('S1', 'FontSize', 16)
    else
        yticks([])
    end
    xticklabels({})
end
r = 2;
for c = 1:length(signals)
    axs(r,c) = nexttile;
    mat = cell2mat(pfc_fs.(signals{c}));
    semshade(mat, 0.3, 'k', 'k', time, 1);
    %title(ttls{c});
    xlim([-2.8,4.9])
    ylim([10,25])
    if c == 1
        yticks([10,25])
        ax = gca;
        ax.YAxis.FontSize = 12;
        ylabel('PFC', 'FontSize', 16)
    else
        yticks([])
    end
    xticklabels({})
end
r = 3;
for c = 1:length(signals)
    axs(r,c) = nexttile;
    mat = cell2mat(bg_fs.(signals{c}));
    semshade(mat, 0.3, 'k', 'k', time, 1);
    %title(ttls{c});
    xlim([-2.8,4.9])
    ylim([10,20])
    if c == 1
        yticks([10,20])
        ax = gca;
        ax.YAxis.FontSize = 12;
        ylabel('Striatum', 'FontSize', 16)
    else
        yticks([])
    end
    ax = gca;
    ax.XAxis.FontSize = 12;
end
r = 4;
for c = 1:length(signals)
    axs(r,c) = nexttile;
    mat = cell2mat(ag_fs.(signals{c}));
    semshade(mat, 0.3, 'k', 'k', time, 1);
    %title(ttls{c});
    xlim([-2.8,4.9])
    ylim([20,60])
    if c == 1
        yticks([20,60])
        ax = gca;
        ax.YAxis.FontSize = 12;
        ylabel('Amygdala', 'FontSize', 16)
    else
        yticks([])
    end
    ax = gca;
    ax.XAxis.FontSize = 12;
end
xlabel(tl, 'Time (s)', 'FontSize', 16)
ylabel(tl, 'Avg. Firing Rate (Hz)', 'FontSize', 16)
title(tl, 'Fast Spiking Units', 'FontSize', 16)
if out_path
    saveas(fs_fig, 'Figures/fs_avg_frs.svg')
    saveas(fs_fig, 'Figures/fs_avg_frs.fig')
end

% statistics 
%% ss 
ss_fs_hit = cell2mat(ss_fs.left_trigger_aligned_avg_fr_Hit);
ss_fs_miss = cell2mat(ss_fs.left_trigger_aligned_avg_fr_Miss);
ss_fs_cr = cell2mat(ss_fs.right_trigger_aligned_avg_fr_CR);
ss_fs_fa = cell2mat(ss_fs.right_trigger_aligned_avg_fr_FA);

ss_fs_hit_delta = ss_fs_hit - nanmean(ss_fs_hit(:,time<0),2); 
ss_fs_miss_delta = ss_fs_miss - nanmean(ss_fs_miss(:,time<0),2); 
ss_fs_cr_delta = ss_fs_cr - nanmean(ss_fs_cr(:,time<0),2); 
ss_fs_fa_delta = ss_fs_fa - nanmean(ss_fs_fa(:,time<0),2); 

ss_fs_hit_depol = max(ss_fs_hit_delta(:,time>0 & time < 0.3),[],2);
ss_fs_miss_depol = max(ss_fs_miss_delta(:,time>0 & time < 0.3),[],2);
ss_fs_cr_depol = max(ss_fs_cr_delta(:,time>0 & time < 0.3),[],2);
ss_fs_fa_depol = max(ss_fs_fa_delta(:,time>0 & time < 0.3),[],2);

ss_rs_hit = cell2mat(ss_rs.left_trigger_aligned_avg_fr_Hit);
ss_rs_miss = cell2mat(ss_rs.left_trigger_aligned_avg_fr_Miss);
ss_rs_cr = cell2mat(ss_rs.right_trigger_aligned_avg_fr_CR);
ss_rs_fa = cell2mat(ss_rs.right_trigger_aligned_avg_fr_FA);

ss_rs_hit_delta = ss_rs_hit - nanmean(ss_rs_hit(:,time<0),2); 
ss_rs_miss_delta = ss_rs_miss - nanmean(ss_rs_miss(:,time<0),2); 
ss_rs_cr_delta = ss_rs_cr - nanmean(ss_rs_cr(:,time<0),2); 
ss_rs_fa_delta = ss_rs_fa - nanmean(ss_rs_fa(:,time<0),2); 

ss_rs_hit_depol = max(ss_rs_hit_delta(:,time>0 & time < 0.3),[],2);
ss_rs_miss_depol = max(ss_rs_miss_delta(:,time>0 & time < 0.3),[],2);
ss_rs_cr_depol = max(ss_rs_cr_delta(:,time>0 & time < 0.3),[],2);
ss_rs_fa_depol = max(ss_rs_fa_delta(:,time>0 & time < 0.3),[],2);

%% bg 
bg_fs_hit = cell2mat(bg_fs.left_trigger_aligned_avg_fr_Hit);
bg_fs_miss = cell2mat(bg_fs.left_trigger_aligned_avg_fr_Miss);
bg_fs_cr = cell2mat(bg_fs.right_trigger_aligned_avg_fr_CR);
bg_fs_fa = cell2mat(bg_fs.right_trigger_aligned_avg_fr_FA);

bg_fs_hit_delta = bg_fs_hit - nanmean(bg_fs_hit(:,time<0),2); 
bg_fs_miss_delta = bg_fs_miss - nanmean(bg_fs_miss(:,time<0),2); 
bg_fs_cr_delta = bg_fs_cr - nanmean(bg_fs_cr(:,time<0),2); 
bg_fs_fa_delta = bg_fs_fa - nanmean(bg_fs_fa(:,time<0),2); 

bg_fs_hit_depol = max(bg_fs_hit_delta(:,time>0 & time < 0.3),[],2);
bg_fs_miss_depol = max(bg_fs_miss_delta(:,time>0 & time < 0.3),[],2);
bg_fs_cr_depol = max(bg_fs_cr_delta(:,time>0 & time < 0.3),[],2);
bg_fs_fa_depol = max(bg_fs_fa_delta(:,time>0 & time < 0.3),[],2);

bg_rs_hit = cell2mat(bg_rs.left_trigger_aligned_avg_fr_Hit);
bg_rs_miss = cell2mat(bg_rs.left_trigger_aligned_avg_fr_Miss);
bg_rs_cr = cell2mat(bg_rs.right_trigger_aligned_avg_fr_CR);
bg_rs_fa = cell2mat(bg_rs.right_trigger_aligned_avg_fr_FA);

bg_rs_hit_delta = bg_rs_hit - nanmean(bg_rs_hit(:,time<0),2); 
bg_rs_miss_delta = bg_rs_miss - nanmean(bg_rs_miss(:,time<0),2); 
bg_rs_cr_delta = bg_rs_cr - nanmean(bg_rs_cr(:,time<0),2); 
bg_rs_fa_delta = bg_rs_fa - nanmean(bg_rs_fa(:,time<0),2); 

bg_rs_hit_depol = max(bg_rs_hit_delta(:,time>0 & time < 0.3),[],2);
bg_rs_miss_depol = max(bg_rs_miss_delta(:,time>0 & time < 0.3),[],2);
bg_rs_cr_depol = max(bg_rs_cr_delta(:,time>0 & time < 0.3),[],2);
bg_rs_fa_depol = max(bg_rs_fa_delta(:,time>0 & time < 0.3),[],2);

%% ag 
ag_fs_hit = cell2mat(ag_fs.left_trigger_aligned_avg_fr_Hit);
ag_fs_miss = cell2mat(ag_fs.left_trigger_aligned_avg_fr_Miss);
ag_fs_cr = cell2mat(ag_fs.right_trigger_aligned_avg_fr_CR);
ag_fs_fa = cell2mat(ag_fs.right_trigger_aligned_avg_fr_FA);

ag_fs_hit_delta = ag_fs_hit - nanmean(ag_fs_hit(:,time<0),2); 
ag_fs_miss_delta = ag_fs_miss - nanmean(ag_fs_miss(:,time<0),2); 
ag_fs_cr_delta = ag_fs_cr - nanmean(ag_fs_cr(:,time<0),2); 
ag_fs_fa_delta = ag_fs_fa - nanmean(ag_fs_fa(:,time<0),2); 

ag_fs_hit_depol = max(ag_fs_hit_delta(:,time>0 & time < 0.3),[],2);
ag_fs_miss_depol = max(ag_fs_miss_delta(:,time>0 & time < 0.3),[],2);
ag_fs_cr_depol = max(ag_fs_cr_delta(:,time>0 & time < 0.3),[],2);
ag_fs_fa_depol = max(ag_fs_fa_delta(:,time>0 & time < 0.3),[],2);

ag_rs_hit = cell2mat(ag_rs.left_trigger_aligned_avg_fr_Hit);
ag_rs_miss = cell2mat(ag_rs.left_trigger_aligned_avg_fr_Miss);
ag_rs_cr = cell2mat(ag_rs.right_trigger_aligned_avg_fr_CR);
ag_rs_fa = cell2mat(ag_rs.right_trigger_aligned_avg_fr_FA);

ag_rs_hit_delta = ag_rs_hit - nanmean(ag_rs_hit(:,time<0),2); 
ag_rs_miss_delta = ag_rs_miss - nanmean(ag_rs_miss(:,time<0),2); 
ag_rs_cr_delta = ag_rs_cr - nanmean(ag_rs_cr(:,time<0),2); 
ag_rs_fa_delta = ag_rs_fa - nanmean(ag_rs_fa(:,time<0),2); 

ag_rs_hit_depol = max(ag_rs_hit_delta(:,time>0 & time < 0.3),[],2);
ag_rs_miss_depol = max(ag_rs_miss_delta(:,time>0 & time < 0.3),[],2);
ag_rs_cr_depol = max(ag_rs_cr_delta(:,time>0 & time < 0.3),[],2);
ag_rs_fa_depol = max(ag_rs_fa_delta(:,time>0 & time < 0.3),[],2);

%% pfc 
pfc_fs_hit = cell2mat(pfc_fs.left_trigger_aligned_avg_fr_Hit);
n = size(pfc_fs_hit,2);
for c = 1:size(pfc_fs)
    if isempty(pfc_fs(c,:).left_trigger_aligned_avg_fr_Miss{1})
        pfc_fs(c,:).left_trigger_aligned_avg_fr_Miss{1} = nan(1,n);
    end
end
pfc_fs_miss = cell2mat(pfc_fs.left_trigger_aligned_avg_fr_Miss);
pfc_fs_cr = cell2mat(pfc_fs.right_trigger_aligned_avg_fr_CR);
pfc_fs_fa = cell2mat(pfc_fs.right_trigger_aligned_avg_fr_FA);

pfc_fs_hit_delta = pfc_fs_hit - nanmean(pfc_fs_hit(:,time<0),2); 
pfc_fs_miss_delta = pfc_fs_miss - nanmean(pfc_fs_miss(:,time<0),2); 
pfc_fs_cr_delta = pfc_fs_cr - nanmean(pfc_fs_cr(:,time<0),2); 
pfc_fs_fa_delta = pfc_fs_fa - nanmean(pfc_fs_fa(:,time<0),2); 

pfc_fs_hit_depol = max(pfc_fs_hit_delta(:,time>0 & time < 0.3),[],2);
pfc_fs_miss_depol = max(pfc_fs_miss_delta(:,time>0 & time < 0.3),[],2);
pfc_fs_cr_depol = max(pfc_fs_cr_delta(:,time>0 & time < 0.3),[],2);
pfc_fs_fa_depol = max(pfc_fs_fa_delta(:,time>0 & time < 0.3),[],2);

pfc_rs_hit = cell2mat(pfc_rs.left_trigger_aligned_avg_fr_Hit);
n = size(pfc_rs_hit,2);
for c = 1:size(pfc_rs)
    if isempty(pfc_rs(c,:).left_trigger_aligned_avg_fr_Miss{1})
        pfc_rs(c,:).left_trigger_aligned_avg_fr_Miss{1} = nan(1,n);
    end
end
pfc_rs_miss = cell2mat(pfc_rs.left_trigger_aligned_avg_fr_Miss);
pfc_rs_cr = cell2mat(pfc_rs.right_trigger_aligned_avg_fr_CR);
pfc_rs_fa = cell2mat(pfc_rs.right_trigger_aligned_avg_fr_FA);

pfc_rs_hit_delta = pfc_rs_hit - nanmean(pfc_rs_hit(:,time<0),2); 
pfc_rs_miss_delta = pfc_rs_miss - nanmean(pfc_rs_miss(:,time<0),2); 
pfc_rs_cr_delta = pfc_rs_cr - nanmean(pfc_rs_cr(:,time<0),2); 
pfc_rs_fa_delta = pfc_rs_fa - nanmean(pfc_rs_fa(:,time<0),2); 

pfc_rs_hit_depol = max(pfc_rs_hit_delta(:,time>0 & time < 0.3),[],2);
pfc_rs_miss_depol = max(pfc_rs_miss_delta(:,time>0 & time < 0.3),[],2);
pfc_rs_cr_depol = max(pfc_rs_cr_delta(:,time>0 & time < 0.3),[],2);
pfc_rs_fa_depol = max(pfc_rs_fa_delta(:,time>0 & time < 0.3),[],2);

fprintf(sprintf('S1 RS: N = %i\n', length(ss_rs_hit_depol)))
fprintf(sprintf('S1 FS: N = %i\n\n', length(ss_fs_hit_depol)))

fprintf(sprintf('PFC RS: N = %i\n', length(pfc_rs_hit_depol)))
fprintf(sprintf('PFC FS: N = %i\n\n', length(pfc_fs_hit_depol)))

fprintf(sprintf('Striatum RS: N = %i\n', length(bg_rs_hit_depol)))
fprintf(sprintf('Striatum FS: N = %i\n\n', length(bg_fs_hit_depol)))

fprintf(sprintf('Amygdala RS: N = %i\n', length(ag_rs_hit_depol)))
fprintf(sprintf('Amygdala FS: N = %i\n\n', length(ag_fs_hit_depol)))

p = signrank(ss_rs_hit_depol, ss_rs_miss_depol);
if p < (0.05 / length(ss_rs_hit_depol))
    fprintf(sprintf('S1 RS Hit vs. Miss (Wilcoxon Signed Rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('S1 RS Hit vs. Miss (Wilcoxon Signed Rank): *p = %d\n', p))
else
    fprintf(sprintf('S1 RS Hit vs. Miss (Wilcoxon Signed Rank): p = %d\n', p))
end

p = signrank(ss_fs_hit_depol, ss_fs_miss_depol);
if p < (0.05 / length(ss_fs_hit_depol))
    fprintf(sprintf('S1 FS Hit vs. Miss (Wilcoxon Signed Rank): **p = %d\n\n', p))
elseif p < 0.05
    fprintf(sprintf('S1 FS Hit vs. Miss (Wilcoxon Signed Rank): *p = %d\n\n', p))
else
    fprintf(sprintf('S1 FS Hit vs. Miss (Wilcoxon Signed Rank): p = %d\n\n', p))
end

fprintf('S1 RS Hit: %d +/- %d\n', nanmean(ss_rs_hit_depol), nanstd(ss_rs_hit_depol)/sqrt(sum(~isnan(ss_rs_hit_depol))));
fprintf('S1 RS Miss: %d +/- %d\n', nanmean(ss_rs_miss_depol), nanstd(ss_rs_miss_depol)/sqrt(sum(~isnan(ss_rs_miss_depol))));
fprintf('S1 FS Hit: %d +/- %d\n', nanmean(ss_fs_hit_depol), nanstd(ss_fs_hit_depol)/sqrt(sum(~isnan(ss_fs_hit_depol))));
fprintf('S1 FS Miss: %d +/- %d\n', nanmean(ss_fs_miss_depol), nanstd(ss_fs_miss_depol)/sqrt(sum(~isnan(ss_fs_miss_depol))));

p = signrank(pfc_rs_hit_depol, pfc_rs_miss_depol);
if p < (0.05 / length(pfc_rs_hit_depol))
    fprintf(sprintf('PFC RS Hit vs. Miss: **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('PFC RS Hit vs. Miss: *p = %d\n', p))
else
    fprintf(sprintf('PFC RS Hit vs. Miss: p = %d\n', p))
end

p = signrank(pfc_fs_hit_depol, pfc_fs_miss_depol);
if p < (0.05 / length(pfc_fs_hit_depol))
    fprintf(sprintf('PFC FS Hit vs. Miss: **p = %d\n\n', p))
elseif p < 0.05 
    fprintf(sprintf('PFC FS Hit vs. Miss: *p = %d\n\n', p))
else
    fprintf(sprintf('PFC FS Hit vs. Miss: p = %d\n\n', p))
end

fprintf('PFC RS Hit: %d +/- %d\n', nanmean(pfc_rs_hit_depol), nanstd(pfc_rs_hit_depol)/sqrt(sum(~isnan(pfc_rs_hit_depol))));
fprintf('PFC RS Miss: %d +/- %d\n', nanmean(pfc_rs_miss_depol), nanstd(pfc_rs_miss_depol)/sqrt(sum(~isnan(pfc_rs_miss_depol))));
fprintf('PFC FS Hit: %d +/- %d\n', nanmean(pfc_fs_hit_depol), nanstd(pfc_fs_hit_depol)/sqrt(sum(~isnan(pfc_fs_hit_depol))));
fprintf('PFC FS Miss: %d +/- %d\n', nanmean(pfc_fs_miss_depol), nanstd(pfc_fs_miss_depol)/sqrt(sum(~isnan(pfc_fs_miss_depol))));

p = signrank(bg_rs_hit_depol, bg_rs_miss_depol);
if p < (0.05 < length(bg_rs_hit_depol))
    fprintf(sprintf('Striatum RS Hit vs. Miss: **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Striatum RS Hit vs. Miss: *p = %d\n', p))
else
    fprintf(sprintf('Striatum RS Hit vs. Miss: p = %d\n', p))
end

p = signrank(bg_fs_hit_depol, bg_fs_miss_depol);
if p < (0.05 / length(bg_fs_hit_depol))
    fprintf(sprintf('Striatum FS Hit vs. Miss: **p = %d\n\n', p))
elseif p < 0.05
    fprintf(sprintf('Striatum FS Hit vs. Miss: *p = %d\n\n', p))
else
    fprintf(sprintf('Striatum FS Hit vs. Miss: p = %d\n\n', p))
end

fprintf('Striatum RS Hit: %d +/- %d\n', nanmean(bg_rs_hit_depol), nanstd(bg_rs_hit_depol)/sqrt(sum(~isnan(bg_rs_hit_depol))));
fprintf('Striatum RS Miss: %d +/- %d\n', nanmean(bg_rs_miss_depol), nanstd(bg_rs_miss_depol)/sqrt(sum(~isnan(bg_rs_miss_depol))));
fprintf('Striatum FS Hit: %d +/- %d\n', nanmean(bg_fs_hit_depol), nanstd(bg_fs_hit_depol)/sqrt(sum(~isnan(bg_fs_hit_depol))));
fprintf('Striatum FS Miss: %d +/- %d\n', nanmean(bg_fs_miss_depol), nanstd(bg_fs_miss_depol)/sqrt(sum(~isnan(bg_fs_miss_depol))));

p = signrank(ag_rs_hit_depol, ag_rs_miss_depol);
if p < (0.05 / length(ag_rs_hit_depol))
    fprintf(sprintf('Amygdala RS Hit vs. Miss: **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Amygdala RS Hit vs. Miss: *p = %d\n', p))
else
    fprintf(sprintf('Amygdala RS Hit vs. Miss: p = %d\n', p))
end

p = signrank(ag_fs_hit_depol, ag_fs_miss_depol);
if p < (0.05 / length(ag_fs_hit_depol))
    fprintf(sprintf('Amygdala FS Hit vs. Miss: **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Amygdala FS Hit vs. Miss: *p = %d\n', p))
else
    fprintf(sprintf('Amygdala FS Hit vs. Miss: p = %d\n', p))
end

fprintf('Amygdala RS Hit: %d +/- %d\n', nanmean(ag_rs_hit_depol), nanstd(ag_rs_hit_depol)/sqrt(sum(~isnan(ag_rs_hit_depol))));
fprintf('Amygdala RS Miss: %d +/- %d\n', nanmean(ag_rs_miss_depol), nanstd(ag_rs_miss_depol)/sqrt(sum(~isnan(ag_rs_miss_depol))));
fprintf('Amygdala FS Hit: %d +/- %d\n', nanmean(ag_fs_hit_depol), nanstd(ag_fs_hit_depol)/sqrt(sum(~isnan(ag_fs_hit_depol))));
fprintf('Amygdala FS Miss: %d +/- %d\n', nanmean(ag_fs_miss_depol), nanstd(ag_fs_miss_depol)/sqrt(sum(~isnan(ag_fs_miss_depol))));