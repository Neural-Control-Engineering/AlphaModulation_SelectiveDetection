addpath(genpath('~/circstat-matlab/'))
delete Stats/alpha_mod_and_licking.txt 
diary Stats/alpha_mod_and_licking.txt 
init_paths;
load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Adjusted/Cortex/Spontaneous_Alpha_Modulation/data.mat'))
out_path = false; %true;
alpha_modulated = out.alpha_modulated;

s1 = load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Adjusted/Cortex/Spontaneous_Alpha_Modulation/data.mat'));
pfc = load(strcat(ftr_path, '/AP/FIG/PFC_Expert_Combo_Adjusted/PFC/Spontaneous_Alpha_Modulation/data.mat'));
striatum = load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Adjusted/Basal_Ganglia/Spontaneous_Alpha_Modulation/data.mat'));
amygdala = load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Adjusted/Amygdala/Spontaneous_Alpha_Modulation/data.mat'));

s1.out.alpha_modulated = s1.out.alpha_modulated(cell2mat(s1.out.alpha_modulated.avg_trial_fr) > 1, :);
striatum.out.alpha_modulated = striatum.out.alpha_modulated(cell2mat(striatum.out.alpha_modulated.avg_trial_fr) > 1, :);
amygdala.out.alpha_modulated = amygdala.out.alpha_modulated(cell2mat(amygdala.out.alpha_modulated.avg_trial_fr) > 1, :);
pfc.out.alpha_modulated = pfc.out.alpha_modulated(cell2mat(pfc.out.alpha_modulated.avg_trial_fr) > 1, :);

exinds = load('ExcldInds/3738_excld_v2.mat');
for i = 1:length(exinds.new_excld{1})
    session_id = exinds.new_excld{1}{i};
    cid = exinds.new_excld{2}{i};
    s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.session_id, session_id) & s1.out.alpha_modulated.cluster_id == cid,:) = [];
    striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.session_id, session_id) & striatum.out.alpha_modulated.cluster_id == cid,:) = [];
    amygdala.out.alpha_modulated(strcmp(amygdala.out.alpha_modulated.session_id, session_id) & amygdala.out.alpha_modulated.cluster_id == cid,:) = [];
end
exinds = load('ExcldInds/3387_excld.mat');
for i = 1:length(exinds.excld{1})
    session_id = exinds.excld{1}{i};
    cid = exinds.excld{2}{i};
    s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.session_id, session_id) & s1.out.alpha_modulated.cluster_id == cid,:) = [];
    striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.session_id, session_id) & striatum.out.alpha_modulated.cluster_id == cid,:) = [];
    amygdala.out.alpha_modulated(strcmp(amygdala.out.alpha_modulated.session_id, session_id) & amygdala.out.alpha_modulated.cluster_id == cid,:) = [];
end

inds = find(contains(pfc.out.alpha_modulated.region, 'AC') & strcmp(pfc.out.alpha_modulated.waveform_class, 'RS') & cell2mat(pfc.out.alpha_modulated.avg_trial_fr) > 15);
for i = 1:length(inds)
    pfc.out.alpha_modulated(inds(i),:).waveform_class{1} = 'FS';
end

exinds = load('ExcldInds/1075_excld.mat');
for i = 1:length(exinds.excld{1})
    session_id = exinds.excld{1}{i};
    cid = exinds.excld{2}{i};
    pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.session_id, session_id) & pfc.out.alpha_modulated.cluster_id == cid,:) = [];
end
exinds = load('ExcldInds/3755_excld.mat');
for i = 1:length(exinds.excld{1})
    session_id = exinds.excld{1}{i};
    cid = exinds.excld{2}{i};
    pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.session_id, session_id) & pfc.out.alpha_modulated.cluster_id == cid,:) = [];
end

pfc_rs = pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.waveform_class,'RS'),:);
pfc_fs = pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.waveform_class,'FS'),:);
s1_rs = s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.waveform_class,'RS'),:);
s1_fs = s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.waveform_class,'FS'),:);
striatum_rs = striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.waveform_class,'RS'),:);
striatum_fs = striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.waveform_class,'FS'),:);
amygdala_rs = amygdala.out.alpha_modulated(strcmp(amygdala.out.alpha_modulated.waveform_class,'RS'),:);
amygdala_fs = amygdala.out.alpha_modulated(strcmp(amygdala.out.alpha_modulated.waveform_class,'FS'),:);

