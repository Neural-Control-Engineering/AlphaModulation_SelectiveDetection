addpath(genpath('./'))

% % pfc phase 5 
% load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase5_g0.mat
% probe_type = 'PFC';
% out_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3755_phase5/spatial_fr_maps/';
% spatialFiringRatePlots(ap_ftr, probe_type, out_path)

% % s1 phase 5 
% load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase5_g0.mat
% probe_type = 'S1';
% out_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3738_phase5/spatial_fr_maps/';
% spatialFiringRatePlots(ap_ftr, probe_type, out_path)

% % pfc phase 5 saline
% load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase5_g0.mat
% probe_type = 'PFC';
% out_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3755_phase5_Saline/spatial_fr_maps/';
% spatialFiringRatePlots(ap_ftr, probe_type, out_path)

% % pfc phase 5 dcz
% load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase5_g0.mat
% probe_type = 'PFC';
% out_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3755_phase5_DCZ/spatial_fr_maps/';
% spatialFiringRatePlots(ap_ftr, probe_type, out_path)

% 3387 phase 3 expert sessions
load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat
probe_type = 'S1';
out_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3387_expert_sessions/spatial_fr_maps/';
spatialFiringRatePlots(ap_ftr, probe_type, out_path)

% 3738 phase 3 expert sessions
load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat
probe_type = 'S1';
out_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3738_expert_sessions/spatial_fr_maps/';
spatialFiringRatePlots(ap_ftr, probe_type, out_path)

% 3387 phase 3 saline sessions
load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase3_g0.mat
probe_type = 'S1';
out_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3387_phase3_saline/spatial_fr_maps/';
spatialFiringRatePlots(ap_ftr, probe_type, out_path)

% 3738 phase 3 saline sessions
load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase3_g0.mat
probe_type = 'S1';
out_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3738_phase3_saline/spatial_fr_maps/';
spatialFiringRatePlots(ap_ftr, probe_type, out_path)

% 3387 phase 3 half dcz sessions
load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-005mgpkg_phase--phase3_g0.mat
probe_type = 'S1';
out_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3387_phase3_half_dcz/spatial_fr_maps/';
spatialFiringRatePlots(ap_ftr, probe_type, out_path)

% 3738 phase 3 half dcz sessions
load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-005mgpkg_phase--phase3_g0.mat
probe_type = 'S1';
out_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3738_phase3_half_dcz/spatial_fr_maps/';
spatialFiringRatePlots(ap_ftr, probe_type, out_path)

% 3387 phase 3 full dcz sessions
load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase3_g0.mat
probe_type = 'S1';
out_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3387_phase3_full_dcz/spatial_fr_maps/';
spatialFiringRatePlots(ap_ftr, probe_type, out_path)

% 3738 phase 3 full dcz sessions
load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase3_g0.mat
probe_type = 'S1';
out_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/3738_phase3_full_dcz/spatial_fr_maps/';
spatialFiringRatePlots(ap_ftr, probe_type, out_path)



% ftr_files = {{'~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
%     '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'}};
% for i = 1:length(ftr_files)
%     if iscell(ftr_files{i})
%         % combine animals
%         for j = 1:length(ftr_files{i})
%             f = load(ftr_files{i}{j});
%             if j == 1
%                 ftrs = f.ap_ftr;
%             else
%                 ftrs = combineTables(ftrs, f.ap_ftr);
%             end
%         end
%         expr = sprintf('ftr%i.ap_ftr = ftrs;', i);
%         eval(expr)
%     else
%         expr = sprintf('ftr%i = load(ftr_files{%i});', i, i);
%         eval(expr)
%     end
% end
% ap_ftr = ftr1.ap_ftr;
% probe_type = 'S1';
% out_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/
