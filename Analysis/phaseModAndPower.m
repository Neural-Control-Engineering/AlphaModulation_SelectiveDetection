addpath(genpath('./'))
addpath(genpath('~/circstat-matlab/'))
% init_paths;
% load(strcat(ftr_path, 'AP/FIG/S1_Expert_Combo_Adjusted/Cortex/Spontaneous_Alpha_Modulation/data.mat'))
% alpha_modulated = out.alpha_modulated;
% clear out

% low_mi = zeros(size(alpha_modulated,1),1);
% high_mi = zeros(size(alpha_modulated,1),1);
% low_p = zeros(size(alpha_modulated,1),1);
% high_p = zeros(size(alpha_modulated,1),1);
% low_firing_rates = zeros(size(alpha_modulated,1),1);
% high_firing_rates = zeros(size(alpha_modulated,1),1);
% n_low_events = zeros(size(alpha_modulated,1),1);
% n_high_events = zeros(size(alpha_modulated,1),1);
% low_mse = zeros(size(alpha_modulated,1),1);
% high_mse = zeros(size(alpha_modulated,1),1);
% theta_bar_low = zeros(size(alpha_modulated,1),1);
% theta_bar_high = zeros(size(alpha_modulated,1),1);
% high_outcomes = {};
% low_outcomes = {};
% event_inds_low = {};
% event_inds_high = {};

% for nrn = 1:size(alpha_modulated,1)
%     high_outcomes{nrn} = {};
%     low_outcomes{nrn} = {};
%     event_inds_low{nrn} = {};
%     event_inds_high{nrn} = {};

%     cid = alpha_modulated(nrn,:).cluster_id;
%     if nrn == 1
%         last_session_id = '';
%     else
%         last_session_id = session_id;
%     end
%     session_id = alpha_modulated(nrn,:).session_id{1};
%     if ~strcmp(session_id, last_session_id)
%         load(sprintf('%sAP/%s.mat', ext_path, session_id));
%         load(sprintf('%sLFP/%s.mat', ext_path, session_id));
%         load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
%     end
%     alpha_powers = [];
%     all_phases = [];
%     all_times = [];
%     for t = 1:size(slrt_data,1)
%         c = find(ap_data(t,:).spiking_data{1}.cluster_id == cid);
%         cluster_channel = ap_data(t,:).spiking_data{1}(c,:).channel{1};
%         lfp = lfp_data(t,:).lfp{1}(cluster_channel,:);
%         if strcmp(slrt_data(t,:).categorical_outcome{1}, 'Hit') || strcmp(slrt_data(t,:).categorical_outcome{1}, 'Miss')
%             lfp_times = lfp_data(t,:).left_trigger_aligned_lfp_time{1};
%             lfp_time = lfp_data(t,:).lfpTime{1};
%             spike_times = ap_data(t,:).spiking_data{1}(c,:).left_trigger_aligned_spike_times{1};
%         else
%             lfp_times = lfp_data(t,:).right_trigger_aligned_lfp_time{1};
%             lfp_time = lfp_data(t,:).lfpTime{1};
%             spike_times = ap_data(t,:).spiking_data{1}(c,:).right_trigger_aligned_spike_times{1};
%         end
%         alpha = bandpassFilter(lfp, 8, 12, 500);
%         phi = angle(hilbert(alpha));
%         ALPHA = abs(hilbert(alpha)).^2;
%         delta = bandpassFilter(lfp, 1, 4, 500);
%         DELTA = abs(hilbert(delta)).^2;
%         spike_phases = zeros(1,length(spike_times));
%         for i = 1:length(spike_times)
%             [~, tind] = min((lfp_times - spike_times(i)).^2);
%             spike_phases(i) = phi(tind);
%         end
%         spike_phases = spike_phases(spike_times > -3 & spike_times < 0);
%         alpha_powers = [alpha_powers, ALPHA(lfp_times > -3 & lfp_times < 0)];
%         all_times = [all_times, lfp_time(lfp_times > -3 & lfp_times < 0)];
%     end
    
