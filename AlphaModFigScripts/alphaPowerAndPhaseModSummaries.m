addpath(genpath('~/circstat-matlab/'))
load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Combo/Cortex/Spontaneous_Alpha_Modulation_v2/data.mat
alpha_modulated = out.alpha_modulated;
p_threshold = out.overall_p_threshold;
clear out 
out_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Combo/Cortex/Spontaneous_Alpha_Modulation_v2/high_v_low_alpha.mat';
load(out_file)
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


load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/PFC_Expert_Combo/PFC/Spontaneous_Alpha_Modulation_v2/data.mat
alpha_modulated = out.alpha_modulated;
p_threshold = out.overall_p_threshold;
clear out 
out_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/PFC_Expert_Combo/PFC/Spontaneous_Alpha_Modulation_v2/high_v_low_alpha.mat';
load(out_file)
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


load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Combo/Basal_Ganglia/Spontaneous_Alpha_Modulation_v2/data.mat
alpha_modulated = out.alpha_modulated;
p_threshold = out.overall_p_threshold;
clear out 
out_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Combo/Basal_Ganglia/Spontaneous_Alpha_Modulation_v2/high_v_low_alpha.mat';
load(out_file)
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

load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Combo/Amygdala/Spontaneous_Alpha_Modulation_v2/data.mat
alpha_modulated = out.alpha_modulated;
p_threshold = out.overall_p_threshold;
clear out 
out_file = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/Expert_Combo/Amygdala/Spontaneous_Alpha_Modulation_v2/high_v_low_alpha.mat';
load(out_file)
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
bar([2,5,8,11,14,17, 20, 23], ...
    [s1_rs_high_mi_avg, s1_fs_high_mi_avg, ...
    pfc_rs_high_mi_avg, pfc_fs_high_mi_avg, ...
    striatum_rs_high_mi_avg, striatum_fs_high_mi_avg, ...
    amygdala_rs_high_mi_avg, amygdala_fs_high_mi_avg], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'b')
bar([1,4,7,10,13,16,19,22], ...
    [s1_rs_low_mi_avg, s1_fs_low_mi_avg, ...
    pfc_rs_low_mi_avg, pfc_fs_low_mi_avg, ...
    striatum_rs_low_mi_avg, striatum_fs_low_mi_avg, ...
    amygdala_rs_low_mi_avg, amygdala_fs_low_mi_avg], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'r')
errorbar([2,5,8,11,14,17, 20, 23], ...
    [s1_rs_high_mi_avg, s1_fs_high_mi_avg, ...
    pfc_rs_high_mi_avg, pfc_fs_high_mi_avg, ...
    striatum_rs_high_mi_avg, striatum_fs_high_mi_avg, ...
    amygdala_rs_high_mi_avg, amygdala_fs_high_mi_avg], ...
    [s1_rs_high_mi_err, s1_fs_high_mi_err, ...
    pfc_rs_high_mi_err, pfc_fs_high_mi_err, ...
    striatum_rs_high_mi_err, striatum_fs_high_mi_err, ...
    amygdala_rs_high_mi_err, amygdala_fs_high_mi_err], ...
    'k.')
errorbar([1,4,7,10,13,16,19,22], ...
    [s1_rs_low_mi_avg, s1_fs_low_mi_avg, ...
    pfc_rs_low_mi_avg, pfc_fs_low_mi_avg, ...
    striatum_rs_low_mi_avg, striatum_fs_low_mi_avg, ...
    amygdala_rs_low_mi_avg, amygdala_fs_low_mi_avg], ...
    [s1_rs_low_mi_err, s1_fs_low_mi_err, ...
    pfc_rs_low_mi_err, pfc_fs_low_mi_err, ...
    striatum_rs_low_mi_err, striatum_fs_low_mi_err, ...
    amygdala_rs_low_mi_err, amygdala_fs_low_mi_err], ...
    'k.')
xticks([1.5, 4.5, 7.5, 10.5, 13.5, 16.5, 19.5, 22.5])
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS', 'Amygdala RS', 'Amygdala FS'})
xtickangle(45)
% ylim([0,0.12])
% yticks([0,0.12])
lims = ylim;
yticks([0,lims(2)])
ylabel('Modulation Index', 'FontSize', 14)

