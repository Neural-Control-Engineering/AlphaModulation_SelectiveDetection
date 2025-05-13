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

S1 = S1(cell2mat(S1.avg_trial_fr) > 0.5, :);
Striatum = Striatum(cell2mat(Striatum.avg_trial_fr) > 0.5, :);
Amygdala = Amygdala(cell2mat(Amygdala.avg_trial_fr) > 0.5, :);
PFC = PFC(cell2mat(PFC.avg_trial_fr) > 0.5, :);
s1.out.alpha_modulated = s1.out.alpha_modulated(cell2mat(s1.out.alpha_modulated.avg_trial_fr) > 0.5, :);
striatum.out.alpha_modulated = striatum.out.alpha_modulated(cell2mat(striatum.out.alpha_modulated.avg_trial_fr) > 0.5, :);
amygdala.out.alpha_modulated = amygdala.out.alpha_modulated(cell2mat(amygdala.out.alpha_modulated.avg_trial_fr) > 0.5, :);
pfc.out.alpha_modulated = pfc.out.alpha_modulated(cell2mat(pfc.out.alpha_modulated.avg_trial_fr) > 0.5, :);

s1_sessions = unique(S1.session_id);
s1_rs_fracs = zeros(1,length(s1_sessions));
s1_fs_fracs = zeros(1,length(s1_sessions));
s1_ts_fracs = zeros(1,length(s1_sessions));
s1_ps_fracs = zeros(1,length(s1_sessions));
s1_action_fractions = zeros(1,length(s1_sessions));
s1_inaction_fractions = zeros(1,length(s1_sessions));
s1_correct_fractions = zeros(1,length(s1_sessions));
s1_incorrect_fractions = zeros(1,length(s1_sessions));
for s = 1:length(s1_sessions)
    session_id = s1_sessions{s};
    tmp = s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.session_id, session_id),:);
    tmp_all = S1(strcmp(S1.session_id, session_id),:);
    s1_rs_fracs(s) = sum(strcmp(tmp.waveform_class, 'RS')) / sum(strcmp(tmp_all.waveform_class, 'RS'));
    s1_fs_fracs(s) = sum(strcmp(tmp.waveform_class, 'FS')) / sum(strcmp(tmp_all.waveform_class, 'FS'));
    s1_ts_fracs(s) = sum(strcmp(tmp.waveform_class, 'TS')) / sum(strcmp(tmp_all.waveform_class, 'TS'));
    s1_ps_fracs(s) = sum(strcmp(tmp.waveform_class, 'PS')) / sum(strcmp(tmp_all.waveform_class, 'PS'));
    s1_justAction_fractions(s) = sum(tmp.p_action < s1.out.overall_p_threshold & tmp.p_inaction > s1.out.overall_p_threshold) / size(tmp,1);
    s1_justInaction_fractions(s) = sum(tmp.p_inaction < s1.out.overall_p_threshold & tmp.p_action > s1.out.overall_p_threshold) / size(tmp,1);
    s1_actionInaction_fractions(s) = sum(tmp.p_action < s1.out.overall_p_threshold & tmp.p_inaction < s1.out.overall_p_threshold) / size(tmp,1);
    s1_justCorrect_fractions(s) = sum(tmp.p_correct < s1.out.overall_p_threshold & tmp.p_incorrect > s1.out.overall_p_threshold) / size(tmp,1);
    s1_justIncorrect_fractions(s) = sum(tmp.p_incorrect < s1.out.overall_p_threshold & tmp.p_correct > s1.out.overall_p_threshold) / size(tmp,1);
    s1_correctIncorrect_fractions(s) = sum(tmp.p_correct < s1.out.overall_p_threshold & tmp.p_incorrect < s1.out.overall_p_threshold) / size(tmp,1);
    s1_rs = tmp(strcmp(tmp.waveform_class,'RS'),:);
    s1_fs = tmp(strcmp(tmp.waveform_class,'FS'),:);
    s1_rs_justCorrect(s) = sum(s1_rs.p_correct < s1.out.overall_p_threshold & s1_rs.p_incorrect > s1.out.overall_p_threshold) / size(s1_rs,1);
    s1_fs_justCorrect(s) = sum(s1_fs.p_correct < s1.out.overall_p_threshold & s1_fs.p_incorrect > s1.out.overall_p_threshold) / size(s1_fs,1);
    s1_rs_justIncorrect(s) = sum(s1_rs.p_incorrect < s1.out.overall_p_threshold & s1_rs.p_correct > s1.out.overall_p_threshold) / size(s1_rs,1);
    s1_fs_justIncorrect(s) = sum(s1_fs.p_incorrect < s1.out.overall_p_threshold & s1_fs.p_correct > s1.out.overall_p_threshold) / size(s1_fs,1);
    s1_rs_correctIncorrect(s) = sum(s1_rs.p_incorrect < s1.out.overall_p_threshold & s1_rs.p_correct < s1.out.overall_p_threshold) / size(s1_rs,1);
    s1_fs_correctIncorrect(s) = sum(s1_fs.p_incorrect < s1.out.overall_p_threshold & s1_fs.p_correct < s1.out.overall_p_threshold) / size(s1_fs,1);
    s1_rs_justAction(s) = sum(s1_rs.p_action < s1.out.overall_p_threshold & s1_rs.p_inaction > s1.out.overall_p_threshold) / size(s1_rs,1);
    s1_fs_justAction(s) = sum(s1_fs.p_action < s1.out.overall_p_threshold & s1_fs.p_inaction > s1.out.overall_p_threshold) / size(s1_fs,1);
    s1_rs_justInaction(s) = sum(s1_rs.p_inaction < s1.out.overall_p_threshold & s1_rs.p_action > s1.out.overall_p_threshold) / size(s1_rs,1);
    s1_fs_justInaction(s) = sum(s1_fs.p_inaction < s1.out.overall_p_threshold & s1_fs.p_action > s1.out.overall_p_threshold) / size(s1_fs,1);
    s1_rs_actionInaction(s) = sum(s1_rs.p_inaction < s1.out.overall_p_threshold & s1_rs.p_action < s1.out.overall_p_threshold) / size(s1_rs,1);
    s1_fs_actionInaction(s) = sum(s1_fs.p_inaction < s1.out.overall_p_threshold & s1_fs.p_action < s1.out.overall_p_threshold) / size(s1_fs,1);
end

