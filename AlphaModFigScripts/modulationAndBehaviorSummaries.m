out_path = false;
addpath(genpath('./'))
addpath(genpath('~/circstat-matlab/'))
s1 = load('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Combo/Cortex/Spontaneous_Alpha_Modulation_v2/data.mat');
pfc = load('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/PFC_Expert_Combo/PFC/Spontaneous_Alpha_Modulation_v2/data.mat');
striatum = load('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Combo/Basal_Ganglia/Spontaneous_Alpha_Modulation_v2/data.mat');
amygdala = load('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Combo/Amygdala/Spontaneous_Alpha_Modulation_v2/data.mat');

all_ftr_files = {'/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-005mgpkg_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-01mgpkg_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--DCZ-005mgpkg_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_rx--Saline_phase--phase3_g0.mat'};

%% s1 sessions
% combine animals
ftr_files = horzcat(all_ftr_files(1), all_ftr_files(2));
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

ftr_files = {'/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'};
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

s1_sessions = unique(s1.out.alpha_modulated.session_id);
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

striatum_sessions = unique(striatum.out.alpha_modulated.session_id);
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

amygdala_sessions = unique(amygdala.out.alpha_modulated.session_id);
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
pfc_sessions = unique(pfc.out.alpha_modulated.session_id);
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

pfc_rs = pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.waveform_class, 'RS'),:);
pfc_fs = pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.waveform_class, 'FS'),:);
s1_rs = s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.waveform_class, 'RS'),:);
s1_fs = s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.waveform_class, 'FS'),:);
striatum_rs = striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.waveform_class, 'RS'),:);
striatum_fs = striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.waveform_class, 'FS'),:);
amygdala_rs = amygdala.out.alpha_modulated(strcmp(amygdala.out.alpha_modulated.waveform_class, 'RS'),:);
amygdala_fs = amygdala.out.alpha_modulated(strcmp(amygdala.out.alpha_modulated.waveform_class, 'FS'),:);

pfc_rs_mses_hit = pfc_rs.mses_hit;
pfc_rs_mses_miss = pfc_rs.mses_miss;
pfc_rs_mses_cr = pfc_rs.mses_cr;
pfc_rs_mses_fa = pfc_rs.mses_fa;
pfc_rs_mses_correct = pfc_rs.mses_correct;
pfc_rs_mses_incorrect = pfc_rs.mses_incorrect;
pfc_rs_mses_action = pfc_rs.mses_action;
pfc_rs_mses_inaction = pfc_rs.mses_inaction;
pfc_rs_excld = sort(unique([find(pfc_rs_mses_hit > 0.075); find(pfc_rs_mses_miss > 0.075); find(pfc_rs_mses_cr > 0.075); find(pfc_rs_mses_fa > 0.075); ...
    find(pfc_rs_mses_correct > 0.075); find(pfc_rs_mses_incorrect > 0.075); find(pfc_rs_mses_action > 0.075); find(pfc_rs_mses_inaction > 0.075)]));
pfc_rs_mses_hit(pfc_rs_excld) = [];
pfc_rs_mses_miss(pfc_rs_excld) = [];
pfc_rs_mses_cr(pfc_rs_excld) = [];
pfc_rs_mses_fa(pfc_rs_excld) = [];
pfc_rs_mses_correct(pfc_rs_excld) = [];
pfc_rs_mses_incorrect(pfc_rs_excld) = [];
pfc_rs_mses_action(pfc_rs_excld) = [];
pfc_rs_mses_inaction(pfc_rs_excld) = [];
pfc_rs_mse_avgs = [nanmean(pfc_rs_mses_hit), nanmean(pfc_rs_mses_miss), nanmean(pfc_rs_mses_cr), nanmean(pfc_rs_mses_fa), ...
    nanmean(pfc_rs_mses_correct), nanmean(pfc_rs_mses_incorrect), nanmean(pfc_rs_mses_action), nanmean(pfc_rs_mses_inaction)];
pfc_rs_mse_errs = [nanstd(pfc_rs_mses_hit)/sqrt(sum(~isnan(pfc_rs_mses_hit))), ...
    nanstd(pfc_rs_mses_miss)/sqrt(sum(~isnan(pfc_rs_mses_miss))), ...
    nanstd(pfc_rs_mses_cr)/sqrt(sum(~isnan(pfc_rs_mses_cr))), ...
    nanstd(pfc_rs_mses_fa)/sqrt(sum(~isnan(pfc_rs_mses_fa))), ...
    nanstd(pfc_rs_mses_correct)/sqrt(sum(~isnan(pfc_rs_mses_correct))), ...
    nanstd(pfc_rs_mses_incorrect)/sqrt(sum(~isnan(pfc_rs_mses_incorrect))), ...
    nanstd(pfc_rs_mses_action)/sqrt(sum(~isnan(pfc_rs_mses_action))), ...
    nanstd(pfc_rs_mses_inaction)/sqrt(sum(~isnan(pfc_rs_mses_inaction)))];

pfc_rs_mse_mat = [pfc_rs_mses_hit, pfc_rs_mses_miss, pfc_rs_mses_cr, pfc_rs_mses_fa];
fprintf('PFC RS MSE ANOVA:\n')
[p,~,stats] = anova1(pfc_rs_mse_mat)

s1_rs_mses_hit = s1_rs.mses_hit;
s1_rs_mses_miss = s1_rs.mses_miss;
s1_rs_mses_cr = s1_rs.mses_cr;
s1_rs_mses_fa = s1_rs.mses_fa;
s1_rs_mses_correct = s1_rs.mses_correct;
s1_rs_mses_incorrect = s1_rs.mses_incorrect;
s1_rs_mses_action = s1_rs.mses_action;
s1_rs_mses_inaction = s1_rs.mses_inaction;
s1_rs_excld = sort(unique([find(s1_rs_mses_hit > 0.075); find(s1_rs_mses_miss > 0.075); find(s1_rs_mses_cr > 0.075); find(s1_rs_mses_fa > 0.075); ...
    find(s1_rs_mses_correct > 0.075); find(s1_rs_mses_incorrect > 0.075); find(s1_rs_mses_action > 0.075); find(s1_rs_mses_inaction > 0.075)]));
s1_rs_mses_hit(s1_rs_excld) = [];
s1_rs_mses_miss(s1_rs_excld) = [];
s1_rs_mses_cr(s1_rs_excld) = [];
s1_rs_mses_fa(s1_rs_excld) = [];
s1_rs_mses_correct(s1_rs_excld) = [];
s1_rs_mses_incorrect(s1_rs_excld) = [];
s1_rs_mses_action(s1_rs_excld) = [];
s1_rs_mses_inaction(s1_rs_excld) = [];
s1_rs_mse_avgs = [nanmean(s1_rs_mses_hit), nanmean(s1_rs_mses_miss), nanmean(s1_rs_mses_cr), nanmean(s1_rs_mses_fa), ...
    nanmean(s1_rs_mses_correct), nanmean(s1_rs_mses_incorrect), nanmean(s1_rs_mses_action), nanmean(s1_rs_mses_inaction)];
s1_rs_mse_errs = [nanstd(s1_rs_mses_hit)/sqrt(sum(~isnan(s1_rs_mses_hit))), ...
    nanstd(s1_rs_mses_miss)/sqrt(sum(~isnan(s1_rs_mses_miss))), ...
    nanstd(s1_rs_mses_cr)/sqrt(sum(~isnan(s1_rs_mses_cr))), ...
    nanstd(s1_rs_mses_fa)/sqrt(sum(~isnan(s1_rs_mses_fa))), ...
    nanstd(s1_rs_mses_correct)/sqrt(sum(~isnan(s1_rs_mses_correct))), ...
    nanstd(s1_rs_mses_incorrect)/sqrt(sum(~isnan(s1_rs_mses_incorrect))), ...
    nanstd(s1_rs_mses_action)/sqrt(sum(~isnan(s1_rs_mses_action))), ...
    nanstd(s1_rs_mses_inaction)/sqrt(sum(~isnan(s1_rs_mses_inaction)))];

s1_rs_mse_mat = [s1_rs_mses_hit, s1_rs_mses_miss, s1_rs_mses_cr, s1_rs_mses_fa];
fprintf('S1 RS MSE ANOVA:\n')
[p,~,stats] = anova1(s1_rs_mse_mat)
    
striatum_rs_mses_hit = striatum_rs.mses_hit;
striatum_rs_mses_miss = striatum_rs.mses_miss;
striatum_rs_mses_cr = striatum_rs.mses_cr;
striatum_rs_mses_fa = striatum_rs.mses_fa;
striatum_rs_mses_correct = striatum_rs.mses_correct;
striatum_rs_mses_incorrect = striatum_rs.mses_incorrect;
striatum_rs_mses_action = striatum_rs.mses_action;
striatum_rs_mses_inaction = striatum_rs.mses_inaction;
striatum_rs_excld = sort(unique([find(striatum_rs_mses_hit > 0.075); find(striatum_rs_mses_miss > 0.075); find(striatum_rs_mses_cr > 0.075); find(striatum_rs_mses_fa > 0.075); ...
    find(striatum_rs_mses_correct > 0.075); find(striatum_rs_mses_incorrect > 0.075); find(striatum_rs_mses_action > 0.075); find(striatum_rs_mses_inaction > 0.075)]));
striatum_rs_mses_hit(striatum_rs_excld) = [];
striatum_rs_mses_miss(striatum_rs_excld) = [];
striatum_rs_mses_cr(striatum_rs_excld) = [];
striatum_rs_mses_fa(striatum_rs_excld) = [];
striatum_rs_mses_correct(striatum_rs_excld) = [];
striatum_rs_mses_incorrect(striatum_rs_excld) = [];
striatum_rs_mses_action(striatum_rs_excld) = [];
striatum_rs_mses_inaction(striatum_rs_excld) = [];
striatum_rs_mse_avgs = [nanmean(striatum_rs_mses_hit), nanmean(striatum_rs_mses_miss), nanmean(striatum_rs_mses_cr), nanmean(striatum_rs_mses_fa), ...
    nanmean(striatum_rs_mses_correct), nanmean(striatum_rs_mses_incorrect), nanmean(striatum_rs_mses_action), nanmean(striatum_rs_mses_inaction)];
striatum_rs_mse_errs = [nanstd(striatum_rs_mses_hit)/sqrt(sum(~isnan(striatum_rs_mses_hit))), ...
    nanstd(striatum_rs_mses_miss)/sqrt(sum(~isnan(striatum_rs_mses_miss))), ...
    nanstd(striatum_rs_mses_cr)/sqrt(sum(~isnan(striatum_rs_mses_cr))), ...
    nanstd(striatum_rs_mses_fa)/sqrt(sum(~isnan(striatum_rs_mses_fa))), ...
    nanstd(striatum_rs_mses_correct)/sqrt(sum(~isnan(striatum_rs_mses_correct))), ...
    nanstd(striatum_rs_mses_incorrect)/sqrt(sum(~isnan(striatum_rs_mses_incorrect))), ...
    nanstd(striatum_rs_mses_action)/sqrt(sum(~isnan(striatum_rs_mses_action))), ...
    nanstd(striatum_rs_mses_inaction)/sqrt(sum(~isnan(striatum_rs_mses_inaction)))];

striatum_rs_mse_mat = [striatum_rs_mses_hit, striatum_rs_mses_miss, striatum_rs_mses_cr, striatum_rs_mses_fa];
fprintf('Striatum RS MSE ANOVA:\n')
[p,~,stats] = anova1(striatum_rs_mse_mat)

amygdala_rs_mses_hit = amygdala_rs.mses_hit;
amygdala_rs_mses_miss = amygdala_rs.mses_miss;
amygdala_rs_mses_cr = amygdala_rs.mses_cr;
amygdala_rs_mses_fa = amygdala_rs.mses_fa;
amygdala_rs_mses_correct = amygdala_rs.mses_correct;
amygdala_rs_mses_incorrect = amygdala_rs.mses_incorrect;
amygdala_rs_mses_action = amygdala_rs.mses_action;
amygdala_rs_mses_inaction = amygdala_rs.mses_inaction;
amygdala_rs_excld = sort(unique([find(amygdala_rs_mses_hit > 0.075); find(amygdala_rs_mses_miss > 0.075); find(amygdala_rs_mses_cr > 0.075); find(amygdala_rs_mses_fa > 0.075); ...
    find(amygdala_rs_mses_correct > 0.075); find(amygdala_rs_mses_incorrect > 0.075); find(amygdala_rs_mses_action > 0.075); find(amygdala_rs_mses_inaction > 0.075)]));
amygdala_rs_mses_hit(amygdala_rs_excld) = [];
amygdala_rs_mses_miss(amygdala_rs_excld) = [];
amygdala_rs_mses_cr(amygdala_rs_excld) = [];
amygdala_rs_mses_fa(amygdala_rs_excld) = [];
amygdala_rs_mses_correct(amygdala_rs_excld) = [];
amygdala_rs_mses_incorrect(amygdala_rs_excld) = [];
amygdala_rs_mses_action(amygdala_rs_excld) = [];
amygdala_rs_mses_inaction(amygdala_rs_excld) = [];
amygdala_rs_mse_avgs = [nanmean(amygdala_rs_mses_hit), nanmean(amygdala_rs_mses_miss), nanmean(amygdala_rs_mses_cr), nanmean(amygdala_rs_mses_fa), ...
    nanmean(amygdala_rs_mses_correct), nanmean(amygdala_rs_mses_incorrect), nanmean(amygdala_rs_mses_action), nanmean(amygdala_rs_mses_inaction)];
amygdala_rs_mse_errs = [nanstd(amygdala_rs_mses_hit)/sqrt(sum(~isnan(amygdala_rs_mses_hit))), ...
    nanstd(amygdala_rs_mses_miss)/sqrt(sum(~isnan(amygdala_rs_mses_miss))), ...
    nanstd(amygdala_rs_mses_cr)/sqrt(sum(~isnan(amygdala_rs_mses_cr))), ...
    nanstd(amygdala_rs_mses_fa)/sqrt(sum(~isnan(amygdala_rs_mses_fa))), ...
    nanstd(amygdala_rs_mses_correct)/sqrt(sum(~isnan(amygdala_rs_mses_correct))), ...
    nanstd(amygdala_rs_mses_incorrect)/sqrt(sum(~isnan(amygdala_rs_mses_incorrect))), ...
    nanstd(amygdala_rs_mses_action)/sqrt(sum(~isnan(amygdala_rs_mses_action))), ...
    nanstd(amygdala_rs_mses_inaction)/sqrt(sum(~isnan(amygdala_rs_mses_inaction)))];

amygdala_rs_mse_mat = [amygdala_rs_mses_hit, amygdala_rs_mses_miss, amygdala_rs_mses_cr, amygdala_rs_mses_fa];
fprintf('Amygdala RS MSE ANOVA:\n')
[p,~,stats] = anova1(amygdala_rs_mse_mat)

