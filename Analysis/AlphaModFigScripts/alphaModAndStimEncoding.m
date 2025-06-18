delete Stats/phase_mod_stim_encoding.txt 
diary Stats/phase_mod_stim_encoding.txt 

addpath(genpath('~/circstat-matlab/'))
init_paths;
s1 = load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Adjusted/Cortex/Spontaneous_Alpha_Modulation/data.mat'));
pfc = load(strcat(ftr_path, '/AP/FIG/PFC_Expert_Combo_Adjusted/PFC/Spontaneous_Alpha_Modulation/data.mat'));
striatum = load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Adjusted/Basal_Ganglia/Spontaneous_Alpha_Modulation/data.mat'));
amygdala = load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Adjusted/Amygdala/Spontaneous_Alpha_Modulation/data.mat'));

%% s1 sessions
% combine animals
ftr_files = {strcat(ftr_path, '/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_adjusted.mat'), ...
    strcat(ftr_path, '/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_adjusted.mat')};
for i = 1:length(ftr_files)
    f = load(ftr_files{i});
    if i == 1
        ftrs = f.ap_ftr;
    else
        ftrs = combineTables(ftrs, f.ap_ftr);
    end
end
S1 = ftrs(startsWith(ftrs.region, 'SS'),:);
striatum_inds = strcmp(ftrs.region, 'STR') + strcmp(ftrs.region, 'CP');
Striatum = ftrs(logical(striatum_inds), :);
amygdala_inds = strcmp(ftrs.region, 'BLAp') + strcmp(ftrs.region, 'LA');
Amygdala = ftrs(logical(amygdala_inds), :);

ftr_files = {strcat(ftr_path, '/AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, '/AP/subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat')};
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
PFC = ftrs(pfc_inds,:);

%-----------------------------------------------------%
% quality control
S1 = S1(cell2mat(S1.avg_trial_fr) > 1, :);
Striatum = Striatum(cell2mat(Striatum.avg_trial_fr) > 1, :);
Amygdala = Amygdala(cell2mat(Amygdala.avg_trial_fr) > 1, :);
PFC = PFC(cell2mat(PFC.avg_trial_fr) > 1, :);
s1.out.alpha_modulated = s1.out.alpha_modulated(cell2mat(s1.out.alpha_modulated.avg_trial_fr) > 1, :);
striatum.out.alpha_modulated = striatum.out.alpha_modulated(cell2mat(striatum.out.alpha_modulated.avg_trial_fr) > 1, :);
amygdala.out.alpha_modulated = amygdala.out.alpha_modulated(cell2mat(amygdala.out.alpha_modulated.avg_trial_fr) > 1, :);
pfc.out.alpha_modulated = pfc.out.alpha_modulated(cell2mat(pfc.out.alpha_modulated.avg_trial_fr) > 1, :);

exinds = load('ExcldInds/3738_excld_v2.mat');
for i = 1:length(exinds.new_excld{1})
    session_id = exinds.new_excld{1}{i};
    cid = exinds.new_excld{2}{i};
    S1(strcmp(S1.session_id, session_id) & S1.cluster_id == cid,:) = [];
    s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.session_id, session_id) & s1.out.alpha_modulated.cluster_id == cid,:) = [];
    Striatum(strcmp(Striatum.session_id, session_id) & Striatum.cluster_id == cid,:) = [];
    striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.session_id, session_id) & striatum.out.alpha_modulated.cluster_id == cid,:) = [];
    Amygdala(strcmp(Amygdala.session_id, session_id) & Amygdala.cluster_id == cid,:) = [];
    amygdala.out.alpha_modulated(strcmp(amygdala.out.alpha_modulated.session_id, session_id) & amygdala.out.alpha_modulated.cluster_id == cid,:) = [];
end
exinds = load('ExcldInds/3387_excld.mat');
for i = 1:length(exinds.excld{1})
    session_id = exinds.excld{1}{i};
    cid = exinds.excld{2}{i};
    S1(strcmp(S1.session_id, session_id) & S1.cluster_id == cid,:) = [];
    s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.session_id, session_id) & s1.out.alpha_modulated.cluster_id == cid,:) = [];
    Striatum(strcmp(Striatum.session_id, session_id) & Striatum.cluster_id == cid,:) = [];
    striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.session_id, session_id) & striatum.out.alpha_modulated.cluster_id == cid,:) = [];
    Amygdala(strcmp(Amygdala.session_id, session_id) & Amygdala.cluster_id == cid,:) = [];
    amygdala.out.alpha_modulated(strcmp(amygdala.out.alpha_modulated.session_id, session_id) & amygdala.out.alpha_modulated.cluster_id == cid,:) = [];
end

inds = find(contains(PFC.region, 'AC') & strcmp(PFC.waveform_class, 'RS') & cell2mat(PFC.avg_trial_fr) > 15);
for i = 1:length(inds)
    PFC(inds(i),:).waveform_class{1} = 'FS';
end
inds = find(contains(pfc.out.alpha_modulated.region, 'AC') & strcmp(pfc.out.alpha_modulated.waveform_class, 'RS') & cell2mat(pfc.out.alpha_modulated.avg_trial_fr) > 15);
for i = 1:length(inds)
    pfc.out.alpha_modulated(inds(i),:).waveform_class{1} = 'FS';
end

exinds = load('ExcldInds/1075_excld.mat');
for i = 1:length(exinds.excld{1})
    session_id = exinds.excld{1}{i};
    cid = exinds.excld{2}{i};
    PFC(strcmp(PFC.session_id, session_id) & PFC.cluster_id == cid,:) = [];
    pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.session_id, session_id) & pfc.out.alpha_modulated.cluster_id == cid,:) = [];
end
exinds = load('ExcldInds/3755_excld.mat');
for i = 1:length(exinds.excld{1})
    session_id = exinds.excld{1}{i};
    cid = exinds.excld{2}{i};
    PFC(strcmp(PFC.session_id, session_id) & PFC.cluster_id == cid,:) = [];
    pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.session_id, session_id) & pfc.out.alpha_modulated.cluster_id == cid,:) = [];
end
%-----------------------------------------------------%

s1_sessions = unique(S1.session_id);
pfc_sessions = unique(PFC.session_id);
striatum_sessions = unique(Striatum.session_id);
amygdala_sessions = unique(Amygdala.session_id);

s1_mod_rs_hit = [];
s1_mod_fs_hit = [];
s1_unmod_rs_hit = [];
s1_unmod_fs_hit = [];
s1_mod_rs_miss = [];
s1_mod_fs_miss = [];
s1_unmod_rs_miss = [];
s1_unmod_fs_miss = [];
s1_mod_rs_cr = [];
s1_mod_fs_cr = [];
s1_unmod_rs_cr = [];
s1_unmod_fs_cr = [];
s1_mod_rs_fa = [];
s1_mod_fs_fa = [];
s1_unmod_rs_fa = [];
s1_unmod_fs_fa = [];
s1_mod_rs_subj = {};
s1_mod_fs_subj = {};
s1_unmod_rs_subj = {};
s1_unmod_fs_subj = {};
s1_mod_rs_baseline = [];
s1_mod_fs_baseline = [];
s1_unmod_rs_baseline = [];
s1_unmod_fs_baseline = [];
s1_mod_rs_evoked = [];
s1_mod_fs_evoked = [];
s1_unmod_rs_evoked = [];
s1_unmod_fs_evoked = [];

for s = 1:length(s1_sessions)
    session_id = s1_sessions{s};
    tmp = s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.session_id, session_id),:);
    tmp_all = S1(strcmp(S1.session_id, session_id),:);
    s1_rs = tmp(strcmp(tmp.waveform_class,'RS'),:);
    s1_fs = tmp(strcmp(tmp.waveform_class,'FS'),:);
    S1_rs = tmp_all(strcmp(tmp_all.waveform_class,'RS'),:);
    S1_fs = tmp_all(strcmp(tmp_all.waveform_class,'FS'),:);
    s1_rs_ids = s1_rs.cluster_id;
    for id = 1:length(s1_rs_ids)
        S1_rs(S1_rs.cluster_id == s1_rs_ids(id),:) = [];
    end
    s1_fs_ids = s1_fs.cluster_id;
    for id = 1:length(s1_fs_ids)
        S1_fs(S1_fs.cluster_id == s1_fs_ids(id),:) = [];
    end
    s1_mod_rs_hit = [s1_mod_rs_hit; cell2mat(s1_rs.left_trigger_aligned_avg_fr_Hit)];
    s1_mod_fs_hit = [s1_mod_fs_hit; cell2mat(s1_fs.left_trigger_aligned_avg_fr_Hit)];
    s1_mod_rs_miss = [s1_mod_rs_miss; cell2mat(s1_rs.left_trigger_aligned_avg_fr_Miss)];
    s1_mod_fs_miss = [s1_mod_fs_miss; cell2mat(s1_fs.left_trigger_aligned_avg_fr_Miss)];
    s1_mod_rs_cr = [s1_mod_rs_cr; cell2mat(s1_rs.right_trigger_aligned_avg_fr_CR)];
    s1_mod_fs_cr = [s1_mod_fs_cr; cell2mat(s1_fs.right_trigger_aligned_avg_fr_CR)];
    s1_mod_rs_fa = [s1_mod_rs_fa; cell2mat(s1_rs.right_trigger_aligned_avg_fr_FA)];
    s1_mod_fs_fa = [s1_mod_fs_fa; cell2mat(s1_fs.right_trigger_aligned_avg_fr_FA)];

    s1_mod_rs_baseline = [s1_mod_rs_baseline; cell2mat(s1_rs.avg_baseline_fr)];
    s1_mod_fs_baseline = [s1_mod_fs_baseline; cell2mat(s1_fs.avg_baseline_fr)];

    s1_unmod_rs_hit = [s1_unmod_rs_hit; cell2mat(S1_rs.left_trigger_aligned_avg_fr_Hit)];
    s1_unmod_fs_hit = [s1_unmod_fs_hit; cell2mat(S1_fs.left_trigger_aligned_avg_fr_Hit)];
    s1_unmod_rs_miss = [s1_unmod_rs_miss; cell2mat(S1_rs.left_trigger_aligned_avg_fr_Miss)];
    s1_unmod_fs_miss = [s1_unmod_fs_miss; cell2mat(S1_fs.left_trigger_aligned_avg_fr_Miss)];
    s1_unmod_rs_cr = [s1_unmod_rs_cr; cell2mat(S1_rs.right_trigger_aligned_avg_fr_CR)];
    s1_unmod_fs_cr = [s1_unmod_fs_cr; cell2mat(S1_fs.right_trigger_aligned_avg_fr_CR)];
    s1_unmod_rs_fa = [s1_unmod_rs_fa; cell2mat(S1_rs.right_trigger_aligned_avg_fr_FA)];
    s1_unmod_fs_fa = [s1_unmod_fs_fa; cell2mat(S1_fs.right_trigger_aligned_avg_fr_FA)];

    s1_unmod_rs_baseline = [s1_unmod_rs_baseline; cell2mat(S1_rs.avg_baseline_fr)];
    s1_unmod_fs_baseline = [s1_unmod_fs_baseline; cell2mat(S1_fs.avg_baseline_fr)];

    for id = 1:length(s1_rs.session_id)
        sesh = s1_rs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        s1_mod_rs_subj = vertcat(s1_mod_rs_subj, subj);
    end

    for id = 1:length(s1_fs.session_id)
        sesh = s1_fs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        s1_mod_fs_subj = vertcat(s1_mod_fs_subj, subj);
    end

    for id = 1:length(S1_rs.session_id)
        sesh = S1_rs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        s1_unmod_rs_subj = vertcat(s1_unmod_rs_subj, subj);
    end

    for id = 1:length(S1_fs.session_id)
        sesh = S1_fs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        s1_unmod_fs_subj = vertcat(s1_unmod_fs_subj, subj);
    end
end

pfc_mod_rs_hit = [];
pfc_mod_fs_hit = [];
pfc_unmod_rs_hit = [];
pfc_unmod_fs_hit = [];
pfc_mod_rs_miss = [];
pfc_mod_fs_miss = [];
pfc_unmod_rs_miss = [];
pfc_unmod_fs_miss = [];
pfc_mod_rs_cr = [];
pfc_mod_fs_cr = [];
pfc_unmod_rs_cr = [];
pfc_unmod_fs_cr = [];
pfc_mod_rs_fa = [];
pfc_mod_fs_fa = [];
pfc_unmod_rs_fa = [];
pfc_unmod_fs_fa = [];
pfc_mod_rs_subj = {};
pfc_mod_fs_subj = {};
pfc_unmod_rs_subj = {};
pfc_unmod_fs_subj = {};
pfc_mod_rs_baseline = [];
pfc_mod_fs_baseline = [];
pfc_unmod_rs_baseline = [];
pfc_unmod_fs_baseline = [];

for s = 1:length(pfc_sessions)
    session_id = pfc_sessions{s};
    tmp = pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.session_id, session_id),:);
    tmp_all = PFC(strcmp(PFC.session_id, session_id),:);
    pfc_rs = tmp(strcmp(tmp.waveform_class,'RS'),:);
    pfc_fs = tmp(strcmp(tmp.waveform_class,'FS'),:);
    PFC_rs = tmp_all(strcmp(tmp_all.waveform_class,'RS'),:);
    PFC_fs = tmp_all(strcmp(tmp_all.waveform_class,'FS'),:);
    pfc_rs_ids = pfc_rs.cluster_id;
    for id = 1:length(pfc_rs_ids)
        PFC_rs(PFC_rs.cluster_id == pfc_rs_ids(id),:) = [];
    end
    pfc_fs_ids = pfc_fs.cluster_id;
    for id = 1:length(pfc_fs_ids)
        PFC_fs(PFC_fs.cluster_id == pfc_fs_ids(id),:) = [];
    end
    pfc_mod_rs_hit = [pfc_mod_rs_hit; cell2mat(pfc_rs.left_trigger_aligned_avg_fr_Hit)];
    pfc_mod_fs_hit = [pfc_mod_fs_hit; cell2mat(pfc_fs.left_trigger_aligned_avg_fr_Hit)];
    if isempty(cell2mat(pfc_rs.left_trigger_aligned_avg_fr_Miss))
        pfc_mod_rs_miss = [pfc_mod_rs_miss; nan(size(cell2mat(pfc_rs.left_trigger_aligned_avg_fr_Hit)))];
        pfc_mod_fs_miss = [pfc_mod_fs_miss; nan(size(cell2mat(pfc_fs.left_trigger_aligned_avg_fr_Hit)))];
    else
        pfc_mod_rs_miss = [pfc_mod_rs_miss; cell2mat(pfc_rs.left_trigger_aligned_avg_fr_Miss)];
        pfc_mod_fs_miss = [pfc_mod_fs_miss; cell2mat(pfc_fs.left_trigger_aligned_avg_fr_Miss)];
    end
    pfc_mod_rs_cr = [pfc_mod_rs_cr; cell2mat(pfc_rs.right_trigger_aligned_avg_fr_CR)];
    pfc_mod_fs_cr = [pfc_mod_fs_cr; cell2mat(pfc_fs.right_trigger_aligned_avg_fr_CR)];
    pfc_mod_rs_fa = [pfc_mod_rs_fa; cell2mat(pfc_rs.right_trigger_aligned_avg_fr_FA)];
    pfc_mod_fs_fa = [pfc_mod_fs_fa; cell2mat(pfc_fs.right_trigger_aligned_avg_fr_FA)];

    pfc_mod_rs_baseline = [pfc_mod_rs_baseline; cell2mat(pfc_rs.avg_baseline_fr)];
    pfc_mod_fs_baseline = [pfc_mod_fs_baseline; cell2mat(pfc_fs.avg_baseline_fr)];

    pfc_unmod_rs_hit = [pfc_unmod_rs_hit; cell2mat(PFC_rs.left_trigger_aligned_avg_fr_Hit)];
    pfc_unmod_fs_hit = [pfc_unmod_fs_hit; cell2mat(PFC_fs.left_trigger_aligned_avg_fr_Hit)];
    if isempty(cell2mat(pfc_rs.left_trigger_aligned_avg_fr_Miss))
        pfc_unmod_rs_miss = [pfc_unmod_rs_miss; nan(size(cell2mat(PFC_rs.left_trigger_aligned_avg_fr_Hit)))];
        pfc_unmod_fs_miss = [pfc_unmod_fs_miss; nan(size(cell2mat(PFC_fs.left_trigger_aligned_avg_fr_Hit)))];
    else
        pfc_unmod_rs_miss = [pfc_unmod_rs_miss; cell2mat(PFC_rs.left_trigger_aligned_avg_fr_Miss)];
        pfc_unmod_fs_miss = [pfc_unmod_fs_miss; cell2mat(PFC_fs.left_trigger_aligned_avg_fr_Miss)];
    end
    pfc_unmod_rs_cr = [pfc_unmod_rs_cr; cell2mat(PFC_rs.right_trigger_aligned_avg_fr_CR)];
    pfc_unmod_fs_cr = [pfc_unmod_fs_cr; cell2mat(PFC_fs.right_trigger_aligned_avg_fr_CR)];
    pfc_unmod_rs_fa = [pfc_unmod_rs_fa; cell2mat(PFC_rs.right_trigger_aligned_avg_fr_FA)];
    pfc_unmod_fs_fa = [pfc_unmod_fs_fa; cell2mat(PFC_fs.right_trigger_aligned_avg_fr_FA)];

    pfc_unmod_rs_baseline = [pfc_unmod_rs_baseline; cell2mat(PFC_rs.avg_baseline_fr)];
    pfc_unmod_fs_baseline = [pfc_unmod_fs_baseline; cell2mat(PFC_fs.avg_baseline_fr)];

    for id = 1:length(pfc_rs.session_id)
        sesh = pfc_rs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        pfc_mod_rs_subj = vertcat(pfc_mod_rs_subj, subj);
    end
    
    for id = 1:length(pfc_fs.session_id)
        sesh = pfc_fs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        pfc_mod_fs_subj = vertcat(pfc_mod_fs_subj, subj);
    end
    
    for id = 1:length(PFC_rs.session_id)
        sesh = PFC_rs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        pfc_unmod_rs_subj = vertcat(pfc_unmod_rs_subj, subj);
    end
    
    for id = 1:length(PFC_fs.session_id)
        sesh = PFC_fs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        pfc_unmod_fs_subj = vertcat(pfc_unmod_fs_subj, subj);
    end
end

striatum_mod_rs_hit = [];
striatum_mod_fs_hit = [];
striatum_unmod_rs_hit = [];
striatum_unmod_fs_hit = [];
striatum_mod_rs_miss = [];
striatum_mod_fs_miss = [];
striatum_unmod_rs_miss = [];
striatum_unmod_fs_miss = [];
striatum_mod_rs_cr = [];
striatum_mod_fs_cr = [];
striatum_unmod_rs_cr = [];
striatum_unmod_fs_cr = [];
striatum_mod_rs_fa = [];
striatum_mod_fs_fa = [];
striatum_unmod_rs_fa = [];
striatum_unmod_fs_fa = [];
striatum_mod_rs_subj = {};
striatum_mod_fs_subj = {};
striatum_unmod_rs_subj = {};
striatum_unmod_fs_subj = {};
striatum_mod_rs_baseline = [];
striatum_mod_fs_baseline = [];
striatum_unmod_rs_baseline = [];
striatum_unmod_fs_baseline = [];


for s = 1:length(striatum_sessions)
    session_id = striatum_sessions{s};
    tmp = striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.session_id, session_id),:);
    tmp_all = Striatum(strcmp(Striatum.session_id, session_id),:);
    striatum_rs = tmp(strcmp(tmp.waveform_class,'RS'),:);
    striatum_fs = tmp(strcmp(tmp.waveform_class,'FS'),:);
    Striatum_rs = tmp_all(strcmp(tmp_all.waveform_class,'RS'),:);
    Striatum_fs = tmp_all(strcmp(tmp_all.waveform_class,'FS'),:);
    striatum_rs_ids = striatum_rs.cluster_id;
    for id = 1:length(striatum_rs_ids)
        Striatum_rs(Striatum_rs.cluster_id == striatum_rs_ids(id),:) = [];
    end
    striatum_fs_ids = striatum_fs.cluster_id;
    for id = 1:length(striatum_fs_ids)
        Striatum_fs(Striatum_fs.cluster_id == striatum_fs_ids(id),:) = [];
    end
    striatum_mod_rs_hit = [striatum_mod_rs_hit; cell2mat(striatum_rs.left_trigger_aligned_avg_fr_Hit)];
    striatum_mod_fs_hit = [striatum_mod_fs_hit; cell2mat(striatum_fs.left_trigger_aligned_avg_fr_Hit)];
    striatum_mod_rs_miss = [striatum_mod_rs_miss; cell2mat(striatum_rs.left_trigger_aligned_avg_fr_Miss)];
    striatum_mod_fs_miss = [striatum_mod_fs_miss; cell2mat(striatum_fs.left_trigger_aligned_avg_fr_Miss)];
    striatum_mod_rs_cr = [striatum_mod_rs_cr; cell2mat(striatum_rs.right_trigger_aligned_avg_fr_CR)];
    striatum_mod_fs_cr = [striatum_mod_fs_cr; cell2mat(striatum_fs.right_trigger_aligned_avg_fr_CR)];
    striatum_mod_rs_fa = [striatum_mod_rs_fa; cell2mat(striatum_rs.right_trigger_aligned_avg_fr_FA)];
    striatum_mod_fs_fa = [striatum_mod_fs_fa; cell2mat(striatum_fs.right_trigger_aligned_avg_fr_FA)];

    striatum_mod_rs_baseline = [striatum_mod_rs_baseline; cell2mat(striatum_rs.avg_baseline_fr)];
    striatum_mod_fs_baseline = [striatum_mod_fs_baseline; cell2mat(striatum_fs.avg_baseline_fr)];

    striatum_unmod_rs_hit = [striatum_unmod_rs_hit; cell2mat(Striatum_rs.left_trigger_aligned_avg_fr_Hit)];
    striatum_unmod_fs_hit = [striatum_unmod_fs_hit; cell2mat(Striatum_fs.left_trigger_aligned_avg_fr_Hit)];
    striatum_unmod_rs_miss = [striatum_unmod_rs_miss; cell2mat(Striatum_rs.left_trigger_aligned_avg_fr_Miss)];
    striatum_unmod_fs_miss = [striatum_unmod_fs_miss; cell2mat(Striatum_fs.left_trigger_aligned_avg_fr_Miss)];
    striatum_unmod_rs_cr = [striatum_unmod_rs_cr; cell2mat(Striatum_rs.right_trigger_aligned_avg_fr_CR)];
    striatum_unmod_fs_cr = [striatum_unmod_fs_cr; cell2mat(Striatum_fs.right_trigger_aligned_avg_fr_CR)];
    striatum_unmod_rs_fa = [striatum_unmod_rs_fa; cell2mat(Striatum_rs.right_trigger_aligned_avg_fr_FA)];
    striatum_unmod_fs_fa = [striatum_unmod_fs_fa; cell2mat(Striatum_fs.right_trigger_aligned_avg_fr_FA)];

    striatum_unmod_rs_baseline = [striatum_unmod_rs_baseline; cell2mat(Striatum_rs.avg_baseline_fr)];
    striatum_unmod_fs_baseline = [striatum_unmod_fs_baseline; cell2mat(Striatum_fs.avg_baseline_fr)];

    for id = 1:length(striatum_rs.session_id)
        sesh = striatum_rs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        striatum_mod_rs_subj = vertcat(striatum_mod_rs_subj, subj);
    end
    
    for id = 1:length(striatum_fs.session_id)
        sesh = striatum_fs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        striatum_mod_fs_subj = vertcat(striatum_mod_fs_subj, subj);
    end
    
    for id = 1:length(Striatum_rs.session_id)
        sesh = Striatum_rs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        striatum_unmod_rs_subj = vertcat(striatum_unmod_rs_subj, subj);
    end
    
    for id = 1:length(Striatum_fs.session_id)
        sesh = Striatum_fs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        striatum_unmod_fs_subj = vertcat(striatum_unmod_fs_subj, subj);
    end
end

amygdala_mod_rs_hit = [];
amygdala_mod_fs_hit = [];
amygdala_unmod_rs_hit = [];
amygdala_unmod_fs_hit = [];
amygdala_mod_rs_miss = [];
amygdala_mod_fs_miss = [];
amygdala_unmod_rs_miss = [];
amygdala_unmod_fs_miss = [];
amygdala_mod_rs_cr = [];
amygdala_mod_fs_cr = [];
amygdala_unmod_rs_cr = [];
amygdala_unmod_fs_cr = [];
amygdala_mod_rs_fa = [];
amygdala_mod_fs_fa = [];
amygdala_unmod_rs_fa = [];
amygdala_unmod_fs_fa = [];
amygdala_mod_rs_subj = {};
amygdala_mod_fs_subj = {};
amygdala_unmod_rs_subj = {};
amygdala_unmod_fs_subj = {};
amygdala_mod_rs_baseline = [];
amygdala_mod_fs_baseline = [];
amygdala_unmod_rs_baseline = [];
amygdala_unmod_fs_baseline = [];

for s = 1:length(amygdala_sessions)
    session_id = amygdala_sessions{s};
    tmp = amygdala.out.alpha_modulated(strcmp(amygdala.out.alpha_modulated.session_id, session_id),:);
    tmp_all = Amygdala(strcmp(Amygdala.session_id, session_id),:);
    amygdala_rs = tmp(strcmp(tmp.waveform_class,'RS'),:);
    amygdala_fs = tmp(strcmp(tmp.waveform_class,'FS'),:);
    Amygdala_rs = tmp_all(strcmp(tmp_all.waveform_class,'RS'),:);
    Amygdala_fs = tmp_all(strcmp(tmp_all.waveform_class,'FS'),:);
    amygdala_rs_ids = amygdala_rs.cluster_id;
    for id = 1:length(amygdala_rs_ids)
        Amygdala_rs(Amygdala_rs.cluster_id == amygdala_rs_ids(id),:) = [];
    end
    amygdala_fs_ids = amygdala_fs.cluster_id;
    for id = 1:length(amygdala_fs_ids)
        Amygdala_fs(Amygdala_fs.cluster_id == amygdala_fs_ids(id),:) = [];
    end
    amygdala_mod_rs_hit = [amygdala_mod_rs_hit; cell2mat(amygdala_rs.left_trigger_aligned_avg_fr_Hit)];
    amygdala_mod_fs_hit = [amygdala_mod_fs_hit; cell2mat(amygdala_fs.left_trigger_aligned_avg_fr_Hit)];
    amygdala_mod_rs_miss = [amygdala_mod_rs_miss; cell2mat(amygdala_rs.left_trigger_aligned_avg_fr_Miss)];
    amygdala_mod_fs_miss = [amygdala_mod_fs_miss; cell2mat(amygdala_fs.left_trigger_aligned_avg_fr_Miss)];
    amygdala_mod_rs_cr = [amygdala_mod_rs_cr; cell2mat(amygdala_rs.right_trigger_aligned_avg_fr_CR)];
    amygdala_mod_fs_cr = [amygdala_mod_fs_cr; cell2mat(amygdala_fs.right_trigger_aligned_avg_fr_CR)];
    amygdala_mod_rs_fa = [amygdala_mod_rs_fa; cell2mat(amygdala_rs.right_trigger_aligned_avg_fr_FA)];
    amygdala_mod_fs_fa = [amygdala_mod_fs_fa; cell2mat(amygdala_fs.right_trigger_aligned_avg_fr_FA)];

    amygdala_mod_rs_baseline = [amygdala_mod_rs_baseline; cell2mat(amygdala_rs.avg_baseline_fr)];
    amygdala_mod_fs_baseline = [amygdala_mod_fs_baseline; cell2mat(amygdala_fs.avg_baseline_fr)];

    amygdala_unmod_rs_hit = [amygdala_unmod_rs_hit; cell2mat(Amygdala_rs.left_trigger_aligned_avg_fr_Hit)];
    amygdala_unmod_fs_hit = [amygdala_unmod_fs_hit; cell2mat(Amygdala_fs.left_trigger_aligned_avg_fr_Hit)];
    amygdala_unmod_rs_miss = [amygdala_unmod_rs_miss; cell2mat(Amygdala_rs.left_trigger_aligned_avg_fr_Miss)];
    amygdala_unmod_fs_miss = [amygdala_unmod_fs_miss; cell2mat(Amygdala_fs.left_trigger_aligned_avg_fr_Miss)];
    amygdala_unmod_rs_cr = [amygdala_unmod_rs_cr; cell2mat(Amygdala_rs.right_trigger_aligned_avg_fr_CR)];
    amygdala_unmod_fs_cr = [amygdala_unmod_fs_cr; cell2mat(Amygdala_fs.right_trigger_aligned_avg_fr_CR)];
    amygdala_unmod_rs_fa = [amygdala_unmod_rs_fa; cell2mat(Amygdala_rs.right_trigger_aligned_avg_fr_FA)];
    amygdala_unmod_fs_fa = [amygdala_unmod_fs_fa; cell2mat(Amygdala_fs.right_trigger_aligned_avg_fr_FA)];

    amygdala_unmod_rs_baseline = [amygdala_unmod_rs_baseline; cell2mat(Amygdala_rs.avg_baseline_fr)];
    amygdala_unmod_fs_baseline = [amygdala_unmod_fs_baseline; cell2mat(Amygdala_fs.avg_baseline_fr)];

    for id = 1:length(amygdala_rs.session_id)
        sesh = amygdala_rs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        amygdala_mod_rs_subj = vertcat(amygdala_mod_rs_subj, subj);
    end
    
    for id = 1:length(amygdala_fs.session_id)
        sesh = amygdala_fs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        amygdala_mod_fs_subj = vertcat(amygdala_mod_fs_subj, subj);
    end
    
    for id = 1:length(Amygdala_rs.session_id)
        sesh = Amygdala_rs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        amygdala_unmod_rs_subj = vertcat(amygdala_unmod_rs_subj, subj);
    end
    
    for id = 1:length(Amygdala_fs.session_id)
        sesh = Amygdala_fs.session_id{id};
        parts = strsplit(sesh, '_');
        part = parts{2};
        parts = strsplit(part, '-');
        subj = parts{2};
        amygdala_unmod_fs_subj = vertcat(amygdala_unmod_fs_subj, subj);
    end
end

time = linspace(-2.8,4.8,size(striatum_mod_rs_hit,2));
Time = time(time > 0)';

%% evoked fig 
s1_mod_rs_delta_hit = s1_mod_rs_hit-mean(s1_mod_rs_hit(:,time<0),2);
s1_mod_rs_evoked_hit = max(s1_mod_rs_delta_hit(:,time > 0 & time < 0.4),[],2);
s1_mod_fs_delta_hit = s1_mod_fs_hit-mean(s1_mod_fs_hit(:,time<0),2);
s1_mod_fs_evoked_hit = max(s1_mod_fs_delta_hit(:,time > 0 & time < 0.4),[],2);

