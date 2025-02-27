addpath(genpath('./'))
init_paths;
%% s1 
ftr_files = {strcat(ftr_path, 'LFP/date--2024-03-04_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-03-01_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-29_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-27_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-22_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g1.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-22_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-21_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-20_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-15_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat')};

s1_channel = 285;
striatum_channel = 138;
amygdala_channel = 160;

for f = 1:length(ftr_files)
    data = load(ftr_files{f});
    if f == 1
        s1_hit = data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit{1};
        s1_miss = data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Miss{1};
        s1_cr = data.lfp_session(s1_channel,:).right_trigger_baseline_spectra_CR{1};
        s1_fa = data.lfp_session(s1_channel,:).right_trigger_baseline_spectra_FA{1};
    else
        s1_hit = [s1_hit; data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit{1}];
        s1_miss = [s1_miss; data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Miss{1}];
        s1_cr = [s1_cr; data.lfp_session(s1_channel,:).right_trigger_baseline_spectra_CR{1}];
        s1_fa = [s1_fa; data.lfp_session(s1_channel,:).right_trigger_baseline_spectra_FA{1}];
    end
    if f == 1
        striatum_hit = data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Hit{1};
        striatum_miss = data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Miss{1};
        striatum_cr = data.lfp_session(striatum_channel,:).right_trigger_baseline_spectra_CR{1};
        striatum_fa = data.lfp_session(striatum_channel,:).right_trigger_baseline_spectra_FA{1};
    else
        striatum_hit = [striatum_hit; data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Hit{1}];
        striatum_miss = [striatum_miss; data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Miss{1}];
        striatum_cr = [striatum_cr; data.lfp_session(striatum_channel,:).right_trigger_baseline_spectra_CR{1}];
        striatum_fa = [striatum_fa; data.lfp_session(striatum_channel,:).right_trigger_baseline_spectra_FA{1}];
    end

    if f == 1
        amygdala_hit = data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Hit{1};
        amygdala_miss = data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Miss{1};
        amygdala_cr = data.lfp_session(amygdala_channel,:).right_trigger_baseline_spectra_CR{1};
        amygdala_fa = data.lfp_session(amygdala_channel,:).right_trigger_baseline_spectra_FA{1};
    else
        amygdala_hit = [amygdala_hit; data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Hit{1}];
        amygdala_miss = [amygdala_miss; data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Miss{1}];
        amygdala_cr = [amygdala_cr; data.lfp_session(amygdala_channel,:).right_trigger_baseline_spectra_CR{1}];
        amygdala_fa = [amygdala_fa; data.lfp_session(amygdala_channel,:).right_trigger_baseline_spectra_FA{1}];
    end
end

ftr_files = {strcat(ftr_path, 'LFP/date--2024-07-17_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-07-16_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-07-15_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-07-13_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-07-12_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat')};

for f = 1:length(ftr_files)
    data = load(ftr_files{f});
    s1_hit = [s1_hit; data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit{1}];
    s1_miss = [s1_miss; data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Miss{1}];
    s1_cr = [s1_cr; data.lfp_session(s1_channel,:).right_trigger_baseline_spectra_CR{1}];
    s1_fa = [s1_fa; data.lfp_session(s1_channel,:).right_trigger_baseline_spectra_FA{1}];
    striatum_hit = [striatum_hit; data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Hit{1}];
    striatum_miss = [striatum_miss; data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Miss{1}];
    striatum_cr = [striatum_cr; data.lfp_session(striatum_channel,:).right_trigger_baseline_spectra_CR{1}];
    striatum_fa = [striatum_fa; data.lfp_session(striatum_channel,:).right_trigger_baseline_spectra_FA{1}];
    amygdala_hit = [amygdala_hit; data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Hit{1}];
    amygdala_miss = [amygdala_miss; data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Miss{1}];
    amygdala_cr = [amygdala_cr; data.lfp_session(amygdala_channel,:).right_trigger_baseline_spectra_CR{1}];
    amygdala_fa = [amygdala_fa; data.lfp_session(amygdala_channel,:).right_trigger_baseline_spectra_FA{1}];
