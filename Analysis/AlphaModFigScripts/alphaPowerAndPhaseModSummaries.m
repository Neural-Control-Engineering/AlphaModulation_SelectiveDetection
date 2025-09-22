addpath(genpath('~/circstat-matlab/'))
delete Stats/alpha_power_and_phase_mod.txt 
diary Stats/alpha_power_and_phase_mod.txt 
init_paths;
load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Revision/Cortex/Spontaneous_Alpha_Modulation/data.mat'))
out_path = false; %true;
alpha_modulated = out.alpha_modulated;
p_threshold = out.overall_p_threshold;
clear out 
out_file = strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Revision/Cortex/Spontaneous_Alpha_Modulation/high_v_low_alpha.mat');
load(out_file)

out.low_mi = out.low_mi(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.high_mi = out.high_mi(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.low_mse = out.low_mse(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.high_mse = out.high_mse(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.theta_bar_low = out.theta_bar_low(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.theta_bar_high = out.theta_bar_high(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.low_p = out.low_p(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.high_p = out.high_p(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.low_firing_rates = out.low_firing_rates(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.high_firing_rates = out.high_firing_rates(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.n_low_events = out.n_low_events(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.n_high_events = out.n_high_events(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
alpha_modulated = alpha_modulated(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);

exinds = load('ExcldInds/3738_excld_v2.mat');
for i = 1:length(exinds.new_excld{1})
    session_id = exinds.new_excld{1}{i};
    cid = exinds.new_excld{2}{i};
    out.low_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_low(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_high(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_low_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_high_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    alpha_modulated(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
end
exinds = load('ExcldInds/3387_excld.mat');
for i = 1:length(exinds.excld{1})
    session_id = exinds.excld{1}{i};
    cid = exinds.excld{2}{i};
    out.low_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_low(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_high(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_low_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_high_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    alpha_modulated(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
end

session_ids = unique(alpha_modulated.session_id);
for s = 1:length(session_ids)
    low_p = out.low_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'RS'));
    high_p = out.high_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'RS'));
    s1_rs_frac_low(s) = sum(low_p < p_threshold) / length(low_p);
    s1_rs_frac_high(s) = sum(high_p < p_threshold) / length(high_p);
    low_p = out.low_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'FS'));
    high_p = out.high_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'FS'));
    s1_fs_frac_low(s) = sum(low_p < p_threshold) / length(low_p);
    s1_fs_frac_high(s) = sum(high_p < p_threshold) / length(high_p);
end

s1_rs_low_mi = out.low_mi(strcmp(alpha_modulated.waveform_class, 'RS'));
s1_rs_high_mi = out.high_mi(strcmp(alpha_modulated.waveform_class, 'RS'));
s1_rs_low_mse = out.low_mse(strcmp(alpha_modulated.waveform_class, 'RS'));
s1_rs_high_mse = out.high_mse(strcmp(alpha_modulated.waveform_class, 'RS'));
s1_rs_theta_bar_low = out.theta_bar_low(strcmp(alpha_modulated.waveform_class, 'RS'));
s1_rs_theta_bar_high = out.theta_bar_high(strcmp(alpha_modulated.waveform_class, 'RS'));
s1_fs_low_mse = out.low_mse(strcmp(alpha_modulated.waveform_class, 'FS'));
s1_fs_high_mse = out.high_mse(strcmp(alpha_modulated.waveform_class, 'FS'));
s1_fs_theta_bar_low = out.theta_bar_low(strcmp(alpha_modulated.waveform_class, 'FS'));
s1_fs_theta_bar_high = out.theta_bar_high(strcmp(alpha_modulated.waveform_class, 'FS'));
s1_rs_low_p = out.low_p(strcmp(alpha_modulated.waveform_class, 'RS'));
s1_rs_high_p = out.high_p(strcmp(alpha_modulated.waveform_class, 'RS'));
s1_fs_low_mi = out.low_mi(strcmp(alpha_modulated.waveform_class, 'FS'));
s1_fs_high_mi = out.high_mi(strcmp(alpha_modulated.waveform_class, 'FS'));
s1_fs_low_p = out.low_p(strcmp(alpha_modulated.waveform_class, 'FS'));
s1_fs_high_p = out.high_p(strcmp(alpha_modulated.waveform_class, 'FS'));
s1_fs_low_fr = out.low_firing_rates(strcmp(alpha_modulated.waveform_class, 'FS'));
s1_fs_high_fr = out.high_firing_rates(strcmp(alpha_modulated.waveform_class, 'FS'));
s1_rs_low_fr = out.low_firing_rates(strcmp(alpha_modulated.waveform_class, 'RS'));
s1_rs_high_fr = out.high_firing_rates(strcmp(alpha_modulated.waveform_class, 'RS'));
s1_fs_low_n_events = out.n_low_events(strcmp(alpha_modulated.waveform_class, 'FS'));
s1_fs_high_n_events = out.n_high_events(strcmp(alpha_modulated.waveform_class, 'FS'));
s1_rs_low_n_events = out.n_low_events(strcmp(alpha_modulated.waveform_class, 'RS'));
s1_rs_high_n_events = out.n_high_events(strcmp(alpha_modulated.waveform_class, 'RS'));
s1_rs_excld = find(s1_rs_high_mse > 0.1);
s1_rs_low_mi(s1_rs_excld) = [];
s1_rs_high_mi(s1_rs_excld) = [];
s1_rs_low_mse(s1_rs_excld) = [];
s1_rs_high_mse(s1_rs_excld) = [];
s1_rs_theta_bar_low(s1_rs_excld) = [];
s1_rs_theta_bar_high(s1_rs_excld) = [];
s1_rs_low_p(s1_rs_excld) = [];
s1_rs_high_p(s1_rs_excld) = [];
s1_rs_low_fr(s1_rs_excld) = [];
s1_rs_high_fr(s1_rs_excld) = [];
s1_rs_low_n_events(s1_rs_excld) = [];
s1_rs_high_n_events(s1_rs_excld) = [];
s1_rs_low_mi_avg = nanmean(s1_rs_low_mi);
s1_rs_high_mi_avg = nanmean(s1_rs_high_mi);
s1_rs_low_mi_err = nanstd(s1_rs_low_mi) ./ sqrt(sum(~isnan(s1_rs_low_mi)));
s1_rs_high_mi_err = nanstd(s1_rs_high_mi) ./ sqrt(sum(~isnan(s1_rs_high_mi)));
s1_fs_low_mi_avg = nanmean(s1_fs_low_mi);
s1_fs_high_mi_avg = nanmean(s1_fs_high_mi);
s1_fs_low_mi_err = nanstd(s1_fs_low_mi) ./ sqrt(sum(~isnan(s1_fs_low_mi)));
s1_fs_high_mi_err = nanstd(s1_fs_high_mi) ./ sqrt(sum(~isnan(s1_fs_high_mi)));
s1_rs_low_fr_avg = nanmean(s1_rs_low_fr);
s1_rs_high_fr_avg = nanmean(s1_rs_high_fr);
s1_rs_low_fr_err = nanstd(s1_rs_low_fr) ./ sqrt(sum(~isnan(s1_rs_low_fr)));
s1_rs_high_fr_err = nanstd(s1_rs_high_fr) ./ sqrt(sum(~isnan(s1_rs_high_fr)));
s1_fs_low_fr_avg = nanmean(s1_fs_low_fr);
s1_fs_high_fr_avg = nanmean(s1_fs_high_fr);
s1_fs_low_fr_err = nanstd(s1_fs_low_fr) ./ sqrt(sum(~isnan(s1_fs_low_fr)));
s1_fs_high_fr_err = nanstd(s1_fs_high_fr) ./ sqrt(sum(~isnan(s1_fs_high_fr)));
s1_rs_low_mse_avg = nanmean(s1_rs_low_mse);
s1_rs_high_mse_avg = nanmean(s1_rs_high_mse);
s1_rs_low_mse_err = nanstd(s1_rs_low_mse) ./ sqrt(sum(~isnan(s1_rs_low_mse)));
s1_rs_high_mse_err = nanstd(s1_rs_high_mse) ./ sqrt(sum(~isnan(s1_rs_high_mse)));
s1_fs_low_mse_avg = nanmean(s1_fs_low_mse);
s1_fs_high_mse_avg = nanmean(s1_fs_high_mse);
s1_fs_low_mse_err = nanstd(s1_fs_low_mse) ./ sqrt(sum(~isnan(s1_fs_low_mse)));
s1_fs_high_mse_err = nanstd(s1_fs_high_mse) ./ sqrt(sum(~isnan(s1_fs_high_mse)));

load(strcat(ftr_path, '/AP/FIG/PFC_Expert_Combo_Revision/PFC/Spontaneous_Alpha_Modulation/data.mat'))
alpha_modulated = out.alpha_modulated;
p_threshold = out.overall_p_threshold;
clear out 
out_file = strcat(ftr_path, '/AP/FIG/PFC_Expert_Combo_Revision/PFC/Spontaneous_Alpha_Modulation/high_v_low_alpha.mat');
load(out_file)


inds = find(contains(alpha_modulated.region, 'AC') & strcmp(alpha_modulated.waveform_class, 'RS') & cell2mat(alpha_modulated.avg_trial_fr) > 15);
for i = 1:length(inds)
    alpha_modulated(inds(i),:).waveform_class{1} = 'FS';
end

out.low_mi = out.low_mi(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.high_mi = out.high_mi(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.low_mse = out.low_mse(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.high_mse = out.high_mse(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.theta_bar_low = out.theta_bar_low(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.theta_bar_high = out.theta_bar_high(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.low_p = out.low_p(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.high_p = out.high_p(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.low_firing_rates = out.low_firing_rates(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.high_firing_rates = out.high_firing_rates(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.n_low_events = out.n_low_events(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.n_high_events = out.n_high_events(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
alpha_modulated = alpha_modulated(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);

exinds = load('ExcldInds/3755_excld.mat');
for i = 1:length(exinds.excld{1})
    session_id = exinds.excld{1}{i};
    cid = exinds.excld{2}{i};
    out.low_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_low(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_high(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_low_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_high_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    alpha_modulated(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
end
exinds = load('ExcldInds/1075_excld.mat');
for i = 1:length(exinds.excld{1})
    session_id = exinds.excld{1}{i};
    cid = exinds.excld{2}{i};
    out.low_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_low(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_high(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_low_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_high_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    alpha_modulated(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
end

pfc_rs_low_mi = out.low_mi(strcmp(alpha_modulated.waveform_class, 'RS'));
pfc_rs_high_mi = out.high_mi(strcmp(alpha_modulated.waveform_class, 'RS'));
pfc_rs_low_p = out.low_p(strcmp(alpha_modulated.waveform_class, 'RS'));
pfc_rs_high_p = out.high_p(strcmp(alpha_modulated.waveform_class, 'RS'));
pfc_fs_low_mi = out.low_mi(strcmp(alpha_modulated.waveform_class, 'FS'));
pfc_fs_high_mi = out.high_mi(strcmp(alpha_modulated.waveform_class, 'FS'));
pfc_fs_low_p = out.low_p(strcmp(alpha_modulated.waveform_class, 'FS'));
pfc_fs_high_p = out.high_p(strcmp(alpha_modulated.waveform_class, 'FS'));
pfc_fs_low_fr = out.low_firing_rates(strcmp(alpha_modulated.waveform_class, 'FS'));
pfc_fs_high_fr = out.high_firing_rates(strcmp(alpha_modulated.waveform_class, 'FS'));
pfc_rs_low_fr = out.low_firing_rates(strcmp(alpha_modulated.waveform_class, 'RS'));
pfc_rs_high_fr = out.high_firing_rates(strcmp(alpha_modulated.waveform_class, 'RS'));
pfc_fs_low_n_events = out.n_low_events(strcmp(alpha_modulated.waveform_class, 'FS'));
pfc_fs_high_n_events = out.n_high_events(strcmp(alpha_modulated.waveform_class, 'FS'));
pfc_rs_low_n_events = out.n_low_events(strcmp(alpha_modulated.waveform_class, 'RS'));
pfc_rs_high_n_events = out.n_high_events(strcmp(alpha_modulated.waveform_class, 'RS'));
pfc_rs_low_mse = out.low_mse(strcmp(alpha_modulated.waveform_class, 'RS'));
pfc_rs_high_mse = out.high_mse(strcmp(alpha_modulated.waveform_class, 'RS'));
pfc_rs_theta_bar_low = out.theta_bar_low(strcmp(alpha_modulated.waveform_class, 'RS'));
pfc_rs_theta_bar_high = out.theta_bar_high(strcmp(alpha_modulated.waveform_class, 'RS'));
pfc_fs_low_mse = out.low_mse(strcmp(alpha_modulated.waveform_class, 'FS'));
pfc_fs_high_mse = out.high_mse(strcmp(alpha_modulated.waveform_class, 'FS'));
pfc_fs_theta_bar_low = out.theta_bar_low(strcmp(alpha_modulated.waveform_class, 'FS'));
pfc_fs_theta_bar_high = out.theta_bar_high(strcmp(alpha_modulated.waveform_class, 'FS'));
pfc_rs_excld = sort(unique([find(pfc_rs_high_mse > 0.1); find(pfc_rs_low_mse > 0.1)]));
pfc_rs_low_mi(pfc_rs_excld) = [];
pfc_rs_high_mi(pfc_rs_excld) = [];
pfc_rs_low_mse(pfc_rs_excld) = [];
pfc_rs_high_mse(pfc_rs_excld) = [];
pfc_rs_theta_bar_low(pfc_rs_excld) = [];
pfc_rs_theta_bar_high(pfc_rs_excld) = [];
pfc_rs_low_p(pfc_rs_excld) = [];
pfc_rs_high_p(pfc_rs_excld) = [];
pfc_rs_low_fr(pfc_rs_excld) = [];
pfc_rs_high_fr(pfc_rs_excld) = [];
pfc_rs_low_n_events(pfc_rs_excld) = [];
pfc_rs_high_n_events(pfc_rs_excld) = [];
pfc_rs_low_mi_avg = nanmean(pfc_rs_low_mi);
pfc_rs_high_mi_avg = nanmean(pfc_rs_high_mi);
pfc_rs_low_mi_err = nanstd(pfc_rs_low_mi) ./ sqrt(sum(~isnan(pfc_rs_low_mi)));
pfc_rs_high_mi_err = nanstd(pfc_rs_high_mi) ./ sqrt(sum(~isnan(pfc_rs_high_mi)));
pfc_fs_low_mi_avg = nanmean(pfc_fs_low_mi);
pfc_fs_high_mi_avg = nanmean(pfc_fs_high_mi);
pfc_fs_low_mi_err = nanstd(pfc_fs_low_mi) ./ sqrt(sum(~isnan(pfc_fs_low_mi)));
pfc_fs_high_mi_err = nanstd(pfc_fs_high_mi) ./ sqrt(sum(~isnan(pfc_fs_high_mi)));
pfc_rs_low_fr_avg = nanmean(pfc_rs_low_fr);
pfc_rs_high_fr_avg = nanmean(pfc_rs_high_fr);
pfc_rs_low_fr_err = nanstd(pfc_rs_low_fr) ./ sqrt(sum(~isnan(pfc_rs_low_fr)));
pfc_rs_high_fr_err = nanstd(pfc_rs_high_fr) ./ sqrt(sum(~isnan(pfc_rs_high_fr)));
pfc_fs_low_fr_avg = nanmean(pfc_fs_low_fr);
pfc_fs_high_fr_avg = nanmean(pfc_fs_high_fr);
pfc_fs_low_fr_err = nanstd(pfc_fs_low_fr) ./ sqrt(sum(~isnan(pfc_fs_low_fr)));
pfc_fs_high_fr_err = nanstd(pfc_fs_high_fr) ./ sqrt(sum(~isnan(pfc_fs_high_fr)));
pfc_rs_low_mse_avg = nanmean(pfc_rs_low_mse);
pfc_rs_high_mse_avg = nanmean(pfc_rs_high_mse);
pfc_rs_low_mse_err = nanstd(pfc_rs_low_mse) ./ sqrt(sum(~isnan(pfc_rs_low_mse)));
pfc_rs_high_mse_err = nanstd(pfc_rs_high_mse) ./ sqrt(sum(~isnan(pfc_rs_high_mse)));
pfc_fs_low_mse_avg = nanmean(pfc_fs_low_mse);
pfc_fs_high_mse_avg = nanmean(pfc_fs_high_mse);
pfc_fs_low_mse_err = nanstd(pfc_fs_low_mse) ./ sqrt(sum(~isnan(pfc_fs_low_mse)));
pfc_fs_high_mse_err = nanstd(pfc_fs_high_mse) ./ sqrt(sum(~isnan(pfc_fs_high_mse)));

session_ids = unique(alpha_modulated.session_id);
for s = 1:length(session_ids)
    low_p = out.low_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'RS'));
    high_p = out.high_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'RS'));
    pfc_rs_frac_low(s) = sum(low_p < p_threshold) / length(low_p);
    pfc_rs_frac_high(s) = sum(high_p < p_threshold) / length(high_p);
    low_p = out.low_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'FS'));
    high_p = out.high_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'FS'));
    pfc_fs_frac_low(s) = sum(low_p < p_threshold) / length(low_p);
    pfc_fs_frac_high(s) = sum(high_p < p_threshold) / length(high_p);
end

load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Revision/Basal_Ganglia/Spontaneous_Alpha_Modulation/data.mat'))
alpha_modulated = out.alpha_modulated;
p_threshold = out.overall_p_threshold;
clear out 
out_file = strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Revision/Basal_Ganglia/Spontaneous_Alpha_Modulation/high_v_low_alpha.mat');
load(out_file)

out.low_mi = out.low_mi(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.high_mi = out.high_mi(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.low_mse = out.low_mse(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.high_mse = out.high_mse(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.theta_bar_low = out.theta_bar_low(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.theta_bar_high = out.theta_bar_high(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.low_p = out.low_p(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.high_p = out.high_p(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.low_firing_rates = out.low_firing_rates(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.high_firing_rates = out.high_firing_rates(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.n_low_events = out.n_low_events(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.n_high_events = out.n_high_events(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
alpha_modulated = alpha_modulated(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);

exinds = load('ExcldInds/3738_excld_v2.mat');
for i = 1:length(exinds.new_excld{1})
    session_id = exinds.new_excld{1}{i};
    cid = exinds.new_excld{2}{i};
    out.low_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_low(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_high(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_low_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_high_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    alpha_modulated(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
end
exinds = load('ExcldInds/3387_excld.mat');
for i = 1:length(exinds.excld{1})
    session_id = exinds.excld{1}{i};
    cid = exinds.excld{2}{i};
    out.low_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_low(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_high(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_low_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_high_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    alpha_modulated(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
end

striatum_rs_low_mi = out.low_mi(strcmp(alpha_modulated.waveform_class, 'RS'));
striatum_rs_high_mi = out.high_mi(strcmp(alpha_modulated.waveform_class, 'RS'));
striatum_rs_low_p = out.low_p(strcmp(alpha_modulated.waveform_class, 'RS'));
striatum_rs_high_p = out.high_p(strcmp(alpha_modulated.waveform_class, 'RS'));
striatum_fs_low_mi = out.low_mi(strcmp(alpha_modulated.waveform_class, 'FS'));
striatum_fs_high_mi = out.high_mi(strcmp(alpha_modulated.waveform_class, 'FS'));
striatum_fs_low_p = out.low_p(strcmp(alpha_modulated.waveform_class, 'FS'));
striatum_fs_high_p = out.high_p(strcmp(alpha_modulated.waveform_class, 'FS'));
striatum_fs_low_fr = out.low_firing_rates(strcmp(alpha_modulated.waveform_class, 'FS'));
striatum_fs_high_fr = out.high_firing_rates(strcmp(alpha_modulated.waveform_class, 'FS'));
striatum_rs_low_fr = out.low_firing_rates(strcmp(alpha_modulated.waveform_class, 'RS'));
striatum_rs_high_fr = out.high_firing_rates(strcmp(alpha_modulated.waveform_class, 'RS'));
striatum_fs_low_n_events = out.n_low_events(strcmp(alpha_modulated.waveform_class, 'FS'));
striatum_fs_high_n_events = out.n_high_events(strcmp(alpha_modulated.waveform_class, 'FS'));
striatum_rs_low_n_events = out.n_low_events(strcmp(alpha_modulated.waveform_class, 'RS'));
striatum_rs_high_n_events = out.n_high_events(strcmp(alpha_modulated.waveform_class, 'RS'));
striatum_rs_low_mse = out.low_mse(strcmp(alpha_modulated.waveform_class, 'RS'));
striatum_rs_high_mse = out.high_mse(strcmp(alpha_modulated.waveform_class, 'RS'));
striatum_rs_theta_bar_low = out.theta_bar_low(strcmp(alpha_modulated.waveform_class, 'RS'));
striatum_rs_theta_bar_high = out.theta_bar_high(strcmp(alpha_modulated.waveform_class, 'RS'));
striatum_fs_low_mse = out.low_mse(strcmp(alpha_modulated.waveform_class, 'FS'));
striatum_fs_high_mse = out.high_mse(strcmp(alpha_modulated.waveform_class, 'FS'));
striatum_fs_theta_bar_low = out.theta_bar_low(strcmp(alpha_modulated.waveform_class, 'FS'));
striatum_fs_theta_bar_high = out.theta_bar_high(strcmp(alpha_modulated.waveform_class, 'FS'));
striatum_rs_excld = sort(unique([find(striatum_rs_high_mse > 0.1); find(striatum_rs_low_mse > 0.1)]));
striatum_rs_low_mi(striatum_rs_excld) = [];
striatum_rs_high_mi(striatum_rs_excld) = [];
striatum_rs_low_mse(striatum_rs_excld) = [];
striatum_rs_high_mse(striatum_rs_excld) = [];
striatum_rs_theta_bar_low(striatum_rs_excld) = [];
striatum_rs_theta_bar_high(striatum_rs_excld) = [];
striatum_rs_low_p(striatum_rs_excld) = [];
striatum_rs_high_p(striatum_rs_excld) = [];
striatum_rs_low_fr(striatum_rs_excld) = [];
striatum_rs_high_fr(striatum_rs_excld) = [];
striatum_rs_low_n_events(striatum_rs_excld) = [];
striatum_rs_high_n_events(striatum_rs_excld) = [];
striatum_rs_low_mi_avg = nanmean(striatum_rs_low_mi);
striatum_rs_high_mi_avg = nanmean(striatum_rs_high_mi);
striatum_rs_low_mi_err = nanstd(striatum_rs_low_mi) ./ sqrt(sum(~isnan(striatum_rs_low_mi)));
striatum_rs_high_mi_err = nanstd(striatum_rs_high_mi) ./ sqrt(sum(~isnan(striatum_rs_high_mi)));
striatum_fs_low_mi_avg = nanmean(striatum_fs_low_mi);
striatum_fs_high_mi_avg = nanmean(striatum_fs_high_mi);
striatum_fs_low_mi_err = nanstd(striatum_fs_low_mi) ./ sqrt(sum(~isnan(striatum_fs_low_mi)));
striatum_fs_high_mi_err = nanstd(striatum_fs_high_mi) ./ sqrt(sum(~isnan(striatum_fs_high_mi)));
striatum_rs_low_fr_avg = nanmean(striatum_rs_low_fr);
striatum_rs_high_fr_avg = nanmean(striatum_rs_high_fr);
striatum_rs_low_fr_err = nanstd(striatum_rs_low_fr) ./ sqrt(sum(~isnan(striatum_rs_low_fr)));
striatum_rs_high_fr_err = nanstd(striatum_rs_high_fr) ./ sqrt(sum(~isnan(striatum_rs_high_fr)));
striatum_fs_low_fr_avg = nanmean(striatum_fs_low_fr);
striatum_fs_high_fr_avg = nanmean(striatum_fs_high_fr);
striatum_fs_low_fr_err = nanstd(striatum_fs_low_fr) ./ sqrt(sum(~isnan(striatum_fs_low_fr)));
striatum_fs_high_fr_err = nanstd(striatum_fs_high_fr) ./ sqrt(sum(~isnan(striatum_fs_high_fr)));
striatum_rs_low_mse_avg = nanmean(striatum_rs_low_mse);
striatum_rs_high_mse_avg = nanmean(striatum_rs_high_mse);
striatum_rs_low_mse_err = nanstd(striatum_rs_low_mse) ./ sqrt(sum(~isnan(striatum_rs_low_mse)));
striatum_rs_high_mse_err = nanstd(striatum_rs_high_mse) ./ sqrt(sum(~isnan(striatum_rs_high_mse)));
striatum_fs_low_mse_avg = nanmean(striatum_fs_low_mse);
striatum_fs_high_mse_avg = nanmean(striatum_fs_high_mse);
striatum_fs_low_mse_err = nanstd(striatum_fs_low_mse) ./ sqrt(sum(~isnan(striatum_fs_low_mse)));
striatum_fs_high_mse_err = nanstd(striatum_fs_high_mse) ./ sqrt(sum(~isnan(striatum_fs_high_mse)));

session_ids = unique(alpha_modulated.session_id);
for s = 1:length(session_ids)
    low_p = out.low_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'RS'));
    high_p = out.high_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'RS'));
    striatum_rs_frac_low(s) = sum(low_p < p_threshold) / length(low_p);
    striatum_rs_frac_high(s) = sum(high_p < p_threshold) / length(high_p);
    low_p = out.low_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'FS'));
    high_p = out.high_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'FS'));
    striatum_fs_frac_low(s) = sum(low_p < p_threshold) / length(low_p);
    striatum_fs_frac_high(s) = sum(high_p < p_threshold) / length(high_p);
end

load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Revision/Amygdala/Spontaneous_Alpha_Modulation/data.mat'))
alpha_modulated = out.alpha_modulated;
p_threshold = out.overall_p_threshold;
clear out 
out_file = strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Revision/Amygdala/Spontaneous_Alpha_Modulation/high_v_low_alpha.mat');
load(out_file)

out.low_mi = out.low_mi(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.high_mi = out.high_mi(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.low_mse = out.low_mse(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.high_mse = out.high_mse(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.theta_bar_low = out.theta_bar_low(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.theta_bar_high = out.theta_bar_high(cell2mat(alpha_modulated.avg_trial_fr) > 1.0, :);
out.low_p = out.low_p(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.high_p = out.high_p(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.low_firing_rates = out.low_firing_rates(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.high_firing_rates = out.high_firing_rates(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.n_low_events = out.n_low_events(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
out.n_high_events = out.n_high_events(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);
alpha_modulated = alpha_modulated(cell2mat(alpha_modulated.avg_trial_fr) > 1.0,:);

exinds = load('ExcldInds/3738_excld_v2.mat');
for i = 1:length(exinds.new_excld{1})
    session_id = exinds.new_excld{1}{i};
    cid = exinds.new_excld{2}{i};
    out.low_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_low(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_high(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_low_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_high_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    alpha_modulated(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
end
exinds = load('ExcldInds/3387_excld.mat');
for i = 1:length(exinds.excld{1})
    session_id = exinds.excld{1}{i};
    cid = exinds.excld{2}{i};
    out.low_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mi(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_mse(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_low(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.theta_bar_high(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_p(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.low_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.high_firing_rates(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_low_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    out.n_high_events(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
    alpha_modulated(strcmp(alpha_modulated.session_id, session_id) & alpha_modulated.cluster_id == cid,:) = [];
end

amygdala_rs_low_mi = out.low_mi(strcmp(alpha_modulated.waveform_class, 'RS'));
amygdala_rs_high_mi = out.high_mi(strcmp(alpha_modulated.waveform_class, 'RS'));
amygdala_rs_low_p = out.low_p(strcmp(alpha_modulated.waveform_class, 'RS'));
amygdala_rs_high_p = out.high_p(strcmp(alpha_modulated.waveform_class, 'RS'));
amygdala_fs_low_mi = out.low_mi(strcmp(alpha_modulated.waveform_class, 'FS'));
amygdala_fs_high_mi = out.high_mi(strcmp(alpha_modulated.waveform_class, 'FS'));
amygdala_fs_low_p = out.low_p(strcmp(alpha_modulated.waveform_class, 'FS'));
amygdala_fs_high_p = out.high_p(strcmp(alpha_modulated.waveform_class, 'FS'));
amygdala_fs_low_fr = out.low_firing_rates(strcmp(alpha_modulated.waveform_class, 'FS'));
amygdala_fs_high_fr = out.high_firing_rates(strcmp(alpha_modulated.waveform_class, 'FS'));
amygdala_rs_low_fr = out.low_firing_rates(strcmp(alpha_modulated.waveform_class, 'RS'));
amygdala_rs_high_fr = out.high_firing_rates(strcmp(alpha_modulated.waveform_class, 'RS'));
amygdala_fs_low_n_events = out.n_low_events(strcmp(alpha_modulated.waveform_class, 'FS'));
amygdala_fs_high_n_events = out.n_high_events(strcmp(alpha_modulated.waveform_class, 'FS'));
amygdala_rs_low_n_events = out.n_low_events(strcmp(alpha_modulated.waveform_class, 'RS'));
amygdala_rs_high_n_events = out.n_high_events(strcmp(alpha_modulated.waveform_class, 'RS'));
amygdala_rs_low_mse = out.low_mse(strcmp(alpha_modulated.waveform_class, 'RS'));
amygdala_rs_high_mse = out.high_mse(strcmp(alpha_modulated.waveform_class, 'RS'));
amygdala_rs_theta_bar_low = out.theta_bar_low(strcmp(alpha_modulated.waveform_class, 'RS'));
amygdala_rs_theta_bar_high = out.theta_bar_high(strcmp(alpha_modulated.waveform_class, 'RS'));
amygdala_fs_low_mse = out.low_mse(strcmp(alpha_modulated.waveform_class, 'FS'));
amygdala_fs_high_mse = out.high_mse(strcmp(alpha_modulated.waveform_class, 'FS'));
amygdala_fs_theta_bar_low = out.theta_bar_low(strcmp(alpha_modulated.waveform_class, 'FS'));
amygdala_fs_theta_bar_high = out.theta_bar_high(strcmp(alpha_modulated.waveform_class, 'FS'));
amygdala_rs_excld = sort(unique([find(amygdala_rs_high_mse > 0.1); find(amygdala_rs_low_mse > 0.1)]));
amygdala_rs_low_mi(amygdala_rs_excld) = [];
amygdala_rs_high_mi(amygdala_rs_excld) = [];
amygdala_rs_low_mse(amygdala_rs_excld) = [];
amygdala_rs_high_mse(amygdala_rs_excld) = [];
amygdala_rs_theta_bar_low(amygdala_rs_excld) = [];
amygdala_rs_theta_bar_high(amygdala_rs_excld) = [];
amygdala_rs_low_p(amygdala_rs_excld) = [];
amygdala_rs_high_p(amygdala_rs_excld) = [];
amygdala_rs_low_fr(amygdala_rs_excld) = [];
amygdala_rs_high_fr(amygdala_rs_excld) = [];
amygdala_rs_low_n_events(amygdala_rs_excld) = [];
amygdala_rs_high_n_events(amygdala_rs_excld) = [];
amygdala_rs_low_mi_avg = nanmean(amygdala_rs_low_mi);
amygdala_rs_high_mi_avg = nanmean(amygdala_rs_high_mi);
amygdala_rs_low_mi_err = nanstd(amygdala_rs_low_mi) ./ sqrt(sum(~isnan(amygdala_rs_low_mi)));
amygdala_rs_high_mi_err = nanstd(amygdala_rs_high_mi) ./ sqrt(sum(~isnan(amygdala_rs_high_mi)));
amygdala_fs_low_mi_avg = nanmean(amygdala_fs_low_mi);
amygdala_fs_high_mi_avg = nanmean(amygdala_fs_high_mi);
amygdala_fs_low_mi_err = nanstd(amygdala_fs_low_mi) ./ sqrt(sum(~isnan(amygdala_fs_low_mi)));
amygdala_fs_high_mi_err = nanstd(amygdala_fs_high_mi) ./ sqrt(sum(~isnan(amygdala_fs_high_mi)));
amygdala_rs_low_fr_avg = nanmean(amygdala_rs_low_fr);
amygdala_rs_high_fr_avg = nanmean(amygdala_rs_high_fr);
amygdala_rs_low_fr_err = nanstd(amygdala_rs_low_fr) ./ sqrt(sum(~isnan(amygdala_rs_low_fr)));
amygdala_rs_high_fr_err = nanstd(amygdala_rs_high_fr) ./ sqrt(sum(~isnan(amygdala_rs_high_fr)));
amygdala_fs_low_fr_avg = nanmean(amygdala_fs_low_fr);
amygdala_fs_high_fr_avg = nanmean(amygdala_fs_high_fr);
amygdala_fs_low_fr_err = nanstd(amygdala_fs_low_fr) ./ sqrt(sum(~isnan(amygdala_fs_low_fr)));
amygdala_fs_high_fr_err = nanstd(amygdala_fs_high_fr) ./ sqrt(sum(~isnan(amygdala_fs_high_fr)));
amygdala_rs_low_mse_avg = nanmean(amygdala_rs_low_mse);
amygdala_rs_high_mse_avg = nanmean(amygdala_rs_high_mse);
amygdala_rs_low_mse_err = nanstd(amygdala_rs_low_mse) ./ sqrt(sum(~isnan(amygdala_rs_low_mse)));
amygdala_rs_high_mse_err = nanstd(amygdala_rs_high_mse) ./ sqrt(sum(~isnan(amygdala_rs_high_mse)));
amygdala_fs_low_mse_avg = nanmean(amygdala_fs_low_mse);
amygdala_fs_high_mse_avg = nanmean(amygdala_fs_high_mse);
amygdala_fs_low_mse_err = nanstd(amygdala_fs_low_mse) ./ sqrt(sum(~isnan(amygdala_fs_low_mse)));
amygdala_fs_high_mse_err = nanstd(amygdala_fs_high_mse) ./ sqrt(sum(~isnan(amygdala_fs_high_mse)));

session_ids = unique(alpha_modulated.session_id);
for s = 1:length(session_ids)
    low_p = out.low_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'RS'));
    high_p = out.high_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'RS'));
    amygdala_rs_frac_low(s) = sum(low_p < p_threshold) / length(low_p);
    amygdala_rs_frac_high(s) = sum(high_p < p_threshold) / length(high_p);
    low_p = out.low_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'FS'));
    high_p = out.high_p(strcmp(alpha_modulated.session_id, session_ids{s}) & strcmp(alpha_modulated.waveform_class, 'FS'));
    amygdala_fs_frac_low(s) = sum(low_p < p_threshold) / length(low_p);
    amygdala_fs_frac_high(s) = sum(high_p < p_threshold) / length(high_p);
end

s1_rs_frac_low_avg = nanmean(s1_rs_frac_low);
s1_fs_frac_low_avg = nanmean(s1_fs_frac_low);
s1_rs_frac_high_avg = nanmean(s1_rs_frac_high);
s1_fs_frac_high_avg = nanmean(s1_fs_frac_high);
pfc_rs_frac_low_avg = nanmean(pfc_rs_frac_low);
pfc_fs_frac_low_avg = nanmean(pfc_fs_frac_low);
pfc_rs_frac_high_avg = nanmean(pfc_rs_frac_high);
pfc_fs_frac_high_avg = nanmean(pfc_fs_frac_high);
striatum_rs_frac_low_avg = nanmean(striatum_rs_frac_low);
striatum_fs_frac_low_avg = nanmean(striatum_fs_frac_low);
striatum_rs_frac_high_avg = nanmean(striatum_rs_frac_high);
striatum_fs_frac_high_avg = nanmean(striatum_fs_frac_high);
amygdala_rs_frac_low_avg = nanmean(amygdala_rs_frac_low);
amygdala_fs_frac_low_avg = nanmean(amygdala_fs_frac_low);
amygdala_rs_frac_high_avg = nanmean(amygdala_rs_frac_high);
amygdala_fs_frac_high_avg = nanmean(amygdala_fs_frac_high);
s1_rs_frac_low_err = ste(s1_rs_frac_low);
s1_fs_frac_low_err = ste(s1_fs_frac_low);
s1_rs_frac_high_err = ste(s1_rs_frac_high);
s1_fs_frac_high_err = ste(s1_fs_frac_high);
pfc_rs_frac_low_err = ste(pfc_rs_frac_low);
pfc_fs_frac_low_err = ste(pfc_fs_frac_low);
pfc_rs_frac_high_err = ste(pfc_rs_frac_high);
pfc_fs_frac_high_err = ste(pfc_fs_frac_high);
striatum_rs_frac_low_err = ste(striatum_rs_frac_low);
striatum_fs_frac_low_err = ste(striatum_fs_frac_low);
striatum_rs_frac_high_err = ste(striatum_rs_frac_high);
striatum_fs_frac_high_err = ste(striatum_fs_frac_high);
amygdala_rs_frac_low_err = ste(amygdala_rs_frac_low);
amygdala_fs_frac_low_err = ste(amygdala_fs_frac_low);
amygdala_rs_frac_high_err = ste(amygdala_rs_frac_high);
amygdala_fs_frac_high_err = ste(amygdala_fs_frac_high);
amygdala_rs_theta_bar_low_avg = circ_mean(amygdala_rs_theta_bar_low);
amygdala_rs_theta_bar_high_avg = circ_mean(amygdala_rs_theta_bar_high);
amygdala_rs_theta_bar_low_err = circ_std(amygdala_rs_theta_bar_low) ./ sqrt(sum(~isnan(amygdala_rs_theta_bar_low)));
amygdala_rs_theta_bar_high_err = circ_std(amygdala_rs_theta_bar_high) ./ sqrt(sum(~isnan(amygdala_rs_theta_bar_high)));
striatum_rs_theta_bar_low_avg = circ_mean(striatum_rs_theta_bar_low);
striatum_rs_theta_bar_high_avg = circ_mean(striatum_rs_theta_bar_high);
striatum_rs_theta_bar_low_err = circ_std(striatum_rs_theta_bar_low) ./ sqrt(sum(~isnan(striatum_rs_theta_bar_low)));
striatum_rs_theta_bar_high_err = circ_std(striatum_rs_theta_bar_high) ./ sqrt(sum(~isnan(striatum_rs_theta_bar_high)));
pfc_rs_theta_bar_low_avg = circ_mean(pfc_rs_theta_bar_low);
pfc_rs_theta_bar_high_avg = circ_mean(pfc_rs_theta_bar_high);
pfc_rs_theta_bar_low_err = circ_std(pfc_rs_theta_bar_low) ./ sqrt(sum(~isnan(pfc_rs_theta_bar_low)));
pfc_rs_theta_bar_high_err = circ_std(pfc_rs_theta_bar_high) ./ sqrt(sum(~isnan(pfc_rs_theta_bar_high)));
s1_rs_theta_bar_low_avg = circ_mean(s1_rs_theta_bar_low);
s1_rs_theta_bar_high_avg = circ_mean(s1_rs_theta_bar_high);
s1_rs_theta_bar_low_err = circ_std(s1_rs_theta_bar_low) ./ sqrt(sum(~isnan(s1_rs_theta_bar_low)));
s1_rs_theta_bar_high_err = circ_std(s1_rs_theta_bar_high) ./ sqrt(sum(~isnan(s1_rs_theta_bar_high)));

amygdala_fs_theta_bar_low_avg = circ_mean(amygdala_fs_theta_bar_low);
amygdala_fs_theta_bar_high_avg = circ_mean(amygdala_fs_theta_bar_high);
amygdala_fs_theta_bar_low_err = circ_std(amygdala_fs_theta_bar_low) ./ sqrt(sum(~isnan(amygdala_fs_theta_bar_low)));
amygdala_fs_theta_bar_high_err = circ_std(amygdala_fs_theta_bar_high) ./ sqrt(sum(~isnan(amygdala_fs_theta_bar_high)));
striatum_fs_theta_bar_low_avg = circ_mean(striatum_fs_theta_bar_low);
striatum_fs_theta_bar_high_avg = circ_mean(striatum_fs_theta_bar_high);
striatum_fs_theta_bar_low_err = circ_std(striatum_fs_theta_bar_low) ./ sqrt(sum(~isnan(striatum_fs_theta_bar_low)));
striatum_fs_theta_bar_high_err = circ_std(striatum_fs_theta_bar_high) ./ sqrt(sum(~isnan(striatum_fs_theta_bar_high)));
pfc_fs_theta_bar_low_avg = circ_mean(pfc_fs_theta_bar_low);
pfc_fs_theta_bar_high_avg = circ_mean(pfc_fs_theta_bar_high);
pfc_fs_theta_bar_low_err = circ_std(pfc_fs_theta_bar_low) ./ sqrt(sum(~isnan(pfc_fs_theta_bar_low)));
pfc_fs_theta_bar_high_err = circ_std(pfc_fs_theta_bar_high) ./ sqrt(sum(~isnan(pfc_fs_theta_bar_high)));
s1_fs_theta_bar_low_avg = circ_mean(s1_fs_theta_bar_low);
s1_fs_theta_bar_high_avg = circ_mean(s1_fs_theta_bar_high);
s1_fs_theta_bar_low_err = circ_std(s1_fs_theta_bar_low) ./ sqrt(sum(~isnan(s1_fs_theta_bar_low)));
s1_fs_theta_bar_high_err = circ_std(s1_fs_theta_bar_high) ./ sqrt(sum(~isnan(s1_fs_theta_bar_high)));

fig = figure('Position', [1220 1334 1000 700]);
tl = tiledlayout(2,2);
axs(1) = nexttile;
hold on 
bar([2,5,8,11,14,17], ...
    [nanmean(s1_rs_frac_high .* 100), nanmean(s1_fs_frac_high .* 100), ...
    nanmean(pfc_rs_frac_high .* 100), nanmean(pfc_fs_frac_high .* 100), ...
    nanmean(striatum_rs_frac_high .* 100), nanmean(striatum_fs_frac_high .* 100)], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'b')
bar([1,4,7,10,13,16], ...
    [nanmean(s1_rs_frac_low .* 100), nanmean(s1_fs_frac_low .* 100), ...
    nanmean(pfc_rs_frac_low .* 100), nanmean(pfc_fs_frac_low .* 100), ...
    nanmean(striatum_rs_frac_low .* 100), nanmean(striatum_fs_frac_low .* 100)], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'r')
errorbar([2,5,8,11,14,17], ...
    [nanmean(s1_rs_frac_high .* 100), nanmean(s1_fs_frac_high .* 100), ...
    nanmean(pfc_rs_frac_high .* 100), nanmean(pfc_fs_frac_high .* 100), ...
    nanmean(striatum_rs_frac_high .* 100), nanmean(striatum_fs_frac_high .* 100)], ...
    [ste(s1_rs_frac_high .* 100), ste(s1_fs_frac_high .* 100), ...
    ste(pfc_rs_frac_high .* 100), ste(pfc_fs_frac_high .* 100), ...
    ste(striatum_rs_frac_high .* 100), ste(striatum_fs_frac_high .* 100)], ...
    'k.', 'LineWidth', 1.5)
errorbar([1,4,7,10,13,16], ...
    [nanmean(s1_rs_frac_low .* 100), nanmean(s1_fs_frac_low .* 100), ...
    nanmean(pfc_rs_frac_low .* 100), nanmean(pfc_fs_frac_low .* 100), ...
    nanmean(striatum_rs_frac_low .* 100), nanmean(striatum_fs_frac_low .* 100)], ...
    [ste(s1_rs_frac_low .* 100), ste(s1_fs_frac_low .* 100), ...
    ste(pfc_rs_frac_low .* 100), ste(pfc_fs_frac_low .* 100), ...
    ste(striatum_rs_frac_low .* 100), ste(striatum_fs_frac_low .* 100)], ...
    'k.', 'LineWidth', 1.5)
xticks([1.5, 4.5, 7.5, 10.5, 13.5, 16.5])
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS'})
xtickangle(45)
ylim([0,105])
yticks([0,100])
ylabel('% Modulated per Session', 'FontSize', 14)

axs(2) = nexttile;
hold on
bar([2,5,8,11,14,17], ...
    [s1_rs_high_mi_avg, s1_fs_high_mi_avg, ...
    pfc_rs_high_mi_avg, pfc_fs_high_mi_avg, ...
    striatum_rs_high_mi_avg, striatum_fs_high_mi_avg], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'b')
bar([1,4,7,10,13,16], ...
    [s1_rs_low_mi_avg, s1_fs_low_mi_avg, ...
    pfc_rs_low_mi_avg, pfc_fs_low_mi_avg, ...
    striatum_rs_low_mi_avg, striatum_fs_low_mi_avg], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'r')
errorbar([2,5,8,11,14,17], ...
    [s1_rs_high_mi_avg, s1_fs_high_mi_avg, ...
    pfc_rs_high_mi_avg, pfc_fs_high_mi_avg, ...
    striatum_rs_high_mi_avg, striatum_fs_high_mi_avg], ...
    [s1_rs_high_mi_err, s1_fs_high_mi_err, ...
    pfc_rs_high_mi_err, pfc_fs_high_mi_err, ...
    striatum_rs_high_mi_err, striatum_fs_high_mi_err], ...
    'k.', 'LineWidth', 1.5)
errorbar([1,4,7,10,13,16], ...
    [s1_rs_low_mi_avg, s1_fs_low_mi_avg, ...
    pfc_rs_low_mi_avg, pfc_fs_low_mi_avg, ...
    striatum_rs_low_mi_avg, striatum_fs_low_mi_avg], ...
    [s1_rs_low_mi_err, s1_fs_low_mi_err, ...
    pfc_rs_low_mi_err, pfc_fs_low_mi_err, ...
    striatum_rs_low_mi_err, striatum_fs_low_mi_err], ...
    'k.', 'LineWidth', 1.5)
xticks([1.5, 4.5, 7.5, 10.5, 13.5, 16.5])
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS'})
xtickangle(45)
% ylim([0,0.12])
% yticks([0,0.12])
lims = ylim;
yticks([0,lims(2)])
ylabel('Modulation Index', 'FontSize', 14)

axs(3) = nexttile;
hold on
bar([2,5,8,11,14,17], ...
    [s1_rs_high_fr_avg, s1_fs_high_fr_avg, ...
    pfc_rs_high_fr_avg, pfc_fs_high_fr_avg, ...
    striatum_rs_high_fr_avg, striatum_fs_high_fr_avg], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'b')
bar([1,4,7,10,13,16], ...
    [s1_rs_low_fr_avg, s1_fs_low_fr_avg, ...
    pfc_rs_low_fr_avg, pfc_fs_low_fr_avg, ...
    striatum_rs_low_fr_avg, striatum_fs_low_fr_avg], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'r')
errorbar([2,5,8,11,14,17], ...
    [s1_rs_high_fr_avg, s1_fs_high_fr_avg, ...
    pfc_rs_high_fr_avg, pfc_fs_high_fr_avg, ...
    striatum_rs_high_fr_avg, striatum_fs_high_fr_avg], ...
    [s1_rs_high_fr_err, s1_fs_high_fr_err, ...
    pfc_rs_high_fr_err, pfc_fs_high_fr_err, ...
    striatum_rs_high_fr_err, striatum_fs_high_fr_err], ...
    'k.', 'LineWidth', 1.5)
errorbar([1,4,7,10,13,16], ...
    [s1_rs_low_fr_avg, s1_fs_low_fr_avg, ...
    pfc_rs_low_fr_avg, pfc_fs_low_fr_avg, ...
    striatum_rs_low_fr_avg, striatum_fs_low_fr_avg], ...
    [s1_rs_low_fr_err, s1_fs_low_fr_err, ...
    pfc_rs_low_fr_err, pfc_fs_low_fr_err, ...
    striatum_rs_low_fr_err, striatum_fs_low_fr_err], ...
    'k.', 'LineWidth', 1.5)
xticks([1.5, 4.5, 7.5, 10.5, 13.5, 16.5])
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS'})
xtickangle(45)
% ylim([0,18])
lims = ylim;
yticks([0,lims(2)])
ylabel('Avg. Firing Rate (Hz)', 'FontSize', 14)

axs(4) = nexttile;
hold on
bar([2,5,8,11,14,17], ...
    [s1_rs_theta_bar_high_avg, s1_fs_theta_bar_high_avg, ...
    pfc_rs_theta_bar_high_avg, pfc_fs_theta_bar_high_avg, ...
    striatum_rs_theta_bar_high_avg, striatum_fs_theta_bar_high_avg], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'b')
bar([1,4,7,10,13,16], ...
    [s1_rs_theta_bar_low_avg, s1_fs_theta_bar_low_avg, ...
    pfc_rs_theta_bar_low_avg, pfc_fs_theta_bar_low_avg, ...
    striatum_rs_theta_bar_low_avg, striatum_fs_theta_bar_low_avg], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'r')
errorbar([2,5,8,11,14,17], ...
    [s1_rs_theta_bar_high_avg, s1_fs_theta_bar_high_avg, ...
    pfc_rs_theta_bar_high_avg, pfc_fs_theta_bar_high_avg, ...
    striatum_rs_theta_bar_high_avg, striatum_fs_theta_bar_high_avg], ...
    [s1_rs_theta_bar_high_err, s1_fs_theta_bar_high_err, ...
    pfc_rs_theta_bar_high_err, pfc_fs_theta_bar_high_err, ...
    striatum_rs_theta_bar_high_err, striatum_fs_theta_bar_high_err], ...
    'k.', 'LineWidth', 1.5)
errorbar([1,4,7,10,13,16], ...
    [s1_rs_theta_bar_low_avg, s1_fs_theta_bar_low_avg, ...
    pfc_rs_theta_bar_low_avg, pfc_fs_theta_bar_low_avg, ...
    striatum_rs_theta_bar_low_avg, striatum_fs_theta_bar_low_avg], ...
    [s1_rs_theta_bar_low_err, s1_fs_theta_bar_low_err, ...
    pfc_rs_theta_bar_low_err, pfc_fs_theta_bar_low_err, ...
    striatum_rs_theta_bar_low_err, striatum_fs_theta_bar_low_err], ...
    'k.', 'LineWidth', 1.5)
ylabel('Avg. Firing Phase (rad)', 'FontSize', 14)
xticks([1.5, 4.5, 7.5, 10.5, 13.5, 16.5, 19.5, 22.5])
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS'})
xtickangle(45)
ylim([-4,4])
yticks([-pi,pi])
yticklabels({'-\pi', '\pi'})

% if out_path
%     mkdir('./Figures/')
%     saveas(fig, '../Figures/lowVsHighAlpha_summary.svg')
%     saveas(fig, '../Figures/lowVsHighAlpha_summary.fig')
% end
if KStest(s1_rs_frac_low) || KStest(s1_rs_frac_high)
    p = signrank(s1_rs_frac_low,s1_rs_frac_high);
    if p < (0.05 / length(s1_rs_frac_low))
        fprintf(sprintf('S1 RS low alpha fraction vs high alpha fraction (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('S1 RS low alpha fraction vs high alpha fraction (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('S1 RS low alpha fraction vs high alpha fraction (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(s1_rs_frac_low, s1_rs_frac_high);
    if p < 0.05 
        fprintf(sprintf('S1 RS low alpha fraction vs high alpha fraction (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('S1 RS low alpha fraction vs high alpha fraction (t-test): p = %d\n', p))
    end
end
fprintf('S1 RS avg high minus low fraction: %d\n', nanmean(s1_rs_frac_high-s1_rs_frac_low))

if KStest(s1_fs_frac_low) || KStest(s1_fs_frac_high)
    p = signrank(s1_fs_frac_low,s1_fs_frac_high);
    if p < (0.05 / length(s1_fs_frac_low))
        fprintf(sprintf('S1 FS low alpha fraction vs high alpha fraction (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('S1 FS low alpha fraction vs high alpha fraction (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('S1 FS low alpha fraction vs high alpha fraction (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(s1_fs_frac_low, s1_fs_frac_high);
    if p < 0.05 
        fprintf(sprintf('S1 FS low alpha fraction vs high alpha fraction (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('S1 FS low alpha fraction vs high alpha fraction (t-test): p = %d\n', p))
    end
end
fprintf('S1 FS avg high minus low fraction: %d\n', nanmean(s1_fs_frac_high-s1_fs_frac_low))

if KStest(pfc_rs_frac_low) || KStest(pfc_rs_frac_high)
    p = signrank(pfc_rs_frac_low,pfc_rs_frac_high);
    if p < (0.05 / length(pfc_rs_frac_low))
        fprintf(sprintf('PFC RS low alpha fraction vs high alpha fraction (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('PFC RS low alpha fraction vs high alpha fraction (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('PFC RS low alpha fraction vs high alpha fraction (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(pfc_rs_frac_low, pfc_rs_frac_high);
    if p < 0.05 
        fprintf(sprintf('PFC RS low alpha fraction vs high alpha fraction (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('PFC RS low alpha fraction vs high alpha fraction (t-test): p = %d\n', p))
    end
end
fprintf('PFC RS avg high minus low fraction: %d\n', nanmean(pfc_rs_frac_high-pfc_rs_frac_low))

if KStest(pfc_fs_frac_low) || KStest(pfc_fs_frac_high)
    p = signrank(pfc_fs_frac_low,pfc_fs_frac_high);
    if p < (0.05 / length(pfc_fs_frac_low))
        fprintf(sprintf('PFC FS low alpha fraction vs high alpha fraction (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('PFC FS low alpha fraction vs high alpha fraction (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('PFC FS low alpha fraction vs high alpha fraction (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(pfc_fs_frac_low, pfc_fs_frac_high);
    if p < 0.05 
        fprintf(sprintf('PFC FS low alpha fraction vs high alpha fraction (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('PFC FS low alpha fraction vs high alpha fraction (t-test): p = %d\n', p))
    end
end
fprintf('PFC FS avg high minus low fraction: %d\n', nanmean(pfc_fs_frac_high-pfc_fs_frac_low))

if KStest(striatum_rs_frac_low) || KStest(striatum_rs_frac_high)
    p = signrank(striatum_rs_frac_low,striatum_rs_frac_high);
    if p < (0.05 / length(striatum_rs_frac_low))
        fprintf(sprintf('Striatum RS low alpha fraction vs high alpha fraction (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('Striatum RS low alpha fraction vs high alpha fraction (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum RS low alpha fraction vs high alpha fraction (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(striatum_rs_frac_low, striatum_rs_frac_high);
    if p < 0.05 
        fprintf(sprintf('Striatum RS low alpha fraction vs high alpha fraction (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum RS low alpha fraction vs high alpha fraction (t-test): p = %d\n', p))
    end
end
fprintf('Striatum RS avg high minus low fraction: %d\n', nanmean(striatum_rs_frac_high-striatum_rs_frac_low))

if KStest(striatum_fs_frac_low) || KStest(striatum_fs_frac_high)
    p = signrank(striatum_fs_frac_low,striatum_fs_frac_high);
    if p < (0.05 / length(striatum_fs_frac_low))
        fprintf(sprintf('Striatum FS low alpha fraction vs high alpha fraction (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('Striatum FS low alpha fraction vs high alpha fraction (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum FS low alpha fraction vs high alpha fraction (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(striatum_fs_frac_low, striatum_fs_frac_high);
    if p < 0.05 
        fprintf(sprintf('Striatum FS low alpha fraction vs high alpha fraction (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum FS low alpha fraction vs high alpha fraction (t-test): p = %d\n', p))
    end
end
fprintf('Striatum FS avg high minus low fraction: %d\n', nanmean(striatum_fs_frac_high-striatum_fs_frac_low))

if KStest(s1_rs_low_mi) || KStest(s1_rs_high_mi)
    p = signrank(s1_rs_low_mi,s1_rs_high_mi);
    if p < (0.05 / length(s1_rs_low_mi))
        fprintf(sprintf('S1 RS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('S1 RS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('S1 RS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(s1_rs_low_mi, s1_rs_high_mi);
    if p < 0.05 
        fprintf(sprintf('S1 RS low alpha MI vs high alpha MI (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('S1 RS low alpha MI vs high alpha MI (t-test): p = %d\n', p))
    end
end
fprintf('S1 RS avg high minus low MI: %d\n', nanmean(s1_rs_high_mi-s1_rs_low_mi))

if KStest(s1_fs_low_mi) || KStest(s1_fs_high_mi)
    p = signrank(s1_fs_low_mi,s1_fs_high_mi);
    if p < (0.05 / length(s1_fs_low_mi))
        fprintf(sprintf('S1 FS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('S1 FS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('S1 FS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(s1_fs_low_mi, s1_fs_high_mi);
    if p < 0.05 
        fprintf(sprintf('S1 FS low alpha MI vs high alpha MI (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('S1 FS low alpha MI vs high alpha MI (t-test): p = %d\n', p))
    end
end
fprintf('S1 FS avg high minus low MI: %d\n', nanmean(s1_fs_high_mi-s1_fs_low_mi))

if KStest(pfc_rs_low_mi) || KStest(pfc_rs_high_mi)
    p = signrank(pfc_rs_low_mi,pfc_rs_high_mi);
    if p < (0.05 / length(pfc_rs_low_mi))
        fprintf(sprintf('PFC RS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('PFC RS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('PFC RS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(pfc_rs_low_mi, pfc_rs_high_mi);
    if p < 0.05 
        fprintf(sprintf('PFC RS low alpha MI vs high alpha MI (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('PFC RS low alpha MI vs high alpha MI (t-test): p = %d\n', p))
    end
end
fprintf('PFC RS avg high minus low MI: %d\n', nanmean(pfc_rs_high_mi-pfc_rs_low_mi))

if KStest(pfc_fs_low_mi) || KStest(pfc_fs_high_mi)
    p = signrank(pfc_fs_low_mi,pfc_fs_high_mi);
    if p < (0.05 / length(pfc_fs_low_mi))
        fprintf(sprintf('PFC FS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('PFC FS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('PFC FS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(pfc_fs_low_mi, pfc_fs_high_mi);
    if p < 0.05 
        fprintf(sprintf('PFC FS low alpha MI vs high alpha MI (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('PFC FS low alpha MI vs high alpha MI (t-test): p = %d\n', p))
    end
end
fprintf('PFC FS avg high minus low MI: %d\n', nanmean(pfc_fs_high_mi-pfc_fs_low_mi))

if KStest(striatum_rs_low_mi) || KStest(striatum_rs_high_mi)
    p = signrank(striatum_rs_low_mi,striatum_rs_high_mi);
    if p < (0.05 / length(striatum_rs_low_mi))
        fprintf(sprintf('Striatum RS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('Striatum RS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum RS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(striatum_rs_low_mi, striatum_rs_high_mi);
    if p < 0.05 
        fprintf(sprintf('Striatum RS low alpha MI vs high alpha MI (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum RS low alpha MI vs high alpha MI (t-test): p = %d\n', p))
    end
end
fprintf('Striatum RS avg high minus low MI: %d\n', nanmean(striatum_rs_high_mi-striatum_rs_low_mi))

if KStest(striatum_fs_low_mi) || KStest(striatum_fs_high_mi)
    p = signrank(striatum_fs_low_mi,striatum_fs_high_mi);
    if p < (0.05 / length(striatum_fs_low_mi))
        fprintf(sprintf('Striatum FS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('Striatum FS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum FS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(striatum_fs_low_mi, striatum_fs_high_mi);
    if p < 0.05 
        fprintf(sprintf('Striatum FS low alpha MI vs high alpha MI (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum FS low alpha MI vs high alpha MI (t-test): p = %d\n', p))
    end
end
fprintf('Striatum FS avg high minus low MI: %d\n', nanmean(striatum_fs_high_mi-striatum_fs_low_mi))

% if KStest(amygdala_rs_low_mi) || KStest(amygdala_rs_high_mi)
%     p = signrank(amygdala_rs_low_mi,amygdala_rs_high_mi);
%     if p < (0.05 / length(amygdala_rs_low_mi))
%         fprintf(sprintf('Amygdala RS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
%     elseif p < 0.05 
%         fprintf(sprintf('Amygdala RS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
%     else
%         fprintf(sprintf('Amygdala RS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
%     end
% else
%     [~, p] = ttest(amygdala_rs_low_mi, amygdala_rs_high_mi);
%     if p < 0.05 
%         fprintf(sprintf('Amygdala RS low alpha MI vs high alpha MI (t-test): *p = %d\n', p))
%     else
%         fprintf(sprintf('Amygdala RS low alpha MI vs high alpha MI (t-test): p = %d\n', p))
%     end
% end
% fprintf('Amygdala RS avg high minus low MI: %d\n', nanmean(amygdala_rs_high_mi-amygdala_rs_low_mi))

% if KStest(amygdala_fs_low_mi) || KStest(amygdala_fs_high_mi)
%     p = signrank(amygdala_fs_low_mi,amygdala_fs_high_mi);
%     if p < (0.05 / length(amygdala_fs_low_mi))
%         fprintf(sprintf('Amygdala FS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
%     elseif p < 0.05 
%         fprintf(sprintf('Amygdala FS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
%     else
%         fprintf(sprintf('Amygdala FS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
%     end
% else
%     [~, p] = ttest(amygdala_fs_low_mi, amygdala_fs_high_mi);
%     if p < 0.05 
%         fprintf(sprintf('Amygdala FS low alpha MI vs high alpha MI (t-test): *p = %d\n', p))
%     else
%         fprintf(sprintf('Amygdala FS low alpha MI vs high alpha MI (t-test): p = %d\n', p))
%     end
% end
% fprintf('Amygdala FS avg high minus low MI: %d\n', nanmean(amygdala_fs_high_mi-amygdala_fs_low_mi))

if KStest(s1_rs_low_mse) || KStest(s1_rs_high_mse)
    p = signrank(s1_rs_low_mse,s1_rs_high_mse);
    if p < (0.05 / length(s1_rs_low_mse))
        fprintf(sprintf('S1 RS low alpha MSE vs high alpha MSE (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('S1 RS low alpha MSE vs high alpha MSE (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('S1 RS low alpha MSE vs high alpha MSE (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(s1_rs_low_mse, s1_rs_high_mse);
    if p < 0.05 
        fprintf(sprintf('S1 RS low alpha MSE vs high alpha MSE (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('S1 RS low alpha MSE vs high alpha MSE (t-test): p = %d\n', p))
    end
end
fprintf('S1 RS avg high minus low MSE: %d\n', nanmean(s1_rs_high_mse-s1_rs_low_mse))

if KStest(s1_fs_low_mse) || KStest(s1_fs_high_mse)
    p = signrank(s1_fs_low_mse,s1_fs_high_mse);
    if p < (0.05 / length(s1_fs_low_mse))
        fprintf(sprintf('S1 FS low alpha MSE vs high alpha MSE (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('S1 FS low alpha MSE vs high alpha MSE (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('S1 FS low alpha MSE vs high alpha MSE (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(s1_fs_low_mse, s1_fs_high_mse);
    if p < 0.05 
        fprintf(sprintf('S1 FS low alpha MSE vs high alpha MSE (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('S1 FS low alpha MSE vs high alpha MSE (t-test): p = %d\n', p))
    end
end
fprintf('S1 FS avg high minus low MSE: %d\n', nanmean(s1_fs_high_mse-s1_fs_low_mse))

if KStest(pfc_rs_low_mse) || KStest(pfc_rs_high_mse)
    p = signrank(pfc_rs_low_mse,pfc_rs_high_mse);
    if p < (0.05 / length(pfc_rs_low_mse))
        fprintf(sprintf('PFC RS low alpha MSE vs high alpha MSE (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('PFC RS low alpha MSE vs high alpha MSE (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('PFC RS low alpha MSE vs high alpha MSE (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(pfc_rs_low_mse, pfc_rs_high_mse);
    if p < 0.05 
        fprintf(sprintf('PFC RS low alpha MSE vs high alpha MSE (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('PFC RS low alpha MSE vs high alpha MSE (t-test): p = %d\n', p))
    end
end
fprintf('PFC RS avg high minus low MSE: %d\n', nanmean(pfc_rs_high_mse-pfc_rs_low_mse))

if KStest(pfc_fs_low_mse) || KStest(pfc_fs_high_mse)
    p = signrank(pfc_fs_low_mse,pfc_fs_high_mse);
    if p < (0.05 / length(pfc_fs_low_mse))
        fprintf(sprintf('PFC FS low alpha MSE vs high alpha MSE (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('PFC FS low alpha MSE vs high alpha MSE (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('PFC FS low alpha MSE vs high alpha MSE (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(pfc_fs_low_mse, pfc_fs_high_mse);
    if p < 0.05 
        fprintf(sprintf('PFC FS low alpha MSE vs high alpha MSE (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('PFC FS low alpha MSE vs high alpha MSE (t-test): p = %d\n', p))
    end
end
fprintf('PFC FS avg high minus low MSE: %d\n', nanmean(pfc_fs_high_mse-pfc_fs_low_mse))

if KStest(striatum_rs_low_mse) || KStest(striatum_rs_high_mse)
    p = signrank(striatum_rs_low_mse,striatum_rs_high_mse);
    if p < (0.05 / length(striatum_rs_low_mse))
        fprintf(sprintf('Striatum RS low alpha MSE vs high alpha MSE (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('Striatum RS low alpha MSE vs high alpha MSE (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum RS low alpha MSE vs high alpha MSE (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(striatum_rs_low_mse, striatum_rs_high_mse);
    if p < 0.05 
        fprintf(sprintf('Striatum RS low alpha MSE vs high alpha MSE (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum RS low alpha MSE vs high alpha MSE (t-test): p = %d\n', p))
    end
end
fprintf('Striatum RS avg high minus low MSE: %d\n', nanmean(striatum_rs_high_mse-striatum_rs_low_mse))

if KStest(striatum_fs_low_mse) || KStest(striatum_fs_high_mse)
    p = signrank(striatum_fs_low_mse,striatum_fs_high_mse);
    if p < (0.05 / length(striatum_fs_low_mse))
        fprintf(sprintf('Striatum FS low alpha MSE vs high alpha MSE (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('Striatum FS low alpha MSE vs high alpha MSE (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum FS low alpha MSE vs high alpha MSE (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(striatum_fs_low_mse, striatum_fs_high_mse);
    if p < 0.05 
        fprintf(sprintf('Striatum FS low alpha MSE vs high alpha MSE (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum FS low alpha MSE vs high alpha MSE (t-test): p = %d\n', p))
    end
end
fprintf('Striatum FS avg high minus low MSE: %d\n', nanmean(striatum_fs_high_mse-striatum_fs_low_mse))

% if KStest(amygdala_rs_low_mse) || KStest(amygdala_rs_high_mse)
%     p = signrank(amygdala_rs_low_mse,amygdala_rs_high_mse);
%     if p < (0.05 / length(amygdala_rs_low_mse))
%         fprintf(sprintf('Amygdala RS low alpha MSE vs high alpha MSE (signed-rank): **p = %d\n', p))
%     elseif p < 0.05 
%         fprintf(sprintf('Amygdala RS low alpha MSE vs high alpha MSE (signed-rank): *p = %d\n', p))
%     else
%         fprintf(sprintf('Amygdala RS low alpha MSE vs high alpha MSE (signed-rank): p = %d\n', p))
%     end
% else
%     [~, p] = ttest(amygdala_rs_low_mse, amygdala_rs_high_mse);
%     if p < 0.05 
%         fprintf(sprintf('Amygdala RS low alpha MSE vs high alpha MSE (t-test): *p = %d\n', p))
%     else
%         fprintf(sprintf('Amygdala RS low alpha MSE vs high alpha MSE (t-test): p = %d\n', p))
%     end
% end
% fprintf('Amygdala RS avg high minus low MSE: %d\n', nanmean(amygdala_rs_high_mse-amygdala_rs_low_mse))

% if KStest(amygdala_fs_low_mse) || KStest(amygdala_fs_high_mse)
%     p = signrank(amygdala_fs_low_mse,amygdala_fs_high_mse);
%     if p < (0.05 / length(amygdala_fs_low_mse))
%         fprintf(sprintf('Amygdala FS low alpha MSE vs high alpha MSE (signed-rank): **p = %d\n', p))
%     elseif p < 0.05 
%         fprintf(sprintf('Amygdala FS low alpha MSE vs high alpha MSE (signed-rank): *p = %d\n', p))
%     else
%         fprintf(sprintf('Amygdala FS low alpha MSE vs high alpha MSE (signed-rank): p = %d\n', p))
%     end
% else
%     [~, p] = ttest(amygdala_fs_low_mse, amygdala_fs_high_mse);
%     if p < 0.05 
%         fprintf(sprintf('Amygdala FS low alpha MSE vs high alpha MSE (t-test): *p = %d\n', p))
%     else
%         fprintf(sprintf('Amygdala FS low alpha MSE vs high alpha MSE (t-test): p = %d\n', p))
%     end
% end
% fprintf('Amygdala FS avg high minus low MSE: %d\n', nanmean(amygdala_fs_high_mse-amygdala_fs_low_mse))

if KStest(s1_rs_low_fr) || KStest(s1_rs_high_fr)
    p = signrank(s1_rs_low_fr,s1_rs_high_fr);
    if p < (0.05 / length(s1_rs_low_fr))
        fprintf(sprintf('S1 RS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('S1 RS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('S1 RS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(s1_rs_low_fr, s1_rs_high_fr);
    if p < 0.05 
        fprintf(sprintf('S1 RS low alpha FR vs high alpha FR (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('S1 RS low alpha FR vs high alpha FR (t-test): p = %d\n', p))
    end
end
fprintf('S1 RS avg high minus low FR: %d\n', nanmean(s1_rs_high_fr-s1_rs_low_fr))

if KStest(s1_fs_low_fr) || KStest(s1_fs_high_fr)
    p = signrank(s1_fs_low_fr,s1_fs_high_fr);
    if p < (0.05 / length(s1_fs_low_fr))
        fprintf(sprintf('S1 FS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('S1 FS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('S1 FS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(s1_fs_low_fr, s1_fs_high_fr);
    if p < 0.05 
        fprintf(sprintf('S1 FS low alpha FR vs high alpha FR (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('S1 FS low alpha FR vs high alpha FR (t-test): p = %d\n', p))
    end
end
fprintf('S1 FS avg high minus low FR: %d\n', nanmean(s1_fs_high_fr-s1_fs_low_fr))

if KStest(pfc_rs_low_fr) || KStest(pfc_rs_high_fr)
    p = signrank(pfc_rs_low_fr,pfc_rs_high_fr);
    if p < (0.05 / length(pfc_rs_low_fr))
        fprintf(sprintf('PFC RS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('PFC RS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('PFC RS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(pfc_rs_low_fr, pfc_rs_high_fr);
    if p < 0.05 
        fprintf(sprintf('PFC RS low alpha FR vs high alpha FR (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('PFC RS low alpha FR vs high alpha FR (t-test): p = %d\n', p))
    end
end
fprintf('PFC RS avg high minus low FR: %d\n', nanmean(pfc_rs_high_fr-pfc_rs_low_fr))

if KStest(pfc_fs_low_fr) || KStest(pfc_fs_high_fr)
    p = signrank(pfc_fs_low_fr,pfc_fs_high_fr);
    if p < (0.05 / length(pfc_fs_low_fr))
        fprintf(sprintf('PFC FS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('PFC FS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('PFC FS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(pfc_fs_low_fr, pfc_fs_high_fr);
    if p < 0.05 
        fprintf(sprintf('PFC FS low alpha FR vs high alpha FR (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('PFC FS low alpha FR vs high alpha FR (t-test): p = %d\n', p))
    end
end
fprintf('PFC FS avg high minus low FR: %d\n', nanmean(pfc_fs_high_fr-pfc_fs_low_fr))

if KStest(striatum_rs_low_fr) || KStest(striatum_rs_high_fr)
    p = signrank(striatum_rs_low_fr,striatum_rs_high_fr);
    if p < (0.05 / length(striatum_rs_low_fr))
        fprintf(sprintf('Striatum RS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('Striatum RS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum RS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(striatum_rs_low_fr, striatum_rs_high_fr);
    if p < 0.05 
        fprintf(sprintf('Striatum RS low alpha FR vs high alpha FR (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum RS low alpha FR vs high alpha FR (t-test): p = %d\n', p))
    end
end
fprintf('Striatum RS avg high minus low FR: %d\n', nanmean(striatum_rs_high_fr-striatum_rs_low_fr))

if KStest(striatum_fs_low_fr) || KStest(striatum_fs_high_fr)
    p = signrank(striatum_fs_low_fr,striatum_fs_high_fr);
    if p < (0.05 / length(striatum_fs_low_fr))
        fprintf(sprintf('Striatum FS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
    elseif p < 0.05 
        fprintf(sprintf('Striatum FS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum FS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
    end
else
    [~, p] = ttest(striatum_fs_low_fr, striatum_fs_high_fr);
    if p < 0.05 
        fprintf(sprintf('Striatum FS low alpha FR vs high alpha FR (t-test): *p = %d\n', p))
    else
        fprintf(sprintf('Striatum FS low alpha FR vs high alpha FR (t-test): p = %d\n', p))
    end
end
fprintf('Striatum FS avg high minus low FR: %d\n', nanmean(striatum_fs_high_fr-striatum_fs_low_fr))

% if KStest(amygdala_rs_low_fr) || KStest(amygdala_rs_high_fr)
%     p = signrank(amygdala_rs_low_fr,amygdala_rs_high_fr);
%     if p < (0.05 / length(amygdala_rs_low_fr))
%         fprintf(sprintf('Amygdala RS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
%     elseif p < 0.05 
%         fprintf(sprintf('Amygdala RS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
%     else
%         fprintf(sprintf('Amygdala RS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
%     end
% else
%     [~, p] = ttest(amygdala_rs_low_fr, amygdala_rs_high_fr);
%     if p < 0.05 
%         fprintf(sprintf('Amygdala RS low alpha FR vs high alpha FR (t-test): *p = %d\n', p))
%     else
%         fprintf(sprintf('Amygdala RS low alpha FR vs high alpha FR (t-test): p = %d\n', p))
%     end
% end
% fprintf('Amygdala RS avg high minus low FR: %d\n', nanmean(amygdala_rs_high_fr-amygdala_rs_low_fr))

% if KStest(amygdala_fs_low_fr) || KStest(amygdala_fs_high_fr)
%     p = signrank(amygdala_fs_low_fr,amygdala_fs_high_fr);
%     if p < (0.05 / length(amygdala_fs_low_fr))
%         fprintf(sprintf('Amygdala FS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
%     elseif p < 0.05 
%         fprintf(sprintf('Amygdala FS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
%     else
%         fprintf(sprintf('Amygdala FS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
%     end
% else
%     [~, p] = ttest(amygdala_fs_low_fr, amygdala_fs_high_fr);
%     if p < 0.05 
%         fprintf(sprintf('Amygdala FS low alpha FR vs high alpha FR (t-test): *p = %d\n', p))
%     else
%         fprintf(sprintf('Amygdala FS low alpha FR vs high alpha FR (t-test): p = %d\n', p))
%     end
% end
% fprintf('Amygdala FS avg high minus low FR: %d\n', nanmean(amygdala_fs_high_fr-amygdala_fs_low_fr))

fprintf(sprintf('S1 RS theta bar distribtions kuipers test: %d\n', circ_kuipertest(s1_rs_theta_bar_low,s1_rs_theta_bar_high)))
fprintf(sprintf('S1 FS theta bar distribtions kuipers test: %d\n', circ_kuipertest(s1_fs_theta_bar_low,s1_fs_theta_bar_high)))
fprintf(sprintf('PFC RS theta bar distribtions kuipers test: %d\n', circ_kuipertest(pfc_rs_theta_bar_low,pfc_rs_theta_bar_high)))
try
    fprintf(sprintf('PFC FS theta bar distribtions kuipers test: %d\n', circ_kuipertest(pfc_fs_theta_bar_low,pfc_fs_theta_bar_high)))
end
try
    fprintf(sprintf('Striatum RS theta bar distribtions kuipers test: %d\n', circ_kuipertest(striatum_rs_theta_bar_low,striatum_rs_theta_bar_high)))
end
try
    fprintf(sprintf('Striatum FS theta bar distribtions kuipers test: %d\n', circ_kuipertest(striatum_fs_theta_bar_low,striatum_fs_theta_bar_high)))
end
% fprintf(sprintf('Amygdala RS theta bar distribtions kuipers test: %d\n', circ_kuipertest(amygdala_rs_theta_bar_low,amygdala_rs_theta_bar_high)))
% fprintf(sprintf('Amygdala FS theta bar distribtions kuipers test: %d\n', circ_kuipertest(amygdala_fs_theta_bar_low,amygdala_fs_theta_bar_high)))

% fig = figure('Position', [1220 1334 1000 700]);
% hold on
% bar([2,5,8,11,14,17, 20, 23], ...
%     [s1_rs_frac_high_avg, s1_fs_frac_high_avg, ...
%     pfc_rs_frac_high_avg, pfc_fs_frac_high_avg, ...
%     striatum_rs_frac_high_avg, striatum_fs_frac_high_avg, ...
%     amygdala_rs_frac_high_avg, amygdala_fs_frac_high_avg] .* 100, 0.3, ...
%     'EdgeColor', 'k', 'FaceColor', 'b')
% bar([1,4,7,10,13,16,19,22], ...
%     [s1_rs_frac_low_avg, s1_fs_frac_low_avg, ...
%     pfc_rs_frac_low_avg, pfc_fs_frac_low_avg, ...
%     striatum_rs_frac_low_avg, striatum_fs_frac_low_avg, ...
%     amygdala_rs_frac_low_avg, amygdala_fs_frac_low_avg] .* 100, 0.3, ...
%     'EdgeColor', 'k', 'FaceColor', 'r')
% errorbar([2,5,8,11,14,17, 20, 23], ...
%     [s1_rs_frac_high_avg, s1_fs_frac_high_avg, ...
%     pfc_rs_frac_high_avg, pfc_fs_frac_high_avg, ...
%     striatum_rs_frac_high_avg, striatum_fs_frac_high_avg, ...
%     amygdala_rs_frac_high_avg, amygdala_fs_frac_high_avg] .* 100, ...
%     [s1_rs_frac_high_err, s1_fs_frac_high_err, ...
%     pfc_rs_frac_high_err, pfc_fs_frac_high_err, ...
%     striatum_rs_frac_high_err, striatum_fs_frac_high_err, ...
%     amygdala_rs_frac_high_err, amygdala_fs_frac_high_err] .* 100, ...
%     'k.')
% errorbar([1,4,7,10,13,16,19,22], ...
%     [s1_rs_frac_low_avg, s1_fs_frac_low_avg, ...
%     pfc_rs_frac_low_avg, pfc_fs_frac_low_avg, ...
%     striatum_rs_frac_low_avg, striatum_fs_frac_low_avg, ...
%     amygdala_rs_frac_low_avg, amygdala_fs_frac_low_avg] .* 100, ...
%     [s1_rs_frac_low_err, s1_fs_frac_low_err, ...
%     pfc_rs_frac_low_err, pfc_fs_frac_low_err, ...
%     striatum_rs_frac_low_err, striatum_fs_frac_low_err, ...
%     amygdala_rs_frac_low_err, amygdala_fs_frac_low_err] .* 100, ...
%     'k.')
% xticks([1.5, 4.5, 7.5, 10.5, 13.5, 16.5, 19.5, 22.5])
% xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS', 'Amygdala RS', 'Amygdala FS'})
% xtickangle(45)
% % ylim([0,0.12])
% % yticks([0,0.12])
% lims = ylim;
% yticks([0,lims(2)])
% ylabel('% Alpha Modulated ', 'FontSize', 14) 

updated_fig = figure('Position', [1215 1296 1682 506]);
tl = tiledlayout(1,3);
axs(1) = nexttile;
s1_rs_frac = [s1_rs_frac_low', s1_rs_frac_high'];
s1_fs_frac = [s1_fs_frac_low', s1_fs_frac_high'];
pfc_rs_frac = [pfc_rs_frac_low', pfc_rs_frac_high'];
pfc_fs_frac = [pfc_fs_frac_low', pfc_fs_frac_high'];
striatum_rs_frac = [striatum_rs_frac_low', striatum_rs_frac_high'];
striatum_fs_frac = [striatum_fs_frac_low', striatum_fs_frac_high'];
hold on 
for i = 1:size(s1_rs_frac,1)
    x = (rand()-0.5) * 0.5;
    y = (rand()-0.5) * 0.01;
    plot(1+x, s1_rs_frac(i,1)+y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(3+x, s1_rs_frac(i,2)+y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([1,3]+x, s1_rs_frac(i,:)+y, '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(1, nanmean(s1_rs_frac(:,1)), ste(s1_rs_frac(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(3, nanmean(s1_rs_frac(:,2)), ste(s1_rs_frac(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([1,3], [nanmean(s1_rs_frac(:,1)), nanmean(s1_rs_frac(:,2))], 'k--', 'LineWidth', 0.01)

% plot(zeros(1, size(s1_fs_frac,1))+6, s1_fs_frac(:,1), 'r.')
% plot(zeros(1, size(s1_fs_frac,1))+8, s1_fs_frac(:,2), 'b.')
for i = 1:size(s1_fs_frac,1)
    x = (rand()-0.5) * 0.5;
    y = (rand()-0.5) * 0.01;
    plot(6+x, s1_fs_frac(i,1)+y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(8+x, s1_fs_frac(i,2)+y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([6,8]+x, s1_fs_frac(i,:)+y, '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(6, nanmean(s1_fs_frac(:,1)), ste(s1_fs_frac(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(8, nanmean(s1_fs_frac(:,2)), ste(s1_fs_frac(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([6,8], [nanmean(s1_fs_frac(:,1)), nanmean(s1_fs_frac(:,2))], 'k--', 'LineWidth', 0.01)

% plot(zeros(1, size(pfc_rs_frac,1))+11, pfc_rs_frac(:,1), 'r.')
% plot(zeros(1, size(pfc_rs_frac,1))+13, pfc_rs_frac(:,2), 'b.')
for i = 1:size(pfc_rs_frac,1)
    x = (rand()-0.5) * 0.5;
    y = (rand()-0.5) * 0.01;
    plot(11+x, pfc_rs_frac(i,1)+y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(13+x, pfc_rs_frac(i,2)+y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([11,13]+x, pfc_rs_frac(i,:)+y, '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(11, nanmean(pfc_rs_frac(:,1)), ste(pfc_rs_frac(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(13, nanmean(pfc_rs_frac(:,2)), ste(pfc_rs_frac(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([11,13], [nanmean(pfc_rs_frac(:,1)), nanmean(pfc_rs_frac(:,2))], 'k--', 'LineWidth', 0.01)

% plot(zeros(1, size(pfc_fs_frac,1))+16, pfc_fs_frac(:,1), 'r.')
% plot(zeros(1, size(pfc_fs_frac,1))+18, pfc_fs_frac(:,2), 'b.')
for i = 1:size(pfc_fs_frac,1)
    x = (rand()-0.5) * 0.5;
    y = (rand()-0.5) * 0.01;
    plot(16+x, pfc_fs_frac(i,1)+y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(18+x, pfc_fs_frac(i,2)+y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([16,18]+x, pfc_fs_frac(i,:)+y, '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(16, nanmean(pfc_fs_frac(:,1)), ste(pfc_fs_frac(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(18, nanmean(pfc_fs_frac(:,2)), ste(pfc_fs_frac(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([16,18], [nanmean(pfc_fs_frac(:,1)), nanmean(pfc_fs_frac(:,2))], 'k--', 'LineWidth', 0.01)

% plot(zeros(1, size(striatum_rs_frac,1))+21, striatum_rs_frac(:,1), 'r.')
% plot(zeros(1, size(striatum_rs_frac,1))+23, striatum_rs_frac(:,2), 'b.')
for i = 1:size(striatum_rs_frac,1)
    x = (rand()-0.5) * 0.5;
    y = (rand()-0.5) * 0.01;
    plot(21+x, striatum_rs_frac(i,1)+y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(23+x, striatum_rs_frac(i,2)+y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([21,23]+x, striatum_rs_frac(i,:)+y, '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(21, nanmean(striatum_rs_frac(:,1)), ste(striatum_rs_frac(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(23, nanmean(striatum_rs_frac(:,2)), ste(striatum_rs_frac(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([21,23], [nanmean(striatum_rs_frac(:,1)), nanmean(striatum_rs_frac(:,2))], 'k--', 'LineWidth', 0.01)

% plot(zeros(1, size(striatum_fs_frac,1))+26, striatum_fs_frac(:,1), 'r.')
% plot(zeros(1, size(striatum_fs_frac,1))+28, striatum_fs_frac(:,2), 'b.')
for i = 1:size(striatum_fs_frac,1)
    x = (rand()-0.5) * 0.5;
    y = (rand()-0.5) * 0.01;
    plot(26+x, striatum_fs_frac(i,1)+y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(28+x, striatum_fs_frac(i,2)+y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([26,28]+x, striatum_fs_frac(i,:)+y, '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(26, nanmean(striatum_fs_frac(:,1)), ste(striatum_fs_frac(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(28, nanmean(striatum_fs_frac(:,2)), ste(striatum_fs_frac(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([26,28], [nanmean(striatum_fs_frac(:,1)), nanmean(striatum_fs_frac(:,2))], 'k--', 'LineWidth', 0.01)
xticks([2, 7, 12, 17, 22, 27])
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS'})
ylim([0,1.05])
yticks([0,1]);
yticklabels({'0', '100'})
ylabel('% Modulated per Session ', 'FontSize', 14)
ax = gca;
ax.YAxis.FontSize = 14;
ax.XAxis.FontSize = 14;

axs(2) = nexttile;
s1_rs_mi = [s1_rs_low_mi, s1_rs_high_mi];
s1_fs_mi = [s1_fs_low_mi, s1_fs_high_mi];
pfc_rs_mi = [pfc_rs_low_mi, pfc_rs_high_mi];
pfc_fs_mi = [pfc_fs_low_mi, pfc_fs_high_mi];
striatum_rs_mi = [striatum_rs_low_mi, striatum_rs_high_mi];
striatum_fs_mi = [striatum_fs_low_mi, striatum_fs_high_mi];
hold on 
for i = 1:size(s1_rs_mi,1)
    x = (rand()-0.5) * 0.5;
    plot(1+x, log(s1_rs_mi(i,1)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(3+x, log(s1_rs_mi(i,2)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([1,3], log(s1_rs_mi(i,:)), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(1, nanmean(log(s1_rs_mi(:,1))), ste(log(s1_rs_mi(:,1))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(3, nanmean(log(s1_rs_mi(:,2))), ste(log(s1_rs_mi(:,2))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([1,3], [nanmean(log(s1_rs_mi(:,1))), nanmean(log(s1_rs_mi(:,2)))], 'k--', 'LineWidth', 0.01)

for i = 1:size(s1_fs_mi,1)
    x = (rand()-0.5) * 0.5;
    plot(6+x, log(s1_fs_mi(i,1)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(8+x, log(s1_fs_mi(i,2)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([6,8], log(s1_fs_mi(i,:)), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(6, nanmean(log(s1_fs_mi(:,1))), ste(log(s1_fs_mi(:,1))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(8, nanmean(log(s1_fs_mi(:,2))), ste(log(s1_fs_mi(:,2))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([6,8], [nanmean(log(s1_fs_mi(:,1))), nanmean(log(s1_fs_mi(:,2)))], 'k--', 'LineWidth', 0.01)

for i = 1:size(pfc_rs_mi,1)
    x = (rand()-0.5) * 0.5;
    plot(11+x, log(pfc_rs_mi(i,1)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(13+x, log(pfc_rs_mi(i,2)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([11,13], log(pfc_rs_mi(i,:)), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(11, nanmean(log(pfc_rs_mi(:,1))), ste(log(pfc_rs_mi(:,1))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(13, nanmean(log(pfc_rs_mi(:,2))), ste(log(pfc_rs_mi(:,2))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([11,13], [nanmean(log(pfc_rs_mi(:,1))), nanmean(log(pfc_rs_mi(:,2)))], 'k--', 'LineWidth', 0.01)

for i = 1:size(pfc_fs_mi,1)
    x = (rand()-0.5) * 0.5;
    plot(16+x, log(pfc_fs_mi(i,1)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(18+x, log(pfc_fs_mi(i,2)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([16,18], log(pfc_fs_mi(i,:)), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(16, nanmean(log(pfc_fs_mi(:,1))), ste(log(pfc_fs_mi(:,1))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(18, nanmean(log(pfc_fs_mi(:,2))), ste(log(pfc_fs_mi(:,2))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([16,18], [nanmean(log(pfc_fs_mi(:,1))), nanmean(log(pfc_fs_mi(:,2)))], 'k--', 'LineWidth', 0.01)

for i = 1:size(striatum_rs_mi,1)
    x = (rand()-0.5) * 0.5;
    plot(21+x, log(striatum_rs_mi(i,1)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(23+x, log(striatum_rs_mi(i,2)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([21,23], log(striatum_rs_mi(i,:)), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(21, nanmean(log(striatum_rs_mi(:,1))), ste(log(striatum_rs_mi(:,1))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(23, nanmean(log(striatum_rs_mi(:,2))), ste(log(striatum_rs_mi(:,2))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([21,23], [nanmean(log(striatum_rs_mi(:,1))), nanmean(log(striatum_rs_mi(:,2)))], 'k--', 'LineWidth', 0.01)

for i = 1:size(striatum_fs_mi,1)
    x = (rand()-0.5) * 0.5;
    plot(26+x, log(striatum_fs_mi(i,1)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(28+x, log(striatum_fs_mi(i,2)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([26,28], log(striatum_fs_mi(i,:)), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(26, nanmean(log(striatum_fs_mi(:,1))), ste(log(striatum_fs_mi(:,1))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(28, nanmean(log(striatum_fs_mi(:,2))), ste(log(striatum_fs_mi(:,2))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([26,28], [nanmean(log(striatum_fs_mi(:,1))), nanmean(log(striatum_fs_mi(:,2)))], 'k--', 'LineWidth', 0.01)
xticks([2, 7, 12, 17, 22, 27])
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS'})
ylabel('log Modulation Index ', 'FontSize', 14)
lims = ylim;
% ylim([0, lims(2)])
yticks([lims(1), lims(2)])
ax = gca;
ax.YAxis.FontSize = 14;
ax.XAxis.FontSize = 14;

axs(3) = nexttile;
s1_rs_fr = [s1_rs_low_fr, s1_rs_high_fr];
s1_fs_fr = [s1_fs_low_fr, s1_fs_high_fr];
pfc_rs_fr = [pfc_rs_low_fr, pfc_rs_high_fr];
pfc_fs_fr = [pfc_fs_low_fr, pfc_fs_high_fr];
striatum_rs_fr = [striatum_rs_low_fr, striatum_rs_high_fr];
striatum_fs_fr = [striatum_fs_low_fr, striatum_fs_high_fr];
hold on 
for i = 1:size(s1_rs_fr,1)
    x = (rand()-0.5) * 0.5;
    plot(1+x, s1_rs_fr(i,1), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(3+x, s1_rs_fr(i,2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([1,3], s1_rs_fr(i,:), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(1, nanmean(s1_rs_fr(:,1)), ste(s1_rs_fr(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(3, nanmean(s1_rs_fr(:,2)), ste(s1_rs_fr(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([1,3], [nanmean(s1_rs_fr(:,1)), nanmean(s1_rs_fr(:,2))], 'k--', 'LineWidth', 0.01)

for i = 1:size(s1_fs_fr,1)
    x = (rand()-0.5) * 0.5;
    plot(6+x, s1_fs_fr(i,1), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(8+x, s1_fs_fr(i,2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([6,8], s1_fs_fr(i,:), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(6, nanmean(s1_fs_fr(:,1)), ste(s1_fs_fr(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(8, nanmean(s1_fs_fr(:,2)), ste(s1_fs_fr(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([6,8], [nanmean(s1_fs_fr(:,1)), nanmean(s1_fs_fr(:,2))], 'k--', 'LineWidth', 0.01)

for i = 1:size(pfc_rs_fr,1)
    x = (rand()-0.5) * 0.5;
    plot(11+x, pfc_rs_fr(i,1), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(13+x, pfc_rs_fr(i,2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([11,13], pfc_rs_fr(i,:), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(11, nanmean(pfc_rs_fr(:,1)), ste(pfc_rs_fr(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(13, nanmean(pfc_rs_fr(:,2)), ste(pfc_rs_fr(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([11,13], [nanmean(pfc_rs_fr(:,1)), nanmean(pfc_rs_fr(:,2))], 'k--', 'LineWidth', 0.01)

for i = 1:size(pfc_fs_fr,1)
    x = (rand()-0.5) * 0.5;
    plot(16+x, pfc_fs_fr(i,1), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(18+x, pfc_fs_fr(i,2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([16,18], pfc_fs_fr(i,:), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(16, nanmean(pfc_fs_fr(:,1)), ste(pfc_fs_fr(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(18, nanmean(pfc_fs_fr(:,2)), ste(pfc_fs_fr(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([16,18], [nanmean(pfc_fs_fr(:,1)), nanmean(pfc_fs_fr(:,2))], 'k--', 'LineWidth', 0.01)

for i = 1:size(striatum_rs_fr,1)
    x = (rand()-0.5) * 0.5;
    plot(21+x, striatum_rs_fr(i,1), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(23+x, striatum_rs_fr(i,2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([21,23], striatum_rs_fr(i,:), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(21, nanmean(striatum_rs_fr(:,1)), ste(striatum_rs_fr(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(23, nanmean(striatum_rs_fr(:,2)), ste(striatum_rs_fr(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([21,23], [nanmean(striatum_rs_fr(:,1)), nanmean(striatum_rs_fr(:,2))], 'k--', 'LineWidth', 0.01)

for i = 1:size(striatum_fs_fr,1)
    x = (rand()-0.5) * 0.5;
    plot(26+x, striatum_fs_fr(i,1), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(28+x, striatum_fs_fr(i,2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([26,28], striatum_fs_fr(i,:), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(26, nanmean(striatum_fs_fr(:,1)), ste(striatum_fs_fr(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(28, nanmean(striatum_fs_fr(:,2)), ste(striatum_fs_fr(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([26,28], [nanmean(striatum_fs_fr(:,1)), nanmean(striatum_fs_fr(:,2))], 'k--', 'LineWidth', 0.01)
xticks([2, 7, 12, 17, 22, 27])
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS'})
ylabel('Firing Rate (Hz) ', 'FontSize', 14)
lims = ylim;
ylim([0, lims(2)])
yticks([0, lims(2)])
ax = gca;
ax.YAxis.FontSize = 14;
ax.XAxis.FontSize = 14;

s1_rs_theta_fig = figure();
polarhistogram(s1_rs_theta_bar_low, 36, 'FaceColor', 'r')
hold on
polarhistogram(s1_rs_theta_bar_high, 36, 'FaceColor', 'b')
thetaticks([0 90 180 270])
pax = gca;
pax.GridColor = [0 0 0];          % Black grid lines
pax.GridAlpha = 1;                % Fully opaque grid lines
pax.GridLineStyle = '--';         % Dashed grid lines for visibility

s1_fs_theta_fig = figure();
polarhistogram(s1_fs_theta_bar_low, 36, 'FaceColor', 'r')
hold on
polarhistogram(s1_fs_theta_bar_high, 36, 'FaceColor', 'b')
thetaticks([0 90 180 270])
pax = gca;
pax.GridColor = [0 0 0];          % Black grid lines
pax.GridAlpha = 1;                % Fully opaque grid lines
pax.GridLineStyle = '--';         % Dashed grid lines for visibility

pfc_rs_theta_fig = figure();
polarhistogram(pfc_rs_theta_bar_low, 36, 'FaceColor', 'r')
hold on
polarhistogram(pfc_rs_theta_bar_high, 36, 'FaceColor', 'b')
thetaticks([0 90 180 270])
pax = gca;
pax.GridColor = [0 0 0];          % Black grid lines
pax.GridAlpha = 1;                % Fully opaque grid lines
pax.GridLineStyle = '--';         % Dashed grid lines for visibility

pfc_fs_theta_fig = figure();
polarhistogram(pfc_fs_theta_bar_low, 36, 'FaceColor', 'r')
hold on
polarhistogram(pfc_fs_theta_bar_high, 36, 'FaceColor', 'b')
thetaticks([0 90 180 270])
pax = gca;
pax.GridColor = [0 0 0];          % Black grid lines
pax.GridAlpha = 1;                % Fully opaque grid lines
pax.GridLineStyle = '--';         % Dashed grid lines for visibility

striatum_rs_theta_fig = figure();
polarhistogram(striatum_rs_theta_bar_low, 36, 'FaceColor', 'r')
hold on
polarhistogram(striatum_rs_theta_bar_high, 36, 'FaceColor', 'b')
thetaticks([0 90 180 270])
pax = gca;
pax.GridColor = [0 0 0];          % Black grid lines
pax.GridAlpha = 1;                % Fully opaque grid lines
pax.GridLineStyle = '--';         % Dashed grid lines for visibility

striatum_fs_theta_fig = figure();
polarhistogram(striatum_fs_theta_bar_low, 36, 'FaceColor', 'r')
hold on
polarhistogram(striatum_fs_theta_bar_high, 36, 'FaceColor', 'b')
thetaticks([0 90 180 270])
pax = gca;
pax.GridColor = [0 0 0];          % Black grid lines
pax.GridAlpha = 1;                % Fully opaque grid lines
pax.GridLineStyle = '--';         % Dashed grid lines for visibility

angle_diff_fig = figure('Position', [1475 1124 396 577]);
hold on 
plot(zeros(length(s1_rs_theta_bar_low),1)+1+(rand(length(s1_rs_theta_bar_low),1)-0.5)*0.3, circ_dist(s1_rs_theta_bar_low, s1_rs_theta_bar_high), '.', 'Color', [0.5, 0.5, 0.5])
plot(zeros(length(s1_fs_theta_bar_low),1)+2+(rand(length(s1_fs_theta_bar_low),1)-0.5)*0.3, circ_dist(s1_fs_theta_bar_low, s1_fs_theta_bar_high), '.', 'Color', [0.5, 0.5, 0.5])
plot(zeros(length(pfc_rs_theta_bar_low),1)+4+(rand(length(pfc_rs_theta_bar_low),1)-0.5)*0.3, circ_dist(pfc_rs_theta_bar_low, pfc_rs_theta_bar_high), '.', 'Color', [0.5, 0.5, 0.5])
plot(zeros(length(pfc_fs_theta_bar_low),1)+5+(rand(length(pfc_fs_theta_bar_low),1)-0.5)*0.3, circ_dist(pfc_fs_theta_bar_low, pfc_fs_theta_bar_high), '.', 'Color', [0.5, 0.5, 0.5])
plot(zeros(length(striatum_rs_theta_bar_low),1)+7+(rand(length(striatum_rs_theta_bar_low),1)-0.5)*0.3, circ_dist(striatum_rs_theta_bar_low, striatum_rs_theta_bar_high), '.', 'Color', [0.5, 0.5, 0.5])
plot(zeros(length(striatum_fs_theta_bar_low),1)+8+(rand(length(striatum_fs_theta_bar_low),1)-0.5)*0.3, circ_dist(striatum_fs_theta_bar_low, striatum_fs_theta_bar_high), '.', 'Color', [0.5, 0.5, 0.5])
errorbar([1,2,4,5,7,8], ...
    [circ_mean(circ_dist(s1_rs_theta_bar_low, s1_rs_theta_bar_high)), ...
    circ_mean(circ_dist(s1_fs_theta_bar_low, s1_fs_theta_bar_high)), ...
    circ_mean(circ_dist(pfc_rs_theta_bar_low, pfc_rs_theta_bar_high)), ...
    circ_mean(circ_dist(pfc_fs_theta_bar_low, pfc_fs_theta_bar_high)), ...
    circ_mean(circ_dist(striatum_rs_theta_bar_low, striatum_rs_theta_bar_high)), ...
    circ_mean(circ_dist(striatum_fs_theta_bar_low, striatum_fs_theta_bar_high))], ...
    [circ_ste(circ_dist(s1_rs_theta_bar_low, s1_rs_theta_bar_high)), ...
    circ_ste(circ_dist(s1_fs_theta_bar_low, s1_fs_theta_bar_high)), ...
    circ_ste(circ_dist(pfc_rs_theta_bar_low, pfc_rs_theta_bar_high)), ...
    circ_ste(circ_dist(pfc_fs_theta_bar_low, pfc_fs_theta_bar_high)), ...
    circ_ste(circ_dist(striatum_rs_theta_bar_low, striatum_rs_theta_bar_high)), ...
    circ_ste(circ_dist(striatum_fs_theta_bar_low, striatum_fs_theta_bar_high))], ...
    'k.', 'MarkerSize', 5, 'CapSize', 15, 'LineWidth', 1.5)
xticks([1,2,4,5,7,8])
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS'})
ylim([-pi,pi])
yticks([-pi,0,pi])
yticklabels({'-\pi', '0', '\pi'})
ylabel('Difference in Preferred Anlge (rad)')
ax = gca;
ax.YAxis.FontSize = 14;
ax.XAxis.FontSize = 14;

keyboard 

if out_path
    % saveas(updated_fig, '../Figures/lowVsHighAlpha_summary.svg')
    print(updated_fig,'-vector','-dsvg','../Figures/lowVsHighAlpha_summary.svg') % svg
    saveas(updated_fig, '../Figures/lowVsHighAlpha_summary.fig')
    saveas(s1_rs_theta_fig, '../Figures/s1_rs_theta_low_vs_high.svg')
    saveas(s1_rs_theta_fig, '../Figures/s1_rs_theta_low_vs_high.fig')
    saveas(s1_fs_theta_fig, '../Figures/s1_fs_theta_low_vs_high.svg')
    saveas(s1_fs_theta_fig, '../Figures/s1_fs_theta_low_vs_high.fig')
    saveas(pfc_rs_theta_fig, '../Figures/pfc_rs_theta_low_vs_high.svg')
    saveas(pfc_rs_theta_fig, '../Figures/pfc_rs_theta_low_vs_high.fig')
    saveas(pfc_fs_theta_fig, '../Figures/pfc_fs_theta_low_vs_high.svg')
    saveas(pfc_fs_theta_fig, '../Figures/pfc_fs_theta_low_vs_high.fig')
    saveas(striatum_rs_theta_fig, '../Figures/striatum_rs_theta_low_vs_high.svg')
    saveas(striatum_rs_theta_fig, '../Figures/striatum_rs_theta_low_vs_high.fig')
    saveas(striatum_fs_theta_fig, '../Figures/striatum_fs_theta_low_vs_high.svg')
    saveas(striatum_fs_theta_fig, '../Figures/striatum_fs_theta_low_vs_high.fig')
    saveas(angle_diff_fig, '../Figures/angle_diff.svg')
    saveas(angle_diff_fig, '../Figures/angle_diff.fig')
end

% %% example figure
% load(strcat(ext_path, 'AP/date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'))
% load(strcat(ext_path, 'LFP/date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'))
% load(strcat(ext_path, 'SLRT/date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'))

% alpha_powers = [];
% all_phases = [];
% all_times = [];
% cid = 218; % fast spiking 
% for t = 1:size(slrt_data,1)
%     c = find(ap_data(t,:).spiking_data{1}.cluster_id == cid);
%     cluster_channel = ap_data(t,:).spiking_data{1}(c,:).channel{1};
%     lfp = lfp_data(t,:).lfp{1}(cluster_channel,:);
%     lfp_times = lfp_data(t,:).left_trigger_aligned_lfp_time{1};
%     lfp_time = lfp_data(t,:).lfpTime{1};
%     alpha = bandpassFilter(lfp, 8, 12, 500);
%     spike_times = ap_data(t,:).spiking_data{1}(c,:).left_trigger_aligned_spike_times{1};
%     phi = angle(hilbert(alpha));
%     ALPHA = abs(hilbert(alpha)).^2;
%     delta = bandpassFilter(lfp, 1, 4, 500);
%     DELTA = abs(hilbert(delta)).^2;
%     spike_phases = zeros(1,length(spike_times));
%     for i = 1:length(spike_times)
%         [~, tind] = min((lfp_times - spike_times(i)).^2);
%         spike_phases(i) = phi(tind);
%     end
%     spike_phases = spike_phases(spike_times > -3 & spike_times < 0);
%     alpha_powers = [alpha_powers, ALPHA(lfp_times > -3 & lfp_times < 0)];
%     all_times = [all_times, lfp_time(lfp_times > -3 & lfp_times < 0)];
% end

% high_phases = [];
% low_phases = [];
% high_frs = [];
% low_frs = [];
% for t = 1:size(slrt_data,1)
%     c = find(ap_data(t,:).spiking_data{1}.cluster_id == cid);
%     cluster_channel = ap_data(t,:).spiking_data{1}(c,:).channel{1};
%     lfp = lfp_data(t,:).lfp{1}(cluster_channel,:);
%     lfp_times = lfp_data(t,:).left_trigger_aligned_lfp_time{1};
%     alpha = bandpassFilter(lfp, 8, 12, 500);
%     spike_times = ap_data(t,:).spiking_data{1}(c,:).left_trigger_aligned_spike_times{1};
%     phi = angle(hilbert(alpha));
%     ALPHA = abs(hilbert(alpha)).^2;
%     delta = bandpassFilter(lfp, 1, 4, 500);
%     DELTA = abs(hilbert(delta)).^2;
%     for i = 1:length(spike_times)
%         [~, tind] = min((lfp_times - spike_times(i)).^2);
%         spike_phases(i) = phi(tind);
%     end
%     spike_phases = spike_phases(spike_times > -3 & spike_times < 0);
%     spike_times = spike_times(spike_times > -3 & spike_times < 0);
%     ALPHA = ALPHA(lfp_times > -3 & lfp_times < 0);
%     lfp_times = lfp_times(lfp_times > -3 & lfp_times < 0);
%     high_inds = findEvents(ALPHA, lfp_times, prctile(alpha_powers, 75), 0.33, 0.2, 'above');
%     if size(high_inds,1)
%         for n = 1:size(high_inds,1)
%             begin = lfp_times(high_inds(n,1));
%             fin = lfp_times(high_inds(n,2));
%             high_phases = [high_phases, spike_phases(spike_times > begin & spike_times < fin)];
%             high_frs = [high_frs, length(spike_phases(spike_times > begin & spike_times < fin)) / (fin-begin)];
%         end
%     end
%     low_inds = findEvents(ALPHA, lfp_times, prctile(alpha_powers, 50), 0.33, 0.2, 'below');
%     if size(low_inds,1)
%         for n = 1:size(low_inds,1)
%             begin = lfp_times(low_inds(n,1));
%             fin = lfp_times(low_inds(n,2));
%             low_phases = [low_phases, spike_phases(spike_times >= begin & spike_times <= fin)];
%             low_frs = [low_frs, length(spike_phases(spike_times > begin & spike_times < fin)) / (fin-begin)];
%         end
%     end
% end

% example_fig = figure('Position', [1220 1318 984 400]);
% tl = tiledlayout(1, 2);
% axs(1) = nexttile;
% [Nlow, edges] = histcounts(low_phases, 20, 'Normalization', 'pdf');
% centers = zeros(length(edges)-1,1);
% for e = 1:(length(edges)-1)
%     centers(e) = mean(edges(e:(e+1)));
% end
% [x,y, ~, ~, ~] = vonMises(low_phases);
% bar(centers, Nlow, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
% hold on
% plot(x,y, 'k', 'LineWidth', 1.5);
% xticks([-pi, 0, pi])
% xticklabels({'-\pi', '0', '\pi'})
% title('Low Alpha Power')
% ylim([0,0.35])
% yticks([0,0.35])
% axs(2) = nexttile;
% [Nhigh, edges] = histcounts(high_phases, 20, 'Normalization', 'pdf');
% centers = zeros(length(edges)-1,1);
% for e = 1:(length(edges)-1)
%     centers(e) = mean(edges(e:(e+1)));
% end
% [x,y, ~, ~, ~] = vonMises(high_phases);
% bar(centers, Nhigh, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
% hold on
% plot(x,y, 'k', 'LineWidth', 1.5);
% xticks([-pi, 0, pi])
% xticklabels({'-\pi', '0', '\pi'})
% title('High Alpha Power')
% xlabel(tl, 'Alpha Phase (rad)', 'FontSize', 14)
% ylabel(tl, 'Spike PDF', 'FontSize', 14)
% ylim([0,0.35])
% yticks([0,0.35])
% yticklabels({})

% if out_path
%     saveas(example_fig, '../Figures/examp_high_low.svg')
%     saveas(example_fig, '../Figures/examp_high_low.fig')
% end

% [Nlow, ~] = histcounts(low_phases, 20);
% [Nhigh, ~] = histcounts(high_phases, 20);
% low_mi = compute_modulation_index(Nlow);
% high_mi = compute_modulation_index(Nhigh);
% low_p = circ_rtest(low_phases);
% high_p = circ_rtest(high_phases);
% [Nlow, edges] = histcounts(low_phases, 20, 'Normalization', 'pdf');
% centers = zeros(length(edges)-1,1);
% for e = 1:(length(edges)-1)
%     centers(e) = mean(edges(e:(e+1)));
% end
% [x,y, theta_bar_low ~, ~] = vonMises(low_phases);
% y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
% low_mse = mean((Nlow(2:end-1) - y_interpolated').^2);
% [Nhigh, edges] = histcounts(high_phases, 20, 'Normalization', 'pdf');
% centers = zeros(length(edges)-1,1);
% for e = 1:(length(edges)-1)
%     centers(e) = mean(edges(e:(e+1)));
% end
% [x,y, theta_bar_high ~, ~] = vonMises(high_phases);
% y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
% high_mse = mean((Nhigh(2:end-1) - y_interpolated').^2);

% fprintf(sprintf('Example Low Alpha Power MI: %.4f\n', low_mi))
% fprintf(sprintf('Example Low Alpha Power von Mises MSE: %.4f\n', low_mse))
% fprintf(sprintf('Example Low Alpha Power Rayleigh test: p = %d\n', low_p))
% fprintf(sprintf('Example High Alpha Power MI: %.4f\n', high_mi))
% fprintf(sprintf('Example High Alpha Power von Mises MSE: %.4f\n', high_mse))
% fprintf(sprintf('Example High Alpha Power Rayleigh test: p = %d\n', high_p))

diary off