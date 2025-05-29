load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/AP/date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat
load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/LFP/date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat
load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/SLRT/date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat
addpath(genpath('./'))
addpath(genpath('~/circstat-matlab'))
delete Stats/example_phase_mod.txt
diary Stats/example_phase_mod.txt
trials = find(strcmp(slrt_data.categorical_outcome,'Hit'));
% for trial = 1:length(trials)

trial_inds = 24:27;
count = 1;
for t = 107:109
    % t = 24;
    c = find(ap_data(t,:).spiking_data{1}.cluster_id == 218);
    cluster_channel = ap_data(t,:).spiking_data{1}(c,:).channel{1};
    lfp = lfp_data(t,:).lfp{1}(cluster_channel,:);
    lfp_times = lfp_data(t,:).left_trigger_aligned_lfp_time{1};
    spike_times = ap_data(t,:).spiking_data{1}(c,:).left_trigger_aligned_spike_times{1};
    if isempty(lfp_times)
        lfp_times = lfp_data(t,:).right_trigger_aligned_lfp_time{1};
        spike_times = ap_data(t,:).spiking_data{1}(c,:).right_trigger_aligned_spike_times{1};
    end
    y = bandpassFilter(lfp, 8, 12, 500);
    phi = angle(hilbert(y));
    Y = abs(hilbert(y)).^2;
    spike_phases = zeros(1,length(spike_times));
    for i = 1:length(spike_times)
        [~, tind] = min((lfp_times - spike_times(i)).^2);
        spike_phases(i) = phi(tind);
    end
    figs(count) = figure('Position', [1220 1074 567 728]);
    tl = tiledlayout(2,1);
    axs(1) = nexttile;
    plot(lfp_times, y, 'k-'); xlim([-3,0]);
    ylabel('Filtered LFP', 'FontSize', 16)
    xlabel('Time (s)', 'FontSize', 16)
    % yticks([-1e-4, 1e-4])
    xticks([-3,-1.5,0])
    ylim([-6.5e-5, 6.5e-5])
    ax = gca;    
    ax.XAxis.FontSize = 14;
    ax = gca;    
    ax.YAxis.FontSize = 14;
    axs(2) = nexttile;
    plot(lfp_times, phi, 'k-')
    hold on 
    plot(spike_times, spike_phases, 'r*')
    xlabel('Time (s)', 'FontSize', 16)
    ylabel('Alpha Phase (radians)', 'FontSize', 16)
    yticks([-pi, 0, pi])
    yticklabels({'-\pi', '0', '\pi'})
    xlim([-3,0]);
    xticks([-3,-1.5,0])
    ax = gca;    
    ax.XAxis.FontSize = 14;
    ax = gca;    
    ax.YAxis.FontSize = 14;
    saveas(figs(count), sprintf('../Figures/example_trial_%i.fig', count))
    saveas(figs(count), sprintf('../Figures/example_trial_%i.svg', count))
    count = count + 1;
end

% axs(3) = nexttile;
load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/FTR/AP/FIG/S1_Expert_Combo_Adjusted/Cortex/Spontaneous_Alpha_Modulation/data.mat
session_id = 'date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0';
ind = find(out.alpha_modulated.cluster_id == 218 & strcmp(out.alpha_modulated.session_id, session_id));

example_fig = figure();
[N, edges] = histcounts(out.alpha_modulated(ind,:).spon_alpha_spike_phases{1}, 20, 'Normalization', 'pdf');
centers = zeros(length(edges)-1,1);
for e = 1:(length(edges)-1)
    centers(e) = mean(edges(e:(e+1)));
end
[x,y, theta_bars(i), Rs(i), kappas(i)] = vonMises(out.alpha_modulated(ind,:).spon_alpha_spike_phases{1});
bar(centers, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
hold on
plot(x,y, 'k', 'LineWidth', 2);
xticks([-pi, 0, pi])
xticklabels({'-\pi', '0', '\pi'})
ax = gca;    
ax.XAxis.FontSize = 14
ax = gca;    
ax.YAxis.FontSize = 14
ylabel('Spike PDF', 'FontSize', 16)
xlabel('Alpha Phase (radians)', 'FontSize', 16)
saveas(example_fig, '../Figures/example_phase_hist.fig')
saveas(example_fig, '../Figures/example_phase_hist.svg')

fprintf('Example cell Rayleigh p-value: %d\n', circ_rtest(out.alpha_modulated(ind,:).spon_alpha_spike_phases{1}))
fprintf('Example cell Rayleigh MI: %d\n', out.alpha_modulated(ind,:).pmi)

diary off