end

%% pfc 
ftr_files = {strcat(ftr_path, 'LFP/date--2024-09-07_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-09-06_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-09-05_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-09-04_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-09-03_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-09-02_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat')};

pfc_channel = 300;

for f = 1:length(ftr_files)
    data = load(ftr_files{f});
    if f == 1
        pfc_hit = data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Hit{1};
        pfc_miss = data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Miss{1};
        pfc_cr = data.lfp_session(pfc_channel,:).right_trigger_baseline_spectra_CR{1};
        pfc_fa = data.lfp_session(pfc_channel,:).right_trigger_baseline_spectra_FA{1};
    else
        pfc_hit = [pfc_hit; data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Hit{1}];
        pfc_miss = [pfc_miss; data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Miss{1}];
        pfc_cr = [pfc_cr; data.lfp_session(pfc_channel,:).right_trigger_baseline_spectra_CR{1}];
        pfc_fa = [pfc_fa; data.lfp_session(pfc_channel,:).right_trigger_baseline_spectra_FA{1}];
    end
end

ftr_files = {strcat(ftr_path, 'LFP/date--2024-12-20_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-19_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-18_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-17_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-16_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g1.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-16_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-15_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat')};

pfc_channel = 180;

for f = 1:length(ftr_files)
    data = load(ftr_files{f});
    pfc_hit = [pfc_hit; data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Hit{1}];
    try
        pfc_miss = [pfc_miss; data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Miss{1}];
    end
    pfc_cr = [pfc_cr; data.lfp_session(pfc_channel,:).right_trigger_baseline_spectra_CR{1}];
    pfc_fa = [pfc_fa; data.lfp_session(pfc_channel,:).right_trigger_baseline_spectra_FA{1}];
end

fig = figure('Position', [1194 982 779 659]); 
tl = tiledlayout(4,4);
axs(1) = nexttile;
semshade(log10(s1_hit), 0.3, 'k', 'k', data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit_f{1}); 
xlim([0,30])
ylim([-11,-9])
yticks([-11,-9])
xticklabels({})
title('Hit', 'FontSize', 14, 'FontWeight', 'normal')
ylabel('S1', 'FontSize', 14)
axs(2) = nexttile;
semshade(log10(s1_miss), 0.3, 'k', 'k', data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit_f{1});
xlim([0,30])
ylim([-11,-9])
yticks([-11,-9])
xticklabels({})
yticklabels({})
title('Miss', 'FontSize', 14, 'FontWeight', 'normal')
axs(3) = nexttile;
semshade(log10(s1_cr), 0.3, 'k', 'k', data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit_f{1});  
xlim([0,30])
ylim([-11,-9])
yticks([-11,-9])
xticklabels({})
yticklabels({})
title('Correct Rejection', 'FontSize', 14, 'FontWeight', 'normal')
axs(4) = nexttile;
semshade(log10(s1_fa), 0.3, 'k', 'k', data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit_f{1});
ylim([-11,-9])
yticks([-11,-9])
xlim([0,30])
xticklabels({})
yticklabels({})
title('False Alarm', 'FontSize', 14, 'FontWeight', 'normal')

axs(5) = nexttile;
semshade(log10(pfc_hit), 0.3, 'k', 'k', data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Hit_f{1}); 
xlim([0,30])
ylim([-11,-8])
yticks([-11,-8])
xticklabels({})
ylabel('PFC', 'FontSize', 14)
axs(6) = nexttile;
semshade(log10(pfc_miss), 0.3, 'k', 'k', data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Hit_f{1});
xlim([0,30])
ylim([-11,-8])
yticks([-11,-8])
xticklabels({})
yticklabels({})
axs(7) = nexttile;
semshade(log10(pfc_cr), 0.3, 'k', 'k', data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Hit_f{1});  
xlim([0,30])
ylim([-11,-8])
yticks([-11,-8])
xticklabels({})
yticklabels({})
axs(8) = nexttile;
semshade(log10(pfc_fa), 0.3, 'k', 'k', data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Hit_f{1});
xlim([0,30])
ylim([-11,-8])
yticks([-11,-8])
xticklabels({})
yticklabels({})