pfc_rs_pmi_hit = pfc_rs.pmi_hit;
pfc_rs_pmi_miss = pfc_rs.pmi_miss;
pfc_rs_pmi_cr = pfc_rs.pmi_cr;
pfc_rs_pmi_fa = pfc_rs.pmi_fa;
pfc_rs_pmi_correct = pfc_rs.pmi_correct;
pfc_rs_pmi_incorrect = pfc_rs.pmi_incorrect;
pfc_rs_pmi_action = pfc_rs.pmi_action;
pfc_rs_pmi_inaction = pfc_rs.pmi_inaction;
pfc_rs_pmi_hit(pfc_rs_excld) = [];
pfc_rs_pmi_miss(pfc_rs_excld) = [];
pfc_rs_pmi_cr(pfc_rs_excld) = [];
pfc_rs_pmi_fa(pfc_rs_excld) = [];
pfc_rs_pmi_correct(pfc_rs_excld) = [];
pfc_rs_pmi_incorrect(pfc_rs_excld) = [];
pfc_rs_pmi_action(pfc_rs_excld) = [];
pfc_rs_pmi_inaction(pfc_rs_excld) = [];
inds = find(pfc_rs_pmi_miss > 0.55);
pfc_rs_pmi_hit(inds) = [];
pfc_rs_pmi_miss(inds) = [];
pfc_rs_pmi_cr(inds) = [];
pfc_rs_pmi_fa(inds) = [];
pfc_rs_pmi_correct(inds) = [];
pfc_rs_pmi_incorrect(inds) = [];
pfc_rs_pmi_action(inds) = [];
pfc_rs_pmi_inaction(inds) = [];
pfc_rs_pmi_avgs = [nanmean(pfc_rs_pmi_hit), nanmean(pfc_rs_pmi_miss), nanmean(pfc_rs_pmi_cr), nanmean(pfc_rs_pmi_fa), ...
    nanmean(pfc_rs_pmi_correct), nanmean(pfc_rs_pmi_incorrect), nanmean(pfc_rs_pmi_action), nanmean(pfc_rs_pmi_inaction)];
pfc_rs_pmi_errs = [nanstd(pfc_rs_pmi_hit)/sqrt(sum(~isnan(pfc_rs_pmi_hit))), ...
    nanstd(pfc_rs_pmi_miss)/sqrt(sum(~isnan(pfc_rs_pmi_miss))), ...
    nanstd(pfc_rs_pmi_cr)/sqrt(sum(~isnan(pfc_rs_pmi_cr))), ...
    nanstd(pfc_rs_pmi_fa)/sqrt(sum(~isnan(pfc_rs_pmi_fa))), ...
    nanstd(pfc_rs_pmi_correct)/sqrt(sum(~isnan(pfc_rs_pmi_correct))), ...
    nanstd(pfc_rs_pmi_incorrect)/sqrt(sum(~isnan(pfc_rs_pmi_incorrect))), ...
    nanstd(pfc_rs_pmi_action)/sqrt(sum(~isnan(pfc_rs_pmi_action))), ...
    nanstd(pfc_rs_pmi_inaction)/sqrt(sum(~isnan(pfc_rs_pmi_inaction)))];

pfc_rs_pmi_mat = [pfc_rs_pmi_hit, pfc_rs_pmi_miss, pfc_rs_pmi_cr, pfc_rs_pmi_fa];
fprintf('PFC RS MI ANOVA:\n')
[p,~,stats] = anova1(pfc_rs_pmi_mat)

pfc_rs_theta_bars_hit = pfc_rs.theta_bars_hit;
pfc_rs_theta_bars_miss = pfc_rs.theta_bars_miss;
pfc_rs_theta_bars_cr = pfc_rs.theta_bars_cr;
pfc_rs_theta_bars_fa = pfc_rs.theta_bars_fa;
pfc_rs_theta_bars_correct = pfc_rs.theta_bars_correct;
pfc_rs_theta_bars_incorrect = pfc_rs.theta_bars_incorrect;
pfc_rs_theta_bars_action = pfc_rs.theta_bars_action;
pfc_rs_theta_bars_inaction = pfc_rs.theta_bars_inaction;
pfc_rs_theta_bars_hit(pfc_rs_excld) = [];
pfc_rs_theta_bars_miss(pfc_rs_excld) = [];
pfc_rs_theta_bars_cr(pfc_rs_excld) = [];
pfc_rs_theta_bars_fa(pfc_rs_excld) = [];
pfc_rs_theta_bars_correct(pfc_rs_excld) = [];
pfc_rs_theta_bars_incorrect(pfc_rs_excld) = [];
pfc_rs_theta_bars_action(pfc_rs_excld) = [];
pfc_rs_theta_bars_inaction(pfc_rs_excld) = [];
inds = find(pfc_rs_theta_bars_miss > 0.55);
pfc_rs_theta_bars_hit(inds) = [];
pfc_rs_theta_bars_miss(inds) = [];
pfc_rs_theta_bars_cr(inds) = [];
pfc_rs_theta_bars_fa(inds) = [];
pfc_rs_theta_bars_correct(inds) = [];
pfc_rs_theta_bars_incorrect(inds) = [];
pfc_rs_theta_bars_action(inds) = [];
pfc_rs_theta_bars_inaction(inds) = [];
pfc_rs_theta_bars_avgs = [circ_mean(pfc_rs_theta_bars_hit), circ_mean(pfc_rs_theta_bars_miss), circ_mean(pfc_rs_theta_bars_cr), circ_mean(pfc_rs_theta_bars_fa), ...
    circ_mean(pfc_rs_theta_bars_correct), circ_mean(pfc_rs_theta_bars_incorrect), circ_mean(pfc_rs_theta_bars_action), circ_mean(pfc_rs_theta_bars_inaction)];
pfc_rs_theta_bars_errs = [circ_std(pfc_rs_theta_bars_hit)/sqrt(sum(~isnan(pfc_rs_theta_bars_hit))), ...
    circ_std(pfc_rs_theta_bars_miss)/sqrt(sum(~isnan(pfc_rs_theta_bars_miss))), ...
    circ_std(pfc_rs_theta_bars_cr)/sqrt(sum(~isnan(pfc_rs_theta_bars_cr))), ...
    circ_std(pfc_rs_theta_bars_fa)/sqrt(sum(~isnan(pfc_rs_theta_bars_fa))), ...
    circ_std(pfc_rs_theta_bars_correct)/sqrt(sum(~isnan(pfc_rs_theta_bars_correct))), ...
    circ_std(pfc_rs_theta_bars_incorrect)/sqrt(sum(~isnan(pfc_rs_theta_bars_incorrect))), ...
    circ_std(pfc_rs_theta_bars_action)/sqrt(sum(~isnan(pfc_rs_theta_bars_action))), ...
    circ_std(pfc_rs_theta_bars_inaction)/sqrt(sum(~isnan(pfc_rs_theta_bars_inaction)))];

s1_rs_pmi_hit = s1_rs.pmi_hit;
s1_rs_pmi_miss = s1_rs.pmi_miss;
s1_rs_pmi_cr = s1_rs.pmi_cr;
s1_rs_pmi_fa = s1_rs.pmi_fa;
s1_rs_pmi_correct = s1_rs.pmi_correct;
s1_rs_pmi_incorrect = s1_rs.pmi_incorrect;
s1_rs_pmi_action = s1_rs.pmi_action;
s1_rs_pmi_inaction = s1_rs.pmi_inaction;
s1_rs_pmi_hit(s1_rs_excld) = [];
s1_rs_pmi_miss(s1_rs_excld) = [];
s1_rs_pmi_cr(s1_rs_excld) = [];
s1_rs_pmi_fa(s1_rs_excld) = [];
s1_rs_pmi_correct(s1_rs_excld) = [];
s1_rs_pmi_incorrect(s1_rs_excld) = [];
s1_rs_pmi_action(s1_rs_excld) = [];
s1_rs_pmi_inaction(s1_rs_excld) = [];
s1_rs_pmi_avgs = [nanmean(s1_rs_pmi_hit), nanmean(s1_rs_pmi_miss), nanmean(s1_rs_pmi_cr), nanmean(s1_rs_pmi_fa), ...
    nanmean(s1_rs_pmi_correct), nanmean(s1_rs_pmi_incorrect), nanmean(s1_rs_pmi_action), nanmean(s1_rs_pmi_inaction)];
s1_rs_pmi_errs = [nanstd(s1_rs_pmi_hit)/sqrt(sum(~isnan(s1_rs_pmi_hit))), ...
    nanstd(s1_rs_pmi_miss)/sqrt(sum(~isnan(s1_rs_pmi_miss))), ...
    nanstd(s1_rs_pmi_cr)/sqrt(sum(~isnan(s1_rs_pmi_cr))), ...
    nanstd(s1_rs_pmi_fa)/sqrt(sum(~isnan(s1_rs_pmi_fa))), ...
    nanstd(s1_rs_pmi_correct)/sqrt(sum(~isnan(s1_rs_pmi_correct))), ...
    nanstd(s1_rs_pmi_incorrect)/sqrt(sum(~isnan(s1_rs_pmi_incorrect))), ...
    nanstd(s1_rs_pmi_action)/sqrt(sum(~isnan(s1_rs_pmi_action))), ...
    nanstd(s1_rs_pmi_inaction)/sqrt(sum(~isnan(s1_rs_pmi_inaction)))];

s1_rs_pmi_mat = [s1_rs_pmi_hit, s1_rs_pmi_miss, s1_rs_pmi_cr, s1_rs_pmi_fa];
fprintf('S1 RS MI ANOVA:\n')
[p,~,stats] = anova1(s1_rs_pmi_mat)

s1_rs_theta_bars_hit = s1_rs.theta_bars_hit;
s1_rs_theta_bars_miss = s1_rs.theta_bars_miss;
s1_rs_theta_bars_cr = s1_rs.theta_bars_cr;
s1_rs_theta_bars_fa = s1_rs.theta_bars_fa;
s1_rs_theta_bars_correct = s1_rs.theta_bars_correct;
s1_rs_theta_bars_incorrect = s1_rs.theta_bars_incorrect;
s1_rs_theta_bars_action = s1_rs.theta_bars_action;
s1_rs_theta_bars_inaction = s1_rs.theta_bars_inaction;
s1_rs_theta_bars_hit(s1_rs_excld) = [];
s1_rs_theta_bars_miss(s1_rs_excld) = [];
s1_rs_theta_bars_cr(s1_rs_excld) = [];
s1_rs_theta_bars_fa(s1_rs_excld) = [];
s1_rs_theta_bars_correct(s1_rs_excld) = [];
s1_rs_theta_bars_incorrect(s1_rs_excld) = [];
s1_rs_theta_bars_action(s1_rs_excld) = [];
s1_rs_theta_bars_inaction(s1_rs_excld) = [];
s1_rs_theta_bars_avgs = [circ_mean(s1_rs_theta_bars_hit), circ_mean(s1_rs_theta_bars_miss), circ_mean(s1_rs_theta_bars_cr), circ_mean(s1_rs_theta_bars_fa), ...
    circ_mean(s1_rs_theta_bars_correct), circ_mean(s1_rs_theta_bars_incorrect), circ_mean(s1_rs_theta_bars_action), circ_mean(s1_rs_theta_bars_inaction)];
s1_rs_theta_bars_errs = [circ_std(s1_rs_theta_bars_hit)/sqrt(sum(~isnan(s1_rs_theta_bars_hit))), ...
    circ_std(s1_rs_theta_bars_miss)/sqrt(sum(~isnan(s1_rs_theta_bars_miss))), ...
    circ_std(s1_rs_theta_bars_cr)/sqrt(sum(~isnan(s1_rs_theta_bars_cr))), ...
    circ_std(s1_rs_theta_bars_fa)/sqrt(sum(~isnan(s1_rs_theta_bars_fa))), ...
    circ_std(s1_rs_theta_bars_correct)/sqrt(sum(~isnan(s1_rs_theta_bars_correct))), ...
    circ_std(s1_rs_theta_bars_incorrect)/sqrt(sum(~isnan(s1_rs_theta_bars_incorrect))), ...
    circ_std(s1_rs_theta_bars_action)/sqrt(sum(~isnan(s1_rs_theta_bars_action))), ...
    circ_std(s1_rs_theta_bars_inaction)/sqrt(sum(~isnan(s1_rs_theta_bars_inaction)))];
    
striatum_rs_pmi_hit = striatum_rs.pmi_hit;
striatum_rs_pmi_miss = striatum_rs.pmi_miss;
striatum_rs_pmi_cr = striatum_rs.pmi_cr;
striatum_rs_pmi_fa = striatum_rs.pmi_fa;
striatum_rs_pmi_correct = striatum_rs.pmi_correct;
striatum_rs_pmi_incorrect = striatum_rs.pmi_incorrect;
striatum_rs_pmi_action = striatum_rs.pmi_action;
striatum_rs_pmi_inaction = striatum_rs.pmi_inaction;
striatum_rs_pmi_hit(striatum_rs_excld) = [];
striatum_rs_pmi_miss(striatum_rs_excld) = [];
striatum_rs_pmi_cr(striatum_rs_excld) = [];
striatum_rs_pmi_fa(striatum_rs_excld) = [];
striatum_rs_pmi_correct(striatum_rs_excld) = [];
striatum_rs_pmi_incorrect(striatum_rs_excld) = [];
striatum_rs_pmi_action(striatum_rs_excld) = [];
striatum_rs_pmi_inaction(striatum_rs_excld) = [];
striatum_rs_pmi_avgs = [nanmean(striatum_rs_pmi_hit), nanmean(striatum_rs_pmi_miss), nanmean(striatum_rs_pmi_cr), nanmean(striatum_rs_pmi_fa), ...
    nanmean(striatum_rs_pmi_correct), nanmean(striatum_rs_pmi_incorrect), nanmean(striatum_rs_pmi_action), nanmean(striatum_rs_pmi_inaction)];
striatum_rs_pmi_errs = [nanstd(striatum_rs_pmi_hit)/sqrt(sum(~isnan(striatum_rs_pmi_hit))), ...
    nanstd(striatum_rs_pmi_miss)/sqrt(sum(~isnan(striatum_rs_pmi_miss))), ...
    nanstd(striatum_rs_pmi_cr)/sqrt(sum(~isnan(striatum_rs_pmi_cr))), ...
    nanstd(striatum_rs_pmi_fa)/sqrt(sum(~isnan(striatum_rs_pmi_fa))), ...
    nanstd(striatum_rs_pmi_correct)/sqrt(sum(~isnan(striatum_rs_pmi_correct))), ...
    nanstd(striatum_rs_pmi_incorrect)/sqrt(sum(~isnan(striatum_rs_pmi_incorrect))), ...
    nanstd(striatum_rs_pmi_action)/sqrt(sum(~isnan(striatum_rs_pmi_action))), ...
    nanstd(striatum_rs_pmi_inaction)/sqrt(sum(~isnan(striatum_rs_pmi_inaction)))];

striatum_rs_pmi_mat = [striatum_rs_pmi_hit, striatum_rs_pmi_miss, striatum_rs_pmi_cr, striatum_rs_pmi_fa];
fprintf('Striatum RS MI ANOVA:\n')
[p,~,stats] = anova1(striatum_rs_pmi_mat)

striatum_rs_theta_bars_hit = striatum_rs.theta_bars_hit;
striatum_rs_theta_bars_miss = striatum_rs.theta_bars_miss;
striatum_rs_theta_bars_cr = striatum_rs.theta_bars_cr;
striatum_rs_theta_bars_fa = striatum_rs.theta_bars_fa;
striatum_rs_theta_bars_correct = striatum_rs.theta_bars_correct;
striatum_rs_theta_bars_incorrect = striatum_rs.theta_bars_incorrect;
striatum_rs_theta_bars_action = striatum_rs.theta_bars_action;
striatum_rs_theta_bars_inaction = striatum_rs.theta_bars_inaction;
striatum_rs_theta_bars_hit(striatum_rs_excld) = [];
striatum_rs_theta_bars_miss(striatum_rs_excld) = [];
striatum_rs_theta_bars_cr(striatum_rs_excld) = [];
striatum_rs_theta_bars_fa(striatum_rs_excld) = [];
striatum_rs_theta_bars_correct(striatum_rs_excld) = [];
striatum_rs_theta_bars_incorrect(striatum_rs_excld) = [];
striatum_rs_theta_bars_action(striatum_rs_excld) = [];
striatum_rs_theta_bars_inaction(striatum_rs_excld) = [];
striatum_rs_theta_bars_avgs = [circ_mean(striatum_rs_theta_bars_hit), circ_mean(striatum_rs_theta_bars_miss), circ_mean(striatum_rs_theta_bars_cr), circ_mean(striatum_rs_theta_bars_fa), ...
    circ_mean(striatum_rs_theta_bars_correct), circ_mean(striatum_rs_theta_bars_incorrect), circ_mean(striatum_rs_theta_bars_action), circ_mean(striatum_rs_theta_bars_inaction)];
