addpath(genpath('./'))
addpath(genpath('~/circstat-matlab/'))

init_paths

%% s1-striatum-amygdala sessions
% combine animals
all_ftr_files = {strcat(ftr_path, 'AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat')};
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

fig_path = strcat(ftr_path, 'AP/FIG/Expert_Combo/Cortex/');  
spontaneousAlphaModulation(ctx, false, fig_path)
fig_path = strcat(ftr_path, 'AP/FIG/Expert_Combo/Basal_Ganglia/');
spontaneousAlphaModulation(striatum, false, fig_path)
fig_path = strcat(ftr_path, 'AP/FIG/Expert_Combo/Amygdala/');
spontaneousAlphaModulation(amygdala, false, fig_path)

%% pfc recording sessions
f = load(strcat(ftr_path, 'AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'));
ftrs = f.ap_ftr;
pfc_inds = startsWith(ftrs.region, 'DP') + startsWith(ftrs.region, 'AC') ...
    + startsWith(ftrs.region, 'PL') + startsWith(ftrs.region, 'IL') ...
    + startsWith(ftrs.region, 'OR');
pfc_inds = logical(pfc_inds);
pfc = ftrs(pfc_inds, :);

fig_path = strcat(ftr_path, 'AP/FIG/3755_phase3/PFC/');
spontaneousAlphaModulation(pfc, false, fig_path)
ftr_files = {strcat(ftr_path, 'AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'AP/subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat')};
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

fig_path = strcat(ftr_path, 'AP/FIG/PFC_Expert_Combo/PFC/');
spontaneousAlphaModulation(pfc, false, fig_path)