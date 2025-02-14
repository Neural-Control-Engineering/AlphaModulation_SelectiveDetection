init_paths;
mkdir('./Figures/')
pfc = load(strcat(ftr_path, '/AP/FIG/PFC_Expert_Combo/PFC/Spontaneous_Alpha_Modulation_v2/data.mat'));
pfc = pfc.out.alpha_modulated;
cs = [278, 270, 210];
fig = figure('Position', [1220 1375 1270 343]);
tl = tiledlayout(1,3);
for i = 1:length(cs)
    c = cs(i);
    [N, edges] = histcounts(pfc(c,:).spon_alpha_spike_phases{1}, 20, 'Normalization', 'pdf');
    binCenters = zeros(length(edges)-1,1);
    for e = 1:(length(edges)-1)
        binCenters(e) = mean(edges(e:(e+1)));
    end
    if c == 210 
        gmmModel = fitgmdist(pfc(c,:).spon_alpha_spike_phases{1}', 2);
        x = linspace(min(binCenters), max(binCenters), 1000); % Fine grid for PDF
        y = pdf(gmmModel, x'); % Evaluate GMM PDF
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
end
unifyYLimits(axs)
xlabel(tl, 'Alpha Phase (radians)')
ylabel(tl, 'Spike PDF')
saveas(fig, 'Figures/phase_mod_classes.svg')
saveas(fig, 'Figures/phase_mod_classes.fig')