striatum_rs_theta_bars_errs = [circ_std(striatum_rs_theta_bars_hit)/sqrt(sum(~isnan(striatum_rs_theta_bars_hit))), ...
    circ_std(striatum_rs_theta_bars_miss)/sqrt(sum(~isnan(striatum_rs_theta_bars_miss))), ...
    circ_std(striatum_rs_theta_bars_cr)/sqrt(sum(~isnan(striatum_rs_theta_bars_cr))), ...
    circ_std(striatum_rs_theta_bars_fa)/sqrt(sum(~isnan(striatum_rs_theta_bars_fa))), ...
    circ_std(striatum_rs_theta_bars_correct)/sqrt(sum(~isnan(striatum_rs_theta_bars_correct))), ...
    circ_std(striatum_rs_theta_bars_incorrect)/sqrt(sum(~isnan(striatum_rs_theta_bars_incorrect))), ...
    circ_std(striatum_rs_theta_bars_action)/sqrt(sum(~isnan(striatum_rs_theta_bars_action))), ...
    circ_std(striatum_rs_theta_bars_inaction)/sqrt(sum(~isnan(striatum_rs_theta_bars_inaction)))];

amygdala_rs_pmi_hit = amygdala_rs.pmi_hit;
amygdala_rs_pmi_miss = amygdala_rs.pmi_miss;
amygdala_rs_pmi_cr = amygdala_rs.pmi_cr;
amygdala_rs_pmi_fa = amygdala_rs.pmi_fa;
amygdala_rs_pmi_correct = amygdala_rs.pmi_correct;
amygdala_rs_pmi_incorrect = amygdala_rs.pmi_incorrect;
amygdala_rs_pmi_action = amygdala_rs.pmi_action;
amygdala_rs_pmi_inaction = amygdala_rs.pmi_inaction;
amygdala_rs_pmi_hit(amygdala_rs_excld) = [];
amygdala_rs_pmi_miss(amygdala_rs_excld) = [];
amygdala_rs_pmi_cr(amygdala_rs_excld) = [];
amygdala_rs_pmi_fa(amygdala_rs_excld) = [];
amygdala_rs_pmi_correct(amygdala_rs_excld) = [];
amygdala_rs_pmi_incorrect(amygdala_rs_excld) = [];
amygdala_rs_pmi_action(amygdala_rs_excld) = [];
amygdala_rs_pmi_inaction(amygdala_rs_excld) = [];
amygdala_rs_pmi_avgs = [nanmean(amygdala_rs_pmi_hit), nanmean(amygdala_rs_pmi_miss), nanmean(amygdala_rs_pmi_cr), nanmean(amygdala_rs_pmi_fa), ...
    nanmean(amygdala_rs_pmi_correct), nanmean(amygdala_rs_pmi_incorrect), nanmean(amygdala_rs_pmi_action), nanmean(amygdala_rs_pmi_inaction)];
amygdala_rs_pmi_errs = [nanstd(amygdala_rs_pmi_hit)/sqrt(sum(~isnan(amygdala_rs_pmi_hit))), ...
    nanstd(amygdala_rs_pmi_miss)/sqrt(sum(~isnan(amygdala_rs_pmi_miss))), ...
    nanstd(amygdala_rs_pmi_cr)/sqrt(sum(~isnan(amygdala_rs_pmi_cr))), ...
    nanstd(amygdala_rs_pmi_fa)/sqrt(sum(~isnan(amygdala_rs_pmi_fa))), ...
    nanstd(amygdala_rs_pmi_correct)/sqrt(sum(~isnan(amygdala_rs_pmi_correct))), ...
    nanstd(amygdala_rs_pmi_incorrect)/sqrt(sum(~isnan(amygdala_rs_pmi_incorrect))), ...
    nanstd(amygdala_rs_pmi_action)/sqrt(sum(~isnan(amygdala_rs_pmi_action))), ...
    nanstd(amygdala_rs_pmi_inaction)/sqrt(sum(~isnan(amygdala_rs_pmi_inaction)))];

amygdala_rs_pmi_mat = [amygdala_rs_pmi_hit, amygdala_rs_pmi_miss, amygdala_rs_pmi_cr, amygdala_rs_pmi_fa];
fprintf('Amygdala RS MI ANOVA:\n')
[p,~,stats] = anova1(amygdala_rs_pmi_mat)

amygdala_rs_theta_bars_hit = amygdala_rs.theta_bars_hit;
amygdala_rs_theta_bars_miss = amygdala_rs.theta_bars_miss;
amygdala_rs_theta_bars_cr = amygdala_rs.theta_bars_cr;
amygdala_rs_theta_bars_fa = amygdala_rs.theta_bars_fa;
amygdala_rs_theta_bars_correct = amygdala_rs.theta_bars_correct;
amygdala_rs_theta_bars_incorrect = amygdala_rs.theta_bars_incorrect;
amygdala_rs_theta_bars_action = amygdala_rs.theta_bars_action;
amygdala_rs_theta_bars_inaction = amygdala_rs.theta_bars_inaction;
amygdala_rs_theta_bars_hit(amygdala_rs_excld) = [];
amygdala_rs_theta_bars_miss(amygdala_rs_excld) = [];
amygdala_rs_theta_bars_cr(amygdala_rs_excld) = [];
amygdala_rs_theta_bars_fa(amygdala_rs_excld) = [];
amygdala_rs_theta_bars_correct(amygdala_rs_excld) = [];
amygdala_rs_theta_bars_incorrect(amygdala_rs_excld) = [];
amygdala_rs_theta_bars_action(amygdala_rs_excld) = [];
amygdala_rs_theta_bars_inaction(amygdala_rs_excld) = [];
amygdala_rs_theta_bars_avgs = [circ_mean(amygdala_rs_theta_bars_hit), circ_mean(amygdala_rs_theta_bars_miss), circ_mean(amygdala_rs_theta_bars_cr), circ_mean(amygdala_rs_theta_bars_fa), ...
    circ_mean(amygdala_rs_theta_bars_correct), circ_mean(amygdala_rs_theta_bars_incorrect), circ_mean(amygdala_rs_theta_bars_action), circ_mean(amygdala_rs_theta_bars_inaction)];
amygdala_rs_theta_bars_errs = [circ_std(amygdala_rs_theta_bars_hit)/sqrt(sum(~isnan(amygdala_rs_theta_bars_hit))), ...
    circ_std(amygdala_rs_theta_bars_miss)/sqrt(sum(~isnan(amygdala_rs_theta_bars_miss))), ...
    circ_std(amygdala_rs_theta_bars_cr)/sqrt(sum(~isnan(amygdala_rs_theta_bars_cr))), ...
    circ_std(amygdala_rs_theta_bars_fa)/sqrt(sum(~isnan(amygdala_rs_theta_bars_fa))), ...
    circ_std(amygdala_rs_theta_bars_correct)/sqrt(sum(~isnan(amygdala_rs_theta_bars_correct))), ...
    circ_std(amygdala_rs_theta_bars_incorrect)/sqrt(sum(~isnan(amygdala_rs_theta_bars_incorrect))), ...
    circ_std(amygdala_rs_theta_bars_action)/sqrt(sum(~isnan(amygdala_rs_theta_bars_action))), ...
    circ_std(amygdala_rs_theta_bars_inaction)/sqrt(sum(~isnan(amygdala_rs_theta_bars_inaction)))];

pfc_fs_mses_hit = pfc_fs.mses_hit;
pfc_fs_mses_miss = pfc_fs.mses_miss;
pfc_fs_mses_cr = pfc_fs.mses_cr;
pfc_fs_mses_fa = pfc_fs.mses_fa;
pfc_fs_mses_correct = pfc_fs.mses_correct;
pfc_fs_mses_incorrect = pfc_fs.mses_incorrect;
pfc_fs_mses_action = pfc_fs.mses_action;
pfc_fs_mses_inaction = pfc_fs.mses_inaction;
pfc_fs_excld = sort(unique([find(pfc_fs_mses_hit > 0.075); find(pfc_fs_mses_miss > 0.075); find(pfc_fs_mses_cr > 0.075); find(pfc_fs_mses_fa > 0.075); ...
    find(pfc_fs_mses_correct > 0.075); find(pfc_fs_mses_incorrect > 0.075); find(pfc_fs_mses_action > 0.075); find(pfc_fs_mses_inaction > 0.075)]));
pfc_fs_mses_hit(pfc_fs_excld) = [];
pfc_fs_mses_miss(pfc_fs_excld) = [];
pfc_fs_mses_cr(pfc_fs_excld) = [];
pfc_fs_mses_fa(pfc_fs_excld) = [];
pfc_fs_mses_correct(pfc_fs_excld) = [];
pfc_fs_mses_incorrect(pfc_fs_excld) = [];
pfc_fs_mses_action(pfc_fs_excld) = [];
pfc_fs_mses_inaction(pfc_fs_excld) = [];
pfc_fs_mse_avgs = [nanmean(pfc_fs_mses_hit), nanmean(pfc_fs_mses_miss), nanmean(pfc_fs_mses_cr), nanmean(pfc_fs_mses_fa), ...
    nanmean(pfc_fs_mses_correct), nanmean(pfc_fs_mses_incorrect), nanmean(pfc_fs_mses_action), nanmean(pfc_fs_mses_inaction)];
pfc_fs_mse_errs = [nanstd(pfc_fs_mses_hit)/sqrt(sum(~isnan(pfc_fs_mses_hit))), ...
    nanstd(pfc_fs_mses_miss)/sqrt(sum(~isnan(pfc_fs_mses_miss))), ...
    nanstd(pfc_fs_mses_cr)/sqrt(sum(~isnan(pfc_fs_mses_cr))), ...
    nanstd(pfc_fs_mses_fa)/sqrt(sum(~isnan(pfc_fs_mses_fa))), ...
    nanstd(pfc_fs_mses_correct)/sqrt(sum(~isnan(pfc_fs_mses_correct))), ...
    nanstd(pfc_fs_mses_incorrect)/sqrt(sum(~isnan(pfc_fs_mses_incorrect))), ...
    nanstd(pfc_fs_mses_action)/sqrt(sum(~isnan(pfc_fs_mses_action))), ...
    nanstd(pfc_fs_mses_inaction)/sqrt(sum(~isnan(pfc_fs_mses_inaction)))];

pfc_fs_mse_mat = [pfc_fs_mses_hit, pfc_fs_mses_miss, pfc_fs_mses_cr, pfc_fs_mses_fa];
fprintf('PFC FS MSE ANOVA:\n')
[p,~,stats] = anova1(pfc_fs_mse_mat)

s1_fs_mses_hit = s1_fs.mses_hit;
s1_fs_mses_miss = s1_fs.mses_miss;
s1_fs_mses_cr = s1_fs.mses_cr;
s1_fs_mses_fa = s1_fs.mses_fa;
s1_fs_mses_correct = s1_fs.mses_correct;
s1_fs_mses_incorrect = s1_fs.mses_incorrect;
s1_fs_mses_action = s1_fs.mses_action;
s1_fs_mses_inaction = s1_fs.mses_inaction;
s1_fs_excld = sort(unique([find(s1_fs_mses_hit > 0.075); find(s1_fs_mses_miss > 0.075); find(s1_fs_mses_cr > 0.075); find(s1_fs_mses_fa > 0.075); ...
    find(s1_fs_mses_correct > 0.075); find(s1_fs_mses_incorrect > 0.075); find(s1_fs_mses_action > 0.075); find(s1_fs_mses_inaction > 0.075)]));
s1_fs_mses_hit(s1_fs_excld) = [];
s1_fs_mses_miss(s1_fs_excld) = [];
s1_fs_mses_cr(s1_fs_excld) = [];
s1_fs_mses_fa(s1_fs_excld) = [];
s1_fs_mses_correct(s1_fs_excld) = [];
s1_fs_mses_incorrect(s1_fs_excld) = [];
s1_fs_mses_action(s1_fs_excld) = [];
s1_fs_mses_inaction(s1_fs_excld) = [];
s1_fs_mse_avgs = [nanmean(s1_fs_mses_hit), nanmean(s1_fs_mses_miss), nanmean(s1_fs_mses_cr), nanmean(s1_fs_mses_fa), ...
    nanmean(s1_fs_mses_correct), nanmean(s1_fs_mses_incorrect), nanmean(s1_fs_mses_action), nanmean(s1_fs_mses_inaction)];
s1_fs_mse_errs = [nanstd(s1_fs_mses_hit)/sqrt(sum(~isnan(s1_fs_mses_hit))), ...
    nanstd(s1_fs_mses_miss)/sqrt(sum(~isnan(s1_fs_mses_miss))), ...
    nanstd(s1_fs_mses_cr)/sqrt(sum(~isnan(s1_fs_mses_cr))), ...
    nanstd(s1_fs_mses_fa)/sqrt(sum(~isnan(s1_fs_mses_fa))), ...
    nanstd(s1_fs_mses_correct)/sqrt(sum(~isnan(s1_fs_mses_correct))), ...
    nanstd(s1_fs_mses_incorrect)/sqrt(sum(~isnan(s1_fs_mses_incorrect))), ...
    nanstd(s1_fs_mses_action)/sqrt(sum(~isnan(s1_fs_mses_action))), ...
    nanstd(s1_fs_mses_inaction)/sqrt(sum(~isnan(s1_fs_mses_inaction)))];

s1_fs_mse_mat = [s1_fs_mses_hit, s1_fs_mses_miss, s1_fs_mses_cr, s1_fs_mses_fa];
fprintf('S1 FS MSE ANOVA:\n')
[p,~,stats] = anova1(s1_fs_mse_mat)
    
striatum_fs_mses_hit = striatum_fs.mses_hit;
striatum_fs_mses_miss = striatum_fs.mses_miss;
striatum_fs_mses_cr = striatum_fs.mses_cr;
striatum_fs_mses_fa = striatum_fs.mses_fa;
striatum_fs_mses_correct = striatum_fs.mses_correct;
striatum_fs_mses_incorrect = striatum_fs.mses_incorrect;
striatum_fs_mses_action = striatum_fs.mses_action;
striatum_fs_mses_inaction = striatum_fs.mses_inaction;
striatum_fs_excld = sort(unique([find(striatum_fs_mses_hit > 0.075); find(striatum_fs_mses_miss > 0.075); find(striatum_fs_mses_cr > 0.075); find(striatum_fs_mses_fa > 0.075); ...
    find(striatum_fs_mses_correct > 0.075); find(striatum_fs_mses_incorrect > 0.075); find(striatum_fs_mses_action > 0.075); find(striatum_fs_mses_inaction > 0.075)]));
striatum_fs_mses_hit(striatum_fs_excld) = [];
striatum_fs_mses_miss(striatum_fs_excld) = [];
striatum_fs_mses_cr(striatum_fs_excld) = [];
striatum_fs_mses_fa(striatum_fs_excld) = [];
striatum_fs_mses_correct(striatum_fs_excld) = [];
striatum_fs_mses_incorrect(striatum_fs_excld) = [];
striatum_fs_mses_action(striatum_fs_excld) = [];
striatum_fs_mses_inaction(striatum_fs_excld) = [];
striatum_fs_mse_avgs = [nanmean(striatum_fs_mses_hit), nanmean(striatum_fs_mses_miss), nanmean(striatum_fs_mses_cr), nanmean(striatum_fs_mses_fa), ...
    nanmean(striatum_fs_mses_correct), nanmean(striatum_fs_mses_incorrect), nanmean(striatum_fs_mses_action), nanmean(striatum_fs_mses_inaction)];