axs(2) = nexttile;
hold on
bar([2,5,8,11,14,17, 20, 23], ...
    [s1_rs_high_mse_avg, s1_fs_high_mse_avg, ...
    pfc_rs_high_mse_avg, pfc_fs_high_mse_avg, ...
    striatum_rs_high_mse_avg, striatum_fs_high_mse_avg, ...
    amygdala_rs_high_mse_avg, amygdala_fs_high_mse_avg], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'b')
bar([1,4,7,10,13,16,19,22], ...
    [s1_rs_low_mse_avg, s1_fs_low_mse_avg, ...
    pfc_rs_low_mse_avg, pfc_fs_low_mse_avg, ...
    striatum_rs_low_mse_avg, striatum_fs_low_mse_avg, ...
    amygdala_rs_low_mse_avg, amygdala_fs_low_mse_avg], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'r')
errorbar([2,5,8,11,14,17, 20, 23], ...
    [s1_rs_high_mse_avg, s1_fs_high_mse_avg, ...
    pfc_rs_high_mse_avg, pfc_fs_high_mse_avg, ...
    striatum_rs_high_mse_avg, striatum_fs_high_mse_avg, ...
    amygdala_rs_high_mse_avg, amygdala_fs_high_mse_avg], ...
    [s1_rs_high_mse_err, s1_fs_high_mse_err, ...
    pfc_rs_high_mse_err, pfc_fs_high_mse_err, ...
    striatum_rs_high_mse_err, striatum_fs_high_mse_err, ...
    amygdala_rs_high_mse_err, amygdala_fs_high_mse_err], ...
    'k.')
errorbar([1,4,7,10,13,16,19,22], ...
    [s1_rs_low_mse_avg, s1_fs_low_mse_avg, ...
    pfc_rs_low_mse_avg, pfc_fs_low_mse_avg, ...
    striatum_rs_low_mse_avg, striatum_fs_low_mse_avg, ...
    amygdala_rs_low_mse_avg, amygdala_fs_low_mse_avg], ...
    [s1_rs_low_mse_err, s1_fs_low_mse_err, ...
    pfc_rs_low_mse_err, pfc_fs_low_mse_err, ...
    striatum_rs_low_mse_err, striatum_fs_low_mse_err, ...
    amygdala_rs_low_mse_err, amygdala_fs_low_mse_err], ...
    'k.')
xticks([1.5, 4.5, 7.5, 10.5, 13.5, 16.5, 19.5, 22.5])
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS', 'Amygdala RS', 'Amygdala FS'})
xtickangle(45)
lims = ylim;
yticks([0,lims(2)])
% ylim([0,0.12])
% lims = ylim;
% yticks([0,lims(2)])
ylabel('von Mises MSE', 'FontSize', 14)

axs(3) = nexttile;
hold on
bar([2,5,8,11,14,17, 20, 23], ...
    [s1_rs_high_fr_avg, s1_fs_high_fr_avg, ...
    pfc_rs_high_fr_avg, pfc_fs_high_fr_avg, ...
    striatum_rs_high_fr_avg, striatum_fs_high_fr_avg, ...
    amygdala_rs_high_fr_avg, amygdala_fs_high_fr_avg], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'b')
bar([1,4,7,10,13,16,19,22], ...
    [s1_rs_low_fr_avg, s1_fs_low_fr_avg, ...
    pfc_rs_low_fr_avg, pfc_fs_low_fr_avg, ...
    striatum_rs_low_fr_avg, striatum_fs_low_fr_avg, ...
    amygdala_rs_low_fr_avg, amygdala_fs_low_fr_avg], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'r')
errorbar([2,5,8,11,14,17, 20, 23], ...
    [s1_rs_high_fr_avg, s1_fs_high_fr_avg, ...
    pfc_rs_high_fr_avg, pfc_fs_high_fr_avg, ...
    striatum_rs_high_fr_avg, striatum_fs_high_fr_avg, ...
    amygdala_rs_high_fr_avg, amygdala_fs_high_fr_avg], ...
    [s1_rs_high_fr_err, s1_fs_high_fr_err, ...
    pfc_rs_high_fr_err, pfc_fs_high_fr_err, ...
    striatum_rs_high_fr_err, striatum_fs_high_fr_err, ...
    amygdala_rs_high_fr_err, amygdala_fs_high_fr_err], ...
    'k.')