striatum_sessions = unique(Striatum.session_id);
striatum_rs_fracs = zeros(1,length(striatum_sessions));
striatum_fs_fracs = zeros(1,length(striatum_sessions));
striatum_ts_fracs = zeros(1,length(striatum_sessions));
striatum_ps_fracs = zeros(1,length(striatum_sessions));
striatum_action_fractions = zeros(1,length(striatum_sessions));
striatum_inaction_fractions = zeros(1,length(striatum_sessions));
striatum_correct_fractions = zeros(1,length(striatum_sessions));
striatum_incorrect_fractions = zeros(1,length(striatum_sessions));
for s = 1:length(striatum_sessions)
    session_id = striatum_sessions{s};
    tmp = striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.session_id, session_id),:);
    tmp_all = Striatum(strcmp(Striatum.session_id, session_id),:);
    striatum_rs_fracs(s) = sum(strcmp(tmp.waveform_class, 'RS')) / sum(strcmp(tmp_all.waveform_class, 'RS'));
    striatum_fs_fracs(s) = sum(strcmp(tmp.waveform_class, 'FS')) / sum(strcmp(tmp_all.waveform_class, 'FS'));
    striatum_ts_fracs(s) = sum(strcmp(tmp.waveform_class, 'TS')) / sum(strcmp(tmp_all.waveform_class, 'TS'));
    striatum_ps_fracs(s) = sum(strcmp(tmp.waveform_class, 'PS')) / sum(strcmp(tmp_all.waveform_class, 'PS'));
    striatum_justAction_fractions(s) = sum(tmp.p_action < striatum.out.overall_p_threshold & tmp.p_inaction > striatum.out.overall_p_threshold) / size(tmp,1);
    striatum_justInaction_fractions(s) = sum(tmp.p_inaction < striatum.out.overall_p_threshold & tmp.p_action > striatum.out.overall_p_threshold) / size(tmp,1);
    striatum_actionInaction_fractions(s) = sum(tmp.p_action < striatum.out.overall_p_threshold & tmp.p_inaction < striatum.out.overall_p_threshold) / size(tmp,1);
    striatum_justCorrect_fractions(s) = sum(tmp.p_correct < striatum.out.overall_p_threshold & tmp.p_incorrect > striatum.out.overall_p_threshold) / size(tmp,1);
    striatum_justIncorrect_fractions(s) = sum(tmp.p_incorrect < striatum.out.overall_p_threshold & tmp.p_correct > striatum.out.overall_p_threshold) / size(tmp,1);
    striatum_correctIncorrect_fractions(s) = sum(tmp.p_correct < striatum.out.overall_p_threshold & tmp.p_incorrect < striatum.out.overall_p_threshold) / size(tmp,1);
    striatum_rs = tmp(strcmp(tmp.waveform_class,'RS'),:);
    striatum_fs = tmp(strcmp(tmp.waveform_class,'FS'),:);
    striatum_rs_justCorrect(s) = sum(striatum_rs.p_correct < striatum.out.overall_p_threshold & striatum_rs.p_incorrect > striatum.out.overall_p_threshold) / size(striatum_rs,1);
    striatum_fs_justCorrect(s) = sum(striatum_fs.p_correct < striatum.out.overall_p_threshold & striatum_fs.p_incorrect > striatum.out.overall_p_threshold) / size(striatum_fs,1);
    striatum_rs_justIncorrect(s) = sum(striatum_rs.p_incorrect < striatum.out.overall_p_threshold & striatum_rs.p_correct > striatum.out.overall_p_threshold) / size(striatum_rs,1);
    striatum_fs_justIncorrect(s) = sum(striatum_fs.p_incorrect < striatum.out.overall_p_threshold & striatum_fs.p_correct > striatum.out.overall_p_threshold) / size(striatum_fs,1);
    striatum_rs_correctIncorrect(s) = sum(striatum_rs.p_incorrect < striatum.out.overall_p_threshold & striatum_rs.p_correct < striatum.out.overall_p_threshold) / size(striatum_rs,1);
    striatum_fs_correctIncorrect(s) = sum(striatum_fs.p_incorrect < striatum.out.overall_p_threshold & striatum_fs.p_correct < striatum.out.overall_p_threshold) / size(striatum_fs,1);
    striatum_rs_justAction(s) = sum(striatum_rs.p_action < striatum.out.overall_p_threshold & striatum_rs.p_inaction > striatum.out.overall_p_threshold) / size(striatum_rs,1);
    striatum_fs_justAction(s) = sum(striatum_fs.p_action < striatum.out.overall_p_threshold & striatum_fs.p_inaction > striatum.out.overall_p_threshold) / size(striatum_fs,1);
    striatum_rs_justInaction(s) = sum(striatum_rs.p_inaction < striatum.out.overall_p_threshold & striatum_rs.p_action > striatum.out.overall_p_threshold) / size(striatum_rs,1);
    striatum_fs_justInaction(s) = sum(striatum_fs.p_inaction < striatum.out.overall_p_threshold & striatum_fs.p_action > striatum.out.overall_p_threshold) / size(striatum_fs,1);
    striatum_rs_actionInaction(s) = sum(striatum_rs.p_inaction < striatum.out.overall_p_threshold & striatum_rs.p_action < striatum.out.overall_p_threshold) / size(striatum_rs,1);
    striatum_fs_actionInaction(s) = sum(striatum_fs.p_inaction < striatum.out.overall_p_threshold & striatum_fs.p_action < striatum.out.overall_p_threshold) / size(striatum_fs,1);
end

%% amygdala sessions 
amygdala_sessions = unique(Amygdala.session_id);
amygdala_rs_fracs = zeros(1,length(amygdala_sessions));
amygdala_fs_fracs = zeros(1,length(amygdala_sessions));
amygdala_ts_fracs = zeros(1,length(amygdala_sessions));
amygdala_ps_fracs = zeros(1,length(amygdala_sessions));
amygdala_action_fractions = zeros(1,length(amygdala_sessions));
amygdala_inaction_fractions = zeros(1,length(amygdala_sessions));
amygdala_correct_fractions = zeros(1,length(amygdala_sessions));
amygdala_incorrect_fractions = zeros(1,length(amygdala_sessions));
for s = 1:length(amygdala_sessions)
    session_id = amygdala_sessions{s};
    tmp = amygdala.out.alpha_modulated(strcmp(amygdala.out.alpha_modulated.session_id, session_id),:);
    tmp_all = Amygdala(strcmp(Amygdala.session_id, session_id),:);
    amygdala_rs_fracs(s) = sum(strcmp(tmp.waveform_class, 'RS')) / sum(strcmp(tmp_all.waveform_class, 'RS'));
    amygdala_fs_fracs(s) = sum(strcmp(tmp.waveform_class, 'FS')) / sum(strcmp(tmp_all.waveform_class, 'FS'));
    amygdala_ts_fracs(s) = sum(strcmp(tmp.waveform_class, 'TS')) / sum(strcmp(tmp_all.waveform_class, 'TS'));
    amygdala_ps_fracs(s) = sum(strcmp(tmp.waveform_class, 'PS')) / sum(strcmp(tmp_all.waveform_class, 'PS'));
    amygdala_justAction_fractions(s) = sum(tmp.p_action < amygdala.out.overall_p_threshold & tmp.p_inaction > amygdala.out.overall_p_threshold) / size(tmp,1);
    amygdala_justInaction_fractions(s) = sum(tmp.p_inaction < amygdala.out.overall_p_threshold & tmp.p_action > amygdala.out.overall_p_threshold) / size(tmp,1);
    amygdala_actionInaction_fractions(s) = sum(tmp.p_action < amygdala.out.overall_p_threshold & tmp.p_inaction < amygdala.out.overall_p_threshold) / size(tmp,1);
    amygdala_justCorrect_fractions(s) = sum(tmp.p_correct < amygdala.out.overall_p_threshold & tmp.p_incorrect > amygdala.out.overall_p_threshold) / size(tmp,1);
    amygdala_justIncorrect_fractions(s) = sum(tmp.p_incorrect < amygdala.out.overall_p_threshold & tmp.p_correct > amygdala.out.overall_p_threshold) / size(tmp,1);
    amygdala_correctIncorrect_fractions(s) = sum(tmp.p_correct < amygdala.out.overall_p_threshold & tmp.p_incorrect < amygdala.out.overall_p_threshold) / size(tmp,1);
    amygdala_rs = tmp(strcmp(tmp.waveform_class,'RS'),:);
    amygdala_fs = tmp(strcmp(tmp.waveform_class,'FS'),:);
    amygdala_rs_justCorrect(s) = sum(amygdala_rs.p_correct < amygdala.out.overall_p_threshold & amygdala_rs.p_incorrect > amygdala.out.overall_p_threshold) / size(amygdala_rs,1);
    amygdala_fs_justCorrect(s) = sum(amygdala_fs.p_correct < amygdala.out.overall_p_threshold & amygdala_fs.p_incorrect > amygdala.out.overall_p_threshold) / size(amygdala_fs,1);
    amygdala_rs_justIncorrect(s) = sum(amygdala_rs.p_incorrect < amygdala.out.overall_p_threshold & amygdala_rs.p_correct > amygdala.out.overall_p_threshold) / size(amygdala_rs,1);
    amygdala_fs_justIncorrect(s) = sum(amygdala_fs.p_incorrect < amygdala.out.overall_p_threshold & amygdala_fs.p_correct > amygdala.out.overall_p_threshold) / size(amygdala_fs,1);
    amygdala_rs_correctIncorrect(s) = sum(amygdala_rs.p_incorrect < amygdala.out.overall_p_threshold & amygdala_rs.p_correct < amygdala.out.overall_p_threshold) / size(amygdala_rs,1);
    amygdala_fs_correctIncorrect(s) = sum(amygdala_fs.p_incorrect < amygdala.out.overall_p_threshold & amygdala_fs.p_correct < amygdala.out.overall_p_threshold) / size(amygdala_fs,1);
    amygdala_rs_justAction(s) = sum(amygdala_rs.p_action < amygdala.out.overall_p_threshold & amygdala_rs.p_inaction > amygdala.out.overall_p_threshold) / size(amygdala_rs,1);
    amygdala_fs_justAction(s) = sum(amygdala_fs.p_action < amygdala.out.overall_p_threshold & amygdala_fs.p_inaction > amygdala.out.overall_p_threshold) / size(amygdala_fs,1);
    amygdala_rs_justInaction(s) = sum(amygdala_rs.p_inaction < amygdala.out.overall_p_threshold & amygdala_rs.p_action > amygdala.out.overall_p_threshold) / size(amygdala_rs,1);
    amygdala_fs_justInaction(s) = sum(amygdala_fs.p_inaction < amygdala.out.overall_p_threshold & amygdala_fs.p_action > amygdala.out.overall_p_threshold) / size(amygdala_fs,1);
    amygdala_rs_actionInaction(s) = sum(amygdala_rs.p_inaction < amygdala.out.overall_p_threshold & amygdala_rs.p_action < amygdala.out.overall_p_threshold) / size(amygdala_rs,1);
    amygdala_fs_actionInaction(s) = sum(amygdala_fs.p_inaction < amygdala.out.overall_p_threshold & amygdala_fs.p_action < amygdala.out.overall_p_threshold) / size(amygdala_fs,1);