striatum_fs_mse_errs = [nanstd(striatum_fs_mses_hit)/sqrt(sum(~isnan(striatum_fs_mses_hit))), ...
    nanstd(striatum_fs_mses_miss)/sqrt(sum(~isnan(striatum_fs_mses_miss))), ...
    nanstd(striatum_fs_mses_cr)/sqrt(sum(~isnan(striatum_fs_mses_cr))), ...
    nanstd(striatum_fs_mses_fa)/sqrt(sum(~isnan(striatum_fs_mses_fa))), ...
    nanstd(striatum_fs_mses_correct)/sqrt(sum(~isnan(striatum_fs_mses_correct))), ...
    nanstd(striatum_fs_mses_incorrect)/sqrt(sum(~isnan(striatum_fs_mses_incorrect))), ...
    nanstd(striatum_fs_mses_action)/sqrt(sum(~isnan(striatum_fs_mses_action))), ...
    nanstd(striatum_fs_mses_inaction)/sqrt(sum(~isnan(striatum_fs_mses_inaction)))];

striatum_fs_mse_mat = [striatum_fs_mses_hit, striatum_fs_mses_miss, striatum_fs_mses_cr, striatum_fs_mses_fa];
fprintf('Striatum FS MSE ANOVA:\n')
[p,~,stats] = anova1(striatum_fs_mse_mat)

amygdala_fs_mses_hit = amygdala_fs.mses_hit;
amygdala_fs_mses_miss = amygdala_fs.mses_miss;
amygdala_fs_mses_cr = amygdala_fs.mses_cr;
amygdala_fs_mses_fa = amygdala_fs.mses_fa;
amygdala_fs_mses_correct = amygdala_fs.mses_correct;
amygdala_fs_mses_incorrect = amygdala_fs.mses_incorrect;
amygdala_fs_mses_action = amygdala_fs.mses_action;
amygdala_fs_mses_inaction = amygdala_fs.mses_inaction;
amygdala_fs_excld = sort(unique([find(amygdala_fs_mses_hit > 0.075); find(amygdala_fs_mses_miss > 0.075); find(amygdala_fs_mses_cr > 0.075); find(amygdala_fs_mses_fa > 0.075); ...
    find(amygdala_fs_mses_correct > 0.075); find(amygdala_fs_mses_incorrect > 0.075); find(amygdala_fs_mses_action > 0.075); find(amygdala_fs_mses_inaction > 0.075)]));
amygdala_fs_mses_hit(amygdala_fs_excld) = [];
amygdala_fs_mses_miss(amygdala_fs_excld) = [];
amygdala_fs_mses_cr(amygdala_fs_excld) = [];
amygdala_fs_mses_fa(amygdala_fs_excld) = [];
amygdala_fs_mses_correct(amygdala_fs_excld) = [];
amygdala_fs_mses_incorrect(amygdala_fs_excld) = [];
amygdala_fs_mses_action(amygdala_fs_excld) = [];
amygdala_fs_mses_inaction(amygdala_fs_excld) = [];
amygdala_fs_mse_avgs = [nanmean(amygdala_fs_mses_hit), nanmean(amygdala_fs_mses_miss), nanmean(amygdala_fs_mses_cr), nanmean(amygdala_fs_mses_fa), ...
    nanmean(amygdala_fs_mses_correct), nanmean(amygdala_fs_mses_incorrect), nanmean(amygdala_fs_mses_action), nanmean(amygdala_fs_mses_inaction)];
amygdala_fs_mse_errs = [nanstd(amygdala_fs_mses_hit)/sqrt(sum(~isnan(amygdala_fs_mses_hit))), ...
    nanstd(amygdala_fs_mses_miss)/sqrt(sum(~isnan(amygdala_fs_mses_miss))), ...
    nanstd(amygdala_fs_mses_cr)/sqrt(sum(~isnan(amygdala_fs_mses_cr))), ...
    nanstd(amygdala_fs_mses_fa)/sqrt(sum(~isnan(amygdala_fs_mses_fa))), ...
    nanstd(amygdala_fs_mses_correct)/sqrt(sum(~isnan(amygdala_fs_mses_correct))), ...
    nanstd(amygdala_fs_mses_incorrect)/sqrt(sum(~isnan(amygdala_fs_mses_incorrect))), ...
    nanstd(amygdala_fs_mses_action)/sqrt(sum(~isnan(amygdala_fs_mses_action))), ...
    nanstd(amygdala_fs_mses_inaction)/sqrt(sum(~isnan(amygdala_fs_mses_inaction)))];

amygdala_fs_mse_mat = [amygdala_fs_mses_hit, amygdala_fs_mses_miss, amygdala_fs_mses_cr, amygdala_fs_mses_fa];
fprintf('Amygdala FS MSE ANOVA:\n')
[p,~,stats] = anova1(amygdala_fs_mse_mat)

pfc_fs_pmi_hit = pfc_fs.pmi_hit;
pfc_fs_pmi_miss = pfc_fs.pmi_miss;
pfc_fs_pmi_cr = pfc_fs.pmi_cr;
pfc_fs_pmi_fa = pfc_fs.pmi_fa;
pfc_fs_pmi_correct = pfc_fs.pmi_correct;
pfc_fs_pmi_incorrect = pfc_fs.pmi_incorrect;
pfc_fs_pmi_action = pfc_fs.pmi_action;
pfc_fs_pmi_inaction = pfc_fs.pmi_inaction;
pfc_fs_pmi_hit(pfc_fs_excld) = [];
pfc_fs_pmi_miss(pfc_fs_excld) = [];
pfc_fs_pmi_cr(pfc_fs_excld) = [];
pfc_fs_pmi_fa(pfc_fs_excld) = [];
pfc_fs_pmi_correct(pfc_fs_excld) = [];
pfc_fs_pmi_incorrect(pfc_fs_excld) = [];
pfc_fs_pmi_action(pfc_fs_excld) = [];
pfc_fs_pmi_inaction(pfc_fs_excld) = [];
pfc_fs_pmi_avgs = [nanmean(pfc_fs_pmi_hit), nanmean(pfc_fs_pmi_miss), nanmean(pfc_fs_pmi_cr), nanmean(pfc_fs_pmi_fa), ...
    nanmean(pfc_fs_pmi_correct), nanmean(pfc_fs_pmi_incorrect), nanmean(pfc_fs_pmi_action), nanmean(pfc_fs_pmi_inaction)];
pfc_fs_pmi_errs = [nanstd(pfc_fs_pmi_hit)/sqrt(sum(~isnan(pfc_fs_pmi_hit))), ...
    nanstd(pfc_fs_pmi_miss)/sqrt(sum(~isnan(pfc_fs_pmi_miss))), ...
    nanstd(pfc_fs_pmi_cr)/sqrt(sum(~isnan(pfc_fs_pmi_cr))), ...
    nanstd(pfc_fs_pmi_fa)/sqrt(sum(~isnan(pfc_fs_pmi_fa))), ...
    nanstd(pfc_fs_pmi_correct)/sqrt(sum(~isnan(pfc_fs_pmi_correct))), ...
    nanstd(pfc_fs_pmi_incorrect)/sqrt(sum(~isnan(pfc_fs_pmi_incorrect))), ...
    nanstd(pfc_fs_pmi_action)/sqrt(sum(~isnan(pfc_fs_pmi_action))), ...
    nanstd(pfc_fs_pmi_inaction)/sqrt(sum(~isnan(pfc_fs_pmi_inaction)))];

pfc_fs_pmi_mat = [pfc_fs_pmi_hit, pfc_fs_pmi_miss, pfc_fs_pmi_cr, pfc_fs_pmi_fa];
fprintf('PFC FS MI ANOVA:\n')
[p,~,stats] = anova1(pfc_fs_pmi_mat)

pfc_fs_theta_bars_hit = pfc_fs.theta_bars_hit;
pfc_fs_theta_bars_miss = pfc_fs.theta_bars_miss;
pfc_fs_theta_bars_cr = pfc_fs.theta_bars_cr;
pfc_fs_theta_bars_fa = pfc_fs.theta_bars_fa;
pfc_fs_theta_bars_correct = pfc_fs.theta_bars_correct;
pfc_fs_theta_bars_incorrect = pfc_fs.theta_bars_incorrect;
pfc_fs_theta_bars_action = pfc_fs.theta_bars_action;
pfc_fs_theta_bars_inaction = pfc_fs.theta_bars_inaction;
pfc_fs_theta_bars_hit(pfc_fs_excld) = [];
pfc_fs_theta_bars_miss(pfc_fs_excld) = [];
pfc_fs_theta_bars_cr(pfc_fs_excld) = [];
pfc_fs_theta_bars_fa(pfc_fs_excld) = [];
pfc_fs_theta_bars_correct(pfc_fs_excld) = [];
pfc_fs_theta_bars_incorrect(pfc_fs_excld) = [];
pfc_fs_theta_bars_action(pfc_fs_excld) = [];
pfc_fs_theta_bars_inaction(pfc_fs_excld) = [];
pfc_fs_theta_bars_avgs = [circ_mean(pfc_fs_theta_bars_hit), circ_mean(pfc_fs_theta_bars_miss), circ_mean(pfc_fs_theta_bars_cr), circ_mean(pfc_fs_theta_bars_fa), ...
    circ_mean(pfc_fs_theta_bars_correct), circ_mean(pfc_fs_theta_bars_incorrect), circ_mean(pfc_fs_theta_bars_action), circ_mean(pfc_fs_theta_bars_inaction)];
pfc_fs_theta_bars_errs = [circ_std(pfc_fs_theta_bars_hit)/sqrt(sum(~isnan(pfc_fs_theta_bars_hit))), ...
    circ_std(pfc_fs_theta_bars_miss)/sqrt(sum(~isnan(pfc_fs_theta_bars_miss))), ...
    circ_std(pfc_fs_theta_bars_cr)/sqrt(sum(~isnan(pfc_fs_theta_bars_cr))), ...
    circ_std(pfc_fs_theta_bars_fa)/sqrt(sum(~isnan(pfc_fs_theta_bars_fa))), ...
    circ_std(pfc_fs_theta_bars_correct)/sqrt(sum(~isnan(pfc_fs_theta_bars_correct))), ...
    circ_std(pfc_fs_theta_bars_incorrect)/sqrt(sum(~isnan(pfc_fs_theta_bars_incorrect))), ...
    circ_std(pfc_fs_theta_bars_action)/sqrt(sum(~isnan(pfc_fs_theta_bars_action))), ...
    circ_std(pfc_fs_theta_bars_inaction)/sqrt(sum(~isnan(pfc_fs_theta_bars_inaction)))];
    
s1_fs_pmi_hit = s1_fs.pmi_hit;
s1_fs_pmi_miss = s1_fs.pmi_miss;
s1_fs_pmi_cr = s1_fs.pmi_cr;
s1_fs_pmi_fa = s1_fs.pmi_fa;
s1_fs_pmi_correct = s1_fs.pmi_correct;
s1_fs_pmi_incorrect = s1_fs.pmi_incorrect;
s1_fs_pmi_action = s1_fs.pmi_action;
s1_fs_pmi_inaction = s1_fs.pmi_inaction;
s1_fs_pmi_hit(s1_fs_excld) = [];
s1_fs_pmi_miss(s1_fs_excld) = [];
s1_fs_pmi_cr(s1_fs_excld) = [];
s1_fs_pmi_fa(s1_fs_excld) = [];
s1_fs_pmi_correct(s1_fs_excld) = [];
s1_fs_pmi_incorrect(s1_fs_excld) = [];
s1_fs_pmi_action(s1_fs_excld) = [];
s1_fs_pmi_inaction(s1_fs_excld) = [];
s1_fs_pmi_avgs = [nanmean(s1_fs_pmi_hit), nanmean(s1_fs_pmi_miss), nanmean(s1_fs_pmi_cr), nanmean(s1_fs_pmi_fa), ...
    nanmean(s1_fs_pmi_correct), nanmean(s1_fs_pmi_incorrect), nanmean(s1_fs_pmi_action), nanmean(s1_fs_pmi_inaction)];
s1_fs_pmi_errs = [nanstd(s1_fs_pmi_hit)/sqrt(sum(~isnan(s1_fs_pmi_hit))), ...
    nanstd(s1_fs_pmi_miss)/sqrt(sum(~isnan(s1_fs_pmi_miss))), ...
    nanstd(s1_fs_pmi_cr)/sqrt(sum(~isnan(s1_fs_pmi_cr))), ...
    nanstd(s1_fs_pmi_fa)/sqrt(sum(~isnan(s1_fs_pmi_fa))), ...
    nanstd(s1_fs_pmi_correct)/sqrt(sum(~isnan(s1_fs_pmi_correct))), ...
    nanstd(s1_fs_pmi_incorrect)/sqrt(sum(~isnan(s1_fs_pmi_incorrect))), ...
    nanstd(s1_fs_pmi_action)/sqrt(sum(~isnan(s1_fs_pmi_action))), ...
    nanstd(s1_fs_pmi_inaction)/sqrt(sum(~isnan(s1_fs_pmi_inaction)))];

s1_fs_pmi_mat = [s1_fs_pmi_hit, s1_fs_pmi_miss, s1_fs_pmi_cr, s1_fs_pmi_fa];
fprintf('S1 FS MI ANOVA:\n')
[p,~,stats] = anova1(s1_fs_pmi_mat)

s1_fs_theta_bars_hit = s1_fs.theta_bars_hit;
s1_fs_theta_bars_miss = s1_fs.theta_bars_miss;
s1_fs_theta_bars_cr = s1_fs.theta_bars_cr;
s1_fs_theta_bars_fa = s1_fs.theta_bars_fa;
s1_fs_theta_bars_correct = s1_fs.theta_bars_correct;
s1_fs_theta_bars_incorrect = s1_fs.theta_bars_incorrect;
s1_fs_theta_bars_action = s1_fs.theta_bars_action;
s1_fs_theta_bars_inaction = s1_fs.theta_bars_inaction;
s1_fs_theta_bars_hit(s1_fs_excld) = [];
s1_fs_theta_bars_miss(s1_fs_excld) = [];
s1_fs_theta_bars_cr(s1_fs_excld) = [];
s1_fs_theta_bars_fa(s1_fs_excld) = [];
s1_fs_theta_bars_correct(s1_fs_excld) = [];
s1_fs_theta_bars_incorrect(s1_fs_excld) = [];
s1_fs_theta_bars_action(s1_fs_excld) = [];
s1_fs_theta_bars_inaction(s1_fs_excld) = [];
s1_fs_theta_bars_avgs = [circ_mean(s1_fs_theta_bars_hit), circ_mean(s1_fs_theta_bars_miss), circ_mean(s1_fs_theta_bars_cr), circ_mean(s1_fs_theta_bars_fa), ...
    circ_mean(s1_fs_theta_bars_correct), circ_mean(s1_fs_theta_bars_incorrect), circ_mean(s1_fs_theta_bars_action), circ_mean(s1_fs_theta_bars_inaction)];
s1_fs_theta_bars_errs = [circ_std(s1_fs_theta_bars_hit)/sqrt(sum(~isnan(s1_fs_theta_bars_hit))), ...
    circ_std(s1_fs_theta_bars_miss)/sqrt(sum(~isnan(s1_fs_theta_bars_miss))), ...
    circ_std(s1_fs_theta_bars_cr)/sqrt(sum(~isnan(s1_fs_theta_bars_cr))), ...
    circ_std(s1_fs_theta_bars_fa)/sqrt(sum(~isnan(s1_fs_theta_bars_fa))), ...
    circ_std(s1_fs_theta_bars_correct)/sqrt(sum(~isnan(s1_fs_theta_bars_correct))), ...
    circ_std(s1_fs_theta_bars_incorrect)/sqrt(sum(~isnan(s1_fs_theta_bars_incorrect))), ...
    circ_std(s1_fs_theta_bars_action)/sqrt(sum(~isnan(s1_fs_theta_bars_action))), ...
    circ_std(s1_fs_theta_bars_inaction)/sqrt(sum(~isnan(s1_fs_theta_bars_inaction)))];
    
