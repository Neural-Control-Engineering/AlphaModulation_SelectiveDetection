addpath(genpath('./'))
addpath(genpath('~/circstat-matlab/'))

all_ftr_files = {'/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-005mgpkg_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-005mgpkg_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase3_g0.mat'};
signals = {'left_trigger_aligned_avg_fr_Hit', ...
    'left_trigger_aligned_avg_fr_Miss', ...
    'right_trigger_aligned_avg_fr_CR', ...
    'right_trigger_aligned_avg_fr_FA'};
left_after_signals = {'left_trigger_aligned_avg_fr_afterHit', ...
    'left_trigger_aligned_avg_fr_afterMiss', ...
    'left_trigger_aligned_avg_fr_afterCR', ...
    'left_trigger_aligned_avg_fr_afterFA'};
cell_classes = {'RS', 'FS', 'PS', 'TS'};

%% s1-striatum-amygdala sessions
% combine animals
ftr_files = all_ftr_files(1:2);
for i = 1:length(ftr_files)
    f = load(ftr_files{i});
    if i == 1
        ftrs = f.ap_ftr;
    else
        ftrs = combineTables(ftrs, f.ap_ftr);
    end
end

ctx = ftrs(startsWith(ftrs.region, 'SS'),:);
striatum_inds = strcmp(ftrs.region, 'STR') + strcmp(ftrs.region, 'CP');
striatum = ftrs(logical(striatum_inds), :);
amyg_inds = startsWith(ftrs.region, 'LA') + startsWith(ftrs.region{1}, 'BL');
amygdala = ftrs(logical(amyg_inds),:);

fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Combo/Cortex/';  
spontaneousAlphaModulation(ctx, false, fig_path)
fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Combo/Basal_Ganglia/';
spontaneousAlphaModulation(striatum, false, fig_path)
fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Combo/Amygdala/';
spontaneousAlphaModulation(amygdala, false, fig_path)

%% pfc recording sessions
f = load('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat');
ftrs = f.ap_ftr;
pfc_inds = startsWith(ftrs.region, 'DP') + startsWith(ftrs.region, 'AC') ...
    + startsWith(ftrs.region, 'PL') + startsWith(ftrs.region, 'IL') ...
    + startsWith(ftrs.region, 'OR');
pfc_inds = logical(pfc_inds);
pfc = ftrs(pfc_inds, :);

fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3755_phase3/PFC/';
spontaneousAlphaModulation(pfc, false, fig_path)
ftr_files = {'/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'};
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
pfc_inds = logical(pfc_inds);
pfc = ftrs(pfc_inds, :);

fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/PFC_Expert_Combo/PFC/';
spontaneousAlphaModulation(pfc, false, fig_path)