end

%% pfc sessions
pfc_sessions = unique(PFC.session_id);
pfc_rs_fracs = zeros(1,length(pfc_sessions));
pfc_fs_fracs = zeros(1,length(pfc_sessions));
pfc_ts_fracs = zeros(1,length(pfc_sessions));
pfc_ps_fracs = zeros(1,length(pfc_sessions));
pfc_action_fractions = zeros(1,length(pfc_sessions));
pfc_inaction_fractions = zeros(1,length(pfc_sessions));
pfc_correct_fractions = zeros(1,length(pfc_sessions));
pfc_incorrect_fractions = zeros(1,length(pfc_sessions));
for s = 1:length(pfc_sessions)
    session_id = pfc_sessions{s};
    tmp = pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.session_id, session_id),:);
    tmp_all = PFC(strcmp(PFC.session_id, session_id),:);
    pfc_rs_fracs(s) = sum(strcmp(tmp.waveform_class, 'RS')) / sum(strcmp(tmp_all.waveform_class, 'RS'));
    pfc_fs_fracs(s) = sum(strcmp(tmp.waveform_class, 'FS')) / sum(strcmp(tmp_all.waveform_class, 'FS'));
    pfc_ts_fracs(s) = sum(strcmp(tmp.waveform_class, 'TS')) / sum(strcmp(tmp_all.waveform_class, 'TS'));
    pfc_ps_fracs(s) = sum(strcmp(tmp.waveform_class, 'PS')) / sum(strcmp(tmp_all.waveform_class, 'PS'));
    pfc_justAction_fractions(s) = sum(tmp.p_action < pfc.out.overall_p_threshold & tmp.p_inaction > pfc.out.overall_p_threshold) / size(tmp,1);
    pfc_justInaction_fractions(s) = sum(tmp.p_inaction < pfc.out.overall_p_threshold & tmp.p_action > pfc.out.overall_p_threshold) / size(tmp,1);
    pfc_actionInaction_fractions(s) = sum(tmp.p_action < pfc.out.overall_p_threshold & tmp.p_inaction < pfc.out.overall_p_threshold) / size(tmp,1);
    pfc_justCorrect_fractions(s) = sum(tmp.p_correct < pfc.out.overall_p_threshold & tmp.p_incorrect > pfc.out.overall_p_threshold) / size(tmp,1);
    pfc_justIncorrect_fractions(s) = sum(tmp.p_incorrect < pfc.out.overall_p_threshold & tmp.p_correct > pfc.out.overall_p_threshold) / size(tmp,1);
    pfc_correctIncorrect_fractions(s) = sum(tmp.p_correct < pfc.out.overall_p_threshold & tmp.p_incorrect < pfc.out.overall_p_threshold) / size(tmp,1);
    pfc_rs = tmp(strcmp(tmp.waveform_class,'RS'),:);
    pfc_fs = tmp(strcmp(tmp.waveform_class,'FS'),:);
    pfc_rs_justCorrect(s) = sum(pfc_rs.p_correct < pfc.out.overall_p_threshold & pfc_rs.p_incorrect > pfc.out.overall_p_threshold) / size(pfc_rs,1);
    pfc_fs_justCorrect(s) = sum(pfc_fs.p_correct < pfc.out.overall_p_threshold & pfc_fs.p_incorrect > pfc.out.overall_p_threshold) / size(pfc_fs,1);
    pfc_rs_justIncorrect(s) = sum(pfc_rs.p_incorrect < pfc.out.overall_p_threshold & pfc_rs.p_correct > pfc.out.overall_p_threshold) / size(pfc_rs,1);
    pfc_fs_justIncorrect(s) = sum(pfc_fs.p_incorrect < pfc.out.overall_p_threshold & pfc_fs.p_correct > pfc.out.overall_p_threshold) / size(pfc_fs,1);
    pfc_rs_correctIncorrect(s) = sum(pfc_rs.p_incorrect < pfc.out.overall_p_threshold & pfc_rs.p_correct < pfc.out.overall_p_threshold) / size(pfc_rs,1);
    pfc_fs_correctIncorrect(s) = sum(pfc_fs.p_incorrect < pfc.out.overall_p_threshold & pfc_fs.p_correct < pfc.out.overall_p_threshold) / size(pfc_fs,1);
    pfc_rs_justAction(s) = sum(pfc_rs.p_action < pfc.out.overall_p_threshold & pfc_rs.p_inaction > pfc.out.overall_p_threshold) / size(pfc_rs,1);
    pfc_fs_justAction(s) = sum(pfc_fs.p_action < pfc.out.overall_p_threshold & pfc_fs.p_inaction > pfc.out.overall_p_threshold) / size(pfc_fs,1);
    pfc_rs_justInaction(s) = sum(pfc_rs.p_inaction < pfc.out.overall_p_threshold & pfc_rs.p_action > pfc.out.overall_p_threshold) / size(pfc_rs,1);
    pfc_fs_justInaction(s) = sum(pfc_fs.p_inaction < pfc.out.overall_p_threshold & pfc_fs.p_action > pfc.out.overall_p_threshold) / size(pfc_fs,1);
    pfc_rs_actionInaction(s) = sum(pfc_rs.p_inaction < pfc.out.overall_p_threshold & pfc_rs.p_action < pfc.out.overall_p_threshold) / size(pfc_rs,1);
    pfc_fs_actionInaction(s) = sum(pfc_fs.p_inaction < pfc.out.overall_p_threshold & pfc_fs.p_action < pfc.out.overall_p_threshold) / size(pfc_fs,1);
end

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

    s1_unmod_rs_hit = [s1_unmod_rs_hit; cell2mat(S1_rs.left_trigger_aligned_avg_fr_Hit)];
    s1_unmod_fs_hit = [s1_unmod_fs_hit; cell2mat(S1_fs.left_trigger_aligned_avg_fr_Hit)];
    s1_unmod_rs_miss = [s1_unmod_rs_miss; cell2mat(S1_rs.left_trigger_aligned_avg_fr_Miss)];
    s1_unmod_fs_miss = [s1_unmod_fs_miss; cell2mat(S1_fs.left_trigger_aligned_avg_fr_Miss)];
    s1_unmod_rs_cr = [s1_unmod_rs_cr; cell2mat(S1_rs.right_trigger_aligned_avg_fr_CR)];
    s1_unmod_fs_cr = [s1_unmod_fs_cr; cell2mat(S1_fs.right_trigger_aligned_avg_fr_CR)];
    s1_unmod_rs_fa = [s1_unmod_rs_fa; cell2mat(S1_rs.right_trigger_aligned_avg_fr_FA)];
    s1_unmod_fs_fa = [s1_unmod_fs_fa; cell2mat(S1_fs.right_trigger_aligned_avg_fr_FA)];

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
    pfc_mod_rs_miss = [pfc_mod_rs_miss; cell2mat(pfc_rs.left_trigger_aligned_avg_fr_Miss)];
    pfc_mod_fs_miss = [pfc_mod_fs_miss; cell2mat(pfc_fs.left_trigger_aligned_avg_fr_Miss)];
    pfc_mod_rs_cr = [pfc_mod_rs_cr; cell2mat(pfc_rs.right_trigger_aligned_avg_fr_CR)];
    pfc_mod_fs_cr = [pfc_mod_fs_cr; cell2mat(pfc_fs.right_trigger_aligned_avg_fr_CR)];
    pfc_mod_rs_fa = [pfc_mod_rs_fa; cell2mat(pfc_rs.right_trigger_aligned_avg_fr_FA)];
    pfc_mod_fs_fa = [pfc_mod_fs_fa; cell2mat(pfc_fs.right_trigger_aligned_avg_fr_FA)];

    pfc_unmod_rs_hit = [pfc_unmod_rs_hit; cell2mat(PFC_rs.left_trigger_aligned_avg_fr_Hit)];
    pfc_unmod_fs_hit = [pfc_unmod_fs_hit; cell2mat(PFC_fs.left_trigger_aligned_avg_fr_Hit)];
    pfc_unmod_rs_miss = [pfc_unmod_rs_miss; cell2mat(PFC_rs.left_trigger_aligned_avg_fr_Miss)];
    pfc_unmod_fs_miss = [pfc_unmod_fs_miss; cell2mat(PFC_fs.left_trigger_aligned_avg_fr_Miss)];
    pfc_unmod_rs_cr = [pfc_unmod_rs_cr; cell2mat(PFC_rs.right_trigger_aligned_avg_fr_CR)];
    pfc_unmod_fs_cr = [pfc_unmod_fs_cr; cell2mat(PFC_fs.right_trigger_aligned_avg_fr_CR)];
    pfc_unmod_rs_fa = [pfc_unmod_rs_fa; cell2mat(PFC_rs.right_trigger_aligned_avg_fr_FA)];
    pfc_unmod_fs_fa = [pfc_unmod_fs_fa; cell2mat(PFC_fs.right_trigger_aligned_avg_fr_FA)];

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

    striatum_unmod_rs_hit = [striatum_unmod_rs_hit; cell2mat(Striatum_rs.left_trigger_aligned_avg_fr_Hit)];
    striatum_unmod_fs_hit = [striatum_unmod_fs_hit; cell2mat(Striatum_fs.left_trigger_aligned_avg_fr_Hit)];
    striatum_unmod_rs_miss = [striatum_unmod_rs_miss; cell2mat(Striatum_rs.left_trigger_aligned_avg_fr_Miss)];
    striatum_unmod_fs_miss = [striatum_unmod_fs_miss; cell2mat(Striatum_fs.left_trigger_aligned_avg_fr_Miss)];
    striatum_unmod_rs_cr = [striatum_unmod_rs_cr; cell2mat(Striatum_rs.right_trigger_aligned_avg_fr_CR)];
    striatum_unmod_fs_cr = [striatum_unmod_fs_cr; cell2mat(Striatum_fs.right_trigger_aligned_avg_fr_CR)];
    striatum_unmod_rs_fa = [striatum_unmod_rs_fa; cell2mat(Striatum_rs.right_trigger_aligned_avg_fr_FA)];
    striatum_unmod_fs_fa = [striatum_unmod_fs_fa; cell2mat(Striatum_fs.right_trigger_aligned_avg_fr_FA)];

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

    amygdala_unmod_rs_hit = [amygdala_unmod_rs_hit; cell2mat(Amygdala_rs.left_trigger_aligned_avg_fr_Hit)];
    amygdala_unmod_fs_hit = [amygdala_unmod_fs_hit; cell2mat(Amygdala_fs.left_trigger_aligned_avg_fr_Hit)];
    amygdala_unmod_rs_miss = [amygdala_unmod_rs_miss; cell2mat(Amygdala_rs.left_trigger_aligned_avg_fr_Miss)];
    amygdala_unmod_fs_miss = [amygdala_unmod_fs_miss; cell2mat(Amygdala_fs.left_trigger_aligned_avg_fr_Miss)];
    amygdala_unmod_rs_cr = [amygdala_unmod_rs_cr; cell2mat(Amygdala_rs.right_trigger_aligned_avg_fr_CR)];
    amygdala_unmod_fs_cr = [amygdala_unmod_fs_cr; cell2mat(Amygdala_fs.right_trigger_aligned_avg_fr_CR)];
    amygdala_unmod_rs_fa = [amygdala_unmod_rs_fa; cell2mat(Amygdala_rs.right_trigger_aligned_avg_fr_FA)];
    amygdala_unmod_fs_fa = [amygdala_unmod_fs_fa; cell2mat(Amygdala_fs.right_trigger_aligned_avg_fr_FA)];

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

