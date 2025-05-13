init_paths;
session_ids = {'date--2024-02-22_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g1.mat', ...
    'date--2024-02-22_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'date--2024-02-21_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'date--2024-02-20_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'date--2024-02-15_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'date--2024-03-04_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'date--2024-03-01_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'date--2024-02-29_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat', ...
    'date--2024-02-27_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'};
time = linspace(-2.8,5,4000);
for s = 1:length(session_ids)
    load(strcat(ftr_path, 'LFP/', session_ids{s}))
    mat = cell2mat(lfp_session.left_trigger_aligned_erp);
    mat = mat - nanmean(mat(:,time < 0),2);
    mat = mat(2:2:385,:);
    csd{s} = computeCSD(mat, (3.84/13/1000));
end
incld = [2,3,5,6,7,8,9];
csd = csd(incld);
csd_mat = zeros(190,3999,length(csd));
for i = 1:length(csd)
    csd_mat(:,:,i) = csd{i}(:,1:3999);
end
load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Subjects/3387-20240121/regionMap_adjusted.mat
fig = figure('Position', [1531 1107 1133 540]); 
tl = tiledlayout(1,2);
axs(1) = nexttile;
hold on; 
imagesc(time(1:end-1), 1:size(csd_mat,1), mean(csd_mat,3)); colorbar(); clim([-15,15]); 
colormap('jet'); set(gca, 'YDir', 'normal'); 
layers{1} = [min(cell2mat(regMap.channel(contains(regMap.region, 'bfd1')))), max(cell2mat(regMap.channel(contains(regMap.region, 'bfd1'))))] ./ 2;
layers{2} = [min(cell2mat(regMap.channel(contains(regMap.region, 'bfd2')))), max(cell2mat(regMap.channel(contains(regMap.region, 'bfd2'))))] ./ 2;
layers{3} = [min(cell2mat(regMap.channel(contains(regMap.region, 'bfd4')))), max(cell2mat(regMap.channel(contains(regMap.region, 'bfd4'))))] ./ 2;
layers{4} = [min(cell2mat(regMap.channel(contains(regMap.region, 'bfd5')))), max(cell2mat(regMap.channel(contains(regMap.region, 'bfd5'))))] ./ 2;
layers{5} = [min(cell2mat(regMap.channel(contains(regMap.region, 'bfd6')))), max(cell2mat(regMap.channel(contains(regMap.region, 'bfd6'))))] ./ 2;
layer_names = {'L1', 'L2/3', 'L4', 'L5', 'L6'};
for i = 1:length(layers)
    plot([min(time),max(time)], [layers{i}(1), layers{i}(1)],  'k--')
    plot([min(time),max(time)], [layers{i}(2), layers{i}(2)],  'k--')
end
plot(time, smooth(mat(round(layers{1}(1))+5,:)*3e4, 10) + (layers{1}(1)+5), 'k-', 'LineWidth', 1.5)
plot(time, smooth(mat(round(layers{1}(2))-5,:)*3e4, 10) + (layers{1}(2)-5), 'k-', 'LineWidth', 1.5)
mids = fliplr(cellfun(@mean, layers));
for m = 1:length(mids)
    plot(time, smooth((mat(round(mids(m)),:))*3e4, 10) + (mids(m)), 'k-', 'LineWidth', 1.5)
end
yticks(mids)
yticklabels(fliplr(layer_names))
ylim([115,190]); xlim([-0.1,0.8])
title('Mouse 1')

session_ids = {'date--2024-07-12_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-13_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-15_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-16_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-17_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-24_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-25_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-29_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-31_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0'};
csd = {};
f0 = 0.5; f1 = 30;
d = designfilt('bandpassiir', ...
    'FilterOrder', 4, ...
    'HalfPowerFrequency1', f0, ...
    'HalfPowerFrequency2', f1, ...
    'DesignMethod', 'butter', ...
    'SampleRate', 500);
for s = 1:length(session_ids)
    load(strcat(ftr_path, 'LFP/', session_ids{s}, '.mat'))
    mat = cell2mat(lfp_session.left_trigger_aligned_erp);
    mat = mat - nanmean(mat(:,time < 0),2);
    mat = mat(2:2:385,:);
    for c = 1:size(mat,1)
        mat(c,2093) = nan;
        mat(c,:) = fillmissing(mat(c,:), 'linear');
        mat(c,:) = filtfilt(d, mat(c,:));
        mat(c,1) = mat(c,2);
    end 
    csd{s} = computeCSD(mat, (3.84/13/1000));
end 
incld = [1,2,3,4,5,7,8,9];
csd = csd(incld);
csd_mat = zeros(190,3999,length(csd));
for i = 1:length(csd)
    csd_mat(:,:,i) = csd{i}(:,1:3999);
end
load ~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Subjects/3738-20240702/regionMap_adjusted.mat
axs(2) = nexttile;
hold on;
imagesc(time(1:end-1), 1:size(csd_mat,1), mean(csd_mat,3)); colorbar(); clim([-20,20]); 
colormap('jet'); set(gca, 'YDir', 'normal'); 
layers{1} = [min(cell2mat(regMap.channel(contains(regMap.region, 'bfd1')))), max(cell2mat(regMap.channel(contains(regMap.region, 'bfd1'))))] ./ 2;
layers{2} = [min(cell2mat(regMap.channel(contains(regMap.region, 'bfd2')))), max(cell2mat(regMap.channel(contains(regMap.region, 'bfd2'))))] ./ 2;
layers{3} = [min(cell2mat(regMap.channel(contains(regMap.region, 'bfd4')))), max(cell2mat(regMap.channel(contains(regMap.region, 'bfd4'))))] ./ 2;
layers{4} = [min(cell2mat(regMap.channel(contains(regMap.region, 'bfd5')))), max(cell2mat(regMap.channel(contains(regMap.region, 'bfd5'))))] ./ 2;
layers{5} = [min(cell2mat(regMap.channel(contains(regMap.region, 'bfd6')))), max(cell2mat(regMap.channel(contains(regMap.region, 'bfd6'))))] ./ 2;
layer_names = {'L1', 'L2/3', 'L4', 'L5', 'L6'};
for i = 2:length(layers)
    plot([min(time),max(time)], [layers{i}(1), layers{i}(1)],  'k--')
    plot([min(time),max(time)], [layers{i}(2), layers{i}(2)],  'k--')
end
mids = fliplr(cellfun(@mean, layers));
mids(1) = 133;
mids(end) = 170;
for m = 1:length(mids)
    plot(time(1:end-1), smooth((mat(round(mids(m)),:))*3e4, 10) + (mids(m)), 'k-', 'LineWidth', 1.5)
end
plot(time(1:end-1), smooth(mat(round(mids(end))+5,:)*3e4, 10) + (mids(end)+5), 'k-', 'LineWidth', 1.5)
plot(time(1:end-1), smooth(mat(round(mids(end))-5,:)*3e4, 10) + (mids(end)-5), 'k-', 'LineWidth', 1.5)
yticks(mids)
yticklabels(fliplr(layer_names))
ylim([122,178]); xlim([-0.1,0.8])
title('Mouse 2')
xlabel(tl, 'Time (s)')
ylabel(tl, 'Cortical Layer')

saveas(fig, 'Figures/s1_csd.fig')
saveas(fig, 'Figures/s1_csd.svg')