s1_unmod_rs_delta_hit = s1_unmod_rs_hit-mean(s1_unmod_rs_hit(:,time<0),2);
s1_unmod_rs_evoked_hit = max(s1_unmod_rs_delta_hit(:,time > 0 & time < 0.4),[],2);
s1_unmod_fs_delta_hit = s1_unmod_fs_hit-mean(s1_unmod_fs_hit(:,time<0),2);
s1_unmod_fs_evoked_hit = max(s1_unmod_fs_delta_hit(:,time > 0 & time < 0.4),[],2);

s1_mod_rs_delta_miss = s1_mod_rs_miss-mean(s1_mod_rs_miss(:,time<0),2);
s1_mod_rs_evoked_miss = max(s1_mod_rs_delta_miss(:,time > 0 & time < 0.4),[],2);
s1_mod_fs_delta_miss = s1_mod_fs_miss-mean(s1_mod_fs_miss(:,time<0),2);
s1_mod_fs_evoked_miss = max(s1_mod_fs_delta_miss(:,time > 0 & time < 0.4),[],2);

s1_unmod_rs_delta_miss = s1_unmod_rs_miss-mean(s1_unmod_rs_miss(:,time<0),2);
s1_unmod_rs_evoked_miss = max(s1_unmod_rs_delta_miss(:,time > 0 & time < 0.4),[],2);
s1_unmod_fs_delta_miss = s1_unmod_fs_miss-mean(s1_unmod_fs_miss(:,time<0),2);
s1_unmod_fs_evoked_miss = max(s1_unmod_fs_delta_miss(:,time > 0 & time < 0.4),[],2);

pfc_mod_rs_delta_hit = pfc_mod_rs_hit-mean(pfc_mod_rs_hit(:,time<0),2);
pfc_mod_rs_evoked_hit = max(pfc_mod_rs_delta_hit(:,time > 0 & time < 0.4),[],2);
pfc_mod_fs_delta_hit = pfc_mod_fs_hit-mean(pfc_mod_fs_hit(:,time<0),2);
pfc_mod_fs_evoked_hit = max(pfc_mod_fs_delta_hit(:,time > 0 & time < 0.4),[],2);

pfc_unmod_rs_delta_hit = pfc_unmod_rs_hit-mean(pfc_unmod_rs_hit(:,time<0),2);
pfc_unmod_rs_evoked_hit = max(pfc_unmod_rs_delta_hit(:,time > 0 & time < 0.4),[],2);
pfc_unmod_fs_delta_hit = pfc_unmod_fs_hit-mean(pfc_unmod_fs_hit(:,time<0),2);
pfc_unmod_fs_evoked_hit = max(pfc_unmod_fs_delta_hit(:,time > 0 & time < 0.4),[],2);

pfc_mod_rs_delta_miss = pfc_mod_rs_miss-mean(pfc_mod_rs_miss(:,time<0),2);
pfc_mod_rs_evoked_miss = max(pfc_mod_rs_delta_miss(:,time > 0 & time < 0.4),[],2);
pfc_mod_fs_delta_miss = pfc_mod_fs_miss-mean(pfc_mod_fs_miss(:,time<0),2);
pfc_mod_fs_evoked_miss = max(pfc_mod_fs_delta_miss(:,time > 0 & time < 0.4),[],2);

pfc_unmod_rs_delta_miss = pfc_unmod_rs_miss-mean(pfc_unmod_rs_miss(:,time<0),2);
pfc_unmod_rs_evoked_miss = max(pfc_unmod_rs_delta_miss(:,time > 0 & time < 0.4),[],2);
pfc_unmod_fs_delta_miss = pfc_unmod_fs_miss-mean(pfc_unmod_fs_miss(:,time<0),2);
pfc_unmod_fs_evoked_miss = max(pfc_unmod_fs_delta_miss(:,time > 0 & time < 0.4),[],2);

striatum_mod_rs_delta_hit = striatum_mod_rs_hit-mean(striatum_mod_rs_hit(:,time<0),2);
striatum_mod_rs_evoked_hit = max(striatum_mod_rs_delta_hit(:,time > 0 & time < 0.4),[],2);
striatum_mod_fs_delta_hit = striatum_mod_fs_hit-mean(striatum_mod_fs_hit(:,time<0),2);
striatum_mod_fs_evoked_hit = max(striatum_mod_fs_delta_hit(:,time > 0 & time < 0.4),[],2);

striatum_unmod_rs_delta_hit = striatum_unmod_rs_hit-mean(striatum_unmod_rs_hit(:,time<0),2);
striatum_unmod_rs_evoked_hit = max(striatum_unmod_rs_delta_hit(:,time > 0 & time < 0.4),[],2);
striatum_unmod_fs_delta_hit = striatum_unmod_fs_hit-mean(striatum_unmod_fs_hit(:,time<0),2);
striatum_unmod_fs_evoked_hit = max(striatum_unmod_fs_delta_hit(:,time > 0 & time < 0.4),[],2);

striatum_mod_rs_delta_miss = striatum_mod_rs_miss-mean(striatum_mod_rs_miss(:,time<0),2);
striatum_mod_rs_evoked_miss = max(striatum_mod_rs_delta_miss(:,time > 0 & time < 0.4),[],2);
striatum_mod_fs_delta_miss = striatum_mod_fs_miss-mean(striatum_mod_fs_miss(:,time<0),2);
striatum_mod_fs_evoked_miss = max(striatum_mod_fs_delta_miss(:,time > 0 & time < 0.4),[],2);

striatum_unmod_rs_delta_miss = striatum_unmod_rs_miss-mean(striatum_unmod_rs_miss(:,time<0),2);
striatum_unmod_rs_evoked_miss = max(striatum_unmod_rs_delta_miss(:,time > 0 & time < 0.4),[],2);
striatum_unmod_fs_delta_miss = striatum_unmod_fs_miss-mean(striatum_unmod_fs_miss(:,time<0),2);
striatum_unmod_fs_evoked_miss = max(striatum_unmod_fs_delta_miss(:,time > 0 & time < 0.4),[],2);

amygdala_mod_rs_delta_hit = amygdala_mod_rs_hit-mean(amygdala_mod_rs_hit(:,time<0),2);
amygdala_mod_rs_evoked_hit = max(amygdala_mod_rs_delta_hit(:,time > 0 & time < 0.4),[],2);
amygdala_mod_fs_delta_hit = amygdala_mod_fs_hit-mean(amygdala_mod_fs_hit(:,time<0),2);
amygdala_mod_fs_evoked_hit = max(amygdala_mod_fs_delta_hit(:,time > 0 & time < 0.4),[],2);

amygdala_unmod_rs_delta_hit = amygdala_unmod_rs_hit-mean(amygdala_unmod_rs_hit(:,time<0),2);
amygdala_unmod_rs_evoked_hit = max(amygdala_unmod_rs_delta_hit(:,time > 0 & time < 0.4),[],2);
amygdala_unmod_fs_delta_hit = amygdala_unmod_fs_hit-mean(amygdala_unmod_fs_hit(:,time<0),2);
amygdala_unmod_fs_evoked_hit = max(amygdala_unmod_fs_delta_hit(:,time > 0 & time < 0.4),[],2);

amygdala_mod_rs_delta_miss = amygdala_mod_rs_miss-mean(amygdala_mod_rs_miss(:,time<0),2);
amygdala_mod_rs_evoked_miss = max(amygdala_mod_rs_delta_miss(:,time > 0 & time < 0.4),[],2);
amygdala_mod_fs_delta_miss = amygdala_mod_fs_miss-mean(amygdala_mod_fs_miss(:,time<0),2);
amygdala_mod_fs_evoked_miss = max(amygdala_mod_fs_delta_miss(:,time > 0 & time < 0.4),[],2);

amygdala_unmod_rs_delta_miss = amygdala_unmod_rs_miss-mean(amygdala_unmod_rs_miss(:,time<0),2);
amygdala_unmod_rs_evoked_miss = max(amygdala_unmod_rs_delta_miss(:,time > 0 & time < 0.4),[],2);
amygdala_unmod_fs_delta_miss = amygdala_unmod_fs_miss-mean(amygdala_unmod_fs_miss(:,time<0),2);
amygdala_unmod_fs_evoked_miss = max(amygdala_unmod_fs_delta_miss(:,time > 0 & time < 0.4),[],2);

s1_mod_rs_delta_cr = s1_mod_rs_cr-mean(s1_mod_rs_cr(:,time<0),2);
s1_mod_rs_evoked_cr = max(s1_mod_rs_delta_cr(:,time > 0 & time < 0.4),[],2);
s1_mod_fs_delta_cr = s1_mod_fs_cr-mean(s1_mod_fs_cr(:,time<0),2);
s1_mod_fs_evoked_cr = max(s1_mod_fs_delta_cr(:,time > 0 & time < 0.4),[],2);

s1_unmod_rs_delta_cr = s1_unmod_rs_cr-mean(s1_unmod_rs_cr(:,time<0),2);
s1_unmod_rs_evoked_cr = max(s1_unmod_rs_delta_cr(:,time > 0 & time < 0.4),[],2);
s1_unmod_fs_delta_cr = s1_unmod_fs_cr-mean(s1_unmod_fs_cr(:,time<0),2);
s1_unmod_fs_evoked_cr = max(s1_unmod_fs_delta_cr(:,time > 0 & time < 0.4),[],2);

s1_mod_rs_delta_fa = s1_mod_rs_fa-mean(s1_mod_rs_fa(:,time<0),2);
s1_mod_rs_evoked_fa = max(s1_mod_rs_delta_fa(:,time > 0 & time < 0.4),[],2);
s1_mod_fs_delta_fa = s1_mod_fs_fa-mean(s1_mod_fs_fa(:,time<0),2);
s1_mod_fs_evoked_fa = max(s1_mod_fs_delta_fa(:,time > 0 & time < 0.4),[],2);

s1_unmod_rs_delta_fa = s1_unmod_rs_fa-mean(s1_unmod_rs_fa(:,time<0),2);
s1_unmod_rs_evoked_fa = max(s1_unmod_rs_delta_fa(:,time > 0 & time < 0.4),[],2);
s1_unmod_fs_delta_fa = s1_unmod_fs_fa-mean(s1_unmod_fs_fa(:,time<0),2);
s1_unmod_fs_evoked_fa = max(s1_unmod_fs_delta_fa(:,time > 0 & time < 0.4),[],2);

pfc_mod_rs_delta_cr = pfc_mod_rs_cr-mean(pfc_mod_rs_cr(:,time<0),2);
pfc_mod_rs_evoked_cr = max(pfc_mod_rs_delta_cr(:,time > 0 & time < 0.4),[],2);
pfc_mod_fs_delta_cr = pfc_mod_fs_cr-mean(pfc_mod_fs_cr(:,time<0),2);
pfc_mod_fs_evoked_cr = max(pfc_mod_fs_delta_cr(:,time > 0 & time < 0.4),[],2);

pfc_unmod_rs_delta_cr = pfc_unmod_rs_cr-mean(pfc_unmod_rs_cr(:,time<0),2);
pfc_unmod_rs_evoked_cr = max(pfc_unmod_rs_delta_cr(:,time > 0 & time < 0.4),[],2);
pfc_unmod_fs_delta_cr = pfc_unmod_fs_cr-mean(pfc_unmod_fs_cr(:,time<0),2);
pfc_unmod_fs_evoked_cr = max(pfc_unmod_fs_delta_cr(:,time > 0 & time < 0.4),[],2);

pfc_mod_rs_delta_fa = pfc_mod_rs_fa-mean(pfc_mod_rs_fa(:,time<0),2);
pfc_mod_rs_evoked_fa = max(pfc_mod_rs_delta_fa(:,time > 0 & time < 0.4),[],2);
pfc_mod_fs_delta_fa = pfc_mod_fs_fa-mean(pfc_mod_fs_fa(:,time<0),2);
pfc_mod_fs_evoked_fa = max(pfc_mod_fs_delta_fa(:,time > 0 & time < 0.4),[],2);

pfc_unmod_rs_delta_fa = pfc_unmod_rs_fa-mean(pfc_unmod_rs_fa(:,time<0),2);
pfc_unmod_rs_evoked_fa = max(pfc_unmod_rs_delta_fa(:,time > 0 & time < 0.4),[],2);
pfc_unmod_fs_delta_fa = pfc_unmod_fs_fa-mean(pfc_unmod_fs_fa(:,time<0),2);
pfc_unmod_fs_evoked_fa = max(pfc_unmod_fs_delta_fa(:,time > 0 & time < 0.4),[],2);

striatum_mod_rs_delta_cr = striatum_mod_rs_cr-mean(striatum_mod_rs_cr(:,time<0),2);
striatum_mod_rs_evoked_cr = max(striatum_mod_rs_delta_cr(:,time > 0 & time < 0.4),[],2);
striatum_mod_fs_delta_cr = striatum_mod_fs_cr-mean(striatum_mod_fs_cr(:,time<0),2);
striatum_mod_fs_evoked_cr = max(striatum_mod_fs_delta_cr(:,time > 0 & time < 0.4),[],2);

striatum_unmod_rs_delta_cr = striatum_unmod_rs_cr-mean(striatum_unmod_rs_cr(:,time<0),2);
striatum_unmod_rs_evoked_cr = max(striatum_unmod_rs_delta_cr(:,time > 0 & time < 0.4),[],2);
striatum_unmod_fs_delta_cr = striatum_unmod_fs_cr-mean(striatum_unmod_fs_cr(:,time<0),2);
striatum_unmod_fs_evoked_cr = max(striatum_unmod_fs_delta_cr(:,time > 0 & time < 0.4),[],2);

striatum_mod_rs_delta_fa = striatum_mod_rs_fa-mean(striatum_mod_rs_fa(:,time<0),2);
striatum_mod_rs_evoked_fa = max(striatum_mod_rs_delta_fa(:,time > 0 & time < 0.4),[],2);
striatum_mod_fs_delta_fa = striatum_mod_fs_fa-mean(striatum_mod_fs_fa(:,time<0),2);
striatum_mod_fs_evoked_fa = max(striatum_mod_fs_delta_fa(:,time > 0 & time < 0.4),[],2);

striatum_unmod_rs_delta_fa = striatum_unmod_rs_fa-mean(striatum_unmod_rs_fa(:,time<0),2);
striatum_unmod_rs_evoked_fa = max(striatum_unmod_rs_delta_fa(:,time > 0 & time < 0.4),[],2);
striatum_unmod_fs_delta_fa = striatum_unmod_fs_fa-mean(striatum_unmod_fs_fa(:,time<0),2);
striatum_unmod_fs_evoked_fa = max(striatum_unmod_fs_delta_fa(:,time > 0 & time < 0.4),[],2);

amygdala_mod_rs_delta_cr = amygdala_mod_rs_cr-mean(amygdala_mod_rs_cr(:,time<0),2);
amygdala_mod_rs_evoked_cr = max(amygdala_mod_rs_delta_cr(:,time > 0 & time < 0.4),[],2);
amygdala_mod_fs_delta_cr = amygdala_mod_fs_cr-mean(amygdala_mod_fs_cr(:,time<0),2);
amygdala_mod_fs_evoked_cr = max(amygdala_mod_fs_delta_cr(:,time > 0 & time < 0.4),[],2);

amygdala_unmod_rs_delta_cr = amygdala_unmod_rs_cr-mean(amygdala_unmod_rs_cr(:,time<0),2);
amygdala_unmod_rs_evoked_cr = max(amygdala_unmod_rs_delta_cr(:,time > 0 & time < 0.4),[],2);
amygdala_unmod_fs_delta_cr = amygdala_unmod_fs_cr-mean(amygdala_unmod_fs_cr(:,time<0),2);
amygdala_unmod_fs_evoked_cr = max(amygdala_unmod_fs_delta_cr(:,time > 0 & time < 0.4),[],2);

amygdala_mod_rs_delta_fa = amygdala_mod_rs_fa-mean(amygdala_mod_rs_fa(:,time<0),2);
amygdala_mod_rs_evoked_fa = max(amygdala_mod_rs_delta_fa(:,time > 0 & time < 0.4),[],2);
amygdala_mod_fs_delta_fa = amygdala_mod_fs_fa-mean(amygdala_mod_fs_fa(:,time<0),2);
amygdala_mod_fs_evoked_fa = max(amygdala_mod_fs_delta_fa(:,time > 0 & time < 0.4),[],2);

amygdala_unmod_rs_delta_fa = amygdala_unmod_rs_fa-mean(amygdala_unmod_rs_fa(:,time<0),2);
amygdala_unmod_rs_evoked_fa = max(amygdala_unmod_rs_delta_fa(:,time > 0 & time < 0.4),[],2);
amygdala_unmod_fs_delta_fa = amygdala_unmod_fs_fa-mean(amygdala_unmod_fs_fa(:,time<0),2);
amygdala_unmod_fs_evoked_fa = max(amygdala_unmod_fs_delta_fa(:,time > 0 & time < 0.4),[],2);

evoked_fig = figure('Position', [1220 770 1007 948]);
tl = tiledlayout(3,2);
axs(1,1) = nexttile;
hold on
plot(zeros(length(s1_mod_rs_evoked_hit),1)+1+(rand(length(s1_mod_rs_evoked_hit),1)-0.5)*-0.3, s1_mod_rs_evoked_hit, 'k.', 'MarkerSize', 0.1)
violinplot(1, s1_mod_rs_evoked_hit, 'FaceColor', 'b')
plot(zeros(length(s1_unmod_rs_evoked_hit),1)+2+(rand(length(s1_unmod_rs_evoked_hit),1)-0.5)*-0.3, s1_unmod_rs_evoked_hit, 'k.', 'MarkerSize', 0.1)
violinplot(2, s1_unmod_rs_evoked_hit, 'FaceColor', 'r')
plot(zeros(length(s1_mod_rs_evoked_miss),1)+4+(rand(length(s1_mod_rs_evoked_miss),1)-0.5)*-0.3, s1_mod_rs_evoked_miss, 'k.', 'MarkerSize', 0.1)
violinplot(4, s1_mod_rs_evoked_miss, 'FaceColor', 'b')
plot(zeros(length(s1_unmod_rs_evoked_miss),1)+5+(rand(length(s1_unmod_rs_evoked_miss),1)-0.5)*-0.3, s1_unmod_rs_evoked_miss, 'k.', 'MarkerSize', 0.1)
violinplot(5, s1_unmod_rs_evoked_miss, 'FaceColor', 'r')
plot(zeros(length(s1_mod_rs_evoked_cr),1)+7+(rand(length(s1_mod_rs_evoked_cr),1)-0.5)*-0.3, s1_mod_rs_evoked_cr, 'k.', 'MarkerSize', 0.1)
violinplot(7, s1_mod_rs_evoked_cr, 'FaceColor', 'b')
plot(zeros(length(s1_unmod_rs_evoked_cr),1)+8+(rand(length(s1_unmod_rs_evoked_cr),1)-0.5)*-0.3, s1_unmod_rs_evoked_cr, 'k.', 'MarkerSize', 0.1)
violinplot(8, s1_unmod_rs_evoked_cr, 'FaceColor', 'r')
plot(zeros(length(s1_mod_rs_evoked_fa),1)+10+(rand(length(s1_mod_rs_evoked_fa),1)-0.5)*-0.3, s1_mod_rs_evoked_fa, 'k.', 'MarkerSize', 0.1)
violinplot(10, s1_mod_rs_evoked_fa, 'FaceColor', 'b')
plot(zeros(length(s1_unmod_rs_evoked_fa),1)+11+(rand(length(s1_unmod_rs_evoked_fa),1)-0.5)*-0.3, s1_unmod_rs_evoked_fa, 'k.', 'MarkerSize', 0.1)
violinplot(11, s1_unmod_rs_evoked_fa, 'FaceColor', 'r')
xticks([1.5:3:10.5])
xticklabels({'Hit', 'Miss', 'CR', 'FA'})
ylabel('S1', 'FontSize', 16)
title('Regular Spiking', 'FontWeight', 'normal', 'FontSize', 16)
lims = ylim;
ylim([lims(1), lims(2)+20])
ax = gca;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 16;

axs(1,2) = nexttile;
hold on
plot(zeros(length(s1_mod_fs_evoked_hit),1)+1+(rand(length(s1_mod_fs_evoked_hit),1)-0.5)*-0.3, s1_mod_fs_evoked_hit, 'k.', 'MarkerSize', 0.1)
violinplot(1, s1_mod_fs_evoked_hit, 'FaceColor', 'b')
plot(zeros(length(s1_unmod_fs_evoked_hit),1)+2+(rand(length(s1_unmod_fs_evoked_hit),1)-0.5)*-0.3, s1_unmod_fs_evoked_hit, 'k.', 'MarkerSize', 0.1)
violinplot(2, s1_unmod_fs_evoked_hit, 'FaceColor', 'r')
plot(zeros(length(s1_mod_fs_evoked_miss),1)+4+(rand(length(s1_mod_fs_evoked_miss),1)-0.5)*-0.3, s1_mod_fs_evoked_miss, 'k.', 'MarkerSize', 0.1)
violinplot(4, s1_mod_fs_evoked_miss, 'FaceColor', 'b')
plot(zeros(length(s1_unmod_fs_evoked_miss),1)+5+(rand(length(s1_unmod_fs_evoked_miss),1)-0.5)*-0.3, s1_unmod_fs_evoked_miss, 'k.', 'MarkerSize', 0.1)
violinplot(5, s1_unmod_fs_evoked_miss, 'FaceColor', 'r')
plot(zeros(length(s1_mod_fs_evoked_cr),1)+7+(rand(length(s1_mod_fs_evoked_cr),1)-0.5)*-0.3, s1_mod_fs_evoked_cr, 'k.', 'MarkerSize', 0.1)
violinplot(7, s1_mod_fs_evoked_cr, 'FaceColor', 'b')
plot(zeros(length(s1_unmod_fs_evoked_cr),1)+8+(rand(length(s1_unmod_fs_evoked_cr),1)-0.5)*-0.3, s1_unmod_fs_evoked_cr, 'k.', 'MarkerSize', 0.1)
violinplot(8, s1_unmod_fs_evoked_cr, 'FaceColor', 'r')
plot(zeros(length(s1_mod_fs_evoked_fa),1)+10+(rand(length(s1_mod_fs_evoked_fa),1)-0.5)*-0.3, s1_mod_fs_evoked_fa, 'k.', 'MarkerSize', 0.1)
violinplot(10, s1_mod_fs_evoked_fa, 'FaceColor', 'b')
plot(zeros(length(s1_unmod_fs_evoked_fa),1)+11+(rand(length(s1_unmod_fs_evoked_fa),1)-0.5)*-0.3, s1_unmod_fs_evoked_fa, 'k.', 'MarkerSize', 0.1)
violinplot(11, s1_unmod_fs_evoked_fa, 'FaceColor', 'r')
xticks([1.5:3:10.5])
xticklabels({'Hit', 'Miss', 'CR', 'FA'})
title('Fast Spiking', 'FontWeight', 'normal', 'FontSize', 16)
lims = ylim;
ylim([lims(1), lims(2)+20])
ax = gca;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 16;

axs(2,1) = nexttile;
hold on
plot(zeros(length(pfc_mod_rs_evoked_hit),1)+1+(rand(length(pfc_mod_rs_evoked_hit),1)-0.5)*-0.3, pfc_mod_rs_evoked_hit, 'k.', 'MarkerSize', 0.1)
violinplot(1, pfc_mod_rs_evoked_hit, 'FaceColor', 'b')
plot(zeros(length(pfc_unmod_rs_evoked_hit),1)+2+(rand(length(pfc_unmod_rs_evoked_hit),1)-0.5)*-0.3, pfc_unmod_rs_evoked_hit, 'k.', 'MarkerSize', 0.1)
violinplot(2, pfc_unmod_rs_evoked_hit, 'FaceColor', 'r')
plot(zeros(length(pfc_mod_rs_evoked_miss),1)+4+(rand(length(pfc_mod_rs_evoked_miss),1)-0.5)*-0.3, pfc_mod_rs_evoked_miss, 'k.', 'MarkerSize', 0.1)
violinplot(4, pfc_mod_rs_evoked_miss, 'FaceColor', 'b')
plot(zeros(length(pfc_unmod_rs_evoked_miss),1)+5+(rand(length(pfc_unmod_rs_evoked_miss),1)-0.5)*-0.3, pfc_unmod_rs_evoked_miss, 'k.', 'MarkerSize', 0.1)
violinplot(5, pfc_unmod_rs_evoked_miss, 'FaceColor', 'r')
plot(zeros(length(pfc_mod_rs_evoked_cr),1)+7+(rand(length(pfc_mod_rs_evoked_cr),1)-0.5)*-0.3, pfc_mod_rs_evoked_cr, 'k.', 'MarkerSize', 0.1)
violinplot(7, pfc_mod_rs_evoked_cr, 'FaceColor', 'b')
plot(zeros(length(pfc_unmod_rs_evoked_cr),1)+8+(rand(length(pfc_unmod_rs_evoked_cr),1)-0.5)*-0.3, pfc_unmod_rs_evoked_cr, 'k.', 'MarkerSize', 0.1)
violinplot(8, pfc_unmod_rs_evoked_cr, 'FaceColor', 'r')
plot(zeros(length(pfc_mod_rs_evoked_fa),1)+10+(rand(length(pfc_mod_rs_evoked_fa),1)-0.5)*-0.3, pfc_mod_rs_evoked_fa, 'k.', 'MarkerSize', 0.1)
violinplot(10, pfc_mod_rs_evoked_fa, 'FaceColor', 'b')
plot(zeros(length(pfc_unmod_rs_evoked_fa),1)+11+(rand(length(pfc_unmod_rs_evoked_fa),1)-0.5)*-0.3, pfc_unmod_rs_evoked_fa, 'k.', 'MarkerSize', 0.1)
violinplot(11, pfc_unmod_rs_evoked_fa, 'FaceColor', 'r')
xticks([1.5:3:10.5])
xticklabels({'Hit', 'Miss', 'CR', 'FA'})
ylabel('PFC', 'FontSize', 16)
lims = ylim;
ylim([lims(1), lims(2)+20])
ax = gca;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 16;

axs(2,2) = nexttile;
hold on
plot(zeros(length(pfc_mod_fs_evoked_hit),1)+1+(rand(length(pfc_mod_fs_evoked_hit),1)-0.5)*-0.3, pfc_mod_fs_evoked_hit, 'k.', 'MarkerSize', 0.1)
violinplot(1, pfc_mod_fs_evoked_hit, 'FaceColor', 'b')
plot(zeros(length(pfc_unmod_fs_evoked_hit),1)+2+(rand(length(pfc_unmod_fs_evoked_hit),1)-0.5)*-0.3, pfc_unmod_fs_evoked_hit, 'k.', 'MarkerSize', 0.1)
violinplot(2, pfc_unmod_fs_evoked_hit, 'FaceColor', 'r')
plot(zeros(length(pfc_mod_fs_evoked_miss),1)+4+(rand(length(pfc_mod_fs_evoked_miss),1)-0.5)*-0.3, pfc_mod_fs_evoked_miss, 'k.', 'MarkerSize', 0.1)
violinplot(4, pfc_mod_fs_evoked_miss, 'FaceColor', 'b')
plot(zeros(length(pfc_unmod_fs_evoked_miss),1)+5+(rand(length(pfc_unmod_fs_evoked_miss),1)-0.5)*-0.3, pfc_unmod_fs_evoked_miss, 'k.', 'MarkerSize', 0.1)
violinplot(5, pfc_unmod_fs_evoked_miss, 'FaceColor', 'r')
plot(zeros(length(pfc_mod_fs_evoked_cr),1)+7+(rand(length(pfc_mod_fs_evoked_cr),1)-0.5)*-0.3, pfc_mod_fs_evoked_cr, 'k.', 'MarkerSize', 0.1)
violinplot(7, pfc_mod_fs_evoked_cr, 'FaceColor', 'b')
plot(zeros(length(pfc_unmod_fs_evoked_cr),1)+8+(rand(length(pfc_unmod_fs_evoked_cr),1)-0.5)*-0.3, pfc_unmod_fs_evoked_cr, 'k.', 'MarkerSize', 0.1)
violinplot(8, pfc_unmod_fs_evoked_cr, 'FaceColor', 'r')
plot(zeros(length(pfc_mod_fs_evoked_fa),1)+10+(rand(length(pfc_mod_fs_evoked_fa),1)-0.5)*-0.3, pfc_mod_fs_evoked_fa, 'k.', 'MarkerSize', 0.1)
violinplot(10, pfc_mod_fs_evoked_fa, 'FaceColor', 'b')
plot(zeros(length(pfc_unmod_fs_evoked_fa),1)+11+(rand(length(pfc_unmod_fs_evoked_fa),1)-0.5)*-0.3, pfc_unmod_fs_evoked_fa, 'k.', 'MarkerSize', 0.1)
violinplot(11, pfc_unmod_fs_evoked_fa, 'FaceColor', 'r')
xticks([1.5:3:10.5])
xticklabels({'Hit', 'Miss', 'CR', 'FA'})
lims = ylim;
ylim([lims(1), lims(2)+20])
ax = gca;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 16;

axs(3,1) = nexttile;
hold on
plot(zeros(length(striatum_mod_rs_evoked_hit),1)+1+(rand(length(striatum_mod_rs_evoked_hit),1)-0.5)*-0.3, striatum_mod_rs_evoked_hit, 'k.', 'MarkerSize', 0.1)
violinplot(1, striatum_mod_rs_evoked_hit, 'FaceColor', 'b')
plot(zeros(length(striatum_unmod_rs_evoked_hit),1)+2+(rand(length(striatum_unmod_rs_evoked_hit),1)-0.5)*-0.3, striatum_unmod_rs_evoked_hit, 'k.', 'MarkerSize', 0.1)
violinplot(2, striatum_unmod_rs_evoked_hit, 'FaceColor', 'r')
plot(zeros(length(striatum_mod_rs_evoked_miss),1)+4+(rand(length(striatum_mod_rs_evoked_miss),1)-0.5)*-0.3, striatum_mod_rs_evoked_miss, 'k.', 'MarkerSize', 0.1)
violinplot(4, striatum_mod_rs_evoked_miss, 'FaceColor', 'b')
plot(zeros(length(striatum_unmod_rs_evoked_miss),1)+5+(rand(length(striatum_unmod_rs_evoked_miss),1)-0.5)*-0.3, striatum_unmod_rs_evoked_miss, 'k.', 'MarkerSize', 0.1)
violinplot(5, striatum_unmod_rs_evoked_miss, 'FaceColor', 'r')
plot(zeros(length(striatum_mod_rs_evoked_cr),1)+7+(rand(length(striatum_mod_rs_evoked_cr),1)-0.5)*-0.3, striatum_mod_rs_evoked_cr, 'k.', 'MarkerSize', 0.1)
violinplot(7, striatum_mod_rs_evoked_cr, 'FaceColor', 'b')
plot(zeros(length(striatum_unmod_rs_evoked_cr),1)+8+(rand(length(striatum_unmod_rs_evoked_cr),1)-0.5)*-0.3, striatum_unmod_rs_evoked_cr, 'k.', 'MarkerSize', 0.1)
violinplot(8, striatum_unmod_rs_evoked_cr, 'FaceColor', 'r')
plot(zeros(length(striatum_mod_rs_evoked_fa),1)+10+(rand(length(striatum_mod_rs_evoked_fa),1)-0.5)*-0.3, striatum_mod_rs_evoked_fa, 'k.', 'MarkerSize', 0.1)
violinplot(10, striatum_mod_rs_evoked_fa, 'FaceColor', 'b')
plot(zeros(length(striatum_unmod_rs_evoked_fa),1)+11+(rand(length(striatum_unmod_rs_evoked_fa),1)-0.5)*-0.3, striatum_unmod_rs_evoked_fa, 'k.', 'MarkerSize', 0.1)
violinplot(11, striatum_unmod_rs_evoked_fa, 'FaceColor', 'r')
xticks([1.5:3:10.5])
xticklabels({'Hit', 'Miss', 'CR', 'FA'})
ylabel('Striatum', 'FontSize', 16)
lims = ylim;
ylim([lims(1), lims(2)+20])
ax = gca;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 16;

