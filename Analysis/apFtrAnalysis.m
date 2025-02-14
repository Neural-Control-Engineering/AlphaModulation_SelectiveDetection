addpath(genpath('./'))
addpath(genpath('~/circstat-matlab/'))

ftr_files = {'/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
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

% fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Comparison/';
% compareApFtrs(ftr_files(1:2), fig_path, signals)

% fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Combo/';
% plotApFtrs(ftr_files(1:2), fig_path, signals)

% % 3387 expert sessions
% fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3387_expert_sessions/';
% plotApFtrs(ftr_files(1), fig_path, signals)

% % 3738 expert sessions
% fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3738_expert_sessions/';
% plotApFtrs(ftr_files(2), fig_path, signals)

% % 3387 dcz vs saline sessions
% fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3387_saline_vs_dcz/';
% compareApFtrs({ftr_files(3:4), ftr_files{5}}, fig_path, signals)

% % 3787 saline vs dcz
% fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3738_saline_vs_dcz/';
% compareApFtrs({ftr_files(end-2:end-1), ftr_files{end}}, fig_path, signals)

% % 3387 full dcz vs saline sessions
% fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3387_saline_vs_full_dcz/';
% compareApFtrs({ftr_files{3}, ftr_files{5}}, fig_path, signals)

% % 3787 saline vs full dcz
% fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3738_saline_vs_full_dcz/';
% compareApFtrs({ftr_files{end-2}, ftr_files{end}}, fig_path, signals)

% % 3387 full dcz vs saline sessions
% fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3387_saline_vs_half_dcz/';
% compareApFtrs({ftr_files{4}, ftr_files{5}}, fig_path, signals)

% % 3787 saline vs full dcz
% fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3738_saline_vs_half_dcz/';
% compareApFtrs({ftr_files{end-1}, ftr_files{end}}, fig_path, signals)

% % all saline vs dcz
% fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/saline_vs_dcz/';
% compareApFtrs({horzcat(ftr_files(3:4), ftr_files(end-2:end-1)), horzcat(ftr_files(5), ftr_files(end))}, fig_path, signals)

% % all saline vs full dcz
% fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/saline_vs_full_dcz/';
% compareApFtrs({horzcat(ftr_files(3), ftr_files(end-2)), horzcat(ftr_files(5), ftr_files(end))}, fig_path, signals)

% % all saline vs half dcz
% fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/saline_vs_half_dcz/';
% compareApFtrs({horzcat(ftr_files(3), ftr_files(end-2)), horzcat(ftr_files(5), ftr_files(end))}, fig_path, signals)

% % 3738 expert sessions
fig_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3755_phase3/';
ftr_file = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat';
plotApFtrs({ftr_file}, fig_path, signals, 'PFC')