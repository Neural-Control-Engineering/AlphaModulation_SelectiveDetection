init_paths;
addpath(genpath('~/mvmdist/'))
mkdir('./Figures/')
pfc = load(strcat(ftr_path, '/AP/FIG/PFC_Expert_Combo_Adjusted/PFC/Spontaneous_Alpha_Modulation/data.mat'));
pfc = pfc.out.alpha_modulated;

[N, edges] = histcounts(pfc(1,:).spon_alpha_spike_phases{1}, 20, 'Normalization', 'pdf');
binCenters = zeros(length(edges)-1,1);
for e = 1:(length(edges)-1)
    binCenters(e) = mean(edges(e:(e+1)));
end
x = linspace(min(binCenters), max(binCenters), 1000)'; % Fine grid for PDF
y = [];
for c = 1:size(pfc,1)
    fittedVmm = fitmvmdist(pfc(c,:).spon_alpha_spike_phases{1}', 2, ...
        'MaxIter', 250); % Set maximum number of EM iterations to 250
    y(c,:) = fittedVmm.pdf(x)';
end

% compute pca 
[~, score, ~, ~, explained] = pca(y);
% Determine the number of components to retain 95% variance
numComponents = find(cumsum(explained) >= 95, 1);
reducedData = score(:, 1:numComponents);
% determine the optimal number of clusters using the silhouette method
eva = evalclusters(reducedData, 'kmeans', 'silhouette', 'KList', 2:10);
optimalK = eva.OptimalK;
[idx, ~] = kmeans(reducedData, 4, 'Replicates', 10);
% idx(idx == 2) = 2;
figure();
hold on 
cols = distinguishable_colors(length(unique(idx)));
for i = 1:length(unique(idx))
    subplot(1, length(unique(idx)), i)
    dn = sprintf('Group %i', i);
    try
        semshade(y(idx==i,:), 0.3, 'k', 'k', x, 1, dn);
    catch 
        plot(x, y(idx==i,:), 'Color', 'k', 'DisplayName', dn)
    end
end 
bmidx = input('Enter bimodal index: ');
bimodal_total = sum(idx == bmidx);
pfc_tmp = pfc;
pfc_tmp(idx == bmidx,:) = [];

s1 = load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Adjusted/Cortex/Spontaneous_Alpha_Modulation/data.mat'));
striatum = load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Adjusted/Basal_Ganglia/Spontaneous_Alpha_Modulation/data.mat'));
amygdala = load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Adjusted/Amygdala/Spontaneous_Alpha_Modulation/data.mat'));
s1 = s1.out.alpha_modulated;
striatum = striatum.out.alpha_modulated;
amygdala = amygdala.out.alpha_modulated;
all_phase_mod = combineTables(s1, pfc_tmp); 
all_phase_mod = combineTables(all_phase_mod, striatum); 
all_phase_mod = combineTables(all_phase_mod, amygdala);
clear s1 striatum amygdala

exinds = load('ExcldInds/3738_excld_v2.mat');
for i = 1:length(exinds.new_excld{1})
    session_id = exinds.new_excld{1}{i};
    cid = exinds.new_excld{2}{i};
    all_phase_mod(strcmp(all_phase_mod.session_id, session_id) & all_phase_mod.cluster_id == cid,:) = [];
end
exinds = load('ExcldInds/3387_excld.mat');
for i = 1:length(exinds.excld{1})
    session_id = exinds.excld{1}{i};
    cid = exinds.excld{2}{i};
    all_phase_mod(strcmp(all_phase_mod.session_id, session_id) & all_phase_mod.cluster_id == cid,:) = [];
end

y = [];
for c = 1:size(all_phase_mod,1)
    [~,y(c,:), theta_bar(c), ~, ~] = vonMises(all_phase_mod(c,:).spon_alpha_spike_phases{1});
end
peak_total = sum(theta_bar < pi/6 & theta_bar > -pi/6);
trough_total = sum(theta_bar < (-pi+pi/6) | theta_bar > (pi-pi/6));

bimodal_pct = bimodal_total / (size(all_phase_mod,1) + bimodal_total) * 100;
peak_pct = peak_total / (size(all_phase_mod,1) + bimodal_total) * 100;
trough_pct = trough_total / (size(all_phase_mod,1) + bimodal_total) * 100;

pcts = [trough_pct, peak_pct, bimodal_pct];
ttls = {'Fires near trough ', 'Fires near peak ', 'Bimodal distribution '};
for i = 1:length(pcts)
    ttls{i} = sprintf('%s(%.2f%%)', ttls{i}, pcts(i));
end

cs = [270, 278, 210];
fig = figure('Position', [1220 1280 1480 438]);
tl = tiledlayout(1,3);
for i = 1:length(cs)
    c = cs(i);
    [N, edges] = histcounts(pfc(c,:).spon_alpha_spike_phases{1}, 20, 'Normalization', 'pdf');
    binCenters = zeros(length(edges)-1,1);
    for e = 1:(length(edges)-1)
        binCenters(e) = mean(edges(e:(e+1)));
    end
    if c == 210 
        fittedVmm = fitmvmdist(pfc(c,:).spon_alpha_spike_phases{1}', 2, ...
            'MaxIter', 250); % Set maximum number of EM iterations to 250
        x = linspace(min(binCenters), max(binCenters), 1000)'; % Fine grid for PDF
        y = fittedVmm.pdf(x);
    else
        [x,y, ~, ~, ~] = vonMises(pfc(c,:).spon_alpha_spike_phases{1});
    end
    axs(i) = nexttile;
    hold on
    bar(binCenters, N, 'EdgeColor', 'k', 'FaceColor', [0.5,0.5,0.5], 'BarWidth', 1)
    plot(x, y, 'k-', 'LineWidth', 2)
    xticks([-pi,pi])
    xticklabels({'-\pi', '\pi'})
    if i == 1 
        yticks([0,0.3]);
    else
        yticks([])
    end
    ax = gca;
    ax.XAxis.FontSize = 16;
    title(ttls{i}, 'FontSize', 16, 'FontWeight', 'normal')
end
unifyYLimits(axs)
xlabel(tl, 'Alpha Phase (radians)', 'FontSize', 16)
ylabel(tl, 'Spike PDF', 'FontSize', 16)
saveas(fig, 'Figures/phase_mod_classes.svg')
saveas(fig, 'Figures/phase_mod_classes.fig')