striatum_fs_pmi_hit = striatum_fs.pmi_hit;
striatum_fs_pmi_miss = striatum_fs.pmi_miss;
striatum_fs_pmi_cr = striatum_fs.pmi_cr;
striatum_fs_pmi_fa = striatum_fs.pmi_fa;
striatum_fs_pmi_correct = striatum_fs.pmi_correct;
striatum_fs_pmi_incorrect = striatum_fs.pmi_incorrect;
striatum_fs_pmi_action = striatum_fs.pmi_action;
striatum_fs_pmi_inaction = striatum_fs.pmi_inaction;
striatum_fs_pmi_hit(striatum_fs_excld) = [];
striatum_fs_pmi_miss(striatum_fs_excld) = [];
striatum_fs_pmi_cr(striatum_fs_excld) = [];
striatum_fs_pmi_fa(striatum_fs_excld) = [];
striatum_fs_pmi_correct(striatum_fs_excld) = [];
striatum_fs_pmi_incorrect(striatum_fs_excld) = [];
striatum_fs_pmi_action(striatum_fs_excld) = [];
striatum_fs_pmi_inaction(striatum_fs_excld) = [];
striatum_fs_pmi_avgs = [nanmean(striatum_fs_pmi_hit), nanmean(striatum_fs_pmi_miss), nanmean(striatum_fs_pmi_cr), nanmean(striatum_fs_pmi_fa), ...
    nanmean(striatum_fs_pmi_correct), nanmean(striatum_fs_pmi_incorrect), nanmean(striatum_fs_pmi_action), nanmean(striatum_fs_pmi_inaction)];
striatum_fs_pmi_errs = [nanstd(striatum_fs_pmi_hit)/sqrt(sum(~isnan(striatum_fs_pmi_hit))), ...
    nanstd(striatum_fs_pmi_miss)/sqrt(sum(~isnan(striatum_fs_pmi_miss))), ...
    nanstd(striatum_fs_pmi_cr)/sqrt(sum(~isnan(striatum_fs_pmi_cr))), ...
    nanstd(striatum_fs_pmi_fa)/sqrt(sum(~isnan(striatum_fs_pmi_fa))), ...
    nanstd(striatum_fs_pmi_correct)/sqrt(sum(~isnan(striatum_fs_pmi_correct))), ...
    nanstd(striatum_fs_pmi_incorrect)/sqrt(sum(~isnan(striatum_fs_pmi_incorrect))), ...
    nanstd(striatum_fs_pmi_action)/sqrt(sum(~isnan(striatum_fs_pmi_action))), ...
    nanstd(striatum_fs_pmi_inaction)/sqrt(sum(~isnan(striatum_fs_pmi_inaction)))];

striatum_fs_pmi_mat = [striatum_fs_pmi_hit, striatum_fs_pmi_miss, striatum_fs_pmi_cr, striatum_fs_pmi_fa];
fprintf('Striatum FS MI ANOVA:\n')
[p,~,stats] = anova1(striatum_fs_pmi_mat)

striatum_fs_theta_bars_hit = striatum_fs.theta_bars_hit;
striatum_fs_theta_bars_miss = striatum_fs.theta_bars_miss;
striatum_fs_theta_bars_cr = striatum_fs.theta_bars_cr;
striatum_fs_theta_bars_fa = striatum_fs.theta_bars_fa;
striatum_fs_theta_bars_correct = striatum_fs.theta_bars_correct;
striatum_fs_theta_bars_incorrect = striatum_fs.theta_bars_incorrect;
striatum_fs_theta_bars_action = striatum_fs.theta_bars_action;
striatum_fs_theta_bars_inaction = striatum_fs.theta_bars_inaction;
striatum_fs_theta_bars_hit(striatum_fs_excld) = [];
striatum_fs_theta_bars_miss(striatum_fs_excld) = [];
striatum_fs_theta_bars_cr(striatum_fs_excld) = [];
striatum_fs_theta_bars_fa(striatum_fs_excld) = [];
striatum_fs_theta_bars_correct(striatum_fs_excld) = [];
striatum_fs_theta_bars_incorrect(striatum_fs_excld) = [];
striatum_fs_theta_bars_action(striatum_fs_excld) = [];
striatum_fs_theta_bars_inaction(striatum_fs_excld) = [];
striatum_fs_theta_bars_avgs = [circ_mean(striatum_fs_theta_bars_hit), circ_mean(striatum_fs_theta_bars_miss), circ_mean(striatum_fs_theta_bars_cr), circ_mean(striatum_fs_theta_bars_fa), ...
    circ_mean(striatum_fs_theta_bars_correct), circ_mean(striatum_fs_theta_bars_incorrect), circ_mean(striatum_fs_theta_bars_action), circ_mean(striatum_fs_theta_bars_inaction)];
striatum_fs_theta_bars_errs = [circ_std(striatum_fs_theta_bars_hit)/sqrt(sum(~isnan(striatum_fs_theta_bars_hit))), ...
    circ_std(striatum_fs_theta_bars_miss)/sqrt(sum(~isnan(striatum_fs_theta_bars_miss))), ...
    circ_std(striatum_fs_theta_bars_cr)/sqrt(sum(~isnan(striatum_fs_theta_bars_cr))), ...
    circ_std(striatum_fs_theta_bars_fa)/sqrt(sum(~isnan(striatum_fs_theta_bars_fa))), ...
    circ_std(striatum_fs_theta_bars_correct)/sqrt(sum(~isnan(striatum_fs_theta_bars_correct))), ...
    circ_std(striatum_fs_theta_bars_incorrect)/sqrt(sum(~isnan(striatum_fs_theta_bars_incorrect))), ...
    circ_std(striatum_fs_theta_bars_action)/sqrt(sum(~isnan(striatum_fs_theta_bars_action))), ...
    circ_std(striatum_fs_theta_bars_inaction)/sqrt(sum(~isnan(striatum_fs_theta_bars_inaction)))];

amygdala_fs_pmi_hit = amygdala_fs.pmi_hit;
amygdala_fs_pmi_miss = amygdala_fs.pmi_miss;
amygdala_fs_pmi_cr = amygdala_fs.pmi_cr;
amygdala_fs_pmi_fa = amygdala_fs.pmi_fa;
amygdala_fs_pmi_correct = amygdala_fs.pmi_correct;
amygdala_fs_pmi_incorrect = amygdala_fs.pmi_incorrect;
amygdala_fs_pmi_action = amygdala_fs.pmi_action;
amygdala_fs_pmi_inaction = amygdala_fs.pmi_inaction;
amygdala_fs_pmi_hit(amygdala_fs_excld) = [];
amygdala_fs_pmi_miss(amygdala_fs_excld) = [];
amygdala_fs_pmi_cr(amygdala_fs_excld) = [];
amygdala_fs_pmi_fa(amygdala_fs_excld) = [];
amygdala_fs_pmi_correct(amygdala_fs_excld) = [];
amygdala_fs_pmi_incorrect(amygdala_fs_excld) = [];
amygdala_fs_pmi_action(amygdala_fs_excld) = [];
amygdala_fs_pmi_inaction(amygdala_fs_excld) = [];
amygdala_fs_pmi_avgs = [nanmean(amygdala_fs_pmi_hit), nanmean(amygdala_fs_pmi_miss), nanmean(amygdala_fs_pmi_cr), nanmean(amygdala_fs_pmi_fa), ...
    nanmean(amygdala_fs_pmi_correct), nanmean(amygdala_fs_pmi_incorrect), nanmean(amygdala_fs_pmi_action), nanmean(amygdala_fs_pmi_inaction)];
amygdala_fs_pmi_errs = [nanstd(amygdala_fs_pmi_hit)/sqrt(sum(~isnan(amygdala_fs_pmi_hit))), ...
    nanstd(amygdala_fs_pmi_miss)/sqrt(sum(~isnan(amygdala_fs_pmi_miss))), ...
    nanstd(amygdala_fs_pmi_cr)/sqrt(sum(~isnan(amygdala_fs_pmi_cr))), ...
    nanstd(amygdala_fs_pmi_fa)/sqrt(sum(~isnan(amygdala_fs_pmi_fa))), ...
    nanstd(amygdala_fs_pmi_correct)/sqrt(sum(~isnan(amygdala_fs_pmi_correct))), ...
    nanstd(amygdala_fs_pmi_incorrect)/sqrt(sum(~isnan(amygdala_fs_pmi_incorrect))), ...
    nanstd(amygdala_fs_pmi_action)/sqrt(sum(~isnan(amygdala_fs_pmi_action))), ...
    nanstd(amygdala_fs_pmi_inaction)/sqrt(sum(~isnan(amygdala_fs_pmi_inaction)))];

amygdala_fs_pmi_mat = [amygdala_fs_pmi_hit, amygdala_fs_pmi_miss, amygdala_fs_pmi_cr, amygdala_fs_pmi_fa];
fprintf('Amygdala FS MI ANOVA:\n')
[p,~,stats] = anova1(amygdala_fs_pmi_mat)

amygdala_fs_theta_bars_hit = amygdala_fs.theta_bars_hit;
amygdala_fs_theta_bars_miss = amygdala_fs.theta_bars_miss;
amygdala_fs_theta_bars_cr = amygdala_fs.theta_bars_cr;
amygdala_fs_theta_bars_fa = amygdala_fs.theta_bars_fa;
amygdala_fs_theta_bars_correct = amygdala_fs.theta_bars_correct;
amygdala_fs_theta_bars_incorrect = amygdala_fs.theta_bars_incorrect;
amygdala_fs_theta_bars_action = amygdala_fs.theta_bars_action;
amygdala_fs_theta_bars_inaction = amygdala_fs.theta_bars_inaction;
amygdala_fs_theta_bars_hit(amygdala_fs_excld) = [];
amygdala_fs_theta_bars_miss(amygdala_fs_excld) = [];
amygdala_fs_theta_bars_cr(amygdala_fs_excld) = [];
amygdala_fs_theta_bars_fa(amygdala_fs_excld) = [];
amygdala_fs_theta_bars_correct(amygdala_fs_excld) = [];
amygdala_fs_theta_bars_incorrect(amygdala_fs_excld) = [];
amygdala_fs_theta_bars_action(amygdala_fs_excld) = [];
amygdala_fs_theta_bars_inaction(amygdala_fs_excld) = [];
amygdala_fs_theta_bars_avgs = [circ_mean(amygdala_fs_theta_bars_hit), circ_mean(amygdala_fs_theta_bars_miss), circ_mean(amygdala_fs_theta_bars_cr), circ_mean(amygdala_fs_theta_bars_fa), ...
    circ_mean(amygdala_fs_theta_bars_correct), circ_mean(amygdala_fs_theta_bars_incorrect), circ_mean(amygdala_fs_theta_bars_action), circ_mean(amygdala_fs_theta_bars_inaction)];
amygdala_fs_theta_bars_errs = [circ_std(amygdala_fs_theta_bars_hit)/sqrt(sum(~isnan(amygdala_fs_theta_bars_hit))), ...
    circ_std(amygdala_fs_theta_bars_miss)/sqrt(sum(~isnan(amygdala_fs_theta_bars_miss))), ...
    circ_std(amygdala_fs_theta_bars_cr)/sqrt(sum(~isnan(amygdala_fs_theta_bars_cr))), ...
    circ_std(amygdala_fs_theta_bars_fa)/sqrt(sum(~isnan(amygdala_fs_theta_bars_fa))), ...
    circ_std(amygdala_fs_theta_bars_correct)/sqrt(sum(~isnan(amygdala_fs_theta_bars_correct))), ...
    circ_std(amygdala_fs_theta_bars_incorrect)/sqrt(sum(~isnan(amygdala_fs_theta_bars_incorrect))), ...
    circ_std(amygdala_fs_theta_bars_action)/sqrt(sum(~isnan(amygdala_fs_theta_bars_action))), ...
    circ_std(amygdala_fs_theta_bars_inaction)/sqrt(sum(~isnan(amygdala_fs_theta_bars_inaction)))];

mod_by_outcome_fig = figure('Position', [1222 868 869 1035]);
tl = tiledlayout(4,2);
axs = zeros(4,2);
axs(1,1) = nexttile;
hold on
bar(1:3, [nanmean(s1_rs_justCorrect), nanmean(s1_rs_justIncorrect), nanmean(s1_rs_correctIncorrect)], ...
     'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:3, [nanmean(s1_rs_justCorrect), nanmean(s1_rs_justIncorrect), nanmean(s1_rs_correctIncorrect)], ...
    [nanstd(s1_rs_justCorrect) ./ sqrt(sum(~isnan(s1_rs_justCorrect))), ...
    nanstd(s1_rs_justIncorrect) ./ sqrt(sum(~isnan(s1_rs_justIncorrect))), ...
    nanstd(s1_rs_correctIncorrect) ./ sqrt(sum(~isnan(s1_rs_correctIncorrect)))], 'k.')
bar(6:8, [nanmean(s1_rs_justAction), nanmean(s1_rs_justInaction), nanmean(s1_rs_actionInaction)], ...
    'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(6:8, [nanmean(s1_rs_justAction), nanmean(s1_rs_justInaction), nanmean(s1_rs_actionInaction)], ...
    [nanstd(s1_rs_justAction) ./ sqrt(sum(~isnan(s1_rs_justAction))), ...
    nanstd(s1_rs_justInaction) ./ sqrt(sum(~isnan(s1_rs_justInaction))), ...
    nanstd(s1_rs_actionInaction) ./ sqrt(sum(~isnan(s1_rs_actionInaction)))], 'k.')
xticks([1:3,6:8])
xticklabels({'Corret', 'Incorrect', 'Both', 'Action', 'Inaction', 'Both'})
xtickangle(45)
title('Somatosensory Cortex RS')
ylim([0,1])
yticks([0,1])
axs(1,2) = nexttile;
hold on
bar(1:3, [nanmean(s1_fs_justCorrect), nanmean(s1_fs_justIncorrect), nanmean(s1_fs_correctIncorrect)], ...
     'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:3, [nanmean(s1_fs_justCorrect), nanmean(s1_fs_justIncorrect), nanmean(s1_fs_correctIncorrect)], ...
    [nanstd(s1_fs_justCorrect) ./ sqrt(sum(~isnan(s1_fs_justCorrect))), ...
    nanstd(s1_fs_justIncorrect) ./ sqrt(sum(~isnan(s1_fs_justIncorrect))), ...
    nanstd(s1_fs_correctIncorrect) ./ sqrt(sum(~isnan(s1_fs_correctIncorrect)))], 'k.')
bar(6:8, [nanmean(s1_fs_justAction), nanmean(s1_fs_justInaction), nanmean(s1_fs_actionInaction)], ...
    'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(6:8, [nanmean(s1_fs_justAction), nanmean(s1_fs_justInaction), nanmean(s1_fs_actionInaction)], ...
    [nanstd(s1_fs_justAction) ./ sqrt(sum(~isnan(s1_fs_justAction))), ...
    nanstd(s1_fs_justInaction) ./ sqrt(sum(~isnan(s1_fs_justInaction))), ...
    nanstd(s1_fs_actionInaction) ./ sqrt(sum(~isnan(s1_fs_actionInaction)))], 'k.')
