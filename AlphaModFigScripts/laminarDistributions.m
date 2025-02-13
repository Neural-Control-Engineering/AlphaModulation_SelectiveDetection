out_path = false;
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

s1_sessions = unique(S1.session_id);
s1_l1_rs_frac = zeros(1,length(s1_sessions));
s1_l2_rs_frac = zeros(1,length(s1_sessions));
s1_l4_rs_frac = zeros(1,length(s1_sessions));
s1_l5_rs_frac = zeros(1,length(s1_sessions));
s1_l6_rs_frac = zeros(1,length(s1_sessions));
s1_l1_fs_frac = zeros(1,length(s1_sessions));
s1_l2_fs_frac = zeros(1,length(s1_sessions));
s1_l4_fs_frac = zeros(1,length(s1_sessions));
s1_l5_fs_frac = zeros(1,length(s1_sessions));
s1_l6_fs_frac = zeros(1,length(s1_sessions));
for s = 1:length(s1_sessions)
    session_id = s1_sessions{s};
    tmp = s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.session_id, session_id),:);
    tmp_all = S1(strcmp(S1.session_id, session_id),:);
    tmp_rs = tmp(strcmp(tmp.waveform_class, 'RS'),:);
    tmp_fs = tmp(strcmp(tmp.waveform_class, 'FS'),:);
    tmp_all_rs = tmp_all(strcmp(tmp_all.waveform_class, 'RS'),:);
    tmp_all_fs = tmp_all(strcmp(tmp_all.waveform_class, 'FS'),:);
    s1_l1_rs_frac(s) = sum(contains(tmp_rs.region, '1')) / sum(contains(tmp_all_rs.region, '1'));
    s1_l2_rs_frac(s) = sum(contains(tmp_rs.region, '2')) / sum(contains(tmp_all_rs.region, '2'));
    s1_l4_rs_frac(s) = sum(contains(tmp_rs.region, '4')) / sum(contains(tmp_all_rs.region, '4'));
    s1_l5_rs_frac(s) = sum(contains(tmp_rs.region, '5')) / sum(contains(tmp_all_rs.region, '5'));
    s1_l6_rs_frac(s) = sum(contains(tmp_rs.region, '6')) / sum(contains(tmp_all_rs.region, '6'));
    s1_l1_fs_frac(s) = sum(contains(tmp_fs.region, '1')) / sum(contains(tmp_all_fs.region, '1'));
    s1_l2_fs_frac(s) = sum(contains(tmp_fs.region, '2')) / sum(contains(tmp_all_fs.region, '2'));
    s1_l4_fs_frac(s) = sum(contains(tmp_fs.region, '4')) / sum(contains(tmp_all_fs.region, '4'));
    s1_l5_fs_frac(s) = sum(contains(tmp_fs.region, '5')) / sum(contains(tmp_all_fs.region, '5'));
    s1_l6_fs_frac(s) = sum(contains(tmp_fs.region, '6')) / sum(contains(tmp_all_fs.region, '6'));
end

tmp = s1.out.alpha_modulated;
tmp_rs = tmp(strcmp(tmp.waveform_class, 'RS'),:);
tmp_rs1 = tmp_rs(contains(tmp_rs.region, '1'),:);
s1_l1_rs_mi = tmp_rs1.pmi;
s1_l1_rs_mse = tmp_rs1.mses;
s1_l1_rs_theta_bar = tmp_rs1.theta_bars;
tmp_rs2 = tmp_rs(contains(tmp_rs.region, '2'),:);
s1_l2_rs_mi = tmp_rs2.pmi;
s1_l2_rs_mse = tmp_rs2.mses;
s1_l2_rs_theta_bar = tmp_rs2.theta_bars;
tmp_rs4 = tmp_rs(contains(tmp_rs.region, '4'),:);
s1_l4_rs_mi = tmp_rs4.pmi;
s1_l4_rs_mse = tmp_rs4.mses;
s1_l4_rs_theta_bar = tmp_rs4.theta_bars;
tmp_rs5 = tmp_rs(contains(tmp_rs.region, '5'),:);
s1_l5_rs_mi = tmp_rs5.pmi;
s1_l5_rs_mse = tmp_rs5.mses;
s1_l5_rs_theta_bar = tmp_rs5.theta_bars;
tmp_rs6 = tmp_rs(contains(tmp_rs.region, '6'),:);
s1_l6_rs_mi = tmp_rs6.pmi;
s1_l6_rs_mse = tmp_rs6.mses;
s1_l6_rs_theta_bar = tmp_rs6.theta_bars;
tmp_fs = tmp(strcmp(tmp.waveform_class, 'FS'),:);
tmp_fs1 = tmp_fs(contains(tmp_fs.region, '1'),:);
s1_l1_fs_mi = tmp_fs1.pmi;
s1_l1_fs_mse = tmp_fs1.mses;
s1_l1_fs_theta_bar = tmp_fs1.theta_bars;
tmp_fs2 = tmp_fs(contains(tmp_fs.region, '2'),:);
s1_l2_fs_mi = tmp_fs2.pmi;
s1_l2_fs_mse = tmp_fs2.mses;
s1_l2_fs_theta_bar = tmp_fs2.theta_bars;
tmp_fs4 = tmp_fs(contains(tmp_fs.region, '4'),:);
s1_l4_fs_mi = tmp_fs4.pmi;
s1_l4_fs_mse = tmp_fs4.mses;
s1_l4_fs_theta_bar = tmp_fs4.theta_bars;
tmp_fs5 = tmp_fs(contains(tmp_fs.region, '5'),:);
s1_l5_fs_mi = tmp_fs5.pmi;
s1_l5_fs_mse = tmp_fs5.mses;
s1_l5_fs_theta_bar = tmp_fs5.theta_bars;
tmp_fs6 = tmp_fs(contains(tmp_fs.region, '6'),:);
s1_l6_fs_mi = tmp_fs6.pmi;
s1_l6_fs_mse = tmp_fs6.mses;
s1_l6_fs_theta_bar = tmp_fs6.theta_bars;

l1_mod_rs_hit = [];
l1_mod_fs_hit = [];
l1_unmod_rs_hit = [];
l1_unmod_fs_hit = [];
l1_mod_rs_miss = [];
l1_mod_fs_miss = [];
l1_unmod_rs_miss = [];
l1_unmod_fs_miss = [];
l1_mod_rs_cr = [];
l1_mod_fs_cr = [];
l1_unmod_rs_cr = [];
l1_unmod_fs_cr = [];
l1_mod_rs_fa = [];
l1_mod_fs_fa = [];
l1_unmod_rs_fa = [];
l1_unmod_fs_fa = [];
l1_mod_rs_subj = {};
l1_mod_fs_subj = {};
l1_unmod_rs_subj = {};
l1_unmod_fs_subj = {};
l2_mod_rs_hit = [];
l2_mod_fs_hit = [];
l2_unmod_rs_hit = [];
l2_unmod_fs_hit = [];
l2_mod_rs_miss = [];
l2_mod_fs_miss = [];
l2_unmod_rs_miss = [];
l2_unmod_fs_miss = [];
l2_mod_rs_cr = [];
l2_mod_fs_cr = [];
l2_unmod_rs_cr = [];
l2_unmod_fs_cr = [];
l2_mod_rs_fa = [];
l2_mod_fs_fa = [];
l2_unmod_rs_fa = [];
l2_unmod_fs_fa = [];
l2_mod_rs_subj = {};
l2_mod_fs_subj = {};
l2_unmod_rs_subj = {};
l2_unmod_fs_subj = {};
l4_mod_rs_hit = [];
l4_mod_fs_hit = [];
l4_unmod_rs_hit = [];
l4_unmod_fs_hit = [];
l4_mod_rs_miss = [];
l4_mod_fs_miss = [];
l4_unmod_rs_miss = [];
l4_unmod_fs_miss = [];
l4_mod_rs_cr = [];
l4_mod_fs_cr = [];
l4_unmod_rs_cr = [];
l4_unmod_fs_cr = [];
l4_mod_rs_fa = [];
l4_mod_fs_fa = [];
l4_unmod_rs_fa = [];
l4_unmod_fs_fa = [];
l4_mod_rs_subj = {};
l4_mod_fs_subj = {};
l4_unmod_rs_subj = {};
l4_unmod_fs_subj = {};
l5_mod_rs_hit = [];
l5_mod_fs_hit = [];
l5_unmod_rs_hit = [];
l5_unmod_fs_hit = [];
l5_mod_rs_miss = [];
l5_mod_fs_miss = [];
l5_unmod_rs_miss = [];
l5_unmod_fs_miss = [];
l5_mod_rs_cr = [];
l5_mod_fs_cr = [];
l5_unmod_rs_cr = [];
l5_unmod_fs_cr = [];
l5_mod_rs_fa = [];
l5_mod_fs_fa = [];
l5_unmod_rs_fa = [];
l5_unmod_fs_fa = [];
l5_mod_rs_subj = {};
l5_mod_fs_subj = {};
l5_unmod_rs_subj = {};
l5_unmod_fs_subj = {};
l6_mod_rs_hit = [];
l6_mod_fs_hit = [];
l6_unmod_rs_hit = [];
l6_unmod_fs_hit = [];
l6_mod_rs_miss = [];
l6_mod_fs_miss = [];
l6_unmod_rs_miss = [];
l6_unmod_fs_miss = [];
l6_mod_rs_cr = [];
l6_mod_fs_cr = [];
l6_unmod_rs_cr = [];
l6_unmod_fs_cr = [];
l6_mod_rs_fa = [];
l6_mod_fs_fa = [];
l6_unmod_rs_fa = [];
l6_unmod_fs_fa = [];
l6_mod_rs_subj = {};
l6_mod_fs_subj = {};
l6_unmod_rs_subj = {};
l6_unmod_fs_subj = {};
layers = {'1', '2', '4', '5', '6'};

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
    for l = 1:length(layers)
        layer = layers{l};
        tmp_s1_rs = s1_rs(contains(s1_rs.region, layer),:);
        tmp_s1_fs = s1_fs(contains(s1_fs.region, layer),:);
        tmp_S1_rs = S1_rs(contains(S1_rs.region, layer),:);
        tmp_S1_fs = S1_fs(contains(S1_fs.region, layer),:);
        exec_str = sprintf('l%s_mod_rs_hit = [l%s_mod_rs_hit; cell2mat(tmp_s1_rs.left_trigger_aligned_avg_fr_Hit)];',layer,layer);
        eval(exec_str);
        exec_str = sprintf('l%s_mod_rs_miss = [l%s_mod_rs_miss; cell2mat(tmp_s1_rs.left_trigger_aligned_avg_fr_Miss)];',layer,layer);
        eval(exec_str);
        exec_str = sprintf('l%s_mod_rs_cr = [l%s_mod_rs_cr; cell2mat(tmp_s1_rs.right_trigger_aligned_avg_fr_CR)];',layer,layer);
        eval(exec_str);
        exec_str = sprintf('l%s_mod_rs_fa = [l%s_mod_rs_fa; cell2mat(tmp_s1_rs.right_trigger_aligned_avg_fr_FA)];',layer,layer);
        eval(exec_str);
        exec_str = sprintf('l%s_mod_fs_hit = [l%s_mod_fs_hit; cell2mat(tmp_s1_fs.left_trigger_aligned_avg_fr_Hit)];',layer,layer);
        eval(exec_str);
        exec_str = sprintf('l%s_mod_fs_miss = [l%s_mod_fs_miss; cell2mat(tmp_s1_fs.left_trigger_aligned_avg_fr_Miss)];',layer,layer);
        eval(exec_str);
        exec_str = sprintf('l%s_mod_fs_cr = [l%s_mod_fs_cr; cell2mat(tmp_s1_fs.right_trigger_aligned_avg_fr_CR)];',layer,layer);
        eval(exec_str);
        exec_str = sprintf('l%s_mod_fs_fa = [l%s_mod_fs_fa; cell2mat(tmp_s1_fs.right_trigger_aligned_avg_fr_FA)];',layer,layer);
        eval(exec_str);
        exec_str = sprintf('l%s_unmod_rs_hit = [l%s_unmod_rs_hit; cell2mat(tmp_S1_rs.left_trigger_aligned_avg_fr_Hit)];',layer,layer);
        eval(exec_str);
        exec_str = sprintf('l%s_unmod_rs_miss = [l%s_unmod_rs_miss; cell2mat(tmp_S1_rs.left_trigger_aligned_avg_fr_Miss)];',layer,layer);
        eval(exec_str);
        exec_str = sprintf('l%s_unmod_rs_cr = [l%s_unmod_rs_cr; cell2mat(tmp_S1_rs.right_trigger_aligned_avg_fr_CR)];',layer,layer);
        eval(exec_str);
        exec_str = sprintf('l%s_unmod_rs_fa = [l%s_unmod_rs_fa; cell2mat(tmp_S1_rs.right_trigger_aligned_avg_fr_FA)];',layer,layer);
        eval(exec_str);
        exec_str = sprintf('l%s_unmod_fs_hit = [l%s_unmod_fs_hit; cell2mat(tmp_S1_fs.left_trigger_aligned_avg_fr_Hit)];',layer,layer);
        eval(exec_str);
        exec_str = sprintf('l%s_unmod_fs_miss = [l%s_unmod_fs_miss; cell2mat(tmp_S1_fs.left_trigger_aligned_avg_fr_Miss)];',layer,layer);
        eval(exec_str);
        exec_str = sprintf('l%s_unmod_fs_cr = [l%s_unmod_fs_cr; cell2mat(tmp_S1_fs.right_trigger_aligned_avg_fr_CR)];',layer,layer);
        eval(exec_str);
        exec_str = sprintf('l%s_unmod_fs_fa = [l%s_unmod_fs_fa; cell2mat(tmp_S1_fs.right_trigger_aligned_avg_fr_FA)];',layer,layer);
        eval(exec_str);

        for id = 1:length(tmp_s1_rs.session_id)
            sesh = tmp_s1_rs.session_id{id};
            parts = strsplit(sesh, '_');
            part = parts{2};
            parts = strsplit(part, '-');
            subj = parts{2};
            exec_str = sprintf('l%s_mod_rs_subj = vertcat(l%s_mod_rs_subj, subj);',layer,layer);
            eval(exec_str)
        end

        for id = 1:length(tmp_s1_fs.session_id)
            sesh = tmp_s1_fs.session_id{id};
            parts = strsplit(sesh, '_');
            part = parts{2};
            parts = strsplit(part, '-');
            subj = parts{2};
            exec_str = sprintf('l%s_mod_fs_subj = vertcat(l%s_mod_fs_subj, subj);',layer,layer);
            eval(exec_str)
        end

        for id = 1:length(tmp_S1_rs.session_id)
            sesh = tmp_S1_rs.session_id{id};
            parts = strsplit(sesh, '_');
            part = parts{2};
            parts = strsplit(part, '-');
            subj = parts{2};
            exec_str = sprintf('l%s_unmod_rs_subj = vertcat(l%s_unmod_rs_subj, subj);',layer,layer);
            eval(exec_str)
        end

        for id = 1:length(tmp_S1_fs.session_id)
            sesh = tmp_S1_fs.session_id{id};
            parts = strsplit(sesh, '_');
            part = parts{2};
            parts = strsplit(part, '-');
            subj = parts{2};
            exec_str = sprintf('l%s_unmod_fs_subj = vertcat(l%s_unmod_fs_subj, subj);',layer,layer);
            eval(exec_str)
        end
    end