%     high_phases = [];
%     low_phases = [];
%     high_frs = [];
%     low_frs = [];
%     for t = 1:size(slrt_data,1)
%         c = find(ap_data(t,:).spiking_data{1}.cluster_id == cid);
%         cluster_channel = ap_data(t,:).spiking_data{1}(c,:).channel{1};
%         lfp = lfp_data(t,:).lfp{1}(cluster_channel,:);
%         if strcmp(slrt_data(t,:).categorical_outcome{1}, 'Hit') || strcmp(slrt_data(t,:).categorical_outcome{1}, 'Miss')
%             lfp_times = lfp_data(t,:).left_trigger_aligned_lfp_time{1};
%             spike_times = ap_data(t,:).spiking_data{1}(c,:).left_trigger_aligned_spike_times{1};
%         else
%             lfp_times = lfp_data(t,:).right_trigger_aligned_lfp_time{1};
%             spike_times = ap_data(t,:).spiking_data{1}(c,:).right_trigger_aligned_spike_times{1};
%         end
%         alpha = bandpassFilter(lfp, 8, 12, 500);
%         phi = angle(hilbert(alpha));
%         ALPHA = abs(hilbert(alpha)).^2;
%         delta = bandpassFilter(lfp, 1, 4, 500);
%         DELTA = abs(hilbert(delta)).^2;
%         spike_phases = zeros(1,length(spike_times));
%         for i = 1:length(spike_times)
%             [~, tind] = min((lfp_times - spike_times(i)).^2);
%             spike_phases(i) = phi(tind);
%         end
%         spike_phases = spike_phases(spike_times > -3 & spike_times < 0);
%         spike_times = spike_times(spike_times > -3 & spike_times < 0);
%         ALPHA = ALPHA(lfp_times > -3 & lfp_times < 0);
%         lfp_times = lfp_times(lfp_times > -3 & lfp_times < 0);
%         high_inds = findEvents(ALPHA, lfp_times, prctile(alpha_powers, 75), 0.33, 0.2, 'above');
%         if size(high_inds,1)
%             for n = 1:size(high_inds,1)
%                 begin = lfp_times(high_inds(n,1));
%                 fin = lfp_times(high_inds(n,2));
%                 high_phases = [high_phases, spike_phases(spike_times > begin & spike_times < fin)];
%                 high_frs = [high_frs, length(spike_phases(spike_times > begin & spike_times < fin)) / (fin-begin)];
%                 high_outcomes{nrn} = horzcat(high_outcomes{nrn}, slrt_data(t,:).categorical_outcome{1});
%                 event_inds_high{nrn} = horzcat(event_inds_high{nrn}, {high_inds(n,:)});
%             end
%         end
%         low_inds = findEvents(ALPHA, lfp_times, prctile(alpha_powers, 50), 0.33, 0.2, 'below');
%         if size(low_inds,1)
%             for n = 1:size(low_inds,1)
%                 begin = lfp_times(low_inds(n,1));
%                 fin = lfp_times(low_inds(n,2));
%                 low_phases = [low_phases, spike_phases(spike_times >= begin & spike_times <= fin)];
%                 low_frs = [low_frs, length(spike_phases(spike_times > begin & spike_times < fin)) / (fin-begin)];
%                 low_outcomes{nrn} = horzcat(low_outcomes{nrn}, slrt_data(t,:).categorical_outcome{1});
%                 event_inds_low{nrn} = horzcat(event_inds_low{nrn}, {low_inds(n,:)});
%             end
%         end
%     end
%     [Nlow, ~] = histcounts(low_phases, 20);
%     [Nhigh, ~] = histcounts(high_phases,20);
%     low_mi(nrn) = compute_modulation_index(Nlow);
%     high_mi(nrn) = compute_modulation_index(Nhigh);
    