pfc_rs = pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.waveform_class,'RS'),:);
pfc_fs = pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.waveform_class,'FS'),:);
s1_rs = s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.waveform_class,'RS'),:);
s1_fs = s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.waveform_class,'FS'),:);
striatum_rs = striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.waveform_class,'RS'),:);
striatum_fs = striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.waveform_class,'FS'),:);
amygdala_rs = amygdala.out.alpha_modulated(strcmp(amygdala.out.alpha_modulated.waveform_class,'RS'),:);
amygdala_fs = amygdala.out.alpha_modulated(strcmp(amygdala.out.alpha_modulated.waveform_class,'FS'),:);

%% fraction fig 
fracs_fig = figure('Position', [1220 1274 963 444]);
frac_avgs = [nanmean(s1_rs_fracs), nanmean(s1_fs_fracs), ...
    nanmean(pfc_rs_fracs), nanmean(pfc_fs_fracs), ...
    nanmean(striatum_rs_fracs), nanmean(striatum_fs_fracs), ...
    nanmean(amygdala_rs_fracs), nanmean(amygdala_fs_fracs)];

frac_errs = [nanstd(s1_rs_fracs)/sqrt(sum(~isnan(s1_rs_fracs))), nanstd(s1_fs_fracs)/sqrt(sum(~isnan(s1_fs_fracs))), ...
    nanstd(pfc_rs_fracs)/sqrt(sum(~isnan(pfc_rs_fracs))), nanstd(pfc_fs_fracs)/sqrt(sum(~isnan(pfc_fs_fracs))), ...
    nanstd(striatum_rs_fracs)/sqrt(sum(~isnan(striatum_rs_fracs))), nanstd(striatum_fs_fracs)/sqrt(sum(~isnan(striatum_fs_fracs))), ...
    nanstd(amygdala_rs_fracs)/sqrt(sum(~isnan(amygdala_rs_fracs))), nanstd(amygdala_fs_fracs)/sqrt(sum(~isnan(amygdala_fs_fracs)))];