xticks([1:3,6:8])
xticklabels({'Corret', 'Incorrect', 'Both', 'Action', 'Inaction', 'Both'})
xtickangle(45)
title('Somatosensory Cortex FS')
ylim([0,1])
yticks([0,1])
axs(2,1) = nexttile;
hold on
bar(1:3, [nanmean(pfc_rs_justCorrect), nanmean(pfc_rs_justIncorrect), nanmean(pfc_rs_correctIncorrect)], ...
     'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:3, [nanmean(pfc_rs_justCorrect), nanmean(pfc_rs_justIncorrect), nanmean(pfc_rs_correctIncorrect)], ...
    [nanstd(pfc_rs_justCorrect) ./ sqrt(sum(~isnan(pfc_rs_justCorrect))), ...
    nanstd(pfc_rs_justIncorrect) ./ sqrt(sum(~isnan(pfc_rs_justIncorrect))), ...
    nanstd(pfc_rs_correctIncorrect) ./ sqrt(sum(~isnan(pfc_rs_correctIncorrect)))], 'k.')
bar(6:8, [nanmean(pfc_rs_justAction), nanmean(pfc_rs_justInaction), nanmean(pfc_rs_actionInaction)], ...
    'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(6:8, [nanmean(pfc_rs_justAction), nanmean(pfc_rs_justInaction), nanmean(pfc_rs_actionInaction)], ...
    [nanstd(pfc_rs_justAction) ./ sqrt(sum(~isnan(pfc_rs_justAction))), ...
    nanstd(pfc_rs_justInaction) ./ sqrt(sum(~isnan(pfc_rs_justInaction))), ...
    nanstd(pfc_rs_actionInaction) ./ sqrt(sum(~isnan(pfc_rs_actionInaction)))], 'k.')
xticks([1:3,6:8])
xticklabels({'Corret', 'Incorrect', 'Both', 'Action', 'Inaction', 'Both'})
xtickangle(45)
title('Prefrontal Cortex RS')
ylim([0,1])
yticks([0,1])
axs(2,2) = nexttile;
hold on
bar(1:3, [nanmean(pfc_fs_justCorrect), nanmean(pfc_fs_justIncorrect), nanmean(pfc_fs_correctIncorrect)], ...
     'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:3, [nanmean(pfc_fs_justCorrect), nanmean(pfc_fs_justIncorrect), nanmean(pfc_fs_correctIncorrect)], ...
    [nanstd(pfc_fs_justCorrect) ./ sqrt(sum(~isnan(pfc_fs_justCorrect))), ...
    nanstd(pfc_fs_justIncorrect) ./ sqrt(sum(~isnan(pfc_fs_justIncorrect))), ...
    nanstd(pfc_fs_correctIncorrect) ./ sqrt(sum(~isnan(pfc_fs_correctIncorrect)))], 'k.')
bar(6:8, [nanmean(pfc_fs_justAction), nanmean(pfc_fs_justInaction), nanmean(pfc_fs_actionInaction)], ...
    'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(6:8, [nanmean(pfc_fs_justAction), nanmean(pfc_fs_justInaction), nanmean(pfc_fs_actionInaction)], ...
    [nanstd(pfc_fs_justAction) ./ sqrt(sum(~isnan(pfc_fs_justAction))), ...
    nanstd(pfc_fs_justInaction) ./ sqrt(sum(~isnan(pfc_fs_justInaction))), ...
    nanstd(pfc_fs_actionInaction) ./ sqrt(sum(~isnan(pfc_fs_actionInaction)))], 'k.')
xticks([1:3,6:8])
xticklabels({'Corret', 'Incorrect', 'Both', 'Action', 'Inaction', 'Both'})
xtickangle(45)
title('Prefrontal Cortex FS')
ylim([0,1])
yticks([0,1])
axs(3,1) = nexttile;
hold on
bar(1:3, [nanmean(striatum_rs_justCorrect), nanmean(striatum_rs_justIncorrect), nanmean(striatum_rs_correctIncorrect)], ...
     'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:3, [nanmean(striatum_rs_justCorrect), nanmean(striatum_rs_justIncorrect), nanmean(striatum_rs_correctIncorrect)], ...
    [nanstd(striatum_rs_justCorrect) ./ sqrt(sum(~isnan(striatum_rs_justCorrect))), ...
    nanstd(striatum_rs_justIncorrect) ./ sqrt(sum(~isnan(striatum_rs_justIncorrect))), ...
    nanstd(striatum_rs_correctIncorrect) ./ sqrt(sum(~isnan(striatum_rs_correctIncorrect)))], 'k.')
bar(6:8, [nanmean(striatum_rs_justAction), nanmean(striatum_rs_justInaction), nanmean(striatum_rs_actionInaction)], ...
    'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(6:8, [nanmean(striatum_rs_justAction), nanmean(striatum_rs_justInaction), nanmean(striatum_rs_actionInaction)], ...
    [nanstd(striatum_rs_justAction) ./ sqrt(sum(~isnan(striatum_rs_justAction))), ...
    nanstd(striatum_rs_justInaction) ./ sqrt(sum(~isnan(striatum_rs_justInaction))), ...
    nanstd(striatum_rs_actionInaction) ./ sqrt(sum(~isnan(striatum_rs_actionInaction)))], 'k.')
xticks([1:3,6:8])
xticklabels({'Corret', 'Incorrect', 'Both', 'Action', 'Inaction', 'Both'})
xtickangle(45)
title('Striatum RS')
ylim([0,1])
yticks([0,1])
axs(3,2) = nexttile;
hold on
bar(1:3, [nanmean(striatum_fs_justCorrect), nanmean(striatum_fs_justIncorrect), nanmean(striatum_fs_correctIncorrect)], ...
     'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:3, [nanmean(striatum_fs_justCorrect), nanmean(striatum_fs_justIncorrect), nanmean(striatum_fs_correctIncorrect)], ...
    [nanstd(striatum_fs_justCorrect) ./ sqrt(sum(~isnan(striatum_fs_justCorrect))), ...
    nanstd(striatum_fs_justIncorrect) ./ sqrt(sum(~isnan(striatum_fs_justIncorrect))), ...
    nanstd(striatum_fs_correctIncorrect) ./ sqrt(sum(~isnan(striatum_fs_correctIncorrect)))], 'k.')
bar(6:8, [nanmean(striatum_fs_justAction), nanmean(striatum_fs_justInaction), nanmean(striatum_fs_actionInaction)], ...
    'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(6:8, [nanmean(striatum_fs_justAction), nanmean(striatum_fs_justInaction), nanmean(striatum_fs_actionInaction)], ...
    [nanstd(striatum_fs_justAction) ./ sqrt(sum(~isnan(striatum_fs_justAction))), ...
    nanstd(striatum_fs_justInaction) ./ sqrt(sum(~isnan(striatum_fs_justInaction))), ...
    nanstd(striatum_fs_actionInaction) ./ sqrt(sum(~isnan(striatum_fs_actionInaction)))], 'k.')
xticks([1:3,6:8])
xticklabels({'Corret', 'Incorrect', 'Both', 'Action', 'Inaction', 'Both'})
xtickangle(45)
title('Striatum FS')
ylim([0,1])
yticks([0,1])
axs(4,1) = nexttile;
hold on
bar(1:3, [nanmean(amygdala_rs_justCorrect), nanmean(amygdala_rs_justIncorrect), nanmean(amygdala_rs_correctIncorrect)], ...
     'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:3, [nanmean(amygdala_rs_justCorrect), nanmean(amygdala_rs_justIncorrect), nanmean(amygdala_rs_correctIncorrect)], ...
    [nanstd(amygdala_rs_justCorrect) ./ sqrt(sum(~isnan(amygdala_rs_justCorrect))), ...
    nanstd(amygdala_rs_justIncorrect) ./ sqrt(sum(~isnan(amygdala_rs_justIncorrect))), ...
    nanstd(amygdala_rs_correctIncorrect) ./ sqrt(sum(~isnan(amygdala_rs_correctIncorrect)))], 'k.')
bar(6:8, [nanmean(amygdala_rs_justAction), nanmean(amygdala_rs_justInaction), nanmean(amygdala_rs_actionInaction)], ...
    'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(6:8, [nanmean(amygdala_rs_justAction), nanmean(amygdala_rs_justInaction), nanmean(amygdala_rs_actionInaction)], ...
    [nanstd(amygdala_rs_justAction) ./ sqrt(sum(~isnan(amygdala_rs_justAction))), ...
    nanstd(amygdala_rs_justInaction) ./ sqrt(sum(~isnan(amygdala_rs_justInaction))), ...
    nanstd(amygdala_rs_actionInaction) ./ sqrt(sum(~isnan(amygdala_rs_actionInaction)))], 'k.')
xticks([1:3,6:8])
xticklabels({'Corret', 'Incorrect', 'Both', 'Action', 'Inaction', 'Both'})
xtickangle(45)
title('Amygdala RS')
ylim([0,1])
yticks([0,1])
axs(4,2) = nexttile;
hold on
bar(1:3, [nanmean(amygdala_fs_justCorrect), nanmean(amygdala_fs_justIncorrect), nanmean(amygdala_fs_correctIncorrect)], ...
     'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:3, [nanmean(amygdala_fs_justCorrect), nanmean(amygdala_fs_justIncorrect), nanmean(amygdala_fs_correctIncorrect)], ...
    [nanstd(amygdala_fs_justCorrect) ./ sqrt(sum(~isnan(amygdala_fs_justCorrect))), ...
    nanstd(amygdala_fs_justIncorrect) ./ sqrt(sum(~isnan(amygdala_fs_justIncorrect))), ...
    nanstd(amygdala_fs_correctIncorrect) ./ sqrt(sum(~isnan(amygdala_fs_correctIncorrect)))], 'k.')
bar(6:8, [nanmean(amygdala_fs_justAction), nanmean(amygdala_fs_justInaction), nanmean(amygdala_fs_actionInaction)], ...
    'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(6:8, [nanmean(amygdala_fs_justAction), nanmean(amygdala_fs_justInaction), nanmean(amygdala_fs_actionInaction)], ...
    [nanstd(amygdala_fs_justAction) ./ sqrt(sum(~isnan(amygdala_fs_justAction))), ...
    nanstd(amygdala_fs_justInaction) ./ sqrt(sum(~isnan(amygdala_fs_justInaction))), ...
    nanstd(amygdala_fs_actionInaction) ./ sqrt(sum(~isnan(amygdala_fs_actionInaction)))], 'k.')
xticks([1:3,6:8])
xticklabels({'Corret', 'Incorrect', 'Both', 'Action', 'Inaction', 'Both'})
xtickangle(45)
title('Amygdala FS')
ylim([0,1])
yticks([0,1])
xlabel(tl, 'Trial Outcome')
ylabel(tl, 'Fraction of Modulated Neurons')

% saveas(mod_by_outcome_fig, 'tmp/mod_by_outcome_fig.png')
if out_path
    saveas(mod_by_outcome_fig, 'Figures/mod_by_outcome_fig.svg')
    saveas(mod_by_outcome_fig, 'Figures/mod_by_outcome_fig.fig')
end

mse_fig = figure('Position', [1452 766 849 1011]);
tl = tiledlayout(4,2);
axs = zeros(4,2);
axs(1) = nexttile; 
bar([1,2,3,4,6,7,9,10], s1_rs_mse_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], s1_rs_mse_avgs, s1_rs_mse_errs, 'k.')
title('S1 RS', 'FontSize', 16, 'FontWeight', 'normal')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
ylim([0,0.013])
yticks([0,0.013])
axs(2) = nexttile;
bar([1,2,3,4,6,7,9,10], s1_fs_mse_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], s1_fs_mse_avgs, s1_fs_mse_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
title('S1 FS', 'FontSize', 16, 'FontWeight', 'normal')
ylim([0,0.007])
yticks([0,0.007])
axs(3) = nexttile; 
bar([1,2,3,4,6,7,9,10], pfc_rs_mse_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], pfc_rs_mse_avgs, pfc_rs_mse_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
title('PFC RS', 'FontSize', 16, 'FontWeight', 'normal')
ylim([0,0.013])
yticks([0,0.013])
axs(4) = nexttile;
bar([1,2,3,4,6,7,9,10], pfc_fs_mse_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], pfc_fs_mse_avgs, pfc_fs_mse_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
title('PFC FS', 'FontSize', 16, 'FontWeight', 'normal')
ylim([0,0.007])
yticks([0,0.007])
ylabel(tl, 'von Mises MSE', 'FontSize', 16)
xlabel(tl, 'Trial Outcome', 'FontSize', 16)
axs(5) = nexttile; 
bar([1,2,3,4,6,7,9,10], striatum_rs_mse_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], striatum_rs_mse_avgs, striatum_rs_mse_errs, 'k.')
title('Striatum RS', 'FontSize', 16, 'FontWeight', 'normal')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
ylim([0,0.013])
yticks([0,0.013])
axs(6) = nexttile;
bar([1,2,3,4,6,7,9,10], striatum_fs_mse_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], striatum_fs_mse_avgs, striatum_fs_mse_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
title('Striatum FS', 'FontSize', 16, 'FontWeight', 'normal')
ylim([0,0.007])
yticks([0,0.007])
axs(7) = nexttile; 
bar([1,2,3,4,6,7,9,10], amygdala_rs_mse_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], amygdala_rs_mse_avgs, amygdala_rs_mse_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({'Hit', 'Miss', 'Correct Rejection', 'False Alarm', 'Correct', 'Incorrect', 'Action', 'Inaction'})
ax = gca;
ax.XAxis.FontSize = 14;
title('Amygdala RS', 'FontSize', 16, 'FontWeight', 'normal')
ylim([0,0.013])
yticks([0,0.013])
axs(8) = nexttile;
bar([1,2,3,4,6,7,9,10], amygdala_fs_mse_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], amygdala_fs_mse_avgs, amygdala_fs_mse_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({'Hit', 'Miss', 'Correct Rejection', 'False Alarm', 'Correct', 'Incorrect', 'Action', 'Inaction'})
ax = gca;
ax.XAxis.FontSize = 14;
title('Amygdala FS', 'FontSize', 16, 'FontWeight', 'normal')
ylim([0,0.007])
yticks([0,0.007])
ylabel(tl, 'von Mises MSE', 'FontSize', 16)
xlabel(tl, 'Trial Outcome', 'FontSize', 16)
if out_path
    saveas(mse_fig, 'Figures/mse_by_outcome.fig')
    saveas(mse_fig, 'Figures/mse_by_outcome.svg')
end