%     [Nlow, edges] = histcounts(low_phases, 20, 'Normalization', 'pdf');
%     centers = zeros(length(edges)-1,1);
%     for e = 1:(length(edges)-1)
%         centers(e) = mean(edges(e:(e+1)));
%     end
%     [x,y, theta_bar_low(nrn), ~, ~] = vonMises(low_phases);
%     y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
%     low_mse(nrn) = mean((Nlow(2:end-1) - y_interpolated').^2);
    
%     [Nhigh, edges] = histcounts(high_phases, 20, 'Normalization', 'pdf');
%     centers = zeros(length(edges)-1,1);
%     for e = 1:(length(edges)-1)
%         centers(e) = mean(edges(e:(e+1)));
%     end
%     [x,y, theta_bar_high(nrn) ~, ~] = vonMises(high_phases);
%     y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
%     high_mse(nrn) = mean((Nhigh(2:end-1) - y_interpolated').^2);

%     low_p(nrn) = circ_rtest(low_phases);
%     high_p(nrn) = circ_rtest(high_phases);
%     low_firing_rates(nrn) = mean(low_frs);
%     high_firing_rates(nrn) = mean(high_frs);
%     n_low_events(nrn) = length(low_frs);
%     n_high_events(nrn) = length(high_frs);
% end

% out_file = strcat(ftr_path, 'AP/FIG/S1_Expert_Combo_Adjusted/Cortex/Spontaneous_Alpha_Modulation/high_v_low_alpha.mat');

% out = struct();
% out.low_mi = low_mi;
% out.high_mi = high_mi;
% out.low_p = low_p;
% out.high_p = high_p;
% out.low_firing_rates = low_firing_rates;
% out.high_firing_rates = high_firing_rates;
% out.n_low_events = n_low_events;
% out.n_high_events = n_high_events;
% out.low_mse = low_mse;
% out.high_mse = high_mse;
% out.theta_bar_low = theta_bar_low;
% out.theta_bar_high = theta_bar_high;
% out.low_outcomes = low_outcomes;
% out.event_inds_low = event_inds_low;
% out.high_outcomes = high_outcomes;
% out.event_inds_high = event_inds_high;
% save(out_file, 'out', '-v7.3');

% clear 
% init_paths;
% load(strcat(ftr_path, 'AP/FIG/PFC_Expert_Combo_Adjusted/PFC/Spontaneous_Alpha_Modulation/data.mat'))
% alpha_modulated = out.alpha_modulated;
% clear out

% low_mi = zeros(size(alpha_modulated,1),1);
% high_mi = zeros(size(alpha_modulated,1),1);
% low_p = zeros(size(alpha_modulated,1),1);
% high_p = zeros(size(alpha_modulated,1),1);
% low_firing_rates = zeros(size(alpha_modulated,1),1);
% high_firing_rates = zeros(size(alpha_modulated,1),1);
% n_low_events = zeros(size(alpha_modulated,1),1);
% n_high_events = zeros(size(alpha_modulated,1),1);
% low_mse = zeros(size(alpha_modulated,1),1);
% high_mse = zeros(size(alpha_modulated,1),1);
% theta_bar_low = zeros(size(alpha_modulated,1),1);
% theta_bar_high = zeros(size(alpha_modulated,1),1);
% high_outcomes = {};
% low_outcomes = {};
% event_inds_low = {};
% event_inds_high = {};

% for nrn = 1:size(alpha_modulated,1)
%     high_outcomes{nrn} = {};
%     low_outcomes{nrn} = {};
%     event_inds_low{nrn} = {};
%     event_inds_high{nrn} = {};

%     cid = alpha_modulated(nrn,:).cluster_id;
%     if nrn == 1
%         last_session_id = '';
%     else
%         last_session_id = session_id;
%     end
%     session_id = alpha_modulated(nrn,:).session_id{1};
%     if ~strcmp(session_id, last_session_id)
%         load(sprintf('%sAP/%s.mat', ext_path, session_id));
%         load(sprintf('%sLFP/%s.mat', ext_path, session_id));
%         load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
%     end
%     alpha_powers = [];
%     all_phases = [];
%     all_times = [];
%     for t = 1:size(slrt_data,1)
%         c = find(ap_data(t,:).spiking_data{1}.cluster_id == cid);
%         cluster_channel = ap_data(t,:).spiking_data{1}(c,:).channel{1};
%         lfp = lfp_data(t,:).lfp{1}(cluster_channel,:);
%         if strcmp(slrt_data(t,:).categorical_outcome{1}, 'Hit') || strcmp(slrt_data(t,:).categorical_outcome{1}, 'Miss')
%             lfp_times = lfp_data(t,:).left_trigger_aligned_lfp_time{1};
%             lfp_time = lfp_data(t,:).lfpTime{1};
%             spike_times = ap_data(t,:).spiking_data{1}(c,:).left_trigger_aligned_spike_times{1};
%         else
%             lfp_times = lfp_data(t,:).right_trigger_aligned_lfp_time{1};
%             lfp_time = lfp_data(t,:).lfpTime{1};
%             spike_times = ap_data(t,:).spiking_data{1}(c,:).right_trigger_aligned_spike_times{1};
%         end
%         alpha = bandpassFilter(lfp, 8, 12, 500);
%         phi = angle(hilbert(alpha));
%         ALPHA = abs(hilbert(alpha)).^2;
%         delta = bandpassFilter(lfp, 1, 4, 500);
%         DELTA = abs(hilbert(delta)).^2;
%         spike_phases = zeros(1,length(spike_times));
%         for i = 1:length(spike_times)
%             [~, tind] = min((lfp_times - spike_times(i)).^2);
%             spike_phases(i) = phi(tind);
%         end
%         spike_phases = spike_phases(spike_times > -3 & spike_times < 0);
%         alpha_powers = [alpha_powers, ALPHA(lfp_times > -3 & lfp_times < 0)];
%         all_times = [all_times, lfp_time(lfp_times > -3 & lfp_times < 0)];
%     end
    
%     high_phases = [];
%     low_phases = [];
%     high_frs = [];
%     low_frs = [];
%     for t = 1:size(slrt_data,1)
%         c = find(ap_data(t,:).spiking_data{1}.cluster_id == cid);
%         cluster_channel = ap_data(t,:).spiking_data{1}(c,:).channel{1};
%         lfp = lfp_data(t,:).lfp{1}(cluster_channel,:);
%         if strcmp(slrt_data(t,:).categorical_outcome{1}, 'Hit') || strcmp(slrt_data(t,:).categorical_outcome{1}, 'Miss')
%             lfp_times = lfp_data(t,:).left_trigger_aligned_lfp_time{1};
%             spike_times = ap_data(t,:).spiking_data{1}(c,:).left_trigger_aligned_spike_times{1};
%         else
%             lfp_times = lfp_data(t,:).right_trigger_aligned_lfp_time{1};
%             spike_times = ap_data(t,:).spiking_data{1}(c,:).right_trigger_aligned_spike_times{1};
%         end
%         alpha = bandpassFilter(lfp, 8, 12, 500);
%         phi = angle(hilbert(alpha));
%         ALPHA = abs(hilbert(alpha)).^2;
%         delta = bandpassFilter(lfp, 1, 4, 500);
%         DELTA = abs(hilbert(delta)).^2;
%         spike_phases = zeros(1,length(spike_times));
%         for i = 1:length(spike_times)
%             [~, tind] = min((lfp_times - spike_times(i)).^2);
%             spike_phases(i) = phi(tind);
%         end
%         spike_phases = spike_phases(spike_times > -3 & spike_times < 0);
%         spike_times = spike_times(spike_times > -3 & spike_times < 0);
%         ALPHA = ALPHA(lfp_times > -3 & lfp_times < 0);
%         lfp_times = lfp_times(lfp_times > -3 & lfp_times < 0);
%         high_inds = findEvents(ALPHA, lfp_times, prctile(alpha_powers, 75), 0.33, 0.2, 'above');
%         if size(high_inds,1)
%             for n = 1:size(high_inds,1)
%                 begin = lfp_times(high_inds(n,1));
%                 fin = lfp_times(high_inds(n,2));
%                 high_phases = [high_phases, spike_phases(spike_times > begin & spike_times < fin)];
%                 high_frs = [high_frs, length(spike_phases(spike_times > begin & spike_times < fin)) / (fin-begin)];
%                 high_outcomes{nrn} = horzcat(high_outcomes{nrn}, slrt_data(t,:).categorical_outcome{1});
%                 event_inds_high{nrn} = horzcat(event_inds_high{nrn}, {high_inds(n,:)});
%             end
%         end
%         low_inds = findEvents(ALPHA, lfp_times, prctile(alpha_powers, 50), 0.33, 0.2, 'below');
%         if size(low_inds,1)
%             for n = 1:size(low_inds,1)
%                 begin = lfp_times(low_inds(n,1));
%                 fin = lfp_times(low_inds(n,2));
%                 low_phases = [low_phases, spike_phases(spike_times >= begin & spike_times <= fin)];
%                 low_frs = [low_frs, length(spike_phases(spike_times > begin & spike_times < fin)) / (fin-begin)];
%                 low_outcomes{nrn} = horzcat(low_outcomes{nrn}, slrt_data(t,:).categorical_outcome{1});
%                 event_inds_low{nrn} = horzcat(event_inds_low{nrn}, {low_inds(n,:)});
%             end
%         end
%     end
%     [Nlow, ~] = histcounts(low_phases, 20);
%     [Nhigh, ~] = histcounts(high_phases,20);
%     low_mi(nrn) = compute_modulation_index(Nlow);
%     high_mi(nrn) = compute_modulation_index(Nhigh);

%     [Nlow, edges] = histcounts(low_phases, 20, 'Normalization', 'pdf');
%     centers = zeros(length(edges)-1,1);
%     for e = 1:(length(edges)-1)
%         centers(e) = mean(edges(e:(e+1)));
%     end
%     [x,y, theta_bar_low(nrn), ~, ~] = vonMises(low_phases);
%     y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
%     low_mse(nrn) = mean((Nlow(2:end-1) - y_interpolated').^2);
    
%     [Nhigh, edges] = histcounts(high_phases, 20, 'Normalization', 'pdf');
%     centers = zeros(length(edges)-1,1);
%     for e = 1:(length(edges)-1)
%         centers(e) = mean(edges(e:(e+1)));
%     end
%     [x,y, theta_bar_high(nrn), ~, ~] = vonMises(high_phases);
%     y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
%     high_mse(nrn) = mean((Nhigh(2:end-1) - y_interpolated').^2);

%     low_p(nrn) = circ_rtest(low_phases);
%     high_p(nrn) = circ_rtest(high_phases);
%     low_firing_rates(nrn) = mean(low_frs);
%     high_firing_rates(nrn) = mean(high_frs);
%     n_low_events(nrn) = length(low_frs);
%     n_high_events(nrn) = length(high_frs);
% end

% out_file = strcat(ftr_path, 'AP/FIG/PFC_Expert_Combo_Adjusted/PFC/Spontaneous_Alpha_Modulation/high_v_low_alpha.mat');

% out = struct();
% out.low_mi = low_mi;
% out.high_mi = high_mi;
% out.low_p = low_p;
% out.high_p = high_p;
% out.low_firing_rates = low_firing_rates;
% out.high_firing_rates = high_firing_rates;
% out.n_low_events = n_low_events;
% out.n_high_events = n_high_events;
% out.low_mse = low_mse;
% out.high_mse = high_mse;
% out.theta_bar_low = theta_bar_low;
% out.theta_bar_high = theta_bar_high;
% out.low_outcomes = low_outcomes;
% out.event_inds_low = event_inds_low;
% out.high_outcomes = high_outcomes;
% out.event_inds_high = event_inds_high;
% save(out_file, 'out', '-v7.3');

% clear
% init_paths; 
% load(strcat(ftr_path, 'AP/FIG/S1_Expert_Combo_Adjusted/Basal_Ganglia/Spontaneous_Alpha_Modulation/data.mat'))
% alpha_modulated = out.alpha_modulated;
% clear out

% low_mi = zeros(size(alpha_modulated,1),1);
% high_mi = zeros(size(alpha_modulated,1),1);
% low_p = zeros(size(alpha_modulated,1),1);
% high_p = zeros(size(alpha_modulated,1),1);
% low_firing_rates = zeros(size(alpha_modulated,1),1);
% high_firing_rates = zeros(size(alpha_modulated,1),1);
% n_low_events = zeros(size(alpha_modulated,1),1);
% n_high_events = zeros(size(alpha_modulated,1),1);
% low_mse = zeros(size(alpha_modulated,1),1);
% high_mse = zeros(size(alpha_modulated,1),1);
% theta_bar_low = zeros(size(alpha_modulated,1),1);
% theta_bar_high = zeros(size(alpha_modulated,1),1);
% high_outcomes = {};
% low_outcomes = {};
% event_inds_low = {};
% event_inds_high = {};

% for nrn = 1:size(alpha_modulated,1)
%     high_outcomes{nrn} = {};
%     low_outcomes{nrn} = {};
%     event_inds_low{nrn} = {};
%     event_inds_high{nrn} = {};
%     cid = alpha_modulated(nrn,:).cluster_id;
%     if nrn == 1
%         last_session_id = '';
%     else
%         last_session_id = session_id;
%     end
%     session_id = alpha_modulated(nrn,:).session_id{1};
%     if ~strcmp(session_id, last_session_id)
%         load(sprintf('%sAP/%s.mat', ext_path, session_id));
%         load(sprintf('%sLFP/%s.mat', ext_path, session_id));
%         load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
%     end
%     alpha_powers = [];
%     all_phases = [];
%     all_times = [];
%     for t = 1:size(slrt_data,1)
%         c = find(ap_data(t,:).spiking_data{1}.cluster_id == cid);
%         cluster_channel = ap_data(t,:).spiking_data{1}(c,:).channel{1};
%         lfp = lfp_data(t,:).lfp{1}(cluster_channel,:);
%         if strcmp(slrt_data(t,:).categorical_outcome{1}, 'Hit') || strcmp(slrt_data(t,:).categorical_outcome{1}, 'Miss')
%             lfp_times = lfp_data(t,:).left_trigger_aligned_lfp_time{1};
%             lfp_time = lfp_data(t,:).lfpTime{1};
%             spike_times = ap_data(t,:).spiking_data{1}(c,:).left_trigger_aligned_spike_times{1};
%         else
%             lfp_times = lfp_data(t,:).right_trigger_aligned_lfp_time{1};
%             lfp_time = lfp_data(t,:).lfpTime{1};
%             spike_times = ap_data(t,:).spiking_data{1}(c,:).right_trigger_aligned_spike_times{1};
%         end
%         alpha = bandpassFilter(lfp, 8, 12, 500);
%         phi = angle(hilbert(alpha));
%         ALPHA = abs(hilbert(alpha)).^2;
%         delta = bandpassFilter(lfp, 1, 4, 500);
%         DELTA = abs(hilbert(delta)).^2;
%         spike_phases = zeros(1,length(spike_times));
%         for i = 1:length(spike_times)
%             [~, tind] = min((lfp_times - spike_times(i)).^2);
%             spike_phases(i) = phi(tind);
%         end
%         spike_phases = spike_phases(spike_times > -3 & spike_times < 0);
%         alpha_powers = [alpha_powers, ALPHA(lfp_times > -3 & lfp_times < 0)];
%         all_times = [all_times, lfp_time(lfp_times > -3 & lfp_times < 0)];
%     end
    
%     high_phases = [];
%     low_phases = [];
%     high_frs = [];
%     low_frs = [];
%     for t = 1:size(slrt_data,1)
%         c = find(ap_data(t,:).spiking_data{1}.cluster_id == cid);
%         cluster_channel = ap_data(t,:).spiking_data{1}(c,:).channel{1};
%         lfp = lfp_data(t,:).lfp{1}(cluster_channel,:);
%         if strcmp(slrt_data(t,:).categorical_outcome{1}, 'Hit') || strcmp(slrt_data(t,:).categorical_outcome{1}, 'Miss')
%             lfp_times = lfp_data(t,:).left_trigger_aligned_lfp_time{1};
%             spike_times = ap_data(t,:).spiking_data{1}(c,:).left_trigger_aligned_spike_times{1};
%         else
%             lfp_times = lfp_data(t,:).right_trigger_aligned_lfp_time{1};
%             spike_times = ap_data(t,:).spiking_data{1}(c,:).right_trigger_aligned_spike_times{1};
%         end
%         alpha = bandpassFilter(lfp, 8, 12, 500);
%         phi = angle(hilbert(alpha));
%         ALPHA = abs(hilbert(alpha)).^2;
%         delta = bandpassFilter(lfp, 1, 4, 500);
%         DELTA = abs(hilbert(delta)).^2;
%         spike_phases = zeros(1,length(spike_times));
%         for i = 1:length(spike_times)
%             [~, tind] = min((lfp_times - spike_times(i)).^2);
%             spike_phases(i) = phi(tind);
%         end
%         spike_phases = spike_phases(spike_times > -3 & spike_times < 0);
%         spike_times = spike_times(spike_times > -3 & spike_times < 0);
%         ALPHA = ALPHA(lfp_times > -3 & lfp_times < 0);
%         lfp_times = lfp_times(lfp_times > -3 & lfp_times < 0);
%         high_inds = findEvents(ALPHA, lfp_times, prctile(alpha_powers, 75), 0.33, 0.2, 'above');
%         if size(high_inds,1)
%             for n = 1:size(high_inds,1)
%                 begin = lfp_times(high_inds(n,1));
%                 fin = lfp_times(high_inds(n,2));
%                 high_phases = [high_phases, spike_phases(spike_times > begin & spike_times < fin)];
%                 high_frs = [high_frs, length(spike_phases(spike_times > begin & spike_times < fin)) / (fin-begin)];
%                 high_outcomes{nrn} = horzcat(high_outcomes{nrn}, slrt_data(t,:).categorical_outcome{1});
%                 event_inds_high{nrn} = horzcat(event_inds_high{nrn}, {high_inds(n,:)});
%             end
%         end
%         low_inds = findEvents(ALPHA, lfp_times, prctile(alpha_powers, 50), 0.33, 0.2, 'below');
%         if size(low_inds,1)
%             for n = 1:size(low_inds,1)
%                 begin = lfp_times(low_inds(n,1));
%                 fin = lfp_times(low_inds(n,2));
%                 low_phases = [low_phases, spike_phases(spike_times >= begin & spike_times <= fin)];
%                 low_frs = [low_frs, length(spike_phases(spike_times > begin & spike_times < fin)) / (fin-begin)];
%                 low_outcomes{nrn} = horzcat(low_outcomes{nrn}, slrt_data(t,:).categorical_outcome{1});
%                 event_inds_low{nrn} = horzcat(event_inds_low{nrn}, {low_inds(n,:)});
%             end
%         end
%     end
%     [Nlow, ~] = histcounts(low_phases, 20);
%     [Nhigh, ~] = histcounts(high_phases,20);
%     low_mi(nrn) = compute_modulation_index(Nlow);
%     high_mi(nrn) = compute_modulation_index(Nhigh);

%     [Nlow, edges] = histcounts(low_phases, 20, 'Normalization', 'pdf');
%     centers = zeros(length(edges)-1,1);
%     for e = 1:(length(edges)-1)
%         centers(e) = mean(edges(e:(e+1)));
%     end
%     [x,y, theta_bar_low(nrn), ~, ~] = vonMises(low_phases);
%     y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
%     low_mse(nrn) = mean((Nlow(2:end-1) - y_interpolated').^2);
    
%     [Nhigh, edges] = histcounts(high_phases, 20, 'Normalization', 'pdf');
%     centers = zeros(length(edges)-1,1);
%     for e = 1:(length(edges)-1)
%         centers(e) = mean(edges(e:(e+1)));
%     end
%     [x,y, theta_bar_high(nrn), ~, ~] = vonMises(high_phases);
%     y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
%     high_mse(nrn) = mean((Nhigh(2:end-1) - y_interpolated').^2);

%     low_p(nrn) = circ_rtest(low_phases);
%     high_p(nrn) = circ_rtest(high_phases);
%     low_firing_rates(nrn) = mean(low_frs);
%     high_firing_rates(nrn) = mean(high_frs);
%     n_low_events(nrn) = length(low_frs);
%     n_high_events(nrn) = length(high_frs);
% end

% out_file = strcat(ftr_path, 'AP/FIG/S1_Expert_Combo_Adjusted/Basal_Ganglia/Spontaneous_Alpha_Modulation/high_v_low_alpha.mat');

% out = struct();
% out.low_mi = low_mi;
% out.high_mi = high_mi;
% out.low_p = low_p;
% out.high_p = high_p;
% out.low_firing_rates = low_firing_rates;
% out.high_firing_rates = high_firing_rates;
% out.n_low_events = n_low_events;
% out.n_high_events = n_high_events;
% out.low_mse = low_mse;
% out.high_mse = high_mse;
% out.theta_bar_low = theta_bar_low;
% out.theta_bar_high = theta_bar_high;
% out.low_outcomes = low_outcomes;
% out.event_inds_low = event_inds_low;
% out.high_outcomes = high_outcomes;
% out.event_inds_high = event_inds_high;
% save(out_file, 'out', '-v7.3');

clear
init_paths; 
load(strcat(ftr_path, 'AP/FIG/S1_Expert_Combo_Adjusted/Amygdala/Spontaneous_Alpha_Modulation/data.mat'))
alpha_modulated = out.alpha_modulated;
clear out

low_mi = zeros(size(alpha_modulated,1),1);
high_mi = zeros(size(alpha_modulated,1),1);
low_p = zeros(size(alpha_modulated,1),1);
high_p = zeros(size(alpha_modulated,1),1);
low_firing_rates = zeros(size(alpha_modulated,1),1);
high_firing_rates = zeros(size(alpha_modulated,1),1);
n_low_events = zeros(size(alpha_modulated,1),1);
n_high_events = zeros(size(alpha_modulated,1),1);
low_mse = zeros(size(alpha_modulated,1),1);
high_mse = zeros(size(alpha_modulated,1),1);
theta_bar_low = zeros(size(alpha_modulated,1),1);
theta_bar_high = zeros(size(alpha_modulated,1),1);
high_outcomes = {};
low_outcomes = {};
event_inds_high = {};
event_inds_low = {};

for nrn = 1:size(alpha_modulated,1)
    high_outcomes{nrn} = {};
    low_outcomes{nrn} = {};
    event_inds_low{nrn} = {};
    event_inds_high{nrn} = {};
    cid = alpha_modulated(nrn,:).cluster_id;
    if nrn == 1
        last_session_id = '';
    else
        last_session_id = session_id;
    end
    session_id = alpha_modulated(nrn,:).session_id{1};
    if ~strcmp(session_id, last_session_id)
        load(sprintf('%sAP/%s.mat', ext_path, session_id));
        load(sprintf('%sLFP/%s.mat', ext_path, session_id));
        load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
    end
    alpha_powers = [];
    all_phases = [];
    all_times = [];
    for t = 1:size(slrt_data,1)
        c = find(ap_data(t,:).spiking_data{1}.cluster_id == cid);
        cluster_channel = ap_data(t,:).spiking_data{1}(c,:).channel{1};
        lfp = lfp_data(t,:).lfp{1}(cluster_channel,:);
        if strcmp(slrt_data(t,:).categorical_outcome{1}, 'Hit') || strcmp(slrt_data(t,:).categorical_outcome{1}, 'Miss')
            lfp_times = lfp_data(t,:).left_trigger_aligned_lfp_time{1};
            lfp_time = lfp_data(t,:).lfpTime{1};
            spike_times = ap_data(t,:).spiking_data{1}(c,:).left_trigger_aligned_spike_times{1};
        else
            lfp_times = lfp_data(t,:).right_trigger_aligned_lfp_time{1};
            lfp_time = lfp_data(t,:).lfpTime{1};
            spike_times = ap_data(t,:).spiking_data{1}(c,:).right_trigger_aligned_spike_times{1};
        end
        alpha = bandpassFilter(lfp, 8, 12, 500);
        phi = angle(hilbert(alpha));
        ALPHA = abs(hilbert(alpha)).^2;
        delta = bandpassFilter(lfp, 1, 4, 500);
        DELTA = abs(hilbert(delta)).^2;
        spike_phases = zeros(1,length(spike_times));
        for i = 1:length(spike_times)
            [~, tind] = min((lfp_times - spike_times(i)).^2);
            spike_phases(i) = phi(tind);
        end
        spike_phases = spike_phases(spike_times > -3 & spike_times < 0);
        alpha_powers = [alpha_powers, ALPHA(lfp_times > -3 & lfp_times < 0)];
        all_times = [all_times, lfp_time(lfp_times > -3 & lfp_times < 0)];
    end
    
    high_phases = [];
    low_phases = [];
    high_frs = [];
    low_frs = [];
    for t = 1:size(slrt_data,1)
        c = find(ap_data(t,:).spiking_data{1}.cluster_id == cid);
        cluster_channel = ap_data(t,:).spiking_data{1}(c,:).channel{1};
        lfp = lfp_data(t,:).lfp{1}(cluster_channel,:);
        if strcmp(slrt_data(t,:).categorical_outcome{1}, 'Hit') || strcmp(slrt_data(t,:).categorical_outcome{1}, 'Miss')
            lfp_times = lfp_data(t,:).left_trigger_aligned_lfp_time{1};
            spike_times = ap_data(t,:).spiking_data{1}(c,:).left_trigger_aligned_spike_times{1};
        else
            lfp_times = lfp_data(t,:).right_trigger_aligned_lfp_time{1};
            spike_times = ap_data(t,:).spiking_data{1}(c,:).right_trigger_aligned_spike_times{1};
        end
        alpha = bandpassFilter(lfp, 8, 12, 500);
        phi = angle(hilbert(alpha));
        ALPHA = abs(hilbert(alpha)).^2;
        delta = bandpassFilter(lfp, 1, 4, 500);
        DELTA = abs(hilbert(delta)).^2;
        spike_phases = zeros(1,length(spike_times));
        for i = 1:length(spike_times)
            [~, tind] = min((lfp_times - spike_times(i)).^2);
            spike_phases(i) = phi(tind);
        end
        spike_phases = spike_phases(spike_times > -3 & spike_times < 0);
        spike_times = spike_times(spike_times > -3 & spike_times < 0);
        ALPHA = ALPHA(lfp_times > -3 & lfp_times < 0);
        lfp_times = lfp_times(lfp_times > -3 & lfp_times < 0);
        high_inds = findEvents(ALPHA, lfp_times, prctile(alpha_powers, 75), 0.33, 0.2, 'above');
        if size(high_inds,1)
            for n = 1:size(high_inds,1)
                begin = lfp_times(high_inds(n,1));
                fin = lfp_times(high_inds(n,2));
                high_phases = [high_phases, spike_phases(spike_times > begin & spike_times < fin)];
                high_frs = [high_frs, length(spike_phases(spike_times > begin & spike_times < fin)) / (fin-begin)];
                high_outcomes{nrn} = horzcat(high_outcomes{nrn}, slrt_data(t,:).categorical_outcome{1});
                event_inds_high{nrn} = horzcat(event_inds_high{nrn}, {high_inds(n,:)});
            end
        end
        low_inds = findEvents(ALPHA, lfp_times, prctile(alpha_powers, 50), 0.33, 0.2, 'below');
        if size(low_inds,1)
            for n = 1:size(low_inds,1)
                begin = lfp_times(low_inds(n,1));
                fin = lfp_times(low_inds(n,2));
                low_phases = [low_phases, spike_phases(spike_times >= begin & spike_times <= fin)];
                low_frs = [low_frs, length(spike_phases(spike_times > begin & spike_times < fin)) / (fin-begin)];
                low_outcomes{nrn} = horzcat(low_outcomes{nrn}, slrt_data(t,:).categorical_outcome{1});
                event_inds_low{nrn} = horzcat(event_inds_low{nrn}, {low_inds(n,:)});
            end
        end
    end
    [Nlow, ~] = histcounts(low_phases, 20);
    [Nhigh, ~] = histcounts(high_phases,20);
    low_mi(nrn) = compute_modulation_index(Nlow);
    high_mi(nrn) = compute_modulation_index(Nhigh);

    [Nlow, edges] = histcounts(low_phases, 20, 'Normalization', 'pdf');
    centers = zeros(length(edges)-1,1);
    for e = 1:(length(edges)-1)
        centers(e) = mean(edges(e:(e+1)));
    end
    [x,y, theta_bar_low(nrn), ~, ~] = vonMises(low_phases);
    y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
    low_mse(nrn) = mean((Nlow(2:end-1) - y_interpolated').^2);
    
    [Nhigh, edges] = histcounts(high_phases, 20, 'Normalization', 'pdf');
    centers = zeros(length(edges)-1,1);
    for e = 1:(length(edges)-1)
        centers(e) = mean(edges(e:(e+1)));
    end
    [x,y, theta_bar_high(nrn), ~, ~] = vonMises(high_phases);
    y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
    high_mse(nrn) = mean((Nhigh(2:end-1) - y_interpolated').^2);

    low_p(nrn) = circ_rtest(low_phases);
    high_p(nrn) = circ_rtest(high_phases);
    low_firing_rates(nrn) = mean(low_frs);
    high_firing_rates(nrn) = mean(high_frs);
    n_low_events(nrn) = length(low_frs);
    n_high_events(nrn) = length(high_frs);
end

out_file = strcat(ftr_path, 'AP/FIG/S1_Expert_Combo_Adjusted/Amygdala/Spontaneous_Alpha_Modulation/high_v_low_alpha.mat');

out = struct();
out.low_mi = low_mi;
out.high_mi = high_mi;
out.low_p = low_p;
out.high_p = high_p;
out.low_firing_rates = low_firing_rates;
out.high_firing_rates = high_firing_rates;
out.n_low_events = n_low_events;
out.n_high_events = n_high_events;
out.low_mse = low_mse;
out.high_mse = high_mse;
out.theta_bar_low = theta_bar_low;
out.theta_bar_high = theta_bar_high;
out.low_outcomes = low_outcomes;
out.event_inds_low = event_inds_low;
out.high_outcomes = high_outcomes;
out.event_inds_high = event_inds_high;
save(out_file, 'out', '-v7.3');