end

s1_fr_fig = figure('Position', [1452 766 849 1011]);
tl = tiledlayout(5,2);
axs = zeros(5,2);
time = linspace(-2.8,4.8,size(l4_mod_rs_hit,2));
labels = {'L1', 'L2/3', 'L4', 'L5', 'L6'};
for l = 1:length(layers)
    layer = layers{l};
    axs(l,1) = nexttile;
    hold on 
    exec_str = sprintf("semshade(l%s_mod_rs_hit-mean(l%s_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time);", layer, layer);
    try
        eval(exec_str)
    end
    exec_str = sprintf("semshade(l%s_unmod_rs_hit-mean(l%s_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time);", layer, layer);
    try 
        eval(exec_str)
    end
    ylim([-5,10])
    xlim([-1,5])
    if l == 1
        title('Regular Spiking', 'FontSize', 18, 'FontWeight', 'normal')
    end
    ylabel(labels{l}, 'FontSize', 14)
    axs(l,2) = nexttile;
    hold on
    exec_str = sprintf("semshade(l%s_mod_fs_hit-mean(l%s_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time);", layer, layer);
    try
        eval(exec_str)
    catch
        exec_str = sprintf("plot(time, l%s_mod_fs_hit-mean(l%s_mod_fs_hit(time<0)), 'b')", layer);
        try 
            eval(exec_str)
        end
    end
    exec_str = sprintf("semshade(l%s_unmod_fs_hit-mean(l%s_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time);", layer, layer);
    try
        eval(exec_str)
    catch
        exec_str = sprintf("plot(time, l%s_unmod_fs_hit-mean(l%s_unmod_fs_hit(time<0)), 'r')", layer, layer);
        try 
            eval(exec_str)
        end
    end
    ylim([-10,20])
    xlim([-1,5])
    if l == 1
        title('Fast Spiking', 'FontSize', 18, 'FontWeight', 'normal')
    end
end 
ylabel(tl, '\Delta Firing Rate (Hz)', 'FontSize', 16)
xlabel(tl, 'Time (s)', 'FontSize', 16)
% saveas(s1_fr_fig, 'tmp/layer_fr.png')
if out_path
    saveas(s1_fr_fig, 'Figures/layer_fr.svg')
    saveas(s1_fr_fig, 'Figures/layer_fr.fig')
end
Time = time(time > 0)';

