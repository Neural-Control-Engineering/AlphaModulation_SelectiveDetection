addpath(genpath('./'))
addpath(genpath('~/circstat-matlab/'))
s1 = load('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Combo/Cortex/Spontaneous_Alpha_Modulation_v2/data.mat');
pfc = load('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/PFC_Expert_Combo/PFC/Spontaneous_Alpha_Modulation_v2/data.mat');
striatum = load('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Combo/Basal_Ganglia/Spontaneous_Alpha_Modulation_v2/data.mat');

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

pfc_rs = pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.waveform_class,'RS'),:);
pfc_fs = pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.waveform_class,'FS'),:);
s1_rs = s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.waveform_class,'RS'),:);
s1_fs = s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.waveform_class,'FS'),:);
striatum_rs = striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.waveform_class,'RS'),:);
striatum_fs = striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.waveform_class,'FS'),:);

fracs_fig = figure('Position', [1775 810 1089 1081]);
tl = tiledlayout(3,3, 'TileSpacing', 'tight');
axs = zeros(3,3);
axs(1,1) = nexttile;
hold on 
bar(1:2, [mean(s1_rs_fracs), mean(s1_fs_fracs)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:2, [mean(s1_rs_fracs), mean(s1_fs_fracs)], ... 
    [std(s1_rs_fracs)/sqrt(length((s1_rs_fracs))), std(s1_fs_fracs)/sqrt(length((s1_fs_fracs)))], 'k.')
ylim([0,1])
yticks([0,0.5,1])
ylabel('Fraction of Alpha Modulated Neurons')
xticks(1:2)
xticklabels({'RS', 'FS'})
axs(1,2) = nexttile;
polarhistogram(s1_rs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
thetaticks([0 90 180 270])
rlim([0,25])
hold on 
polarplot([circ_mean(s1_rs.theta_bars), circ_mean(s1_rs.theta_bars)], [0,25], 'r--', 'LineWidth', 2)
title({'Somatosensory Cortex', 'RS'})
axs(1,3) = nexttile;
polarhistogram(s1_fs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
thetaticks([0 90 180 270])
rlim([0,25])
hold on 
polarplot([circ_mean(s1_fs.theta_bars), circ_mean(s1_fs.theta_bars)], [0,25], 'r--', 'LineWidth', 2)
title('FS')
axs(2,1) = nexttile;
hold on
bar(1:2, [mean(pfc_rs_fracs), mean(pfc_fs_fracs)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:2, [mean(pfc_rs_fracs), mean(pfc_fs_fracs)], ... 
    [std(pfc_rs_fracs)/sqrt(length((pfc_rs_fracs))), std(pfc_fs_fracs)/sqrt(length((pfc_fs_fracs)))], 'k.')
ylim([0,1])
yticks([0,0.5,1])
xticklabels({'RS', 'FS'})
ylabel('Fraction of Alpha Modulated Neurons')
xticks(1:2)
xticklabels({'RS', 'FS'})
axs(2,2) = nexttile;
polarhistogram(pfc_rs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
thetaticks([0 90 180 270])
rlim([0,15])
hold on 
polarplot([circ_mean(pfc_rs.theta_bars),circ_mean(pfc_rs.theta_bars)], [0,15], 'r--', 'LineWidth', 2)
title({'Prefrontal Cortex', 'RS'})
axs(2,3) = nexttile;
polarhistogram(pfc_fs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
thetaticks([0 90 180 270])
rlim([0,15])
hold on 
polarplot([circ_mean(pfc_fs.theta_bars),circ_mean(pfc_fs.theta_bars)], [0,15], 'r--', 'LineWidth', 2)
title('FS')
axs(3,1) = nexttile;
hold on
bar(1:2, [mean(striatum_rs_fracs), mean(striatum_fs_fracs)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:2, [mean(striatum_rs_fracs), mean(striatum_fs_fracs)], ... 
    [std(striatum_rs_fracs)/sqrt(length((striatum_rs_fracs))), std(striatum_fs_fracs)/sqrt(length((striatum_fs_fracs)))], 'k.')
ylim([0,1])
yticks([0,0.5,1])
xticklabels({'RS', 'FS'})
ylabel('Fraction of Alpha Modulated Neurons')
xticks(1:2)
xticklabels({'RS', 'FS'})
axs(3,2) = nexttile;
polarhistogram(striatum_rs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
rlim([0,10])
hold on 
polarplot([circ_mean(striatum_rs.theta_bars), circ_mean(striatum_rs.theta_bars)], [0, 10], 'r--', 'LineWidth', 2)
thetaticks([0 90 180 270])
title({'Striatum', 'RS'})
axs(3,3) = nexttile;
polarhistogram(striatum_fs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
thetaticks([0 90 180 270])
rlim([0,10])
hold on
polarplot([circ_mean(striatum_fs.theta_bars), circ_mean(striatum_fs.theta_bars)], [0, 10], 'r--', 'LineWidth', 2)
title('FS')

% figure();
% tl = tiledlayout(1,2);
% axs = zeros(1,2);
% axs(1) = nexttile;
% hold on 
% bar(1:2, [mean(s1_correct_fractions), mean(s1_incorrect_fractions)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
% errorbar(1:2, [mean(s1_correct_fractions), mean(s1_incorrect_fractions)], ...
%     [std(s1_correct_fractions)/sqrt(length((s1_correct_fractions))), std(s1_incorrect_fractions)/sqrt(length((s1_incorrect_fractions)))], 'k.')
% bar(4:5, [mean(pfc_correct_fractions), mean(pfc_incorrect_fractions)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
% errorbar(4:5, [mean(pfc_correct_fractions), mean(pfc_incorrect_fractions)], ...
%     [std(pfc_correct_fractions)/sqrt(length((pfc_correct_fractions))), std(pfc_incorrect_fractions)/sqrt(length((pfc_incorrect_fractions)))], 'k.')
% bar(7:8, [mean(striatum_correct_fractions), mean(striatum_incorrect_fractions)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
% errorbar(7:8, [mean(striatum_correct_fractions), mean(striatum_incorrect_fractions)], ...
%     [std(striatum_correct_fractions)/sqrt(length((striatum_correct_fractions))), std(striatum_incorrect_fractions)/sqrt(length((striatum_incorrect_fractions)))], 'k.')
% xticks([1,2,4,5,7,8])
% xticklabels({'Correct', 'Incorrect', 'Correct', 'Incorrect', 'Correct', 'Incorrect'})
% xtickangle(45)
% axs(2) = nexttile;
% hold on 
% bar(1:2, [mean(s1_action_fractions), mean(s1_inaction_fractions)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
% errorbar(1:2, [mean(s1_action_fractions), mean(s1_inaction_fractions)], ...
%     [std(s1_action_fractions)/sqrt(length((s1_action_fractions))), std(s1_inaction_fractions)/sqrt(length((s1_inaction_fractions)))], 'k.')
% bar(4:5, [mean(pfc_action_fractions), mean(pfc_inaction_fractions)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
% errorbar(4:5, [mean(pfc_action_fractions), mean(pfc_inaction_fractions)], ...
%     [std(pfc_action_fractions)/sqrt(length((pfc_action_fractions))), std(pfc_inaction_fractions)/sqrt(length((pfc_inaction_fractions)))], 'k.')
% bar(7:8, [mean(striatum_action_fractions), mean(striatum_inaction_fractions)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
% errorbar(7:8, [mean(striatum_action_fractions), mean(striatum_inaction_fractions)], ...
%     [std(striatum_action_fractions)/sqrt(length((striatum_action_fractions))), std(striatum_inaction_fractions)/sqrt(length((striatum_inaction_fractions)))], 'k.')
% xticks([1,2,4,5,7,8])
% xticklabels({'Action', 'Inaction', 'Action', 'Inaction', 'Action', 'Inaction'})
% xtickangle(45)

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


mod_by_outcome_fig = figure('Position', [1222 868 869 1035]);
tl = tiledlayout(3,2);
axs = zeros(3,2);
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
xlabel(tl, 'Trial Outcome')
ylabel(tl, 'Fraction of Modulated Neurons')

% figure(); semshade(striatum_mod_rs_hit, 0.3, 'b', 'b', linspace(-2.8,4.8,80), 1); hold on; semshade(striatum_unmod_rs_hit, 0.3, 'r', 'r', linspace(-2.8,4.8,80),1)
% figure(); semshade(striatum_mod_fs_hit, 0.3, 'b', 'b', linspace(-2.8,4.8,80), 1); hold on; semshade(striatum_unmod_fs_hit, 0.3, 'r', 'r', linspace(-2.8,4.8,80),1)

time = linspace(-2.8,4.8,size(striatum_mod_rs_hit,2));
s1_mod_unmod_fr_fig = figure('Position', [1222 868 869 1035]);
tl = tiledlayout(3,2, 'TileSpacing', 'tight');
axs(1,1) = nexttile;
semshade(s1_mod_rs_hit-mean(s1_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_rs_hit-mean(s1_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
axs(1,2) = nexttile;
semshade(s1_mod_fs_hit-mean(s1_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_fs_hit-mean(s1_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-2,15])
legend()
axs(2,1) = nexttile;
semshade(pfc_mod_rs_hit-mean(pfc_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1);
hold on;
semshade(pfc_unmod_rs_hit-mean(pfc_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1);
xlim([-2.8,4.8])
ylim([-1,3])
axs(2,2) = nexttile;
semshade(pfc_mod_fs_hit-mean(pfc_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1);
hold on;
semshade(pfc_unmod_fs_hit-mean(pfc_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1);
xlim([-2.8,4.8])
ylim([-2,15])
axs(3,1) = nexttile;
semshade(striatum_mod_rs_hit-mean(striatum_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1);
hold on;
semshade(striatum_unmod_rs_hit-mean(striatum_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1);
xlim([-2.8,4.8])
ylim([-5,25])
axs(3,2) = nexttile;
semshade(striatum_mod_fs_hit-mean(striatum_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1);
hold on;
semshade(striatum_unmod_fs_hit-mean(striatum_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1);
xlim([-2.8,4.8])
ylim([-2,15])
regions = {'Somatosensory Cortex', 'Prefrontal Corext', 'Striatum'};
for r = 1:3
    axes(axs(r,1))
    ylabel(regions{r}, 'FontSize', 16)
end
for r = 1:2
    for c = 1:2
        xticklabels({})
    end
end
axes(axs(1,1))
title('Regular Spiking Units', 'FontSize', 16, 'FontWeight', 'normal')
axes(axs(1,2))
title('Fast Spiking Units', 'FontSize', 16, 'FontWeight', 'normal')
xlabel(tl, 'Time (s)', 'FontSize', 16)
ylabel(tl, '\Delta Firing Rate (Hz)', 'FontSize', 16)

rs_mod_vs_unmod_fr_fig = figure('Position', [1151 841 1850 1081]) 
tl = tiledlayout(3,4);
axs(1,1) = nexttile;
semshade(s1_mod_rs_hit-mean(s1_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_rs_hit-mean(s1_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
title('Hit', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,2) = nexttile;
semshade(s1_mod_rs_miss-mean(s1_mod_rs_miss(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_rs_miss-mean(s1_unmod_rs_miss(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
title('Miss', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,3) = nexttile;
semshade(s1_mod_rs_cr-mean(s1_mod_rs_cr(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_rs_cr-mean(s1_unmod_rs_cr(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
title('Correct Rejection', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,4) = nexttile;
semshade(s1_mod_rs_fa-mean(s1_mod_rs_fa(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_rs_fa-mean(s1_unmod_rs_fa(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
title('False Alarm', 'FontWeight', 'normal', 'FontSize', 16)
axs(2,1) = nexttile;
semshade(pfc_mod_rs_hit-mean(pfc_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_rs_hit-mean(pfc_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
axs(2,2) = nexttile;
semshade(pfc_mod_rs_miss-mean(pfc_mod_rs_miss(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_rs_miss-mean(pfc_unmod_rs_miss(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
axs(2,3) = nexttile;
semshade(pfc_mod_rs_cr-mean(pfc_mod_rs_cr(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_rs_cr-mean(pfc_unmod_rs_cr(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
axs(2,4) = nexttile;
semshade(pfc_mod_rs_fa-mean(pfc_mod_rs_fa(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_rs_fa-mean(pfc_unmod_rs_fa(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
axs(3,1) = nexttile;
semshade(striatum_mod_rs_hit-mean(striatum_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_rs_hit-mean(striatum_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,25])
axs(3,2) = nexttile;
semshade(striatum_mod_rs_miss-mean(striatum_mod_rs_miss(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_rs_miss-mean(striatum_unmod_rs_miss(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,25])
axs(3,3) = nexttile;
semshade(striatum_mod_rs_cr-mean(striatum_mod_rs_cr(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_rs_cr-mean(striatum_unmod_rs_cr(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,25])
axs(3,4) = nexttile;
semshade(striatum_mod_rs_fa-mean(striatum_mod_rs_fa(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_rs_fa-mean(striatum_unmod_rs_fa(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,25])
xlabel(tl, 'Time (s)', 'FontSize', 16)
ylabel(tl, '\Delta Firing Rate (Hz)', 'FontSize', 16)
outcomes = {'Hit', 'Miss', 'Correct Rejection', 'False Alarm'}
for c = 1:4
    axes(axs(1,c))
    title(outcomes{c}, 'FontWeight', 'normal', 'FontSize', 16)
end
title(tl, 'Regular Spiking Units', 'FontSize', 16, 'FontWeight', 'normal')

fs_mod_vs_unmod_fr_fig = figure('Position', [1151 841 1850 1081]);
tl = tiledlayout(3,4);
axs(1,1) = nexttile;
semshade(s1_mod_fs_hit-mean(s1_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_fs_hit-mean(s1_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
title('Hit', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,2) = nexttile;
semshade(s1_mod_fs_miss-mean(s1_mod_fs_miss(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_fs_miss-mean(s1_unmod_fs_miss(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
title('Miss', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,3) = nexttile;
semshade(s1_mod_fs_cr-mean(s1_mod_fs_cr(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_fs_cr-mean(s1_unmod_fs_cr(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
title('Correct Rejection', 'FontWeight', 'normal', 'FontSize', 16)
axs(1,4) = nexttile;
semshade(s1_mod_fs_fa-mean(s1_mod_fs_fa(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_fs_fa-mean(s1_unmod_fs_fa(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
title('False Alarm', 'FontWeight', 'normal', 'FontSize', 16)
axs(2,1) = nexttile;
semshade(pfc_mod_fs_hit-mean(pfc_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_fs_hit-mean(pfc_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
axs(2,2) = nexttile;
semshade(pfc_mod_fs_miss-mean(pfc_mod_fs_miss(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_fs_miss-mean(pfc_unmod_fs_miss(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
axs(2,3) = nexttile;
semshade(pfc_mod_fs_cr-mean(pfc_mod_fs_cr(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_fs_cr-mean(pfc_unmod_fs_cr(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
axs(2,4) = nexttile;
semshade(pfc_mod_fs_fa-mean(pfc_mod_fs_fa(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_fs_fa-mean(pfc_unmod_fs_fa(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
axs(3,1) = nexttile;
semshade(striatum_mod_fs_hit-mean(striatum_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_fs_hit-mean(striatum_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
axs(3,2) = nexttile;
semshade(striatum_mod_fs_miss-mean(striatum_mod_fs_miss(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_fs_miss-mean(striatum_unmod_fs_miss(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
axs(3,3) = nexttile;
semshade(striatum_mod_fs_cr-mean(striatum_mod_fs_cr(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_fs_cr-mean(striatum_unmod_fs_cr(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
axs(3,4) = nexttile;
semshade(striatum_mod_fs_fa-mean(striatum_mod_fs_fa(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_fs_fa-mean(striatum_unmod_fs_fa(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,15])
xlabel(tl, 'Time (s)', 'FontSize', 16)
ylabel(tl, '\Delta Firing Rate (Hz)', 'FontSize', 16)
outcomes = {'Hit', 'Miss', 'Correct Rejection', 'False Alarm'}
for c = 1:4
    axes(axs(1,c))
    title(outcomes{c}, 'FontWeight', 'normal', 'FontSize', 16)
end
title(tl, 'Fast Spiking Units', 'FontSize', 16, 'FontWeight', 'normal')

Time = time(time > 0)';
% s1_mod_rs_delta = s1_mod_rs_hit-mean(s1_mod_rs_hit(:,time<0),2);
% s1_unmod_rs_delta = s1_unmod_rs_hit-mean(s1_unmod_rs_hit(:,time<0),2);
% s1_mod_rs_delta = s1_mod_rs_delta(:,time > 0);
% s1_unmod_rs_delta = s1_unmod_rs_delta(:,time > 0);
% s1_rs_delta = [s1_mod_rs_delta; s1_unmod_rs_delta];
% s1_rs_subj = vertcat(s1_mod_rs_subj, s1_unmod_rs_subj);
% s1_rs_group = [zeros(size(s1_mod_rs_delta,1),1); ones(size(s1_unmod_rs_delta,1),1)];
% s1_rs_table = table(s1_rs_group, s1_rs_subj, ...
%     s1_rs_delta(:,1), s1_rs_delta(:,2), s1_rs_delta(:,3), s1_rs_delta(:,4), s1_rs_delta(:,5), s1_rs_delta(:,6), s1_rs_delta(:,7), s1_rs_delta(:,8), s1_rs_delta(:,9), s1_rs_delta(:,10), ...
%     s1_rs_delta(:,11), s1_rs_delta(:,12), s1_rs_delta(:,13), s1_rs_delta(:,14), s1_rs_delta(:,15), s1_rs_delta(:,16), s1_rs_delta(:,17), s1_rs_delta(:,18), s1_rs_delta(:,19), s1_rs_delta(:,20), ...
%     s1_rs_delta(:,21), s1_rs_delta(:,22), s1_rs_delta(:,23), s1_rs_delta(:,24), s1_rs_delta(:,25), s1_rs_delta(:,26), s1_rs_delta(:,27), s1_rs_delta(:,28), s1_rs_delta(:,29), s1_rs_delta(:,30), ...
%     s1_rs_delta(:,31), s1_rs_delta(:,32), s1_rs_delta(:,33), s1_rs_delta(:,34), s1_rs_delta(:,35), s1_rs_delta(:,36), s1_rs_delta(:,37), s1_rs_delta(:,38), s1_rs_delta(:,39), s1_rs_delta(:,40), ...
%     s1_rs_delta(:,41), s1_rs_delta(:,42), s1_rs_delta(:,43), s1_rs_delta(:,44), s1_rs_delta(:,45), s1_rs_delta(:,46), s1_rs_delta(:,47), s1_rs_delta(:,48), s1_rs_delta(:,49), s1_rs_delta(:,50), ...
%     'VariableNames', {'group', 'subject', ...
%     't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
%     't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
%     't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
%     't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
%     't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
% s1_rs_rm = fitrm(s1_rs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
% s1_rs_ranova = ranova(s1_rs_rm)

% s1_mod_fs_delta = s1_mod_fs_hit-mean(s1_mod_fs_hit(:,time<0),2);
% s1_unmod_fs_delta = s1_unmod_fs_hit-mean(s1_unmod_fs_hit(:,time<0),2);
% s1_mod_fs_delta = s1_mod_fs_delta(:,time > 0);
% s1_unmod_fs_delta = s1_unmod_fs_delta(:,time > 0);
% s1_fs_delta = [s1_mod_fs_delta; s1_unmod_fs_delta];
% s1_fs_subj = vertcat(s1_mod_fs_subj, s1_unmod_fs_subj);
% s1_fs_group = [zeros(size(s1_mod_fs_delta,1),1); ones(size(s1_unmod_fs_delta,1),1)];
% s1_fs_table = table(s1_fs_group, s1_fs_subj, ...
%     s1_fs_delta(:,1), s1_fs_delta(:,2), s1_fs_delta(:,3), s1_fs_delta(:,4), s1_fs_delta(:,5), s1_fs_delta(:,6), s1_fs_delta(:,7), s1_fs_delta(:,8), s1_fs_delta(:,9), s1_fs_delta(:,10), ...
%     s1_fs_delta(:,11), s1_fs_delta(:,12), s1_fs_delta(:,13), s1_fs_delta(:,14), s1_fs_delta(:,15), s1_fs_delta(:,16), s1_fs_delta(:,17), s1_fs_delta(:,18), s1_fs_delta(:,19), s1_fs_delta(:,20), ...
%     s1_fs_delta(:,21), s1_fs_delta(:,22), s1_fs_delta(:,23), s1_fs_delta(:,24), s1_fs_delta(:,25), s1_fs_delta(:,26), s1_fs_delta(:,27), s1_fs_delta(:,28), s1_fs_delta(:,29), s1_fs_delta(:,30), ...
%     s1_fs_delta(:,31), s1_fs_delta(:,32), s1_fs_delta(:,33), s1_fs_delta(:,34), s1_fs_delta(:,35), s1_fs_delta(:,36), s1_fs_delta(:,37), s1_fs_delta(:,38), s1_fs_delta(:,39), s1_fs_delta(:,40), ...
%     s1_fs_delta(:,41), s1_fs_delta(:,42), s1_fs_delta(:,43), s1_fs_delta(:,44), s1_fs_delta(:,45), s1_fs_delta(:,46), s1_fs_delta(:,47), s1_fs_delta(:,48), s1_fs_delta(:,49), s1_fs_delta(:,50), ...
%     'VariableNames', {'group', 'subject', ...
%     't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
%     't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
%     't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
%     't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
%     't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
% s1_fs_rm = fitrm(s1_fs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
% s1_fs_ranova = ranova(s1_fs_rm)

% pfc_mod_rs_delta = pfc_mod_rs_hit-mean(pfc_mod_rs_hit(:,time<0),2);
% pfc_unmod_rs_delta = pfc_unmod_rs_hit-mean(pfc_unmod_rs_hit(:,time<0),2);
% pfc_mod_rs_delta = pfc_mod_rs_delta(:,time > 0);
% pfc_unmod_rs_delta = pfc_unmod_rs_delta(:,time > 0);
% pfc_rs_delta = [pfc_mod_rs_delta; pfc_unmod_rs_delta];
% pfc_rs_subj = vertcat(pfc_mod_rs_subj, pfc_unmod_rs_subj);
% pfc_rs_group = [zeros(size(pfc_mod_rs_delta,1),1); ones(size(pfc_unmod_rs_delta,1),1)];
% pfc_rs_table = table(pfc_rs_group, pfc_rs_subj, ...
%     pfc_rs_delta(:,1), pfc_rs_delta(:,2), pfc_rs_delta(:,3), pfc_rs_delta(:,4), pfc_rs_delta(:,5), pfc_rs_delta(:,6), pfc_rs_delta(:,7), pfc_rs_delta(:,8), pfc_rs_delta(:,9), pfc_rs_delta(:,10), ...
%     pfc_rs_delta(:,11), pfc_rs_delta(:,12), pfc_rs_delta(:,13), pfc_rs_delta(:,14), pfc_rs_delta(:,15), pfc_rs_delta(:,16), pfc_rs_delta(:,17), pfc_rs_delta(:,18), pfc_rs_delta(:,19), pfc_rs_delta(:,20), ...
%     pfc_rs_delta(:,21), pfc_rs_delta(:,22), pfc_rs_delta(:,23), pfc_rs_delta(:,24), pfc_rs_delta(:,25), pfc_rs_delta(:,26), pfc_rs_delta(:,27), pfc_rs_delta(:,28), pfc_rs_delta(:,29), pfc_rs_delta(:,30), ...
%     pfc_rs_delta(:,31), pfc_rs_delta(:,32), pfc_rs_delta(:,33), pfc_rs_delta(:,34), pfc_rs_delta(:,35), pfc_rs_delta(:,36), pfc_rs_delta(:,37), pfc_rs_delta(:,38), pfc_rs_delta(:,39), pfc_rs_delta(:,40), ...
%     pfc_rs_delta(:,41), pfc_rs_delta(:,42), pfc_rs_delta(:,43), pfc_rs_delta(:,44), pfc_rs_delta(:,45), pfc_rs_delta(:,46), pfc_rs_delta(:,47), pfc_rs_delta(:,48), pfc_rs_delta(:,49), pfc_rs_delta(:,50), ...
%     'VariableNames', {'group', 'subject', ...
%     't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
%     't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
%     't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
%     't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
%     't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
% pfc_rs_rm = fitrm(pfc_rs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
% % pfc_rs_rm = fitrm(pfc_rs_table, 't1-t50 ~ group', 'WithinDesign', Time);
% pfc_rs_ranova = ranova(pfc_rs_rm)

% pfc_mod_fs_delta = pfc_mod_fs_hit-mean(pfc_mod_fs_hit(:,time<0),2);
% pfc_unmod_fs_delta = pfc_unmod_fs_hit-mean(pfc_unmod_fs_hit(:,time<0),2);
% pfc_mod_fs_delta = pfc_mod_fs_delta(:,time > 0);
% pfc_unmod_fs_delta = pfc_unmod_fs_delta(:,time > 0);
% pfc_fs_delta = [pfc_mod_fs_delta; pfc_unmod_fs_delta];
% pfc_fs_subj = vertcat(pfc_mod_fs_subj, pfc_unmod_fs_subj);
% pfc_fs_group = [zeros(size(pfc_mod_fs_delta,1),1); ones(size(pfc_unmod_fs_delta,1),1)];
% pfc_fs_table = table(pfc_fs_group, pfc_fs_subj, ...
%     pfc_fs_delta(:,1), pfc_fs_delta(:,2), pfc_fs_delta(:,3), pfc_fs_delta(:,4), pfc_fs_delta(:,5), pfc_fs_delta(:,6), pfc_fs_delta(:,7), pfc_fs_delta(:,8), pfc_fs_delta(:,9), pfc_fs_delta(:,10), ...
%     pfc_fs_delta(:,11), pfc_fs_delta(:,12), pfc_fs_delta(:,13), pfc_fs_delta(:,14), pfc_fs_delta(:,15), pfc_fs_delta(:,16), pfc_fs_delta(:,17), pfc_fs_delta(:,18), pfc_fs_delta(:,19), pfc_fs_delta(:,20), ...
%     pfc_fs_delta(:,21), pfc_fs_delta(:,22), pfc_fs_delta(:,23), pfc_fs_delta(:,24), pfc_fs_delta(:,25), pfc_fs_delta(:,26), pfc_fs_delta(:,27), pfc_fs_delta(:,28), pfc_fs_delta(:,29), pfc_fs_delta(:,30), ...
%     pfc_fs_delta(:,31), pfc_fs_delta(:,32), pfc_fs_delta(:,33), pfc_fs_delta(:,34), pfc_fs_delta(:,35), pfc_fs_delta(:,36), pfc_fs_delta(:,37), pfc_fs_delta(:,38), pfc_fs_delta(:,39), pfc_fs_delta(:,40), ...
%     pfc_fs_delta(:,41), pfc_fs_delta(:,42), pfc_fs_delta(:,43), pfc_fs_delta(:,44), pfc_fs_delta(:,45), pfc_fs_delta(:,46), pfc_fs_delta(:,47), pfc_fs_delta(:,48), pfc_fs_delta(:,49), pfc_fs_delta(:,50), ...
%     'VariableNames', {'group', 'subject', ...
%     't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
%     't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
%     't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
%     't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
%     't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
% pfc_fs_rm = fitrm(pfc_fs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
% % pfc_fs_rm = fitrm(pfc_fs_table, 't1-t50 ~ group', 'WithinDesign', Time);
% pfc_fs_ranova = ranova(pfc_fs_rm)

% striatum_mod_rs_delta = striatum_mod_rs_hit-mean(striatum_mod_rs_hit(:,time<0),2);
% striatum_unmod_rs_delta = striatum_unmod_rs_hit-mean(striatum_unmod_rs_hit(:,time<0),2);
% striatum_mod_rs_delta = striatum_mod_rs_delta(:,time > 0);
% striatum_unmod_rs_delta = striatum_unmod_rs_delta(:,time > 0);
% striatum_rs_delta = [striatum_mod_rs_delta; striatum_unmod_rs_delta];
% striatum_rs_subj = vertcat(striatum_mod_rs_subj, striatum_unmod_rs_subj);
% striatum_rs_group = [zeros(size(striatum_mod_rs_delta,1),1); ones(size(striatum_unmod_rs_delta,1),1)];
% striatum_rs_table = table(striatum_rs_group, striatum_rs_subj, ...
%     striatum_rs_delta(:,1), striatum_rs_delta(:,2), striatum_rs_delta(:,3), striatum_rs_delta(:,4), striatum_rs_delta(:,5), striatum_rs_delta(:,6), striatum_rs_delta(:,7), striatum_rs_delta(:,8), striatum_rs_delta(:,9), striatum_rs_delta(:,10), ...
%     striatum_rs_delta(:,11), striatum_rs_delta(:,12), striatum_rs_delta(:,13), striatum_rs_delta(:,14), striatum_rs_delta(:,15), striatum_rs_delta(:,16), striatum_rs_delta(:,17), striatum_rs_delta(:,18), striatum_rs_delta(:,19), striatum_rs_delta(:,20), ...
%     striatum_rs_delta(:,21), striatum_rs_delta(:,22), striatum_rs_delta(:,23), striatum_rs_delta(:,24), striatum_rs_delta(:,25), striatum_rs_delta(:,26), striatum_rs_delta(:,27), striatum_rs_delta(:,28), striatum_rs_delta(:,29), striatum_rs_delta(:,30), ...
%     striatum_rs_delta(:,31), striatum_rs_delta(:,32), striatum_rs_delta(:,33), striatum_rs_delta(:,34), striatum_rs_delta(:,35), striatum_rs_delta(:,36), striatum_rs_delta(:,37), striatum_rs_delta(:,38), striatum_rs_delta(:,39), striatum_rs_delta(:,40), ...
%     striatum_rs_delta(:,41), striatum_rs_delta(:,42), striatum_rs_delta(:,43), striatum_rs_delta(:,44), striatum_rs_delta(:,45), striatum_rs_delta(:,46), striatum_rs_delta(:,47), striatum_rs_delta(:,48), striatum_rs_delta(:,49), striatum_rs_delta(:,50), ...
%     'VariableNames', {'group', 'subject', ...
%     't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
%     't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
%     't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
%     't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
%     't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
% striatum_rs_rm = fitrm(striatum_rs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
% striatum_rs_ranova = ranova(striatum_rs_rm)

% striatum_mod_fs_delta = striatum_mod_fs_hit-mean(striatum_mod_fs_hit(:,time<0),2);
% striatum_unmod_fs_delta = striatum_unmod_fs_hit-mean(striatum_unmod_fs_hit(:,time<0),2);
% striatum_mod_fs_delta = striatum_mod_fs_delta(:,time > 0);
% striatum_unmod_fs_delta = striatum_unmod_fs_delta(:,time > 0);
% striatum_fs_delta = [striatum_mod_fs_delta; striatum_unmod_fs_delta];
% striatum_fs_subj = vertcat(striatum_mod_fs_subj, striatum_unmod_fs_subj);
% striatum_fs_group = [zeros(size(striatum_mod_fs_delta,1),1); ones(size(striatum_unmod_fs_delta,1),1)];
% striatum_fs_table = table(striatum_fs_group, striatum_fs_subj, ...
%     striatum_fs_delta(:,1), striatum_fs_delta(:,2), striatum_fs_delta(:,3), striatum_fs_delta(:,4), striatum_fs_delta(:,5), striatum_fs_delta(:,6), striatum_fs_delta(:,7), striatum_fs_delta(:,8), striatum_fs_delta(:,9), striatum_fs_delta(:,10), ...
%     striatum_fs_delta(:,11), striatum_fs_delta(:,12), striatum_fs_delta(:,13), striatum_fs_delta(:,14), striatum_fs_delta(:,15), striatum_fs_delta(:,16), striatum_fs_delta(:,17), striatum_fs_delta(:,18), striatum_fs_delta(:,19), striatum_fs_delta(:,20), ...
%     striatum_fs_delta(:,21), striatum_fs_delta(:,22), striatum_fs_delta(:,23), striatum_fs_delta(:,24), striatum_fs_delta(:,25), striatum_fs_delta(:,26), striatum_fs_delta(:,27), striatum_fs_delta(:,28), striatum_fs_delta(:,29), striatum_fs_delta(:,30), ...
%     striatum_fs_delta(:,31), striatum_fs_delta(:,32), striatum_fs_delta(:,33), striatum_fs_delta(:,34), striatum_fs_delta(:,35), striatum_fs_delta(:,36), striatum_fs_delta(:,37), striatum_fs_delta(:,38), striatum_fs_delta(:,39), striatum_fs_delta(:,40), ...
%     striatum_fs_delta(:,41), striatum_fs_delta(:,42), striatum_fs_delta(:,43), striatum_fs_delta(:,44), striatum_fs_delta(:,45), striatum_fs_delta(:,46), striatum_fs_delta(:,47), striatum_fs_delta(:,48), striatum_fs_delta(:,49), striatum_fs_delta(:,50), ...
%     'VariableNames', {'group', 'subject', ...
%     't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
%     't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
%     't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
%     't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
%     't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
% striatum_fs_rm = fitrm(striatum_fs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
% striatum_fs_ranova = ranova(striatum_fs_rm)

pfc_rs = pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.waveform_class,'RS'),:);
pfc_fs = pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.waveform_class,'FS'),:);
s1_rs = s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.waveform_class,'RS'),:);
s1_fs = s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.waveform_class,'FS'),:);
striatum_rs = striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.waveform_class,'RS'),:);
striatum_fs = striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.waveform_class,'FS'),:);

%% parts for overview figure 
% fig = figure('Position', [1151 841 1850 1081]);
% fig = figure('Position', [1267 846 852 1074]);
s1_mod_fig = figure('Position', [1220 1269 1071 569]);
tl = tiledlayout(2,3, 'TileSpacing', 'compact');
% tl = tiledlayout(6,3, 'TileSpacing', 'compact');
axs(1) = nexttile([2,1]);
hold on 
bar(1:2, [mean(s1_rs_fracs), mean(s1_fs_fracs)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:2, [mean(s1_rs_fracs), mean(s1_fs_fracs)], ... 
    [std(s1_rs_fracs)/sqrt(length((s1_rs_fracs))), std(s1_fs_fracs)/sqrt(length((s1_fs_fracs)))], 'k.')
ylim([0,1])
yticks([0,0.5,1])
xticks(1:2)
xticklabels({'RS', 'FS'})
ylabel('Fraction of Alpha Modulated Units')

axs(2) = nexttile;
polarhistogram(s1_rs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
thetaticks([0 90 180 270])
rlim([0,25])
hold on 
polarplot([circ_mean(s1_rs.theta_bars), circ_mean(s1_rs.theta_bars)], [0,25], 'r--', 'LineWidth', 2)
title({'Regular Spiking'}, 'FontWeight', 'normal')

axs(3) = nexttile;
polarhistogram(s1_fs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
thetaticks([0 90 180 270])
rlim([0,25])
hold on 
polarplot([circ_mean(s1_fs.theta_bars), circ_mean(s1_fs.theta_bars)], [0,25], 'r--', 'LineWidth', 2)
title({'Fast Spiking'}, 'FontWeight', 'normal')

axs(4) = nexttile;
semshade(s1_mod_rs_hit-mean(s1_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_rs_hit-mean(s1_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
ylabel('\Delta Firing Rate (Hz)')
xlabel('Time (s)')

axs(5) = nexttile;
semshade(s1_mod_fs_hit-mean(s1_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(s1_unmod_fs_hit-mean(s1_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-2,15])
ylabel('\Delta Firing Rate (Hz)')
xlabel('Time (s)')
title(tl, 'Somatosensory Cortex')
legend()


pfc_mod_fig = figure('Position', [1220 1269 1071 569]);
tl = tiledlayout(2,3, 'TileSpacing', 'compact');
axs(1) = nexttile([2,1]);
hold on
bar(1:2, [mean(pfc_rs_fracs), mean(pfc_fs_fracs)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:2, [mean(pfc_rs_fracs), mean(pfc_fs_fracs)], ... 
    [std(pfc_rs_fracs)/sqrt(length((pfc_rs_fracs))), std(pfc_fs_fracs)/sqrt(length((pfc_fs_fracs)))], 'k.')
ylim([0,1])
yticks([0,0.5,1])
xticks(1:2)
xticklabels({'RS', 'FS'})
ylabel('Fraction of Alpha Modulated Units')

axs(2) = nexttile;
polarhistogram(pfc_rs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
thetaticks([0 90 180 270])
rlim([0,15])
hold on 
polarplot([circ_mean(pfc_rs.theta_bars),circ_mean(pfc_rs.theta_bars)], [0,15], 'r--', 'LineWidth', 2)
title({'Regular Spiking'}, 'FontWeight', 'normal')

axs(3) = nexttile;
polarhistogram(pfc_fs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
thetaticks([0 90 180 270])
rlim([0,15])
hold on 
polarplot([circ_mean(pfc_fs.theta_bars),circ_mean(pfc_fs.theta_bars)], [0,15], 'r--', 'LineWidth', 2)
title({'Fast Spiking'}, 'FontWeight', 'normal')

axs(4) = nexttile;
semshade(pfc_mod_rs_hit-mean(pfc_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_rs_hit-mean(pfc_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-1,3])
ylabel('\Delta Firing Rate (Hz)')
xlabel('Time (s)')

axs(5) = nexttile;
semshade(pfc_mod_fs_hit-mean(pfc_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(pfc_unmod_fs_hit-mean(pfc_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-2,15])
ylabel('\Delta Firing Rate (Hz)')
xlabel('Time (s)')
legend()
title(tl, 'Prefrontal Cortex')

striatum_mod_fig = figure('Position', [1220 1269 1071 569]);
tl = tiledlayout(2,3, 'TileSpacing', 'compact');
axs(1) = nexttile([2,1]);
hold on
bar(1:2, [mean(striatum_rs_fracs), mean(striatum_fs_fracs)], 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
errorbar(1:2, [mean(striatum_rs_fracs), mean(striatum_fs_fracs)], ... 
    [std(striatum_rs_fracs)/sqrt(length((striatum_rs_fracs))), std(striatum_fs_fracs)/sqrt(length((striatum_fs_fracs)))], 'k.')
ylim([0,1])
yticks([0,0.5,1])
xticks(1:2)
xticklabels({'RS', 'FS'})
ylabel('Fraction of Alpha Modulated Units')

axs(2) = nexttile;
polarhistogram(striatum_rs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
rlim([0,10])
hold on 
polarplot([circ_mean(striatum_rs.theta_bars), circ_mean(striatum_rs.theta_bars)], [0, 10], 'r--', 'LineWidth', 2)
thetaticks([0 90 180 270])
% title({'Somatosensory Cortex', 'Regular Spiking'}, 'FontWeight', 'normal')
title({'Regular Spiking'}, 'FontWeight', 'normal')

axs(3) = nexttile;
polarhistogram(striatum_fs.theta_bars, 36, 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
rlim([0,10])
hold on
polarplot([circ_mean(striatum_fs.theta_bars), circ_mean(striatum_fs.theta_bars)], [0, 10], 'r--', 'LineWidth', 2)
thetaticks([0 90 180 270])
title({'Fast Spiking'}, 'FontWeight', 'normal')

axs(4) = nexttile;
semshade(striatum_mod_rs_hit-mean(striatum_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_rs_hit-mean(striatum_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-5,25])
ylabel('\Delta Firing Rate (Hz)')
xlabel('Time (s)')

axs(5) = nexttile;
semshade(striatum_mod_fs_hit-mean(striatum_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time, 1, 'Phase Modulated');
hold on;
semshade(striatum_unmod_fs_hit-mean(striatum_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time, 1, 'Unmodulated');
xlim([-2.8,4.8])
ylim([-2,15])
ylabel('\Delta Firing Rate (Hz)')
xlabel('Time (s)')
title(tl, 'Striatum')
legend()

s1_rs_correct_mat = [s1_rs_justCorrect', s1_rs_justIncorrect', s1_rs_correctIncorrect'];
s1_fs_correct_mat = [s1_fs_justCorrect', s1_fs_justIncorrect', s1_fs_correctIncorrect'];
pfc_rs_correct_mat = [pfc_rs_justCorrect', pfc_rs_justIncorrect', pfc_rs_correctIncorrect'];
pfc_fs_correct_mat = [pfc_fs_justCorrect', pfc_fs_justIncorrect', pfc_fs_correctIncorrect'];
striatum_rs_correct_mat = [striatum_rs_justCorrect', striatum_rs_justIncorrect', striatum_rs_correctIncorrect'];
striatum_fs_correct_mat = [striatum_fs_justCorrect', striatum_fs_justIncorrect', striatum_fs_correctIncorrect'];

s1_rs_action_mat = [s1_rs_justAction', s1_rs_justInaction', s1_rs_actionInaction'];
s1_fs_action_mat = [s1_fs_justAction', s1_fs_justInaction', s1_fs_actionInaction'];
pfc_rs_action_mat = [pfc_rs_justAction', pfc_rs_justInaction', pfc_rs_actionInaction'];
pfc_fs_action_mat = [pfc_fs_justAction', pfc_fs_justInaction', pfc_fs_actionInaction'];
striatum_rs_action_mat = [striatum_rs_justAction', striatum_rs_justInaction', striatum_rs_actionInaction'];
striatum_fs_action_mat = [striatum_fs_justAction', striatum_fs_justInaction', striatum_fs_actionInaction'];

% % mi 
% s1_rs_mod_mi = zeros(size(s1_rs,1),1);
% s1_rs_unmod_mi = zeros(size(S1_rs,1),1);

% for c = 1:size(s1_rs,1)
%     phases = s1_rs(c,:).spon_alpha_spike_phases{1};
%     [avg_amp, edges] = histcounts(phases, 20);
%     % avg_amp = avg_amp / mean(avg_amp);
%     %calculate entropy measure H
%     p = zeros(1,length(avg_amp));
%     for k = 1:length(p)
%         p(k) = avg_amp(k) / sum(avg_amp);
%     end
%     H = 0;
%     for k = 1:length(p)
%         H = H + p(k)*log(p(k));
%     end
%     s1_rs_mod_mi(c) = H * -1;
% end

% for c = 1:size(S1_rs,1)
%     phases = S1_rs(c,:).spon_alpha_spike_phases{1};
%     [avg_amp, edges] = histcounts(phases, 20);
%     % avg_amp = avg_amp / mean(avg_amp);
%     %calculate entropy measure H
%     p = zeros(1,length(avg_amp));
%     for k = 1:length(p)
%         p(k) = avg_amp(k) / sum(avg_amp);
%     end
%     H = 0;
%     for k = 1:length(p)
%         H = H + p(k)*log(p(k));
%     end
%     s1_rs_unmod_mi(c) = H * -1;
% end

saveas(striatum_mod_fig, 'tmp/striatum_mod_fig.png')
saveas(pfc_mod_fig, 'tmp/pfc_mod_fig.png')
saveas(s1_mod_fig, 'tmp/s1_mod_fig.png')
saveas(fs_mod_vs_unmod_fr_fig, 'tmp/fs_mod_vs_unmod_fr_fig.png')
saveas(rs_mod_vs_unmod_fr_fig, 'tmp/rs_mod_vs_unmod_fr_fig.png')
saveas(mod_by_outcome_fig, 'tmp/mod_by_outcome_fig.png')
saveas(fracs_fig, 'tmp/fracs_fig.png')