pmi_fig = figure('Position', [1452 766 849 1011]);
tl = tiledlayout(4,2);
axs = zeros(4,2);
axs(1) = nexttile; 
bar([1,2,3,4,6,7,9,10], s1_rs_pmi_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], s1_rs_pmi_avgs, s1_rs_pmi_errs, 'k.')
title('S1 RS', 'FontSize', 16, 'FontWeight', 'normal')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
ylim([0,0.11])
yticks([0,0.11])
axs(2) = nexttile;
bar([1,2,3,4,6,7,9,10], s1_fs_pmi_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], s1_fs_pmi_avgs, s1_fs_pmi_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
title('S1 FS', 'FontSize', 16, 'FontWeight', 'normal')
yticks([0,0.06])
ylim([0,0.06])
axs(3) = nexttile; 
bar([1,2,3,4,6,7,9,10], pfc_rs_pmi_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], pfc_rs_pmi_avgs, pfc_rs_pmi_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
title('PFC RS', 'FontSize', 16, 'FontWeight', 'normal')
yticks([0,0.11])
ylim([0,0.11])
axs(4) = nexttile;
bar([1,2,3,4,6,7,9,10], pfc_fs_pmi_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], pfc_fs_pmi_avgs, pfc_fs_pmi_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
title('PFC FS', 'FontSize', 16, 'FontWeight', 'normal')
ylabel(tl, 'Modulation Index', 'FontSize', 16)
xlabel(tl, 'Trial Outcome', 'FontSize', 16)
yticks([0,0.06])
ylim([0,0.06])
axs(5) = nexttile; 
bar([1,2,3,4,6,7,9,10], striatum_rs_pmi_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], striatum_rs_pmi_avgs, striatum_rs_pmi_errs, 'k.')
title('Striatum RS', 'FontSize', 16, 'FontWeight', 'normal')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
ylim([0,0.11])
yticks([0,0.11])
axs(6) = nexttile;
bar([1,2,3,4,6,7,9,10], striatum_fs_pmi_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], striatum_fs_pmi_avgs, striatum_fs_pmi_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
title('Striatum FS', 'FontSize', 16, 'FontWeight', 'normal')
yticks([0,0.06])
ylim([0,0.06])
axs(7) = nexttile; 
bar([1,2,3,4,6,7,9,10], amygdala_rs_pmi_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], amygdala_rs_pmi_avgs, amygdala_rs_pmi_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({'Hit', 'Miss', 'Correct Rejection', 'False Alarm', 'Correct', 'Incorrect', 'Action', 'Inaction'})
ax = gca;
ax.XAxis.FontSize = 14;
title('Amygdala RS', 'FontSize', 16, 'FontWeight', 'normal')
yticks([0,0.11])
ylim([0,0.11])
axs(8) = nexttile;
bar([1,2,3,4,6,7,9,10], amygdala_fs_pmi_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], amygdala_fs_pmi_avgs, amygdala_fs_pmi_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({'Hit', 'Miss', 'Correct Rejection', 'False Alarm', 'Correct', 'Incorrect', 'Action', 'Inaction'})
ax = gca;
ax.XAxis.FontSize = 14;
title('Amygdala FS', 'FontSize', 16, 'FontWeight', 'normal')
ylabel(tl, 'Modulation Index', 'FontSize', 16)
xlabel(tl, 'Trial Outcome', 'FontSize', 16)
yticks([0,0.06])
ylim([0,0.06])
% unifyYLimits(axs)
if out_path
    saveas(pmi_fig, 'Figures/pmi_by_outcome.fig')
    saveas(pmi_fig, 'Figures/pmi_by_outcome.svg')
end

theta_bars_fig = figure('Position', [1452 766 849 1011]);
tl = tiledlayout(4,2);
axs = zeros(4,2);
axs(1) = nexttile; 
bar([1,2,3,4,6,7,9,10], s1_rs_theta_bars_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], s1_rs_theta_bars_avgs, s1_rs_theta_bars_errs, 'k.')
title('S1 RS', 'FontSize', 16, 'FontWeight', 'normal')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
ylim([-3.5,3.5])
yticks([-pi,pi])
yticklabels({'-\pi', '\pi'})
axs(2) = nexttile;
bar([1,2,3,4,6,7,9,10], s1_fs_theta_bars_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], s1_fs_theta_bars_avgs, s1_fs_theta_bars_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
title('S1 FS', 'FontSize', 16, 'FontWeight', 'normal')
ylim([-3.5,3.5])
yticks([-pi,pi])
yticklabels({'-\pi', '\pi'})
axs(3) = nexttile; 
bar([1,2,3,4,6,7,9,10], pfc_rs_theta_bars_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], pfc_rs_theta_bars_avgs, pfc_rs_theta_bars_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
title('PFC RS', 'FontSize', 16, 'FontWeight', 'normal')
ylim([-3.5,3.5])
yticks([-pi,pi])
yticklabels({'-\pi', '\pi'})
axs(4) = nexttile;
bar([1,2,3,4,6,7,9,10], pfc_fs_theta_bars_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], pfc_fs_theta_bars_avgs, pfc_fs_theta_bars_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
title('PFC FS', 'FontSize', 16, 'FontWeight', 'normal')
ylim([-3.5,3.5])
yticks([-pi,pi])
yticklabels({'-\pi', '\pi'})
axs(5) = nexttile; 
bar([1,2,3,4,6,7,9,10], striatum_rs_theta_bars_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], striatum_rs_theta_bars_avgs, striatum_rs_theta_bars_errs, 'k.')
title('Striatum RS', 'FontSize', 16, 'FontWeight', 'normal')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
yticks([-pi,pi])
ylim([-3.5,3.5])
yticklabels({'-\pi', '\pi'})
axs(6) = nexttile;
bar([1,2,3,4,6,7,9,10], striatum_fs_theta_bars_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], striatum_fs_theta_bars_avgs, striatum_fs_theta_bars_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({})
title('Striatum FS', 'FontSize', 16, 'FontWeight', 'normal')
ylim([-3.5,3.5])
yticks([-pi,pi])
yticklabels({'-\pi', '\pi'})
axs(7) = nexttile; 
bar([1,2,3,4,6,7,9,10], amygdala_rs_theta_bars_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], amygdala_rs_theta_bars_avgs, amygdala_rs_theta_bars_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({'Hit', 'Miss', 'Correct Rejection', 'False Alarm', 'Correct', 'Incorrect', 'Action', 'Inaction'})
ax = gca;
ax.XAxis.FontSize = 14;
title('Amygdala RS', 'FontSize', 16, 'FontWeight', 'normal')
ylim([-3.5,3.5])
yticks([-pi,pi])
yticklabels({'-\pi', '\pi'})
axs(8) = nexttile;
bar([1,2,3,4,6,7,9,10], amygdala_fs_theta_bars_avgs, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5, 0.5, 0.5])
hold on 
errorbar([1,2,3,4,6,7,9,10], amygdala_fs_theta_bars_avgs, amygdala_fs_theta_bars_errs, 'k.')
xticks([1,2,3,4,6,7,9,10])
xticklabels({'Hit', 'Miss', 'Correct Rejection', 'False Alarm', 'Correct', 'Incorrect', 'Action', 'Inaction'})
ax = gca;
ax.XAxis.FontSize = 14;
title('Amygdala FS', 'FontSize', 16, 'FontWeight', 'normal')
ylabel(tl, 'Avg. Spike Phase (radians)', 'FontSize', 16)
xlabel(tl, 'Trial Outcome', 'FontSize', 16)
ylim([-3.5,3.5])
yticks([-pi,pi])
yticklabels({'-\pi', '\pi'})
% unifyYLimits(axs)

if out_path
    saveas(theta_bars_fig, 'Figures/theta_bars_by_outcome.fig')
    saveas(theta_bars_fig, 'Figures/theta_bars_by_outcome.svg')
end