axs(9) = nexttile;
semshade(log10(striatum_hit), 0.3, 'k', 'k', data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Hit_f{1}); 
xlim([0,30])
ylim([-11,-9])
yticks([-11,-9])
xticklabels({})
ylabel('Striatum', 'FontSize', 14)
axs(10) = nexttile;
semshade(log10(striatum_miss), 0.3, 'k', 'k', data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Hit_f{1});
xlim([0,30])
ylim([-11,-9])
yticks([-11,-9])
xticklabels({})
yticklabels({})
axs(11) = nexttile;
semshade(log10(striatum_cr), 0.3, 'k', 'k', data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Hit_f{1});  
xlim([0,30])
ylim([-11,-9])
yticks([-11,-9])
xticklabels({})
yticklabels({})
axs(12) = nexttile;
semshade(log10(striatum_fa), 0.3, 'k', 'k', data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Hit_f{1});
ylim([-11,-9])
yticks([-11,-9])
xlim([0,30])
xticklabels({})
yticklabels({})

axs(13) = nexttile;
semshade(log10(amygdala_hit), 0.3, 'k', 'k', data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Hit_f{1}); 
xlim([0,30])
ylim([-11,-9])
yticks([-11,-9])
ylabel('Amygdala', 'FontSize', 14)
axs(14) = nexttile;
semshade(log10(amygdala_miss), 0.3, 'k', 'k', data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Hit_f{1});
xlim([0,30])
ylim([-11,-9])
yticks([-11,-9])
yticklabels({})
axs(15) = nexttile;
semshade(log10(amygdala_cr), 0.3, 'k', 'k', data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Hit_f{1});  
xlim([0,30])
ylim([-11,-9])
yticks([-11,-9])
yticklabels({})
axs(16) = nexttile;
semshade(log10(amygdala_fa), 0.3, 'k', 'k', data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Hit_f{1});
ylim([-11,-9])
yticks([-11,-9])
xlim([0,30])
yticklabels({})
xlabel(tl, 'Frequency (Hz)', 'FontSize', 14)
ylabel(tl, 'log LFP power', 'FontSize', 14)

out_path = false; 
mkdir('./Figures/')
if out_path
    saveas(fig, 'Figures/lfp_power_by_outcome.fig')
    saveas(fig, 'Figures/lfp_power_by_outcome.svg')
end

args = struct();
args.peakWidth_min = 2;
args.peakWidth_max = 8;  
args.numPeaks_max = 8;
args.peakHeight_min = 0.;     
args.peakThreshold = 2;
args.chanRange_start = 1;
args.chanRange_end = 384;

%% s1 
f = data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit_f{1};
mat = s1_hit;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_hit = spectralParameterizationV0(DF_chg, args);
pparams_hit = [];
for i = 1:size(DF_specs_hit,1)
    if size(DF_specs_hit(i,:).periodic_params{1},1) > 1
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}(end,:)];
    else
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}];
    end
end

mat = s1_miss;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_miss = spectralParameterizationV0(DF_chg, args);
pparams_miss = [];
for i = 1:size(DF_specs_miss,1)
    if size(DF_specs_miss(i,:).periodic_params{1},1) > 1
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}(end,:)];
    else
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}];
    end
end

mat = s1_cr;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_cr = spectralParameterizationV0(DF_chg, args);
pparams_cr = [];
for i = 1:size(DF_specs_cr,1)
    if size(DF_specs_cr(i,:).periodic_params{1},1) > 1
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}(end,:)];
    else
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}];
    end
end

mat = s1_fa;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_fa = spectralParameterizationV0(DF_chg, args);
pparams_fa = [];
for i = 1:size(DF_specs_fa,1)
    if size(DF_specs_fa(i,:).periodic_params{1},1) > 1
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}(end,:)];
    else
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}];
    end
end

% fprintf('S1 params\n')
% mat = [pparams_hit(:,1), pparams_miss(:,1), pparams_cr(:,1), pparams_fa(:,1)];
% anova1(mat)