pfc_rs_session_ids = unique(pfc_rs.session_id);
for s = 1:length(pfc_rs_session_ids)
    tmp = pfc_rs(strcmp(pfc_rs.session_id, pfc_rs_session_ids{s}),:);
    pfc_rs_fracs_lick(s) = sum(tmp.p_lick < pfc.out.overall_p_threshold) / size(tmp,1) * 100;
    pfc_rs_fracs_nolick(s) = sum(tmp.p_nolick < pfc.out.overall_p_threshold) / size(tmp,1) * 100;
end
pfc_fs_session_ids = unique(pfc_fs.session_id);
for s = 1:length(pfc_fs_session_ids)
    tmp = pfc_fs(strcmp(pfc_fs.session_id, pfc_fs_session_ids{s}),:);
    pfc_fs_fracs_lick(s) = sum(tmp.p_lick < pfc.out.overall_p_threshold) / size(tmp,1) * 100;
    pfc_fs_fracs_nolick(s) = sum(tmp.p_nolick < pfc.out.overall_p_threshold) / size(tmp,1) * 100;
end
s1_rs_session_ids = unique(s1_rs.session_id);
for s = 1:length(s1_rs_session_ids)
    tmp = s1_rs(strcmp(s1_rs.session_id, s1_rs_session_ids{s}),:);
    s1_rs_fracs_lick(s) = sum(tmp.p_lick < s1.out.overall_p_threshold) / size(tmp,1) * 100;
    s1_rs_fracs_nolick(s) = sum(tmp.p_nolick < s1.out.overall_p_threshold) / size(tmp,1) * 100;
end
s1_fs_session_ids = unique(s1_fs.session_id);
for s = 1:length(s1_fs_session_ids)
    tmp = s1_fs(strcmp(s1_fs.session_id, s1_fs_session_ids{s}),:);
    s1_fs_fracs_lick(s) = sum(tmp.p_lick < s1.out.overall_p_threshold) / size(tmp,1) * 100;
    s1_fs_fracs_nolick(s) = sum(tmp.p_nolick < s1.out.overall_p_threshold) / size(tmp,1) * 100;
end
striatum_rs_session_ids = unique(striatum_rs.session_id);
for s = 1:length(striatum_rs_session_ids)
    tmp = striatum_rs(strcmp(striatum_rs.session_id, striatum_rs_session_ids{s}),:);
    striatum_rs_fracs_lick(s) = sum(tmp.p_lick < striatum.out.overall_p_threshold) / size(tmp,1) * 100;
    striatum_rs_fracs_nolick(s) = sum(tmp.p_nolick < striatum.out.overall_p_threshold) / size(tmp,1) * 100;
end
striatum_fs_session_ids = unique(striatum_fs.session_id);
for s = 1:length(striatum_fs_session_ids)
    tmp = striatum_fs(strcmp(striatum_fs.session_id, striatum_fs_session_ids{s}),:);
    striatum_fs_fracs_lick(s) = sum(tmp.p_lick < striatum.out.overall_p_threshold) / size(tmp,1) * 100;
    striatum_fs_fracs_nolick(s) = sum(tmp.p_nolick < striatum.out.overall_p_threshold) / size(tmp,1) * 100;
end
amygdala_rs_session_ids = unique(amygdala_rs.session_id);
for s = 1:length(amygdala_rs_session_ids)
    tmp = amygdala_rs(strcmp(amygdala_rs.session_id, amygdala_rs_session_ids{s}),:);
    amygdala_rs_fracs_lick(s) = sum(tmp.p_lick < amygdala.out.overall_p_threshold) / size(tmp,1) * 100;
    amygdala_rs_fracs_nolick(s) = sum(tmp.p_nolick < amygdala.out.overall_p_threshold) / size(tmp,1) * 100;
end
amygdala_fs_session_ids = unique(amygdala_fs.session_id);
for s = 1:length(amygdala_fs_session_ids)
    tmp = amygdala_fs(strcmp(amygdala_fs.session_id, amygdala_fs_session_ids{s}),:);
    amygdala_fs_fracs_lick(s) = sum(tmp.p_lick < amygdala.out.overall_p_threshold) / size(tmp,1) * 100;
    amygdala_fs_fracs_nolick(s) = sum(tmp.p_nolick < amygdala.out.overall_p_threshold) / size(tmp,1) * 100;
