addpath(genpath('./'))
ftr_files = {'~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase3_g0.mat', ...
    '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-005mgpkg_phase--phase3_g0.mat', ...
    '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase3_g0.mat', ...
    '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase3_g0.mat', ...
    '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-005mgpkg_phase--phase3_g0.mat', ...
    '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase3_g0.mat'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% original version of the task 

% expert comparison
% fig_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/FIG/Expert_Comparison/';
% compareSlrtFtrs(ftr_files(1:2), false, fig_path)

% % combination of expert sessions
% fig_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/FIG/Expert_Combo/';
% plotSlrtFtrs(ftr_files(1:2), false, fig_path)

% % 3387 expert sessions
% fig_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/FIG/3387_expert_sessions/';
% plotSlrtFtrs(ftr_files(1), false, fig_path)

% % 3738 expert sessions
% fig_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/FIG/3738_expert_sessions/';
% plotSlrtFtrs(ftr_files(2), false, fig_path)

% % 3387 saline vs dcz
% fig_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/FIG/3387_saline_vs_dcz/';
% compareSlrtFtrs({ftr_files(3:4), ftr_files{5}}, false, fig_path)

% % 3787 saline vs dcz
% fig_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/FIG/3738_saline_vs_dcz/';
% compareSlrtFtrs({ftr_files(end-2:end-1), ftr_files{end}}, false, fig_path)

% % 3387 saline vs full dcz
% fig_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/FIG/3387_saline_vs_full_dcz/';
% compareSlrtFtrs({ftr_files{3}, ftr_files{5}}, false, fig_path)

% % 3787 saline vs full dcz
% fig_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/FIG/3738_saline_vs_full_dcz/';
% compareSlrtFtrs({ftr_files{end-2}, ftr_files{end}}, false, fig_path)

% % 3387 saline vs full dcz
% fig_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/FIG/3387_saline_vs_half_dcz/';
% compareSlrtFtrs({ftr_files{4}, ftr_files{5}}, false, fig_path)

% % 3787 saline vs full dcz
% fig_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/FIG/3738_saline_vs_half_dcz/';
% compareSlrtFtrs({ftr_files{end-1}, ftr_files{end}}, false, fig_path)

% % all saline vs dcz
% fig_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/FIG/saline_vs_dcz/';
% compareSlrtFtrs({horzcat(ftr_files(3:4), ftr_files(end-2:end-1)), horzcat(ftr_files(5), ftr_files(end))}, false, fig_path)

% % all saline vs full dcz
% fig_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/FIG/saline_vs_full_dcz/';
% compareSlrtFtrs({horzcat(ftr_files(3), ftr_files(end-2)), horzcat(ftr_files(5), ftr_files(end))}, false, fig_path)

% all saline vs half dcz
% fig_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/FIG/saline_vs_half_dcz/';
% compareSlrtFtrs({horzcat(ftr_files(4), ftr_files(end-1)), horzcat(ftr_files(5), ftr_files(end))}, true, fig_path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% new version of the task 
%% just the low go probability expert sessions 
ftr_files = {'~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase5_g0.mat', ...
    '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase5_g0.mat', ...
    '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10004_geno-Wt_phase--5_lowTargetProbability.mat', ...
    '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10005_geno-Wt_phase--5_lowTargetProbability.mat'};
plotSlrtFtrs(ftr_files, true, false)

%% saline vs dcz 
ftr_files = {{'~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase5_g0.mat'}, ...
    {'~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase5_g0.mat'}};
compareSlrtFtrs(ftr_files, true, false)

% 10005 low vs high probability 
% ftr_files = {'~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10005_geno-Wt_phase--5_midTargetProbability.mat', ...
%     '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10005_geno-Wt_phase--5_lowTargetProbability.mat'};
% fig_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/FIG/saline_vs_half_dcz/';
% compareSlrtFtrs(ftr_files, true, false)