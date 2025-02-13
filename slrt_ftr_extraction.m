addpath(genpath('./'))
addpath(genpath('~/n-CORTEx/'))
sessionIDs 
ext_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/';

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat';
% extToFtrSLRT(ext_path, expert_3738_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat';
% extToFtrSLRT(ext_path, expert_3387_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat';
% extToFtrSLRT(ext_path, expert_3755_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat';
% extToFtrSLRT(ext_path, expert_1075_session_ids, ftr_file)

ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/new_3755_sessions.mat';
extToFtrSLRT(ext_path, new_3755_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase4_g0.mat';
% extToFtrSLRT(ext_path, distracted_3738_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-005mgpkg_phase--phase3_g0.mat';
% extToFtrSLRT(ext_path, half_dcz_3387_session_ids_slrt, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase3_g0.mat';
% extToFtrSLRT(ext_path, dcz_3387_session_ids_slrt, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase3_g0.mat';
% extToFtrSLRT(ext_path, saline_3387_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase3_g0.mat';
% extToFtrSLRT(ext_path, dcz_3738_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-005mgpkg_phase--phase3_g0.mat';
% extToFtrSLRT(ext_path, half_dcz_3738_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase3_g0.mat';
% extToFtrSLRT(ext_path, saline_3738_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10005_geno-Wt_phase--5_lowTargetProbability.mat';
% extToFtrSLRT(ext_path, lowTarget_10005_session_ids, ftr_file);

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10005_geno-Wt_phase--5_midTargetProbability.mat';
% extToFtrSLRT(ext_path, midTarget_10005_session_ids, ftr_file);

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10005_geno-Wt_phase--5_highTargetProbability.mat';
% extToFtrSLRT(ext_path, highTarget_10005_session_ids, ftr_file);

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10004_geno-Wt_phase--5_lowTargetProbability.mat';
% extToFtrSLRT(ext_path, lowTarget_10004_session_ids, ftr_file);

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10004_geno-Wt_phase--5_midTargetProbability.mat';
% extToFtrSLRT(ext_path, midTarget_10004_session_ids, ftr_file);

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10004_geno-Wt_phase--5_highTargetProbability.mat';
% extToFtrSLRT(ext_path, highTarget_10004_session_ids, ftr_file);

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10004_geno-Wt_phase--5_lowTargetProbability_pupil.mat';
% extToFtrSLRT(ext_path, lowTarget_10004_pupil_session_ids, ftr_file);

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10004_geno-Wt_phase--5_midTargetProbability_pupil.mat';
% extToFtrSLRT(ext_path, midTarget_10004_pupil_session_ids, ftr_file);

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10004_geno-Wt_phase--5_highTargetProbability_pupil.mat';
% extToFtrSLRT(ext_path, highTarget_10004_pupil_session_ids, ftr_file);

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10004_geno-Wt_phase--5_lowTargetProbability_all.mat';
% extToFtrSLRT(ext_path, horzcat(lowTarget_10004_session_ids, lowTarget_10004_pupil_session_ids), ftr_file);

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10004_geno-Wt_phase--5_midTargetProbability_all.mat';
% extToFtrSLRT(ext_path, horzcat(midTarget_10004_session_ids, midTarget_10004_pupil_session_ids), ftr_file);

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10004_geno-Wt_phase--5_highTargetProbability_all.mat';
% extToFtrSLRT(ext_path, horzcat(highTarget_10004_session_ids, highTarget_10004_pupil_session_ids), ftr_file);

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10003_geno-Wt_phase--5_lowTargetProbability.mat';
% extToFtrSLRT(ext_path, lowTarget_10003_session_ids, ftr_file);

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10003_geno-Wt_phase--5_midTargetProbability.mat';
% extToFtrSLRT(ext_path, midTarget_10003_session_ids, ftr_file);

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--10003_geno-Wt_phase--5_highTargetProbability.mat';
% extToFtrSLRT(ext_path, highTarget_10003_session_ids, ftr_file);

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase5_g0.mat';
% extToFtrSLRT(ext_path, phase5_3738_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase5_g0.mat';
% extToFtrSLRT(ext_path, phase5_3738_saline_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase5_g0.mat';
% extToFtrSLRT(ext_path, phase5_3738_dcz_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase5_g0.mat';
% extToFtrSLRT(ext_path, phase5_3755_saline_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase5_g0.mat';
% extToFtrSLRT(ext_path, phase5_3755_dcz_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase5_g1.mat';
% extToFtrSLRT(ext_path, phase5_3755_saline_session_ids2, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase5_g1.mat';
% extToFtrSLRT(ext_path, phase5_3755_dcz_session_ids2, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase5_g0.mat';
% extToFtrSLRT(ext_path, phase5_3755_expert_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase5_midTargetProbability.mat';
% extToFtrSLRT(ext_path, midTarget_3755_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase5_highTargetProbability.mat';
% extToFtrSLRT(ext_path, highTarget_3755_session_ids, ftr_file)

% ftr_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/SLRT/subj--2001-20240910_geno--Dbh-Cre_photom--R_phase--phase3_g0.mat';
% extToFtrSLRT(ext_path, expert_2001_session_ids, ftr_file)