end
% pfc_rs_session_ids = unique(pfc_rs.session_id);
% for s = 1:length(pfc_rs_session_ids)
%     tmp = pfc_rs(strcmp(pfc_rs.session_id, pfc_rs_session_ids{s}),:);
%     pfc_rs_fracs_lick(s) = sum(tmp.p_lick < 0.01) / size(tmp,1) * 100;
%     pfc_rs_fracs_nolick(s) = sum(tmp.p_nolick < 0.01) / size(tmp,1) * 100;
% end
% pfc_fs_session_ids = unique(pfc_fs.session_id);
% for s = 1:length(pfc_fs_session_ids)
%     tmp = pfc_fs(strcmp(pfc_fs.session_id, pfc_fs_session_ids{s}),:);
%     pfc_fs_fracs_lick(s) = sum(tmp.p_lick < 0.01) / size(tmp,1) * 100;
%     pfc_fs_fracs_nolick(s) = sum(tmp.p_nolick < 0.01) / size(tmp,1) * 100;
% end
% s1_rs_session_ids = unique(s1_rs.session_id);
% for s = 1:length(s1_rs_session_ids)
%     tmp = s1_rs(strcmp(s1_rs.session_id, s1_rs_session_ids{s}),:);
%     s1_rs_fracs_lick(s) = sum(tmp.p_lick < 0.01) / size(tmp,1) * 100;
%     s1_rs_fracs_nolick(s) = sum(tmp.p_nolick < 0.01) / size(tmp,1) * 100;
% end
% s1_fs_session_ids = unique(s1_fs.session_id);
% for s = 1:length(s1_fs_session_ids)
%     tmp = s1_fs(strcmp(s1_fs.session_id, s1_fs_session_ids{s}),:);
%     s1_fs_fracs_lick(s) = sum(tmp.p_lick < 0.01) / size(tmp,1) * 100;
%     s1_fs_fracs_nolick(s) = sum(tmp.p_nolick < 0.01) / size(tmp,1) * 100;
% end
% striatum_rs_session_ids = unique(striatum_rs.session_id);
% for s = 1:length(striatum_rs_session_ids)
%     tmp = striatum_rs(strcmp(striatum_rs.session_id, striatum_rs_session_ids{s}),:);
%     striatum_rs_fracs_lick(s) = sum(tmp.p_lick < 0.01) / size(tmp,1) * 100;
%     striatum_rs_fracs_nolick(s) = sum(tmp.p_nolick < 0.01) / size(tmp,1) * 100;
% end
% striatum_fs_session_ids = unique(striatum_fs.session_id);
% for s = 1:length(striatum_fs_session_ids)
%     tmp = striatum_fs(strcmp(striatum_fs.session_id, striatum_fs_session_ids{s}),:);
%     striatum_fs_fracs_lick(s) = sum(tmp.p_lick < 0.01) / size(tmp,1) * 100;
%     striatum_fs_fracs_nolick(s) = sum(tmp.p_nolick < 0.01) / size(tmp,1) * 100;
% end
% amygdala_rs_session_ids = unique(amygdala_rs.session_id);
% for s = 1:length(amygdala_rs_session_ids)
%     tmp = amygdala_rs(strcmp(amygdala_rs.session_id, amygdala_rs_session_ids{s}),:);
%     amygdala_rs_fracs_lick(s) = sum(tmp.p_lick < 0.01) / size(tmp,1) * 100;
%     amygdala_rs_fracs_nolick(s) = sum(tmp.p_nolick < 0.01) / size(tmp,1) * 100;
% end
% amygdala_fs_session_ids = unique(amygdala_fs.session_id);
% for s = 1:length(amygdala_fs_session_ids)
%     tmp = amygdala_fs(strcmp(amygdala_fs.session_id, amygdala_fs_session_ids{s}),:);
%     amygdala_fs_fracs_lick(s) = sum(tmp.p_lick < 0.01) / size(tmp,1) * 100;
%     amygdala_fs_fracs_nolick(s) = sum(tmp.p_nolick < 0.01) / size(tmp,1) * 100;
% end