l1_mod_rs_delta = l1_mod_rs_hit-mean(l1_mod_rs_hit(:,time<0),2);
l1_unmod_rs_delta = l1_unmod_rs_hit-mean(l1_unmod_rs_hit(:,time<0),2);
l1_mod_rs_delta = l1_mod_rs_delta(:,time > 0);
l1_unmod_rs_delta = l1_unmod_rs_delta(:,time > 0);
l1_rs_delta = [l1_mod_rs_delta; l1_unmod_rs_delta];
l1_rs_subj = vertcat(l1_mod_rs_subj, l1_unmod_rs_subj);
l1_rs_group = [zeros(size(l1_mod_rs_delta,1),1); ones(size(l1_unmod_rs_delta,1),1)];
l1_rs_table = table(l1_rs_group, l1_rs_subj, ...
    l1_rs_delta(:,1), l1_rs_delta(:,2), l1_rs_delta(:,3), l1_rs_delta(:,4), l1_rs_delta(:,5), l1_rs_delta(:,6), l1_rs_delta(:,7), l1_rs_delta(:,8), l1_rs_delta(:,9), l1_rs_delta(:,10), ...
    l1_rs_delta(:,11), l1_rs_delta(:,12), l1_rs_delta(:,13), l1_rs_delta(:,14), l1_rs_delta(:,15), l1_rs_delta(:,16), l1_rs_delta(:,17), l1_rs_delta(:,18), l1_rs_delta(:,19), l1_rs_delta(:,20), ...
    l1_rs_delta(:,21), l1_rs_delta(:,22), l1_rs_delta(:,23), l1_rs_delta(:,24), l1_rs_delta(:,25), l1_rs_delta(:,26), l1_rs_delta(:,27), l1_rs_delta(:,28), l1_rs_delta(:,29), l1_rs_delta(:,30), ...
    l1_rs_delta(:,31), l1_rs_delta(:,32), l1_rs_delta(:,33), l1_rs_delta(:,34), l1_rs_delta(:,35), l1_rs_delta(:,36), l1_rs_delta(:,37), l1_rs_delta(:,38), l1_rs_delta(:,39), l1_rs_delta(:,40), ...
    l1_rs_delta(:,41), l1_rs_delta(:,42), l1_rs_delta(:,43), l1_rs_delta(:,44), l1_rs_delta(:,45), l1_rs_delta(:,46), l1_rs_delta(:,47), l1_rs_delta(:,48), l1_rs_delta(:,49), l1_rs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
l1_rs_rm = fitrm(l1_rs_table, 't1-t50 ~ group', 'WithinDesign', Time);
fprintf('L1 RS ANOVA:\n')
l1_rs_ranova = ranova(l1_rs_rm)

l2_mod_rs_delta = l2_mod_rs_hit-mean(l2_mod_rs_hit(:,time<0),2);
l2_unmod_rs_delta = l2_unmod_rs_hit-mean(l2_unmod_rs_hit(:,time<0),2);
l2_mod_rs_delta = l2_mod_rs_delta(:,time > 0);
l2_unmod_rs_delta = l2_unmod_rs_delta(:,time > 0);
l2_rs_delta = [l2_mod_rs_delta; l2_unmod_rs_delta];
l2_rs_subj = vertcat(l2_mod_rs_subj, l2_unmod_rs_subj);
l2_rs_group = [zeros(size(l2_mod_rs_delta,1),1); ones(size(l2_unmod_rs_delta,1),1)];
l2_rs_table = table(l2_rs_group, l2_rs_subj, ...
    l2_rs_delta(:,1), l2_rs_delta(:,2), l2_rs_delta(:,3), l2_rs_delta(:,4), l2_rs_delta(:,5), l2_rs_delta(:,6), l2_rs_delta(:,7), l2_rs_delta(:,8), l2_rs_delta(:,9), l2_rs_delta(:,10), ...
    l2_rs_delta(:,11), l2_rs_delta(:,12), l2_rs_delta(:,13), l2_rs_delta(:,14), l2_rs_delta(:,15), l2_rs_delta(:,16), l2_rs_delta(:,17), l2_rs_delta(:,18), l2_rs_delta(:,19), l2_rs_delta(:,20), ...
    l2_rs_delta(:,21), l2_rs_delta(:,22), l2_rs_delta(:,23), l2_rs_delta(:,24), l2_rs_delta(:,25), l2_rs_delta(:,26), l2_rs_delta(:,27), l2_rs_delta(:,28), l2_rs_delta(:,29), l2_rs_delta(:,30), ...
    l2_rs_delta(:,31), l2_rs_delta(:,32), l2_rs_delta(:,33), l2_rs_delta(:,34), l2_rs_delta(:,35), l2_rs_delta(:,36), l2_rs_delta(:,37), l2_rs_delta(:,38), l2_rs_delta(:,39), l2_rs_delta(:,40), ...
    l2_rs_delta(:,41), l2_rs_delta(:,42), l2_rs_delta(:,43), l2_rs_delta(:,44), l2_rs_delta(:,45), l2_rs_delta(:,46), l2_rs_delta(:,47), l2_rs_delta(:,48), l2_rs_delta(:,49), l2_rs_delta(:,50), ...
    'VariableNames', {'group', 'subject' ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
l2_rs_rm = fitrm(l2_rs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
fprintf('L2/3 RS ANOVA:\n')
l2_rs_ranova = ranova(l2_rs_rm)

l2_mod_fs_delta = l2_mod_fs_hit-mean(l2_mod_fs_hit(:,time<0),2);
l2_unmod_fs_delta = l2_unmod_fs_hit-mean(l2_unmod_fs_hit(:,time<0),2);
l2_mod_fs_delta = l2_mod_fs_delta(:,time > 0);
l2_unmod_fs_delta = l2_unmod_fs_delta(:,time > 0);
l2_fs_delta = [l2_mod_fs_delta; l2_unmod_fs_delta];
l2_fs_subj = vertcat(l2_mod_fs_subj, l2_unmod_fs_subj);
l2_fs_group = [zeros(size(l2_mod_fs_delta,1),1); ones(size(l2_unmod_fs_delta,1),1)];
l2_fs_table = table(l2_fs_group, ...
    l2_fs_delta(:,1), l2_fs_delta(:,2), l2_fs_delta(:,3), l2_fs_delta(:,4), l2_fs_delta(:,5), l2_fs_delta(:,6), l2_fs_delta(:,7), l2_fs_delta(:,8), l2_fs_delta(:,9), l2_fs_delta(:,10), ...
    l2_fs_delta(:,11), l2_fs_delta(:,12), l2_fs_delta(:,13), l2_fs_delta(:,14), l2_fs_delta(:,15), l2_fs_delta(:,16), l2_fs_delta(:,17), l2_fs_delta(:,18), l2_fs_delta(:,19), l2_fs_delta(:,20), ...
    l2_fs_delta(:,21), l2_fs_delta(:,22), l2_fs_delta(:,23), l2_fs_delta(:,24), l2_fs_delta(:,25), l2_fs_delta(:,26), l2_fs_delta(:,27), l2_fs_delta(:,28), l2_fs_delta(:,29), l2_fs_delta(:,30), ...
    l2_fs_delta(:,31), l2_fs_delta(:,32), l2_fs_delta(:,33), l2_fs_delta(:,34), l2_fs_delta(:,35), l2_fs_delta(:,36), l2_fs_delta(:,37), l2_fs_delta(:,38), l2_fs_delta(:,39), l2_fs_delta(:,40), ...
    l2_fs_delta(:,41), l2_fs_delta(:,42), l2_fs_delta(:,43), l2_fs_delta(:,44), l2_fs_delta(:,45), l2_fs_delta(:,46), l2_fs_delta(:,47), l2_fs_delta(:,48), l2_fs_delta(:,49), l2_fs_delta(:,50), ...
    'VariableNames', {'group', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
l2_fs_rm = fitrm(l2_fs_table, 't1-t50 ~ group', 'WithinDesign', Time);
fprintf('L2/3 FS ANOVA:\n')
l2_fs_ranova = ranova(l2_fs_rm)

l4_mod_rs_delta = l4_mod_rs_hit-mean(l4_mod_rs_hit(:,time<0),2);
l4_unmod_rs_delta = l4_unmod_rs_hit-mean(l4_unmod_rs_hit(:,time<0),2);
l4_mod_rs_delta = l4_mod_rs_delta(:,time > 0);
l4_unmod_rs_delta = l4_unmod_rs_delta(:,time > 0);
l4_rs_delta = [l4_mod_rs_delta; l4_unmod_rs_delta];
l4_rs_subj = vertcat(l4_mod_rs_subj, l4_unmod_rs_subj);
l4_rs_group = [zeros(size(l4_mod_rs_delta,1),1); ones(size(l4_unmod_rs_delta,1),1)];
l4_rs_table = table(l4_rs_group, l4_rs_subj, ...
    l4_rs_delta(:,1), l4_rs_delta(:,2), l4_rs_delta(:,3), l4_rs_delta(:,4), l4_rs_delta(:,5), l4_rs_delta(:,6), l4_rs_delta(:,7), l4_rs_delta(:,8), l4_rs_delta(:,9), l4_rs_delta(:,10), ...
    l4_rs_delta(:,11), l4_rs_delta(:,12), l4_rs_delta(:,13), l4_rs_delta(:,14), l4_rs_delta(:,15), l4_rs_delta(:,16), l4_rs_delta(:,17), l4_rs_delta(:,18), l4_rs_delta(:,19), l4_rs_delta(:,20), ...
    l4_rs_delta(:,21), l4_rs_delta(:,22), l4_rs_delta(:,23), l4_rs_delta(:,24), l4_rs_delta(:,25), l4_rs_delta(:,26), l4_rs_delta(:,27), l4_rs_delta(:,28), l4_rs_delta(:,29), l4_rs_delta(:,30), ...
    l4_rs_delta(:,31), l4_rs_delta(:,32), l4_rs_delta(:,33), l4_rs_delta(:,34), l4_rs_delta(:,35), l4_rs_delta(:,36), l4_rs_delta(:,37), l4_rs_delta(:,38), l4_rs_delta(:,39), l4_rs_delta(:,40), ...
    l4_rs_delta(:,41), l4_rs_delta(:,42), l4_rs_delta(:,43), l4_rs_delta(:,44), l4_rs_delta(:,45), l4_rs_delta(:,46), l4_rs_delta(:,47), l4_rs_delta(:,48), l4_rs_delta(:,49), l4_rs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
l4_rs_rm = fitrm(l4_rs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
fprintf('L4 RS ANOVA:\n')
l4_rs_ranova = ranova(l4_rs_rm)

l4_mod_fs_delta = l4_mod_fs_hit-mean(l4_mod_fs_hit(:,time<0),2);
l4_unmod_fs_delta = l4_unmod_fs_hit-mean(l4_unmod_fs_hit(:,time<0),2);
l4_mod_fs_delta = l4_mod_fs_delta(:,time > 0);
l4_unmod_fs_delta = l4_unmod_fs_delta(:,time > 0);
l4_fs_delta = [l4_mod_fs_delta; l4_unmod_fs_delta];
l4_fs_subj = vertcat(l4_mod_fs_subj, l4_unmod_fs_subj);
l4_fs_group = [zeros(size(l4_mod_fs_delta,1),1); ones(size(l4_unmod_fs_delta,1),1)];
l4_fs_table = table(l4_fs_group, l4_fs_subj, ...
    l4_fs_delta(:,1), l4_fs_delta(:,2), l4_fs_delta(:,3), l4_fs_delta(:,4), l4_fs_delta(:,5), l4_fs_delta(:,6), l4_fs_delta(:,7), l4_fs_delta(:,8), l4_fs_delta(:,9), l4_fs_delta(:,10), ...
    l4_fs_delta(:,11), l4_fs_delta(:,12), l4_fs_delta(:,13), l4_fs_delta(:,14), l4_fs_delta(:,15), l4_fs_delta(:,16), l4_fs_delta(:,17), l4_fs_delta(:,18), l4_fs_delta(:,19), l4_fs_delta(:,20), ...
    l4_fs_delta(:,21), l4_fs_delta(:,22), l4_fs_delta(:,23), l4_fs_delta(:,24), l4_fs_delta(:,25), l4_fs_delta(:,26), l4_fs_delta(:,27), l4_fs_delta(:,28), l4_fs_delta(:,29), l4_fs_delta(:,30), ...
    l4_fs_delta(:,31), l4_fs_delta(:,32), l4_fs_delta(:,33), l4_fs_delta(:,34), l4_fs_delta(:,35), l4_fs_delta(:,36), l4_fs_delta(:,37), l4_fs_delta(:,38), l4_fs_delta(:,39), l4_fs_delta(:,40), ...
    l4_fs_delta(:,41), l4_fs_delta(:,42), l4_fs_delta(:,43), l4_fs_delta(:,44), l4_fs_delta(:,45), l4_fs_delta(:,46), l4_fs_delta(:,47), l4_fs_delta(:,48), l4_fs_delta(:,49), l4_fs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
l4_fs_rm = fitrm(l4_fs_table, 't1-t50 ~ group', 'WithinDesign', Time);
fprintf('L4 FS ANOVA:\n')
l4_fs_ranova = ranova(l4_fs_rm)

l5_mod_rs_delta = l5_mod_rs_hit-mean(l5_mod_rs_hit(:,time<0),2);
l5_unmod_rs_delta = l5_unmod_rs_hit-mean(l5_unmod_rs_hit(:,time<0),2);
l5_mod_rs_delta = l5_mod_rs_delta(:,time > 0);
l5_unmod_rs_delta = l5_unmod_rs_delta(:,time > 0);
l5_rs_delta = [l5_mod_rs_delta; l5_unmod_rs_delta];
l5_rs_subj = vertcat(l5_mod_rs_subj, l5_unmod_rs_subj);
l5_rs_group = [zeros(size(l5_mod_rs_delta,1),1); ones(size(l5_unmod_rs_delta,1),1)];
l5_rs_table = table(l5_rs_group, l5_rs_subj, ...
    l5_rs_delta(:,1), l5_rs_delta(:,2), l5_rs_delta(:,3), l5_rs_delta(:,4), l5_rs_delta(:,5), l5_rs_delta(:,6), l5_rs_delta(:,7), l5_rs_delta(:,8), l5_rs_delta(:,9), l5_rs_delta(:,10), ...
    l5_rs_delta(:,11), l5_rs_delta(:,12), l5_rs_delta(:,13), l5_rs_delta(:,14), l5_rs_delta(:,15), l5_rs_delta(:,16), l5_rs_delta(:,17), l5_rs_delta(:,18), l5_rs_delta(:,19), l5_rs_delta(:,20), ...
    l5_rs_delta(:,21), l5_rs_delta(:,22), l5_rs_delta(:,23), l5_rs_delta(:,24), l5_rs_delta(:,25), l5_rs_delta(:,26), l5_rs_delta(:,27), l5_rs_delta(:,28), l5_rs_delta(:,29), l5_rs_delta(:,30), ...
    l5_rs_delta(:,31), l5_rs_delta(:,32), l5_rs_delta(:,33), l5_rs_delta(:,34), l5_rs_delta(:,35), l5_rs_delta(:,36), l5_rs_delta(:,37), l5_rs_delta(:,38), l5_rs_delta(:,39), l5_rs_delta(:,40), ...
    l5_rs_delta(:,41), l5_rs_delta(:,42), l5_rs_delta(:,43), l5_rs_delta(:,44), l5_rs_delta(:,45), l5_rs_delta(:,46), l5_rs_delta(:,47), l5_rs_delta(:,48), l5_rs_delta(:,49), l5_rs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
l5_rs_rm = fitrm(l5_rs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
fprintf('L5 RS ANOVA:\n')
l5_rs_ranova = ranova(l5_rs_rm)

l5_mod_fs_delta = l5_mod_fs_hit-mean(l5_mod_fs_hit(:,time<0),2);
l5_unmod_fs_delta = l5_unmod_fs_hit-mean(l5_unmod_fs_hit(:,time<0),2);
l5_mod_fs_delta = l5_mod_fs_delta(:,time > 0);
l5_unmod_fs_delta = l5_unmod_fs_delta(:,time > 0);
l5_fs_delta = [l5_mod_fs_delta; l5_unmod_fs_delta];
l5_fs_subj = vertcat(l5_mod_fs_subj, l5_unmod_fs_subj);
l5_fs_group = [zeros(size(l5_mod_fs_delta,1),1); ones(size(l5_unmod_fs_delta,1),1)];
l5_fs_table = table(l5_fs_group, l5_fs_subj, ...
    l5_fs_delta(:,1), l5_fs_delta(:,2), l5_fs_delta(:,3), l5_fs_delta(:,4), l5_fs_delta(:,5), l5_fs_delta(:,6), l5_fs_delta(:,7), l5_fs_delta(:,8), l5_fs_delta(:,9), l5_fs_delta(:,10), ...
    l5_fs_delta(:,11), l5_fs_delta(:,12), l5_fs_delta(:,13), l5_fs_delta(:,14), l5_fs_delta(:,15), l5_fs_delta(:,16), l5_fs_delta(:,17), l5_fs_delta(:,18), l5_fs_delta(:,19), l5_fs_delta(:,20), ...
    l5_fs_delta(:,21), l5_fs_delta(:,22), l5_fs_delta(:,23), l5_fs_delta(:,24), l5_fs_delta(:,25), l5_fs_delta(:,26), l5_fs_delta(:,27), l5_fs_delta(:,28), l5_fs_delta(:,29), l5_fs_delta(:,30), ...
    l5_fs_delta(:,31), l5_fs_delta(:,32), l5_fs_delta(:,33), l5_fs_delta(:,34), l5_fs_delta(:,35), l5_fs_delta(:,36), l5_fs_delta(:,37), l5_fs_delta(:,38), l5_fs_delta(:,39), l5_fs_delta(:,40), ...
    l5_fs_delta(:,41), l5_fs_delta(:,42), l5_fs_delta(:,43), l5_fs_delta(:,44), l5_fs_delta(:,45), l5_fs_delta(:,46), l5_fs_delta(:,47), l5_fs_delta(:,48), l5_fs_delta(:,49), l5_fs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
l5_fs_rm = fitrm(l5_fs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
fprintf('L5 FS ANOVA:\n')
l5_fs_ranova = ranova(l5_fs_rm)

l6_mod_rs_delta = l6_mod_rs_hit-mean(l6_mod_rs_hit(:,time<0),2);
l6_unmod_rs_delta = l6_unmod_rs_hit-mean(l6_unmod_rs_hit(:,time<0),2);
l6_mod_rs_delta = l6_mod_rs_delta(:,time > 0);
l6_unmod_rs_delta = l6_unmod_rs_delta(:,time > 0);
l6_rs_delta = [l6_mod_rs_delta; l6_unmod_rs_delta];
l6_rs_subj = vertcat(l6_mod_rs_subj, l6_unmod_rs_subj);
l6_rs_group = [zeros(size(l6_mod_rs_delta,1),1); ones(size(l6_unmod_rs_delta,1),1)];
l6_rs_table = table(l6_rs_group, l6_rs_subj, ...
    l6_rs_delta(:,1), l6_rs_delta(:,2), l6_rs_delta(:,3), l6_rs_delta(:,4), l6_rs_delta(:,5), l6_rs_delta(:,6), l6_rs_delta(:,7), l6_rs_delta(:,8), l6_rs_delta(:,9), l6_rs_delta(:,10), ...
    l6_rs_delta(:,11), l6_rs_delta(:,12), l6_rs_delta(:,13), l6_rs_delta(:,14), l6_rs_delta(:,15), l6_rs_delta(:,16), l6_rs_delta(:,17), l6_rs_delta(:,18), l6_rs_delta(:,19), l6_rs_delta(:,20), ...
    l6_rs_delta(:,21), l6_rs_delta(:,22), l6_rs_delta(:,23), l6_rs_delta(:,24), l6_rs_delta(:,25), l6_rs_delta(:,26), l6_rs_delta(:,27), l6_rs_delta(:,28), l6_rs_delta(:,29), l6_rs_delta(:,30), ...
    l6_rs_delta(:,31), l6_rs_delta(:,32), l6_rs_delta(:,33), l6_rs_delta(:,34), l6_rs_delta(:,35), l6_rs_delta(:,36), l6_rs_delta(:,37), l6_rs_delta(:,38), l6_rs_delta(:,39), l6_rs_delta(:,40), ...
    l6_rs_delta(:,41), l6_rs_delta(:,42), l6_rs_delta(:,43), l6_rs_delta(:,44), l6_rs_delta(:,45), l6_rs_delta(:,46), l6_rs_delta(:,47), l6_rs_delta(:,48), l6_rs_delta(:,49), l6_rs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
l6_rs_rm = fitrm(l6_rs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
fprintf('L6 RS ANOVA:\n')
l6_rs_ranova = ranova(l6_rs_rm)

l6_mod_fs_delta = l6_mod_fs_hit-mean(l6_mod_fs_hit(:,time<0),2);
l6_unmod_fs_delta = l6_unmod_fs_hit-mean(l6_unmod_fs_hit(:,time<0),2);
l6_mod_fs_delta = l6_mod_fs_delta(:,time > 0);
l6_unmod_fs_delta = l6_unmod_fs_delta(:,time > 0);
l6_fs_delta = [l6_mod_fs_delta; l6_unmod_fs_delta];
l6_fs_subj = vertcat(l6_mod_fs_subj, l6_unmod_fs_subj);
l6_fs_group = [zeros(size(l6_mod_fs_delta,1),1); ones(size(l6_unmod_fs_delta,1),1)];
l6_fs_table = table(l6_fs_group, l6_fs_subj, ...
    l6_fs_delta(:,1), l6_fs_delta(:,2), l6_fs_delta(:,3), l6_fs_delta(:,4), l6_fs_delta(:,5), l6_fs_delta(:,6), l6_fs_delta(:,7), l6_fs_delta(:,8), l6_fs_delta(:,9), l6_fs_delta(:,10), ...
    l6_fs_delta(:,11), l6_fs_delta(:,12), l6_fs_delta(:,13), l6_fs_delta(:,14), l6_fs_delta(:,15), l6_fs_delta(:,16), l6_fs_delta(:,17), l6_fs_delta(:,18), l6_fs_delta(:,19), l6_fs_delta(:,20), ...
    l6_fs_delta(:,21), l6_fs_delta(:,22), l6_fs_delta(:,23), l6_fs_delta(:,24), l6_fs_delta(:,25), l6_fs_delta(:,26), l6_fs_delta(:,27), l6_fs_delta(:,28), l6_fs_delta(:,29), l6_fs_delta(:,30), ...
    l6_fs_delta(:,31), l6_fs_delta(:,32), l6_fs_delta(:,33), l6_fs_delta(:,34), l6_fs_delta(:,35), l6_fs_delta(:,36), l6_fs_delta(:,37), l6_fs_delta(:,38), l6_fs_delta(:,39), l6_fs_delta(:,40), ...
    l6_fs_delta(:,41), l6_fs_delta(:,42), l6_fs_delta(:,43), l6_fs_delta(:,44), l6_fs_delta(:,45), l6_fs_delta(:,46), l6_fs_delta(:,47), l6_fs_delta(:,48), l6_fs_delta(:,49), l6_fs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
l6_fs_rm = fitrm(l6_fs_table, 't1-t50 ~ group', 'WithinDesign', Time);
fprintf('L6 FS ANOVA:\n')
l6_fs_ranova = ranova(l6_fs_rm)

cellclass = {};
for i = 1:length(s1_l1_rs_frac)
    cellclass{i} = 'RS';
end
for i = 1:length(s1_l1_fs_frac)
    cellclass{length(s1_l1_rs_frac)+i} = 'FS';
end
s1_by_layers = table(cellclass', [s1_l2_rs_frac'; s1_l2_fs_frac'], ...
    [s1_l4_rs_frac'; s1_l4_fs_frac'], [s1_l5_rs_frac'; s1_l5_fs_frac'], [s1_l6_rs_frac'; s1_l6_fs_frac'], 'VariableNames', ...
    {'cellclass', 'l2', 'l4', 'l5', 'l6'});
% s1_rs_by_layers = table(cellclass', s1_l1_rs_frac', s1_l2_rs_frac', ...
%     s1_l4_rs_frac', s1_l5_rs_frac', s1_l6_rs_frac', 'VariableNames', ...
%     {'cellclass', 'l1', 'l2', 'l4', 'l5', 'l6'});
Layer = [2,4,5,6]';
% s1_layer_rm = fitrm(s1_rs_by_layers, 'l1-l6 ~ cellclass', 'WithinDesign', Layer);
% s1_layer_tbl = anova(s1_rs_rm);
s1_rs_mat = [s1_l1_rs_frac', s1_l2_rs_frac', ...
    s1_l4_rs_frac', s1_l5_rs_frac', s1_l6_rs_frac'];
fprintf(sprintf('S1 Fraction RS ANOVA:\n'))
[p, ~, stats] = anova1(s1_rs_mat)

s1_fs_mat = [s1_l1_fs_frac', s1_l2_fs_frac', ...
    s1_l4_fs_frac', s1_l5_fs_frac', s1_l6_fs_frac'];
fprintf(sprintf('S1 Fraction FS ANOVA:\n'))
[p, ~, stats] = anova1(s1_fs_mat)
 
maxN = max([size(s1_l1_rs_mi,1),size(s1_l2_rs_mi,1),size(s1_l4_rs_mi,1),...
    size(s1_l5_rs_mi,1), size(s1_l6_rs_mi,1)]);
s1_rs_mi_mat = [[s1_l1_rs_mi; nan(maxN-length(s1_l1_rs_mi),1)], ...
    [s1_l2_rs_mi; nan(maxN-length(s1_l2_rs_mi),1)], ...
    [s1_l4_rs_mi; nan(maxN-length(s1_l4_rs_mi),1)], ...
    [s1_l5_rs_mi; nan(maxN-length(s1_l5_rs_mi),1)], ...
    [s1_l6_rs_mi; nan(maxN-length(s1_l6_rs_mi),1)]];
fprintf(sprintf('S1 MI RS ANOVA:\n'))
[p, ~, stats] = anova1(s1_rs_mi_mat)
 
maxN = max([size(s1_l1_fs_mi,1),size(s1_l2_fs_mi,1),size(s1_l4_fs_mi,1),...
    size(s1_l5_fs_mi,1), size(s1_l6_fs_mi,1)]);
s1_fs_mi_mat = [[s1_l1_fs_mi; nan(maxN-length(s1_l1_fs_mi),1)], ...
    [s1_l2_fs_mi; nan(maxN-length(s1_l2_fs_mi),1)], ...
    [s1_l4_fs_mi; nan(maxN-length(s1_l4_fs_mi),1)], ...
    [s1_l5_fs_mi; nan(maxN-length(s1_l5_fs_mi),1)], ...
    [s1_l6_fs_mi; nan(maxN-length(s1_l6_fs_mi),1)]];
fprintf(sprintf('S1 MI FS ANOVA:\n'))
[p, ~, stats] = anova1(s1_fs_mi_mat)
 
maxN = max([size(s1_l1_rs_mse,1),size(s1_l2_rs_mse,1),size(s1_l4_rs_mse,1),...
    size(s1_l5_rs_mse,1), size(s1_l6_rs_mse,1)]);
s1_rs_mse_mat = [[s1_l1_rs_mse; nan(maxN-length(s1_l1_rs_mse),1)], ...
    [s1_l2_rs_mse; nan(maxN-length(s1_l2_rs_mse),1)], ...
    [s1_l4_rs_mse; nan(maxN-length(s1_l4_rs_mse),1)], ...
    [s1_l5_rs_mse; nan(maxN-length(s1_l5_rs_mse),1)], ...
    [s1_l6_rs_mse; nan(maxN-length(s1_l6_rs_mse),1)]];
fprintf(sprintf('S1 MSE RS ANOVA:\n'))
[p, ~, stats] = anova1(s1_rs_mse_mat)
 
maxN = max([size(s1_l1_fs_mse,1),size(s1_l2_fs_mse,1),size(s1_l4_fs_mse,1),...
    size(s1_l5_fs_mse,1), size(s1_l6_fs_mse,1)]);
s1_fs_mse_mat = [[s1_l1_fs_mse; nan(maxN-length(s1_l1_fs_mse),1)], ...
    [s1_l2_fs_mse; nan(maxN-length(s1_l2_fs_mse),1)], ...
    [s1_l4_fs_mse; nan(maxN-length(s1_l4_fs_mse),1)], ...
    [s1_l5_fs_mse; nan(maxN-length(s1_l5_fs_mse),1)], ...
    [s1_l6_fs_mse; nan(maxN-length(s1_l6_fs_mse),1)]];
fprintf(sprintf('S1 MSE FS ANOVA:\n'))
[p, ~, stats] = anova1(s1_fs_mse_mat)

s1_fig = figure('Position', [1452 766 849 1011]);
tl = tiledlayout(4,2);

rs_avg = [nanmean(s1_l1_rs_frac), nanmean(s1_l2_rs_frac), nanmean(s1_l4_rs_frac), nanmean(s1_l5_rs_frac), nanmean(s1_l6_rs_frac)];
fs_avg = [nanmean(s1_l1_fs_frac), nanmean(s1_l2_fs_frac), nanmean(s1_l4_fs_frac), nanmean(s1_l5_fs_frac), nanmean(s1_l6_fs_frac)];
rs_err = [nanstd(s1_l1_rs_frac)/sqrt(sum(~isnan(s1_l1_rs_frac))), nanstd(s1_l2_rs_frac)/sqrt(sum(~isnan(s1_l2_rs_frac))), nanstd(s1_l4_rs_frac)/sqrt(sum(~isnan(s1_l4_rs_frac))), nanstd(s1_l5_rs_frac)/sqrt(sum(~isnan(s1_l5_rs_frac))), nanstd(s1_l6_rs_frac)/sqrt(sum(~isnan(s1_l6_rs_frac)))];
fs_err = [nanstd(s1_l1_fs_frac)/sqrt(sum(~isnan(s1_l1_fs_frac))), nanstd(s1_l2_fs_frac)/sqrt(sum(~isnan(s1_l2_fs_frac))), nanstd(s1_l4_fs_frac)/sqrt(sum(~isnan(s1_l4_fs_frac))), nanstd(s1_l5_fs_frac)/sqrt(sum(~isnan(s1_l5_fs_frac))), nanstd(s1_l6_fs_frac)/sqrt(sum(~isnan(s1_l6_fs_frac)))];
axs(1) = nexttile;
barh(1:5, fliplr(rs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(rs_avg), 1:5, fliplr(rs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'L1', 'L2/3', 'L4', 'L5', 'L6'}))
ylim([0.5,5.5])
title('Regular Spiking', 'FontSize', 16, 'FontWeight', 'normal')
xlabel('Fraction of Alpha Modulated', 'FontSize', 14)
ylabel('Cortical Layer', 'FontSize', 14)
lims = xlim;
xticks(lims)
axs(2) = nexttile;
barh(1:5, fliplr(fs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(fs_avg), 1:5, fliplr(fs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'L1', 'L2/3', 'L4', 'L5', 'L6'}))
ylim([0.5,5.5])
lims = xlim;
xticks(lims)
title('Fast Spiking', 'FontSize', 16, 'FontWeight', 'normal')
xlabel('Fraction of Alpha Modulated', 'FontSize', 14, 'FontWeight', 'normal')

rs_avg = [nanmean(s1_l1_rs_mi), nanmean(s1_l2_rs_mi), nanmean(s1_l4_rs_mi), nanmean(s1_l5_rs_mi), nanmean(s1_l6_rs_mi)];
fs_avg = [nanmean(s1_l1_fs_mi), nanmean(s1_l2_fs_mi), nanmean(s1_l4_fs_mi), nanmean(s1_l5_fs_mi), nanmean(s1_l6_fs_mi)];
rs_err = [nanstd(s1_l1_rs_mi)/sqrt(sum(~isnan(s1_l1_rs_mi))), nanstd(s1_l2_rs_mi)/sqrt(sum(~isnan(s1_l2_rs_mi))), nanstd(s1_l4_rs_mi)/sqrt(sum(~isnan(s1_l4_rs_mi))), nanstd(s1_l5_rs_mi)/sqrt(sum(~isnan(s1_l5_rs_mi))), nanstd(s1_l6_rs_mi)/sqrt(sum(~isnan(s1_l6_rs_mi)))];
fs_err = [nanstd(s1_l1_fs_mi)/sqrt(sum(~isnan(s1_l1_fs_mi))), nanstd(s1_l2_fs_mi)/sqrt(sum(~isnan(s1_l2_fs_mi))), nanstd(s1_l4_fs_mi)/sqrt(sum(~isnan(s1_l4_fs_mi))), nanstd(s1_l5_fs_mi)/sqrt(sum(~isnan(s1_l5_fs_mi))), nanstd(s1_l6_fs_mi)/sqrt(sum(~isnan(s1_l6_fs_mi)))];
axs(3) = nexttile;
barh(1:5, fliplr(rs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(rs_avg), 1:5, fliplr(rs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'L1', 'L2/3', 'L4', 'L5', 'L6'}))
ylim([0.5,5.5])
xlabel('Modulation Index', 'FontSize', 14)
xlim([0,0.025])
xticks([0,0.025])
ylabel('Cortical Layer', 'FontSize', 14)
axs(4) = nexttile;
barh(1:5, fliplr(fs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(fs_avg), 1:5, fliplr(fs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'L1', 'L2/3', 'L4', 'L5', 'L6'}))
ylim([0.5,5.5])
xlabel('Modulation Index', 'FontSize', 14)
xlim([0,0.025])
xticks([0,0.025])

rs_avg = [nanmean(s1_l1_rs_mse), nanmean(s1_l2_rs_mse), nanmean(s1_l4_rs_mse), nanmean(s1_l5_rs_mse), nanmean(s1_l6_rs_mse)];
fs_avg = [nanmean(s1_l1_fs_mse), nanmean(s1_l2_fs_mse), nanmean(s1_l4_fs_mse), nanmean(s1_l5_fs_mse), nanmean(s1_l6_fs_mse)];
rs_err = [nanstd(s1_l1_rs_mse)/sqrt(sum(~isnan(s1_l1_rs_mse))), nanstd(s1_l2_rs_mse)/sqrt(sum(~isnan(s1_l2_rs_mse))), nanstd(s1_l4_rs_mse)/sqrt(sum(~isnan(s1_l4_rs_mse))), nanstd(s1_l5_rs_mse)/sqrt(sum(~isnan(s1_l5_rs_mse))), nanstd(s1_l6_rs_mse)/sqrt(sum(~isnan(s1_l6_rs_mse)))];
fs_err = [nanstd(s1_l1_fs_mse)/sqrt(sum(~isnan(s1_l1_fs_mse))), nanstd(s1_l2_fs_mse)/sqrt(sum(~isnan(s1_l2_fs_mse))), nanstd(s1_l4_fs_mse)/sqrt(sum(~isnan(s1_l4_fs_mse))), nanstd(s1_l5_fs_mse)/sqrt(sum(~isnan(s1_l5_fs_mse))), nanstd(s1_l6_fs_mse)/sqrt(sum(~isnan(s1_l6_fs_mse)))];
axs(5) = nexttile;
barh(1:5, fliplr(rs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(rs_avg), 1:5, fliplr(rs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'L1', 'L2/3', 'L4', 'L5', 'L6'}))
ylim([0.5,5.5])
xlabel('von Mises MSE', 'FontSize', 14)
xlim([0,0.0012])
xticks([0,0.0012])
ylabel('Cortical Layer', 'FontSize', 14)
axs(6) = nexttile;
barh(1:5, fliplr(fs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(fs_avg), 1:5, fliplr(fs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'L1', 'L2/3', 'L4', 'L5', 'L6'}))
ylim([0.5,5.5])
xlabel('von Mises MSE', 'FontSize', 14)
xlim([0,0.0012])
xticks([0,0.0012])

rs_avg = [circ_mean(s1_l1_rs_theta_bar), circ_mean(s1_l2_rs_theta_bar), circ_mean(s1_l4_rs_theta_bar), circ_mean(s1_l5_rs_theta_bar), circ_mean(s1_l6_rs_theta_bar)];
fs_avg = [circ_mean(s1_l1_fs_theta_bar), circ_mean(s1_l2_fs_theta_bar), circ_mean(s1_l4_fs_theta_bar), circ_mean(s1_l5_fs_theta_bar), circ_mean(s1_l6_fs_theta_bar)];
rs_err = [circ_std(s1_l1_rs_theta_bar)/sqrt(sum(~isnan(s1_l1_rs_theta_bar))), circ_std(s1_l2_rs_theta_bar)/sqrt(sum(~isnan(s1_l2_rs_theta_bar))), circ_std(s1_l4_rs_theta_bar)/sqrt(sum(~isnan(s1_l4_rs_theta_bar))), circ_std(s1_l5_rs_theta_bar)/sqrt(sum(~isnan(s1_l5_rs_theta_bar))), circ_std(s1_l6_rs_theta_bar)/sqrt(sum(~isnan(s1_l6_rs_theta_bar)))];
fs_err = [circ_std(s1_l1_fs_theta_bar)/sqrt(sum(~isnan(s1_l1_fs_theta_bar))), circ_std(s1_l2_fs_theta_bar)/sqrt(sum(~isnan(s1_l2_fs_theta_bar))), circ_std(s1_l4_fs_theta_bar)/sqrt(sum(~isnan(s1_l4_fs_theta_bar))), circ_std(s1_l5_fs_theta_bar)/sqrt(sum(~isnan(s1_l5_fs_theta_bar))), circ_std(s1_l6_fs_theta_bar)/sqrt(sum(~isnan(s1_l6_fs_theta_bar)))];
axs(7) = nexttile;
barh(1:5, fliplr(rs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(rs_avg), 1:5, fliplr(rs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'L1', 'L2/3', 'L4', 'L5', 'L6'}))
ylim([0.5,5.5])
xlim([-3.5,3.5])
xticks([-pi,0,pi])
xticklabels({'-\pi', '', '\pi'})
xlabel('Avg. Firing Phase (radians)', 'FontSize', 14)
ylabel('Cortical Layer', 'FontSize', 14)
axs(8) = nexttile;
barh(1:5, fliplr(fs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(fs_avg), 1:5, fliplr(fs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'L1', 'L2/3', 'L4', 'L5', 'L6'}))
ylim([0.5,5.5])
xlim([-3.5,3.5])
xticks([-pi,0,pi])
xticklabels({'-\pi', '', '\pi'})
xlabel('Avg. Firing Phase (radians)', 'FontSize', 14, 'FontWeight', 'normal')

if out_path
    saveas(s1_fig, 'Figures/s1_distribution.fig')
    saveas(s1_fig, 'Figures/s1_distribution.svg')
end
fprintf(sprintf('Avg. Fraction L1 RS: %d\n', nanmean(s1_l1_rs_frac)))
fprintf(sprintf('Avg. Fraction L2/3 RS: %d\n', nanmean(s1_l2_rs_frac)))
fprintf(sprintf('Avg. Fraction L4 RS: %d\n', nanmean(s1_l4_rs_frac)))
fprintf(sprintf('Avg. Fraction L5 RS: %d\n', nanmean(s1_l5_rs_frac)))
fprintf(sprintf('Avg. Fraction L6 RS: %d\n', nanmean(s1_l6_rs_frac)))
fprintf(sprintf('Avg. Fraction L1 FS: %d\n', nanmean(s1_l1_fs_frac)))
fprintf(sprintf('Avg. Fraction L2/3 FS: %d\n', nanmean(s1_l2_fs_frac)))
fprintf(sprintf('Avg. Fraction L4 FS: %d\n', nanmean(s1_l4_fs_frac)))
fprintf(sprintf('Avg. Fraction L5 FS: %d\n', nanmean(s1_l5_fs_frac)))
fprintf(sprintf('Avg. Fraction L6 FS: %d\n', nanmean(s1_l6_fs_frac)))
fprintf(sprintf('Avg. MI L1 RS: %d\n', nanmean(s1_l1_rs_mi)))
fprintf(sprintf('Avg. MI L2/3 RS: %d\n', nanmean(s1_l2_rs_mi)))
fprintf(sprintf('Avg. MI L4 RS: %d\n', nanmean(s1_l4_rs_mi)))
fprintf(sprintf('Avg. MI L5 RS: %d\n', nanmean(s1_l5_rs_mi)))
fprintf(sprintf('Avg. MI L6 RS: %d\n', nanmean(s1_l6_rs_mi)))
fprintf(sprintf('Avg. MI L1 FS: %d\n', nanmean(s1_l1_fs_mi)))
fprintf(sprintf('Avg. MI L2/3 FS: %d\n', nanmean(s1_l2_fs_mi)))
fprintf(sprintf('Avg. MI L4 FS: %d\n', nanmean(s1_l4_fs_mi)))
fprintf(sprintf('Avg. MI L5 FS: %d\n', nanmean(s1_l5_fs_mi)))
fprintf(sprintf('Avg. MI L6 FS: %d\n', nanmean(s1_l6_fs_mi)))
fprintf(sprintf('Avg. MSE L1 RS: %d\n', nanmean(s1_l1_rs_mse)))
fprintf(sprintf('Avg. MSE L2/3 RS: %d\n', nanmean(s1_l2_rs_mse)))
fprintf(sprintf('Avg. MSE L4 RS: %d\n', nanmean(s1_l4_rs_mse)))
fprintf(sprintf('Avg. MSE L5 RS: %d\n', nanmean(s1_l5_rs_mse)))
fprintf(sprintf('Avg. MSE L6 RS: %d\n', nanmean(s1_l6_rs_mse)))
fprintf(sprintf('Avg. MSE L1 FS: %d\n', nanmean(s1_l1_fs_mse)))
fprintf(sprintf('Avg. MSE L2/3 FS: %d\n', nanmean(s1_l2_fs_mse)))
fprintf(sprintf('Avg. MSE L4 FS: %d\n', nanmean(s1_l4_fs_mse)))
fprintf(sprintf('Avg. MSE L5 FS: %d\n', nanmean(s1_l5_fs_mse)))
fprintf(sprintf('Avg. MSE L6 FS: %d\n', nanmean(s1_l6_fs_mse)))

pfc_sessions = unique(PFC.session_id);
ac_rs_frac = zeros(1,length(pfc_sessions));
pl_rs_frac = zeros(1,length(pfc_sessions));
il_rs_frac = zeros(1,length(pfc_sessions));
orb_rs_frac = zeros(1,length(pfc_sessions));
dp_rs_frac = zeros(1,length(pfc_sessions));
ac_fs_frac = zeros(1,length(pfc_sessions));
pl_fs_frac = zeros(1,length(pfc_sessions));
il_fs_frac = zeros(1,length(pfc_sessions));
orb_fs_frac = zeros(1,length(pfc_sessions));
dp_fs_frac = zeros(1,length(pfc_sessions));
for s = 1:length(pfc_sessions)
    session_id = pfc_sessions{s};
    tmp = pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.session_id, session_id),:);
    tmp_all = PFC(strcmp(PFC.session_id, session_id),:);
    tmp_rs = tmp(strcmp(tmp.waveform_class, 'RS'),:);
    tmp_fs = tmp(strcmp(tmp.waveform_class, 'FS'),:);
    tmp_all_rs = tmp_all(strcmp(tmp_all.waveform_class, 'RS'),:);
    tmp_all_fs = tmp_all(strcmp(tmp_all.waveform_class, 'FS'),:);
    ac_rs_frac(s) = sum(contains(tmp_rs.region, 'AC')) / sum(contains(tmp_all_rs.region, 'AC'));
    pl_rs_frac(s) = sum(contains(tmp_rs.region, 'PL')) / sum(contains(tmp_all_rs.region, 'PL'));
    il_rs_frac(s) = sum(contains(tmp_rs.region, 'IL')) / sum(contains(tmp_all_rs.region, 'IL'));
    orb_rs_frac(s) = sum(contains(tmp_rs.region, 'OR')) / sum(contains(tmp_all_rs.region, 'OR'));
    dp_rs_frac(s) = sum(contains(tmp_rs.region, 'DP')) / sum(contains(tmp_all_rs.region, 'DP'));
    ac_fs_frac(s) = sum(contains(tmp_fs.region, 'AC')) / sum(contains(tmp_all_fs.region, 'AC'));
    pl_fs_frac(s) = sum(contains(tmp_fs.region, 'PL')) / sum(contains(tmp_all_fs.region, 'PL'));
    il_fs_frac(s) = sum(contains(tmp_fs.region, 'IL')) / sum(contains(tmp_all_fs.region, 'IL'));
    orb_fs_frac(s) = sum(contains(tmp_fs.region, 'OR')) / sum(contains(tmp_all_fs.region, 'OR'));
    dp_fs_frac(s) = sum(contains(tmp_fs.region, 'DP')) / sum(contains(tmp_all_fs.region, 'DP'));
end

tmp = pfc.out.alpha_modulated;
tmp_rs = tmp(strcmp(tmp.waveform_class, 'RS'),:);
tmp_rs1 = tmp_rs(contains(tmp_rs.region, 'AC'),:);
ac_rs_mi = tmp_rs1.pmi;
ac_rs_mse = tmp_rs1.mses;
ac_rs_theta_bar = tmp_rs1.theta_bars;
tmp_rs2 = tmp_rs(contains(tmp_rs.region, 'PL'),:);
pl_rs_mi = tmp_rs2.pmi;
pl_rs_mse = tmp_rs2.mses;
pl_rs_theta_bar = tmp_rs2.theta_bars;
tmp_rs4 = tmp_rs(contains(tmp_rs.region, 'IL'),:);
il_rs_mi = tmp_rs4.pmi;
il_rs_mse = tmp_rs4.mses;
il_rs_theta_bar = tmp_rs4.theta_bars;
tmp_rs5 = tmp_rs(contains(tmp_rs.region, 'OR'),:);
orb_rs_mi = tmp_rs5.pmi;
orb_rs_mse = tmp_rs5.mses;
orb_rs_theta_bar = tmp_rs5.theta_bars;
tmp_rs6 = tmp_rs(contains(tmp_rs.region, 'DP'),:);
dp_rs_mi = tmp_rs6.pmi;
dp_rs_mse = tmp_rs6.mses;
dp_rs_theta_bar = tmp_rs6.theta_bars;

tmp_fs = tmp(strcmp(tmp.waveform_class, 'FS'),:);
tmp_fs1 = tmp_fs(contains(tmp_fs.region, 'AC'),:);
ac_fs_mi = tmp_fs1.pmi;
ac_fs_mse = tmp_fs1.mses;
ac_fs_theta_bar = tmp_fs1.theta_bars;
tmp_fs2 = tmp_fs(contains(tmp_fs.region, 'PL'),:);
pl_fs_mi = tmp_fs2.pmi;
pl_fs_mse = tmp_fs2.mses;
pl_fs_theta_bar = tmp_fs2.theta_bars;
tmp_fs4 = tmp_fs(contains(tmp_fs.region, 'IL'),:);
il_fs_mi = tmp_fs4.pmi;
il_fs_mse = tmp_fs4.mses;
il_fs_theta_bar = tmp_fs4.theta_bars;
tmp_fs5 = tmp_fs(contains(tmp_fs.region, 'OR'),:);
orb_fs_mi = tmp_fs5.pmi;
orb_fs_mse = tmp_fs5.mses;
orb_fs_theta_bar = tmp_fs5.theta_bars;
tmp_fs6 = tmp_fs(contains(tmp_fs.region, 'DP'),:);
dp_fs_mi = tmp_fs6.pmi;
dp_fs_mse = tmp_fs6.mses;
dp_fs_theta_bar = tmp_fs6.theta_bars;

AC_mod_rs_hit = [];
AC_mod_fs_hit = [];
AC_unmod_rs_hit = [];
AC_unmod_fs_hit = [];
AC_mod_rs_miss = [];
AC_mod_fs_miss = [];
AC_unmod_rs_miss = [];
AC_unmod_fs_miss = [];
AC_mod_rs_cr = [];
AC_mod_fs_cr = [];
AC_unmod_rs_cr = [];
AC_unmod_fs_cr = [];
AC_mod_rs_fa = [];
AC_mod_fs_fa = [];
AC_unmod_rs_fa = [];
AC_unmod_fs_fa = [];
AC_mod_rs_subj = {};
AC_mod_fs_subj = {};
AC_unmod_rs_subj = {};
AC_unmod_fs_subj = {};
PL_mod_rs_hit = [];
PL_mod_fs_hit = [];
PL_unmod_rs_hit = [];
PL_unmod_fs_hit = [];
PL_mod_rs_miss = [];
PL_mod_fs_miss = [];
PL_unmod_rs_miss = [];
PL_unmod_fs_miss = [];
PL_mod_rs_cr = [];
PL_mod_fs_cr = [];
PL_unmod_rs_cr = [];
PL_unmod_fs_cr = [];
PL_mod_rs_fa = [];
PL_mod_fs_fa = [];
PL_unmod_rs_fa = [];
PL_unmod_fs_fa = [];
PL_mod_rs_subj = {};
PL_mod_fs_subj = {};
PL_unmod_rs_subj = {};
PL_unmod_fs_subj = {};
IL_mod_rs_hit = [];
IL_mod_fs_hit = [];
IL_unmod_rs_hit = [];
IL_unmod_fs_hit = [];
IL_mod_rs_miss = [];
IL_mod_fs_miss = [];
IL_unmod_rs_miss = [];
IL_unmod_fs_miss = [];
IL_mod_rs_cr = [];
IL_mod_fs_cr = [];
IL_unmod_rs_cr = [];
IL_unmod_fs_cr = [];
IL_mod_rs_fa = [];
IL_mod_fs_fa = [];
IL_unmod_rs_fa = [];
IL_unmod_fs_fa = [];
IL_mod_rs_subj = {};
IL_mod_fs_subj = {};
IL_unmod_rs_subj = {};
IL_unmod_fs_subj = {};
ORB_mod_rs_hit = [];
ORB_mod_fs_hit = [];
ORB_unmod_rs_hit = [];
ORB_unmod_fs_hit = [];
ORB_mod_rs_miss = [];
ORB_mod_fs_miss = [];
ORB_unmod_rs_miss = [];
ORB_unmod_fs_miss = [];
ORB_mod_rs_cr = [];
ORB_mod_fs_cr = [];
ORB_unmod_rs_cr = [];
ORB_unmod_fs_cr = [];
ORB_mod_rs_fa = [];
ORB_mod_fs_fa = [];
ORB_unmod_rs_fa = [];
ORB_unmod_fs_fa = [];
ORB_mod_rs_subj = {};
ORB_mod_fs_subj = {};
ORB_unmod_rs_subj = {};
ORB_unmod_fs_subj = {};
DP_mod_rs_hit = [];
DP_mod_fs_hit = [];
DP_unmod_rs_hit = [];
DP_unmod_fs_hit = [];
DP_mod_rs_miss = [];
DP_mod_fs_miss = [];
DP_unmod_rs_miss = [];
DP_unmod_fs_miss = [];
DP_mod_rs_cr = [];
DP_mod_fs_cr = [];
DP_unmod_rs_cr = [];
DP_unmod_fs_cr = [];
DP_mod_rs_fa = [];
DP_mod_fs_fa = [];
DP_unmod_rs_fa = [];
DP_unmod_fs_fa = [];
DP_mod_rs_subj = {};
DP_mod_fs_subj = {};
DP_unmod_rs_subj = {};
DP_unmod_fs_subj = {};
subregions = {'AC', 'PL', 'IL', 'ORB', 'DP'};

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
    for l = 1:length(subregions)
        subregion = subregions{l};
        tmp_pfc_rs = pfc_rs(contains(pfc_rs.region, subregion),:);
        tmp_pfc_fs = pfc_fs(contains(pfc_fs.region, subregion),:);
        tmp_PFC_rs = PFC_rs(contains(PFC_rs.region, subregion),:);
        tmp_PFC_fs = PFC_fs(contains(PFC_fs.region, subregion),:);
        exec_str = sprintf('%s_mod_rs_hit = [%s_mod_rs_hit; cell2mat(tmp_pfc_rs.left_trigger_aligned_avg_fr_Hit)];',subregion,subregion);
        eval(exec_str);
        exec_str = sprintf('%s_mod_rs_miss = [%s_mod_rs_miss; cell2mat(tmp_pfc_rs.left_trigger_aligned_avg_fr_Miss)];',subregion,subregion);
        eval(exec_str);
        exec_str = sprintf('%s_mod_rs_cr = [%s_mod_rs_cr; cell2mat(tmp_pfc_rs.right_trigger_aligned_avg_fr_CR)];',subregion,subregion);
        eval(exec_str);
        exec_str = sprintf('%s_mod_rs_fa = [%s_mod_rs_fa; cell2mat(tmp_pfc_rs.right_trigger_aligned_avg_fr_FA)];',subregion,subregion);
        eval(exec_str);
        exec_str = sprintf('%s_mod_fs_hit = [%s_mod_fs_hit; cell2mat(tmp_pfc_fs.left_trigger_aligned_avg_fr_Hit)];',subregion,subregion);
        eval(exec_str);
        exec_str = sprintf('%s_mod_fs_miss = [%s_mod_fs_miss; cell2mat(tmp_pfc_fs.left_trigger_aligned_avg_fr_Miss)];',subregion,subregion);
        eval(exec_str);
        exec_str = sprintf('%s_mod_fs_cr = [%s_mod_fs_cr; cell2mat(tmp_pfc_fs.right_trigger_aligned_avg_fr_CR)];',subregion,subregion);
        eval(exec_str);
        exec_str = sprintf('%s_mod_fs_fa = [%s_mod_fs_fa; cell2mat(tmp_pfc_fs.right_trigger_aligned_avg_fr_FA)];',subregion,subregion);
        eval(exec_str);
        exec_str = sprintf('%s_unmod_rs_hit = [%s_unmod_rs_hit; cell2mat(tmp_PFC_rs.left_trigger_aligned_avg_fr_Hit)];',subregion,subregion);
        eval(exec_str);
        exec_str = sprintf('%s_unmod_rs_miss = [%s_unmod_rs_miss; cell2mat(tmp_PFC_rs.left_trigger_aligned_avg_fr_Miss)];',subregion,subregion);
        eval(exec_str);
        exec_str = sprintf('%s_unmod_rs_cr = [%s_unmod_rs_cr; cell2mat(tmp_PFC_rs.right_trigger_aligned_avg_fr_CR)];',subregion,subregion);
        eval(exec_str);
        exec_str = sprintf('%s_unmod_rs_fa = [%s_unmod_rs_fa; cell2mat(tmp_PFC_rs.right_trigger_aligned_avg_fr_FA)];',subregion,subregion);
        eval(exec_str);
        exec_str = sprintf('%s_unmod_fs_hit = [%s_unmod_fs_hit; cell2mat(tmp_PFC_fs.left_trigger_aligned_avg_fr_Hit)];',subregion,subregion);
        eval(exec_str);
        exec_str = sprintf('%s_unmod_fs_miss = [%s_unmod_fs_miss; cell2mat(tmp_PFC_fs.left_trigger_aligned_avg_fr_Miss)];',subregion,subregion);
        eval(exec_str);
        exec_str = sprintf('%s_unmod_fs_cr = [%s_unmod_fs_cr; cell2mat(tmp_PFC_fs.right_trigger_aligned_avg_fr_CR)];',subregion,subregion);
        eval(exec_str);
        exec_str = sprintf('%s_unmod_fs_fa = [%s_unmod_fs_fa; cell2mat(tmp_PFC_fs.right_trigger_aligned_avg_fr_FA)];',subregion,subregion);
        eval(exec_str);

        for id = 1:length(tmp_pfc_rs.session_id)
            sesh = tmp_pfc_rs.session_id{id};
            parts = strsplit(sesh, '_');
            part = parts{2};
            parts = strsplit(part, '-');
            subj = parts{2};
            exec_str = sprintf('%s_mod_rs_subj = vertcat(%s_mod_rs_subj, subj);',subregion,subregion);
            eval(exec_str)
        end

        for id = 1:length(tmp_pfc_fs.session_id)
            sesh = tmp_pfc_fs.session_id{id};
            parts = strsplit(sesh, '_');
            part = parts{2};
            parts = strsplit(part, '-');
            subj = parts{2};
            exec_str = sprintf('%s_mod_fs_subj = vertcat(%s_mod_fs_subj, subj);',subregion,subregion);
            eval(exec_str)
        end

        for id = 1:length(tmp_PFC_rs.session_id)
            sesh = tmp_PFC_rs.session_id{id};
            parts = strsplit(sesh, '_');
            part = parts{2};
            parts = strsplit(part, '-');
            subj = parts{2};
            exec_str = sprintf('%s_unmod_rs_subj = vertcat(%s_unmod_rs_subj, subj);',subregion,subregion);
            eval(exec_str)
        end

        for id = 1:length(tmp_PFC_fs.session_id)
            sesh = tmp_PFC_fs.session_id{id};
            parts = strsplit(sesh, '_');
            part = parts{2};
            parts = strsplit(part, '-');
            subj = parts{2};
            exec_str = sprintf('%s_unmod_fs_subj = vertcat(%s_unmod_fs_subj, subj);',subregion,subregion);
            eval(exec_str)
        end
    end
end

pfc_fr_fig = figure('Position', [1452 766 849 1011]);
tl = tiledlayout(5,2);
axs = zeros(5,2);
time = linspace(-2.8,4.8,size(IL_mod_rs_hit,2));
labels = {'ACC', 'PL', 'IL', 'ORB', 'DP'};
for l = 1:length(subregions)
    subregion = subregions{l};
    axs(l,1) = nexttile;
    hold on 
    exec_str = sprintf("semshade(%s_mod_rs_hit-mean(%s_mod_rs_hit(:,time<0),2), 0.3, 'b', 'b', time);", subregion, subregion);
    try
        eval(exec_str)
    end
    exec_str = sprintf("semshade(%s_unmod_rs_hit-mean(%s_unmod_rs_hit(:,time<0),2), 0.3, 'r', 'r', time);", subregion, subregion);
    try 
        eval(exec_str)
    end
    if l == 1
        ylim([-10,20])
        title('Regular Spiking', 'FontSize', 18, 'FontWeight', 'normal')
    else
        ylim([-2,3])
    end
    xlim([-1,5])
    ylabel(labels{l}, 'FontSize', 14, 'FontWeight', 'normal')
    axs(l,2) = nexttile;
    hold on
    exec_str = sprintf("semshade(%s_mod_fs_hit-nanmean(%s_mod_fs_hit(:,time<0),2), 0.3, 'b', 'b', time);", subregion, subregion);
    try
        eval(exec_str)
    catch
        exec_str = sprintf("plot(time, %s_mod_fs_hit-nanmean(%s_mod_fs_hit(time<0)), 'b')", subregion, subregion);
        try 
            eval(exec_str)
        end
    end
    exec_str = sprintf("semshade(%s_unmod_fs_hit-nanmean(%s_unmod_fs_hit(:,time<0),2), 0.3, 'r', 'r', time);", subregion, subregion);
    try
        eval(exec_str)
    catch
        exec_str = sprintf("plot(time, %s_unmod_fs_hit-nanmean(%s_unmod_fs_hit(time<0)), 'r')", subregion, subregion);
        try 
            eval(exec_str)
        end
    end
    ylim([-10,20])
    xlim([-1,5])
    if l == 1
        title('Fast Spiking', 'FontSize', 18, 'FontWeight', 'normal')
    end
end 
ylabel(tl, '\Delta Firing Rate (Hz)', 'FontSize', 16, 'FontWeight', 'normal')
xlabel(tl, 'Time (s)', 'FontSize', 16, 'FontWeight', 'normal')
% saveas(pfc_fr_fig, 'tmp/subregion_fr.png')
if out_path
    saveas(pfc_fr_fig, 'Figures/subregion_fr.svg')
    saveas(pfc_fr_fig, 'Figures/subregion_fr.fig')
end
AC_mod_rs_delta = AC_mod_rs_hit-mean(AC_mod_rs_hit(:,time<0),2);
AC_unmod_rs_delta = AC_unmod_rs_hit-mean(AC_unmod_rs_hit(:,time<0),2);
AC_mod_rs_delta = AC_mod_rs_delta(:,time > 0);
AC_unmod_rs_delta = AC_unmod_rs_delta(:,time > 0);
AC_rs_delta = [AC_mod_rs_delta; AC_unmod_rs_delta];
AC_rs_subj = vertcat(AC_mod_rs_subj, AC_unmod_rs_subj);
AC_rs_group = [zeros(size(AC_mod_rs_delta,1),1); ones(size(AC_unmod_rs_delta,1),1)];
AC_rs_table = table(AC_rs_group, AC_rs_subj, ...
    AC_rs_delta(:,1), AC_rs_delta(:,2), AC_rs_delta(:,3), AC_rs_delta(:,4), AC_rs_delta(:,5), AC_rs_delta(:,6), AC_rs_delta(:,7), AC_rs_delta(:,8), AC_rs_delta(:,9), AC_rs_delta(:,10), ...
    AC_rs_delta(:,11), AC_rs_delta(:,12), AC_rs_delta(:,13), AC_rs_delta(:,14), AC_rs_delta(:,15), AC_rs_delta(:,16), AC_rs_delta(:,17), AC_rs_delta(:,18), AC_rs_delta(:,19), AC_rs_delta(:,20), ...
    AC_rs_delta(:,21), AC_rs_delta(:,22), AC_rs_delta(:,23), AC_rs_delta(:,24), AC_rs_delta(:,25), AC_rs_delta(:,26), AC_rs_delta(:,27), AC_rs_delta(:,28), AC_rs_delta(:,29), AC_rs_delta(:,30), ...
    AC_rs_delta(:,31), AC_rs_delta(:,32), AC_rs_delta(:,33), AC_rs_delta(:,34), AC_rs_delta(:,35), AC_rs_delta(:,36), AC_rs_delta(:,37), AC_rs_delta(:,38), AC_rs_delta(:,39), AC_rs_delta(:,40), ...
    AC_rs_delta(:,41), AC_rs_delta(:,42), AC_rs_delta(:,43), AC_rs_delta(:,44), AC_rs_delta(:,45), AC_rs_delta(:,46), AC_rs_delta(:,47), AC_rs_delta(:,48), AC_rs_delta(:,49), AC_rs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
AC_rs_rm = fitrm(AC_rs_table, 't1-t50 ~ group', 'WithinDesign', Time);
fprintf('ACC RS ANOVA:\n')
AC_rs_ranova = ranova(AC_rs_rm)

AC_mod_fs_delta = AC_mod_fs_hit-mean(AC_mod_fs_hit(:,time<0),2);
AC_unmod_fs_delta = AC_unmod_fs_hit-mean(AC_unmod_fs_hit(:,time<0),2);
AC_mod_fs_delta = AC_mod_fs_delta(:,time > 0);
AC_unmod_fs_delta = AC_unmod_fs_delta(:,time > 0);
AC_fs_delta = [AC_mod_fs_delta; AC_unmod_fs_delta];
AC_fs_subj = vertcat(AC_mod_fs_subj, AC_unmod_fs_subj);
AC_fs_group = [zeros(size(AC_mod_fs_delta,1),1); ones(size(AC_unmod_fs_delta,1),1)];
AC_fs_table = table(AC_fs_group, AC_fs_subj, ...
    AC_fs_delta(:,1), AC_fs_delta(:,2), AC_fs_delta(:,3), AC_fs_delta(:,4), AC_fs_delta(:,5), AC_fs_delta(:,6), AC_fs_delta(:,7), AC_fs_delta(:,8), AC_fs_delta(:,9), AC_fs_delta(:,10), ...
    AC_fs_delta(:,11), AC_fs_delta(:,12), AC_fs_delta(:,13), AC_fs_delta(:,14), AC_fs_delta(:,15), AC_fs_delta(:,16), AC_fs_delta(:,17), AC_fs_delta(:,18), AC_fs_delta(:,19), AC_fs_delta(:,20), ...
    AC_fs_delta(:,21), AC_fs_delta(:,22), AC_fs_delta(:,23), AC_fs_delta(:,24), AC_fs_delta(:,25), AC_fs_delta(:,26), AC_fs_delta(:,27), AC_fs_delta(:,28), AC_fs_delta(:,29), AC_fs_delta(:,30), ...
    AC_fs_delta(:,31), AC_fs_delta(:,32), AC_fs_delta(:,33), AC_fs_delta(:,34), AC_fs_delta(:,35), AC_fs_delta(:,36), AC_fs_delta(:,37), AC_fs_delta(:,38), AC_fs_delta(:,39), AC_fs_delta(:,40), ...
    AC_fs_delta(:,41), AC_fs_delta(:,42), AC_fs_delta(:,43), AC_fs_delta(:,44), AC_fs_delta(:,45), AC_fs_delta(:,46), AC_fs_delta(:,47), AC_fs_delta(:,48), AC_fs_delta(:,49), AC_fs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
AC_fs_rm = fitrm(AC_fs_table, 't1-t50 ~ group', 'WithinDesign', Time);
fprintf('ACC FS ANOVA:\n')
AC_fs_ranova = ranova(AC_fs_rm)

PL_mod_rs_delta = PL_mod_rs_hit-mean(PL_mod_rs_hit(:,time<0),2);
PL_unmod_rs_delta = PL_unmod_rs_hit-mean(PL_unmod_rs_hit(:,time<0),2);
PL_mod_rs_delta = PL_mod_rs_delta(:,time > 0);
PL_unmod_rs_delta = PL_unmod_rs_delta(:,time > 0);
PL_rs_delta = [PL_mod_rs_delta; PL_unmod_rs_delta];
PL_rs_subj = vertcat(PL_mod_rs_subj, PL_unmod_rs_subj);
PL_rs_group = [zeros(size(PL_mod_rs_delta,1),1); ones(size(PL_unmod_rs_delta,1),1)];
PL_rs_table = table(PL_rs_group, PL_rs_subj, ...
    PL_rs_delta(:,1), PL_rs_delta(:,2), PL_rs_delta(:,3), PL_rs_delta(:,4), PL_rs_delta(:,5), PL_rs_delta(:,6), PL_rs_delta(:,7), PL_rs_delta(:,8), PL_rs_delta(:,9), PL_rs_delta(:,10), ...
    PL_rs_delta(:,11), PL_rs_delta(:,12), PL_rs_delta(:,13), PL_rs_delta(:,14), PL_rs_delta(:,15), PL_rs_delta(:,16), PL_rs_delta(:,17), PL_rs_delta(:,18), PL_rs_delta(:,19), PL_rs_delta(:,20), ...
    PL_rs_delta(:,21), PL_rs_delta(:,22), PL_rs_delta(:,23), PL_rs_delta(:,24), PL_rs_delta(:,25), PL_rs_delta(:,26), PL_rs_delta(:,27), PL_rs_delta(:,28), PL_rs_delta(:,29), PL_rs_delta(:,30), ...
    PL_rs_delta(:,31), PL_rs_delta(:,32), PL_rs_delta(:,33), PL_rs_delta(:,34), PL_rs_delta(:,35), PL_rs_delta(:,36), PL_rs_delta(:,37), PL_rs_delta(:,38), PL_rs_delta(:,39), PL_rs_delta(:,40), ...
    PL_rs_delta(:,41), PL_rs_delta(:,42), PL_rs_delta(:,43), PL_rs_delta(:,44), PL_rs_delta(:,45), PL_rs_delta(:,46), PL_rs_delta(:,47), PL_rs_delta(:,48), PL_rs_delta(:,49), PL_rs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
PL_rs_rm = fitrm(PL_rs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
fprintf('PL RS ANOVA:\n')
PL_rs_ranova = ranova(PL_rs_rm)

PL_mod_fs_delta = PL_mod_fs_hit-mean(PL_mod_fs_hit(:,time<0),2);
PL_unmod_fs_delta = PL_unmod_fs_hit-mean(PL_unmod_fs_hit(:,time<0),2);
PL_mod_fs_delta = PL_mod_fs_delta(:,time > 0);
PL_unmod_fs_delta = PL_unmod_fs_delta(:,time > 0);
PL_fs_delta = [PL_mod_fs_delta; PL_unmod_fs_delta];
PL_fs_subj = vertcat(PL_mod_fs_subj, PL_unmod_fs_subj);
PL_fs_group = [zeros(size(PL_mod_fs_delta,1),1); ones(size(PL_unmod_fs_delta,1),1)];
PL_fs_table = table(PL_fs_group, PL_fs_subj, ...
    PL_fs_delta(:,1), PL_fs_delta(:,2), PL_fs_delta(:,3), PL_fs_delta(:,4), PL_fs_delta(:,5), PL_fs_delta(:,6), PL_fs_delta(:,7), PL_fs_delta(:,8), PL_fs_delta(:,9), PL_fs_delta(:,10), ...
    PL_fs_delta(:,11), PL_fs_delta(:,12), PL_fs_delta(:,13), PL_fs_delta(:,14), PL_fs_delta(:,15), PL_fs_delta(:,16), PL_fs_delta(:,17), PL_fs_delta(:,18), PL_fs_delta(:,19), PL_fs_delta(:,20), ...
    PL_fs_delta(:,21), PL_fs_delta(:,22), PL_fs_delta(:,23), PL_fs_delta(:,24), PL_fs_delta(:,25), PL_fs_delta(:,26), PL_fs_delta(:,27), PL_fs_delta(:,28), PL_fs_delta(:,29), PL_fs_delta(:,30), ...
    PL_fs_delta(:,31), PL_fs_delta(:,32), PL_fs_delta(:,33), PL_fs_delta(:,34), PL_fs_delta(:,35), PL_fs_delta(:,36), PL_fs_delta(:,37), PL_fs_delta(:,38), PL_fs_delta(:,39), PL_fs_delta(:,40), ...
    PL_fs_delta(:,41), PL_fs_delta(:,42), PL_fs_delta(:,43), PL_fs_delta(:,44), PL_fs_delta(:,45), PL_fs_delta(:,46), PL_fs_delta(:,47), PL_fs_delta(:,48), PL_fs_delta(:,49), PL_fs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
PL_fs_rm = fitrm(PL_fs_table, 't1-t50 ~ group', 'WithinDesign', Time);
fprintf('PL FS ANOVA:\n')
PL_fs_ranova = ranova(PL_fs_rm)

IL_mod_rs_delta = IL_mod_rs_hit-mean(IL_mod_rs_hit(:,time<0),2);
IL_unmod_rs_delta = IL_unmod_rs_hit-mean(IL_unmod_rs_hit(:,time<0),2);
IL_mod_rs_delta = IL_mod_rs_delta(:,time > 0);
IL_unmod_rs_delta = IL_unmod_rs_delta(:,time > 0);
IL_rs_delta = [IL_mod_rs_delta; IL_unmod_rs_delta];
IL_rs_subj = vertcat(IL_mod_rs_subj, IL_unmod_rs_subj);
IL_rs_group = [zeros(size(IL_mod_rs_delta,1),1); ones(size(IL_unmod_rs_delta,1),1)];
IL_rs_table = table(IL_rs_group, IL_rs_subj, ...
    IL_rs_delta(:,1), IL_rs_delta(:,2), IL_rs_delta(:,3), IL_rs_delta(:,4), IL_rs_delta(:,5), IL_rs_delta(:,6), IL_rs_delta(:,7), IL_rs_delta(:,8), IL_rs_delta(:,9), IL_rs_delta(:,10), ...
    IL_rs_delta(:,11), IL_rs_delta(:,12), IL_rs_delta(:,13), IL_rs_delta(:,14), IL_rs_delta(:,15), IL_rs_delta(:,16), IL_rs_delta(:,17), IL_rs_delta(:,18), IL_rs_delta(:,19), IL_rs_delta(:,20), ...
    IL_rs_delta(:,21), IL_rs_delta(:,22), IL_rs_delta(:,23), IL_rs_delta(:,24), IL_rs_delta(:,25), IL_rs_delta(:,26), IL_rs_delta(:,27), IL_rs_delta(:,28), IL_rs_delta(:,29), IL_rs_delta(:,30), ...
    IL_rs_delta(:,31), IL_rs_delta(:,32), IL_rs_delta(:,33), IL_rs_delta(:,34), IL_rs_delta(:,35), IL_rs_delta(:,36), IL_rs_delta(:,37), IL_rs_delta(:,38), IL_rs_delta(:,39), IL_rs_delta(:,40), ...
    IL_rs_delta(:,41), IL_rs_delta(:,42), IL_rs_delta(:,43), IL_rs_delta(:,44), IL_rs_delta(:,45), IL_rs_delta(:,46), IL_rs_delta(:,47), IL_rs_delta(:,48), IL_rs_delta(:,49), IL_rs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
IL_rs_rm = fitrm(IL_rs_table, 't1-t50 ~ group*subject', 'WithinDesign', Time);
fprintf('IL RS ANOVA:\n')
IL_rs_ranova = ranova(IL_rs_rm)

ORB_mod_rs_delta = ORB_mod_rs_hit-mean(ORB_mod_rs_hit(:,time<0),2);
ORB_unmod_rs_delta = ORB_unmod_rs_hit-mean(ORB_unmod_rs_hit(:,time<0),2);
ORB_mod_rs_delta = ORB_mod_rs_delta(:,time > 0);
ORB_unmod_rs_delta = ORB_unmod_rs_delta(:,time > 0);
ORB_rs_delta = [ORB_mod_rs_delta; ORB_unmod_rs_delta];
ORB_rs_subj = vertcat(ORB_mod_rs_subj, ORB_unmod_rs_subj);
ORB_rs_group = [zeros(size(ORB_mod_rs_delta,1),1); ones(size(ORB_unmod_rs_delta,1),1)];
ORB_rs_table = table(ORB_rs_group, ORB_rs_subj, ...
    ORB_rs_delta(:,1), ORB_rs_delta(:,2), ORB_rs_delta(:,3), ORB_rs_delta(:,4), ORB_rs_delta(:,5), ORB_rs_delta(:,6), ORB_rs_delta(:,7), ORB_rs_delta(:,8), ORB_rs_delta(:,9), ORB_rs_delta(:,10), ...
    ORB_rs_delta(:,11), ORB_rs_delta(:,12), ORB_rs_delta(:,13), ORB_rs_delta(:,14), ORB_rs_delta(:,15), ORB_rs_delta(:,16), ORB_rs_delta(:,17), ORB_rs_delta(:,18), ORB_rs_delta(:,19), ORB_rs_delta(:,20), ...
    ORB_rs_delta(:,21), ORB_rs_delta(:,22), ORB_rs_delta(:,23), ORB_rs_delta(:,24), ORB_rs_delta(:,25), ORB_rs_delta(:,26), ORB_rs_delta(:,27), ORB_rs_delta(:,28), ORB_rs_delta(:,29), ORB_rs_delta(:,30), ...
    ORB_rs_delta(:,31), ORB_rs_delta(:,32), ORB_rs_delta(:,33), ORB_rs_delta(:,34), ORB_rs_delta(:,35), ORB_rs_delta(:,36), ORB_rs_delta(:,37), ORB_rs_delta(:,38), ORB_rs_delta(:,39), ORB_rs_delta(:,40), ...
    ORB_rs_delta(:,41), ORB_rs_delta(:,42), ORB_rs_delta(:,43), ORB_rs_delta(:,44), ORB_rs_delta(:,45), ORB_rs_delta(:,46), ORB_rs_delta(:,47), ORB_rs_delta(:,48), ORB_rs_delta(:,49), ORB_rs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
ORB_rs_rm = fitrm(ORB_rs_table, 't1-t50 ~ group', 'WithinDesign', Time);
fprintf('ORB RS ANOVA:\n')
ORB_rs_ranova = ranova(ORB_rs_rm)

ORB_mod_fs_delta = ORB_mod_fs_hit-mean(ORB_mod_fs_hit(:,time<0),2);
ORB_unmod_fs_delta = ORB_unmod_fs_hit-mean(ORB_unmod_fs_hit(:,time<0),2);
ORB_mod_fs_delta = ORB_mod_fs_delta(:,time > 0);
ORB_unmod_fs_delta = ORB_unmod_fs_delta(:,time > 0);
ORB_fs_delta = [ORB_mod_fs_delta; ORB_unmod_fs_delta];
ORB_fs_subj = vertcat(ORB_mod_fs_subj, ORB_unmod_fs_subj);
ORB_fs_group = [zeros(size(ORB_mod_fs_delta,1),1); ones(size(ORB_unmod_fs_delta,1),1)];
ORB_fs_table = table(ORB_fs_group, ORB_fs_subj, ...
    ORB_fs_delta(:,1), ORB_fs_delta(:,2), ORB_fs_delta(:,3), ORB_fs_delta(:,4), ORB_fs_delta(:,5), ORB_fs_delta(:,6), ORB_fs_delta(:,7), ORB_fs_delta(:,8), ORB_fs_delta(:,9), ORB_fs_delta(:,10), ...
    ORB_fs_delta(:,11), ORB_fs_delta(:,12), ORB_fs_delta(:,13), ORB_fs_delta(:,14), ORB_fs_delta(:,15), ORB_fs_delta(:,16), ORB_fs_delta(:,17), ORB_fs_delta(:,18), ORB_fs_delta(:,19), ORB_fs_delta(:,20), ...
    ORB_fs_delta(:,21), ORB_fs_delta(:,22), ORB_fs_delta(:,23), ORB_fs_delta(:,24), ORB_fs_delta(:,25), ORB_fs_delta(:,26), ORB_fs_delta(:,27), ORB_fs_delta(:,28), ORB_fs_delta(:,29), ORB_fs_delta(:,30), ...
    ORB_fs_delta(:,31), ORB_fs_delta(:,32), ORB_fs_delta(:,33), ORB_fs_delta(:,34), ORB_fs_delta(:,35), ORB_fs_delta(:,36), ORB_fs_delta(:,37), ORB_fs_delta(:,38), ORB_fs_delta(:,39), ORB_fs_delta(:,40), ...
    ORB_fs_delta(:,41), ORB_fs_delta(:,42), ORB_fs_delta(:,43), ORB_fs_delta(:,44), ORB_fs_delta(:,45), ORB_fs_delta(:,46), ORB_fs_delta(:,47), ORB_fs_delta(:,48), ORB_fs_delta(:,49), ORB_fs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
ORB_fs_rm = fitrm(ORB_fs_table, 't1-t50 ~ group', 'WithinDesign', Time);
fprintf('ORB FS ANOVA:\n')
ORB_fs_ranova = ranova(ORB_fs_rm)

DP_mod_rs_delta = DP_mod_rs_hit-mean(DP_mod_rs_hit(:,time<0),2);
DP_unmod_rs_delta = DP_unmod_rs_hit-mean(DP_unmod_rs_hit(:,time<0),2);
DP_mod_rs_delta = DP_mod_rs_delta(:,time > 0);
DP_unmod_rs_delta = DP_unmod_rs_delta(:,time > 0);
DP_rs_delta = [DP_mod_rs_delta; DP_unmod_rs_delta];
DP_rs_subj = vertcat(DP_mod_rs_subj, DP_unmod_rs_subj);
DP_rs_group = [zeros(size(DP_mod_rs_delta,1),1); ones(size(DP_unmod_rs_delta,1),1)];
DP_rs_table = table(DP_rs_group, DP_rs_subj, ...
    DP_rs_delta(:,1), DP_rs_delta(:,2), DP_rs_delta(:,3), DP_rs_delta(:,4), DP_rs_delta(:,5), DP_rs_delta(:,6), DP_rs_delta(:,7), DP_rs_delta(:,8), DP_rs_delta(:,9), DP_rs_delta(:,10), ...
    DP_rs_delta(:,11), DP_rs_delta(:,12), DP_rs_delta(:,13), DP_rs_delta(:,14), DP_rs_delta(:,15), DP_rs_delta(:,16), DP_rs_delta(:,17), DP_rs_delta(:,18), DP_rs_delta(:,19), DP_rs_delta(:,20), ...
    DP_rs_delta(:,21), DP_rs_delta(:,22), DP_rs_delta(:,23), DP_rs_delta(:,24), DP_rs_delta(:,25), DP_rs_delta(:,26), DP_rs_delta(:,27), DP_rs_delta(:,28), DP_rs_delta(:,29), DP_rs_delta(:,30), ...
    DP_rs_delta(:,31), DP_rs_delta(:,32), DP_rs_delta(:,33), DP_rs_delta(:,34), DP_rs_delta(:,35), DP_rs_delta(:,36), DP_rs_delta(:,37), DP_rs_delta(:,38), DP_rs_delta(:,39), DP_rs_delta(:,40), ...
    DP_rs_delta(:,41), DP_rs_delta(:,42), DP_rs_delta(:,43), DP_rs_delta(:,44), DP_rs_delta(:,45), DP_rs_delta(:,46), DP_rs_delta(:,47), DP_rs_delta(:,48), DP_rs_delta(:,49), DP_rs_delta(:,50), ...
    'VariableNames', {'group', 'subject', ...
    't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 't10', ...
    't11', 't12', 't13', 't14', 't15', 't16', 't17', 't18', 't19', 't20', ...
    't21', 't22', 't23', 't24', 't25', 't26', 't27', 't28', 't29', 't30', ...
    't31', 't32', 't33', 't34', 't35', 't36', 't37', 't38', 't39', 't40', ...
    't41', 't42', 't43', 't44', 't45', 't46', 't47', 't48', 't49', 't50'});
DP_rs_rm = fitrm(DP_rs_table, 't1-t50 ~ group', 'WithinDesign', Time);
fprintf('DP RS ANOVA:\n')
DP_rs_ranova = ranova(DP_rs_rm)

pfc_fig = figure('Position', [1452 766 849 1011]);
tl = tiledlayout(4,2);
rs_avg = [nanmean(ac_rs_frac), nanmean(pl_rs_frac), nanmean(il_rs_frac), nanmean(orb_rs_frac), nanmean(dp_rs_frac)];
fs_avg = [nanmean(ac_fs_frac), nanmean(pl_fs_frac), nanmean(il_fs_frac), nanmean(orb_fs_frac), nanmean(dp_fs_frac)];
rs_err = [nanstd(ac_rs_frac)/sqrt(sum(~isnan(ac_rs_frac))), nanstd(pl_rs_frac)/sqrt(sum(~isnan(pl_rs_frac))), nanstd(il_rs_frac)/sqrt(sum(~isnan(il_rs_frac))), nanstd(orb_rs_frac)/sqrt(sum(~isnan(orb_rs_frac))), nanstd(dp_rs_frac)/sqrt(sum(~isnan(dp_rs_frac)))];
fs_err = [nanstd(ac_fs_frac)/sqrt(sum(~isnan(ac_fs_frac))), nanstd(pl_fs_frac)/sqrt(sum(~isnan(pl_fs_frac))), nanstd(il_fs_frac)/sqrt(sum(~isnan(il_fs_frac))), nanstd(orb_fs_frac)/sqrt(sum(~isnan(orb_fs_frac))), nanstd(dp_fs_frac)/sqrt(sum(~isnan(dp_fs_frac)))];
axs(1) = nexttile;
barh(1:5, fliplr(rs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(rs_avg), 1:5, fliplr(rs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'ACC', 'PL', 'IL', 'ORB', 'DP'}))
ylim([0.5,5.5])
xlim([0,1.05])
xticks([0,1.0])
title('Regular Spiking', 'FontSize', 16, 'FontWeight', 'normal')
xlabel('Fraction of Alpha Modulated', 'FontSize', 14)
ylabel('PFC Subregion', 'FontSize', 14)
axs(2) = nexttile;
barh(1:5, fliplr(fs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(fs_avg), 1:5, fliplr(fs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'ACC', 'PL', 'IL', 'ORB', 'DP'}))
ylim([0.5,5.5])
xlim([0,1.05])
xticks([0,1.0])
title('Fast Spiking', 'FontSize', 16, 'FontWeight', 'normal')
xlabel('Fraction of Alpha Modulated', 'FontSize', 14, 'FontWeight', 'normal')

rs_avg = [nanmean(ac_rs_mi), nanmean(pl_rs_mi), nanmean(il_rs_mi), nanmean(orb_rs_mi), nanmean(dp_rs_mi)];
fs_avg = [nanmean(ac_fs_mi), nanmean(pl_fs_mi), nanmean(il_fs_mi), nanmean(orb_fs_mi), nanmean(dp_fs_mi)];
rs_err = [nanstd(ac_rs_mi)/sqrt(sum(~isnan(ac_rs_mi))), nanstd(pl_rs_mi)/sqrt(sum(~isnan(pl_rs_mi))), nanstd(il_rs_mi)/sqrt(sum(~isnan(il_rs_mi))), nanstd(orb_rs_mi)/sqrt(sum(~isnan(orb_rs_mi))), nanstd(dp_rs_mi)/sqrt(sum(~isnan(dp_rs_mi)))];
fs_err = [nanstd(ac_fs_mi)/sqrt(sum(~isnan(ac_fs_mi))), nanstd(pl_fs_mi)/sqrt(sum(~isnan(pl_fs_mi))), nanstd(il_fs_mi)/sqrt(sum(~isnan(il_fs_mi))), nanstd(orb_fs_mi)/sqrt(sum(~isnan(orb_fs_mi))), nanstd(dp_fs_mi)/sqrt(sum(~isnan(dp_fs_mi)))];
axs(3) = nexttile;
barh(1:5, fliplr(rs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(rs_avg), 1:5, fliplr(rs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'ACC', 'PL', 'IL', 'ORB', 'DP'}))
ylim([0.5,5.5])
xlim([0,0.025])
xticks([0,0.025])
xlabel('Modulation Index', 'FontSize', 14)
ylabel('PFC Subregion', 'FontSize', 14)
axs(4) = nexttile;
barh(1:5, fliplr(fs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(fs_avg), 1:5, fliplr(fs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'ACC', 'PL', 'IL', 'ORB', 'DP'}))
ylim([0.5,5.5])
xlim([0,0.025])
xticks([0,0.025])
xlabel('Modulation Index', 'FontSize', 14)

rs_avg = [nanmean(ac_rs_mse), nanmean(pl_rs_mse), nanmean(il_rs_mse), nanmean(orb_rs_mse), nanmean(dp_rs_mse)];
fs_avg = [nanmean(ac_fs_mse), nanmean(pl_fs_mse), nanmean(il_fs_mse), nanmean(orb_fs_mse), nanmean(dp_fs_mse)];
rs_err = [nanstd(ac_rs_mse)/sqrt(sum(~isnan(ac_rs_mse))), nanstd(pl_rs_mse)/sqrt(sum(~isnan(pl_rs_mse))), nanstd(il_rs_mse)/sqrt(sum(~isnan(il_rs_mse))), nanstd(orb_rs_mse)/sqrt(sum(~isnan(orb_rs_mse))), nanstd(dp_rs_mse)/sqrt(sum(~isnan(dp_rs_mse)))];
fs_err = [nanstd(ac_fs_mse)/sqrt(sum(~isnan(ac_fs_mse))), nanstd(pl_fs_mse)/sqrt(sum(~isnan(pl_fs_mse))), nanstd(il_fs_mse)/sqrt(sum(~isnan(il_fs_mse))), nanstd(orb_fs_mse)/sqrt(sum(~isnan(orb_fs_mse))), nanstd(dp_fs_mse)/sqrt(sum(~isnan(dp_fs_mse)))];
axs(5) = nexttile;
barh(1:5, fliplr(rs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(rs_avg), 1:5, fliplr(rs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'ACC', 'PL', 'IL', 'ORB', 'DP'}))
ylim([0.5,5.5])
xlim([0,0.0012])
xticks([0,0.0012])
xlabel('von Mises MSE', 'FontSize', 14)
ylabel('PFC Subregion', 'FontSize', 14)
axs(6) = nexttile;
barh(1:5, fliplr(fs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(fs_avg), 1:5, fliplr(fs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'ACC', 'PL', 'IL', 'ORB', 'DP'}))
ylim([0.5,5.5])
xlim([0,0.0012])
xticks([0,0.0012])
xlabel('von Mises MSE', 'FontSize', 14)

rs_avg = [circ_mean(ac_rs_theta_bar), circ_mean(pl_rs_theta_bar), circ_mean(il_rs_theta_bar), circ_mean(orb_rs_theta_bar), circ_mean(dp_rs_theta_bar)];
fs_avg = [circ_mean(ac_fs_theta_bar), circ_mean(pl_fs_theta_bar), circ_mean(il_fs_theta_bar), circ_mean(orb_fs_theta_bar), circ_mean(dp_fs_theta_bar)];
rs_err = [circ_std(ac_rs_theta_bar)/sqrt(sum(~isnan(ac_rs_theta_bar))), circ_std(pl_rs_theta_bar)/sqrt(sum(~isnan(pl_rs_theta_bar))), circ_std(il_rs_theta_bar)/sqrt(sum(~isnan(il_rs_theta_bar))), circ_std(orb_rs_theta_bar)/sqrt(sum(~isnan(orb_rs_theta_bar))), circ_std(dp_rs_theta_bar)/sqrt(sum(~isnan(dp_rs_theta_bar)))];
fs_err = [circ_std(ac_fs_theta_bar)/sqrt(sum(~isnan(ac_fs_theta_bar))), circ_std(pl_fs_theta_bar)/sqrt(sum(~isnan(pl_fs_theta_bar))), circ_std(il_fs_theta_bar)/sqrt(sum(~isnan(il_fs_theta_bar))), circ_std(orb_fs_theta_bar)/sqrt(sum(~isnan(orb_fs_theta_bar))), circ_std(dp_fs_theta_bar)/sqrt(sum(~isnan(dp_fs_theta_bar)))];
axs(7) = nexttile;
barh(1:5, fliplr(rs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(rs_avg), 1:5, fliplr(rs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'ACC', 'PL', 'IL', 'ORB', 'DP'}))
ylim([0.5,5.5])
xlim([-3.5,3.5])
xticks([-pi,0,pi])
xticklabels({'-\pi', '', '\pi'})
xlabel('Avg. Firing Phase (radians)', 'FontSize', 14)
ylabel('Cortical Layer', 'FontSize', 14)
axs(8) = nexttile;
barh(1:5, fliplr(fs_avg), 'EdgeColor', [0.5,0.5,0.5], 'FaceColor', [0.5,0.5,0.5])
hold on
errorbar(fliplr(fs_avg), 1:5, fliplr(fs_err), 'horizontal', 'k.')
yticks(1:5)
yticklabels(fliplr({'ACC', 'PL', 'IL', 'ORB', 'DP'}))
ylim([0.5,5.5])
xlim([-3.5,3.5])
xticks([-pi,0,pi])
xticklabels({'-\pi', '', '\pi'})
xlabel('Avg. Firing Phase (radians)', 'FontSize', 14, 'FontWeight', 'normal')

if out_path
    saveas(pfc_fig, 'Figures/pfc_distribution.fig')
    saveas(pfc_fig, 'Figures/pfc_distribution.svg')
end
fprintf(sprintf('Avg. Fraction AC RS: %d\n', nanmean(ac_rs_frac)))
fprintf(sprintf('Avg. Fraction PL/3 RS: %d\n', nanmean(pl_rs_frac)))
fprintf(sprintf('Avg. Fraction IL RS: %d\n', nanmean(il_rs_frac)))
fprintf(sprintf('Avg. Fraction ORB RS: %d\n', nanmean(orb_rs_frac)))
fprintf(sprintf('Avg. Fraction DP RS: %d\n', nanmean(dp_rs_frac)))
fprintf(sprintf('Avg. Fraction AC FS: %d\n', nanmean(ac_fs_frac)))
fprintf(sprintf('Avg. Fraction PL/3 FS: %d\n', nanmean(pl_fs_frac)))
fprintf(sprintf('Avg. Fraction IL FS: %d\n', nanmean(il_fs_frac)))
fprintf(sprintf('Avg. Fraction ORB FS: %d\n', nanmean(orb_fs_frac)))
fprintf(sprintf('Avg. Fraction DP FS: %d\n', nanmean(dp_fs_frac)))
fprintf(sprintf('Avg. MI AC RS: %d\n', nanmean(ac_rs_mi)))
fprintf(sprintf('Avg. MI PL/3 RS: %d\n', nanmean(pl_rs_mi)))
fprintf(sprintf('Avg. MI IL RS: %d\n', nanmean(il_rs_mi)))
fprintf(sprintf('Avg. MI ORB RS: %d\n', nanmean(orb_rs_mi)))
fprintf(sprintf('Avg. MI DP RS: %d\n', nanmean(dp_rs_mi)))
fprintf(sprintf('Avg. MI AC FS: %d\n', nanmean(ac_fs_mi)))
fprintf(sprintf('Avg. MI PL/3 FS: %d\n', nanmean(pl_fs_mi)))
fprintf(sprintf('Avg. MI IL FS: %d\n', nanmean(il_fs_mi)))
fprintf(sprintf('Avg. MI ORB FS: %d\n', nanmean(orb_fs_mi)))
fprintf(sprintf('Avg. MI DP FS: %d\n', nanmean(dp_fs_mi)))
fprintf(sprintf('Avg. MSE AC RS: %d\n', nanmean(ac_rs_mse)))
fprintf(sprintf('Avg. MSE PL/3 RS: %d\n', nanmean(pl_rs_mse)))
fprintf(sprintf('Avg. MSE IL RS: %d\n', nanmean(il_rs_mse)))
fprintf(sprintf('Avg. MSE ORB RS: %d\n', nanmean(orb_rs_mse)))
fprintf(sprintf('Avg. MSE DP RS: %d\n', nanmean(dp_rs_mse)))
fprintf(sprintf('Avg. MSE AC FS: %d\n', nanmean(ac_fs_mse)))
fprintf(sprintf('Avg. MSE PL/3 FS: %d\n', nanmean(pl_fs_mse)))
fprintf(sprintf('Avg. MSE IL FS: %d\n', nanmean(il_fs_mse)))
fprintf(sprintf('Avg. MSE ORB FS: %d\n', nanmean(orb_fs_mse)))
fprintf(sprintf('Avg. MSE DP FS: %d\n', nanmean(dp_fs_mse)))
 
pfc_rs_mat = [ac_rs_frac', pl_rs_frac', ...
    il_rs_frac', orb_rs_frac', dp_rs_frac'];
fprintf(sprintf('PFC RS Fractions ANOVA:\n'))
[p, ~, stats] = anova1(pfc_rs_mat)
 
pfc_fs_mat = [ac_fs_frac', pl_fs_frac', ...
    il_fs_frac', orb_fs_frac', dp_fs_frac'];
fprintf(sprintf('PFC FS Fractions ANOVA:\n'))
[p, ~, stats] = anova1(pfc_fs_mat)
 
maxN = max([size(ac_rs_mi,1),size(pl_rs_mi,1),size(il_rs_mi,1),...
    size(orb_rs_mi,1), size(dp_rs_mi,1)]);
pfc_rs_mi_mat = [[ac_rs_mi; nan(maxN-length(ac_rs_mi),1)], ...
    [pl_rs_mi; nan(maxN-length(pl_rs_mi),1)], ...
    [il_rs_mi; nan(maxN-length(il_rs_mi),1)], ...
    [orb_rs_mi; nan(maxN-length(orb_rs_mi),1)], ...
    [dp_rs_mi; nan(maxN-length(dp_rs_mi),1)]];
fprintf(sprintf('PFC RS MI ANOVA:\n'))
[p, ~, stats] = anova1(pfc_rs_mi_mat)
 
maxN = max([size(ac_fs_mi,1),size(pl_fs_mi,1),size(il_fs_mi,1),...
    size(orb_fs_mi,1), size(dp_fs_mi,1)]);
pfc_fs_mi_mat = [[ac_fs_mi; nan(maxN-length(ac_fs_mi),1)], ...
    [pl_fs_mi; nan(maxN-length(pl_fs_mi),1)], ...
    [il_fs_mi; nan(maxN-length(il_fs_mi),1)], ...
    [orb_fs_mi; nan(maxN-length(orb_fs_mi),1)], ...
    [dp_fs_mi; nan(maxN-length(dp_fs_mi),1)]];
fprintf(sprintf('PFC FS MI ANOVA:\n'))
[p, ~, stats] = anova1(pfc_fs_mi_mat)
 
maxN = max([size(ac_rs_mse,1),size(pl_rs_mse,1),size(il_rs_mse,1),...
    size(orb_rs_mse,1), size(dp_rs_mse,1)]);
pfc_rs_mse_mat = [[ac_rs_mse; nan(maxN-length(ac_rs_mse),1)], ...
    [pl_rs_mse; nan(maxN-length(pl_rs_mse),1)], ...
    [il_rs_mse; nan(maxN-length(il_rs_mse),1)], ...
    [orb_rs_mse; nan(maxN-length(orb_rs_mse),1)], ...
    [dp_rs_mse; nan(maxN-length(dp_rs_mse),1)]];
fprintf(sprintf('PFC RS MSE ANOVA:\n'))
[p, ~, stats] = anova1(pfc_rs_mse_mat)
 
maxN = max([size(ac_fs_mse,1),size(pl_fs_mse,1),size(il_fs_mse,1),...
    size(orb_fs_mse,1), size(dp_fs_mse,1)]);
pfc_fs_mse_mat = [[ac_fs_mse; nan(maxN-length(ac_fs_mse),1)], ...
    [pl_fs_mse; nan(maxN-length(pl_fs_mse),1)], ...
    [il_fs_mse; nan(maxN-length(il_fs_mse),1)], ...
    [orb_fs_mse; nan(maxN-length(orb_fs_mse),1)], ...
    [dp_fs_mse; nan(maxN-length(dp_fs_mse),1)]];
fprintf(sprintf('PFC FS MSE ANOVA:\n'))
[p, ~, stats] = anova1(pfc_fs_mse_mat)

maxN = max([size(ac_fs_theta_bar,1),size(pl_fs_theta_bar,1),size(il_fs_theta_bar,1),...
    size(orb_fs_theta_bar,1), size(dp_fs_theta_bar,1)]);
pfc_fs_theta_bar_mat = [[ac_fs_theta_bar; nan(maxN-length(ac_fs_theta_bar),1)], ...
    [pl_fs_theta_bar; nan(maxN-length(pl_fs_theta_bar),1)], ...
    [il_fs_theta_bar; nan(maxN-length(il_fs_theta_bar),1)], ...
    [orb_fs_theta_bar; nan(maxN-length(orb_fs_theta_bar),1)], ...
    [dp_fs_theta_bar; nan(maxN-length(dp_fs_theta_bar),1)]];
fprintf(sprintf('PFC FS Theta Bar ANOVA:\n'))
[p, ~, stats] = anova1(pfc_fs_theta_bar_mat)

maxN = max([size(ac_rs_theta_bar,1),size(pl_rs_theta_bar,1),size(il_rs_theta_bar,1),...
    size(orb_rs_theta_bar,1), size(dp_rs_theta_bar,1)]);
pfc_rs_theta_bar_mat = [[ac_rs_theta_bar; nan(maxN-length(ac_rs_theta_bar),1)], ...
    [pl_rs_theta_bar; nan(maxN-length(pl_rs_theta_bar),1)], ...
    [il_rs_theta_bar; nan(maxN-length(il_rs_theta_bar),1)], ...
    [orb_rs_theta_bar; nan(maxN-length(orb_rs_theta_bar),1)], ...
    [dp_rs_theta_bar; nan(maxN-length(dp_rs_theta_bar),1)]];
fprintf(sprintf('PFC RS MSE ANOVA:\n'))
[p, ~, stats] = anova1(pfc_rs_theta_bar_mat)

maxN = max([size(s1_l1_fs_theta_bar,1),size(s1_l2_fs_theta_bar,1),size(s1_l4_fs_theta_bar,1),...
    size(s1_l5_fs_theta_bar,1), size(s1_l6_fs_theta_bar,1)]);
s1_fs_theta_bar_mat = [[s1_l1_fs_theta_bar; nan(maxN-length(s1_l1_fs_theta_bar),1)], ...
    [s1_l2_fs_theta_bar; nan(maxN-length(s1_l2_fs_theta_bar),1)], ...
    [s1_l4_fs_theta_bar; nan(maxN-length(s1_l4_fs_theta_bar),1)], ...
    [s1_l5_fs_theta_bar; nan(maxN-length(s1_l5_fs_theta_bar),1)], ...
    [s1_l6_fs_theta_bar; nan(maxN-length(s1_l6_fs_theta_bar),1)]];
fprintf(sprintf('S1 FS Theta Bar ANOVA:\n'))
[p, ~, stats] = anova1(s1_fs_theta_bar_mat)

maxN = max([size(s1_l1_rs_theta_bar,1),size(s1_l2_rs_theta_bar,1),size(s1_l4_rs_theta_bar,1),...
    size(s1_l5_rs_theta_bar,1), size(s1_l6_rs_theta_bar,1)]);
s1_rs_theta_bar_mat = [[s1_l1_rs_theta_bar; nan(maxN-length(s1_l1_rs_theta_bar),1)], ...
    [s1_l2_rs_theta_bar; nan(maxN-length(s1_l2_rs_theta_bar),1)], ...
    [s1_l4_rs_theta_bar; nan(maxN-length(s1_l4_rs_theta_bar),1)], ...
    [s1_l5_rs_theta_bar; nan(maxN-length(s1_l5_rs_theta_bar),1)], ...
    [s1_l6_rs_theta_bar; nan(maxN-length(s1_l6_rs_theta_bar),1)]];
fprintf(sprintf('S1 RS MSE ANOVA:\n'))
[p, ~, stats] = anova1(s1_rs_theta_bar_mat)



    % exec_str = sprintf("l%s_mod_rs_delta = l%s_mod_rs_hit-mean(l%s_mod_rs_hit(:,time<0),2),2);", layer, layer, layer);
    % eval(exec_str)
    % exec_str = sprintf("l%s_unmod_rs_delta = l%s_unmod_rs_hit-mean(l%s_unmod_rs_hit(:,time<0),2),2);", layer, layer, layer);
    % eval(exec_str)
    % exec_str = sprintf("l%s_mod_rs_delta = l%s_mod_rs_delta(:,time > 0);", layer, layer);
    % eval(exec_str)
    % exec_str = sprintf("l%s_unmod_rs_delta = l%s_unmod_rs_delta(:,time > 0);", layer, layer);
    % eval(exec_str)
    % exec_str = sprintf("l%s_mod_fs_delta = l%s_mod_fs_hit-mean(l%s_mod_fs_hit(:,time<0),2),2);", layer, layer, layer);
    % try
    %     eval(exec_str)
    % end
    % exec_str = sprintf("l%s_unmod_fs_delta = l%s_unmod_fs_hit-mean(l%s_unmod_fs_hit(:,time<0),2),2);", layer, layer, layer);
    % try
    %     eval(exec_str)
    % end
    % exec_str = sprintf("l%s_mod_fs_delta = l%s_mod_fs_delta(:,time > 0);", layer, layer);
    % try
    %     eval(exec_str)
    % end
    % exec_str = sprintf("l%s_unmod_fs_delta = l%s_unmod_fs_delta(:,time > 0);", layer, layer);
    % try
    %     eval(exec_str)
    % end