% mat = [pparams_hit(:,2), pparams_miss(:,2), pparams_cr(:,2), pparams_fa(:,2)];
% anova1(mat)

% mat = [pparams_hit(:,3), pparams_miss(:,3), pparams_cr(:,3), pparams_fa(:,3)];
% anova1(mat)

figure('Position', [1461 983 661 659]);
tl = tiledlayout(4,3);
% axs(1,1) = nexttile;
% avg = [mean(DF_specs_hit.aperiodic_params(:,1)), ...
%     mean(DF_specs_miss.aperiodic_params(:,1)), ...
%     mean(DF_specs_cr.aperiodic_params(:,1)), ...
%     mean(DF_specs_fa.aperiodic_params(:,1))];
% err = [std(DF_specs_hit.aperiodic_params(:,1)) / sqrt(size(DF_specs_hit,1)), ...
%     std(DF_specs_miss.aperiodic_params(:,1)) / sqrt(size(DF_specs_miss,1)), ...
%     std(DF_specs_cr.aperiodic_params(:,1)) / sqrt(size(DF_specs_cr,1)), ...
%     std(DF_specs_fa.aperiodic_params(:,1)) / sqrt(size(DF_specs_fa,1))];
% hold on 
% bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
% errorbar(1:4, avg, err, 'k.')

% axs(1,2) = nexttile;
% avg = [mean(DF_specs_hit.aperiodic_params(:,2)), ...
%     mean(DF_specs_miss.aperiodic_params(:,2)), ...
%     mean(DF_specs_cr.aperiodic_params(:,2)), ...
%     mean(DF_specs_fa.aperiodic_params(:,2))];
% err = [std(DF_specs_hit.aperiodic_params(:,2)) / sqrt(size(DF_specs_hit,1)), ...
%     std(DF_specs_miss.aperiodic_params(:,2)) / sqrt(size(DF_specs_miss,1)), ...
%     std(DF_specs_cr.aperiodic_params(:,2)) / sqrt(size(DF_specs_cr,1)), ...
%     std(DF_specs_fa.aperiodic_params(:,2)) / sqrt(size(DF_specs_fa,1))];
% hold on 
% bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
% errorbar(1:4, avg, err, 'k.')

axs(1,1) = nexttile;
avg = [mean(pparams_hit(:,1)), ...
    mean(pparams_miss(:,1)), ...
    mean(pparams_cr(:,1)), ...
    mean(pparams_fa(:,1))];
err = [std(pparams_hit(:,1)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,1)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,1)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,1)) / sqrt(size(pparams_fa,1))];
hold on 
bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
errorbar(1:4, avg, err, 'k.')
xticks([1,2,3,4])
xticklabels({'','','',''})
ylim([0,20])
yticks([0,20])
ylabel('Peak Frequency (Hz)')

axs(1,2) = nexttile;
avg = [mean(pparams_hit(:,2)), ...
    mean(pparams_miss(:,2)), ...
    mean(pparams_cr(:,2)), ...
    mean(pparams_fa(:,2))];
err = [std(pparams_hit(:,2)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,2)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,2)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,2)) / sqrt(size(pparams_fa,1))];
hold on 
bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
errorbar(1:4, avg, err, 'k.')
xticks([1,2,3,4])
xticklabels({'','','',''})
ylim([0,0.8])
yticks([0,0.8])
ylabel('Relative Power (a.u.)')

axs(1,3) = nexttile;
avg = [mean(pparams_hit(:,3)), ...
    mean(pparams_miss(:,3)), ...
    mean(pparams_cr(:,3)), ...
    mean(pparams_fa(:,3))];
err = [std(pparams_hit(:,3)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,3)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,3)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,3)) / sqrt(size(pparams_fa,1))];
hold on 
bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
errorbar(1:4, avg, err, 'k.')
xticks([1,2,3,4])
xticklabels({'','','',''})
ylim([0,8])
yticks([0,8])
ylabel('Bandwidth (Hz)')