errorbar([1,4,7,10,13,16,19,22], ...
    [s1_rs_low_fr_avg, s1_fs_low_fr_avg, ...
    pfc_rs_low_fr_avg, pfc_fs_low_fr_avg, ...
    striatum_rs_low_fr_avg, striatum_fs_low_fr_avg, ...
    amygdala_rs_low_fr_avg, amygdala_fs_low_fr_avg], ...
    [s1_rs_low_fr_err, s1_fs_low_fr_err, ...
    pfc_rs_low_fr_err, pfc_fs_low_fr_err, ...
    striatum_rs_low_fr_err, striatum_fs_low_fr_err, ...
    amygdala_rs_low_fr_err, amygdala_fs_low_fr_err], ...
    'k.')
xticks([1.5, 4.5, 7.5, 10.5, 13.5, 16.5, 19.5, 22.5])
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS', 'Amygdala RS', 'Amygdala FS'})
xtickangle(45)
% ylim([0,18])
lims = ylim;
yticks([0,lims(2)])
ylabel('Avg. Firing Rate (Hz)', 'FontSize', 14)

axs(4) = nexttile;
hold on
bar([2,5,8,11,14,17, 20, 23], ...
    [s1_rs_theta_bar_high_avg, s1_fs_theta_bar_high_avg, ...
    pfc_rs_theta_bar_high_avg, pfc_fs_theta_bar_high_avg, ...
    striatum_rs_theta_bar_high_avg, striatum_fs_theta_bar_high_avg, ...
    amygdala_rs_theta_bar_high_avg, amygdala_fs_theta_bar_high_avg], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'b')
bar([1,4,7,10,13,16,19,22], ...
    [s1_rs_theta_bar_low_avg, s1_fs_theta_bar_low_avg, ...
    pfc_rs_theta_bar_low_avg, pfc_fs_theta_bar_low_avg, ...
    striatum_rs_theta_bar_low_avg, striatum_fs_theta_bar_low_avg, ...
    amygdala_rs_theta_bar_low_avg, amygdala_fs_theta_bar_low_avg], 0.3, ...
    'EdgeColor', 'k', 'FaceColor', 'r')
errorbar([2,5,8,11,14,17, 20, 23], ...
    [s1_rs_theta_bar_high_avg, s1_fs_theta_bar_high_avg, ...
    pfc_rs_theta_bar_high_avg, pfc_fs_theta_bar_high_avg, ...
    striatum_rs_theta_bar_high_avg, striatum_fs_theta_bar_high_avg, ...
    amygdala_rs_theta_bar_high_avg, amygdala_fs_theta_bar_high_avg], ...
    [s1_rs_theta_bar_high_err, s1_fs_theta_bar_high_err, ...
    pfc_rs_theta_bar_high_err, pfc_fs_theta_bar_high_err, ...
    striatum_rs_theta_bar_high_err, striatum_fs_theta_bar_high_err, ...
    amygdala_rs_theta_bar_high_err, amygdala_fs_theta_bar_high_err], ...
    'k.')
errorbar([1,4,7,10,13,16,19,22], ...
    [s1_rs_theta_bar_low_avg, s1_fs_theta_bar_low_avg, ...
    pfc_rs_theta_bar_low_avg, pfc_fs_theta_bar_low_avg, ...
    striatum_rs_theta_bar_low_avg, striatum_fs_theta_bar_low_avg, ...
    amygdala_rs_theta_bar_low_avg, amygdala_fs_theta_bar_low_avg], ...
    [s1_rs_theta_bar_low_err, s1_fs_theta_bar_low_err, ...
    pfc_rs_theta_bar_low_err, pfc_fs_theta_bar_low_err, ...
    striatum_rs_theta_bar_low_err, striatum_fs_theta_bar_low_err, ...
    amygdala_rs_theta_bar_low_err, amygdala_fs_theta_bar_low_err], ...
    'k.')
ylabel('Avg. Firing Phase (radians)', 'FontSize', 14)
xticks([1.5, 4.5, 7.5, 10.5, 13.5, 16.5, 19.5, 22.5])
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS', 'Amygdala RS', 'Amygdala FS'})
xtickangle(45)
ylim([-4,4])
yticks([-pi,pi])
yticklabels({'-\pi', '\pi'})
% saveas(fig, 'tmp/lowVsHighAlpha_summary.png')
saveas(fig, 'Figures/lowVsHighAlpha_summary.svg')
saveas(fig, 'Figures/lowVsHighAlpha_summary.fig')