summary_fig = figure('Position', [1220 1334 1000 700]);
tl = tiledlayout(2,2);
axs(1) = nexttile;
hold on
s1_rs_frac = [s1_rs_fracs_nolick', s1_rs_fracs_lick'];
s1_fs_frac = [s1_fs_fracs_nolick', s1_fs_fracs_lick'];
pfc_rs_frac = [pfc_rs_fracs_nolick', pfc_rs_fracs_lick'];
pfc_fs_frac = [pfc_fs_fracs_nolick', pfc_fs_fracs_lick'];
striatum_rs_frac = [striatum_rs_fracs_nolick', striatum_rs_fracs_lick'];
striatum_fs_frac = [striatum_fs_fracs_nolick', striatum_fs_fracs_lick'];
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
ylim([0,105])
yticks([0,100]);
yticklabels({'0', '100'})
ylabel('% Modulated per Session ', 'FontSize', 14)
ax = gca;
ax.YAxis.FontSize = 14;
ax.XAxis.FontSize = 14;

axs(2) = nexttile;
s1_rs_mi = [s1_rs.pmi_nolick, s1_rs.pmi_lick];
s1_rs_mi(33,:) = nan(1,2);
s1_fs_mi = [s1_fs.pmi_nolick, s1_fs.pmi_lick];
pfc_rs_mi = [pfc_rs.pmi_nolick, pfc_rs.pmi_lick];
pfc_fs_mi = [pfc_fs.pmi_nolick, pfc_fs.pmi_lick];
striatum_rs_mi = [striatum_rs.pmi_nolick, striatum_rs.pmi_lick];
striatum_fs_mi = [striatum_fs.pmi_nolick, striatum_fs.pmi_lick];
hold on 
for i = 1:size(s1_rs_mi,1)
    x = (rand()-0.5) * 0.5;
    plot(1+x, log(s1_rs_mi(i,1)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(3+x, log(s1_rs_mi(i,2)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([1,3]+x, log(s1_rs_mi(i,:)), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(1, nanmean(log(s1_rs_mi(:,1))), ste(log(s1_rs_mi(:,1))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(3, nanmean(log(s1_rs_mi(:,2))), ste(log(s1_rs_mi(:,2))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([1,3], [nanmean(log(s1_rs_mi(:,1))), nanmean(log(s1_rs_mi(:,2)))], 'k--', 'LineWidth', 0.01)

for i = 1:size(s1_fs_mi,1)
    x = (rand()-0.5) * 0.5;
    plot(6+x, log(s1_fs_mi(i,1)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(8+x, log(s1_fs_mi(i,2)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([6,8]+x, log(s1_fs_mi(i,:)), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(6, nanmean(log(s1_fs_mi(:,1))), ste(log(s1_fs_mi(:,1))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(8, nanmean(log(s1_fs_mi(:,2))), ste(log(s1_fs_mi(:,2))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([6,8]+x, [nanmean(log(s1_fs_mi(:,1))), nanmean(log(s1_fs_mi(:,2)))], 'k--', 'LineWidth', 0.01)

for i = 1:size(pfc_rs_mi,1)
    x = (rand()-0.5) * 0.5;
    plot(11+x, log(pfc_rs_mi(i,1)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(13+x, log(pfc_rs_mi(i,2)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([11,13]+x, log(pfc_rs_mi(i,:)), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(11, nanmean(log(pfc_rs_mi(:,1))), ste(log(pfc_rs_mi(:,1))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(13, nanmean(log(pfc_rs_mi(:,2))), ste(log(pfc_rs_mi(:,2))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([11,13], [nanmean(log(pfc_rs_mi(:,1))), nanmean(log(pfc_rs_mi(:,2)))], 'k--', 'LineWidth', 0.01)

for i = 1:size(pfc_fs_mi,1)
    x = (rand()-0.5) * 0.5;
    plot(16+x, log(pfc_fs_mi(i,1)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(18+x, log(pfc_fs_mi(i,2)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([16,18]+x, log(pfc_fs_mi(i,:)), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(16, nanmean(log(pfc_fs_mi(:,1))), ste(log(pfc_fs_mi(:,1))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(18, nanmean(log(pfc_fs_mi(:,2))), ste(log(pfc_fs_mi(:,2))), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([16,18]+x, [nanmean(log(pfc_fs_mi(:,1))), nanmean(log(pfc_fs_mi(:,2)))], 'k--', 'LineWidth', 0.01)

for i = 1:size(striatum_rs_mi,1)
    x = (rand()-0.5) * 0.5;
    plot(21+x, log(striatum_rs_mi(i,1)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(23+x, log(striatum_rs_mi(i,2)), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([21,23]+x, log(striatum_rs_mi(i,:)), '--', 'Color', [0.5, 0.5, 0.5])
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
load phase_mod_licking_frs.mat
s1_rs_fr = [cellfun(@nanmean, out.s1_rs_all_lick_frs)', cellfun(@nanmean, out.s1_rs_all_no_lick_frs)'];
s1_fs_fr = [cellfun(@nanmean, out.s1_fs_all_lick_frs)', cellfun(@nanmean, out.s1_fs_all_no_lick_frs)'];
pfc_rs_fr = [cellfun(@nanmean, out.pfc_rs_all_lick_frs)', cellfun(@nanmean, out.pfc_rs_all_no_lick_frs)'];
pfc_fs_fr = [cellfun(@nanmean, out.pfc_fs_all_lick_frs)', cellfun(@nanmean, out.pfc_fs_all_no_lick_frs)'];
striatum_rs_fr = [cellfun(@nanmean, out.striatum_rs_all_lick_frs)', cellfun(@nanmean, out.striatum_rs_all_no_lick_frs)'];
striatum_fs_fr = [cellfun(@nanmean, out.striatum_fs_all_lick_frs)', cellfun(@nanmean, out.striatum_fs_all_no_lick_frs)'];
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

s1_rs_theta_bars_lick = s1_rs.theta_bars_lick;
pfc_rs_theta_bars_lick = pfc_rs.theta_bars_lick;
striatum_rs_theta_bars_lick = striatum_rs.theta_bars_lick;
amygdala_rs_theta_bars_lick = amygdala_rs.theta_bars_lick;
s1_fs_theta_bars_lick = s1_fs.theta_bars_lick;
pfc_fs_theta_bars_lick = pfc_fs.theta_bars_lick;
striatum_fs_theta_bars_lick = striatum_fs.theta_bars_lick;
amygdala_fs_theta_bars_lick = amygdala_fs.theta_bars_lick;

s1_rs_theta_bars_lick = s1_rs_theta_bars_lick(~isnan(s1_rs_theta_bars_lick));
pfc_rs_theta_bars_lick = pfc_rs_theta_bars_lick(~isnan(pfc_rs_theta_bars_lick));
striatum_rs_theta_bars_lick = striatum_rs_theta_bars_lick(~isnan(striatum_rs_theta_bars_lick));
amygdala_rs_theta_bars_lick = amygdala_rs_theta_bars_lick(~isnan(amygdala_rs_theta_bars_lick));
s1_fs_theta_bars_lick = s1_fs_theta_bars_lick(~isnan(s1_fs_theta_bars_lick));
pfc_fs_theta_bars_lick = pfc_fs_theta_bars_lick(~isnan(pfc_fs_theta_bars_lick));
striatum_fs_theta_bars_lick = striatum_fs_theta_bars_lick(~isnan(striatum_fs_theta_bars_lick));
amygdala_fs_theta_bars_lick = amygdala_fs_theta_bars_lick(~isnan(amygdala_fs_theta_bars_lick));

s1_rs_theta_bars_nolick = s1_rs.theta_bars_nolick;
pfc_rs_theta_bars_nolick = pfc_rs.theta_bars_nolick;
striatum_rs_theta_bars_nolick = striatum_rs.theta_bars_nolick;
amygdala_rs_theta_bars_nolick = amygdala_rs.theta_bars_nolick;
s1_fs_theta_bars_nolick = s1_fs.theta_bars_nolick;
pfc_fs_theta_bars_nolick = pfc_fs.theta_bars_nolick;
striatum_fs_theta_bars_nolick = striatum_fs.theta_bars_nolick;
amygdala_fs_theta_bars_nolick = amygdala_fs.theta_bars_nolick;

s1_rs_theta_bars_nolick = s1_rs_theta_bars_nolick(~isnan(s1_rs_theta_bars_nolick));
pfc_rs_theta_bars_nolick = pfc_rs_theta_bars_nolick(~isnan(pfc_rs_theta_bars_nolick));
striatum_rs_theta_bars_nolick = striatum_rs_theta_bars_nolick(~isnan(striatum_rs_theta_bars_nolick));
amygdala_rs_theta_bars_nolick = amygdala_rs_theta_bars_nolick(~isnan(amygdala_rs_theta_bars_nolick));
s1_fs_theta_bars_nolick = s1_fs_theta_bars_nolick(~isnan(s1_fs_theta_bars_nolick));
pfc_fs_theta_bars_nolick = pfc_fs_theta_bars_nolick(~isnan(pfc_fs_theta_bars_nolick));
striatum_fs_theta_bars_nolick = striatum_fs_theta_bars_nolick(~isnan(striatum_fs_theta_bars_nolick));
amygdala_fs_theta_bars_nolick = amygdala_fs_theta_bars_nolick(~isnan(amygdala_fs_theta_bars_nolick));

axs(4) = nexttile;
s1_rs_fr = [s1_rs_theta_bars_lick, s1_rs_theta_bars_nolick];
s1_fs_fr = [s1_fs_theta_bars_lick, s1_fs_theta_bars_nolick];
pfc_rs_fr = [pfc_rs_theta_bars_lick, pfc_rs_theta_bars_nolick];
pfc_fs_fr = [pfc_fs_theta_bars_lick, pfc_fs_theta_bars_nolick];
striatum_rs_fr = [striatum_rs_theta_bars_lick, striatum_rs_theta_bars_nolick];
striatum_fs_fr = [striatum_fs_theta_bars_lick, striatum_fs_theta_bars_nolick];
hold on 
for i = 1:size(s1_rs_fr,1)
    x = (rand()-0.5) * 0.5;
    plot(1+x, s1_rs_fr(i,1), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(3+x, s1_rs_fr(i,2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([1,3], s1_rs_fr(i,:), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(1, circ_mean(s1_rs_fr(:,1)), circ_ste(s1_rs_fr(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(3, circ_mean(s1_rs_fr(:,2)), circ_ste(s1_rs_fr(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([1,3], [circ_mean(s1_rs_fr(:,1)), circ_mean(s1_rs_fr(:,2))], 'k--', 'LineWidth', 0.01)

for i = 1:size(s1_fs_fr,1)
    x = (rand()-0.5) * 0.5;
    plot(6+x, s1_fs_fr(i,1), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(8+x, s1_fs_fr(i,2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([6,8], s1_fs_fr(i,:), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(6, circ_mean(s1_fs_fr(:,1)), circ_ste(s1_fs_fr(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(8, circ_mean(s1_fs_fr(:,2)), circ_ste(s1_fs_fr(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([6,8], [circ_mean(s1_fs_fr(:,1)), circ_mean(s1_fs_fr(:,2))], 'k--', 'LineWidth', 0.01)

for i = 1:size(pfc_rs_fr,1)
    x = (rand()-0.5) * 0.5;
    plot(11+x, pfc_rs_fr(i,1), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(13+x, pfc_rs_fr(i,2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([11,13], pfc_rs_fr(i,:), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(11, circ_mean(pfc_rs_fr(:,1)), circ_ste(pfc_rs_fr(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(13, circ_mean(pfc_rs_fr(:,2)), circ_ste(pfc_rs_fr(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([11,13], [circ_mean(pfc_rs_fr(:,1)), circ_mean(pfc_rs_fr(:,2))], 'k--', 'LineWidth', 0.01)

for i = 1:size(pfc_fs_fr,1)
    x = (rand()-0.5) * 0.5;
    plot(16+x, pfc_fs_fr(i,1), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(18+x, pfc_fs_fr(i,2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([16,18], pfc_fs_fr(i,:), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(16, circ_mean(pfc_fs_fr(:,1)), circ_ste(pfc_fs_fr(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(18, circ_mean(pfc_fs_fr(:,2)), circ_ste(pfc_fs_fr(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([16,18], [circ_mean(pfc_fs_fr(:,1)), circ_mean(pfc_fs_fr(:,2))], 'k--', 'LineWidth', 0.01)

for i = 1:size(striatum_rs_fr,1)
    x = (rand()-0.5) * 0.5;
    plot(21+x, striatum_rs_fr(i,1), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(23+x, striatum_rs_fr(i,2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([21,23], striatum_rs_fr(i,:), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(21, circ_mean(striatum_rs_fr(:,1)), circ_ste(striatum_rs_fr(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(23, circ_mean(striatum_rs_fr(:,2)), circ_ste(striatum_rs_fr(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([21,23], [circ_mean(striatum_rs_fr(:,1)), circ_mean(striatum_rs_fr(:,2))], 'k--', 'LineWidth', 0.01)

for i = 1:size(striatum_fs_fr,1)
    x = (rand()-0.5) * 0.5;
    plot(26+x, striatum_fs_fr(i,1), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1])
    plot(28+x, striatum_fs_fr(i,2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1])
    plot([26,28], striatum_fs_fr(i,:), '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar(26, circ_mean(striatum_fs_fr(:,1)), circ_ste(striatum_fs_fr(:,1)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
errorbar(28, circ_mean(striatum_fs_fr(:,2)), circ_ste(striatum_fs_fr(:,2)), 'k.', 'LineWidth', 1.5, 'CapSize', 20)
plot([26,28], [circ_mean(striatum_fs_fr(:,1)), circ_mean(striatum_fs_fr(:,2))], 'k--', 'LineWidth', 0.01)
xticks([2, 7, 12, 17, 22, 27])
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS'})
ylabel('Avg. Firing Phase (rad) ', 'FontSize', 14)
lims = ylim;
ax = gca;
ax.YAxis.FontSize = 14;
ax.XAxis.FontSize = 14;
ylim([-pi,pi])
yticks([-pi, pi])
yticklabels({'-\pi', '\pi'})

all_phase_mod = combineTables(s1.out.alpha_modulated, pfc.out.alpha_modulated); 
all_phase_mod = combineTables(all_phase_mod, striatum.out.alpha_modulated); 
% all_phase_mod = combineTables(all_phase_mod, amygdala.out.alpha_modulated);
all_session_ids = unique(all_phase_mod.session_id);
for s = 1:length(all_session_ids)
    tmp = all_phase_mod(strcmp(all_phase_mod.session_id, all_session_ids{s}),:);
    fracs_lick(s) = sum(tmp.p_lick < pfc.out.overall_p_threshold) / size(tmp,1) * 100;
    fracs_nolick(s) = sum(tmp.p_nolick < pfc.out.overall_p_threshold) / size(tmp,1) * 100;
    % fracs_lick(s) = sum(tmp.p_lick < 0.01) / size(tmp,1) * 100;
    % fracs_nolick(s) = sum(tmp.p_nolick < 0.01) / size(tmp,1) * 100;
end

all_fig = figure('Position', [[1210 1197 433 605]]);
hold on 
% bar(1:2, [nanmean(fracs_nolick), nanmean(fracs_lick)], 'FaceColor', [0.5, 0.5, 0.5], 'EdgeColor', [0.5, 0.5, 0.5])
for i = 1:length(fracs_nolick)
    x = (rand()-0.5)*0.3;
    plot(1+x, fracs_nolick(i), 'o', 'MarkerFaceColor', [0.5, 0.5, 0.5], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot(2+x, fracs_lick(i), 'o', 'MarkerFaceColor', [0.5, 0.5, 0.5], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot([1,2]+x, [fracs_nolick(i), fracs_lick(i)], '--', 'Color', [0.5,0.5,0.5])
end
errorbar(1:2, [nanmean(fracs_nolick), nanmean(fracs_lick)], [ste(fracs_nolick), ste(fracs_lick)], 'b.', 'CapSize', 20, 'LineWidth', 2)
xticks(1:2)
xticklabels({'No Lick Trials', 'Lick Trials'})
ylabel('% Phase Modulated per Session')
xlim([0.5,2.5])
ylim([0,105])
yticks([0,100])

if KStest(fracs_lick) || KStest(fracs_nolick)
    p = signrank(fracs_lick, fracs_nolick);
    fprintf(sprintf('pct modulated on no lick trials vs. pct modulated on lick trials (signed-rank): p = %d\n', p))
else
    [~, p] = ttest(fracs_lick, fracs_nolick)
    fprintf(sprintf('pct modulated on no lick trials vs. pct modulated on lick trials (t-test): p = %d\n', p))
end

sessionIDs;
session_ids = horzcat(expert_3387_session_ids, expert_3738_session_ids_v2, expert_3755_session_ids, expert_1075_session_ids);
n_lick = zeros(length(session_ids),1);
n_nolick = zeros(length(session_ids),1);
for s = 1:length(session_ids)
    load(strcat(ext_path, 'SLRT/', session_ids{s}, '.mat'))
    % load(strcat(ext_path, 'AP/', session_ids{s}, '.mat'))
    contains_lick = spontaneousLicks(slrt_data);
    n_lick(s) = sum(contains_lick == 1);
    n_nolick(s) = sum(contains_lick == 0);
end
trial_fig = figure('Position', [[1210 1197 433 605]]);
hold on 
% bar([1,2], [mean(n_lick), mean(n_nolick)], 'FaceColor', [0.5, 0.5, 0.5], 'EdgeColor', [0.5, 0.5, 0.5])
for i = 1:length(n_lick)
    x = (rand()-0.5)*0.3;
    plot(1+x, n_nolick(i), 'o', 'MarkerFaceColor', [0.5, 0.5, 0.5], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot(2+x, n_lick(i), 'o', 'MarkerFaceColor', [0.5, 0.5, 0.5], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot([1,2]+x, [n_nolick(i), n_lick(i)], '--', 'Color', [0.5,0.5,0.5])
end
errorbar([1,2], [mean(n_nolick), mean(n_lick)], [ste(n_nolick), ste(n_lick)], 'b.', 'CapSize', 20, 'LineWidth', 2)
xticks(1:2)
xticklabels({'Lick', 'No-Lick'})
xlabel('Spontaneous Trials')
ylabel('Number of trials')
xlim([0.5,2.5])
lims = ylim;
ylim([0, lims(2)])
yticks([0, lims(2)])

if KStest(n_lick) || KStest(n_nolick)
    p = signrank(n_lick, n_nolick);
    fprintf(sprintf('No lick trials vs. lick trials N (signed-rank): p = %d\n', p))
else
    [~, p] = ttest(n_lick, n_nolick)
    fprintf(sprintf('No lick trials vs. lick trials N (t-test): p = %d\n', p))
end

ldprime = nan(1,length(session_ids));
nldprime = nan(1,length(session_ids));
for s = 1:length(session_ids)
    load(strcat(ext_path, 'SLRT/', session_ids{s}, '.mat'))
    slrt_data.dprime = [];
    contains_lick = spontaneousLicks(slrt_data);
    lick_trials = slrt_data(logical(contains_lick),:);
    no_lick_trials = slrt_data(~logical(contains_lick),:);
    if ~isempty(lick_trials)
        lick_trials = dPrime(lick_trials);
        ldprime(s) = lick_trials(1,:).dprime;
    end 
    if ~isempty(no_lick_trials)
        no_lick_trials = dPrime(no_lick_trials);
        nldprime(s) = no_lick_trials(1,:).dprime;
    end
end
dprime_fig = figure('Position', [[1210 1197 433 605]]);
hold on 
for i = 1:length(ldprime)
    x = (rand()-0.5)*0.3;
    plot(1+x, nldprime(i), 'o', 'MarkerFaceColor', [0.5, 0.5, 0.5], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot(2+x, ldprime(i), 'o', 'MarkerFaceColor', [0.5, 0.5, 0.5], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot([1,2]+x, [nldprime(i), ldprime(i)], '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar([1,2], [nanmean(nldprime), nanmean(ldprime)], [ste(nldprime), ste(ldprime)], 'b.', 'CapSize', 20, 'LineWidth', 2)
xticks(1:2)
xticklabels({'No Lick Trials', 'Lick Trials'})
ylabel('D-prime')
xlim([0.5,2.5])
lims = ylim;
yticks(lims)

if KStest(ldprime) || KStest(nldprime)
    p = signrank(ldprime, nldprime);
    fprintf(sprintf('No lick trials vs. lick trials dprime (signed-rank): p = %d\n', p))
else
    [~, p] = ttest(ldprime, nldprime)
    fprintf(sprintf('No lick trials vs. lick trials dprime (t-test): p = %d\n', p))
end

saveas(summary_fig, '../Figures/lick_summary.svg')
saveas(summary_fig, '../Figures/lick_summary.fig')
saveas(trial_fig, '../Figures/lick_trials.fig')
saveas(trial_fig, '../Figures/lick_trials.svg')
saveas(all_fig, '../Figures/lick_pct.fig')
saveas(all_fig, '../Figures/lick_pct.svg')
saveas(dprime_fig, '../Figures/lick_nolick_dprime.svg')
saveas(dprime_fig, '../Figures/lick_nolick_dprime.fig')

diary off 