axs(3,2) = nexttile;
hold on
plot(zeros(length(striatum_mod_fs_evoked_hit),1)+1+(rand(length(striatum_mod_fs_evoked_hit),1)-0.5)*-0.3, striatum_mod_fs_evoked_hit, 'k.', 'MarkerSize', 0.1)
violinplot(1, striatum_mod_fs_evoked_hit, 'FaceColor', 'b')
plot(zeros(length(striatum_unmod_fs_evoked_hit),1)+2+(rand(length(striatum_unmod_fs_evoked_hit),1)-0.5)*-0.3, striatum_unmod_fs_evoked_hit, 'k.', 'MarkerSize', 0.1)
violinplot(2, striatum_unmod_fs_evoked_hit, 'FaceColor', 'r')
plot(zeros(length(striatum_mod_fs_evoked_miss),1)+4+(rand(length(striatum_mod_fs_evoked_miss),1)-0.5)*-0.3, striatum_mod_fs_evoked_miss, 'k.', 'MarkerSize', 0.1)
violinplot(4, striatum_mod_fs_evoked_miss, 'FaceColor', 'b')
plot(zeros(length(striatum_unmod_fs_evoked_miss),1)+5+(rand(length(striatum_unmod_fs_evoked_miss),1)-0.5)*-0.3, striatum_unmod_fs_evoked_miss, 'k.', 'MarkerSize', 0.1)
violinplot(5, striatum_unmod_fs_evoked_miss, 'FaceColor', 'r')
plot(zeros(length(striatum_mod_fs_evoked_cr),1)+7+(rand(length(striatum_mod_fs_evoked_cr),1)-0.5)*-0.3, striatum_mod_fs_evoked_cr, 'k.', 'MarkerSize', 0.1)
violinplot(7, striatum_mod_fs_evoked_cr, 'FaceColor', 'b')
plot(zeros(length(striatum_unmod_fs_evoked_cr),1)+8+(rand(length(striatum_unmod_fs_evoked_cr),1)-0.5)*-0.3, striatum_unmod_fs_evoked_cr, 'k.', 'MarkerSize', 0.1)
violinplot(8, striatum_unmod_fs_evoked_cr, 'FaceColor', 'r')
plot(zeros(length(striatum_mod_fs_evoked_fa),1)+10+(rand(length(striatum_mod_fs_evoked_fa),1)-0.5)*-0.3, striatum_mod_fs_evoked_fa, 'k.', 'MarkerSize', 0.1)
violinplot(10, striatum_mod_fs_evoked_fa, 'FaceColor', 'b')
plot(zeros(length(striatum_unmod_fs_evoked_fa),1)+11+(rand(length(striatum_unmod_fs_evoked_fa),1)-0.5)*-0.3, striatum_unmod_fs_evoked_fa, 'k.', 'MarkerSize', 0.1)
violinplot(11, striatum_unmod_fs_evoked_fa, 'FaceColor', 'r')
xticks([1.5:3:10.5])
xticklabels({'Hit', 'Miss', 'CR', 'FA'})
lims = ylim;
ylim([lims(1), lims(2)+20])
ax = gca;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 16;
xlabel(tl, 'Trial Outcome', 'FontSize', 18)
ylabel(tl, 'Evoked \Delta Firing Rate (Hz)', 'FontSize', 18)

fprintf('\n\nMod vs. Unmod on hit trials\n')
if KStest(s1_mod_rs_evoked_hit) || KStest(s1_unmod_rs_evoked_hit)
    fprintf(sprintf('S1 mod RS vs unmod RS evoked fr (Mann-Whitney): p = %d\n', ranksum(s1_mod_rs_evoked_hit, s1_unmod_rs_evoked_hit)))