p = signrank(s1_rs_low_mi,s1_rs_high_mi);
if p < (0.05 / length(s1_rs_low_mi))
    fprintf(sprintf('S1 RS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('S1 RS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('S1 RS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
end
fprintf('S1 RS avg high minus low MI: %d\n', nanmean(s1_rs_high_mi-s1_rs_low_mi))
p = signrank(s1_fs_low_mi,s1_fs_high_mi);
if p < (0.05 / length(s1_fs_low_mi))
    fprintf(sprintf('S1 FS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('S1 FS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('S1 FS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
end
fprintf('S1 FS avg high minus low MI: %d\n', nanmean(s1_fs_high_mi-s1_fs_low_mi))
p = signrank(pfc_rs_low_mi,pfc_rs_high_mi);
if p < (0.05 / length(pfc_rs_low_mi))
    fprintf(sprintf('PFC RS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('PFC RS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('PFC RS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
end
fprintf('PFC RS avg high minus low MI: %d\n', nanmean(pfc_rs_high_mi-pfc_rs_low_mi))
p = signrank(pfc_fs_low_mi,pfc_fs_high_mi);
if p < (0.05 / length(pfc_fs_low_mi))
    fprintf(sprintf('PFC FS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('PFC FS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('PFC FS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
end
fprintf('PFC FS avg high minus low MI: %d\n', nanmean(pfc_fs_high_mi-pfc_fs_low_mi))

p = signrank(s1_rs_low_mse,s1_rs_high_mse);
if p < (0.05 / length(s1_rs_low_mse))
    fprintf(sprintf('S1 RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('S1 RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('S1 RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): p = %d\n', p))
end
fprintf('S1 RS avg high minus low MSE: %d\n', nanmean(s1_rs_high_mse-s1_rs_low_mse))
p = signrank(s1_fs_low_mse,s1_fs_high_mse);
if p < (0.05 / length(s1_fs_low_mse))
    fprintf(sprintf('S1 FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('S1 FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('S1 FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): p = %d\n', p))
end
fprintf('S1 FS avg high minus low MSE: %d\n', nanmean(s1_fs_high_mse-s1_fs_low_mse))
p = signrank(pfc_rs_low_mse,pfc_rs_high_mse);
if p < (0.05 / length(pfc_rs_low_mse))
    fprintf(sprintf('PFC RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('PFC RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('PFC RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): p = %d\n', p))
end
fprintf('PFC RS avg high minus low MSE: %d\n', nanmean(pfc_rs_high_mse-pfc_rs_low_mse))
p = signrank(pfc_fs_low_mse,pfc_fs_high_mse);
if p < (0.05 / length(pfc_fs_low_mse))
    fprintf(sprintf('PFC FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('PFC FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('PFC FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): p = %d\n', p))
end
fprintf('PFC FS avg high minus low MSE: %d\n', nanmean(pfc_fs_high_mse-pfc_fs_low_mse))

fprintf(sprintf('S1 RS theta bar distribtions kuipers test: %d\n', circ_kuipertest(s1_rs_theta_bar_low,s1_rs_theta_bar_high)))
fprintf(sprintf('S1 FS theta bar distribtions kuipers test: %d\n', circ_kuipertest(s1_fs_theta_bar_low,s1_fs_theta_bar_high)))
fprintf(sprintf('PFC RS theta bar distribtions kuipers test: %d\n', circ_kuipertest(pfc_rs_theta_bar_low,pfc_rs_theta_bar_high)))
fprintf(sprintf('PFC FS theta bar distribtions kuipers test: %d\n', circ_kuipertest(pfc_fs_theta_bar_low,pfc_fs_theta_bar_high)))

p = signrank(striatum_rs_low_mi,striatum_rs_high_mi);
if p < (0.05 / length(striatum_rs_low_mi))
    fprintf(sprintf('Striatum RS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Striatum RS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum RS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
end
fprintf('Striatum RS avg high minus low MI: %d\n', nanmean(striatum_rs_high_mi-striatum_rs_low_mi))
p = signrank(striatum_fs_low_mi,striatum_fs_high_mi);
if p < (0.05 / length(striatum_fs_low_mi))
    fprintf(sprintf('Striatum FS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Striatum FS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum FS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
end
fprintf('Striatum FS avg high minus low MI: %d\n', nanmean(striatum_fs_high_mi-striatum_fs_low_mi))
p = signrank(amygdala_rs_low_mi,amygdala_rs_high_mi);
if p < (0.05 / length(amygdala_rs_low_mi))
    fprintf(sprintf('Amygdala RS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Amygdala RS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala RS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
end
fprintf('Amygdala RS avg high minus low MI: %d\n', nanmean(amygdala_rs_high_mi-amygdala_rs_low_mi))
p = signrank(amygdala_fs_low_mi,amygdala_fs_high_mi);
if p < (0.05 / length(amygdala_fs_low_mi))
    fprintf(sprintf('Amygdala FS low alpha MI vs high alpha MI (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Amygdala FS low alpha MI vs high alpha MI (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala FS low alpha MI vs high alpha MI (signed-rank): p = %d\n', p))
end
fprintf('Amygdala FS avg high minus low MI: %d\n', nanmean(amygdala_fs_high_mi-amygdala_fs_low_mi))

p = signrank(striatum_rs_low_mse,striatum_rs_high_mse);
if p < (0.05 / length(striatum_rs_low_mse))
    fprintf(sprintf('Striatum RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Striatum RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): p = %d\n', p))
end
fprintf('Striatum RS avg high minus low MSE: %d\n', nanmean(striatum_rs_high_mse-striatum_rs_low_mse))
p = signrank(striatum_fs_low_mse,striatum_fs_high_mse);
if p < (0.05 / length(striatum_fs_low_mse))
    fprintf(sprintf('Striatum FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Striatum FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): p = %d\n', p))
end
fprintf('Striatum FS avg high minus low MSE: %d\n', nanmean(striatum_fs_high_mse-striatum_fs_low_mse))
p = signrank(amygdala_rs_low_mse,amygdala_rs_high_mse);
if p < (0.05 / length(amygdala_rs_low_mse))
    fprintf(sprintf('Amygdala RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Amygdala RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): p = %d\n', p))
end
fprintf('Amygdala RS avg high minus low MSE: %d\n', nanmean(amygdala_rs_high_mse-amygdala_rs_low_mse))
p = signrank(amygdala_fs_low_mse,amygdala_fs_high_mse);
if p < (0.05 / length(amygdala_fs_low_mse))
    fprintf(sprintf('Amygdala FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Amygdala FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): p = %d\n', p))
end
fprintf('Amygdala FS avg high minus low MSE: %d\n', nanmean(amygdala_fs_high_mse-amygdala_fs_low_mse))

fprintf(sprintf('Striatum RS theta bar distribtions kuipers test: %d\n', circ_kuipertest(striatum_rs_theta_bar_low,striatum_rs_theta_bar_high)))
fprintf(sprintf('Striatum FS theta bar distribtions kuipers test: %d\n', circ_kuipertest(striatum_fs_theta_bar_low,striatum_fs_theta_bar_high)))
fprintf(sprintf('Amygdala RS theta bar distribtions kuipers test: NaN (n too small) \n')) %, circ_kuipertest(amygdala_rs_theta_bar_low,amygdala_rs_theta_bar_high)))
fprintf(sprintf('Amygdala FS theta bar distribtions kuipers test: %d\n', circ_kuipertest(amygdala_fs_theta_bar_low,amygdala_fs_theta_bar_high)))

p = signrank(s1_rs_low_fr,s1_rs_high_fr);
if p < (0.05 / length(s1_rs_low_fr))
    fprintf(sprintf('S1 RS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('S1 RS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('S1 RS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
end
fprintf('S1 RS avg high minus low FR: %d\n', nanmean(s1_rs_high_fr-s1_rs_low_fr))
p = signrank(s1_fs_low_fr,s1_fs_high_fr);
if p < (0.05 / length(s1_fs_low_fr))
    fprintf(sprintf('S1 FS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('S1 FS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('S1 FS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
end
fprintf('S1 FS avg high minus low FR: %d\n', nanmean(s1_fs_high_fr-s1_fs_low_fr))
p = signrank(pfc_rs_low_fr,pfc_rs_high_fr);
if p < (0.05 / length(pfc_rs_low_fr))
    fprintf(sprintf('PFC RS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('PFC RS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('PFC RS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
end
fprintf('PFC RS avg high minus low FR: %d\n', nanmean(pfc_rs_high_fr-pfc_rs_low_fr))
p = signrank(pfc_fs_low_fr,pfc_fs_high_fr);
if p < (0.05 / length(pfc_fs_low_fr))
    fprintf(sprintf('PFC FS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('PFC FS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('PFC FS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
end
fprintf('PFC FS avg high minus low FR: %d\n', nanmean(pfc_fs_high_fr-pfc_fs_low_fr))

p = signrank(striatum_rs_low_fr,striatum_rs_high_fr);
if p < (0.05 / length(striatum_rs_low_fr))
    fprintf(sprintf('Striatum RS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Striatum RS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum RS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
end
fprintf('Striatum RS avg high minus low FR: %d\n', nanmean(striatum_rs_high_fr-striatum_rs_low_fr))
p = signrank(striatum_fs_low_fr,striatum_fs_high_fr);
if p < (0.05 / length(striatum_fs_low_fr))
    fprintf(sprintf('Striatum FS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Striatum FS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum FS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
end
fprintf('Striatum FS avg high minus low FR: %d\n', nanmean(striatum_fs_high_fr-striatum_fs_low_fr))
p = signrank(amygdala_rs_low_fr,amygdala_rs_high_fr);
if p < (0.05 / length(amygdala_rs_low_fr))
    fprintf(sprintf('Amygdala RS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Amygdala RS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala RS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
end
fprintf('Amygdala RS avg high minus low FR: %d\n', nanmean(amygdala_rs_high_fr-amygdala_rs_low_fr))
p = signrank(amygdala_fs_low_fr,amygdala_fs_high_fr);
if p < (0.05 / length(amygdala_fs_low_fr))
    fprintf(sprintf('Amygdala FS low alpha FR vs high alpha FR (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Amygdala FS low alpha FR vs high alpha FR (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala FS low alpha FR vs high alpha FR (signed-rank): p = %d\n', p))
end
fprintf('Amygdala FS avg high minus low FR: %d\n', nanmean(amygdala_fs_high_fr-amygdala_fs_low_fr))

p = signrank(striatum_rs_low_mse,striatum_rs_high_mse);
if p < (0.05 / length(striatum_rs_low_mse))
    fprintf(sprintf('Striatum RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Striatum RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): p = %d\n', p))
end
fprintf('Striatum RS avg high minus low MSE: %d\n', nanmean(striatum_rs_high_mse-striatum_rs_low_mse))
p = signrank(striatum_fs_low_mse,striatum_fs_high_mse);
if p < (0.05 / length(striatum_fs_low_mse))
    fprintf(sprintf('Striatum FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Striatum FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Striatum FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): p = %d\n', p))
end
fprintf('Striatum FS avg high minus low MSE: %d\n', nanmean(striatum_fs_high_mse-striatum_fs_low_mse))
p = signrank(amygdala_rs_low_mse,amygdala_rs_high_mse);
if p < (0.05 / length(amygdala_rs_low_mse))
    fprintf(sprintf('Amygdala RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Amygdala RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala RS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): p = %d\n', p))
end
fprintf('Amygdala RS avg high minus low MSE: %d\n', nanmean(amygdala_rs_high_mse-amygdala_rs_low_mse))
p = signrank(amygdala_fs_low_mse,amygdala_fs_high_mse);
if p < (0.05 / length(amygdala_fs_low_mse))
    fprintf(sprintf('Amygdala FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): **p = %d\n', p))
elseif p < 0.05 
    fprintf(sprintf('Amygdala FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): *p = %d\n', p))
else
    fprintf(sprintf('Amygdala FS low alpha von Mises MSE vs high alpha von Mises MSE (signed-rank): p = %d\n', p))
end
fprintf('Amygdala FS avg high minus low MSE: %d\n', nanmean(amygdala_fs_high_mse-amygdala_fs_low_mse))


% %% example figure
% load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/AP/date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat
% load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/LFP/date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat
% load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/SLRT/date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat

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
% plot(x,y, 'k', 'LineWidth', 2);
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
% plot(x,y, 'k', 'LineWidth', 2);
% xticks([-pi, 0, pi])
% xticklabels({'-\pi', '0', '\pi'})
% title('High Alpha Power')
% xlabel(tl, 'Alpha Phase (radians)', 'FontSize', 14)
% ylabel(tl, 'Spike PDF', 'FontSize', 14)
% ylim([0,0.35])
% yticks([0,0.35])
% yticklabels({})
% % saveas(example_fig, 'tmp/examp_high_low.png')
% saveas(example_fig, 'Figures/examp_high_low.svg')
% saveas(example_fig, 'Figures/examp_high_low.fig')

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