mat = pfc_hit;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_hit = spectralParameterizationV0(DF_chg, args);
pparams_hit = [];
for i = 1:size(DF_specs_hit,1)
    if size(DF_specs_hit(i,:).periodic_params{1},1) > 1
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}(end,:)];
    else
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}];
    end
end

mat = pfc_miss;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_miss = spectralParameterizationV0(DF_chg, args);
pparams_miss = [];
for i = 1:size(DF_specs_miss,1)
    if size(DF_specs_miss(i,:).periodic_params{1},1) > 1
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}(end,:)];
    else
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}];
    end
end

mat = pfc_cr;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_cr = spectralParameterizationV0(DF_chg, args);
pparams_cr = [];
for i = 1:size(DF_specs_cr,1)
    if size(DF_specs_cr(i,:).periodic_params{1},1) > 1
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}(end,:)];
    else
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}];
    end
end

mat = pfc_fa;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_fa = spectralParameterizationV0(DF_chg, args);
pparams_fa = [];
for i = 1:size(DF_specs_fa,1)
    if size(DF_specs_fa(i,:).periodic_params{1},1) > 1
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}(end,:)];
    else
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}];
    end
end

% fprintf('PFC params\n')

% mat = nan(13,4);
% mat(:,1) = pparams_hit(:,1);
% mat(1:12,2) = pparams_miss(:,1);
% mat(:,3) = pparams_cr(:,1);
% mat(:,4) = pparams_fa(:,1);
% anova1(mat)

% mat = nan(13,4);
% mat(:,1) = pparams_hit(:,2);
% mat(1:12,2) = pparams_miss(:,2);
% mat(:,3) = pparams_cr(:,2);
% mat(:,4) = pparams_fa(:,2);
% anova1(mat)

% mat = nan(13,4);
% mat(:,1) = pparams_hit(:,3);
% mat(1:12,2) = pparams_miss(:,3);
% mat(:,3) = pparams_cr(:,3);
% mat(:,4) = pparams_fa(:,3);
% anova1(mat)

% axs(2,1) = nexttile;
% avg = [mean(DF_specs_hit.aperiodic_params(:,1)), ...
%     mean(DF_specs_miss.aperiodic_params(:,1)), ...
%     mean(DF_specs_cr.aperiodic_params(:,1)), ...
%     mean(DF_specs_fa.aperiodic_params(:,1))];
% err = [std(DF_specs_hit.aperiodic_params(:,1)) / sqrt(size(DF_specs_hit,1)), ...
%     std(DF_specs_miss.aperiodic_params(:,1)) / sqrt(size(DF_specs_miss,1)), ...
%     std(DF_specs_cr.aperiodic_params(:,1)) / sqrt(size(DF_specs_cr,1)), ...
%     std(DF_specs_fa.aperiodic_params(:,1)) / sqrt(size(DF_specs_fa,1))];
% hold on 
% bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
% errorbar(1:4, avg, err, 'k.')

% axs(2,2) = nexttile;
% avg = [mean(DF_specs_hit.aperiodic_params(:,2)), ...
%     mean(DF_specs_miss.aperiodic_params(:,2)), ...
%     mean(DF_specs_cr.aperiodic_params(:,2)), ...
%     mean(DF_specs_fa.aperiodic_params(:,2))];
% err = [std(DF_specs_hit.aperiodic_params(:,2)) / sqrt(size(DF_specs_hit,1)), ...
%     std(DF_specs_miss.aperiodic_params(:,2)) / sqrt(size(DF_specs_miss,1)), ...
%     std(DF_specs_cr.aperiodic_params(:,2)) / sqrt(size(DF_specs_cr,1)), ...
%     std(DF_specs_fa.aperiodic_params(:,2)) / sqrt(size(DF_specs_fa,1))];
% hold on 
% bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
% errorbar(1:4, avg, err, 'k.')

axs(2,1) = nexttile;
avg = [mean(pparams_hit(:,1)), ...
    mean(pparams_miss(:,1)), ...
    mean(pparams_cr(:,1)), ...
    mean(pparams_fa(:,1))];
