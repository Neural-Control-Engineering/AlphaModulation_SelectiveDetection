addpath(genpath('./'))

%% s1 
ftr_files = {'/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-03-04_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-03-01_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-02-29_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-02-27_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-02-22_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g1.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-02-22_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-02-21_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-02-20_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-02-15_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'};

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

ftr_files = {'/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-07-17_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-07-16_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-07-15_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-07-13_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-07-12_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'};

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
ftr_files = {'/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-09-07_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-09-06_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-09-05_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-09-04_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-09-03_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-09-02_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'};

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

ftr_files = {'/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-12-20_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-12-19_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-12-18_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-12-17_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-12-16_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g1.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-12-16_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/LFP/date--2024-12-15_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'};

pfc_channel = 180 

for f = 1:length(ftr_files)
    data = load(ftr_files{f});
    pfc_hit = [pfc_hit; data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Hit{1}];
    try
        pfc_miss = [pfc_miss; data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Miss{1}];
    end
    pfc_cr = [pfc_cr; data.lfp_session(pfc_channel,:).right_trigger_baseline_spectra_CR{1}];
    pfc_fa = [pfc_fa; data.lfp_session(pfc_channel,:).right_trigger_baseline_spectra_FA{1}];
end

fig = figure(); 
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
if out_path
    saveas(fig, 'Figures/lfp_power_by_outcome.fig')
    saveas(fig, 'Figures/lfp_power_by_outcome.svg')
end