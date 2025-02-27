addpath(genpath('./'))
addpath(genpath('~/n-CORTEx/'))
sessionIDs;
init_paths;

% ftr_file = strcat(ftr_path, 'SLRT/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat');
% extToFtrSLRT(ext_path, expert_3738_session_ids, ftr_file)

% ftr_file = strcat(ftr_path, 'SLRT/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat');
% extToFtrSLRT(ext_path, expert_3387_session_ids, ftr_file)

% ftr_file = strcat(ftr_path, 'SLRT/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat');
% extToFtrSLRT(ext_path, expert_3755_session_ids, ftr_file)

% ftr_file = strcat(ftr_path, 'SLRT/subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat');
% extToFtrSLRT(ext_path, expert_1075_session_ids, ftr_file)

ftr_file = strcat(ftr_path, 'SLRT/subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_all.mat');
extToFtrSLRT(ext_path, all_1075_session_ids, ftr_file)