err = [std(pparams_hit(:,1)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,1)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,1)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,1)) / sqrt(size(pparams_fa,1))];
hold on 
bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
errorbar(1:4, avg, err, 'k.')
xticks([1,2,3,4])
xticklabels({'','','',''})
ylim([0,20])
yticks([0,20])
ylabel('Peak Frequency (Hz)')

axs(2,2) = nexttile;
avg = [mean(pparams_hit(:,2)), ...
    mean(pparams_miss(:,2)), ...
    mean(pparams_cr(:,2)), ...
    mean(pparams_fa(:,2))];
err = [std(pparams_hit(:,2)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,2)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,2)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,2)) / sqrt(size(pparams_fa,1))];
hold on 
bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
errorbar(1:4, avg, err, 'k.')
xticks([1,2,3,4])
xticklabels({'','','',''})
ylim([0,0.8])
yticks([0,0.8])
ylabel('Relative Power (a.u.)')


axs(2,3) = nexttile;
avg = [mean(pparams_hit(:,3)), ...
    mean(pparams_miss(:,3)), ...
    mean(pparams_cr(:,3)), ...
    mean(pparams_fa(:,3))];
err = [std(pparams_hit(:,3)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,3)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,3)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,3)) / sqrt(size(pparams_fa,1))];
hold on 
bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
errorbar(1:4, avg, err, 'k.')
xticks([1,2,3,4])
xticklabels({'','','',''})
ylim([0,8])
yticks([0,8])
ylabel('Bandwidth (Hz)')

mat = striatum_hit;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_hit = spectralParameterizationV0(DF_chg, args);
pparams_hit = [];
for i = 1:size(DF_specs_hit,1)
    if size(DF_specs_hit(i,:).periodic_params{1},1) > 1
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}(end,:)];
    else
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}];
    end
end

mat = striatum_miss;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_miss = spectralParameterizationV0(DF_chg, args);
pparams_miss = [];
for i = 1:size(DF_specs_miss,1)
    if size(DF_specs_miss(i,:).periodic_params{1},1) > 1
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}(end,:)];
    else
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}];
    end
end

mat = striatum_cr;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_cr = spectralParameterizationV0(DF_chg, args);
pparams_cr = [];
for i = 1:size(DF_specs_cr,1)
    if size(DF_specs_cr(i,:).periodic_params{1},1) > 1
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}(end,:)];
    else
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}];
    end
end

mat = striatum_fa;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_fa = spectralParameterizationV0(DF_chg, args);
pparams_fa = [];
for i = 1:size(DF_specs_fa,1)
    if size(DF_specs_fa(i,:).periodic_params{1},1) > 1
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}(end,:)];
    else
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}];
    end
end

% fprintf('Striatum params\n')

% mat = [pparams_hit(:,1), pparams_miss(:,1), pparams_cr(:,1), pparams_fa(:,1)];
% anova1(mat)

% mat = [pparams_hit(:,2), pparams_miss(:,2), pparams_cr(:,2), pparams_fa(:,2)];
% anova1(mat)

% mat = [pparams_hit(:,3), pparams_miss(:,3), pparams_cr(:,3), pparams_fa(:,3)];
% anova1(mat)

% axs(3,1) = nexttile;
% avg = [mean(DF_specs_hit.aperiodic_params(:,1)), ...
%     mean(DF_specs_miss.aperiodic_params(:,1)), ...
%     mean(DF_specs_cr.aperiodic_params(:,1)), ...
%     mean(DF_specs_fa.aperiodic_params(:,1))];
% err = [std(DF_specs_hit.aperiodic_params(:,1)) / sqrt(size(DF_specs_hit,1)), ...
%     std(DF_specs_miss.aperiodic_params(:,1)) / sqrt(size(DF_specs_miss,1)), ...
%     std(DF_specs_cr.aperiodic_params(:,1)) / sqrt(size(DF_specs_cr,1)), ...
%     std(DF_specs_fa.aperiodic_params(:,1)) / sqrt(size(DF_specs_fa,1))];
% hold on 
% bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
% errorbar(1:4, avg, err, 'k.')