x = [1,2,4,5,7,8,10,11];
bar(x, frac_avgs .* 100, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(x, frac_avgs .* 100, frac_errs .* 100, 'k.')
xticks(x)
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS', 'Amygdala RS', 'Amygdala FS'})
xtickangle(45)
ylim([0,100])
yticks([0,100])
ylabel('% Neurons Modulated by Alpha', 'FontSize', 18)
ax = gca;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 16;

% hold on 
% bar(1:2, [mean(s1_rs_fracs), mean(s1_fs_fracs)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
% errorbar(1:2, [mean(s1_rs_fracs), mean(s1_fs_fracs)], ... 
%     [std(s1_rs_fracs)/sqrt(length((s1_rs_fracs))), std(s1_fs_fracs)/sqrt(length((s1_fs_fracs)))], 'k.')

%% parts for overview figure - s1
s1_mod_fig = figure('Position', [1220 1269 1071 569]);
tl = tiledlayout(2,3, 'TileSpacing', 'compact');
% axs(1) = nexttile([2,1]);
% axs(1) = nexttile;
% hold on 
% bar(1:2, [mean(s1_rs_fracs), mean(s1_fs_fracs)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
% errorbar(1:2, [mean(s1_rs_fracs), mean(s1_fs_fracs)], ... 
%     [std(s1_rs_fracs)/sqrt(length((s1_rs_fracs))), std(s1_fs_fracs)/sqrt(length((s1_fs_fracs)))], 'k.')
% ylim([0,1])
% yticks([0,0.5,1])
% xticks(1:2)
% xticklabels({'RS', 'FS'})
% ylabel('Fraction of Alpha Modulated Units')
axs(1) = nexttile;
hold on 
bar(1:2, [nanmean(s1_rs.pmi), nanmean(s1_fs.pmi)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:2, [nanmean(s1_rs.pmi), nanmean(s1_fs.pmi)], ... 
    [nanstd(s1_rs.pmi)/sqrt(sum(~isnan((s1_rs.pmi)))), nanstd(s1_fs.pmi)/sqrt(sum(~isnan((s1_fs.pmi))))], 'k.')
% ylim([0,1])
% yticks([0,0.5,1])
lims = ylim;
ylim([0,lims(2)])
yticks([0,lims(2)])
xticks(1:2)
xticklabels({'RS', 'FS'})
ylabel('Modulation Index')

axs(2) = nexttile;
polarhistogram(s1_rs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
thetaticks([0 90 180 270])
% Access the current polar axes
pax = gca;
% Customize the radial grid (axis markers)
pax.GridColor = [0 0 0];          % Black grid lines
pax.GridAlpha = 1;                % Fully opaque grid lines
pax.GridLineStyle = '--';         % Dashed grid lines for visibility
rlim([0,25])
hold on 
polarplot([circ_mean(s1_rs.theta_bars), circ_mean(s1_rs.theta_bars)], [0,25], 'r--', 'LineWidth', 2)
title({'Regular Spiking'}, 'FontWeight', 'normal')

axs(3) = nexttile;
polarhistogram(s1_fs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
thetaticks([0 90 180 270])
% Access the current polar axes
pax = gca;
% Customize the radial grid (axis markers)
pax.GridColor = [0 0 0];          % Black grid lines
pax.GridAlpha = 1;                % Fully opaque grid lines
pax.GridLineStyle = '--';         % Dashed grid lines for visibility
rlim([0,25])
hold on 
polarplot([circ_mean(s1_fs.theta_bars), circ_mean(s1_fs.theta_bars)], [0,25], 'r--', 'LineWidth', 2)
title({'Fast Spiking'}, 'FontWeight', 'normal')

axs(4) = nexttile;
hold on 
bar(1:2, [nanmean(s1_rs.mses), nanmean(s1_fs.mses)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:2, [nanmean(s1_rs.mses), nanmean(s1_fs.mses)], ... 
    [nanstd(s1_rs.mses)/sqrt(sum(~isnan((s1_rs.mses)))), nanstd(s1_fs.mses)/sqrt(sum(~isnan((s1_fs.mses))))], 'k.')
% ylim([0,1])
% yticks([0,0.5,1])
lims = ylim;
ylim([0,lims(2)])
yticks([0,lims(2)])
xticks(1:2)
xticklabels({'RS', 'FS'})
ylabel('von Mises MSE')

axs(5) = nexttile;
semshade(s1_mod_rs_hit-mean(s1_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_rs_hit-mean(s1_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
yticks([-1,3])
xticks([-2,0,2,4])
ylabel('\Delta Firing Rate (Hz)')
xlabel('Time (s)')

axs(6) = nexttile;
semshade(s1_mod_fs_hit-mean(s1_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_fs_hit-mean(s1_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-2,15])
yticks([-2,15])
xticks([-2,0,2,4])
ylabel('\Delta Firing Rate (Hz)')
xlabel('Time (s)')
title(tl, 'Somatosensory Cortex')
legend()

fprintf(sprintf('S1 RS theta bars vs FS theta bars Kuiper test: p = %d\n', circ_kuipertest(s1_rs.theta_bars, s1_fs.theta_bars)))
if KStest(s1_rs.pmi) || KStest(s1_fs.pmi)
    fprintf(sprintf('S1 RS MI vs FS MI Mann Whitney: p = %d\n', ranksum(s1_rs.pmi, s1_fs.pmi)))
else
    [~,p] = ttest2(s1_rs.pmi, s1_fs.pmi);
    fprintf(sprintf('S1 RS MI vs FS MI 2-sample t-test: p = %d\n', p))
end
if KStest(s1_rs.mses) || KStest(s1_fs.mses)
    fprintf(sprintf('S1 RS von Mises MSE vs FS von Mises MSE Mann Whitney: p = %d\n', ranksum(s1_rs.mses, s1_fs.mses)))
else
    [~,p] = ttest2(s1_rs.mses, s1_fs.mses);
    fprintf(sprintf('S1 RS von Mises MSE vs FS von Mises MSE 2-sample t-test: p = %d\n', p))
end
if KStest(s1_rs_fracs) || KStest(s1_fs_fracs)
    fprintf(sprintf('S1 RS vs FS fraction (Mann-Whitney): p = %d\n', ranksum(s1_rs_fracs, s1_fs_fracs)))
else
    [~,p] = ttest2(s1_rs_fracs, s1_fs_fracs);
    fprintf(sprintf('S1 RS vs FS fraction (Mann-Whitney): p = %d\n', p))
end
fprintf(sprintf('S1 RS mean theta bar: %d +/- %d\n', circ_mean(s1_rs.theta_bars), circ_std(s1_rs.theta_bars) / sqrt(length(s1_rs.theta_bars))))
fprintf(sprintf('S1 FS mean theta bar: %d +/- %d\n', circ_mean(s1_fs.theta_bars), circ_std(s1_fs.theta_bars) / sqrt(length(s1_fs.theta_bars))))

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

%% parts for overview figure - pfc
pfc_mod_fig = figure('Position', [1220 1269 1071 569]);
tl = tiledlayout(2,3, 'TileSpacing', 'compact');
% axs(1) = nexttile([2,1]);
% axs(1) = nexttile;
% hold on
% bar(1:2, [mean(pfc_rs_fracs), mean(pfc_fs_fracs)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
% errorbar(1:2, [mean(pfc_rs_fracs), mean(pfc_fs_fracs)], ... 
%     [std(pfc_rs_fracs)/sqrt(length((pfc_rs_fracs))), std(pfc_fs_fracs)/sqrt(length((pfc_fs_fracs)))], 'k.')
% ylim([0,1])
% yticks([0,0.5,1])
% xticks(1:2)
% xticklabels({'RS', 'FS'})
% ylabel('Fraction of Alpha Modulated Units')
axs(1) = nexttile;
hold on 
bar(1:2, [nanmean(pfc_rs.pmi), nanmean(pfc_fs.pmi)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:2, [nanmean(pfc_rs.pmi), nanmean(pfc_fs.pmi)], ... 
    [nanstd(pfc_rs.pmi)/sqrt(sum(~isnan((pfc_rs.pmi)))), nanstd(pfc_fs.pmi)/sqrt(sum(~isnan((pfc_fs.pmi))))], 'k.')
% ylim([0,1])
% yticks([0,0.5,1])
lims = ylim;
ylim([0,lims(2)])
yticks([0,lims(2)])
xticks(1:2)
xticklabels({'RS', 'FS'})
ylabel('Modulation Index')

axs(2) = nexttile;
polarhistogram(pfc_rs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
thetaticks([0 90 180 270])
% Access the current polar axes
pax = gca;
% Customize the radial grid (axis markers)
pax.GridColor = [0 0 0];          % Black grid lines
pax.GridAlpha = 1;                % Fully opaque grid lines
pax.GridLineStyle = '--';         % Dashed grid lines for visibility
rlim([0,15])
hold on 
polarplot([circ_mean(pfc_rs.theta_bars),circ_mean(pfc_rs.theta_bars)], [0,15], 'r--', 'LineWidth', 2)
title({'Regular Spiking'}, 'FontWeight', 'normal')

axs(3) = nexttile;
polarhistogram(pfc_fs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
thetaticks([0 90 180 270])
% Access the current polar axes
pax = gca;
% Customize the radial grid (axis markers)
pax.GridColor = [0 0 0];          % Black grid lines
pax.GridAlpha = 1;                % Fully opaque grid lines
pax.GridLineStyle = '--';         % Dashed grid lines for visibility
rlim([0,15])
hold on 
polarplot([circ_mean(pfc_fs.theta_bars),circ_mean(pfc_fs.theta_bars)], [0,15], 'r--', 'LineWidth', 2)
title({'Fast Spiking'}, 'FontWeight', 'normal')

axs(4) = nexttile;
hold on 
bar(1:2, [nanmean(pfc_rs.mses), nanmean(pfc_fs.mses)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:2, [nanmean(pfc_rs.mses), nanmean(pfc_fs.mses)], ... 
    [nanstd(pfc_rs.mses)/sqrt(sum(~isnan((pfc_rs.mses)))), nanstd(pfc_fs.mses)/sqrt(sum(~isnan((pfc_fs.mses))))], 'k.')
% ylim([0,1])
% yticks([0,0.5,1])
lims = ylim;
ylim([0,lims(2)])
yticks([0,lims(2)])
xticks(1:2)
xticklabels({'RS', 'FS'})
ylabel('von Mises MSE')

axs(5) = nexttile;
semshade(pfc_mod_rs_hit-mean(pfc_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_rs_hit-mean(pfc_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
yticks([-1,3])
xticks([-2,0,2,4])
ylabel('\Delta Firing Rate (Hz)')
xlabel('Time (s)')

axs(6) = nexttile;
semshade(pfc_mod_fs_hit-mean(pfc_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_fs_hit-mean(pfc_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-2,15])
yticks([-2,15])
xticks([-2,0,2,4])
ylabel('\Delta Firing Rate (Hz)')
xlabel('Time (s)')
legend()
title(tl, 'Prefrontal Cortex')

fprintf(sprintf('PFC RS theta bars vs FS theta bars Kuiper test: p = %d\n', circ_kuipertest(pfc_rs.theta_bars, pfc_fs.theta_bars)))
if KStest(pfc_rs.pmi) || KStest(pfc_fs.pmi)
    fprintf(sprintf('PFC RS MI vs FS MI Mann Whitney: p = %d\n', ranksum(pfc_rs.pmi, pfc_fs.pmi)))
else
    [~,p] = ttest2(pfc_rs.pmi, pfc_fs.pmi);
    fprintf(sprintf('PFC RS MI vs FS MI 2-sample t-test: p = %d\n', p))
end
if KStest(pfc_rs.mses) || KStest(pfc_fs.mses)
    fprintf(sprintf('PFC RS von Mises MSE vs FS von Mises MSE Mann Whitney: p = %d\n', ranksum(pfc_rs.mses, pfc_fs.mses)))
else
    [~,p] = ttest2(pfc_rs.mses, pfc_fs.mses);
    fprintf(sprintf('PFC RS von Mises MSE vs FS von Mises MSE 2-sample t-test: p = %d\n', p))
end
if KStest(pfc_rs_fracs) || KStest(pfc_fs_fracs)
    fprintf(sprintf('PFC RS vs FS fraction (Mann-Whitney): p = %d\n', ranksum(pfc_rs_fracs, pfc_fs_fracs)))
else
    [~,p] = ttest2(pfc_rs_fracs, pfc_fs_fracs);
    fprintf(sprintf('PFC RS vs FS fraction (Mann-Whitney): p = %d\n', p))
end
fprintf(sprintf('PFC RS mean theta bar: %d +/- %d\n', circ_mean(pfc_rs.theta_bars), circ_std(pfc_rs.theta_bars) / sqrt(length(pfc_rs.theta_bars))))
fprintf(sprintf('PFC FS mean theta bar: %d +/- %d\n', circ_mean(pfc_fs.theta_bars), circ_std(pfc_fs.theta_bars) / sqrt(length(pfc_fs.theta_bars))))

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

%% parts for overview figure - striatum
striatum_mod_fig = figure('Position', [1220 1269 1071 569]);
tl = tiledlayout(2,3, 'TileSpacing', 'compact');
% axs(1) = nexttile([2,1]);
% axs(1) = nexttile;
% hold on
% bar(1:2, [mean(striatum_rs_fracs), mean(striatum_fs_fracs)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
% errorbar(1:2, [mean(striatum_rs_fracs), mean(striatum_fs_fracs)], ... 
%     [std(striatum_rs_fracs)/sqrt(length((striatum_rs_fracs))), std(striatum_fs_fracs)/sqrt(length((striatum_fs_fracs)))], 'k.')
% ylim([0,1])
% yticks([0,0.5,1])
% xticks(1:2)
% xticklabels({'RS', 'FS'})
% ylabel('Fraction of Alpha Modulated Units')
axs(1) = nexttile;
hold on 
bar(1:2, [nanmean(striatum_rs.pmi), nanmean(striatum_fs.pmi)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:2, [nanmean(striatum_rs.pmi), nanmean(striatum_fs.pmi)], ... 
    [nanstd(striatum_rs.pmi)/sqrt(sum(~isnan((striatum_rs.pmi)))), nanstd(striatum_fs.pmi)/sqrt(sum(~isnan((striatum_fs.pmi))))], 'k.')
% ylim([0,1])
% yticks([0,0.5,1])
lims = ylim;
ylim([0,lims(2)])
yticks([0,lims(2)])
xticks(1:2)
xticklabels({'RS', 'FS'})
ylabel('Modulation Index')

axs(2) = nexttile;
polarhistogram(striatum_rs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
thetaticks([0 90 180 270])
% Access the current polar axes
pax = gca;
% Customize the radial grid (axis markers)
pax.GridColor = [0 0 0];          % Black grid lines
pax.GridAlpha = 1;                % Fully opaque grid lines
pax.GridLineStyle = '--';         % Dashed grid lines for visibility
rlim([0,5])
hold on 
polarplot([circ_mean(striatum_rs.theta_bars),circ_mean(striatum_rs.theta_bars)], [0,15], 'r--', 'LineWidth', 2)
title({'Regular Spiking'}, 'FontWeight', 'normal')

axs(3) = nexttile;
polarhistogram(striatum_fs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
thetaticks([0 90 180 270])
% Access the current polar axes
pax = gca;
% Customize the radial grid (axis markers)
pax.GridColor = [0 0 0];          % Black grid lines
pax.GridAlpha = 1;                % Fully opaque grid lines
pax.GridLineStyle = '--';         % Dashed grid lines for visibility
rlim([0,5])
hold on 
polarplot([circ_mean(striatum_fs.theta_bars),circ_mean(striatum_fs.theta_bars)], [0,15], 'r--', 'LineWidth', 2)
title({'Fast Spiking'}, 'FontWeight', 'normal')

axs(4) = nexttile;
hold on 
bar(1:2, [nanmean(striatum_rs.mses), nanmean(striatum_fs.mses)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:2, [nanmean(striatum_rs.mses), nanmean(striatum_fs.mses)], ... 
    [nanstd(striatum_rs.mses)/sqrt(sum(~isnan((striatum_rs.mses)))), nanstd(striatum_fs.mses)/sqrt(sum(~isnan((striatum_fs.mses))))], 'k.')
% ylim([0,1])
% yticks([0,0.5,1])
lims = ylim;
ylim([0,lims(2)])
yticks([0,lims(2)])
xticks(1:2)
xticklabels({'RS', 'FS'})
ylabel('von Mises MSE')

axs(5) = nexttile;
semshade(striatum_mod_rs_hit-mean(striatum_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_rs_hit-mean(striatum_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,25])
yticks([-5,25])
xticks([-2,0,2,4])
ylabel('\Delta Firing Rate (Hz)')
xlabel('Time (s)')

axs(6) = nexttile;
semshade(striatum_mod_fs_hit-mean(striatum_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_fs_hit-mean(striatum_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-2,15])
yticks([-2,15])
xticks([-2,0,2,4])
ylabel('\Delta Firing Rate (Hz)')
xlabel('Time (s)')
legend()
title(tl, 'Striatum')

fprintf(sprintf('Striatum RS theta bars vs FS theta bars Kuiper test: p = %d\n', circ_kuipertest(striatum_rs.theta_bars, striatum_fs.theta_bars)))
if KStest(striatum_rs.pmi) || KStest(striatum_fs.pmi)
    fprintf(sprintf('Striatum RS MI vs FS MI Mann Whitney: p = %d\n', ranksum(striatum_rs.pmi, striatum_fs.pmi)))
else
    [~,p] = ttest2(striatum_rs.pmi, striatum_fs.pmi);
    fprintf(sprintf('Striatum RS MI vs FS MI 2-sample t-test: p = %d\n', p))
end
if KStest(striatum_rs.mses) || KStest(striatum_fs.mses)
    fprintf(sprintf('Striatum RS von Mises MSE vs FS von Mises MSE Mann Whitney: p = %d\n', ranksum(striatum_rs.mses, striatum_fs.mses)))
else
    [~,p] = ttest2(striatum_rs.mses, striatum_fs.mses);
    fprintf(sprintf('Striatum RS von Mises MSE vs FS von Mises MSE 2-sample t-test: p = %d\n', p))
end
if KStest(striatum_rs_fracs) || KStest(striatum_fs_fracs)
    fprintf(sprintf('Striatum RS vs FS fraction (Mann-Whitney): p = %d\n', ranksum(striatum_rs_fracs, striatum_fs_fracs)))
else
    [~,p] = ttest2(striatum_rs_fracs, striatum_fs_fracs);
    fprintf(sprintf('Striatum RS vs FS fraction (Mann-Whitney): p = %d\n', p))
end
fprintf(sprintf('Striatum RS mean theta bar: %d +/- %d\n', circ_mean(striatum_rs.theta_bars), circ_std(striatum_rs.theta_bars) / sqrt(length(striatum_rs.theta_bars))))
fprintf(sprintf('Striatum FS mean theta bar: %d +/- %d\n\n', circ_mean(striatum_fs.theta_bars), circ_std(striatum_fs.theta_bars) / sqrt(length(striatum_fs.theta_bars))))

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

%% parts for overview figure - amygdala
amygdala_mod_fig = figure('Position', [1220 1269 1071 569]);
tl = tiledlayout(2,3, 'TileSpacing', 'compact');
% axs(1) = nexttile([2,1]);
% hold on
% bar(1:2, [mean(amygdala_rs_fracs), mean(amygdala_fs_fracs)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
% errorbar(1:2, [mean(amygdala_rs_fracs), mean(amygdala_fs_fracs)], ... 
%     [std(amygdala_rs_fracs)/sqrt(length((amygdala_rs_fracs))), std(amygdala_fs_fracs)/sqrt(length((amygdala_fs_fracs)))], 'k.')
% ylim([0,1])
% yticks([0,0.5,1])
% xticks(1:2)
% xticklabels({'RS', 'FS'})
% ylabel('Fraction of Alpha Modulated Units')
axs(1) = nexttile;
hold on 
bar(1:2, [nanmean(amygdala_rs.pmi), nanmean(amygdala_fs.pmi)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:2, [nanmean(amygdala_rs.pmi), nanmean(amygdala_fs.pmi)], ... 
    [nanstd(amygdala_rs.pmi)/sqrt(sum(~isnan((amygdala_rs.pmi)))), nanstd(amygdala_fs.pmi)/sqrt(sum(~isnan((amygdala_fs.pmi))))], 'k.')
% ylim([0,1])
% yticks([0,0.5,1])
lims = ylim;
ylim([0,lims(2)])
yticks([0,lims(2)])
xticks(1:2)
xticklabels({'RS', 'FS'})
ylabel('Modulation Index')

axs(2) = nexttile;
polarhistogram(amygdala_rs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on 
polarplot([circ_mean(amygdala_rs.theta_bars), circ_mean(amygdala_rs.theta_bars)], [0, 10], 'r--', 'LineWidth', 2)
thetaticks([0 90 180 270])
% Access the current polar axes
pax = gca;
% Customize the radial grid (axis markers)
pax.GridColor = [0 0 0];          % Black grid lines
pax.GridAlpha = 1;                % Fully opaque grid lines
pax.GridLineStyle = '--';         % Dashed grid lines for visibility
rlim([0,2])
% title({'Somatosensory Cortex', 'Regular Spiking'}, 'FontWeight', 'normal')
title({'Regular Spiking'}, 'FontWeight', 'normal')

axs(3) = nexttile;
polarhistogram(amygdala_fs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
polarplot([circ_mean(amygdala_fs.theta_bars), circ_mean(amygdala_fs.theta_bars)], [0, 10], 'r--', 'LineWidth', 2)
thetaticks([0 90 180 270])
% Access the current polar axes
pax = gca;
% Customize the radial grid (axis markers)
pax.GridColor = [0 0 0];          % Black grid lines
pax.GridAlpha = 1;                % Fully opaque grid lines
pax.GridLineStyle = '--';         % Dashed grid lines for visibility
rlim([0,2])
title({'Fast Spiking'}, 'FontWeight', 'normal')

axs(4) = nexttile;
hold on 
bar(1:2, [nanmean(amygdala_rs.mses), nanmean(amygdala_fs.mses)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:2, [nanmean(amygdala_rs.mses), nanmean(amygdala_fs.mses)], ... 
    [nanstd(amygdala_rs.mses)/sqrt(sum(~isnan((amygdala_rs.mses)))), nanstd(amygdala_fs.mses)/sqrt(sum(~isnan((amygdala_fs.mses))))], 'k.')
% ylim([0,1])
% yticks([0,0.5,1])
lims = ylim;
ylim([0,lims(2)])
yticks([0,lims(2)])
xticks(1:2)
xticklabels({'RS', 'FS'})
ylabel('von Mises MSE')

axs(5) = nexttile;
semshade(amygdala_mod_rs_hit-mean(amygdala_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(amygdala_unmod_rs_hit-mean(amygdala_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-10,70])
yticks([-10,70])
xticks([-2,0,2,4])
ylabel('\Delta Firing Rate (Hz)')
xlabel('Time (s)')

axs(6) = nexttile;
semshade(amygdala_mod_fs_hit-mean(amygdala_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(amygdala_unmod_fs_hit-mean(amygdala_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-10,50])
yticks([-10,50])
xticks([-2,0,2,4])
ylabel('\Delta Firing Rate (Hz)')
xlabel('Time (s)')
title(tl, 'Amygdala')
legend()

% fprintf(sprintf('Amygdala RS theta bars vs FS theta bars Kuiper test: p = %d\n', circ_kuipertest(amygdala_rs.theta_bars, amygdala_fs.theta_bars)))
fprintf(sprintf('Amygdala RS theta bars vs FS theta bars Kuiper test: p = NaN\n'))
if KStest(amygdala_rs.pmi) || KStest(amygdala_fs.pmi)
    fprintf(sprintf('Amygdala RS MI vs FS MI Mann Whitney: p = %d\n', ranksum(amygdala_rs.pmi, amygdala_fs.pmi)))
else
    [~,p] = ttest2(amygdala_rs.pmi, amygdala_fs.pmi);
    fprintf(sprintf('Amygdala RS MI vs FS MI 2-sample t-test: p = %d\n', p))
end
if KStest(amygdala_rs.mses) || KStest(amygdala_fs.mses)
    fprintf(sprintf('Amygdala RS von Mises MSE vs FS von Mises MSE Mann Whitney: p = %d\n', ranksum(amygdala_rs.mses, amygdala_fs.mses)))
else
    [~,p] = ttest2(amygdala_rs.mses, amygdala_fs.mses);
    fprintf(sprintf('Amygdala RS von Mises MSE vs FS von Mises MSE 2-sample t-test: p = %d\n', p))
end
if KStest(amygdala_rs_fracs) || KStest(amygdala_fs_fracs)
    fprintf(sprintf('Amygdala RS vs FS fraction (Mann-Whitney): p = %d\n', ranksum(amygdala_rs_fracs, amygdala_fs_fracs)))
else
    [~,p] = ttest2(amygdala_rs_fracs, amygdala_fs_fracs);
    fprintf(sprintf('Amygdala RS vs FS fraction (Mann-Whitney): p = %d\n', p))
end
fprintf(sprintf('Amygdala RS mean theta bar: %d +/- %d\n', circ_mean(amygdala_rs.theta_bars), circ_std(amygdala_rs.theta_bars)/sqrt(length(amygdala_rs.theta_bars))))
fprintf(sprintf('Amygdala FS mean theta bar: %d +/- %d\n\n', circ_mean(amygdala_fs.theta_bars), circ_std(amygdala_fs.theta_bars)/sqrt(length(amygdala_fs.theta_bars))))

amygdala_mod_rs_delta = amygdala_mod_rs_hit-mean(amygdala_mod_rs_hit(:,time<0),2);
amygdala_unmod_rs_delta = amygdala_unmod_rs_hit-mean(amygdala_unmod_rs_hit(:,time<0),2);
amygdala_mod_rs_delta = amygdala_mod_rs_delta(:,time > 0);
amygdala_unmod_rs_delta = amygdala_unmod_rs_delta(:,time > 0);
amygdala_rs_delta = [amygdala_mod_rs_delta; amygdala_unmod_rs_delta];
amygdala_rs_subj = vertcat(amygdala_mod_rs_subj, amygdala_unmod_rs_subj);
amygdala_rs_group = [zeros(size(amygdala_mod_rs_delta,1),1); ones(size(amygdala_unmod_rs_delta,1),1)];
amygdala_rs_table = table(amygdala_rs_group, amygdala_rs_subj, ...
    amygdala_rs_delta(:,1), amygdala_rs_delta(:,2), amygdala_rs_delta(:,3), amygdala_rs_delta(:,4), amygdala_rs_delta(:,5), amygdala_rs_delta(:,6), amygdala_rs_delta(:,7), amygdala_rs_delta(:,8), amygdala_rs_delta(:,9), amygdala_rs_delta(:,10), ...
    amygdala_rs_delta(:,11), amygdala_rs_delta(:,12), amygdala_rs_delta(:,13), amygdala_rs_delta(:,14), amygdala_rs_delta(:,15), amygdala_rs_delta(:,16), amygdala_rs_delta(:,17), amygdala_rs_delta(:,18), amygdala_rs_delta(:,19), amygdala_rs_delta(:,20), ...
    amygdala_rs_delta(:,21), amygdala_rs_delta(:,22), amygdala_rs_delta(:,23), amygdala_rs_delta(:,24), amygdala_rs_delta(:,25), amygdala_rs_delta(:,26), amygdala_rs_delta(:,27), amygdala_rs_delta(:,28), amygdala_rs_delta(:,29), amygdala_rs_delta(:,30), ...
    amygdala_rs_delta(:,31), amygdala_rs_delta(:,32), amygdala_rs_delta(:,33), amygdala_rs_delta(:,34), amygdala_rs_delta(:,35), amygdala_rs_delta(:,36), amygdala_rs_delta(:,37), amygdala_rs_delta(:,38), amygdala_rs_delta(:,39), amygdala_rs_delta(:,40), ...
    amygdala_rs_delta(:,41), amygdala_rs_delta(:,42), amygdala_rs_delta(:,43), amygdala_rs_delta(:,44), amygdala_rs_delta(:,45), amygdala_rs_delta(:,46), amygdala_rs_delta(:,47), amygdala_rs_delta(:,48), amygdala_rs_delta(:,49), amygdala_rs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
amygdala_rs_rm = fitrm(amygdala_rs_table, 't1-t50 ~ group', 'WithinDesign', Time);
amygdala_rs_ranova = ranova(amygdala_rs_rm)

amygdala_mod_fs_delta = amygdala_mod_fs_hit-mean(amygdala_mod_fs_hit(:,time<0),2);
amygdala_unmod_fs_delta = amygdala_unmod_fs_hit-mean(amygdala_unmod_fs_hit(:,time<0),2);
amygdala_mod_fs_delta = amygdala_mod_fs_delta(:,time > 0);
amygdala_unmod_fs_delta = amygdala_unmod_fs_delta(:,time > 0);
amygdala_fs_delta = [amygdala_mod_fs_delta; amygdala_unmod_fs_delta];
amygdala_fs_subj = vertcat(amygdala_mod_fs_subj, amygdala_unmod_fs_subj);
amygdala_fs_group = [zeros(size(amygdala_mod_fs_delta,1),1); ones(size(amygdala_unmod_fs_delta,1),1)];
amygdala_fs_table = table(amygdala_fs_group, amygdala_fs_subj, ...
    amygdala_fs_delta(:,1), amygdala_fs_delta(:,2), amygdala_fs_delta(:,3), amygdala_fs_delta(:,4), amygdala_fs_delta(:,5), amygdala_fs_delta(:,6), amygdala_fs_delta(:,7), amygdala_fs_delta(:,8), amygdala_fs_delta(:,9), amygdala_fs_delta(:,10), ...
    amygdala_fs_delta(:,11), amygdala_fs_delta(:,12), amygdala_fs_delta(:,13), amygdala_fs_delta(:,14), amygdala_fs_delta(:,15), amygdala_fs_delta(:,16), amygdala_fs_delta(:,17), amygdala_fs_delta(:,18), amygdala_fs_delta(:,19), amygdala_fs_delta(:,20), ...
    amygdala_fs_delta(:,21), amygdala_fs_delta(:,22), amygdala_fs_delta(:,23), amygdala_fs_delta(:,24), amygdala_fs_delta(:,25), amygdala_fs_delta(:,26), amygdala_fs_delta(:,27), amygdala_fs_delta(:,28), amygdala_fs_delta(:,29), amygdala_fs_delta(:,30), ...
    amygdala_fs_delta(:,31), amygdala_fs_delta(:,32), amygdala_fs_delta(:,33), amygdala_fs_delta(:,34), amygdala_fs_delta(:,35), amygdala_fs_delta(:,36), amygdala_fs_delta(:,37), amygdala_fs_delta(:,38), amygdala_fs_delta(:,39), amygdala_fs_delta(:,40), ...
    amygdala_fs_delta(:,41), amygdala_fs_delta(:,42), amygdala_fs_delta(:,43), amygdala_fs_delta(:,44), amygdala_fs_delta(:,45), amygdala_fs_delta(:,46), amygdala_fs_delta(:,47), amygdala_fs_delta(:,48), amygdala_fs_delta(:,49), amygdala_fs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
amygdala_fs_rm = fitrm(amygdala_fs_table, 't1-t50 ~ group', 'WithinDesign', Time);
amygdala_fs_ranova = ranova(amygdala_fs_rm)

fprintf(sprintf('Total modulated S1 RS: %i\n', size(s1_rs,1)));
fprintf(sprintf('Total modulated S1 FS: %i\n', size(s1_fs,1)));
fprintf(sprintf('Total modulated S1: %i\n', size(s1_rs,1)+size(s1_fs,1)));
fprintf(sprintf('S1 RS fraction modulated: %d +/- %d\n', nanmean(s1_rs_fracs), nanstd(s1_rs_fracs)/sqrt(sum(~isnan(s1_rs_fracs)))))
fprintf(sprintf('S1 FS fraction modulated: %d +/- %d\n', nanmean(s1_fs_fracs), nanstd(s1_fs_fracs)/sqrt(sum(~isnan(s1_fs_fracs)))))

fprintf(sprintf('Total modulated PFC RS: %i\n', size(pfc_rs,1)));
fprintf(sprintf('Total modulated PFC FS: %i\n', size(pfc_fs,1)));
fprintf(sprintf('Total modulated PFC: %i\n', size(pfc_rs,1)+size(pfc_fs,1)));
fprintf(sprintf('PFC RS fraction modulated: %d +/- %d\n', nanmean(pfc_rs_fracs), nanstd(pfc_rs_fracs)/sqrt(sum(~isnan(pfc_rs_fracs)))))
fprintf(sprintf('PFC FS fraction modulated: %d +/- %d\n', nanmean(pfc_fs_fracs), nanstd(pfc_fs_fracs)/sqrt(sum(~isnan(pfc_fs_fracs)))))

fprintf(sprintf('Total modulated Striatum RS: %i\n', size(striatum_rs,1)));
fprintf(sprintf('Total modulated Striatum FS: %i\n', size(striatum_fs,1)));
fprintf(sprintf('Total modulated Striatum: %i\n', size(striatum_rs,1)+size(striatum_fs,1)));
fprintf(sprintf('Striatum RS fraction modulated: %d +/- %d\n', nanmean(striatum_rs_fracs), nanstd(striatum_rs_fracs)/sqrt(sum(~isnan(striatum_rs_fracs)))))
fprintf(sprintf('Striatum FS fraction modulated: %d +/- %d\n', nanmean(striatum_fs_fracs), nanstd(striatum_fs_fracs)/sqrt(sum(~isnan(striatum_fs_fracs)))))

fprintf(sprintf('Total modulated Amygdala RS: %i\n', size(amygdala_rs,1)));
fprintf(sprintf('Total modulated Amygdala FS: %i\n', size(amygdala_fs,1)));
fprintf(sprintf('Total modulated Amygdala: %i\n', size(amygdala_rs,1)+size(amygdala_fs,1)));
fprintf(sprintf('Amygdala RS fraction modulated: %d +/- %d\n', nanmean(amygdala_rs_fracs), nanstd(amygdala_rs_fracs)/sqrt(sum(~isnan(amygdala_rs_fracs)))))
fprintf(sprintf('Amygdala FS fraction modulated: %d +/- %d\n', nanmean(amygdala_fs_fracs), nanstd(amygdala_fs_fracs)/sqrt(sum(~isnan(amygdala_fs_fracs)))))

%% MI and MSE by average firing rate 
mi_fr_fig = figure();
tl = tiledlayout(4,2);
axs(1) = nexttile;
plot(cell2mat(s1_rs.avg_trial_fr), s1_rs.pmi, 'k*')
axs(2) = nexttile;
plot(cell2mat(s1_fs.avg_trial_fr), s1_fs.pmi, 'k*')
axs(3) = nexttile;
plot(cell2mat(pfc_rs.avg_trial_fr), pfc_rs.pmi, 'k*')
axs(4) = nexttile;
plot(cell2mat(pfc_fs.avg_trial_fr), pfc_fs.pmi, 'k*')
axs(5) = nexttile;
plot(cell2mat(striatum_rs.avg_trial_fr), striatum_rs.pmi, 'k*')
axs(6) = nexttile;
plot(cell2mat(striatum_fs.avg_trial_fr), striatum_fs.pmi, 'k*')
axs(7) = nexttile;
plot(cell2mat(amygdala_rs.avg_trial_fr), amygdala_rs.pmi, 'k*')
axs(8) = nexttile;
plot(cell2mat(amygdala_fs.avg_trial_fr), amygdala_fs.pmi, 'k*')
unifyYLimits(axs)
xlabel(tl, 'Avg. Firing Rate (Hz)')
ylabel(tl, 'Modulation Index')

mse_fr_fig = figure();
tl = tiledlayout(4,2);
axs(1) = nexttile;
plot(cell2mat(s1_rs.avg_trial_fr), s1_rs.mses, 'k*')
axs(2) = nexttile;
plot(cell2mat(s1_fs.avg_trial_fr), s1_fs.mses, 'k*')
axs(3) = nexttile;
plot(cell2mat(pfc_rs.avg_trial_fr), pfc_rs.mses, 'k*')
axs(4) = nexttile;
plot(cell2mat(pfc_fs.avg_trial_fr), pfc_fs.mses, 'k*')
axs(5) = nexttile;
plot(cell2mat(striatum_rs.avg_trial_fr), striatum_rs.mses, 'k*')
axs(6) = nexttile;
plot(cell2mat(striatum_fs.avg_trial_fr), striatum_fs.mses, 'k*')
axs(7) = nexttile;
plot(cell2mat(amygdala_rs.avg_trial_fr), amygdala_rs.mses, 'k*')
axs(8) = nexttile;
plot(cell2mat(amygdala_fs.avg_trial_fr), amygdala_fs.mses, 'k*')
unifyYLimits(axs)
xlabel(tl, 'Avg. Firing Rate (Hz)')
ylabel(tl, 'von Mises MSE')

out_path = false;
if ~exist('./Figures/', 'dir')
    mkdir('./Figures/')
end

if out_path
    saveas(fracs_fig, 'Figures/fracs.fig')
    saveas(s1_mod_fig, 'Figures/s1_mod_fig.fig')
    saveas(pfc_mod_fig, 'Figures/pfc_mod_fig.fig')
    saveas(striatum_mod_fig, 'Figures/striatum_mod_fig.fig')
    saveas(amygdala_mod_fig, 'Figures/amygdala_mod_fig.fig')

    saveas(fracs_fig, 'Figures/fracs.svg')
    saveas(s1_mod_fig, 'Figures/s1_mod_fig.svg')
    saveas(pfc_mod_fig, 'Figures/pfc_mod_fig.svg')
    saveas(striatum_mod_fig, 'Figures/striatum_mod_fig.svg')
    saveas(amygdala_mod_fig, 'Figures/amygdala_mod_fig.svg')
end

