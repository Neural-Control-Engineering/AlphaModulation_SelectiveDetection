addpath(genpath('./'))
addpath(genpath('~/circstat-matlab/'))

init_paths;

%% s1-striatum-amygdala sessions
% combine animals
ftr_files = {strcat(ftr_path, 'AP/subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_adjusted_sill.mat'), ...
    strcat(ftr_path, 'AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_adjusted_sill.mat')};
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

overall_p_threshold = 0.0043;
fig_path = strcat(ftr_path, 'AP/FIG/S1_Expert_Combo_Revision/Cortex/');  
spontaneousAlphaModulation(ctx, false, fig_path, overall_p_threshold)
fig_path = strcat(ftr_path, 'AP/FIG/S1_Expert_Combo_Revision/Basal_Ganglia/');
spontaneousAlphaModulation(striatum, false, fig_path, overall_p_threshold)
fig_path = strcat(ftr_path, 'AP/FIG/S1_Expert_Combo_Revision/Amygdala/');
spontaneousAlphaModulation(amygdala, false, fig_path, overall_p_threshold)

%% pfc recording sessions
ftr_files = {strcat(ftr_path, 'AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0_sill.mat'), ...
    strcat(ftr_path, 'AP/subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0_sill.mat')};
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

fig_path = strcat(ftr_path, 'AP/FIG/PFC_Expert_Combo_Revision/PFC/');
spontaneousAlphaModulation(pfc, false, fig_path, overall_p_threshold)