% axs(3,2) = nexttile;
% avg = [mean(DF_specs_hit.aperiodic_params(:,2)), ...
%     mean(DF_specs_miss.aperiodic_params(:,2)), ...
%     mean(DF_specs_cr.aperiodic_params(:,2)), ...
%     mean(DF_specs_fa.aperiodic_params(:,2))];
% err = [std(DF_specs_hit.aperiodic_params(:,2)) / sqrt(size(DF_specs_hit,1)), ...
%     std(DF_specs_miss.aperiodic_params(:,2)) / sqrt(size(DF_specs_miss,1)), ...
%     std(DF_specs_cr.aperiodic_params(:,2)) / sqrt(size(DF_specs_cr,1)), ...
%     std(DF_specs_fa.aperiodic_params(:,2)) / sqrt(size(DF_specs_fa,1))];
% hold on 
% bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
% errorbar(1:4, avg, err, 'k.')

axs(3,1) = nexttile;
avg = [mean(pparams_hit(:,1)), ...
    mean(pparams_miss(:,1)), ...
    mean(pparams_cr(:,1)), ...
    mean(pparams_fa(:,1))];
err = [std(pparams_hit(:,1)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,1)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,1)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,1)) / sqrt(size(pparams_fa,1))];
hold on 
bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
errorbar(1:4, avg, err, 'k.')
xticks([1,2,3,4])
xticklabels({'','','',''})
ylim([0,20])
yticks([0,20])
ylabel('Peak Frequency (Hz)')

axs(3,2) = nexttile;
avg = [mean(pparams_hit(:,2)), ...
    mean(pparams_miss(:,2)), ...
    mean(pparams_cr(:,2)), ...
    mean(pparams_fa(:,2))];
err = [std(pparams_hit(:,2)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,2)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,2)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,2)) / sqrt(size(pparams_fa,1))];
hold on 
bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
errorbar(1:4, avg, err, 'k.')
xticks([1,2,3,4])
xticklabels({'','','',''})
ylim([0,0.8])
yticks([0,0.8])
ylabel('Relative Power (a.u.)')

axs(3,3) = nexttile;
avg = [mean(pparams_hit(:,3)), ...
    mean(pparams_miss(:,3)), ...
    mean(pparams_cr(:,3)), ...
    mean(pparams_fa(:,3))];
err = [std(pparams_hit(:,3)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,3)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,3)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,3)) / sqrt(size(pparams_fa,1))];
hold on 
bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
errorbar(1:4, avg, err, 'k.')
xticks([1,2,3,4])
xticklabels({'','','',''})
ylim([0,8])
yticks([0,8])
ylabel('Bandwidth (Hz)')

mat = amygdala_hit;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_hit = spectralParameterizationV0(DF_chg, args);
pparams_hit = [];
for i = 1:size(DF_specs_hit,1)
    if size(DF_specs_hit(i,:).periodic_params{1},1) > 1
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}(end,:)];
    else
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}];
    end
end

mat = amygdala_miss;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_miss = spectralParameterizationV0(DF_chg, args);
pparams_miss = [];
for i = 1:size(DF_specs_miss,1)
    if size(DF_specs_miss(i,:).periodic_params{1},1) > 1
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}(end,:)];
    else
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}];
    end
end

mat = amygdala_cr;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_cr = spectralParameterizationV0(DF_chg, args);
pparams_cr = [];
for i = 1:size(DF_specs_cr,1)
    if size(DF_specs_cr(i,:).periodic_params{1},1) > 1
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}(end,:)];
    else
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}];
    end
end

mat = amygdala_fa;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_fa = spectralParameterizationV0(DF_chg, args);
pparams_fa = [];
for i = 1:size(DF_specs_fa,1)
    if size(DF_specs_fa(i,:).periodic_params{1},1) > 1
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}(end,:)];
    else
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}];
    end
end

% fprintf('Amygdala params\n')

% mat = [pparams_hit(:,1), pparams_miss(:,1), pparams_cr(:,1), pparams_fa(:,1)];
% anova1(mat)

