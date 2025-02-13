addpath(genpath('./'))
addpath(genpath('~/n-CORTEx/'))
addpath(genpath('~/circstat-matlab/'))
sessionIDs 
ext_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/';

% load('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Subjects/3738-20240702/regionMap.mat')

% ftr_file = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat';
% extToFtrAP(ext_path, expert_3738_session_ids, regMap, ftr_file)

% ftr_file = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat';
% extToFtrAP(ext_path, expert_3387_session_ids, regMap, ftr_file)

% ftr_file = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase4_g0.mat';
% extToFtrAP(ext_path, expert_3738_session_ids, regMap, ftr_file)

% ftr_file = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-005mgpkg_phase--phase3_g0.mat';
% extToFtrAP(ext_path, half_dcz_3387_session_ids, regMap, ftr_file)

% ftr_file = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase3_g0.mat';
% extToFtrAP(ext_path, dcz_3387_session_ids, regMap, ftr_file)

% ftr_file = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase3_g0.mat';
% extToFtrAP(ext_path, saline_3387_session_ids, regMap, ftr_file)

% ftr_file = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase3_g0.mat';
% extToFtrAP(ext_path, dcz_3738_session_ids, regMap, ftr_file)

% ftr_file = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase3_g0.mat';
% extToFtrAP(ext_path, saline_3738_session_ids, regMap, ftr_file)

% ftr_file = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-005mgpkg_phase--phase3_g0.mat';
% extToFtrAP(ext_path, half_dcz_3738_session_ids, regMap, ftr_file)

% ftr_file = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase5_g0.mat';
% extToFtrAP(ext_path, phase5_3738_session_ids, regMap, ftr_file)

%% animal 3755 
% load('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Subjects/3755-20240828/regionMap.mat')
% ftr_file = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase5_g0.mat';
% extToFtrAP(ext_path, phase5_3755_expert_session_ids, regMap, ftr_file)

% ftr_file = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat';
% extToFtrAP(ext_path, expert_3755_session_ids, regMap, ftr_file)

% animal 1075 
load('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Subjects/1075-20241202/regionMap.mat')

ftr_file = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat';
extToFtrAP(ext_path, expert_1075_session_ids, regMap, ftr_file)