addpath(genpath('./'))
addpath(genpath('~/n-CORTEx/'))
addpath(genpath('~/circstat-matlab/'))
sessionIDs 
init_paths 

load(strcat(subject_path, '3738-20240702/regionMap.mat'))

ftr_file = strcat(ftr_path, 'AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat');
extToFtrAP(ext_path, expert_3387_session_ids, regMap, ftr_file)

ftr_file = strcat(ftr_path, 'AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase4_g0.mat');
extToFtrAP(ext_path, expert_3738_session_ids, regMap, ftr_file)

load(strcat(subject_path, '3755-20240828/regionMap.mat'))

ftr_file = strcat(ftr_path, 'AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase5_g0.mat');
extToFtrAP(ext_path, phase5_3755_expert_session_ids, regMap, ftr_file)

ftr_file = strcat(ftr_path, 'AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat');
extToFtrAP(ext_path, expert_3755_session_ids, regMap, ftr_file)

load(strcat(subject_path, '1075-20241202/regionMap.mat'))

ftr_file = strcat(ftr_path, 'AP/subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat');
extToFtrAP(ext_path, expert_1075_session_ids, regMap, ftr_file)