% mat = [pparams_hit(:,2), pparams_miss(:,2), pparams_cr(:,2), pparams_fa(:,2)];
% anova1(mat)

% mat = [pparams_hit(:,3), pparams_miss(:,3), pparams_cr(:,3), pparams_fa(:,3)];
% anova1(mat)

% axs(4,1) = nexttile;
% avg = [mean(DF_specs_hit.aperiodic_params(:,1)), ...
%     mean(DF_specs_miss.aperiodic_params(:,1)), ...
%     mean(DF_specs_cr.aperiodic_params(:,1)), ...
%     mean(DF_specs_fa.aperiodic_params(:,1))];
% err = [std(DF_specs_hit.aperiodic_params(:,1)) / sqrt(size(DF_specs_hit,1)), ...
%     std(DF_specs_miss.aperiodic_params(:,1)) / sqrt(size(DF_specs_miss,1)), ...
%     std(DF_specs_cr.aperiodic_params(:,1)) / sqrt(size(DF_specs_cr,1)), ...
%     std(DF_specs_fa.aperiodic_params(:,1)) / sqrt(size(DF_specs_fa,1))];
% hold on 
% bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
% errorbar(1:4, avg, err, 'k.')

% axs(4,2) = nexttile;
% avg = [mean(DF_specs_hit.aperiodic_params(:,2)), ...
%     mean(DF_specs_miss.aperiodic_params(:,2)), ...
%     mean(DF_specs_cr.aperiodic_params(:,2)), ...
%     mean(DF_specs_fa.aperiodic_params(:,2))];
% err = [std(DF_specs_hit.aperiodic_params(:,2)) / sqrt(size(DF_specs_hit,1)), ...
%     std(DF_specs_miss.aperiodic_params(:,2)) / sqrt(size(DF_specs_miss,1)), ...
%     std(DF_specs_cr.aperiodic_params(:,2)) / sqrt(size(DF_specs_cr,1)), ...
%     std(DF_specs_fa.aperiodic_params(:,2)) / sqrt(size(DF_specs_fa,1))];
% hold on 
% bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
% errorbar(1:4, avg, err, 'k.')

axs(4,1) = nexttile;
avg = [mean(pparams_hit(:,1)), ...
    mean(pparams_miss(:,1)), ...
    mean(pparams_cr(:,1)), ...
    mean(pparams_fa(:,1))];
err = [std(pparams_hit(:,1)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,1)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,1)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,1)) / sqrt(size(pparams_fa,1))];
hold on 
bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
errorbar(1:4, avg, err, 'k.')
xticks([1,2,3,4])
xticklabels({'Hit','Miss','CR','FA'})
ylim([0,20])
yticks([0,20])
ylabel('Peak Frequency (Hz)')

axs(4,2) = nexttile;
avg = [mean(pparams_hit(:,2)), ...
    mean(pparams_miss(:,2)), ...
    mean(pparams_cr(:,2)), ...
    mean(pparams_fa(:,2))];
err = [std(pparams_hit(:,2)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,2)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,2)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,2)) / sqrt(size(pparams_fa,1))];
hold on 
bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
errorbar(1:4, avg, err, 'k.')
xticks([1,2,3,4])
xticklabels({'Hit','Miss','CR','FA'})
ylim([0,0.8])
yticks([0,0.8])
ylabel('Relative Power (a.u.)')

axs(4,3) = nexttile;
avg = [mean(pparams_hit(:,3)), ...
    mean(pparams_miss(:,3)), ...
    mean(pparams_cr(:,3)), ...
    mean(pparams_fa(:,3))];
err = [std(pparams_hit(:,3)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,3)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,3)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,3)) / sqrt(size(pparams_fa,1))];
hold on 
bar(1:4, avg, 'EdgeColor', [0.5, 0.5, 0.5], 'FaceColor', [0.5, 0.5,0.5])
errorbar(1:4, avg, err, 'k.')
xticks([1,2,3,4])
xticklabels({'Hit','Miss','CR','FA'})
ylim([0,8])
yticks([0,8])
ylabel('Bandwidth (Hz)')