p = signrank(s1_rs_pmi_correct, s1_rs_pmi_incorrect);
if p < (0.05 / size(s1_rs,1))
    fprintf(sprintf('S1 RS MI Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('S1 RS MI Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('S1 RS MI Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(s1_rs_pmi_action, s1_rs_pmi_inaction);
if p < (0.05 / size(s1_rs,1))
    fprintf(sprintf('S1 RS MI Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('S1 RS MI Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('S1 RS MI Action vs. Inaction (signed rank): p = %d\n', p))
end
p = signrank(s1_rs_mses_correct, s1_rs_mses_incorrect);
if p < (0.05 / size(s1_rs,1))
    fprintf(sprintf('S1 RS MSE Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('S1 RS MSE Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('S1 RS MSE Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(s1_rs_mses_action, s1_rs_mses_inaction);
if p < (0.05 / size(s1_rs,1))
    fprintf(sprintf('S1 RS MSE Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('S1 RS MSE Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('S1 RS MSE Action vs. Inaction (signed rank): p = %d\n', p))
end
p = signrank(s1_fs_pmi_correct, s1_fs_pmi_incorrect);
if p < (0.05 / size(s1_fs,1))
    fprintf(sprintf('S1 FS MI Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('S1 FS MI Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('S1 FS MI Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(s1_fs_pmi_action, s1_fs_pmi_inaction);
if p < (0.05 / size(s1_fs,1))
    fprintf(sprintf('S1 FS MI Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('S1 FS MI Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('S1 FS MI Action vs. Inaction (signed rank): p = %d\n', p))
end
p = signrank(s1_fs_mses_correct, s1_fs_mses_incorrect);
if p < (0.05 / size(s1_fs,1))
    fprintf(sprintf('S1 FS MSE Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('S1 FS MSE Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('S1 FS MSE Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(s1_fs_mses_action, s1_fs_mses_inaction);
if p < (0.05 / size(s1_fs,1))
    fprintf(sprintf('S1 FS MSE Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('S1 FS MSE Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('S1 FS MSE Action vs. Inaction (signed rank): p = %d\n', p))
end
p = signrank(pfc_rs_pmi_correct, pfc_rs_pmi_incorrect);
if p < (0.05 / size(pfc_rs,1))
    fprintf(sprintf('PFC RS MI Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('PFC RS MI Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('PFC RS MI Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(pfc_rs_pmi_action, pfc_rs_pmi_inaction);
if p < (0.05 / size(pfc_rs,1))
    fprintf(sprintf('PFC RS MI Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('PFC RS MI Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('PFC RS MI Action vs. Inaction (signed rank): p = %d\n', p))
end
p = signrank(pfc_rs_mses_correct, pfc_rs_mses_incorrect);
if p < (0.05 / size(pfc_rs,1))
    fprintf(sprintf('PFC RS MSE Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('PFC RS MSE Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('PFC RS MSE Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(pfc_rs_mses_action, pfc_rs_mses_inaction);
if p < (0.05 / size(pfc_rs,1))
    fprintf(sprintf('PFC RS MSE Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('PFC RS MSE Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('PFC RS MSE Action vs. Inaction (signed rank): p = %d\n', p))
end
p = signrank(pfc_fs_pmi_correct, pfc_fs_pmi_incorrect);
if p < (0.05 / size(pfc_fs,1))
    fprintf(sprintf('PFC FS MI Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('PFC FS MI Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('PFC FS MI Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(pfc_fs_pmi_action, pfc_fs_pmi_inaction);
if p < (0.05 / size(pfc_fs,1))
    fprintf(sprintf('PFC FS MI Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('PFC FS MI Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('PFC FS MI Action vs. Inaction (signed rank): p = %d\n', p))
end
p = signrank(pfc_fs_mses_correct, pfc_fs_mses_incorrect);
if p < (0.05 / size(pfc_fs,1))
    fprintf(sprintf('PFC FS MSE Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('PFC FS MSE Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('PFC FS MSE Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(pfc_fs_mses_action, pfc_fs_mses_inaction);
if p < (0.05 / size(pfc_fs,1))
    fprintf(sprintf('PFC FS MSE Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('PFC FS MSE Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('PFC FS MSE Action vs. Inaction (signed rank): p = %d\n', p))
end

p = signrank(striatum_rs_pmi_correct, striatum_rs_pmi_incorrect);
if p < (0.05 / size(striatum_rs,1))
    fprintf(sprintf('Striatum RS MI Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Striatum RS MI Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum RS MI Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(striatum_rs_pmi_action, striatum_rs_pmi_inaction);
if p < (0.05 / size(striatum_rs,1))
    fprintf(sprintf('Striatum RS MI Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Striatum RS MI Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum RS MI Action vs. Inaction (signed rank): p = %d\n', p))
end
p = signrank(striatum_rs_mses_correct, striatum_rs_mses_incorrect);
if p < (0.05 / size(striatum_rs,1))
    fprintf(sprintf('Striatum RS MSE Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Striatum RS MSE Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum RS MSE Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(striatum_rs_mses_action, striatum_rs_mses_inaction);
if p < (0.05 / size(striatum_rs,1))
    fprintf(sprintf('Striatum RS MSE Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Striatum RS MSE Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum RS MSE Action vs. Inaction (signed rank): p = %d\n', p))
end
p = signrank(striatum_fs_pmi_correct, striatum_fs_pmi_incorrect);
if p < (0.05 / size(striatum_fs,1))
    fprintf(sprintf('Striatum FS MI Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Striatum FS MI Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum FS MI Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(striatum_fs_pmi_action, striatum_fs_pmi_inaction);
if p < (0.05 / size(striatum_fs,1))
    fprintf(sprintf('Striatum FS MI Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Striatum FS MI Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum FS MI Action vs. Inaction (signed rank): p = %d\n', p))
end
p = signrank(striatum_fs_mses_correct, striatum_fs_mses_incorrect);
if p < (0.05 / size(striatum_fs,1))
    fprintf(sprintf('Striatum FS MSE Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Striatum FS MSE Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum FS MSE Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(striatum_fs_mses_action, striatum_fs_mses_inaction);
if p < (0.05 / size(striatum_fs,1))
    fprintf(sprintf('Striatum FS MSE Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Striatum FS MSE Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum FS MSE Action vs. Inaction (signed rank): p = %d\n', p))
end
p = signrank(amygdala_rs_pmi_correct, amygdala_rs_pmi_incorrect);
if p < (0.05 / size(amygdala_rs,1))
    fprintf(sprintf('Amygdala RS MI Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Amygdala RS MI Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala RS MI Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(amygdala_rs_pmi_action, amygdala_rs_pmi_inaction);
if p < (0.05 / size(amygdala_rs,1))
    fprintf(sprintf('Amygdala RS MI Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Amygdala RS MI Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala RS MI Action vs. Inaction (signed rank): p = %d\n', p))
end
p = signrank(amygdala_rs_mses_correct, amygdala_rs_mses_incorrect);
if p < (0.05 / size(amygdala_rs,1))
    fprintf(sprintf('Amygdala RS MSE Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Amygdala RS MSE Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala RS MSE Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(amygdala_rs_mses_action, amygdala_rs_mses_inaction);
if p < (0.05 / size(amygdala_rs,1))
    fprintf(sprintf('Amygdala RS MSE Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Amygdala RS MSE Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala RS MSE Action vs. Inaction (signed rank): p = %d\n', p))
end
p = signrank(amygdala_fs_pmi_correct, amygdala_fs_pmi_incorrect);
if p < (0.05 / size(amygdala_fs,1))
    fprintf(sprintf('Amygdala FS MI Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Amygdala FS MI Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala FS MI Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(amygdala_fs_pmi_action, amygdala_fs_pmi_inaction);
if p < (0.05 / size(amygdala_fs,1))
    fprintf(sprintf('Amygdala FS MI Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Amygdala FS MI Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala FS MI Action vs. Inaction (signed rank): p = %d\n', p))
end
p = signrank(amygdala_fs_mses_correct, amygdala_fs_mses_incorrect);
if p < (0.05 / size(amygdala_fs,1))
    fprintf(sprintf('Amygdala FS MSE Correct vs. Incorrect (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Amygdala FS MSE Correct vs. Incorrect (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala FS MSE Correct vs. Incorrect (signed rank): p = %d\n', p))
end
p = signrank(amygdala_fs_mses_action, amygdala_fs_mses_inaction);
if p < (0.05 / size(amygdala_fs,1))
    fprintf(sprintf('Amygdala FS MSE Action vs. Inaction (signed rank): **p = %d\n', p))
elseif p < 0.05
    fprintf(sprintf('Amygdala FS MSE Action vs. Inaction (signed rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala FS MSE Action vs. Inaction (signed rank): p = %d\n', p))
end

fprintf(sprintf('S1 RS MI Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(s1_rs_pmi_incorrect - s1_rs_pmi_correct), ...
    nanstd(s1_rs_pmi_incorrect-s1_rs_pmi_correct)/sqrt(sum(~isnan(s1_rs_pmi_incorrect)))))
fprintf(sprintf('S1 RS MI Inaction minus Action: %d +/- %d\n', ...
    nanmean(s1_rs_pmi_inaction - s1_rs_pmi_action), ...
    nanstd(s1_rs_pmi_inaction-s1_rs_pmi_action)/sqrt(sum(~isnan(s1_rs_pmi_inaction)))))
fprintf(sprintf('S1 RS von Mises MSE Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(s1_rs_mses_incorrect - s1_rs_mses_correct), ...
    nanstd(s1_rs_mses_incorrect-s1_rs_mses_correct)/sqrt(sum(~isnan(s1_rs_mses_incorrect)))))
fprintf(sprintf('S1 RS von Mises MSE Inaction minus Action: %d +/- %d\n', ...
    nanmean(s1_rs_mses_inaction - s1_rs_mses_action), ...
    nanstd(s1_rs_mses_inaction-s1_rs_mses_action)/sqrt(sum(~isnan(s1_rs_mses_inaction)))))
fprintf(sprintf('PFC RS MI Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(pfc_rs_pmi_incorrect - pfc_rs_pmi_correct), ...
    nanstd(pfc_rs_pmi_incorrect-pfc_rs_pmi_correct)/sqrt(sum(~isnan(pfc_rs_pmi_incorrect)))))
fprintf(sprintf('PFC RS MI Inaction minus Action: %d +/- %d\n', ...
    nanmean(pfc_rs_pmi_inaction - pfc_rs_pmi_action), ...
    nanstd(pfc_rs_pmi_inaction-pfc_rs_pmi_action)/sqrt(sum(~isnan(pfc_rs_pmi_inaction)))))
fprintf(sprintf('PFC RS von Mises MSE Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(pfc_rs_mses_incorrect - pfc_rs_mses_correct), ...
    nanstd(pfc_rs_mses_incorrect-pfc_rs_mses_correct)/sqrt(sum(~isnan(pfc_rs_mses_incorrect)))))
fprintf(sprintf('PFC RS von Mises MSE Inaction minus Action: %d +/- %d\n', ...
    nanmean(pfc_rs_mses_inaction - pfc_rs_mses_action), ...
    nanstd(pfc_rs_mses_inaction-pfc_rs_mses_action)/sqrt(sum(~isnan(pfc_rs_mses_inaction)))))
fprintf(sprintf('Striatum RS MI Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(striatum_rs_pmi_incorrect - striatum_rs_pmi_correct), ...
    nanstd(striatum_rs_pmi_incorrect-striatum_rs_pmi_correct)/sqrt(sum(~isnan(striatum_rs_pmi_incorrect)))))
fprintf(sprintf('Striatum RS MI Inaction minus Action: %d +/- %d\n', ...
    nanmean(striatum_rs_pmi_inaction - striatum_rs_pmi_action), ...
    nanstd(striatum_rs_pmi_inaction-striatum_rs_pmi_action)/sqrt(sum(~isnan(striatum_rs_pmi_inaction)))))
fprintf(sprintf('Striatum RS von Mises MSE Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(striatum_rs_mses_incorrect - striatum_rs_mses_correct), ...
    nanstd(striatum_rs_mses_incorrect-striatum_rs_mses_correct)/sqrt(sum(~isnan(striatum_rs_mses_incorrect)))))
fprintf(sprintf('Striatum RS von Mises MSE Inaction minus Action: %d +/- %d\n', ...
    nanmean(striatum_rs_mses_inaction - striatum_rs_mses_action), ...
    nanstd(striatum_rs_mses_inaction-striatum_rs_mses_action)/sqrt(sum(~isnan(striatum_rs_mses_inaction)))))
fprintf(sprintf('Amygdala RS MI Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(amygdala_rs_pmi_incorrect - amygdala_rs_pmi_correct), ...
    nanstd(amygdala_rs_pmi_incorrect-amygdala_rs_pmi_correct)/sqrt(sum(~isnan(amygdala_rs_pmi_incorrect)))))
fprintf(sprintf('Amygdala RS MI Inaction minus Action: %d +/- %d\n', ...
    nanmean(amygdala_rs_pmi_inaction - amygdala_rs_pmi_action), ...
    nanstd(amygdala_rs_pmi_inaction-amygdala_rs_pmi_action)/sqrt(sum(~isnan(amygdala_rs_pmi_inaction)))))
fprintf(sprintf('Amygdala RS von Mises MSE Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(amygdala_rs_mses_incorrect - amygdala_rs_mses_correct), ...
    nanstd(amygdala_rs_mses_incorrect-amygdala_rs_mses_correct)/sqrt(sum(~isnan(amygdala_rs_mses_incorrect)))))
fprintf(sprintf('Amygdala RS von Mises MSE Inaction minus Action: %d +/- %d\n', ...
    nanmean(amygdala_rs_mses_inaction - amygdala_rs_mses_action), ...
    nanstd(amygdala_rs_mses_inaction-amygdala_rs_mses_action)/sqrt(sum(~isnan(amygdala_rs_mses_inaction)))))
fprintf(sprintf('S1 FS MI Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(s1_fs_pmi_incorrect - s1_fs_pmi_correct), ...
    nanstd(s1_fs_pmi_incorrect-s1_fs_pmi_correct)/sqrt(sum(~isnan(s1_fs_pmi_incorrect)))))
fprintf(sprintf('S1 FS MI Inaction minus Action: %d +/- %d\n', ...
    nanmean(s1_fs_pmi_inaction - s1_fs_pmi_action), ...
    nanstd(s1_fs_pmi_inaction-s1_fs_pmi_action)/sqrt(sum(~isnan(s1_fs_pmi_inaction)))))
fprintf(sprintf('S1 FS von Mises MSE Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(s1_fs_mses_incorrect - s1_fs_mses_correct), ...
    nanstd(s1_fs_mses_incorrect-s1_fs_mses_correct)/sqrt(sum(~isnan(s1_fs_mses_incorrect)))))
fprintf(sprintf('S1 FS von Mises MSE Inaction minus Action: %d +/- %d\n', ...
    nanmean(s1_fs_mses_inaction - s1_fs_mses_action), ...
    nanstd(s1_fs_mses_inaction-s1_fs_mses_action)/sqrt(sum(~isnan(s1_fs_mses_inaction)))))
fprintf(sprintf('PFC FS MI Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(pfc_fs_pmi_incorrect - pfc_fs_pmi_correct), ...
    nanstd(pfc_fs_pmi_incorrect-pfc_fs_pmi_correct)/sqrt(sum(~isnan(pfc_fs_pmi_incorrect)))))
fprintf(sprintf('PFC FS MI Inaction minus Action: %d +/- %d\n', ...
    nanmean(pfc_fs_pmi_inaction - pfc_fs_pmi_action), ...
    nanstd(pfc_fs_pmi_inaction-pfc_fs_pmi_action)/sqrt(sum(~isnan(pfc_fs_pmi_inaction)))))
fprintf(sprintf('PFC FS von Mises MSE Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(pfc_fs_mses_incorrect - pfc_fs_mses_correct), ...
    nanstd(pfc_fs_mses_incorrect-pfc_fs_mses_correct)/sqrt(sum(~isnan(pfc_fs_mses_incorrect)))))
fprintf(sprintf('PFC FS von Mises MSE Inaction minus Action: %d +/- %d\n', ...
    nanmean(pfc_fs_mses_inaction - pfc_fs_mses_action), ...
    nanstd(pfc_fs_mses_inaction-pfc_fs_mses_action)/sqrt(sum(~isnan(pfc_fs_mses_inaction)))))
fprintf(sprintf('Striatum FS MI Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(striatum_fs_pmi_incorrect - striatum_fs_pmi_correct), ...
    nanstd(striatum_fs_pmi_incorrect-striatum_fs_pmi_correct)/sqrt(sum(~isnan(striatum_fs_pmi_incorrect)))))
fprintf(sprintf('Striatum FS MI Inaction minus Action: %d +/- %d\n', ...
    nanmean(striatum_fs_pmi_inaction - striatum_fs_pmi_action), ...
    nanstd(striatum_fs_pmi_inaction-striatum_fs_pmi_action)/sqrt(sum(~isnan(striatum_fs_pmi_inaction)))))
fprintf(sprintf('Striatum FS von Mises MSE Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(striatum_fs_mses_incorrect - striatum_fs_mses_correct), ...
    nanstd(striatum_fs_mses_incorrect-striatum_fs_mses_correct)/sqrt(sum(~isnan(striatum_fs_mses_incorrect)))))
fprintf(sprintf('Striatum FS von Mises MSE Inaction minus Action: %d +/- %d\n', ...
    nanmean(striatum_fs_mses_inaction - striatum_fs_mses_action), ...
    nanstd(striatum_fs_mses_inaction-striatum_fs_mses_action)/sqrt(sum(~isnan(striatum_fs_mses_inaction)))))
fprintf(sprintf('Amygdala FS MI Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(amygdala_fs_pmi_incorrect - amygdala_fs_pmi_correct), ...
    nanstd(amygdala_fs_pmi_incorrect-amygdala_fs_pmi_correct)/sqrt(sum(~isnan(amygdala_fs_pmi_incorrect)))))
fprintf(sprintf('Amygdala FS MI Inaction minus Action: %d +/- %d\n', ...
    nanmean(amygdala_fs_pmi_inaction - amygdala_fs_pmi_action), ...
    nanstd(amygdala_fs_pmi_inaction-amygdala_fs_pmi_action)/sqrt(sum(~isnan(amygdala_fs_pmi_inaction)))))
fprintf(sprintf('Amygdala FS von Mises MSE Incorrect minus Correct: %d +/- %d\n', ...
    nanmean(amygdala_fs_mses_incorrect - amygdala_fs_mses_correct), ...
    nanstd(amygdala_fs_mses_incorrect-amygdala_fs_mses_correct)/sqrt(sum(~isnan(amygdala_fs_mses_incorrect)))))
fprintf(sprintf('Amygdala FS von Mises MSE Inaction minus Action: %d +/- %d\n', ...
    nanmean(amygdala_fs_mses_inaction - amygdala_fs_mses_action), ...
    nanstd(amygdala_fs_mses_inaction-amygdala_fs_mses_action)/sqrt(sum(~isnan(amygdala_fs_mses_inaction)))))
                        

pfc_rs_theta_bars_mat = [pfc_rs_theta_bars_hit, pfc_rs_theta_bars_miss, pfc_rs_theta_bars_cr, pfc_rs_theta_bars_fa];
pfc_fs_theta_bars_mat = [pfc_fs_theta_bars_hit, pfc_fs_theta_bars_miss, pfc_fs_theta_bars_cr, pfc_fs_theta_bars_fa];
s1_rs_theta_bars_mat = [s1_rs_theta_bars_hit, s1_rs_theta_bars_miss, s1_rs_theta_bars_cr, s1_rs_theta_bars_fa];
s1_fs_theta_bars_mat = [s1_fs_theta_bars_hit, s1_fs_theta_bars_miss, s1_fs_theta_bars_cr, s1_fs_theta_bars_fa];
striatum_rs_theta_bars_mat = [striatum_rs_theta_bars_hit, striatum_rs_theta_bars_miss, striatum_rs_theta_bars_cr, striatum_rs_theta_bars_fa];
striatum_fs_theta_bars_mat = [striatum_fs_theta_bars_hit, striatum_fs_theta_bars_miss, striatum_fs_theta_bars_cr, striatum_fs_theta_bars_fa];
amygdala_rs_theta_bars_mat = [amygdala_rs_theta_bars_hit, amygdala_rs_theta_bars_miss, amygdala_rs_theta_bars_cr, amygdala_rs_theta_bars_fa];
amygdala_fs_theta_bars_mat = [amygdala_fs_theta_bars_hit, amygdala_fs_theta_bars_miss, amygdala_fs_theta_bars_cr, amygdala_fs_theta_bars_fa];

fprintf('S1 RS theta bar ANOVA:\n')
anova1(s1_rs_theta_bars_mat)
fprintf('S1 FS theta bar ANOVA:\n')
anova1(s1_fs_theta_bars_mat)
fprintf('PFC RS theta bar ANOVA:\n')
anova1(pfc_rs_theta_bars_mat)
fprintf('PFC FS theta bar ANOVA:\n')
anova1(pfc_fs_theta_bars_mat)
fprintf('Striatum RS theta bar ANOVA:\n')
anova1(striatum_rs_theta_bars_mat)
fprintf('Striatum FS theta bar ANOVA:\n')
anova1(striatum_fs_theta_bars_mat)
fprintf('Amygdala RS theta bar ANOVA:\n')
anova1(amygdala_rs_theta_bars_mat)
fprintf('Amygdala FS theta bar ANOVA:\n')
anova1(amygdala_fs_theta_bars_mat)

pfc_rs_cognitive = [pfc_rs_justCorrect', pfc_rs_justIncorrect', pfc_rs_correctIncorrect'];
pfc_rs_motor = [pfc_rs_justAction', pfc_rs_justInaction', pfc_rs_actionInaction'];
pfc_fs_cognitive = [pfc_fs_justCorrect', pfc_fs_justIncorrect', pfc_fs_correctIncorrect'];
pfc_fs_motor = [pfc_fs_justAction', pfc_fs_justInaction', pfc_fs_actionInaction'];
s1_rs_cognitive = [s1_rs_justCorrect', s1_rs_justIncorrect', s1_rs_correctIncorrect'];
s1_rs_motor = [s1_rs_justAction', s1_rs_justInaction', s1_rs_actionInaction'];
s1_fs_cognitive = [s1_fs_justCorrect', s1_fs_justIncorrect', s1_fs_correctIncorrect'];
s1_fs_motor = [s1_fs_justAction', s1_fs_justInaction', s1_fs_actionInaction'];
striatum_rs_cognitive = [striatum_rs_justCorrect', striatum_rs_justIncorrect', striatum_rs_correctIncorrect'];
striatum_rs_motor = [striatum_rs_justAction', striatum_rs_justInaction', striatum_rs_actionInaction'];
striatum_fs_cognitive = [striatum_fs_justCorrect', striatum_fs_justIncorrect', striatum_fs_correctIncorrect'];
striatum_fs_motor = [striatum_fs_justAction', striatum_fs_justInaction', striatum_fs_actionInaction'];
amygdala_rs_cognitive = [amygdala_rs_justCorrect', amygdala_rs_justIncorrect', amygdala_rs_correctIncorrect'];
amygdala_rs_motor = [amygdala_rs_justAction', amygdala_rs_justInaction', amygdala_rs_actionInaction'];
amygdala_fs_cognitive = [amygdala_fs_justCorrect', amygdala_fs_justIncorrect', amygdala_fs_correctIncorrect'];
amygdala_fs_motor = [amygdala_fs_justAction', amygdala_fs_justInaction', amygdala_fs_actionInaction'];

fprintf('PFC RS cognitive anova:\n')
anova1(pfc_rs_cognitive)
fprintf('PFC RS motor anova:\n')
anova1(pfc_rs_motor)
fprintf('PFC FS cognitive anova:\n')
anova1(pfc_fs_cognitive)
fprintf('PFC FS motor anova:\n')
anova1(pfc_fs_motor)
fprintf('S1 RS cognitive anova:\n')
anova1(s1_rs_cognitive)
fprintf('S1 RS motor anova:\n')
anova1(s1_rs_motor)
fprintf('S1 FS cognitive anova:\n')
anova1(s1_fs_cognitive)
fprintf('S1 FS motor anova:\n')
anova1(s1_fs_motor)
fprintf('Striatum RS cognitive anova:\n')
anova1(striatum_rs_cognitive)
fprintf('Striatum RS motor anova:\n')
anova1(striatum_rs_motor)
fprintf('Striatum FS cognitive anova:\n')
anova1(striatum_fs_cognitive)
fprintf('Striatum FS motor anova:\n')
anova1(striatum_fs_motor)
fprintf('Amygdala RS cognitive anova:\n')
anova1(amygdala_rs_cognitive)
fprintf('Amygdala RS motor anova:\n')
anova1(amygdala_rs_motor)
fprintf('Amygdala FS cognitive anova:\n')
anova1(amygdala_fs_cognitive)
fprintf('Amygdala FS motor anova:\n')
anova1(amygdala_fs_motor)