else
    [a,p] = ttest2(s1_mod_rs_evoked_hit, s1_unmod_rs_evoked_hit);
    fprintf(sprintf('S1 mod RS vs unmod RS evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(s1_mod_fs_evoked_hit) || KStest(s1_unmod_fs_evoked_hit)
    fprintf(sprintf('S1 mod fs vs unmod fs evoked fr (Mann-Whitney): p = %d\n', ranksum(s1_mod_fs_evoked_hit, s1_unmod_fs_evoked_hit)))
else
    [a,p] = ttest2(s1_mod_fs_evoked_hit, s1_unmod_fs_evoked_hit);
    fprintf(sprintf('S1 mod fs vs unmod fs evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(pfc_mod_rs_evoked_hit) || KStest(pfc_unmod_rs_evoked_hit)
    fprintf(sprintf('PFC mod RS vs unmod RS evoked fr (Mann-Whitney): p = %d\n', ranksum(pfc_mod_rs_evoked_hit, pfc_unmod_rs_evoked_hit)))
else
    [a,p] = ttest2(pfc_mod_rs_evoked_hit, pfc_unmod_rs_evoked_hit);
    fprintf(sprintf('PFC mod RS vs unmod RS evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(pfc_mod_fs_evoked_hit) || KStest(pfc_unmod_fs_evoked_hit)
    fprintf(sprintf('PFC mod fs vs unmod fs evoked fr (Mann-Whitney): p = %d\n', ranksum(pfc_mod_fs_evoked_hit, pfc_unmod_fs_evoked_hit)))
else
    [a,p] = ttest2(pfc_mod_fs_evoked_hit, pfc_unmod_fs_evoked_hit);
    fprintf(sprintf('PFC mod fs vs unmod fs evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(striatum_mod_rs_evoked_hit) || KStest(striatum_unmod_rs_evoked_hit)
    fprintf(sprintf('Striatum mod RS vs unmod RS evoked fr (Mann-Whitney): p = %d\n', ranksum(striatum_mod_rs_evoked_hit, striatum_unmod_rs_evoked_hit)))
else
    [a,p] = ttest2(striatum_mod_rs_evoked_hit, striatum_unmod_rs_evoked_hit);
    fprintf(sprintf('Striatum mod RS vs unmod RS evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(striatum_mod_fs_evoked_hit) || KStest(striatum_unmod_fs_evoked_hit)
    fprintf(sprintf('Striatum mod fs vs unmod fs evoked fr (Mann-Whitney): p = %d\n', ranksum(striatum_mod_fs_evoked_hit, striatum_unmod_fs_evoked_hit)))
else
    [a,p] = ttest2(striatum_mod_fs_evoked_hit, striatum_unmod_fs_evoked_hit);
    fprintf(sprintf('Striatum mod fs vs unmod fs evoked fr (2 sample t-test): p = %d\n', p))
end

fprintf('\n\nMod vs. Unmod on cr trials\n')
if KStest(s1_mod_rs_evoked_cr) || KStest(s1_unmod_rs_evoked_cr)
    fprintf(sprintf('S1 mod RS vs unmod RS evoked fr (Mann-Wcrney): p = %d\n', ranksum(s1_mod_rs_evoked_cr, s1_unmod_rs_evoked_cr)))
else
    [a,p] = ttest2(s1_mod_rs_evoked_cr, s1_unmod_rs_evoked_cr);
    fprintf(sprintf('S1 mod RS vs unmod RS evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(s1_mod_fs_evoked_cr) || KStest(s1_unmod_fs_evoked_cr)
    fprintf(sprintf('S1 mod fs vs unmod fs evoked fr (Mann-Wcrney): p = %d\n', ranksum(s1_mod_fs_evoked_cr, s1_unmod_fs_evoked_cr)))
else
    [a,p] = ttest2(s1_mod_fs_evoked_cr, s1_unmod_fs_evoked_cr);
    fprintf(sprintf('S1 mod fs vs unmod fs evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(pfc_mod_rs_evoked_cr) || KStest(pfc_unmod_rs_evoked_cr)
    fprintf(sprintf('PFC mod RS vs unmod RS evoked fr (Mann-Wcrney): p = %d\n', ranksum(pfc_mod_rs_evoked_cr, pfc_unmod_rs_evoked_cr)))
else
    [a,p] = ttest2(pfc_mod_rs_evoked_cr, pfc_unmod_rs_evoked_cr);
    fprintf(sprintf('PFC mod RS vs unmod RS evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(pfc_mod_fs_evoked_cr) || KStest(pfc_unmod_fs_evoked_cr)
    fprintf(sprintf('PFC mod fs vs unmod fs evoked fr (Mann-Wcrney): p = %d\n', ranksum(pfc_mod_fs_evoked_cr, pfc_unmod_fs_evoked_cr)))
else
    [a,p] = ttest2(pfc_mod_fs_evoked_cr, pfc_unmod_fs_evoked_cr);
    fprintf(sprintf('PFC mod fs vs unmod fs evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(striatum_mod_rs_evoked_cr) || KStest(striatum_unmod_rs_evoked_cr)
    fprintf(sprintf('Striatum mod RS vs unmod RS evoked fr (Mann-Wcrney): p = %d\n', ranksum(striatum_mod_rs_evoked_cr, striatum_unmod_rs_evoked_cr)))
else
    [a,p] = ttest2(striatum_mod_rs_evoked_cr, striatum_unmod_rs_evoked_cr);
    fprintf(sprintf('Striatum mod RS vs unmod RS evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(striatum_mod_fs_evoked_cr) || KStest(striatum_unmod_fs_evoked_cr)
    fprintf(sprintf('Striatum mod fs vs unmod fs evoked fr (Mann-Wcrney): p = %d\n', ranksum(striatum_mod_fs_evoked_cr, striatum_unmod_fs_evoked_cr)))
else
    [a,p] = ttest2(striatum_mod_fs_evoked_cr, striatum_unmod_fs_evoked_cr);
    fprintf(sprintf('Striatum mod fs vs unmod fs evoked fr (2 sample t-test): p = %d\n', p))
end

fprintf('\n\nMod vs. Unmod on miss trials\n')
if KStest(s1_mod_rs_evoked_miss) || KStest(s1_unmod_rs_evoked_miss)
    fprintf(sprintf('S1 mod RS vs unmod RS evoked fr (Mann-Wmissney): p = %d\n', ranksum(s1_mod_rs_evoked_miss, s1_unmod_rs_evoked_miss)))
else
    [a,p] = ttest2(s1_mod_rs_evoked_miss, s1_unmod_rs_evoked_miss);
    fprintf(sprintf('S1 mod RS vs unmod RS evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(s1_mod_fs_evoked_miss) || KStest(s1_unmod_fs_evoked_miss)
    fprintf(sprintf('S1 mod fs vs unmod fs evoked fr (Mann-Wmissney): p = %d\n', ranksum(s1_mod_fs_evoked_miss, s1_unmod_fs_evoked_miss)))
else
    [a,p] = ttest2(s1_mod_fs_evoked_miss, s1_unmod_fs_evoked_miss);
    fprintf(sprintf('S1 mod fs vs unmod fs evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(pfc_mod_rs_evoked_miss) || KStest(pfc_unmod_rs_evoked_miss)
    fprintf(sprintf('PFC mod RS vs unmod RS evoked fr (Mann-Wmissney): p = %d\n', ranksum(pfc_mod_rs_evoked_miss, pfc_unmod_rs_evoked_miss)))
else
    [a,p] = ttest2(pfc_mod_rs_evoked_miss, pfc_unmod_rs_evoked_miss);
    fprintf(sprintf('PFC mod RS vs unmod RS evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(pfc_mod_fs_evoked_miss) || KStest(pfc_unmod_fs_evoked_miss)
    fprintf(sprintf('PFC mod fs vs unmod fs evoked fr (Mann-Wmissney): p = %d\n', ranksum(pfc_mod_fs_evoked_miss, pfc_unmod_fs_evoked_miss)))
else
    [a,p] = ttest2(pfc_mod_fs_evoked_miss, pfc_unmod_fs_evoked_miss);
    fprintf(sprintf('PFC mod fs vs unmod fs evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(striatum_mod_rs_evoked_miss) || KStest(striatum_unmod_rs_evoked_miss)
    fprintf(sprintf('Striatum mod RS vs unmod RS evoked fr (Mann-Wmissney): p = %d\n', ranksum(striatum_mod_rs_evoked_miss, striatum_unmod_rs_evoked_miss)))
else
    [a,p] = ttest2(striatum_mod_rs_evoked_miss, striatum_unmod_rs_evoked_miss);
    fprintf(sprintf('Striatum mod RS vs unmod RS evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(striatum_mod_fs_evoked_miss) || KStest(striatum_unmod_fs_evoked_miss)
    fprintf(sprintf('Striatum mod fs vs unmod fs evoked fr (Mann-Wmissney): p = %d\n', ranksum(striatum_mod_fs_evoked_miss, striatum_unmod_fs_evoked_miss)))
else
    [a,p] = ttest2(striatum_mod_fs_evoked_miss, striatum_unmod_fs_evoked_miss);
    fprintf(sprintf('Striatum mod fs vs unmod fs evoked fr (2 sample t-test): p = %d\n', p))
end

fprintf('\n\nMod vs. Unmod on fa trials\n')
if KStest(s1_mod_rs_evoked_fa) || KStest(s1_unmod_rs_evoked_fa)
    fprintf(sprintf('S1 mod RS vs unmod RS evoked fr (Mann-Wfaney): p = %d\n', ranksum(s1_mod_rs_evoked_fa, s1_unmod_rs_evoked_fa)))
else
    [a,p] = ttest2(s1_mod_rs_evoked_fa, s1_unmod_rs_evoked_fa);
    fprintf(sprintf('S1 mod RS vs unmod RS evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(s1_mod_fs_evoked_fa) || KStest(s1_unmod_fs_evoked_fa)
    fprintf(sprintf('S1 mod fs vs unmod fs evoked fr (Mann-Wfaney): p = %d\n', ranksum(s1_mod_fs_evoked_fa, s1_unmod_fs_evoked_fa)))
else
    [a,p] = ttest2(s1_mod_fs_evoked_fa, s1_unmod_fs_evoked_fa);
    fprintf(sprintf('S1 mod fs vs unmod fs evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(pfc_mod_rs_evoked_fa) || KStest(pfc_unmod_rs_evoked_fa)
    fprintf(sprintf('PFC mod RS vs unmod RS evoked fr (Mann-Wfaney): p = %d\n', ranksum(pfc_mod_rs_evoked_fa, pfc_unmod_rs_evoked_fa)))
else
    [a,p] = ttest2(pfc_mod_rs_evoked_fa, pfc_unmod_rs_evoked_fa);
    fprintf(sprintf('PFC mod RS vs unmod RS evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(pfc_mod_fs_evoked_fa) || KStest(pfc_unmod_fs_evoked_fa)
    fprintf(sprintf('PFC mod fs vs unmod fs evoked fr (Mann-Wfaney): p = %d\n', ranksum(pfc_mod_fs_evoked_fa, pfc_unmod_fs_evoked_fa)))
else
    [a,p] = ttest2(pfc_mod_fs_evoked_fa, pfc_unmod_fs_evoked_fa);
    fprintf(sprintf('PFC mod fs vs unmod fs evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(striatum_mod_rs_evoked_fa) || KStest(striatum_unmod_rs_evoked_fa)
    fprintf(sprintf('Striatum mod RS vs unmod RS evoked fr (Mann-Wfaney): p = %d\n', ranksum(striatum_mod_rs_evoked_fa, striatum_unmod_rs_evoked_fa)))
else
    [a,p] = ttest2(striatum_mod_rs_evoked_fa, striatum_unmod_rs_evoked_fa);
    fprintf(sprintf('Striatum mod RS vs unmod RS evoked fr (2 sample t-test): p = %d\n', p))
end
if KStest(striatum_mod_fs_evoked_fa) || KStest(striatum_unmod_fs_evoked_fa)
    fprintf(sprintf('Striatum mod fs vs unmod fs evoked fr (Mann-Wfaney): p = %d\n', ranksum(striatum_mod_fs_evoked_fa, striatum_unmod_fs_evoked_fa)))
else
    [a,p] = ttest2(striatum_mod_fs_evoked_fa, striatum_unmod_fs_evoked_fa);
    fprintf(sprintf('Striatum mod fs vs unmod fs evoked fr (2 sample t-test): p = %d\n', p))
end

fprintf('\n\nMod hit vs miss trials\n')
if KStest(s1_mod_rs_evoked_hit) || KStest(s1_mod_rs_evoked_miss)
    fprintf(sprintf('S1 mod RS vs mod RS evoked fr (signed-rank): p = %d\n', signrank(s1_mod_rs_evoked_hit, s1_mod_rs_evoked_miss)))
else
    [a,p] = ttest(s1_mod_rs_evoked_hit, s1_mod_rs_evoked_miss);
    fprintf(sprintf('S1 mod RS vs mod RS evoked fr (signed-rank): p = %d\n', p))
end
if KStest(s1_mod_fs_evoked_hit) || KStest(s1_mod_fs_evoked_miss)
    fprintf(sprintf('S1 mod fs vs mod fs evoked fr (signed-rank): p = %d\n', signrank(s1_mod_fs_evoked_hit, s1_mod_fs_evoked_miss)))
else
    [a,p] = ttest(s1_mod_fs_evoked_hit, s1_mod_fs_evoked_miss);
    fprintf(sprintf('S1 mod fs vs mod fs evoked fr (paired t-test): p = %d\n', p))
end
if KStest(pfc_mod_rs_evoked_hit) || KStest(pfc_mod_rs_evoked_miss)
    fprintf(sprintf('PFC mod RS vs mod RS evoked fr (signed-rank): p = %d\n', signrank(pfc_mod_rs_evoked_hit, pfc_mod_rs_evoked_miss)))
else
    [a,p] = ttest(pfc_mod_rs_evoked_hit, pfc_mod_rs_evoked_miss);
    fprintf(sprintf('PFC mod RS vs mod RS evoked fr (paired t-test): p = %d\n', p))
end
if KStest(pfc_mod_fs_evoked_hit) || KStest(pfc_mod_fs_evoked_miss)
    fprintf(sprintf('PFC mod fs vs mod fs evoked fr (signed-rank): p = %d\n', signrank(pfc_mod_fs_evoked_hit, pfc_mod_fs_evoked_miss)))
else
    [a,p] = ttest(pfc_mod_fs_evoked_hit, pfc_mod_fs_evoked_miss);
    fprintf(sprintf('PFC mod fs vs mod fs evoked fr (paired t-test): p = %d\n', p))
end
if KStest(striatum_mod_rs_evoked_hit) || KStest(striatum_mod_rs_evoked_miss)
    fprintf(sprintf('Striatum mod RS vs mod RS evoked fr (signed-rank): p = %d\n', signrank(striatum_mod_rs_evoked_hit, striatum_mod_rs_evoked_miss)))
else
    [a,p] = ttest(striatum_mod_rs_evoked_hit, striatum_mod_rs_evoked_miss);
    fprintf(sprintf('Striatum mod RS vs mod RS evoked fr (paired t-test): p = %d\n', p))
end
if KStest(striatum_mod_fs_evoked_hit) || KStest(striatum_mod_fs_evoked_miss)
    fprintf(sprintf('Striatum mod fs vs mod fs evoked fr (signed-rank): p = %d\n', signrank(striatum_mod_fs_evoked_hit, striatum_mod_fs_evoked_miss)))
else
    [a,p] = ttest(striatum_mod_fs_evoked_hit, striatum_mod_fs_evoked_miss);
    fprintf(sprintf('Striatum mod fs vs mod fs evoked fr (paired t-test): p = %d\n', p))
end

fprintf('\n\nUnmod hit vs miss trials\n')
if KStest(s1_unmod_rs_evoked_hit) || KStest(s1_unmod_rs_evoked_miss)
    fprintf(sprintf('S1 unmod RS vs unmod RS evoked fr (signed-rank): p = %d\n', signrank(s1_unmod_rs_evoked_hit, s1_unmod_rs_evoked_miss)))
else
    [a,p] = ttest(s1_unmod_rs_evoked_hit, s1_unmod_rs_evoked_miss);
    fprintf(sprintf('S1 unmod RS vs unmod RS evoked fr (signed-rank): p = %d\n', p))
end
if KStest(s1_unmod_fs_evoked_hit) || KStest(s1_unmod_fs_evoked_miss)
    fprintf(sprintf('S1 unmod fs vs unmod fs evoked fr (signed-rank): p = %d\n', signrank(s1_unmod_fs_evoked_hit, s1_unmod_fs_evoked_miss)))
else
    [a,p] = ttest(s1_unmod_fs_evoked_hit, s1_unmod_fs_evoked_miss);
    fprintf(sprintf('S1 unmod fs vs unmod fs evoked fr (paired t-test): p = %d\n', p))
end
if KStest(pfc_unmod_rs_evoked_hit) || KStest(pfc_unmod_rs_evoked_miss)
    fprintf(sprintf('PFC unmod RS vs unmod RS evoked fr (signed-rank): p = %d\n', signrank(pfc_unmod_rs_evoked_hit, pfc_unmod_rs_evoked_miss)))
else
    [a,p] = ttest(pfc_unmod_rs_evoked_hit, pfc_unmod_rs_evoked_miss);
    fprintf(sprintf('PFC unmod RS vs unmod RS evoked fr (paired t-test): p = %d\n', p))
end
if KStest(pfc_unmod_fs_evoked_hit) || KStest(pfc_unmod_fs_evoked_miss)
    fprintf(sprintf('PFC unmod fs vs unmod fs evoked fr (signed-rank): p = %d\n', signrank(pfc_unmod_fs_evoked_hit, pfc_unmod_fs_evoked_miss)))
else
    [a,p] = ttest(pfc_unmod_fs_evoked_hit, pfc_unmod_fs_evoked_miss);
    fprintf(sprintf('PFC unmod fs vs unmod fs evoked fr (paired t-test): p = %d\n', p))
end
if KStest(striatum_unmod_rs_evoked_hit) || KStest(striatum_unmod_rs_evoked_miss)
    fprintf(sprintf('Striatum unmod RS vs unmod RS evoked fr (signed-rank): p = %d\n', signrank(striatum_unmod_rs_evoked_hit, striatum_unmod_rs_evoked_miss)))
else
    [a,p] = ttest(striatum_unmod_rs_evoked_hit, striatum_unmod_rs_evoked_miss);
    fprintf(sprintf('Striatum unmod RS vs unmod RS evoked fr (paired t-test): p = %d\n', p))
end
if KStest(striatum_unmod_fs_evoked_hit) || KStest(striatum_unmod_fs_evoked_miss)
    fprintf(sprintf('Striatum unmod fs vs unmod fs evoked fr (signed-rank): p = %d\n', signrank(striatum_unmod_fs_evoked_hit, striatum_unmod_fs_evoked_miss)))
else
    [a,p] = ttest(striatum_unmod_fs_evoked_hit, striatum_unmod_fs_evoked_miss);
    fprintf(sprintf('Striatum unmod fs vs unmod fs evoked fr (paired t-test): p = %d\n', p))
end
%% iti firing rates 
s1_mod_rs_iti_hit = mean(s1_mod_rs_delta_hit(:,time>2 & time < 5),2);
s1_mod_fs_iti_hit = mean(s1_mod_fs_delta_hit(:,time>2 & time < 5),2);
s1_unmod_rs_iti_hit = mean(s1_unmod_rs_delta_hit(:,time>2 & time < 5),2);
s1_unmod_fs_iti_hit = mean(s1_unmod_fs_delta_hit(:,time>2 & time < 5),2);
s1_mod_rs_iti_miss = mean(s1_mod_rs_delta_miss(:,time>2 & time < 5),2);
s1_mod_fs_iti_miss = mean(s1_mod_fs_delta_miss(:,time>2 & time < 5),2);
s1_unmod_rs_iti_miss = mean(s1_unmod_rs_delta_miss(:,time>2 & time < 5),2);
s1_unmod_fs_iti_miss = mean(s1_unmod_fs_delta_miss(:,time>2 & time < 5),2);
s1_mod_rs_iti_cr = mean(s1_mod_rs_delta_cr(:,time>2 & time < 5),2);
s1_mod_fs_iti_cr = mean(s1_mod_fs_delta_cr(:,time>2 & time < 5),2);
s1_unmod_rs_iti_cr = mean(s1_unmod_rs_delta_cr(:,time>2 & time < 5),2);
s1_unmod_fs_iti_cr = mean(s1_unmod_fs_delta_cr(:,time>2 & time < 5),2);
s1_mod_rs_iti_fa = mean(s1_mod_rs_delta_fa(:,time>2 & time < 5),2);
s1_mod_fs_iti_fa = mean(s1_mod_fs_delta_fa(:,time>2 & time < 5),2);
s1_unmod_rs_iti_fa = mean(s1_unmod_rs_delta_fa(:,time>2 & time < 5),2);
s1_unmod_fs_iti_fa = mean(s1_unmod_fs_delta_fa(:,time>2 & time < 5),2);
pfc_mod_rs_iti_hit = mean(pfc_mod_rs_delta_hit(:,time>2 & time < 5),2);
pfc_mod_fs_iti_hit = mean(pfc_mod_fs_delta_hit(:,time>2 & time < 5),2);
pfc_unmod_rs_iti_hit = mean(pfc_unmod_rs_delta_hit(:,time>2 & time < 5),2);
pfc_unmod_fs_iti_hit = mean(pfc_unmod_fs_delta_hit(:,time>2 & time < 5),2);
pfc_mod_rs_iti_miss = mean(pfc_mod_rs_delta_miss(:,time>2 & time < 5),2);
pfc_mod_fs_iti_miss = mean(pfc_mod_fs_delta_miss(:,time>2 & time < 5),2);
pfc_unmod_rs_iti_miss = mean(pfc_unmod_rs_delta_miss(:,time>2 & time < 5),2);
pfc_unmod_fs_iti_miss = mean(pfc_unmod_fs_delta_miss(:,time>2 & time < 5),2);
pfc_mod_rs_iti_cr = mean(pfc_mod_rs_delta_cr(:,time>2 & time < 5),2);
pfc_mod_fs_iti_cr = mean(pfc_mod_fs_delta_cr(:,time>2 & time < 5),2);
pfc_unmod_rs_iti_cr = mean(pfc_unmod_rs_delta_cr(:,time>2 & time < 5),2);
pfc_unmod_fs_iti_cr = mean(pfc_unmod_fs_delta_cr(:,time>2 & time < 5),2);
pfc_mod_rs_iti_fa = mean(pfc_mod_rs_delta_fa(:,time>2 & time < 5),2);
pfc_mod_fs_iti_fa = mean(pfc_mod_fs_delta_fa(:,time>2 & time < 5),2);
pfc_unmod_rs_iti_fa = mean(pfc_unmod_rs_delta_fa(:,time>2 & time < 5),2);
pfc_unmod_fs_iti_fa = mean(pfc_unmod_fs_delta_fa(:,time>2 & time < 5),2);
striatum_mod_rs_iti_hit = mean(striatum_mod_rs_delta_hit(:,time>2 & time < 5),2);
striatum_mod_fs_iti_hit = mean(striatum_mod_fs_delta_hit(:,time>2 & time < 5),2);
striatum_unmod_rs_iti_hit = mean(striatum_unmod_rs_delta_hit(:,time>2 & time < 5),2);
striatum_unmod_fs_iti_hit = mean(striatum_unmod_fs_delta_hit(:,time>2 & time < 5),2);
striatum_mod_rs_iti_miss = mean(striatum_mod_rs_delta_miss(:,time>2 & time < 5),2);
striatum_mod_fs_iti_miss = mean(striatum_mod_fs_delta_miss(:,time>2 & time < 5),2);
striatum_unmod_rs_iti_miss = mean(striatum_unmod_rs_delta_miss(:,time>2 & time < 5),2);
striatum_unmod_fs_iti_miss = mean(striatum_unmod_fs_delta_miss(:,time>2 & time < 5),2);
striatum_mod_rs_iti_cr = mean(striatum_mod_rs_delta_cr(:,time>2 & time < 5),2);
striatum_mod_fs_iti_cr = mean(striatum_mod_fs_delta_cr(:,time>2 & time < 5),2);
striatum_unmod_rs_iti_cr = mean(striatum_unmod_rs_delta_cr(:,time>2 & time < 5),2);
striatum_unmod_fs_iti_cr = mean(striatum_unmod_fs_delta_cr(:,time>2 & time < 5),2);
striatum_mod_rs_iti_fa = mean(striatum_mod_rs_delta_fa(:,time>2 & time < 5),2);
striatum_mod_fs_iti_fa = mean(striatum_mod_fs_delta_fa(:,time>2 & time < 5),2);
striatum_unmod_rs_iti_fa = mean(striatum_unmod_rs_delta_fa(:,time>2 & time < 5),2);
striatum_unmod_fs_iti_fa = mean(striatum_unmod_fs_delta_fa(:,time>2 & time < 5),2);
amygdala_mod_rs_iti_hit = mean(amygdala_mod_rs_delta_hit(:,time>2 & time < 5),2);
amygdala_mod_fs_iti_hit = mean(amygdala_mod_fs_delta_hit(:,time>2 & time < 5),2);
amygdala_unmod_rs_iti_hit = mean(amygdala_unmod_rs_delta_hit(:,time>2 & time < 5),2);
amygdala_unmod_fs_iti_hit = mean(amygdala_unmod_fs_delta_hit(:,time>2 & time < 5),2);
amygdala_mod_rs_iti_miss = mean(amygdala_mod_rs_delta_miss(:,time>2 & time < 5),2);
amygdala_mod_fs_iti_miss = mean(amygdala_mod_fs_delta_miss(:,time>2 & time < 5),2);
amygdala_unmod_rs_iti_miss = mean(amygdala_unmod_rs_delta_miss(:,time>2 & time < 5),2);
amygdala_unmod_fs_iti_miss = mean(amygdala_unmod_fs_delta_miss(:,time>2 & time < 5),2);
amygdala_mod_rs_iti_cr = mean(amygdala_mod_rs_delta_cr(:,time>2 & time < 5),2);
amygdala_mod_fs_iti_cr = mean(amygdala_mod_fs_delta_cr(:,time>2 & time < 5),2);
amygdala_unmod_rs_iti_cr = mean(amygdala_unmod_rs_delta_cr(:,time>2 & time < 5),2);
amygdala_unmod_fs_iti_cr = mean(amygdala_unmod_fs_delta_cr(:,time>2 & time < 5),2);
amygdala_mod_rs_iti_fa = mean(amygdala_mod_rs_delta_fa(:,time>2 & time < 5),2);
amygdala_mod_fs_iti_fa = mean(amygdala_mod_fs_delta_fa(:,time>2 & time < 5),2);
amygdala_unmod_rs_iti_fa = mean(amygdala_unmod_rs_delta_fa(:,time>2 & time < 5),2);
amygdala_unmod_fs_iti_fa = mean(amygdala_unmod_fs_delta_fa(:,time>2 & time < 5),2);

iti_fig = figure();
tl = tiledlayout(3,2);
axs(1,1) = nexttile;
hold on
violinplot(1, s1_mod_rs_iti_hit, 'FaceColor', 'b')
violinplot(2, s1_unmod_rs_iti_hit, 'FaceColor', 'r')
violinplot(4, s1_mod_rs_iti_miss, 'FaceColor', 'b')
violinplot(5, s1_unmod_rs_iti_miss, 'FaceColor', 'r')
violinplot(7, s1_mod_rs_iti_cr, 'FaceColor', 'b')
violinplot(8, s1_unmod_rs_iti_cr, 'FaceColor', 'r')
violinplot(10, s1_mod_rs_iti_fa, 'FaceColor', 'b')
violinplot(11, s1_unmod_rs_iti_fa, 'FaceColor', 'r')
xticks([1.5:3:10.5])
xticklabels({'Hit', 'Miss', 'CR', 'FA'})
ylabel('S1')
title('Regular Spiking')

axs(1,2) = nexttile;
hold on
violinplot(1, s1_mod_fs_iti_hit, 'FaceColor', 'b')
violinplot(2, s1_unmod_fs_iti_hit, 'FaceColor', 'r')
violinplot(4, s1_mod_fs_iti_miss, 'FaceColor', 'b')
violinplot(5, s1_unmod_fs_iti_miss, 'FaceColor', 'r')
violinplot(7, s1_mod_fs_iti_cr, 'FaceColor', 'b')
violinplot(8, s1_unmod_fs_iti_cr, 'FaceColor', 'r')
violinplot(10, s1_mod_fs_iti_fa, 'FaceColor', 'b')
violinplot(11, s1_unmod_fs_iti_fa, 'FaceColor', 'r')
xticks([1.5:3:10.5])
xticklabels({'Hit', 'Miss', 'CR', 'FA'})
title('Fast Spiking')

axs(2,1) = nexttile;
hold on
violinplot(1, pfc_mod_rs_iti_hit, 'FaceColor', 'b')
violinplot(2, pfc_unmod_rs_iti_hit, 'FaceColor', 'r')
violinplot(4, pfc_mod_rs_iti_miss, 'FaceColor', 'b')
violinplot(5, pfc_unmod_rs_iti_miss, 'FaceColor', 'r')
violinplot(7, pfc_mod_rs_iti_cr, 'FaceColor', 'b')
violinplot(8, pfc_unmod_rs_iti_cr, 'FaceColor', 'r')
violinplot(10, pfc_mod_rs_iti_fa, 'FaceColor', 'b')
violinplot(11, pfc_unmod_rs_iti_fa, 'FaceColor', 'r')
xticks([1.5:3:10.5])
xticklabels({'Hit', 'Miss', 'CR', 'FA'})
ylabel('PFC')

axs(2,2) = nexttile;
hold on
violinplot(1, pfc_mod_fs_iti_hit, 'FaceColor', 'b')
violinplot(2, pfc_unmod_fs_iti_hit, 'FaceColor', 'r')
violinplot(4, pfc_mod_fs_iti_miss, 'FaceColor', 'b')
violinplot(5, pfc_unmod_fs_iti_miss, 'FaceColor', 'r')
violinplot(7, pfc_mod_fs_iti_cr, 'FaceColor', 'b')
violinplot(8, pfc_unmod_fs_iti_cr, 'FaceColor', 'r')
violinplot(10, pfc_mod_fs_iti_fa, 'FaceColor', 'b')
violinplot(11, pfc_unmod_fs_iti_fa, 'FaceColor', 'r')
xticks([1.5:3:10.5])
xticklabels({'Hit', 'Miss', 'CR', 'FA'})

axs(3,1) = nexttile;
hold on
violinplot(1, striatum_mod_rs_iti_hit, 'FaceColor', 'b')
violinplot(2, striatum_unmod_rs_iti_hit, 'FaceColor', 'r')
violinplot(4, striatum_mod_rs_iti_miss, 'FaceColor', 'b')
violinplot(5, striatum_unmod_rs_iti_miss, 'FaceColor', 'r')
violinplot(7, striatum_mod_rs_iti_cr, 'FaceColor', 'b')
violinplot(8, striatum_unmod_rs_iti_cr, 'FaceColor', 'r')
violinplot(10, striatum_mod_rs_iti_fa, 'FaceColor', 'b')
violinplot(11, striatum_unmod_rs_iti_fa, 'FaceColor', 'r')
xticks([1.5:3:10.5])
xticklabels({'Hit', 'Miss', 'CR', 'FA'})
ylabel('Striatum')

axs(3,2) = nexttile;
hold on
violinplot(1, striatum_mod_fs_iti_hit, 'FaceColor', 'b')
violinplot(2, striatum_unmod_fs_iti_hit, 'FaceColor', 'r')
violinplot(4, striatum_mod_fs_iti_miss, 'FaceColor', 'b')
violinplot(5, striatum_unmod_fs_iti_miss, 'FaceColor', 'r')
violinplot(7, striatum_mod_fs_iti_cr, 'FaceColor', 'b')
violinplot(8, striatum_unmod_fs_iti_cr, 'FaceColor', 'r')
violinplot(10, striatum_mod_fs_iti_fa, 'FaceColor', 'b')
violinplot(11, striatum_unmod_fs_iti_fa, 'FaceColor', 'r')
xticks([1.5:3:10.5])
xticklabels({'Hit', 'Miss', 'CR', 'FA'})
xlabel(tl, 'Trial Outcome')
ylabel(tl, 'ITI \Delta Firing Rate from Baseline (Hz)')

fprintf('\n\nMod vs. Unmod on hit trials\n')
if KStest(s1_mod_rs_iti_hit) || KStest(s1_unmod_rs_iti_hit)
    fprintf(sprintf('S1 mod RS vs unmod RS iti fr (Mann-Whitney): p = %d\n', ranksum(s1_mod_rs_iti_hit, s1_unmod_rs_iti_hit)))
else
    [a,p] = ttest2(s1_mod_rs_iti_hit, s1_unmod_rs_iti_hit);
    fprintf(sprintf('S1 mod RS vs unmod RS iti fr (2 sample t-test): p = %d\n', p))
end
if KStest(s1_mod_fs_iti_hit) || KStest(s1_unmod_fs_iti_hit)
    fprintf(sprintf('S1 mod fs vs unmod fs iti fr (Mann-Whitney): p = %d\n', ranksum(s1_mod_fs_iti_hit, s1_unmod_fs_iti_hit)))
else
    [a,p] = ttest2(s1_mod_fs_iti_hit, s1_unmod_fs_iti_hit);
    fprintf(sprintf('S1 mod fs vs unmod fs iti fr (2 sample t-test): p = %d\n', p))
end
if KStest(pfc_mod_rs_iti_hit) || KStest(pfc_unmod_rs_iti_hit)
    fprintf(sprintf('PFC mod RS vs unmod RS iti fr (Mann-Whitney): p = %d\n', ranksum(pfc_mod_rs_iti_hit, pfc_unmod_rs_iti_hit)))
else
    [a,p] = ttest2(pfc_mod_rs_iti_hit, pfc_unmod_rs_iti_hit);
    fprintf(sprintf('PFC mod RS vs unmod RS iti fr (2 sample t-test): p = %d\n', p))
end
if KStest(pfc_mod_fs_iti_hit) || KStest(pfc_unmod_fs_iti_hit)
    fprintf(sprintf('PFC mod fs vs unmod fs iti fr (Mann-Whitney): p = %d\n', ranksum(pfc_mod_fs_iti_hit, pfc_unmod_fs_iti_hit)))
else
    [a,p] = ttest2(pfc_mod_fs_iti_hit, pfc_unmod_fs_iti_hit);
    fprintf(sprintf('PFC mod fs vs unmod fs iti fr (2 sample t-test): p = %d\n', p))
end
if KStest(striatum_mod_rs_iti_hit) || KStest(striatum_unmod_rs_iti_hit)
    fprintf(sprintf('Striatum mod RS vs unmod RS iti fr (Mann-Whitney): p = %d\n', ranksum(striatum_mod_rs_iti_hit, striatum_unmod_rs_iti_hit)))
else
    [a,p] = ttest2(striatum_mod_rs_iti_hit, striatum_unmod_rs_iti_hit);
    fprintf(sprintf('Striatum mod RS vs unmod RS iti fr (2 sample t-test): p = %d\n', p))
end
if KStest(striatum_mod_fs_iti_hit) || KStest(striatum_unmod_fs_iti_hit)
    fprintf(sprintf('Striatum mod fs vs unmod fs iti fr (Mann-Whitney): p = %d\n', ranksum(striatum_mod_fs_iti_hit, striatum_unmod_fs_iti_hit)))
else
    [a,p] = ttest2(striatum_mod_fs_iti_hit, striatum_unmod_fs_iti_hit);
    fprintf(sprintf('Striatum mod fs vs unmod fs iti fr (2 sample t-test): p = %d\n', p))
end

%% rs mod vs unmod frs
rs_mod_vs_unmod_fr_fig = figure('Position', [1151 841 1850 1081]);
tl = tiledlayout(3,4);
axs(1,1) = nexttile;
semshade(s1_mod_rs_hit-mean(s1_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_rs_hit-mean(s1_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
yticks([-1,3])
xticks([])
ax = gca;
ax.YAxis.FontSize = 14;
plot([1.2, 1.2], [-3, 8], 'k--', 'HandleVisibility','off')
title('Hit', 'FontWeight', 'normal', 'FontSize', 16)
ylabel('S1', 'FontSize', 16)
axs(1,2) = nexttile;
semshade(s1_mod_rs_miss-mean(s1_mod_rs_miss(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_rs_miss-mean(s1_unmod_rs_miss(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
yticks([])
xticks([])
title('Miss', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,3) = nexttile;
semshade(s1_mod_rs_cr-mean(s1_mod_rs_cr(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_rs_cr-mean(s1_unmod_rs_cr(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
yticks([])
xticks([])
title('Correct Rejection', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,4) = nexttile;
semshade(s1_mod_rs_fa-mean(s1_mod_rs_fa(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_rs_fa-mean(s1_unmod_rs_fa(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
yticks([])
xticks([])
title('False Alarm', 'FontWeight', 'normal', 'FontSize', 16)
axs(2,1) = nexttile;
semshade(pfc_mod_rs_hit-mean(pfc_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_rs_hit-mean(pfc_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
yticks([-1,3])
xticks([])
ax = gca;
ax.YAxis.FontSize = 14;
plot([1.2, 1.2], [-3, 8], 'k--', 'HandleVisibility','off')
ylabel('PFC', 'FontSize', 16)
axs(2,2) = nexttile;
semshade(pfc_mod_rs_miss-mean(pfc_mod_rs_miss(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_rs_miss-mean(pfc_unmod_rs_miss(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
yticks([])
xticks([])
axs(2,3) = nexttile;
semshade(pfc_mod_rs_cr-mean(pfc_mod_rs_cr(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_rs_cr-mean(pfc_unmod_rs_cr(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
yticks([])
xticks([])
axs(2,4) = nexttile;
semshade(pfc_mod_rs_fa-mean(pfc_mod_rs_fa(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_rs_fa-mean(pfc_unmod_rs_fa(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
yticks([])
xticks([])
axs(3,1) = nexttile;
semshade(striatum_mod_rs_hit-mean(striatum_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_rs_hit-mean(striatum_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,35])
yticks([-5,35])
ax = gca;
ax.YAxis.FontSize = 14;
ax.XAxis.FontSize = 14;
plot([1.2, 1.2], [-5, 35], 'k--', 'HandleVisibility','off')
ylabel('Striatum', 'FontSize', 16)
axs(3,2) = nexttile;
semshade(striatum_mod_rs_miss-mean(striatum_mod_rs_miss(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_rs_miss-mean(striatum_unmod_rs_miss(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,35])
yticks([])
ax = gca;
ax.XAxis.FontSize = 14;
axs(3,3) = nexttile;
semshade(striatum_mod_rs_cr-mean(striatum_mod_rs_cr(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_rs_cr-mean(striatum_unmod_rs_cr(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,35])
yticks([])
ax = gca;
ax.XAxis.FontSize = 14;
axs(3,4) = nexttile;
semshade(striatum_mod_rs_fa-mean(striatum_mod_rs_fa(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_rs_fa-mean(striatum_unmod_rs_fa(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,35])
yticks([])
ax = gca;
ax.XAxis.FontSize = 14;
xlabel(tl, 'Time (s)', 'FontSize', 16)
ylabel(tl, '\Delta Firing Rate (Hz)', 'FontSize', 16)
outcomes = {'Hit', 'Miss', 'Correct Rejection', 'False Alarm'};
for c = 1:4
    axes(axs(1,c))
    title(outcomes{c}, 'FontWeight', 'normal', 'FontSize', 16)
end
title(tl, 'Regular Spiking Units', 'FontSize', 16, 'FontWeight', 'normal')

%% fs mod vs unmod frs
fs_mod_vs_unmod_fr_fig = figure('Position', [1151 841 1850 1081]);
tl = tiledlayout(3,4);
axs(1,1) = nexttile;
semshade(s1_mod_fs_hit-mean(s1_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_fs_hit-mean(s1_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
plot([1.2, 1.2], [-5, 15], 'k--', 'HandleVisibility','off')
title('Hit', 'FontWeight', 'normal', 'FontSize', 16)
ylabel('S1', 'FontSize', 16)
xticks([])
yticks([-5,15])
ax = gca;
ax.YAxis.FontSize = 14;
axs(1,2) = nexttile;
semshade(s1_mod_fs_miss-mean(s1_mod_fs_miss(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_fs_miss-mean(s1_unmod_fs_miss(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
title('Miss', 'FontWeight', 'normal', 'FontSize', 16)
xticks([])
yticks([])
axs(1,3) = nexttile;
semshade(s1_mod_fs_cr-mean(s1_mod_fs_cr(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_fs_cr-mean(s1_unmod_fs_cr(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
title('Correct Rejection', 'FontWeight', 'normal', 'FontSize', 16)
xticks([])
yticks([])
axs(1,4) = nexttile;
semshade(s1_mod_fs_fa-mean(s1_mod_fs_fa(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_fs_fa-mean(s1_unmod_fs_fa(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
title('False Alarm', 'FontWeight', 'normal', 'FontSize', 16)
xticks([])
yticks([])
axs(2,1) = nexttile;
semshade(pfc_mod_fs_hit-mean(pfc_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_fs_hit-mean(pfc_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
plot([1.2, 1.2], [-5, 15], 'k--', 'HandleVisibility','off')
xticks([])
yticks([-5,15])
ylabel('PFC', 'FontSize', 16)
ax = gca;
ax.YAxis.FontSize = 14;
axs(2,2) = nexttile;
semshade(pfc_mod_fs_miss-mean(pfc_mod_fs_miss(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_fs_miss-mean(pfc_unmod_fs_miss(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
xticks([])
yticks([])
axs(2,3) = nexttile;
semshade(pfc_mod_fs_cr-mean(pfc_mod_fs_cr(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_fs_cr-mean(pfc_unmod_fs_cr(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
xticks([])
yticks([])
axs(2,4) = nexttile;
semshade(pfc_mod_fs_fa-mean(pfc_mod_fs_fa(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_fs_fa-mean(pfc_unmod_fs_fa(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
xticks([])
yticks([])
axs(3,1) = nexttile;
semshade(striatum_mod_fs_hit-mean(striatum_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_fs_hit-mean(striatum_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
yticks([-5,15])
plot([1.2, 1.2], [-5, 15], 'k--', 'HandleVisibility','off')
ylabel('Striatum', 'FontSize', 16)
ax = gca;
ax.YAxis.FontSize = 14;
ax.XAxis.FontSize = 14;
axs(3,2) = nexttile;
semshade(striatum_mod_fs_miss-mean(striatum_mod_fs_miss(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_fs_miss-mean(striatum_unmod_fs_miss(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
yticks([])
ax = gca;
ax.XAxis.FontSize = 14;
axs(3,3) = nexttile;
semshade(striatum_mod_fs_cr-mean(striatum_mod_fs_cr(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_fs_cr-mean(striatum_unmod_fs_cr(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
yticks([])
ax = gca;
ax.XAxis.FontSize = 14;
axs(3,4) = nexttile;
semshade(striatum_mod_fs_fa-mean(striatum_mod_fs_fa(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_fs_fa-mean(striatum_unmod_fs_fa(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
yticks([])
ax = gca;
ax.XAxis.FontSize = 14;
xlabel(tl, 'Time (s)', 'FontSize', 16)
ylabel(tl, '\Delta Firing Rate (Hz)', 'FontSize', 16)
outcomes = {'Hit', 'Miss', 'Correct Rejection', 'False Alarm'};
for c = 1:4
    axes(axs(1,c))
    title(outcomes{c}, 'FontWeight', 'normal', 'FontSize', 16)
end
title(tl, 'Fast Spiking Units', 'FontSize', 16, 'FontWeight', 'normal')

%% suppressed, drive, non-responders 
s1_mod_driven_rs_delta_hit = s1_mod_rs_delta_hit(s1_mod_rs_evoked_hit > 1,:);
s1_mod_suppressed_rs_delta_hit = s1_mod_rs_delta_hit(s1_mod_rs_evoked_hit < -1,:);
s1_unmod_driven_rs_delta_hit = s1_unmod_rs_delta_hit(s1_unmod_rs_evoked_hit > 1,:);
s1_unmod_suppressed_rs_delta_hit = s1_unmod_rs_delta_hit(s1_unmod_rs_evoked_hit < -1,:);
pfc_mod_driven_rs_delta_hit = pfc_mod_rs_delta_hit(pfc_mod_rs_evoked_hit > 1,:);
pfc_mod_suppressed_rs_delta_hit = pfc_mod_rs_delta_hit(pfc_mod_rs_evoked_hit < -1,:);
pfc_unmod_driven_rs_delta_hit = pfc_unmod_rs_delta_hit(pfc_unmod_rs_evoked_hit > 1,:);
pfc_unmod_suppressed_rs_delta_hit = pfc_unmod_rs_delta_hit(pfc_unmod_rs_evoked_hit < -1,:);
striatum_mod_driven_rs_delta_hit = striatum_mod_rs_delta_hit(striatum_mod_rs_evoked_hit > 1,:);
striatum_mod_suppressed_rs_delta_hit = striatum_mod_rs_delta_hit(striatum_mod_rs_evoked_hit < -1,:);
striatum_unmod_driven_rs_delta_hit = striatum_unmod_rs_delta_hit(striatum_unmod_rs_evoked_hit > 1,:);
striatum_unmod_suppressed_rs_delta_hit = striatum_unmod_rs_delta_hit(striatum_unmod_rs_evoked_hit < -1,:);
s1_mod_driven_fs_delta_hit = s1_mod_fs_delta_hit(s1_mod_fs_evoked_hit > 1,:);
s1_mod_suppressed_fs_delta_hit = s1_mod_fs_delta_hit(s1_mod_fs_evoked_hit < -1,:);
s1_unmod_driven_fs_delta_hit = s1_unmod_fs_delta_hit(s1_unmod_fs_evoked_hit > 1,:);
s1_unmod_suppressed_fs_delta_hit = s1_unmod_fs_delta_hit(s1_unmod_fs_evoked_hit < -1,:);
pfc_mod_driven_fs_delta_hit = pfc_mod_fs_delta_hit(pfc_mod_fs_evoked_hit > 1,:);
pfc_mod_suppressed_fs_delta_hit = pfc_mod_fs_delta_hit(pfc_mod_fs_evoked_hit < -1,:);
pfc_unmod_driven_fs_delta_hit = pfc_unmod_fs_delta_hit(pfc_unmod_fs_evoked_hit > 1,:);
pfc_unmod_suppressed_fs_delta_hit = pfc_unmod_fs_delta_hit(pfc_unmod_fs_evoked_hit < -1,:);
striatum_mod_driven_fs_delta_hit = striatum_mod_fs_delta_hit(striatum_mod_fs_evoked_hit > 1,:);
striatum_mod_suppressed_fs_delta_hit = striatum_mod_fs_delta_hit(striatum_mod_fs_evoked_hit < -1,:);
striatum_unmod_driven_fs_delta_hit = striatum_unmod_fs_delta_hit(striatum_unmod_fs_evoked_hit > 1,:);
striatum_unmod_suppressed_fs_delta_hit = striatum_unmod_fs_delta_hit(striatum_unmod_fs_evoked_hit < -1,:);
s1_mod_driven_rs_delta_miss = s1_mod_rs_delta_miss(s1_mod_rs_evoked_hit > 1,:);
s1_mod_suppressed_rs_delta_miss = s1_mod_rs_delta_miss(s1_mod_rs_evoked_hit < -1,:);
s1_unmod_driven_rs_delta_miss = s1_unmod_rs_delta_miss(s1_unmod_rs_evoked_hit > 1,:);
s1_unmod_suppressed_rs_delta_miss = s1_unmod_rs_delta_miss(s1_unmod_rs_evoked_hit < -1,:);
pfc_mod_driven_rs_delta_miss = pfc_mod_rs_delta_miss(pfc_mod_rs_evoked_hit > 1,:);
pfc_mod_suppressed_rs_delta_miss = pfc_mod_rs_delta_miss(pfc_mod_rs_evoked_hit < -1,:);
pfc_unmod_driven_rs_delta_miss = pfc_unmod_rs_delta_miss(pfc_unmod_rs_evoked_hit > 1,:);
pfc_unmod_suppressed_rs_delta_miss = pfc_unmod_rs_delta_miss(pfc_unmod_rs_evoked_hit < -1,:);
striatum_mod_driven_rs_delta_miss = striatum_mod_rs_delta_miss(striatum_mod_rs_evoked_hit > 1,:);
striatum_mod_suppressed_rs_delta_miss = striatum_mod_rs_delta_miss(striatum_mod_rs_evoked_hit < -1,:);
striatum_unmod_driven_rs_delta_miss = striatum_unmod_rs_delta_miss(striatum_unmod_rs_evoked_hit > 1,:);
striatum_unmod_suppressed_rs_delta_miss = striatum_unmod_rs_delta_miss(striatum_unmod_rs_evoked_hit < -1,:);
s1_mod_driven_fs_delta_miss = s1_mod_fs_delta_miss(s1_mod_fs_evoked_hit > 1,:);
s1_mod_suppressed_fs_delta_miss = s1_mod_fs_delta_miss(s1_mod_fs_evoked_hit < -1,:);
s1_unmod_driven_fs_delta_miss = s1_unmod_fs_delta_miss(s1_unmod_fs_evoked_hit > 1,:);
s1_unmod_suppressed_fs_delta_miss = s1_unmod_fs_delta_miss(s1_unmod_fs_evoked_hit < -1,:);
pfc_mod_driven_fs_delta_miss = pfc_mod_fs_delta_miss(pfc_mod_fs_evoked_hit > 1,:);
pfc_mod_suppressed_fs_delta_miss = pfc_mod_fs_delta_miss(pfc_mod_fs_evoked_hit < -1,:);
pfc_unmod_driven_fs_delta_miss = pfc_unmod_fs_delta_miss(pfc_unmod_fs_evoked_hit > 1,:);
pfc_unmod_suppressed_fs_delta_miss = pfc_unmod_fs_delta_miss(pfc_unmod_fs_evoked_hit < -1,:);
striatum_mod_driven_fs_delta_miss = striatum_mod_fs_delta_miss(striatum_mod_fs_evoked_hit > 1,:);
striatum_mod_suppressed_fs_delta_miss = striatum_mod_fs_delta_miss(striatum_mod_fs_evoked_hit < -1,:);
striatum_unmod_driven_fs_delta_miss = striatum_unmod_fs_delta_miss(striatum_unmod_fs_evoked_hit > 1,:);
striatum_unmod_suppressed_fs_delta_miss = striatum_unmod_fs_delta_miss(striatum_unmod_fs_evoked_hit < -1,:);
s1_mod_driven_rs_delta_cr = s1_mod_rs_delta_cr(s1_mod_rs_evoked_hit > 1,:);
s1_mod_suppressed_rs_delta_cr = s1_mod_rs_delta_cr(s1_mod_rs_evoked_hit < -1,:);
s1_unmod_driven_rs_delta_cr = s1_unmod_rs_delta_cr(s1_unmod_rs_evoked_hit > 1,:);
s1_unmod_suppressed_rs_delta_cr = s1_unmod_rs_delta_cr(s1_unmod_rs_evoked_hit < -1,:);
pfc_mod_driven_rs_delta_cr = pfc_mod_rs_delta_cr(pfc_mod_rs_evoked_hit > 1,:);
pfc_mod_suppressed_rs_delta_cr = pfc_mod_rs_delta_cr(pfc_mod_rs_evoked_hit < -1,:);
pfc_unmod_driven_rs_delta_cr = pfc_unmod_rs_delta_cr(pfc_unmod_rs_evoked_hit > 1,:);
pfc_unmod_suppressed_rs_delta_cr = pfc_unmod_rs_delta_cr(pfc_unmod_rs_evoked_hit < -1,:);
striatum_mod_driven_rs_delta_cr = striatum_mod_rs_delta_cr(striatum_mod_rs_evoked_hit > 1,:);
striatum_mod_suppressed_rs_delta_cr = striatum_mod_rs_delta_cr(striatum_mod_rs_evoked_hit < -1,:);
striatum_unmod_driven_rs_delta_cr = striatum_unmod_rs_delta_cr(striatum_unmod_rs_evoked_hit > 1,:);
striatum_unmod_suppressed_rs_delta_cr = striatum_unmod_rs_delta_cr(striatum_unmod_rs_evoked_hit < -1,:);
s1_mod_driven_fs_delta_cr = s1_mod_fs_delta_cr(s1_mod_fs_evoked_hit > 1,:);
s1_mod_suppressed_fs_delta_cr = s1_mod_fs_delta_cr(s1_mod_fs_evoked_hit < -1,:);
s1_unmod_driven_fs_delta_cr = s1_unmod_fs_delta_cr(s1_unmod_fs_evoked_hit > 1,:);
s1_unmod_suppressed_fs_delta_cr = s1_unmod_fs_delta_cr(s1_unmod_fs_evoked_hit < -1,:);
pfc_mod_driven_fs_delta_cr = pfc_mod_fs_delta_cr(pfc_mod_fs_evoked_hit > 1,:);
pfc_mod_suppressed_fs_delta_cr = pfc_mod_fs_delta_cr(pfc_mod_fs_evoked_hit < -1,:);
pfc_unmod_driven_fs_delta_cr = pfc_unmod_fs_delta_cr(pfc_unmod_fs_evoked_hit > 1,:);
pfc_unmod_suppressed_fs_delta_cr = pfc_unmod_fs_delta_cr(pfc_unmod_fs_evoked_hit < -1,:);
striatum_mod_driven_fs_delta_cr = striatum_mod_fs_delta_cr(striatum_mod_fs_evoked_hit > 1,:);
striatum_mod_suppressed_fs_delta_cr = striatum_mod_fs_delta_cr(striatum_mod_fs_evoked_hit < -1,:);
striatum_unmod_driven_fs_delta_cr = striatum_unmod_fs_delta_cr(striatum_unmod_fs_evoked_hit > 1,:);
striatum_unmod_suppressed_fs_delta_cr = striatum_unmod_fs_delta_cr(striatum_unmod_fs_evoked_hit < -1,:);
s1_mod_driven_rs_delta_fa = s1_mod_rs_delta_fa(s1_mod_rs_evoked_hit > 1,:);
s1_mod_suppressed_rs_delta_fa = s1_mod_rs_delta_fa(s1_mod_rs_evoked_hit < -1,:);
s1_unmod_driven_rs_delta_fa = s1_unmod_rs_delta_fa(s1_unmod_rs_evoked_hit > 1,:);
s1_unmod_suppressed_rs_delta_fa = s1_unmod_rs_delta_fa(s1_unmod_rs_evoked_hit < -1,:);
pfc_mod_driven_rs_delta_fa = pfc_mod_rs_delta_fa(pfc_mod_rs_evoked_hit > 1,:);
pfc_mod_suppressed_rs_delta_fa = pfc_mod_rs_delta_fa(pfc_mod_rs_evoked_hit < -1,:);
pfc_unmod_driven_rs_delta_fa = pfc_unmod_rs_delta_fa(pfc_unmod_rs_evoked_hit > 1,:);
pfc_unmod_suppressed_rs_delta_fa = pfc_unmod_rs_delta_fa(pfc_unmod_rs_evoked_hit < -1,:);
striatum_mod_driven_rs_delta_fa = striatum_mod_rs_delta_fa(striatum_mod_rs_evoked_hit > 1,:);
striatum_mod_suppressed_rs_delta_fa = striatum_mod_rs_delta_fa(striatum_mod_rs_evoked_hit < -1,:);
striatum_unmod_driven_rs_delta_fa = striatum_unmod_rs_delta_fa(striatum_unmod_rs_evoked_hit > 1,:);
striatum_unmod_suppressed_rs_delta_fa = striatum_unmod_rs_delta_fa(striatum_unmod_rs_evoked_hit < -1,:);
s1_mod_driven_fs_delta_fa = s1_mod_fs_delta_fa(s1_mod_fs_evoked_hit > 1,:);
s1_mod_suppressed_fs_delta_fa = s1_mod_fs_delta_fa(s1_mod_fs_evoked_hit < -1,:);
s1_unmod_driven_fs_delta_fa = s1_unmod_fs_delta_fa(s1_unmod_fs_evoked_hit > 1,:);
s1_unmod_suppressed_fs_delta_fa = s1_unmod_fs_delta_fa(s1_unmod_fs_evoked_hit < -1,:);
pfc_mod_driven_fs_delta_fa = pfc_mod_fs_delta_fa(pfc_mod_fs_evoked_hit > 1,:);
pfc_mod_suppressed_fs_delta_fa = pfc_mod_fs_delta_fa(pfc_mod_fs_evoked_hit < -1,:);
pfc_unmod_driven_fs_delta_fa = pfc_unmod_fs_delta_fa(pfc_unmod_fs_evoked_hit > 1,:);
pfc_unmod_suppressed_fs_delta_fa = pfc_unmod_fs_delta_fa(pfc_unmod_fs_evoked_hit < -1,:);
striatum_mod_driven_fs_delta_fa = striatum_mod_fs_delta_fa(striatum_mod_fs_evoked_hit > 1,:);
striatum_mod_suppressed_fs_delta_fa = striatum_mod_fs_delta_fa(striatum_mod_fs_evoked_hit < -1,:);
striatum_unmod_driven_fs_delta_fa = striatum_unmod_fs_delta_fa(striatum_unmod_fs_evoked_hit > 1,:);
striatum_unmod_suppressed_fs_delta_fa = striatum_unmod_fs_delta_fa(striatum_unmod_fs_evoked_hit < -1,:);

%% rs mod_driven vs unmod_driven frs
rs_mod_driven_vs_unmod_driven_fr_fig = figure('Position', [1151 841 1850 1081]);
tl = tiledlayout(3,4);
axs(1,1) = nexttile;
semshade(s1_mod_driven_rs_delta_hit, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_driven_rs_delta_hit, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-3,8])
plot([1.2, 1.2], [-3, 8], 'k--', 'HandleVisibility','off')
title('Hit', 'FontWeight', 'normal', 'FontSize', 16)
ylabel('S1', 'FontSize', 16)
axs(1,2) = nexttile;
semshade(s1_mod_driven_rs_delta_miss, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_driven_rs_delta_miss, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-3,8])
title('Miss', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,3) = nexttile;
semshade(s1_mod_driven_rs_delta_cr, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_driven_rs_delta_cr, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-3,8])
title('Correct Rejection', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,4) = nexttile;
semshade(s1_mod_driven_rs_delta_fa, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_driven_rs_delta_fa, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-3,8])
title('False Alarm', 'FontWeight', 'normal', 'FontSize', 16)

axs(2,1) = nexttile;
semshade(pfc_mod_driven_rs_delta_hit, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_driven_rs_delta_hit, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-3,8])
plot([1.2, 1.2], [-3, 8], 'k--', 'HandleVisibility','off')
ylabel('PFC', 'FontSize', 16)
axs(2,2) = nexttile;
semshade(pfc_mod_driven_rs_delta_miss, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_driven_rs_delta_miss, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-3,8])
axs(2,3) = nexttile;
semshade(pfc_mod_driven_rs_delta_cr, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_driven_rs_delta_cr, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-3,8])
axs(2,4) = nexttile;
semshade(pfc_mod_driven_rs_delta_fa, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_driven_rs_delta_fa, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-3,8])

axs(3,1) = nexttile;
semshade(striatum_mod_driven_rs_delta_hit, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_driven_rs_delta_hit, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,35])
plot([1.2, 1.2], [-5, 35], 'k--', 'HandleVisibility','off')
ylabel('Striatum', 'FontSize', 16)
axs(3,2) = nexttile;
semshade(striatum_mod_driven_rs_delta_miss, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_driven_rs_delta_miss, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,35])
axs(3,3) = nexttile;
semshade(striatum_mod_driven_rs_delta_cr, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_driven_rs_delta_cr, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,35])
axs(3,4) = nexttile;
semshade(striatum_mod_driven_rs_delta_fa, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_driven_rs_delta_fa, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,35])
xlabel(tl, 'Time (s)', 'FontSize', 16)
ylabel(tl, '\Delta Firing Rate (Hz)', 'FontSize', 16)
outcomes = {'Hit', 'Miss', 'Correct Rejection', 'False Alarm'};
for c = 1:4
    axes(axs(1,c))
    title(outcomes{c}, 'FontWeight', 'normal', 'FontSize', 16)
end
title(tl, 'Stim. Driven RS Units', 'FontSize', 16, 'FontWeight', 'normal')

%% fs mod_driven vs unmod_driven ffs
fs_mod_driven_vs_unmod_driven_fr_fig = figure('Position', [1151 841 1850 1081]);
tl = tiledlayout(3,4);
axs(1,1) = nexttile;
semshade(s1_mod_driven_fs_delta_hit, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_driven_fs_delta_hit, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,20])
plot([1.2, 1.2], [-5, 20], 'k--', 'HandleVisibility','off')
title('Hit', 'FontWeight', 'normal', 'FontSize', 16)
ylabel('S1', 'FontSize', 16)
axs(1,2) = nexttile;
semshade(s1_mod_driven_fs_delta_miss, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_driven_fs_delta_miss, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,20])
title('Miss', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,3) = nexttile;
semshade(s1_mod_driven_fs_delta_cr, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_driven_fs_delta_cr, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,20])
title('Correct Rejection', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,4) = nexttile;
semshade(s1_mod_driven_fs_delta_fa, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_driven_fs_delta_fa, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,20])
title('False Alarm', 'FontWeight', 'normal', 'FontSize', 16)

axs(2,1) = nexttile;
semshade(pfc_mod_driven_fs_delta_hit, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_driven_fs_delta_hit, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,20])
plot([1.2, 1.2], [-5, 20], 'k--', 'HandleVisibility','off')
ylabel('PFC', 'FontSize', 16)
axs(2,2) = nexttile;
semshade(pfc_mod_driven_fs_delta_miss, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_driven_fs_delta_miss, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,20])
axs(2,3) = nexttile;
semshade(pfc_mod_driven_fs_delta_cr, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_driven_fs_delta_cr, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,20])
axs(2,4) = nexttile;
semshade(pfc_mod_driven_fs_delta_fa, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_driven_fs_delta_fa, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,20])

axs(3,1) = nexttile;
semshade(striatum_mod_driven_fs_delta_hit, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_driven_fs_delta_hit, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,20])
plot([1.2, 1.2], [-5, 35], 'k--', 'HandleVisibility','off')
ylabel('Striatum', 'FontSize', 16)
axs(3,2) = nexttile;
semshade(striatum_mod_driven_fs_delta_miss, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_driven_fs_delta_miss, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,20])
axs(3,3) = nexttile;
semshade(striatum_mod_driven_fs_delta_cr, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_driven_fs_delta_cr, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,20])
axs(3,4) = nexttile;
semshade(striatum_mod_driven_fs_delta_fa, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_driven_fs_delta_fa, 0.3, 'r', 'r', time, 1, 'Unmod_drivenulated');
xlim([-2.8,4.8])
ylim([-5,20])
xlabel(tl, 'Time (s)', 'FontSize', 16)
ylabel(tl, '\Delta Firing Rate (Hz)', 'FontSize', 16)
outcomes = {'Hit', 'Miss', 'Correct Rejection', 'False Alarm'};
for c = 1:4
    axes(axs(1,c))
    title(outcomes{c}, 'FontWeight', 'normal', 'FontSize', 16)
end
title(tl, 'Stim. Driven FS Units', 'FontSize', 16, 'FontWeight', 'normal')

%% rs mod_suppressed vs unmod_suppressed frs
rs_mod_suppressed_vs_unmod_suppressed_fr_fig = figure('Position', [1151 841 1850 1081]);
tl = tiledlayout(3,4);
axs(1,1) = nexttile;
semshade(s1_mod_suppressed_rs_delta_hit, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_suppressed_rs_delta_hit, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-5,5])
plot([1.2, 1.2], [-5,5], 'k--', 'HandleVisibility','off')
title('Hit', 'FontWeight', 'normal', 'FontSize', 16)
ylabel('S1', 'FontSize', 16)
axs(1,2) = nexttile;
semshade(s1_mod_suppressed_rs_delta_miss, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_suppressed_rs_delta_miss, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-5,5])
title('Miss', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,3) = nexttile;
semshade(s1_mod_suppressed_rs_delta_cr, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_suppressed_rs_delta_cr, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-5,5])
title('Correct Rejection', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,4) = nexttile;
semshade(s1_mod_suppressed_rs_delta_fa, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_suppressed_rs_delta_fa, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-5,5])
title('False Alarm', 'FontWeight', 'normal', 'FontSize', 16)

axs(2,1) = nexttile;
semshade(pfc_mod_suppressed_rs_delta_hit, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_suppressed_rs_delta_hit, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-5,5])
plot([1.2, 1.2], [-5,5], 'k--', 'HandleVisibility','off')
ylabel('PFC', 'FontSize', 16)
axs(2,2) = nexttile;
semshade(pfc_mod_suppressed_rs_delta_miss, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_suppressed_rs_delta_miss, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-5,5])
axs(2,3) = nexttile;
semshade(pfc_mod_suppressed_rs_delta_cr, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_suppressed_rs_delta_cr, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-5,5])
axs(2,4) = nexttile;
semshade(pfc_mod_suppressed_rs_delta_fa, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_suppressed_rs_delta_fa, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-5,5])

axs(3,1) = nexttile;
semshade(striatum_mod_suppressed_rs_delta_hit, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_suppressed_rs_delta_hit, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-5,5])
plot([1.2, 1.2], [-5, 35], 'k--', 'HandleVisibility','off')
ylabel('Striatum', 'FontSize', 16)
axs(3,2) = nexttile;
semshade(striatum_mod_suppressed_rs_delta_miss, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_suppressed_rs_delta_miss, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-5,5])
axs(3,3) = nexttile;
semshade(striatum_mod_suppressed_rs_delta_cr, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_suppressed_rs_delta_cr, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-5,5])
axs(3,4) = nexttile;
semshade(striatum_mod_suppressed_rs_delta_fa, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_suppressed_rs_delta_fa, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-5,5])
xlabel(tl, 'Time (s)', 'FontSize', 16)
ylabel(tl, '\Delta Firing Rate (Hz)', 'FontSize', 16)
outcomes = {'Hit', 'Miss', 'Correct Rejection', 'False Alarm'};
for c = 1:4
    axes(axs(1,c))
    title(outcomes{c}, 'FontWeight', 'normal', 'FontSize', 16)
end
title(tl, 'Stim. Suppressed RS Units', 'FontSize', 16, 'FontWeight', 'normal')

%% fs mod_suppressed vs unmod_suppressed ffs
fs_mod_suppressed_vs_unmod_suppressed_fr_fig = figure('Position', [1151 841 1850 1081]);
tl = tiledlayout(3,4);
axs(1,1) = nexttile;
semshade(s1_mod_suppressed_fs_delta_hit, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
try
    semshade(s1_unmod_suppressed_fs_delta_hit, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
catch
    plot(time, s1_unmod_suppressed_fs_delta_hit, 'r')
end
xlim([-2.8,4.8])
ylim([-30,30])
plot([1.2, 1.2], [-30,30], 'k--', 'HandleVisibility','off')
title('Hit', 'FontWeight', 'normal', 'FontSize', 16)
ylabel('S1', 'FontSize', 16)
axs(1,2) = nexttile;
semshade(s1_mod_suppressed_fs_delta_miss, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
try
    semshade(s1_unmod_suppressed_fs_delta_miss, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
catch
    plot(time, s1_unmod_suppressed_fs_delta_miss, 'r')
end
xlim([-2.8,4.8])
ylim([-30,30])
title('Miss', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,3) = nexttile;
semshade(s1_mod_suppressed_fs_delta_cr, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
try
    semshade(s1_unmod_suppressed_fs_delta_cr, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
catch
    plot(time, s1_unmod_suppressed_fs_delta_cr, 'r')
end
xlim([-2.8,4.8])
ylim([-30,30])
title('Correct Rejection', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,4) = nexttile;
semshade(s1_mod_suppressed_fs_delta_fa, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
try
    semshade(s1_unmod_suppressed_fs_delta_fa, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
catch
    plot(time, pfc_unmod_suppressed_fs_delta_fa, 'r')
end
xlim([-2.8,4.8])
ylim([-30,30])
title('False Alarm', 'FontWeight', 'normal', 'FontSize', 16)

axs(2,1) = nexttile;
try
    semshade(pfc_mod_suppressed_fs_delta_hit, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
catch
    plot(time, pfc_mod_suppressed_fs_delta_hit, 'b')
end
hold on;
try
    semshade(pfc_unmod_suppressed_fs_delta_hit, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
catch
    plot(time, pfc_unmod_suppressed_fs_delta_hit, 'r')
end
xlim([-2.8,4.8])
ylim([-30,30])
plot([1.2, 1.2], [-30,30], 'k--', 'HandleVisibility','off')
ylabel('PFC', 'FontSize', 16)
axs(2,2) = nexttile;
try
    semshade(pfc_mod_suppressed_fs_delta_miss, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
catch
    plot(time, pfc_mod_suppressed_fs_delta_miss, 'b')
end
hold on;
try
    semshade(pfc_unmod_suppressed_fs_delta_miss, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
catch
    plot(time, pfc_unmod_suppressed_fs_delta_miss, 'r')
end
xlim([-2.8,4.8])
ylim([-30,30])
axs(2,3) = nexttile;
try
    semshade(pfc_mod_suppressed_fs_delta_cr, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
catch
    plot(time, pfc_mod_suppressed_fs_delta_cr, 'b')
end
hold on;
try
    semshade(pfc_unmod_suppressed_fs_delta_cr, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
catch
    plot(time, pfc_unmod_suppressed_fs_delta_cr, 'r')
end
xlim([-2.8,4.8])
ylim([-30,30])
axs(2,4) = nexttile;
try
    semshade(pfc_mod_suppressed_fs_delta_fa, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
catch
    plot(time, pfc_mod_suppressed_fs_delta_fa, 'b')
end
hold on;
try
    semshade(pfc_unmod_suppressed_fs_delta_fa, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
catch 
    plot(time, pfc_unmod_suppressed_fs_delta_fa, 'r')
end
xlim([-2.8,4.8])
ylim([-30,30])

axs(3,1) = nexttile;
% semshade(striatum_mod_suppressed_fs_delta_hit, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_suppressed_fs_delta_hit, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-30,30])
plot([1.2, 1.2], [-20, 20], 'k--', 'HandleVisibility','off')
ylabel('Striatum', 'FontSize', 16)
axs(3,2) = nexttile;
% semshade(striatum_mod_suppressed_fs_delta_miss, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_suppressed_fs_delta_miss, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-30,30])
axs(3,3) = nexttile;
% semshade(striatum_mod_suppressed_fs_delta_cr, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_suppressed_fs_delta_cr, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-30,30])
axs(3,4) = nexttile;
% semshade(striatum_mod_suppressed_fs_delta_fa, 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_suppressed_fs_delta_fa, 0.3, 'r', 'r', time, 1, 'Unmod_suppressedulated');
xlim([-2.8,4.8])
ylim([-30,30])
xlabel(tl, 'Time (s)', 'FontSize', 16)
ylabel(tl, '\Delta Firing Rate (Hz)', 'FontSize', 16)
outcomes = {'Hit', 'Miss', 'Correct Rejection', 'False Alarm'};
for c = 1:4
    axes(axs(1,c))
    title(outcomes{c}, 'FontWeight', 'normal', 'FontSize', 16)
end
title(tl, 'Stim. Suppressed FS Units', 'FontSize', 16, 'FontWeight', 'normal')

%% stats on driven, suppressed, non-responsive 
s1_mod_driven_rs_fraction = sum(s1_mod_rs_evoked_hit > 1) / length(s1_mod_rs_evoked_hit);
s1_mod_suppressed_rs_fraction = sum(s1_mod_rs_evoked_hit < -1) / length(s1_mod_rs_evoked_hit);
s1_mod_nonresponse_rs_fraction = sum(abs(s1_mod_rs_evoked_hit) <= 1) / length(s1_mod_rs_evoked_hit);
s1_mod_driven_fs_fraction = sum(s1_mod_fs_evoked_hit > 1) / length(s1_mod_fs_evoked_hit);
s1_mod_suppressed_fs_fraction = sum(s1_mod_fs_evoked_hit < -1) / length(s1_mod_fs_evoked_hit);
s1_mod_nonresponse_fs_fraction = sum(abs(s1_mod_fs_evoked_hit) <= 1) / length(s1_mod_fs_evoked_hit);
s1_unmod_driven_rs_fraction = sum(s1_unmod_rs_evoked_hit > 1) / length(s1_unmod_rs_evoked_hit);
s1_unmod_suppressed_rs_fraction = sum(s1_unmod_rs_evoked_hit < -1) / length(s1_unmod_rs_evoked_hit);
s1_unmod_nonresponse_rs_fraction = sum(abs(s1_unmod_rs_evoked_hit) <= 1) / length(s1_unmod_rs_evoked_hit);
s1_unmod_driven_fs_fraction = sum(s1_unmod_fs_evoked_hit > 1) / length(s1_unmod_fs_evoked_hit);
s1_unmod_suppressed_fs_fraction = sum(s1_unmod_fs_evoked_hit < -1) / length(s1_unmod_fs_evoked_hit);
s1_unmod_nonresponse_fs_fraction = sum(abs(s1_unmod_fs_evoked_hit) <= 1) / length(s1_unmod_fs_evoked_hit);
pfc_mod_driven_rs_fraction = sum(pfc_mod_rs_evoked_hit > 1) / length(pfc_mod_rs_evoked_hit);
pfc_mod_suppressed_rs_fraction = sum(pfc_mod_rs_evoked_hit < -1) / length(pfc_mod_rs_evoked_hit);
pfc_mod_nonresponse_rs_fraction = sum(abs(pfc_mod_rs_evoked_hit) <= 1) / length(pfc_mod_rs_evoked_hit);
pfc_mod_driven_fs_fraction = sum(pfc_mod_fs_evoked_hit > 1) / length(pfc_mod_fs_evoked_hit);
pfc_mod_suppressed_fs_fraction = sum(pfc_mod_fs_evoked_hit < -1) / length(pfc_mod_fs_evoked_hit);
pfc_mod_nonresponse_fs_fraction = sum(abs(pfc_mod_fs_evoked_hit) <= 1) / length(pfc_mod_fs_evoked_hit);
pfc_unmod_driven_rs_fraction = sum(pfc_unmod_rs_evoked_hit > 1) / length(pfc_unmod_rs_evoked_hit);
pfc_unmod_suppressed_rs_fraction = sum(pfc_unmod_rs_evoked_hit < -1) / length(pfc_unmod_rs_evoked_hit);
pfc_unmod_nonresponse_rs_fraction = sum(abs(pfc_unmod_rs_evoked_hit) <= 1) / length(pfc_unmod_rs_evoked_hit);
pfc_unmod_driven_fs_fraction = sum(pfc_unmod_fs_evoked_hit > 1) / length(pfc_unmod_fs_evoked_hit);
pfc_unmod_suppressed_fs_fraction = sum(pfc_unmod_fs_evoked_hit < -1) / length(pfc_unmod_fs_evoked_hit);
pfc_unmod_nonresponse_fs_fraction = sum(abs(pfc_unmod_fs_evoked_hit) <= 1) / length(pfc_unmod_fs_evoked_hit);
striatum_mod_driven_rs_fraction = sum(striatum_mod_rs_evoked_hit > 1) / length(striatum_mod_rs_evoked_hit);
striatum_mod_suppressed_rs_fraction = sum(striatum_mod_rs_evoked_hit < -1) / length(striatum_mod_rs_evoked_hit);
striatum_mod_nonresponse_rs_fraction = sum(abs(striatum_mod_rs_evoked_hit) <= 1) / length(striatum_mod_rs_evoked_hit);
striatum_mod_driven_fs_fraction = sum(striatum_mod_fs_evoked_hit > 1) / length(striatum_mod_fs_evoked_hit);
striatum_mod_suppressed_fs_fraction = sum(striatum_mod_fs_evoked_hit < -1) / length(striatum_mod_fs_evoked_hit);
striatum_mod_nonresponse_fs_fraction = sum(abs(striatum_mod_fs_evoked_hit) <= 1) / length(striatum_mod_fs_evoked_hit);
striatum_unmod_driven_rs_fraction = sum(striatum_unmod_rs_evoked_hit > 1) / length(striatum_unmod_rs_evoked_hit);
striatum_unmod_suppressed_rs_fraction = sum(striatum_unmod_rs_evoked_hit < -1) / length(striatum_unmod_rs_evoked_hit);
striatum_unmod_nonresponse_rs_fraction = sum(abs(striatum_unmod_rs_evoked_hit) <= 1) / length(striatum_unmod_rs_evoked_hit);
striatum_unmod_driven_fs_fraction = sum(striatum_unmod_fs_evoked_hit > 1) / length(striatum_unmod_fs_evoked_hit);
striatum_unmod_suppressed_fs_fraction = sum(striatum_unmod_fs_evoked_hit < -1) / length(striatum_unmod_fs_evoked_hit);
striatum_unmod_nonresponse_fs_fraction = sum(abs(striatum_unmod_fs_evoked_hit) <= 1) / length(striatum_unmod_fs_evoked_hit);

s1_mod_responsive_rs_count = sum(abs(s1_mod_rs_evoked_hit) > 1);
s1_mod_nonresponsive_rs_count = sum(abs(s1_mod_rs_evoked_hit) <= 1);
s1_mod_responsive_fs_count = sum(abs(s1_mod_fs_evoked_hit) > 1);
s1_mod_nonresponsive_fs_count = sum(abs(s1_mod_fs_evoked_hit) <= 1);
s1_unmod_responsive_rs_count = sum(abs(s1_unmod_rs_evoked_hit) > 1);
s1_unmod_nonresponsive_rs_count = sum(abs(s1_unmod_rs_evoked_hit) <= 1);
s1_unmod_responsive_fs_count = sum(abs(s1_unmod_fs_evoked_hit) > 1);
s1_unmod_nonresponsive_fs_count = sum(abs(s1_unmod_fs_evoked_hit) <= 1);
pfc_mod_responsive_rs_count = sum(abs(pfc_mod_rs_evoked_hit) > 1);
pfc_mod_nonresponsive_rs_count = sum(abs(pfc_mod_rs_evoked_hit) <= 1);
pfc_mod_responsive_fs_count = sum(abs(pfc_mod_fs_evoked_hit) > 1);
pfc_mod_nonresponsive_fs_count = sum(abs(pfc_mod_fs_evoked_hit) <= 1);
pfc_unmod_responsive_rs_count = sum(abs(pfc_unmod_rs_evoked_hit) > 1);
pfc_unmod_nonresponsive_rs_count = sum(abs(pfc_unmod_rs_evoked_hit) <= 1);
pfc_unmod_responsive_fs_count = sum(abs(pfc_unmod_fs_evoked_hit) > 1);
pfc_unmod_nonresponsive_fs_count = sum(abs(pfc_unmod_fs_evoked_hit) <= 1);
striatum_mod_responsive_rs_count = sum(abs(striatum_mod_rs_evoked_hit) > 1);
striatum_mod_nonresponsive_rs_count = sum(abs(striatum_mod_rs_evoked_hit) <= 1);
striatum_mod_responsive_fs_count = sum(abs(striatum_mod_fs_evoked_hit) > 1);
striatum_mod_nonresponsive_fs_count = sum(abs(striatum_mod_fs_evoked_hit) <= 1);
striatum_unmod_responsive_rs_count = sum(abs(striatum_unmod_rs_evoked_hit) > 1);
striatum_unmod_nonresponsive_rs_count = sum(abs(striatum_unmod_rs_evoked_hit) <= 1);
striatum_unmod_responsive_fs_count = sum(abs(striatum_unmod_fs_evoked_hit) > 1);
striatum_unmod_nonresponsive_fs_count = sum(abs(striatum_unmod_fs_evoked_hit) <= 1);

x = [s1_mod_nonresponsive_rs_count, s1_unmod_nonresponsive_rs_count];
n = x + [s1_mod_responsive_rs_count, s1_unmod_responsive_rs_count];
fprintf('Fisher exact test s1 rs mod vs unmod nonresponsive %%\n')
[h,p,stats] = fishertest([x(1), n(1)-x(1); x(2), n(2)-x(2)])
x = [s1_mod_nonresponsive_fs_count, s1_unmod_nonresponsive_fs_count];
n = x + [s1_mod_responsive_fs_count, s1_unmod_responsive_fs_count];
fprintf('Fisher exact test s1 fs mod vs unmod nonresponsive %%\n')
[h,p,stats] = fishertest([x(1), n(1)-x(1); x(2), n(2)-x(2)])
x = [pfc_mod_nonresponsive_rs_count, pfc_unmod_nonresponsive_rs_count];
n = x + [pfc_mod_responsive_rs_count, pfc_unmod_responsive_rs_count];
fprintf('Fisher exact test pfc rs mod vs unmod nonresponsive %%\n')
[h,p,stats] = fishertest([x(1), n(1)-x(1); x(2), n(2)-x(2)])
x = [pfc_mod_nonresponsive_fs_count, pfc_unmod_nonresponsive_fs_count];
n = x + [pfc_mod_responsive_fs_count, pfc_unmod_responsive_fs_count];
fprintf('Fisher exact test pfc fs mod vs unmod nonresponsive %%\n')
[h,p,stats] = fishertest([x(1), n(1)-x(1); x(2), n(2)-x(2)])
x = [striatum_mod_nonresponsive_rs_count, striatum_unmod_nonresponsive_rs_count];
n = x + [striatum_mod_responsive_rs_count, striatum_unmod_responsive_rs_count];
fprintf('Fisher exact test striatum rs mod vs unmod nonresponsive %%\n')
[h,p,stats] = fishertest([x(1), n(1)-x(1); x(2), n(2)-x(2)])
x = [striatum_mod_nonresponsive_fs_count, striatum_unmod_nonresponsive_fs_count];
n = x + [striatum_mod_responsive_fs_count, striatum_unmod_responsive_fs_count];
fprintf('Fisher exact test striatum fs mod vs unmod nonresponsive %%\n')
[h,p,stats] = fishertest([x(1), n(1)-x(1); x(2), n(2)-x(2)])

pie_fig = figure('Position', [1151 721 1850 1081]);
tl = tiledlayout(3,4);
axs(1) = nexttile;
piechart([s1_mod_driven_rs_fraction, s1_mod_suppressed_rs_fraction, s1_mod_nonresponse_rs_fraction], ...
    ["Driven", "Suppressed", "Nonresponsive"])
title('Modulated')
axs(2) = nexttile;
piechart([s1_unmod_driven_rs_fraction, s1_unmod_suppressed_rs_fraction, s1_unmod_nonresponse_rs_fraction], ...
    ["Driven", "Suppressed", "Nonresponsive"])
title('Unmodulated')
axs(3) = nexttile;
piechart([s1_mod_driven_fs_fraction, s1_mod_suppressed_fs_fraction, s1_mod_nonresponse_fs_fraction], ...
    ["Driven", "Suppressed", "Nonresponsive"])
title('Modulated')
axs(4) = nexttile;
piechart([s1_unmod_driven_fs_fraction, s1_unmod_suppressed_fs_fraction, s1_unmod_nonresponse_fs_fraction], ...
    ["Driven", "Suppressed", "Nonresponsive"])
title('Unmodulated')
axs(5) = nexttile;
piechart([pfc_mod_driven_rs_fraction, pfc_mod_suppressed_rs_fraction, pfc_mod_nonresponse_rs_fraction], ...
    ["Driven", "Suppressed", "Nonresponsive"])
axs(6) = nexttile;
piechart([pfc_unmod_driven_rs_fraction, pfc_unmod_suppressed_rs_fraction, pfc_unmod_nonresponse_rs_fraction], ...
    ["Driven", "Suppressed", "Nonresponsive"])
axs(7) = nexttile;
piechart([pfc_mod_driven_fs_fraction, pfc_mod_suppressed_fs_fraction, pfc_mod_nonresponse_fs_fraction], ...
    ["Driven", "Suppressed", "Nonresponsive"])
axs(8) = nexttile;
piechart([pfc_unmod_driven_fs_fraction, pfc_unmod_suppressed_fs_fraction, pfc_unmod_nonresponse_fs_fraction], ...
    ["Driven", "Suppressed", "Nonresponsive"])
axs(9) = nexttile;
piechart([striatum_mod_driven_rs_fraction, striatum_mod_suppressed_rs_fraction, striatum_mod_nonresponse_rs_fraction], ...
    ["Driven", "Suppressed", "Nonresponsive"])
axs(10) = nexttile;
piechart([striatum_unmod_driven_rs_fraction, striatum_unmod_suppressed_rs_fraction, striatum_unmod_nonresponse_rs_fraction], ...
    ["Driven", "Suppressed", "Nonresponsive"])
axs(11) = nexttile;
piechart([striatum_mod_driven_fs_fraction, striatum_mod_suppressed_fs_fraction, striatum_mod_nonresponse_fs_fraction], ...
    ["Driven", "Suppressed", "Nonresponsive"])
axs(12) = nexttile;
piechart([striatum_unmod_driven_fs_fraction, striatum_unmod_suppressed_fs_fraction, striatum_unmod_nonresponse_fs_fraction], ...
    ["Driven", "Suppressed", "Nonresponsive"])

%% anova of firing rates 
s1_mod_rs_delta = s1_mod_rs_hit-mean(s1_mod_rs_hit(:,time<0),2);
s1_unmod_rs_delta = s1_unmod_rs_hit-mean(s1_unmod_rs_hit(:,time<0),2);
s1_mod_rs_delta = s1_mod_rs_delta(:,time > 0);
s1_unmod_rs_delta = s1_unmod_rs_delta(:,time > 0);
s1_rs_delta = [s1_mod_rs_delta; s1_unmod_rs_delta];
s1_rs_subj = vertcat(s1_mod_rs_subj, s1_unmod_rs_subj);
s1_rs_group = [zeros(size(s1_mod_rs_delta,1),1); ones(size(s1_unmod_rs_delta,1),1)];
s1_rs_table = table(s1_rs_group, s1_rs_subj, ...
    s1_rs_delta(:,1), s1_rs_delta(:,2), s1_rs_delta(:,3), s1_rs_delta(:,4), s1_rs_delta(:,5), s1_rs_delta(:,6), s1_rs_delta(:,7), s1_rs_delta(:,8), s1_rs_delta(:,9), s1_rs_delta(:,10), ...
    s1_rs_delta(:,11), s1_rs_delta(:,12), s1_rs_delta(:,13), s1_rs_delta(:,14), s1_rs_delta(:,15), s1_rs_delta(:,16), s1_rs_delta(:,17), s1_rs_delta(:,18), s1_rs_delta(:,19), s1_rs_delta(:,20), ...
    s1_rs_delta(:,21), s1_rs_delta(:,22), s1_rs_delta(:,23), s1_rs_delta(:,24), s1_rs_delta(:,25), s1_rs_delta(:,26), s1_rs_delta(:,27), s1_rs_delta(:,28), s1_rs_delta(:,29), s1_rs_delta(:,30), ...
    s1_rs_delta(:,31), s1_rs_delta(:,32), s1_rs_delta(:,33), s1_rs_delta(:,34), s1_rs_delta(:,35), s1_rs_delta(:,36), s1_rs_delta(:,37), s1_rs_delta(:,38), s1_rs_delta(:,39), s1_rs_delta(:,40), ...
    s1_rs_delta(:,41), s1_rs_delta(:,42), s1_rs_delta(:,43), s1_rs_delta(:,44), s1_rs_delta(:,45), s1_rs_delta(:,46), s1_rs_delta(:,47), s1_rs_delta(:,48), s1_rs_delta(:,49), s1_rs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
s1_rs_rm = fitrm(s1_rs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
s1_rs_ranova = ranova(s1_rs_rm)

s1_mod_fs_delta = s1_mod_fs_hit-mean(s1_mod_fs_hit(:,time<0),2);
s1_unmod_fs_delta = s1_unmod_fs_hit-mean(s1_unmod_fs_hit(:,time<0),2);
s1_mod_fs_delta = s1_mod_fs_delta(:,time > 0);
s1_unmod_fs_delta = s1_unmod_fs_delta(:,time > 0);
s1_fs_delta = [s1_mod_fs_delta; s1_unmod_fs_delta];
s1_fs_subj = vertcat(s1_mod_fs_subj, s1_unmod_fs_subj);
s1_fs_group = [zeros(size(s1_mod_fs_delta,1),1); ones(size(s1_unmod_fs_delta,1),1)];
s1_fs_table = table(s1_fs_group, s1_fs_subj, ...
    s1_fs_delta(:,1), s1_fs_delta(:,2), s1_fs_delta(:,3), s1_fs_delta(:,4), s1_fs_delta(:,5), s1_fs_delta(:,6), s1_fs_delta(:,7), s1_fs_delta(:,8), s1_fs_delta(:,9), s1_fs_delta(:,10), ...
    s1_fs_delta(:,11), s1_fs_delta(:,12), s1_fs_delta(:,13), s1_fs_delta(:,14), s1_fs_delta(:,15), s1_fs_delta(:,16), s1_fs_delta(:,17), s1_fs_delta(:,18), s1_fs_delta(:,19), s1_fs_delta(:,20), ...
    s1_fs_delta(:,21), s1_fs_delta(:,22), s1_fs_delta(:,23), s1_fs_delta(:,24), s1_fs_delta(:,25), s1_fs_delta(:,26), s1_fs_delta(:,27), s1_fs_delta(:,28), s1_fs_delta(:,29), s1_fs_delta(:,30), ...
    s1_fs_delta(:,31), s1_fs_delta(:,32), s1_fs_delta(:,33), s1_fs_delta(:,34), s1_fs_delta(:,35), s1_fs_delta(:,36), s1_fs_delta(:,37), s1_fs_delta(:,38), s1_fs_delta(:,39), s1_fs_delta(:,40), ...
    s1_fs_delta(:,41), s1_fs_delta(:,42), s1_fs_delta(:,43), s1_fs_delta(:,44), s1_fs_delta(:,45), s1_fs_delta(:,46), s1_fs_delta(:,47), s1_fs_delta(:,48), s1_fs_delta(:,49), s1_fs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
s1_fs_rm = fitrm(s1_fs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
s1_fs_ranova = ranova(s1_fs_rm)

pfc_mod_rs_delta = pfc_mod_rs_hit-mean(pfc_mod_rs_hit(:,time<0),2);
pfc_unmod_rs_delta = pfc_unmod_rs_hit-mean(pfc_unmod_rs_hit(:,time<0),2);
pfc_mod_rs_delta = pfc_mod_rs_delta(:,time > 0);
pfc_unmod_rs_delta = pfc_unmod_rs_delta(:,time > 0);
pfc_rs_delta = [pfc_mod_rs_delta; pfc_unmod_rs_delta];
pfc_rs_subj = vertcat(pfc_mod_rs_subj, pfc_unmod_rs_subj);
pfc_rs_group = [zeros(size(pfc_mod_rs_delta,1),1); ones(size(pfc_unmod_rs_delta,1),1)];
pfc_rs_table = table(pfc_rs_group, pfc_rs_subj, ...
    pfc_rs_delta(:,1), pfc_rs_delta(:,2), pfc_rs_delta(:,3), pfc_rs_delta(:,4), pfc_rs_delta(:,5), pfc_rs_delta(:,6), pfc_rs_delta(:,7), pfc_rs_delta(:,8), pfc_rs_delta(:,9), pfc_rs_delta(:,10), ...
    pfc_rs_delta(:,11), pfc_rs_delta(:,12), pfc_rs_delta(:,13), pfc_rs_delta(:,14), pfc_rs_delta(:,15), pfc_rs_delta(:,16), pfc_rs_delta(:,17), pfc_rs_delta(:,18), pfc_rs_delta(:,19), pfc_rs_delta(:,20), ...
    pfc_rs_delta(:,21), pfc_rs_delta(:,22), pfc_rs_delta(:,23), pfc_rs_delta(:,24), pfc_rs_delta(:,25), pfc_rs_delta(:,26), pfc_rs_delta(:,27), pfc_rs_delta(:,28), pfc_rs_delta(:,29), pfc_rs_delta(:,30), ...
    pfc_rs_delta(:,31), pfc_rs_delta(:,32), pfc_rs_delta(:,33), pfc_rs_delta(:,34), pfc_rs_delta(:,35), pfc_rs_delta(:,36), pfc_rs_delta(:,37), pfc_rs_delta(:,38), pfc_rs_delta(:,39), pfc_rs_delta(:,40), ...
    pfc_rs_delta(:,41), pfc_rs_delta(:,42), pfc_rs_delta(:,43), pfc_rs_delta(:,44), pfc_rs_delta(:,45), pfc_rs_delta(:,46), pfc_rs_delta(:,47), pfc_rs_delta(:,48), pfc_rs_delta(:,49), pfc_rs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
pfc_rs_rm = fitrm(pfc_rs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
% pfc_rs_rm = fitrm(pfc_rs_table, 't1-t50 ~ group', 'WithinDesign', Time);
pfc_rs_ranova = ranova(pfc_rs_rm)

pfc_mod_fs_delta = pfc_mod_fs_hit-mean(pfc_mod_fs_hit(:,time<0),2);
pfc_unmod_fs_delta = pfc_unmod_fs_hit-mean(pfc_unmod_fs_hit(:,time<0),2);
pfc_mod_fs_delta = pfc_mod_fs_delta(:,time > 0);
pfc_unmod_fs_delta = pfc_unmod_fs_delta(:,time > 0);
pfc_fs_delta = [pfc_mod_fs_delta; pfc_unmod_fs_delta];
pfc_fs_subj = vertcat(pfc_mod_fs_subj, pfc_unmod_fs_subj);
pfc_fs_group = [zeros(size(pfc_mod_fs_delta,1),1); ones(size(pfc_unmod_fs_delta,1),1)];
pfc_fs_table = table(pfc_fs_group, pfc_fs_subj, ...
    pfc_fs_delta(:,1), pfc_fs_delta(:,2), pfc_fs_delta(:,3), pfc_fs_delta(:,4), pfc_fs_delta(:,5), pfc_fs_delta(:,6), pfc_fs_delta(:,7), pfc_fs_delta(:,8), pfc_fs_delta(:,9), pfc_fs_delta(:,10), ...
    pfc_fs_delta(:,11), pfc_fs_delta(:,12), pfc_fs_delta(:,13), pfc_fs_delta(:,14), pfc_fs_delta(:,15), pfc_fs_delta(:,16), pfc_fs_delta(:,17), pfc_fs_delta(:,18), pfc_fs_delta(:,19), pfc_fs_delta(:,20), ...
    pfc_fs_delta(:,21), pfc_fs_delta(:,22), pfc_fs_delta(:,23), pfc_fs_delta(:,24), pfc_fs_delta(:,25), pfc_fs_delta(:,26), pfc_fs_delta(:,27), pfc_fs_delta(:,28), pfc_fs_delta(:,29), pfc_fs_delta(:,30), ...
    pfc_fs_delta(:,31), pfc_fs_delta(:,32), pfc_fs_delta(:,33), pfc_fs_delta(:,34), pfc_fs_delta(:,35), pfc_fs_delta(:,36), pfc_fs_delta(:,37), pfc_fs_delta(:,38), pfc_fs_delta(:,39), pfc_fs_delta(:,40), ...
    pfc_fs_delta(:,41), pfc_fs_delta(:,42), pfc_fs_delta(:,43), pfc_fs_delta(:,44), pfc_fs_delta(:,45), pfc_fs_delta(:,46), pfc_fs_delta(:,47), pfc_fs_delta(:,48), pfc_fs_delta(:,49), pfc_fs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
pfc_fs_rm = fitrm(pfc_fs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
% pfc_fs_rm = fitrm(pfc_fs_table, 't1-t50 ~ group', 'WithinDesign', Time);
pfc_fs_ranova = ranova(pfc_fs_rm)

striatum_mod_rs_delta = striatum_mod_rs_hit-mean(striatum_mod_rs_hit(:,time<0),2);
striatum_unmod_rs_delta = striatum_unmod_rs_hit-mean(striatum_unmod_rs_hit(:,time<0),2);
striatum_mod_rs_delta = striatum_mod_rs_delta(:,time > 0);
striatum_unmod_rs_delta = striatum_unmod_rs_delta(:,time > 0);
striatum_rs_delta = [striatum_mod_rs_delta; striatum_unmod_rs_delta];
striatum_rs_subj = vertcat(striatum_mod_rs_subj, striatum_unmod_rs_subj);
striatum_rs_group = [zeros(size(striatum_mod_rs_delta,1),1); ones(size(striatum_unmod_rs_delta,1),1)];
striatum_rs_table = table(striatum_rs_group, striatum_rs_subj, ...
    striatum_rs_delta(:,1), striatum_rs_delta(:,2), striatum_rs_delta(:,3), striatum_rs_delta(:,4), striatum_rs_delta(:,5), striatum_rs_delta(:,6), striatum_rs_delta(:,7), striatum_rs_delta(:,8), striatum_rs_delta(:,9), striatum_rs_delta(:,10), ...
    striatum_rs_delta(:,11), striatum_rs_delta(:,12), striatum_rs_delta(:,13), striatum_rs_delta(:,14), striatum_rs_delta(:,15), striatum_rs_delta(:,16), striatum_rs_delta(:,17), striatum_rs_delta(:,18), striatum_rs_delta(:,19), striatum_rs_delta(:,20), ...
    striatum_rs_delta(:,21), striatum_rs_delta(:,22), striatum_rs_delta(:,23), striatum_rs_delta(:,24), striatum_rs_delta(:,25), striatum_rs_delta(:,26), striatum_rs_delta(:,27), striatum_rs_delta(:,28), striatum_rs_delta(:,29), striatum_rs_delta(:,30), ...
    striatum_rs_delta(:,31), striatum_rs_delta(:,32), striatum_rs_delta(:,33), striatum_rs_delta(:,34), striatum_rs_delta(:,35), striatum_rs_delta(:,36), striatum_rs_delta(:,37), striatum_rs_delta(:,38), striatum_rs_delta(:,39), striatum_rs_delta(:,40), ...
    striatum_rs_delta(:,41), striatum_rs_delta(:,42), striatum_rs_delta(:,43), striatum_rs_delta(:,44), striatum_rs_delta(:,45), striatum_rs_delta(:,46), striatum_rs_delta(:,47), striatum_rs_delta(:,48), striatum_rs_delta(:,49), striatum_rs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
striatum_rs_rm = fitrm(striatum_rs_table, 't1-t50 ~ group', 'WithinDesign', Time);
striatum_rs_ranova = ranova(striatum_rs_rm)

striatum_mod_fs_delta = striatum_mod_fs_hit-mean(striatum_mod_fs_hit(:,time<0),2);
striatum_unmod_fs_delta = striatum_unmod_fs_hit-mean(striatum_unmod_fs_hit(:,time<0),2);
striatum_mod_fs_delta = striatum_mod_fs_delta(:,time > 0);
striatum_unmod_fs_delta = striatum_unmod_fs_delta(:,time > 0);
striatum_fs_delta = [striatum_mod_fs_delta; striatum_unmod_fs_delta];
striatum_fs_subj = vertcat(striatum_mod_fs_subj, striatum_unmod_fs_subj);
striatum_fs_group = [zeros(size(striatum_mod_fs_delta,1),1); ones(size(striatum_unmod_fs_delta,1),1)];
striatum_fs_table = table(striatum_fs_group, striatum_fs_subj, ...
    striatum_fs_delta(:,1), striatum_fs_delta(:,2), striatum_fs_delta(:,3), striatum_fs_delta(:,4), striatum_fs_delta(:,5), striatum_fs_delta(:,6), striatum_fs_delta(:,7), striatum_fs_delta(:,8), striatum_fs_delta(:,9), striatum_fs_delta(:,10), ...
    striatum_fs_delta(:,11), striatum_fs_delta(:,12), striatum_fs_delta(:,13), striatum_fs_delta(:,14), striatum_fs_delta(:,15), striatum_fs_delta(:,16), striatum_fs_delta(:,17), striatum_fs_delta(:,18), striatum_fs_delta(:,19), striatum_fs_delta(:,20), ...
    striatum_fs_delta(:,21), striatum_fs_delta(:,22), striatum_fs_delta(:,23), striatum_fs_delta(:,24), striatum_fs_delta(:,25), striatum_fs_delta(:,26), striatum_fs_delta(:,27), striatum_fs_delta(:,28), striatum_fs_delta(:,29), striatum_fs_delta(:,30), ...
    striatum_fs_delta(:,31), striatum_fs_delta(:,32), striatum_fs_delta(:,33), striatum_fs_delta(:,34), striatum_fs_delta(:,35), striatum_fs_delta(:,36), striatum_fs_delta(:,37), striatum_fs_delta(:,38), striatum_fs_delta(:,39), striatum_fs_delta(:,40), ...
    striatum_fs_delta(:,41), striatum_fs_delta(:,42), striatum_fs_delta(:,43), striatum_fs_delta(:,44), striatum_fs_delta(:,45), striatum_fs_delta(:,46), striatum_fs_delta(:,47), striatum_fs_delta(:,48), striatum_fs_delta(:,49), striatum_fs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
striatum_fs_rm = fitrm(striatum_fs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
striatum_fs_ranova = ranova(striatum_fs_rm)

%% anova driven/suppressed firing rates 
s1_mod_driven_rs_delta_hit = s1_mod_driven_rs_delta_hit(:,time > 0);
s1_unmod_driven_rs_delta_hit = s1_unmod_driven_rs_delta_hit(:,time > 0);
s1_rs_delta_hit = [s1_mod_driven_rs_delta_hit; s1_unmod_driven_rs_delta_hit];
s1_rs_subj = vertcat(s1_mod_rs_subj(s1_mod_rs_evoked_hit > 1), s1_unmod_rs_subj(s1_unmod_rs_evoked_hit > 1));
s1_rs_group = [zeros(size(s1_mod_driven_rs_delta_hit,1),1); ones(size(s1_unmod_driven_rs_delta_hit,1),1)];
s1_rs_driven_table = table(s1_rs_group, s1_rs_subj, ...
    s1_rs_delta_hit(:,1), s1_rs_delta_hit(:,2), s1_rs_delta_hit(:,3), s1_rs_delta_hit(:,4), s1_rs_delta_hit(:,5), s1_rs_delta_hit(:,6), s1_rs_delta_hit(:,7), s1_rs_delta_hit(:,8), s1_rs_delta_hit(:,9), s1_rs_delta_hit(:,10), ...
    s1_rs_delta_hit(:,11), s1_rs_delta_hit(:,12), s1_rs_delta_hit(:,13), s1_rs_delta_hit(:,14), s1_rs_delta_hit(:,15), s1_rs_delta_hit(:,16), s1_rs_delta_hit(:,17), s1_rs_delta_hit(:,18), s1_rs_delta_hit(:,19), s1_rs_delta_hit(:,20), ...
    s1_rs_delta_hit(:,21), s1_rs_delta_hit(:,22), s1_rs_delta_hit(:,23), s1_rs_delta_hit(:,24), s1_rs_delta_hit(:,25), s1_rs_delta_hit(:,26), s1_rs_delta_hit(:,27), s1_rs_delta_hit(:,28), s1_rs_delta_hit(:,29), s1_rs_delta_hit(:,30), ...
    s1_rs_delta_hit(:,31), s1_rs_delta_hit(:,32), s1_rs_delta_hit(:,33), s1_rs_delta_hit(:,34), s1_rs_delta_hit(:,35), s1_rs_delta_hit(:,36), s1_rs_delta_hit(:,37), s1_rs_delta_hit(:,38), s1_rs_delta_hit(:,39), s1_rs_delta_hit(:,40), ...
    s1_rs_delta_hit(:,41), s1_rs_delta_hit(:,42), s1_rs_delta_hit(:,43), s1_rs_delta_hit(:,44), s1_rs_delta_hit(:,45), s1_rs_delta_hit(:,46), s1_rs_delta_hit(:,47), s1_rs_delta_hit(:,48), s1_rs_delta_hit(:,49), s1_rs_delta_hit(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
s1_rs_driven_rm = fitrm(s1_rs_driven_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
s1_rs_driven_ranova = ranova(s1_rs_driven_rm)

s1_mod_driven_fs_delta_hit = s1_mod_driven_fs_delta_hit(:,time > 0);
s1_unmod_driven_fs_delta_hit = s1_unmod_driven_fs_delta_hit(:,time > 0);
s1_fs_delta_hit = [s1_mod_driven_fs_delta_hit; s1_unmod_driven_fs_delta_hit];
s1_fs_subj = vertcat(s1_mod_fs_subj(s1_mod_fs_evoked_hit > 1), s1_unmod_fs_subj(s1_unmod_fs_evoked_hit > 1));
s1_fs_group = [zeros(size(s1_mod_driven_fs_delta_hit,1),1); ones(size(s1_unmod_driven_fs_delta_hit,1),1)];
s1_fs_driven_table = table(s1_fs_group, s1_fs_subj, ...
    s1_fs_delta_hit(:,1), s1_fs_delta_hit(:,2), s1_fs_delta_hit(:,3), s1_fs_delta_hit(:,4), s1_fs_delta_hit(:,5), s1_fs_delta_hit(:,6), s1_fs_delta_hit(:,7), s1_fs_delta_hit(:,8), s1_fs_delta_hit(:,9), s1_fs_delta_hit(:,10), ...
    s1_fs_delta_hit(:,11), s1_fs_delta_hit(:,12), s1_fs_delta_hit(:,13), s1_fs_delta_hit(:,14), s1_fs_delta_hit(:,15), s1_fs_delta_hit(:,16), s1_fs_delta_hit(:,17), s1_fs_delta_hit(:,18), s1_fs_delta_hit(:,19), s1_fs_delta_hit(:,20), ...
    s1_fs_delta_hit(:,21), s1_fs_delta_hit(:,22), s1_fs_delta_hit(:,23), s1_fs_delta_hit(:,24), s1_fs_delta_hit(:,25), s1_fs_delta_hit(:,26), s1_fs_delta_hit(:,27), s1_fs_delta_hit(:,28), s1_fs_delta_hit(:,29), s1_fs_delta_hit(:,30), ...
    s1_fs_delta_hit(:,31), s1_fs_delta_hit(:,32), s1_fs_delta_hit(:,33), s1_fs_delta_hit(:,34), s1_fs_delta_hit(:,35), s1_fs_delta_hit(:,36), s1_fs_delta_hit(:,37), s1_fs_delta_hit(:,38), s1_fs_delta_hit(:,39), s1_fs_delta_hit(:,40), ...
    s1_fs_delta_hit(:,41), s1_fs_delta_hit(:,42), s1_fs_delta_hit(:,43), s1_fs_delta_hit(:,44), s1_fs_delta_hit(:,45), s1_fs_delta_hit(:,46), s1_fs_delta_hit(:,47), s1_fs_delta_hit(:,48), s1_fs_delta_hit(:,49), s1_fs_delta_hit(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
s1_fs_driven_rm = fitrm(s1_fs_driven_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
s1_fs_driven_ranova = ranova(s1_fs_driven_rm)

pfc_mod_driven_rs_delta_hit = pfc_mod_driven_rs_delta_hit(:,time > 0);
pfc_unmod_driven_rs_delta_hit = pfc_unmod_driven_rs_delta_hit(:,time > 0);
pfc_rs_delta_hit = [pfc_mod_driven_rs_delta_hit; pfc_unmod_driven_rs_delta_hit];
pfc_rs_subj = vertcat(pfc_mod_rs_subj(pfc_mod_rs_evoked_hit > 1), pfc_unmod_rs_subj(pfc_unmod_rs_evoked_hit > 1));
pfc_rs_group = [zeros(size(pfc_mod_driven_rs_delta_hit,1),1); ones(size(pfc_unmod_driven_rs_delta_hit,1),1)];
pfc_rs_driven_table = table(pfc_rs_group, pfc_rs_subj, ...
    pfc_rs_delta_hit(:,1), pfc_rs_delta_hit(:,2), pfc_rs_delta_hit(:,3), pfc_rs_delta_hit(:,4), pfc_rs_delta_hit(:,5), pfc_rs_delta_hit(:,6), pfc_rs_delta_hit(:,7), pfc_rs_delta_hit(:,8), pfc_rs_delta_hit(:,9), pfc_rs_delta_hit(:,10), ...
    pfc_rs_delta_hit(:,11), pfc_rs_delta_hit(:,12), pfc_rs_delta_hit(:,13), pfc_rs_delta_hit(:,14), pfc_rs_delta_hit(:,15), pfc_rs_delta_hit(:,16), pfc_rs_delta_hit(:,17), pfc_rs_delta_hit(:,18), pfc_rs_delta_hit(:,19), pfc_rs_delta_hit(:,20), ...
    pfc_rs_delta_hit(:,21), pfc_rs_delta_hit(:,22), pfc_rs_delta_hit(:,23), pfc_rs_delta_hit(:,24), pfc_rs_delta_hit(:,25), pfc_rs_delta_hit(:,26), pfc_rs_delta_hit(:,27), pfc_rs_delta_hit(:,28), pfc_rs_delta_hit(:,29), pfc_rs_delta_hit(:,30), ...
    pfc_rs_delta_hit(:,31), pfc_rs_delta_hit(:,32), pfc_rs_delta_hit(:,33), pfc_rs_delta_hit(:,34), pfc_rs_delta_hit(:,35), pfc_rs_delta_hit(:,36), pfc_rs_delta_hit(:,37), pfc_rs_delta_hit(:,38), pfc_rs_delta_hit(:,39), pfc_rs_delta_hit(:,40), ...
    pfc_rs_delta_hit(:,41), pfc_rs_delta_hit(:,42), pfc_rs_delta_hit(:,43), pfc_rs_delta_hit(:,44), pfc_rs_delta_hit(:,45), pfc_rs_delta_hit(:,46), pfc_rs_delta_hit(:,47), pfc_rs_delta_hit(:,48), pfc_rs_delta_hit(:,49), pfc_rs_delta_hit(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
pfc_rs_driven_rm = fitrm(pfc_rs_driven_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
pfc_rs_driven_ranova = ranova(pfc_rs_driven_rm)

pfc_mod_driven_fs_delta_hit = pfc_mod_driven_fs_delta_hit(:,time > 0);
pfc_unmod_driven_fs_delta_hit = pfc_unmod_driven_fs_delta_hit(:,time > 0);
pfc_fs_delta_hit = [pfc_mod_driven_fs_delta_hit; pfc_unmod_driven_fs_delta_hit];
pfc_fs_subj = vertcat(pfc_mod_fs_subj(pfc_mod_fs_evoked_hit > 1), pfc_unmod_fs_subj(pfc_unmod_fs_evoked_hit > 1));
pfc_fs_group = [zeros(size(pfc_mod_driven_fs_delta_hit,1),1); ones(size(pfc_unmod_driven_fs_delta_hit,1),1)];
pfc_fs_driven_table = table(pfc_fs_group, pfc_fs_subj, ...
    pfc_fs_delta_hit(:,1), pfc_fs_delta_hit(:,2), pfc_fs_delta_hit(:,3), pfc_fs_delta_hit(:,4), pfc_fs_delta_hit(:,5), pfc_fs_delta_hit(:,6), pfc_fs_delta_hit(:,7), pfc_fs_delta_hit(:,8), pfc_fs_delta_hit(:,9), pfc_fs_delta_hit(:,10), ...
    pfc_fs_delta_hit(:,11), pfc_fs_delta_hit(:,12), pfc_fs_delta_hit(:,13), pfc_fs_delta_hit(:,14), pfc_fs_delta_hit(:,15), pfc_fs_delta_hit(:,16), pfc_fs_delta_hit(:,17), pfc_fs_delta_hit(:,18), pfc_fs_delta_hit(:,19), pfc_fs_delta_hit(:,20), ...
    pfc_fs_delta_hit(:,21), pfc_fs_delta_hit(:,22), pfc_fs_delta_hit(:,23), pfc_fs_delta_hit(:,24), pfc_fs_delta_hit(:,25), pfc_fs_delta_hit(:,26), pfc_fs_delta_hit(:,27), pfc_fs_delta_hit(:,28), pfc_fs_delta_hit(:,29), pfc_fs_delta_hit(:,30), ...
    pfc_fs_delta_hit(:,31), pfc_fs_delta_hit(:,32), pfc_fs_delta_hit(:,33), pfc_fs_delta_hit(:,34), pfc_fs_delta_hit(:,35), pfc_fs_delta_hit(:,36), pfc_fs_delta_hit(:,37), pfc_fs_delta_hit(:,38), pfc_fs_delta_hit(:,39), pfc_fs_delta_hit(:,40), ...
    pfc_fs_delta_hit(:,41), pfc_fs_delta_hit(:,42), pfc_fs_delta_hit(:,43), pfc_fs_delta_hit(:,44), pfc_fs_delta_hit(:,45), pfc_fs_delta_hit(:,46), pfc_fs_delta_hit(:,47), pfc_fs_delta_hit(:,48), pfc_fs_delta_hit(:,49), pfc_fs_delta_hit(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
pfc_fs_driven_rm = fitrm(pfc_fs_driven_table, 't1-t50 ~ group', 'WithinDesign', Time);
pfc_fs_driven_ranova = ranova(pfc_fs_driven_rm)

striatum_mod_driven_rs_delta_hit = striatum_mod_driven_rs_delta_hit(:,time > 0);
striatum_unmod_driven_rs_delta_hit = striatum_unmod_driven_rs_delta_hit(:,time > 0);
striatum_rs_delta_hit = [striatum_mod_driven_rs_delta_hit; striatum_unmod_driven_rs_delta_hit];
striatum_rs_subj = vertcat(striatum_mod_rs_subj(striatum_mod_rs_evoked_hit > 1), striatum_unmod_rs_subj(striatum_unmod_rs_evoked_hit > 1));
striatum_rs_group = [zeros(size(striatum_mod_driven_rs_delta_hit,1),1); ones(size(striatum_unmod_driven_rs_delta_hit,1),1)];
striatum_rs_driven_table = table(striatum_rs_group, striatum_rs_subj, ...
    striatum_rs_delta_hit(:,1), striatum_rs_delta_hit(:,2), striatum_rs_delta_hit(:,3), striatum_rs_delta_hit(:,4), striatum_rs_delta_hit(:,5), striatum_rs_delta_hit(:,6), striatum_rs_delta_hit(:,7), striatum_rs_delta_hit(:,8), striatum_rs_delta_hit(:,9), striatum_rs_delta_hit(:,10), ...
    striatum_rs_delta_hit(:,11), striatum_rs_delta_hit(:,12), striatum_rs_delta_hit(:,13), striatum_rs_delta_hit(:,14), striatum_rs_delta_hit(:,15), striatum_rs_delta_hit(:,16), striatum_rs_delta_hit(:,17), striatum_rs_delta_hit(:,18), striatum_rs_delta_hit(:,19), striatum_rs_delta_hit(:,20), ...
    striatum_rs_delta_hit(:,21), striatum_rs_delta_hit(:,22), striatum_rs_delta_hit(:,23), striatum_rs_delta_hit(:,24), striatum_rs_delta_hit(:,25), striatum_rs_delta_hit(:,26), striatum_rs_delta_hit(:,27), striatum_rs_delta_hit(:,28), striatum_rs_delta_hit(:,29), striatum_rs_delta_hit(:,30), ...
    striatum_rs_delta_hit(:,31), striatum_rs_delta_hit(:,32), striatum_rs_delta_hit(:,33), striatum_rs_delta_hit(:,34), striatum_rs_delta_hit(:,35), striatum_rs_delta_hit(:,36), striatum_rs_delta_hit(:,37), striatum_rs_delta_hit(:,38), striatum_rs_delta_hit(:,39), striatum_rs_delta_hit(:,40), ...
    striatum_rs_delta_hit(:,41), striatum_rs_delta_hit(:,42), striatum_rs_delta_hit(:,43), striatum_rs_delta_hit(:,44), striatum_rs_delta_hit(:,45), striatum_rs_delta_hit(:,46), striatum_rs_delta_hit(:,47), striatum_rs_delta_hit(:,48), striatum_rs_delta_hit(:,49), striatum_rs_delta_hit(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
striatum_rs_driven_rm = fitrm(striatum_rs_driven_table, 't1-t50 ~ group', 'WithinDesign', Time);
striatum_rs_driven_ranova = ranova(striatum_rs_driven_rm)

striatum_mod_driven_fs_delta_hit = striatum_mod_driven_fs_delta_hit(:,time > 0);
striatum_unmod_driven_fs_delta_hit = striatum_unmod_driven_fs_delta_hit(:,time > 0);
striatum_fs_delta_hit = [striatum_mod_driven_fs_delta_hit; striatum_unmod_driven_fs_delta_hit];
striatum_fs_subj = vertcat(striatum_mod_fs_subj(striatum_mod_fs_evoked_hit > 1), striatum_unmod_fs_subj(striatum_unmod_fs_evoked_hit > 1));
striatum_fs_group = [zeros(size(striatum_mod_driven_fs_delta_hit,1),1); ones(size(striatum_unmod_driven_fs_delta_hit,1),1)];
striatum_fs_driven_table = table(striatum_fs_group, striatum_fs_subj, ...
    striatum_fs_delta_hit(:,1), striatum_fs_delta_hit(:,2), striatum_fs_delta_hit(:,3), striatum_fs_delta_hit(:,4), striatum_fs_delta_hit(:,5), striatum_fs_delta_hit(:,6), striatum_fs_delta_hit(:,7), striatum_fs_delta_hit(:,8), striatum_fs_delta_hit(:,9), striatum_fs_delta_hit(:,10), ...
    striatum_fs_delta_hit(:,11), striatum_fs_delta_hit(:,12), striatum_fs_delta_hit(:,13), striatum_fs_delta_hit(:,14), striatum_fs_delta_hit(:,15), striatum_fs_delta_hit(:,16), striatum_fs_delta_hit(:,17), striatum_fs_delta_hit(:,18), striatum_fs_delta_hit(:,19), striatum_fs_delta_hit(:,20), ...
    striatum_fs_delta_hit(:,21), striatum_fs_delta_hit(:,22), striatum_fs_delta_hit(:,23), striatum_fs_delta_hit(:,24), striatum_fs_delta_hit(:,25), striatum_fs_delta_hit(:,26), striatum_fs_delta_hit(:,27), striatum_fs_delta_hit(:,28), striatum_fs_delta_hit(:,29), striatum_fs_delta_hit(:,30), ...
    striatum_fs_delta_hit(:,31), striatum_fs_delta_hit(:,32), striatum_fs_delta_hit(:,33), striatum_fs_delta_hit(:,34), striatum_fs_delta_hit(:,35), striatum_fs_delta_hit(:,36), striatum_fs_delta_hit(:,37), striatum_fs_delta_hit(:,38), striatum_fs_delta_hit(:,39), striatum_fs_delta_hit(:,40), ...
    striatum_fs_delta_hit(:,41), striatum_fs_delta_hit(:,42), striatum_fs_delta_hit(:,43), striatum_fs_delta_hit(:,44), striatum_fs_delta_hit(:,45), striatum_fs_delta_hit(:,46), striatum_fs_delta_hit(:,47), striatum_fs_delta_hit(:,48), striatum_fs_delta_hit(:,49), striatum_fs_delta_hit(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
striatum_fs_driven_rm = fitrm(striatum_fs_driven_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
striatum_fs_driven_ranova = ranova(striatum_fs_driven_rm)

s1_mod_suppressed_rs_delta_hit = s1_mod_suppressed_rs_delta_hit(:,time > 0);
s1_unmod_suppressed_rs_delta_hit = s1_unmod_suppressed_rs_delta_hit(:,time > 0);
s1_rs_delta_hit = [s1_mod_suppressed_rs_delta_hit; s1_unmod_suppressed_rs_delta_hit];
s1_rs_subj = vertcat(s1_mod_rs_subj(s1_mod_rs_evoked_hit < -1), s1_unmod_rs_subj(s1_unmod_rs_evoked_hit < -1));
s1_rs_group = [zeros(size(s1_mod_suppressed_rs_delta_hit,1),1); ones(size(s1_unmod_suppressed_rs_delta_hit,1),1)];
s1_rs_suppressed_table = table(s1_rs_group, s1_rs_subj, ...
    s1_rs_delta_hit(:,1), s1_rs_delta_hit(:,2), s1_rs_delta_hit(:,3), s1_rs_delta_hit(:,4), s1_rs_delta_hit(:,5), s1_rs_delta_hit(:,6), s1_rs_delta_hit(:,7), s1_rs_delta_hit(:,8), s1_rs_delta_hit(:,9), s1_rs_delta_hit(:,10), ...
    s1_rs_delta_hit(:,11), s1_rs_delta_hit(:,12), s1_rs_delta_hit(:,13), s1_rs_delta_hit(:,14), s1_rs_delta_hit(:,15), s1_rs_delta_hit(:,16), s1_rs_delta_hit(:,17), s1_rs_delta_hit(:,18), s1_rs_delta_hit(:,19), s1_rs_delta_hit(:,20), ...
    s1_rs_delta_hit(:,21), s1_rs_delta_hit(:,22), s1_rs_delta_hit(:,23), s1_rs_delta_hit(:,24), s1_rs_delta_hit(:,25), s1_rs_delta_hit(:,26), s1_rs_delta_hit(:,27), s1_rs_delta_hit(:,28), s1_rs_delta_hit(:,29), s1_rs_delta_hit(:,30), ...
    s1_rs_delta_hit(:,31), s1_rs_delta_hit(:,32), s1_rs_delta_hit(:,33), s1_rs_delta_hit(:,34), s1_rs_delta_hit(:,35), s1_rs_delta_hit(:,36), s1_rs_delta_hit(:,37), s1_rs_delta_hit(:,38), s1_rs_delta_hit(:,39), s1_rs_delta_hit(:,40), ...
    s1_rs_delta_hit(:,41), s1_rs_delta_hit(:,42), s1_rs_delta_hit(:,43), s1_rs_delta_hit(:,44), s1_rs_delta_hit(:,45), s1_rs_delta_hit(:,46), s1_rs_delta_hit(:,47), s1_rs_delta_hit(:,48), s1_rs_delta_hit(:,49), s1_rs_delta_hit(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
s1_rs_suppressed_rm = fitrm(s1_rs_suppressed_table, 't1-t50 ~ group', 'WithinDesign', Time);
s1_rs_suppressed_ranova = ranova(s1_rs_suppressed_rm)

s1_mod_suppressed_fs_delta_hit = s1_mod_suppressed_fs_delta_hit(:,time > 0);
s1_unmod_suppressed_fs_delta_hit = s1_unmod_suppressed_fs_delta_hit(:,time > 0);
s1_fs_delta_hit = [s1_mod_suppressed_fs_delta_hit; s1_unmod_suppressed_fs_delta_hit];
s1_fs_subj = vertcat(s1_mod_fs_subj(s1_mod_fs_evoked_hit < -1), s1_unmod_fs_subj(s1_unmod_fs_evoked_hit < -1));
s1_fs_group = [zeros(size(s1_mod_suppressed_fs_delta_hit,1),1); ones(size(s1_unmod_suppressed_fs_delta_hit,1),1)];
s1_fs_suppressed_table = table(s1_fs_group, s1_fs_subj, ...
    s1_fs_delta_hit(:,1), s1_fs_delta_hit(:,2), s1_fs_delta_hit(:,3), s1_fs_delta_hit(:,4), s1_fs_delta_hit(:,5), s1_fs_delta_hit(:,6), s1_fs_delta_hit(:,7), s1_fs_delta_hit(:,8), s1_fs_delta_hit(:,9), s1_fs_delta_hit(:,10), ...
    s1_fs_delta_hit(:,11), s1_fs_delta_hit(:,12), s1_fs_delta_hit(:,13), s1_fs_delta_hit(:,14), s1_fs_delta_hit(:,15), s1_fs_delta_hit(:,16), s1_fs_delta_hit(:,17), s1_fs_delta_hit(:,18), s1_fs_delta_hit(:,19), s1_fs_delta_hit(:,20), ...
    s1_fs_delta_hit(:,21), s1_fs_delta_hit(:,22), s1_fs_delta_hit(:,23), s1_fs_delta_hit(:,24), s1_fs_delta_hit(:,25), s1_fs_delta_hit(:,26), s1_fs_delta_hit(:,27), s1_fs_delta_hit(:,28), s1_fs_delta_hit(:,29), s1_fs_delta_hit(:,30), ...
    s1_fs_delta_hit(:,31), s1_fs_delta_hit(:,32), s1_fs_delta_hit(:,33), s1_fs_delta_hit(:,34), s1_fs_delta_hit(:,35), s1_fs_delta_hit(:,36), s1_fs_delta_hit(:,37), s1_fs_delta_hit(:,38), s1_fs_delta_hit(:,39), s1_fs_delta_hit(:,40), ...
    s1_fs_delta_hit(:,41), s1_fs_delta_hit(:,42), s1_fs_delta_hit(:,43), s1_fs_delta_hit(:,44), s1_fs_delta_hit(:,45), s1_fs_delta_hit(:,46), s1_fs_delta_hit(:,47), s1_fs_delta_hit(:,48), s1_fs_delta_hit(:,49), s1_fs_delta_hit(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
s1_fs_suppressed_rm = fitrm(s1_fs_suppressed_table, 't1-t50 ~ group', 'WithinDesign', Time);
s1_fs_suppressed_ranova = ranova(s1_fs_suppressed_rm)

pfc_mod_suppressed_rs_delta_hit = pfc_mod_suppressed_rs_delta_hit(:,time > 0);
pfc_unmod_suppressed_rs_delta_hit = pfc_unmod_suppressed_rs_delta_hit(:,time > 0);
pfc_rs_delta_hit = [pfc_mod_suppressed_rs_delta_hit; pfc_unmod_suppressed_rs_delta_hit];
pfc_rs_subj = vertcat(pfc_mod_rs_subj(pfc_mod_rs_evoked_hit < -1), pfc_unmod_rs_subj(pfc_unmod_rs_evoked_hit < -1));
pfc_rs_group = [zeros(size(pfc_mod_suppressed_rs_delta_hit,1),1); ones(size(pfc_unmod_suppressed_rs_delta_hit,1),1)];
pfc_rs_suppressed_table = table(pfc_rs_group, pfc_rs_subj, ...
    pfc_rs_delta_hit(:,1), pfc_rs_delta_hit(:,2), pfc_rs_delta_hit(:,3), pfc_rs_delta_hit(:,4), pfc_rs_delta_hit(:,5), pfc_rs_delta_hit(:,6), pfc_rs_delta_hit(:,7), pfc_rs_delta_hit(:,8), pfc_rs_delta_hit(:,9), pfc_rs_delta_hit(:,10), ...
    pfc_rs_delta_hit(:,11), pfc_rs_delta_hit(:,12), pfc_rs_delta_hit(:,13), pfc_rs_delta_hit(:,14), pfc_rs_delta_hit(:,15), pfc_rs_delta_hit(:,16), pfc_rs_delta_hit(:,17), pfc_rs_delta_hit(:,18), pfc_rs_delta_hit(:,19), pfc_rs_delta_hit(:,20), ...
    pfc_rs_delta_hit(:,21), pfc_rs_delta_hit(:,22), pfc_rs_delta_hit(:,23), pfc_rs_delta_hit(:,24), pfc_rs_delta_hit(:,25), pfc_rs_delta_hit(:,26), pfc_rs_delta_hit(:,27), pfc_rs_delta_hit(:,28), pfc_rs_delta_hit(:,29), pfc_rs_delta_hit(:,30), ...
    pfc_rs_delta_hit(:,31), pfc_rs_delta_hit(:,32), pfc_rs_delta_hit(:,33), pfc_rs_delta_hit(:,34), pfc_rs_delta_hit(:,35), pfc_rs_delta_hit(:,36), pfc_rs_delta_hit(:,37), pfc_rs_delta_hit(:,38), pfc_rs_delta_hit(:,39), pfc_rs_delta_hit(:,40), ...
    pfc_rs_delta_hit(:,41), pfc_rs_delta_hit(:,42), pfc_rs_delta_hit(:,43), pfc_rs_delta_hit(:,44), pfc_rs_delta_hit(:,45), pfc_rs_delta_hit(:,46), pfc_rs_delta_hit(:,47), pfc_rs_delta_hit(:,48), pfc_rs_delta_hit(:,49), pfc_rs_delta_hit(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
pfc_rs_suppressed_rm = fitrm(pfc_rs_suppressed_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
pfc_rs_suppressed_ranova = ranova(pfc_rs_suppressed_rm)

pfc_mod_suppressed_fs_delta_hit = pfc_mod_suppressed_fs_delta_hit(:,time > 0);
pfc_unmod_suppressed_fs_delta_hit = pfc_unmod_suppressed_fs_delta_hit(:,time > 0);
pfc_fs_delta_hit = [pfc_mod_suppressed_fs_delta_hit; pfc_unmod_suppressed_fs_delta_hit];
pfc_fs_subj = vertcat(pfc_mod_fs_subj(pfc_mod_fs_evoked_hit < -1), pfc_unmod_fs_subj(pfc_unmod_fs_evoked_hit < -1));
pfc_fs_group = [zeros(size(pfc_mod_suppressed_fs_delta_hit,1),1); ones(size(pfc_unmod_suppressed_fs_delta_hit,1),1)];
pfc_fs_suppressed_table = table(pfc_fs_group, pfc_fs_subj, ...
    pfc_fs_delta_hit(:,1), pfc_fs_delta_hit(:,2), pfc_fs_delta_hit(:,3), pfc_fs_delta_hit(:,4), pfc_fs_delta_hit(:,5), pfc_fs_delta_hit(:,6), pfc_fs_delta_hit(:,7), pfc_fs_delta_hit(:,8), pfc_fs_delta_hit(:,9), pfc_fs_delta_hit(:,10), ...
    pfc_fs_delta_hit(:,11), pfc_fs_delta_hit(:,12), pfc_fs_delta_hit(:,13), pfc_fs_delta_hit(:,14), pfc_fs_delta_hit(:,15), pfc_fs_delta_hit(:,16), pfc_fs_delta_hit(:,17), pfc_fs_delta_hit(:,18), pfc_fs_delta_hit(:,19), pfc_fs_delta_hit(:,20), ...
    pfc_fs_delta_hit(:,21), pfc_fs_delta_hit(:,22), pfc_fs_delta_hit(:,23), pfc_fs_delta_hit(:,24), pfc_fs_delta_hit(:,25), pfc_fs_delta_hit(:,26), pfc_fs_delta_hit(:,27), pfc_fs_delta_hit(:,28), pfc_fs_delta_hit(:,29), pfc_fs_delta_hit(:,30), ...
    pfc_fs_delta_hit(:,31), pfc_fs_delta_hit(:,32), pfc_fs_delta_hit(:,33), pfc_fs_delta_hit(:,34), pfc_fs_delta_hit(:,35), pfc_fs_delta_hit(:,36), pfc_fs_delta_hit(:,37), pfc_fs_delta_hit(:,38), pfc_fs_delta_hit(:,39), pfc_fs_delta_hit(:,40), ...
    pfc_fs_delta_hit(:,41), pfc_fs_delta_hit(:,42), pfc_fs_delta_hit(:,43), pfc_fs_delta_hit(:,44), pfc_fs_delta_hit(:,45), pfc_fs_delta_hit(:,46), pfc_fs_delta_hit(:,47), pfc_fs_delta_hit(:,48), pfc_fs_delta_hit(:,49), pfc_fs_delta_hit(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
pfc_fs_suppressed_rm = fitrm(pfc_fs_suppressed_table, 't1-t50 ~ group', 'WithinDesign', Time);
pfc_fs_suppressed_ranova = ranova(pfc_fs_suppressed_rm)

striatum_mod_suppressed_rs_delta_hit = striatum_mod_suppressed_rs_delta_hit(:,time > 0);
striatum_unmod_suppressed_rs_delta_hit = striatum_unmod_suppressed_rs_delta_hit(:,time > 0);
striatum_rs_delta_hit = [striatum_mod_suppressed_rs_delta_hit; striatum_unmod_suppressed_rs_delta_hit];
striatum_rs_subj = vertcat(striatum_mod_rs_subj(striatum_mod_rs_evoked_hit < -1), striatum_unmod_rs_subj(striatum_unmod_rs_evoked_hit < -1));
striatum_rs_group = [zeros(size(striatum_mod_suppressed_rs_delta_hit,1),1); ones(size(striatum_unmod_suppressed_rs_delta_hit,1),1)];
striatum_rs_suppressed_table = table(striatum_rs_group, striatum_rs_subj, ...
    striatum_rs_delta_hit(:,1), striatum_rs_delta_hit(:,2), striatum_rs_delta_hit(:,3), striatum_rs_delta_hit(:,4), striatum_rs_delta_hit(:,5), striatum_rs_delta_hit(:,6), striatum_rs_delta_hit(:,7), striatum_rs_delta_hit(:,8), striatum_rs_delta_hit(:,9), striatum_rs_delta_hit(:,10), ...
    striatum_rs_delta_hit(:,11), striatum_rs_delta_hit(:,12), striatum_rs_delta_hit(:,13), striatum_rs_delta_hit(:,14), striatum_rs_delta_hit(:,15), striatum_rs_delta_hit(:,16), striatum_rs_delta_hit(:,17), striatum_rs_delta_hit(:,18), striatum_rs_delta_hit(:,19), striatum_rs_delta_hit(:,20), ...
    striatum_rs_delta_hit(:,21), striatum_rs_delta_hit(:,22), striatum_rs_delta_hit(:,23), striatum_rs_delta_hit(:,24), striatum_rs_delta_hit(:,25), striatum_rs_delta_hit(:,26), striatum_rs_delta_hit(:,27), striatum_rs_delta_hit(:,28), striatum_rs_delta_hit(:,29), striatum_rs_delta_hit(:,30), ...
    striatum_rs_delta_hit(:,31), striatum_rs_delta_hit(:,32), striatum_rs_delta_hit(:,33), striatum_rs_delta_hit(:,34), striatum_rs_delta_hit(:,35), striatum_rs_delta_hit(:,36), striatum_rs_delta_hit(:,37), striatum_rs_delta_hit(:,38), striatum_rs_delta_hit(:,39), striatum_rs_delta_hit(:,40), ...
    striatum_rs_delta_hit(:,41), striatum_rs_delta_hit(:,42), striatum_rs_delta_hit(:,43), striatum_rs_delta_hit(:,44), striatum_rs_delta_hit(:,45), striatum_rs_delta_hit(:,46), striatum_rs_delta_hit(:,47), striatum_rs_delta_hit(:,48), striatum_rs_delta_hit(:,49), striatum_rs_delta_hit(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
striatum_rs_suppressed_rm = fitrm(striatum_rs_suppressed_table, 't1-t50 ~ group', 'WithinDesign', Time);
striatum_rs_suppressed_ranova = ranova(striatum_rs_suppressed_rm)

% striatum_mod_suppressed_fs_delta_hit = striatum_mod_suppressed_fs_delta_hit(:,time > 0);
% striatum_unmod_suppressed_fs_delta_hit = striatum_unmod_suppressed_fs_delta_hit(:,time > 0);
% striatum_fs_delta_hit = [striatum_mod_suppressed_fs_delta_hit; striatum_unmod_suppressed_fs_delta_hit];
% striatum_fs_subj = vertcat(striatum_mod_fs_subj(striatum_mod_fs_evoked_hit < -1), striatum_unmod_fs_subj(striatum_unmod_fs_evoked_hit < -1));
% striatum_fs_group = [zeros(size(striatum_mod_suppressed_fs_delta_hit,1),1); ones(size(striatum_unmod_suppressed_fs_delta_hit,1),1)];
% striatum_fs_suppressed_table = table(striatum_fs_group, striatum_fs_subj, ...
%     striatum_fs_delta_hit(:,1), striatum_fs_delta_hit(:,2), striatum_fs_delta_hit(:,3), striatum_fs_delta_hit(:,4), striatum_fs_delta_hit(:,5), striatum_fs_delta_hit(:,6), striatum_fs_delta_hit(:,7), striatum_fs_delta_hit(:,8), striatum_fs_delta_hit(:,9), striatum_fs_delta_hit(:,10), ...
%     striatum_fs_delta_hit(:,11), striatum_fs_delta_hit(:,12), striatum_fs_delta_hit(:,13), striatum_fs_delta_hit(:,14), striatum_fs_delta_hit(:,15), striatum_fs_delta_hit(:,16), striatum_fs_delta_hit(:,17), striatum_fs_delta_hit(:,18), striatum_fs_delta_hit(:,19), striatum_fs_delta_hit(:,20), ...
%     striatum_fs_delta_hit(:,21), striatum_fs_delta_hit(:,22), striatum_fs_delta_hit(:,23), striatum_fs_delta_hit(:,24), striatum_fs_delta_hit(:,25), striatum_fs_delta_hit(:,26), striatum_fs_delta_hit(:,27), striatum_fs_delta_hit(:,28), striatum_fs_delta_hit(:,29), striatum_fs_delta_hit(:,30), ...
%     striatum_fs_delta_hit(:,31), striatum_fs_delta_hit(:,32), striatum_fs_delta_hit(:,33), striatum_fs_delta_hit(:,34), striatum_fs_delta_hit(:,35), striatum_fs_delta_hit(:,36), striatum_fs_delta_hit(:,37), striatum_fs_delta_hit(:,38), striatum_fs_delta_hit(:,39), striatum_fs_delta_hit(:,40), ...
%     striatum_fs_delta_hit(:,41), striatum_fs_delta_hit(:,42), striatum_fs_delta_hit(:,43), striatum_fs_delta_hit(:,44), striatum_fs_delta_hit(:,45), striatum_fs_delta_hit(:,46), striatum_fs_delta_hit(:,47), striatum_fs_delta_hit(:,48), striatum_fs_delta_hit(:,49), striatum_fs_delta_hit(:,50), ...
%     'VariableNames', {'group', 'subject', ...
%     't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
%     't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
%     't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
%     't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
%     't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
% striatum_fs_suppressed_rm = fitrm(striatum_fs_suppressed_table, 't1-t50 ~ group', 'WithinDesign', Time);
% striatum_fs_suppressed_ranova = ranova(striatum_fs_suppressed_rm)

if KStest(s1_mod_rs_evoked_hit(s1_mod_rs_evoked_hit > 1)) || KStest(s1_unmod_rs_evoked_hit(s1_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('S1 RS Driven Mod vs Unmod on Hit (mann-whitney): p = %d\n', ranksum(s1_mod_rs_evoked_hit(s1_mod_rs_evoked_hit > 1), s1_unmod_rs_evoked_hit(s1_unmod_rs_evoked_hit > 1))))
else
    [~,p] = ttest2(s1_mod_rs_evoked_hit(s1_mod_rs_evoked_hit > 1), s1_unmod_rs_evoked_hit(s1_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('S1 RS Driven Mod vs Unmod on Hit (2 sample t-test): p = %d\n', p))
end

if KStest(s1_mod_fs_evoked_hit(s1_mod_fs_evoked_hit > 1)) || KStest(s1_unmod_fs_evoked_hit(s1_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('S1 FS Driven Mod vs Unmod on Hit (mann-whitney): p = %d\n', ranksum(s1_mod_fs_evoked_hit(s1_mod_fs_evoked_hit > 1), s1_unmod_fs_evoked_hit(s1_unmod_fs_evoked_hit > 1))))
else
    [~,p] = ttest2(s1_mod_fs_evoked_hit(s1_mod_fs_evoked_hit > 1), s1_unmod_fs_evoked_hit(s1_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('S1 FS Driven Mod vs Unmod on Hit (2 sample t-test): p = %d\n', p))
end

if KStest(s1_mod_rs_evoked_miss(s1_mod_rs_evoked_hit > 1)) || KStest(s1_unmod_rs_evoked_miss(s1_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('S1 RS Driven Mod vs Unmod on Miss (mann-whitney): p = %d\n', ranksum(s1_mod_rs_evoked_miss(s1_mod_rs_evoked_hit > 1), s1_unmod_rs_evoked_miss(s1_unmod_rs_evoked_hit > 1))))
else
    [~,p] = ttest2(s1_mod_rs_evoked_miss(s1_mod_rs_evoked_hit > 1), s1_unmod_rs_evoked_miss(s1_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('S1 RS Driven Mod vs Unmod on Miss (2 sample t-test): p = %d\n', p))
end

if KStest(s1_mod_fs_evoked_miss(s1_mod_fs_evoked_hit > 1)) || KStest(s1_unmod_fs_evoked_miss(s1_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('S1 FS Driven Mod vs Unmod on Miss (mann-whitney): p = %d\n', ranksum(s1_mod_fs_evoked_miss(s1_mod_fs_evoked_hit > 1), s1_unmod_fs_evoked_miss(s1_unmod_fs_evoked_hit > 1))))
else
    [~,p] = ttest2(s1_mod_fs_evoked_miss(s1_mod_fs_evoked_hit > 1), s1_unmod_fs_evoked_miss(s1_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('S1 FS Driven Mod vs Unmod on Miss (2 sample t-test): p = %d\n', p))
end

if KStest(s1_mod_rs_evoked_cr(s1_mod_rs_evoked_hit > 1)) || KStest(s1_unmod_rs_evoked_cr(s1_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('S1 RS Driven Mod vs Unmod on CR (mann-whitney): p = %d\n', ranksum(s1_mod_rs_evoked_cr(s1_mod_rs_evoked_hit > 1), s1_unmod_rs_evoked_cr(s1_unmod_rs_evoked_hit > 1))))
else
    [~,p] = ttest2(s1_mod_rs_evoked_cr(s1_mod_rs_evoked_hit > 1), s1_unmod_rs_evoked_cr(s1_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('S1 RS Driven Mod vs Unmod on CR (2 sample t-test): p = %d\n', p))
end

if KStest(s1_mod_fs_evoked_cr(s1_mod_fs_evoked_hit > 1)) || KStest(s1_unmod_fs_evoked_cr(s1_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('S1 FS Driven Mod vs Unmod on CR (mann-whitney): p = %d\n', ranksum(s1_mod_fs_evoked_cr(s1_mod_fs_evoked_hit > 1), s1_unmod_fs_evoked_cr(s1_unmod_fs_evoked_hit > 1))))
else
    [~,p] = ttest2(s1_mod_fs_evoked_cr(s1_mod_fs_evoked_hit > 1), s1_unmod_fs_evoked_cr(s1_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('S1 FS Driven Mod vs Unmod on CR (2 sample t-test): p = %d\n', p))
end

if KStest(s1_mod_rs_evoked_fa(s1_mod_rs_evoked_hit > 1)) || KStest(s1_unmod_rs_evoked_fa(s1_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('S1 RS Driven Mod vs Unmod on FA (mann-whitney): p = %d\n', ranksum(s1_mod_rs_evoked_fa(s1_mod_rs_evoked_hit > 1), s1_unmod_rs_evoked_fa(s1_unmod_rs_evoked_hit > 1))))
else
    [~,p] = ttest2(s1_mod_rs_evoked_fa(s1_mod_rs_evoked_hit > 1), s1_unmod_rs_evoked_fa(s1_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('S1 RS Driven Mod vs Unmod on FA (2 sample t-test): p = %d\n', p))
end

if KStest(s1_mod_fs_evoked_fa(s1_mod_fs_evoked_hit > 1)) || KStest(s1_unmod_fs_evoked_fa(s1_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('S1 FS Driven Mod vs Unmod on FA (mann-whitney): p = %d\n', ranksum(s1_mod_fs_evoked_fa(s1_mod_fs_evoked_hit > 1), s1_unmod_fs_evoked_fa(s1_unmod_fs_evoked_hit > 1))))
else
    [~,p] = ttest2(s1_mod_fs_evoked_fa(s1_mod_fs_evoked_hit > 1), s1_unmod_fs_evoked_fa(s1_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('S1 FS Driven Mod vs Unmod on FA (2 sample t-test): p = %d\n', p))
end


if KStest(pfc_mod_rs_evoked_hit(pfc_mod_rs_evoked_hit > 1)) || KStest(pfc_unmod_rs_evoked_hit(pfc_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('PFC RS Driven Mod vs Unmod on Hit (mann-whitney): p = %d\n', ranksum(pfc_mod_rs_evoked_hit(pfc_mod_rs_evoked_hit > 1), pfc_unmod_rs_evoked_hit(pfc_unmod_rs_evoked_hit > 1))))
else
    [~,p] = ttest2(pfc_mod_rs_evoked_hit(pfc_mod_rs_evoked_hit > 1), pfc_unmod_rs_evoked_hit(pfc_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('PFC RS Driven Mod vs Unmod on Hit (2 sample t-test): p = %d\n', p))
end

if KStest(pfc_mod_fs_evoked_hit(pfc_mod_fs_evoked_hit > 1)) || KStest(pfc_unmod_fs_evoked_hit(pfc_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('PFC FS Driven Mod vs Unmod on Hit (mann-whitney): p = %d\n', ranksum(pfc_mod_fs_evoked_hit(pfc_mod_fs_evoked_hit > 1), pfc_unmod_fs_evoked_hit(pfc_unmod_fs_evoked_hit > 1))))
else
    [~,p] = ttest2(pfc_mod_fs_evoked_hit(pfc_mod_fs_evoked_hit > 1), pfc_unmod_fs_evoked_hit(pfc_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('PFC FS Driven Mod vs Unmod on Hit (2 sample t-test): p = %d\n', p))
end

if KStest(pfc_mod_rs_evoked_miss(pfc_mod_rs_evoked_hit > 1)) || KStest(pfc_unmod_rs_evoked_miss(pfc_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('PFC RS Driven Mod vs Unmod on Miss (mann-whitney): p = %d\n', ranksum(pfc_mod_rs_evoked_miss(pfc_mod_rs_evoked_hit > 1), pfc_unmod_rs_evoked_miss(pfc_unmod_rs_evoked_hit > 1))))
else
    [~,p] = ttest2(pfc_mod_rs_evoked_miss(pfc_mod_rs_evoked_hit > 1), pfc_unmod_rs_evoked_miss(pfc_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('PFC RS Driven Mod vs Unmod on Miss (2 sample t-test): p = %d\n', p))
end

if KStest(pfc_mod_fs_evoked_miss(pfc_mod_fs_evoked_hit > 1)) || KStest(pfc_unmod_fs_evoked_miss(pfc_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('PFC FS Driven Mod vs Unmod on Miss (mann-whitney): p = %d\n', ranksum(pfc_mod_fs_evoked_miss(pfc_mod_fs_evoked_hit > 1), pfc_unmod_fs_evoked_miss(pfc_unmod_fs_evoked_hit > 1))))
else
    [~,p] = ttest2(pfc_mod_fs_evoked_miss(pfc_mod_fs_evoked_hit > 1), pfc_unmod_fs_evoked_miss(pfc_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('PFC FS Driven Mod vs Unmod on Miss (2 sample t-test): p = %d\n', p))
end

if KStest(pfc_mod_rs_evoked_cr(pfc_mod_rs_evoked_hit > 1)) || KStest(pfc_unmod_rs_evoked_cr(pfc_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('PFC RS Driven Mod vs Unmod on CR (mann-whitney): p = %d\n', ranksum(pfc_mod_rs_evoked_cr(pfc_mod_rs_evoked_hit > 1), pfc_unmod_rs_evoked_cr(pfc_unmod_rs_evoked_hit > 1))))
else
    [~,p] = ttest2(pfc_mod_rs_evoked_cr(pfc_mod_rs_evoked_hit > 1), pfc_unmod_rs_evoked_cr(pfc_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('PFC RS Driven Mod vs Unmod on CR (2 sample t-test): p = %d\n', p))
end

if KStest(pfc_mod_fs_evoked_cr(pfc_mod_fs_evoked_hit > 1)) || KStest(pfc_unmod_fs_evoked_cr(pfc_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('PFC FS Driven Mod vs Unmod on CR (mann-whitney): p = %d\n', ranksum(pfc_mod_fs_evoked_cr(pfc_mod_fs_evoked_hit > 1), pfc_unmod_fs_evoked_cr(pfc_unmod_fs_evoked_hit > 1))))
else
    [~,p] = ttest2(pfc_mod_fs_evoked_cr(pfc_mod_fs_evoked_hit > 1), pfc_unmod_fs_evoked_cr(pfc_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('PFC FS Driven Mod vs Unmod on CR (2 sample t-test): p = %d\n', p))
end

if KStest(pfc_mod_rs_evoked_fa(pfc_mod_rs_evoked_hit > 1)) || KStest(pfc_unmod_rs_evoked_fa(pfc_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('PFC RS Driven Mod vs Unmod on FA (mann-whitney): p = %d\n', ranksum(pfc_mod_rs_evoked_fa(pfc_mod_rs_evoked_hit > 1), pfc_unmod_rs_evoked_fa(pfc_unmod_rs_evoked_hit > 1))))
else
    [~,p] = ttest2(pfc_mod_rs_evoked_fa(pfc_mod_rs_evoked_hit > 1), pfc_unmod_rs_evoked_fa(pfc_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('PFC RS Driven Mod vs Unmod on FA (2 sample t-test): p = %d\n', p))
end

if KStest(pfc_mod_fs_evoked_fa(pfc_mod_fs_evoked_hit > 1)) || KStest(pfc_unmod_fs_evoked_fa(pfc_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('PFC FS Driven Mod vs Unmod on FA (mann-whitney): p = %d\n', ranksum(pfc_mod_fs_evoked_fa(pfc_mod_fs_evoked_hit > 1), pfc_unmod_fs_evoked_fa(pfc_unmod_fs_evoked_hit > 1))))
else
    [~,p] = ttest2(pfc_mod_fs_evoked_fa(pfc_mod_fs_evoked_hit > 1), pfc_unmod_fs_evoked_fa(pfc_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('PFC FS Driven Mod vs Unmod on FA (2 sample t-test): p = %d\n', p))
end


if KStest(striatum_mod_rs_evoked_hit(striatum_mod_rs_evoked_hit > 1)) || KStest(striatum_unmod_rs_evoked_hit(striatum_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('Striatum RS Driven Mod vs Unmod on Hit (mann-whitney): p = %d\n', ranksum(striatum_mod_rs_evoked_hit(striatum_mod_rs_evoked_hit > 1), striatum_unmod_rs_evoked_hit(striatum_unmod_rs_evoked_hit > 1))))
else
    [~,p] = ttest2(striatum_mod_rs_evoked_hit(striatum_mod_rs_evoked_hit > 1), striatum_unmod_rs_evoked_hit(striatum_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('Striatum RS Driven Mod vs Unmod on Hit (2 sample t-test): p = %d\n', p))
end

if KStest(striatum_mod_fs_evoked_hit(striatum_mod_fs_evoked_hit > 1)) || KStest(striatum_unmod_fs_evoked_hit(striatum_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('Striatum FS Driven Mod vs Unmod on Hit (mann-whitney): p = %d\n', ranksum(striatum_mod_fs_evoked_hit(striatum_mod_fs_evoked_hit > 1), striatum_unmod_fs_evoked_hit(striatum_unmod_fs_evoked_hit > 1))))
else
    [~,p] = ttest2(striatum_mod_fs_evoked_hit(striatum_mod_fs_evoked_hit > 1), striatum_unmod_fs_evoked_hit(striatum_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('Striatum FS Driven Mod vs Unmod on Hit (2 sample t-test): p = %d\n', p))
end

if KStest(striatum_mod_rs_evoked_miss(striatum_mod_rs_evoked_hit > 1)) || KStest(striatum_unmod_rs_evoked_miss(striatum_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('Striatum RS Driven Mod vs Unmod on Miss (mann-whitney): p = %d\n', ranksum(striatum_mod_rs_evoked_miss(striatum_mod_rs_evoked_hit > 1), striatum_unmod_rs_evoked_miss(striatum_unmod_rs_evoked_hit > 1))))
else
    [~,p] = ttest2(striatum_mod_rs_evoked_miss(striatum_mod_rs_evoked_hit > 1), striatum_unmod_rs_evoked_miss(striatum_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('Striatum RS Driven Mod vs Unmod on Miss (2 sample t-test): p = %d\n', p))
end

if KStest(striatum_mod_fs_evoked_miss(striatum_mod_fs_evoked_hit > 1)) || KStest(striatum_unmod_fs_evoked_miss(striatum_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('Striatum FS Driven Mod vs Unmod on Miss (mann-whitney): p = %d\n', ranksum(striatum_mod_fs_evoked_miss(striatum_mod_fs_evoked_hit > 1), striatum_unmod_fs_evoked_miss(striatum_unmod_fs_evoked_hit > 1))))
else
    [~,p] = ttest2(striatum_mod_fs_evoked_miss(striatum_mod_fs_evoked_hit > 1), striatum_unmod_fs_evoked_miss(striatum_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('Striatum FS Driven Mod vs Unmod on Miss (2 sample t-test): p = %d\n', p))
end

if KStest(striatum_mod_rs_evoked_cr(striatum_mod_rs_evoked_hit > 1)) || KStest(striatum_unmod_rs_evoked_cr(striatum_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('Striatum RS Driven Mod vs Unmod on CR (mann-whitney): p = %d\n', ranksum(striatum_mod_rs_evoked_cr(striatum_mod_rs_evoked_hit > 1), striatum_unmod_rs_evoked_cr(striatum_unmod_rs_evoked_hit > 1))))
else
    [~,p] = ttest2(striatum_mod_rs_evoked_cr(striatum_mod_rs_evoked_hit > 1), striatum_unmod_rs_evoked_cr(striatum_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('Striatum RS Driven Mod vs Unmod on CR (2 sample t-test): p = %d\n', p))
end

if KStest(striatum_mod_fs_evoked_cr(striatum_mod_fs_evoked_hit > 1)) || KStest(striatum_unmod_fs_evoked_cr(striatum_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('Striatum FS Driven Mod vs Unmod on CR (mann-whitney): p = %d\n', ranksum(striatum_mod_fs_evoked_cr(striatum_mod_fs_evoked_hit > 1), striatum_unmod_fs_evoked_cr(striatum_unmod_fs_evoked_hit > 1))))
else
    [~,p] = ttest2(striatum_mod_fs_evoked_cr(striatum_mod_fs_evoked_hit > 1), striatum_unmod_fs_evoked_cr(striatum_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('Striatum FS Driven Mod vs Unmod on CR (2 sample t-test): p = %d\n', p))
end

if KStest(striatum_mod_rs_evoked_fa(striatum_mod_rs_evoked_hit > 1)) || KStest(striatum_unmod_rs_evoked_fa(striatum_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('Striatum RS Driven Mod vs Unmod on FA (mann-whitney): p = %d\n', ranksum(striatum_mod_rs_evoked_fa(striatum_mod_rs_evoked_hit > 1), striatum_unmod_rs_evoked_fa(striatum_unmod_rs_evoked_hit > 1))))
else
    [~,p] = ttest2(striatum_mod_rs_evoked_fa(striatum_mod_rs_evoked_hit > 1), striatum_unmod_rs_evoked_fa(striatum_unmod_rs_evoked_hit > 1))
    fprintf(sprintf('Striatum RS Driven Mod vs Unmod on FA (2 sample t-test): p = %d\n', p))
end

if KStest(striatum_mod_fs_evoked_fa(striatum_mod_fs_evoked_hit > 1)) || KStest(striatum_unmod_fs_evoked_fa(striatum_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('Striatum FS Driven Mod vs Unmod on FA (mann-whitney): p = %d\n', ranksum(striatum_mod_fs_evoked_fa(striatum_mod_fs_evoked_hit > 1), striatum_unmod_fs_evoked_fa(striatum_unmod_fs_evoked_hit > 1))))
else
    [~,p] = ttest2(striatum_mod_fs_evoked_fa(striatum_mod_fs_evoked_hit > 1), striatum_unmod_fs_evoked_fa(striatum_unmod_fs_evoked_hit > 1))
    fprintf(sprintf('Striatum FS Driven Mod vs Unmod on FA (2 sample t-test): p = %d\n', p))
end

if KStest(s1_mod_rs_evoked_hit(s1_mod_rs_evoked_hit < -1)) || KStest(s1_unmod_rs_evoked_hit(s1_unmod_rs_evoked_hit < -1))
    fprintf(sprintf('S1 RS Suppressed Mod vs Unmod on Hit (mann-whitney): p = %d\n', ranksum(s1_mod_rs_evoked_hit(s1_mod_rs_evoked_hit < -1), s1_unmod_rs_evoked_hit(s1_unmod_rs_evoked_hit < -1))))
else
    [~,p] = ttest2(s1_mod_rs_evoked_hit(s1_mod_rs_evoked_hit < -1), s1_unmod_rs_evoked_hit(s1_unmod_rs_evoked_hit < -1));
    fprintf(sprintf('S1 RS Suppressed Mod vs Unmod on Hit (2 sample t-test): p = %d\n', p))
end

if KStest(s1_mod_fs_evoked_hit(s1_mod_fs_evoked_hit < -1)) || KStest(s1_unmod_fs_evoked_hit(s1_unmod_fs_evoked_hit < -1))
    fprintf(sprintf('S1 FS Suppressed Mod vs Unmod on Hit (mann-whitney): p = %d\n', ranksum(s1_mod_fs_evoked_hit(s1_mod_fs_evoked_hit < -1), s1_unmod_fs_evoked_hit(s1_unmod_fs_evoked_hit < -1))))
else
    [~,p] = ttest2(s1_mod_fs_evoked_hit(s1_mod_fs_evoked_hit < -1), s1_unmod_fs_evoked_hit(s1_unmod_fs_evoked_hit < -1));
    fprintf(sprintf('S1 FS Suppressed Mod vs Unmod on Hit (2 sample t-test): p = %d\n', p))
end

if KStest(s1_mod_rs_evoked_miss(s1_mod_rs_evoked_hit < -1)) || KStest(s1_unmod_rs_evoked_miss(s1_unmod_rs_evoked_hit < -1))
    fprintf(sprintf('S1 RS Suppressed Mod vs Unmod on Miss (mann-whitney): p = %d\n', ranksum(s1_mod_rs_evoked_miss(s1_mod_rs_evoked_hit < -1), s1_unmod_rs_evoked_miss(s1_unmod_rs_evoked_hit < -1))))
else
    [~,p] = ttest2(s1_mod_rs_evoked_miss(s1_mod_rs_evoked_hit < -1), s1_unmod_rs_evoked_miss(s1_unmod_rs_evoked_hit < -1));
    fprintf(sprintf('S1 RS Suppressed Mod vs Unmod on Miss (2 sample t-test): p = %d\n', p))
end

if KStest(s1_mod_fs_evoked_miss(s1_mod_fs_evoked_hit < -1)) || KStest(s1_unmod_fs_evoked_miss(s1_unmod_fs_evoked_hit < -1))
    fprintf(sprintf('S1 FS Suppressed Mod vs Unmod on Miss (mann-whitney): p = %d\n', ranksum(s1_mod_fs_evoked_miss(s1_mod_fs_evoked_hit < -1), s1_unmod_fs_evoked_miss(s1_unmod_fs_evoked_hit < -1))))
else
    [~,p] = ttest2(s1_mod_fs_evoked_miss(s1_mod_fs_evoked_hit < -1), s1_unmod_fs_evoked_miss(s1_unmod_fs_evoked_hit < -1));
    fprintf(sprintf('S1 FS Suppressed Mod vs Unmod on Miss (2 sample t-test): p = %d\n', p))
end

if KStest(s1_mod_rs_evoked_cr(s1_mod_rs_evoked_hit < -1)) || KStest(s1_unmod_rs_evoked_cr(s1_unmod_rs_evoked_hit < -1))
    fprintf(sprintf('S1 RS Suppressed Mod vs Unmod on CR (mann-whitney): p = %d\n', ranksum(s1_mod_rs_evoked_cr(s1_mod_rs_evoked_hit < -1), s1_unmod_rs_evoked_cr(s1_unmod_rs_evoked_hit < -1))))
else
    [~,p] = ttest2(s1_mod_rs_evoked_cr(s1_mod_rs_evoked_hit < -1), s1_unmod_rs_evoked_cr(s1_unmod_rs_evoked_hit < -1));
    fprintf(sprintf('S1 RS Suppressed Mod vs Unmod on CR (2 sample t-test): p = %d\n', p))
end

if KStest(s1_mod_fs_evoked_cr(s1_mod_fs_evoked_hit < -1)) || KStest(s1_unmod_fs_evoked_cr(s1_unmod_fs_evoked_hit < -1))
    fprintf(sprintf('S1 FS Suppressed Mod vs Unmod on CR (mann-whitney): p = %d\n', ranksum(s1_mod_fs_evoked_cr(s1_mod_fs_evoked_hit < -1), s1_unmod_fs_evoked_cr(s1_unmod_fs_evoked_hit < -1))))
else
    [~,p] = ttest2(s1_mod_fs_evoked_cr(s1_mod_fs_evoked_hit < -1), s1_unmod_fs_evoked_cr(s1_unmod_fs_evoked_hit < -1));
    fprintf(sprintf('S1 FS Suppressed Mod vs Unmod on CR (2 sample t-test): p = %d\n', p))
end

if KStest(s1_mod_rs_evoked_fa(s1_mod_rs_evoked_hit < -1)) || KStest(s1_unmod_rs_evoked_fa(s1_unmod_rs_evoked_hit < -1))
    fprintf(sprintf('S1 RS Suppressed Mod vs Unmod on FA (mann-whitney): p = %d\n', ranksum(s1_mod_rs_evoked_fa(s1_mod_rs_evoked_hit < -1), s1_unmod_rs_evoked_fa(s1_unmod_rs_evoked_hit < -1))))
else
    [~,p] = ttest2(s1_mod_rs_evoked_fa(s1_mod_rs_evoked_hit < -1), s1_unmod_rs_evoked_fa(s1_unmod_rs_evoked_hit < -1));
    fprintf(sprintf('S1 RS Suppressed Mod vs Unmod on FA (2 sample t-test): p = %d\n', p))
end

if KStest(s1_mod_fs_evoked_fa(s1_mod_fs_evoked_hit < -1)) || KStest(s1_unmod_fs_evoked_fa(s1_unmod_fs_evoked_hit < -1))
    fprintf(sprintf('S1 FS Suppressed Mod vs Unmod on FA (mann-whitney): p = %d\n', ranksum(s1_mod_fs_evoked_fa(s1_mod_fs_evoked_hit < -1), s1_unmod_fs_evoked_fa(s1_unmod_fs_evoked_hit < -1))))
else
    [~,p] = ttest2(s1_mod_fs_evoked_fa(s1_mod_fs_evoked_hit < -1), s1_unmod_fs_evoked_fa(s1_unmod_fs_evoked_hit < -1));
    fprintf(sprintf('S1 FS Suppressed Mod vs Unmod on FA (2 sample t-test): p = %d\n', p))
end


if KStest(pfc_mod_rs_evoked_hit(pfc_mod_rs_evoked_hit < -1)) || KStest(pfc_unmod_rs_evoked_hit(pfc_unmod_rs_evoked_hit < -1))
    fprintf(sprintf('PFC RS Suppressed Mod vs Unmod on Hit (mann-whitney): p = %d\n', ranksum(pfc_mod_rs_evoked_hit(pfc_mod_rs_evoked_hit < -1), pfc_unmod_rs_evoked_hit(pfc_unmod_rs_evoked_hit < -1))))
else
    [~,p] = ttest2(pfc_mod_rs_evoked_hit(pfc_mod_rs_evoked_hit < -1), pfc_unmod_rs_evoked_hit(pfc_unmod_rs_evoked_hit < -1));
    fprintf(sprintf('PFC RS Suppressed Mod vs Unmod on Hit (2 sample t-test): p = %d\n', p))
end

if KStest(pfc_mod_fs_evoked_hit(pfc_mod_fs_evoked_hit < -1)) || KStest(pfc_unmod_fs_evoked_hit(pfc_unmod_fs_evoked_hit < -1))
    fprintf(sprintf('PFC FS Suppressed Mod vs Unmod on Hit (mann-whitney): p = %d\n', ranksum(pfc_mod_fs_evoked_hit(pfc_mod_fs_evoked_hit < -1), pfc_unmod_fs_evoked_hit(pfc_unmod_fs_evoked_hit < -1))))
else
    [~,p] = ttest2(pfc_mod_fs_evoked_hit(pfc_mod_fs_evoked_hit < -1), pfc_unmod_fs_evoked_hit(pfc_unmod_fs_evoked_hit < -1));
    fprintf(sprintf('PFC FS Suppressed Mod vs Unmod on Hit (2 sample t-test): p = %d\n', p))
end

if KStest(pfc_mod_rs_evoked_miss(pfc_mod_rs_evoked_hit < -1)) || KStest(pfc_unmod_rs_evoked_miss(pfc_unmod_rs_evoked_hit < -1))
    fprintf(sprintf('PFC RS Suppressed Mod vs Unmod on Miss (mann-whitney): p = %d\n', ranksum(pfc_mod_rs_evoked_miss(pfc_mod_rs_evoked_hit < -1), pfc_unmod_rs_evoked_miss(pfc_unmod_rs_evoked_hit < -1))))
else
    [~,p] = ttest2(pfc_mod_rs_evoked_miss(pfc_mod_rs_evoked_hit < -1), pfc_unmod_rs_evoked_miss(pfc_unmod_rs_evoked_hit < -1));
    fprintf(sprintf('PFC RS Suppressed Mod vs Unmod on Miss (2 sample t-test): p = %d\n', p))
end

if KStest(pfc_mod_fs_evoked_miss(pfc_mod_fs_evoked_hit < -1)) || KStest(pfc_unmod_fs_evoked_miss(pfc_unmod_fs_evoked_hit < -1))
    fprintf(sprintf('PFC FS Suppressed Mod vs Unmod on Miss (mann-whitney): p = %d\n', ranksum(pfc_mod_fs_evoked_miss(pfc_mod_fs_evoked_hit < -1), pfc_unmod_fs_evoked_miss(pfc_unmod_fs_evoked_hit < -1))))
else
    [~,p] = ttest2(pfc_mod_fs_evoked_miss(pfc_mod_fs_evoked_hit < -1), pfc_unmod_fs_evoked_miss(pfc_unmod_fs_evoked_hit < -1));
    fprintf(sprintf('PFC FS Suppressed Mod vs Unmod on Miss (2 sample t-test): p = %d\n', p))
end

if KStest(pfc_mod_rs_evoked_cr(pfc_mod_rs_evoked_hit < -1)) || KStest(pfc_unmod_rs_evoked_cr(pfc_unmod_rs_evoked_hit < -1))
    fprintf(sprintf('PFC RS Suppressed Mod vs Unmod on CR (mann-whitney): p = %d\n', ranksum(pfc_mod_rs_evoked_cr(pfc_mod_rs_evoked_hit < -1), pfc_unmod_rs_evoked_cr(pfc_unmod_rs_evoked_hit < -1))))
else
    [~,p] = ttest2(pfc_mod_rs_evoked_cr(pfc_mod_rs_evoked_hit < -1), pfc_unmod_rs_evoked_cr(pfc_unmod_rs_evoked_hit < -1));
    fprintf(sprintf('PFC RS Suppressed Mod vs Unmod on CR (2 sample t-test): p = %d\n', p))
end

if KStest(pfc_mod_fs_evoked_cr(pfc_mod_fs_evoked_hit < -1)) || KStest(pfc_unmod_fs_evoked_cr(pfc_unmod_fs_evoked_hit < -1))
    fprintf(sprintf('PFC FS Suppressed Mod vs Unmod on CR (mann-whitney): p = %d\n', ranksum(pfc_mod_fs_evoked_cr(pfc_mod_fs_evoked_hit < -1), pfc_unmod_fs_evoked_cr(pfc_unmod_fs_evoked_hit < -1))))
else
    [~,p] = ttest2(pfc_mod_fs_evoked_cr(pfc_mod_fs_evoked_hit < -1), pfc_unmod_fs_evoked_cr(pfc_unmod_fs_evoked_hit < -1));
    fprintf(sprintf('PFC FS Suppressed Mod vs Unmod on CR (2 sample t-test): p = %d\n', p))
end

if KStest(pfc_mod_rs_evoked_fa(pfc_mod_rs_evoked_hit < -1)) || KStest(pfc_unmod_rs_evoked_fa(pfc_unmod_rs_evoked_hit < -1))
    fprintf(sprintf('PFC RS Suppressed Mod vs Unmod on FA (mann-whitney): p = %d\n', ranksum(pfc_mod_rs_evoked_fa(pfc_mod_rs_evoked_hit < -1), pfc_unmod_rs_evoked_fa(pfc_unmod_rs_evoked_hit < -1))))
else
    [~,p] = ttest2(pfc_mod_rs_evoked_fa(pfc_mod_rs_evoked_hit < -1), pfc_unmod_rs_evoked_fa(pfc_unmod_rs_evoked_hit < -1));
    fprintf(sprintf('PFC RS Suppressed Mod vs Unmod on FA (2 sample t-test): p = %d\n', p))
end

if KStest(pfc_mod_fs_evoked_fa(pfc_mod_fs_evoked_hit < -1)) || KStest(pfc_unmod_fs_evoked_fa(pfc_unmod_fs_evoked_hit < -1))
    fprintf(sprintf('PFC FS Suppressed Mod vs Unmod on FA (mann-whitney): p = %d\n', ranksum(pfc_mod_fs_evoked_fa(pfc_mod_fs_evoked_hit < -1), pfc_unmod_fs_evoked_fa(pfc_unmod_fs_evoked_hit < -1))))
else
    [~,p] = ttest2(pfc_mod_fs_evoked_fa(pfc_mod_fs_evoked_hit < -1), pfc_unmod_fs_evoked_fa(pfc_unmod_fs_evoked_hit < -1));
    fprintf(sprintf('PFC FS Suppressed Mod vs Unmod on FA (2 sample t-test): p = %d\n', p))
end


if KStest(striatum_mod_rs_evoked_hit(striatum_mod_rs_evoked_hit < -1)) || KStest(striatum_unmod_rs_evoked_hit(striatum_unmod_rs_evoked_hit < -1))
    fprintf(sprintf('Striatum RS Suppressed Mod vs Unmod on Hit (mann-whitney): p = %d\n', ranksum(striatum_mod_rs_evoked_hit(striatum_mod_rs_evoked_hit < -1), striatum_unmod_rs_evoked_hit(striatum_unmod_rs_evoked_hit < -1))))
else
    [~,p] = ttest2(striatum_mod_rs_evoked_hit(striatum_mod_rs_evoked_hit < -1), striatum_unmod_rs_evoked_hit(striatum_unmod_rs_evoked_hit < -1));
    fprintf(sprintf('Striatum RS Suppressed Mod vs Unmod on Hit (2 sample t-test): p = %d\n', p))
end

% if KStest(striatum_mod_fs_evoked_hit(striatum_mod_fs_evoked_hit < -1)) || KStest(striatum_unmod_fs_evoked_hit(striatum_unmod_fs_evoked_hit < -1))
%     fprintf(sprintf('Striatum FS Suppressed Mod vs Unmod on Hit (mann-whitney): p = %d\n', ranksum(striatum_mod_fs_evoked_hit(striatum_mod_fs_evoked_hit < -1), striatum_unmod_fs_evoked_hit(striatum_unmod_fs_evoked_hit < -1))))
% else
%     [~,p] = ttest2(striatum_mod_fs_evoked_hit(striatum_mod_fs_evoked_hit < -1), striatum_unmod_fs_evoked_hit(striatum_unmod_fs_evoked_hit < -1));
%     fprintf(sprintf('Striatum FS Suppressed Mod vs Unmod on Hit (2 sample t-test): p = %d\n', p))
% end

if KStest(striatum_mod_rs_evoked_miss(striatum_mod_rs_evoked_hit < -1)) || KStest(striatum_unmod_rs_evoked_miss(striatum_unmod_rs_evoked_hit < -1))
    fprintf(sprintf('Striatum RS Suppressed Mod vs Unmod on Miss (mann-whitney): p = %d\n', ranksum(striatum_mod_rs_evoked_miss(striatum_mod_rs_evoked_hit < -1), striatum_unmod_rs_evoked_miss(striatum_unmod_rs_evoked_hit < -1))))
else
    [~,p] = ttest2(striatum_mod_rs_evoked_miss(striatum_mod_rs_evoked_hit < -1), striatum_unmod_rs_evoked_miss(striatum_unmod_rs_evoked_hit < -1));
    fprintf(sprintf('Striatum RS Suppressed Mod vs Unmod on Miss (2 sample t-test): p = %d\n', p))
end

% if KStest(striatum_mod_fs_evoked_miss(striatum_mod_fs_evoked_hit < -1)) || KStest(striatum_unmod_fs_evoked_miss(striatum_unmod_fs_evoked_hit < -1))
%     fprintf(sprintf('Striatum FS Suppressed Mod vs Unmod on Miss (mann-whitney): p = %d\n', ranksum(striatum_mod_fs_evoked_miss(striatum_mod_fs_evoked_hit < -1), striatum_unmod_fs_evoked_miss(striatum_unmod_fs_evoked_hit < -1))))
% else
%     [~,p] = ttest2(striatum_mod_fs_evoked_miss(striatum_mod_fs_evoked_hit < -1), striatum_unmod_fs_evoked_miss(striatum_unmod_fs_evoked_hit < -1));
%     fprintf(sprintf('Striatum FS Suppressed Mod vs Unmod on Miss (2 sample t-test): p = %d\n', p))
% end

if KStest(striatum_mod_rs_evoked_cr(striatum_mod_rs_evoked_hit < -1)) || KStest(striatum_unmod_rs_evoked_cr(striatum_unmod_rs_evoked_hit < -1))
    fprintf(sprintf('Striatum RS Suppressed Mod vs Unmod on CR (mann-whitney): p = %d\n', ranksum(striatum_mod_rs_evoked_cr(striatum_mod_rs_evoked_hit < -1), striatum_unmod_rs_evoked_cr(striatum_unmod_rs_evoked_hit < -1))))
else
    [~,p] = ttest2(striatum_mod_rs_evoked_cr(striatum_mod_rs_evoked_hit < -1), striatum_unmod_rs_evoked_cr(striatum_unmod_rs_evoked_hit < -1));
    fprintf(sprintf('Striatum RS Suppressed Mod vs Unmod on CR (2 sample t-test): p = %d\n', p))
end

% if KStest(striatum_mod_fs_evoked_cr(striatum_mod_fs_evoked_hit < -1)) || KStest(striatum_unmod_fs_evoked_cr(striatum_unmod_fs_evoked_hit < -1))
%     fprintf(sprintf('Striatum FS Suppressed Mod vs Unmod on CR (mann-whitney): p = %d\n', ranksum(striatum_mod_fs_evoked_cr(striatum_mod_fs_evoked_hit < -1), striatum_unmod_fs_evoked_cr(striatum_unmod_fs_evoked_hit < -1))))
% else
%     [~,p] = ttest2(striatum_mod_fs_evoked_cr(striatum_mod_fs_evoked_hit < -1), striatum_unmod_fs_evoked_cr(striatum_unmod_fs_evoked_hit < -1));
%     fprintf(sprintf('Striatum FS Suppressed Mod vs Unmod on CR (2 sample t-test): p = %d\n', p))
% end

if KStest(striatum_mod_rs_evoked_fa(striatum_mod_rs_evoked_hit < -1)) || KStest(striatum_unmod_rs_evoked_fa(striatum_unmod_rs_evoked_hit < -1))
    fprintf(sprintf('Striatum RS Suppressed Mod vs Unmod on FA (mann-whitney): p = %d\n', ranksum(striatum_mod_rs_evoked_fa(striatum_mod_rs_evoked_hit < -1), striatum_unmod_rs_evoked_fa(striatum_unmod_rs_evoked_hit < -1))))
else
    [~,p] = ttest2(striatum_mod_rs_evoked_fa(striatum_mod_rs_evoked_hit < -1), striatum_unmod_rs_evoked_fa(striatum_unmod_rs_evoked_hit < -1));
    fprintf(sprintf('Striatum RS Suppressed Mod vs Unmod on FA (2 sample t-test): p = %d\n', p))
end

% if KStest(striatum_mod_fs_evoked_fa(striatum_mod_fs_evoked_hit < -1)) || KStest(striatum_unmod_fs_evoked_fa(striatum_unmod_fs_evoked_hit < -1))
%     fprintf(sprintf('Striatum FS Suppressed Mod vs Unmod on FA (mann-whitney): p = %d\n', ranksum(striatum_mod_fs_evoked_fa(striatum_mod_fs_evoked_hit < -1), striatum_unmod_fs_evoked_fa(striatum_unmod_fs_evoked_hit < -1))))
% else
%     [~,p] = ttest2(striatum_mod_fs_evoked_fa(striatum_mod_fs_evoked_hit < -1), striatum_unmod_fs_evoked_fa(striatum_unmod_fs_evoked_hit < -1));
%     fprintf(sprintf('Striatum FS Suppressed Mod vs Unmod on FA (2 sample t-test): p = %d\n', p))
% end

saveas(rs_mod_vs_unmod_fr_fig, '../Figures/rs_mod_vs_unmod_fr.svg')
saveas(fs_mod_vs_unmod_fr_fig, '../Figures/fs_mod_vs_unmod_fr.svg')
saveas(evoked_fig, '../Figures/evoked_fr_mod_vs_unmod.svg')
saveas(iti_fig, '../Figures/iti_fr_mod_vs_unmod.svg')
saveas(rs_mod_driven_vs_unmod_driven_fr_fig, '../Figures/rs_driven_mod_vs_unmod_fr.svg')
saveas(fs_mod_driven_vs_unmod_driven_fr_fig, '../Figures/fs_driven_mod_vs_unmod_fr.svg')
saveas(rs_mod_suppressed_vs_unmod_suppressed_fr_fig, '../Figures/rs_suppressed_mod_vs_unmod_fr.svg')
saveas(fs_mod_suppressed_vs_unmod_suppressed_fr_fig, '../Figures/fs_suppressed_mod_vs_unmod_fr.svg')
saveas(pie_fig, '../Figures/mod_unmod_responsiveness.svg')

saveas(rs_mod_vs_unmod_fr_fig, '../Figures/rs_mod_vs_unmod_fr.fig')
saveas(fs_mod_vs_unmod_fr_fig, '../Figures/fs_mod_vs_unmod_fr.fig')
saveas(evoked_fig, '../Figures/evoked_fr_mod_vs_unmod.fig')
saveas(iti_fig, '../Figures/iti_fr_mod_vs_unmod.fig')
saveas(rs_mod_driven_vs_unmod_driven_fr_fig, '../Figures/rs_driven_mod_vs_unmod_fr.fig')
saveas(fs_mod_driven_vs_unmod_driven_fr_fig, '../Figures/fs_driven_mod_vs_unmod_fr.fig')
saveas(rs_mod_suppressed_vs_unmod_suppressed_fr_fig, '../Figures/rs_suppressed_mod_vs_unmod_fr.fig')
saveas(fs_mod_suppressed_vs_unmod_suppressed_fr_fig, '../Figures/fs_suppressed_mod_vs_unmod_fr.fig')
saveas(pie_fig, '../Figures/mod_unmod_responsiveness.fig')

diary off 