% delete Stats/lfp_analysis.txt
% diary Stats/lfp_analysis.txt
init_paths;
%% s1 
ftr_files1 = {strcat(ftr_path, 'LFP/date--2024-03-04_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-03-01_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-29_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-27_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-22_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g1.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-22_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-21_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-20_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-15_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat')};

ftr_files2 = {strcat(ftr_path, 'LFP/date--2024-07-17_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-07-16_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-07-15_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-07-13_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-07-12_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-07-24_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-07-25_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-07-29_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-07-31_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-08-01_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-08-02_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat')};
s1_channel = 285;
striatum_channel = 138;
amygdala_channel = 160;

s1_hit = nan(257,156, length(ftr_files1)+length(ftr_files2));
s1_miss = nan(257,156, length(ftr_files1)+length(ftr_files2));
s1_cr = nan(257,156, length(ftr_files1)+length(ftr_files2));
s1_fa = nan(257,156, length(ftr_files1)+length(ftr_files2));
striatum_hit = nan(257,156, length(ftr_files1)+length(ftr_files2));
striatum_miss = nan(257,156, length(ftr_files1)+length(ftr_files2));
striatum_cr = nan(257,156, length(ftr_files1)+length(ftr_files2));
striatum_fa = nan(257,156, length(ftr_files1)+length(ftr_files2));
amygdala_hit = nan(257,156, length(ftr_files1)+length(ftr_files2));
amygdala_miss = nan(257,156, length(ftr_files1)+length(ftr_files2));
amygdala_cr = nan(257,156, length(ftr_files1)+length(ftr_files2));
amygdala_fa = nan(257,156, length(ftr_files1)+length(ftr_files2));

ftr_files = ftr_files1;

for f = 1:length(ftr_files)
    data = load(ftr_files{f});
    s1_hit(:,:,f) = data.lfp_session(s1_channel,:).avg_spectrogram_Hit{1};
    s1_miss(:,:,f) = data.lfp_session(s1_channel,:).avg_spectrogram_Miss{1};
    s1_cr(:,:,f) = data.lfp_session(s1_channel,:).avg_spectrogram_CR{1};
    s1_fa(:,:,f) = data.lfp_session(s1_channel,:).avg_spectrogram_FA{1};

    striatum_hit(:,:,f) = data.lfp_session(striatum_channel,:).avg_spectrogram_Hit{1};
    striatum_miss(:,:,f) = data.lfp_session(striatum_channel,:).avg_spectrogram_Miss{1};
    striatum_cr(:,:,f) = data.lfp_session(striatum_channel,:).avg_spectrogram_CR{1};
    striatum_fa(:,:,f) = data.lfp_session(striatum_channel,:).avg_spectrogram_FA{1};

    amygdala_hit(:,:,f) = data.lfp_session(amygdala_channel,:).avg_spectrogram_Hit{1};
    amygdala_miss(:,:,f) = data.lfp_session(amygdala_channel,:).avg_spectrogram_Miss{1};
    amygdala_cr(:,:,f) = data.lfp_session(amygdala_channel,:).avg_spectrogram_CR{1};
    amygdala_fa(:,:,f) = data.lfp_session(amygdala_channel,:).avg_spectrogram_FA{1};
end

ftr_files = ftr_files2;

for f = 1:length(ftr_files)
    data = load(ftr_files{f});
    s1_hit(:,:,f+length(ftr_files1)) = data.lfp_session(s1_channel,:).avg_spectrogram_Hit{1};
    s1_miss(:,:,f+length(ftr_files1)) = data.lfp_session(s1_channel,:).avg_spectrogram_Miss{1};
    s1_cr(:,:,f+length(ftr_files1)) = data.lfp_session(s1_channel,:).avg_spectrogram_CR{1};
    s1_fa(:,:,f+length(ftr_files1)) = data.lfp_session(s1_channel,:).avg_spectrogram_FA{1};

    striatum_hit(:,:,f+length(ftr_files1)) = data.lfp_session(striatum_channel,:).avg_spectrogram_Hit{1};
    striatum_miss(:,:,f+length(ftr_files1)) = data.lfp_session(striatum_channel,:).avg_spectrogram_Miss{1};
    striatum_cr(:,:,f+length(ftr_files1)) = data.lfp_session(striatum_channel,:).avg_spectrogram_CR{1};
    striatum_fa(:,:,f+length(ftr_files1)) = data.lfp_session(striatum_channel,:).avg_spectrogram_FA{1};

    amygdala_hit(:,:,f+length(ftr_files1)) = data.lfp_session(amygdala_channel,:).avg_spectrogram_Hit{1};
    amygdala_miss(:,:,f+length(ftr_files1)) = data.lfp_session(amygdala_channel,:).avg_spectrogram_Miss{1};
    amygdala_cr(:,:,f+length(ftr_files1)) = data.lfp_session(amygdala_channel,:).avg_spectrogram_CR{1};
    amygdala_fa(:,:,f+length(ftr_files1)) = data.lfp_session(amygdala_channel,:).avg_spectrogram_FA{1};
end

t = linspace(-3,5,size(s1_hit,2));
f = linspace(0,250,size(s1_hit,1));

% s1_hit(:,:,11:12) = [];
% s1_miss(:,:,11:12) = [];
% s1_cr(:,:,11:12) = [];
% s1_fa(:,:,11:12) = [];
s1_hit(:,80:85,11) = nan(257,6);
striatum_hit(:,80:85,11) = nan(257,6);
amygdala_hit(:,80:85,11) = nan(257,6);
% s1_miss(:,80:85,11) = nan(257,6);
% s1_cr(:,80:85,11) = nan(257,6);
% s1_fa(:,80:85,11) = nan(257,6);
s1_hit(:,80:85,12) = nan(257,6);
striatum_hit(:,80:85,12) = nan(257,6);
amygdala_hit(:,80:85,12) = nan(257,6);
% s1_miss(:,80:85,12) = nan(257,6);
% s1_cr(:,80:85,12) = nan(257,6);
% s1_fa(:,80:85,12) = nan(257,6);

for i = 1:size(s1_hit,1)
    s1_hit(i,:,11) = fillmissing(s1_hit(i,:,11), 'spline', 'SamplePoints', t);
    striatum_hit(i,:,11) = fillmissing(s1_hit(i,:,11), 'spline', 'SamplePoints', t);
    amygdala_hit(i,:,11) = fillmissing(s1_hit(i,:,11), 'spline', 'SamplePoints', t);
    % s1_miss(i,:,11) = fillmissing(s1_miss(i,:,11), 'spline', 'SamplePoints', t);
    % s1_cr(i,:,11) = fillmissing(s1_cr(i,:,11), 'spline', 'SamplePoints', t);
    % s1_fa(i,:,11) = fillmissing(s1_fa(i,:,11), 'spline', 'SamplePoints', t);
    s1_hit(i,:,12) = fillmissing(s1_hit(i,:,11), 'spline', 'SamplePoints', t);
    striatum_hit(i,:,12) = fillmissing(s1_hit(i,:,11), 'spline', 'SamplePoints', t);
    amygdala_hit(i,:,12) = fillmissing(s1_hit(i,:,11), 'spline', 'SamplePoints', t);
    % s1_miss(i,:,12) = fillmissing(s1_miss(i,:,11), 'spline', 'SamplePoints', t);
    % s1_cr(i,:,12) = fillmissing(s1_cr(i,:,11), 'spline', 'SamplePoints', t);
    % s1_fa(i,:,12) = fillmissing(s1_fa(i,:,11), 'spline', 'SamplePoints', t);
end

% for i = 1:size(s1_hit,3)
%     s1_hit(:,:,i) = s1_hit(:,:,i) ./ max(max(s1_hit(:,:,3)));
% end
% for i = 1:size(s1_miss,3)
%     s1_miss(:,:,i) = s1_miss(:,:,i) ./ max(max(s1_miss(:,:,3)));
% end
% for i = 1:size(s1_cr,3)
%     s1_cr(:,:,i) = s1_cr(:,:,i) ./ max(max(s1_cr(:,:,3)));
% end
% for i = 1:size(s1_fa,3)
%     s1_fa(:,:,i) = s1_fa(:,:,i) ./ max(max(s1_fa(:,:,3)));
% end

% figure(); subplot(1,4,1); imagesc(t, f, nanmean(20*log10(s1_hit),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);
% subplot(1,4,2); imagesc(t, f, nanmean(20*log10(s1_miss),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);
% subplot(1,4,3); imagesc(t, f, nanmean(20*log10(s1_cr),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);
% subplot(1,4,4); imagesc(t, f, nanmean(20*log10(s1_fa),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);

% figure(); subplot(1,4,1); imagesc(t, f, nanmean(20*log10(striatum_hit),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);
% subplot(1,4,2); imagesc(t, f, nanmean(20*log10(striatum_miss),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);
% subplot(1,4,3); imagesc(t, f, nanmean(20*log10(striatum_cr),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);
% subplot(1,4,4); imagesc(t, f, nanmean(20*log10(striatum_fa),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);

% figure(); subplot(1,4,1); imagesc(t, f, nanmean(20*log10(amygdala_hit),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);
% subplot(1,4,2); imagesc(t, f, nanmean(20*log10(amygdala_miss),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);
% subplot(1,4,3); imagesc(t, f, nanmean(20*log10(amygdala_cr),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);
% subplot(1,4,4); imagesc(t, f, nanmean(20*log10(amygdala_fa),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);

%% pfc 
ftr_files1 = {strcat(ftr_path, 'LFP/date--2024-09-07_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-09-06_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-09-05_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-09-04_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-09-03_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-09-02_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat')};
ftr_files2 = {strcat(ftr_path, 'LFP/date--2024-12-20_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-19_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-18_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-17_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-16_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g1.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-15_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat')};

pfc_hit = nan(257,156, length(ftr_files1)+length(ftr_files2));
pfc_miss = nan(257,156, length(ftr_files1)+length(ftr_files2));
pfc_cr = nan(257,156, length(ftr_files1)+length(ftr_files2));
pfc_fa = nan(257,156, length(ftr_files1)+length(ftr_files2));

pfc_channel = 300;

ftr_files = ftr_files1;
for f = 1:length(ftr_files)
    data = load(ftr_files{f});
    pfc_hit(:,:,f) = data.lfp_session(pfc_channel,:).avg_spectrogram_Hit{1};
    pfc_miss(:,:,f) = data.lfp_session(pfc_channel,:).avg_spectrogram_Miss{1};
    pfc_cr(:,:,f) = data.lfp_session(pfc_channel,:).avg_spectrogram_CR{1};
    pfc_fa(:,:,f) = data.lfp_session(pfc_channel,:).avg_spectrogram_FA{1};
end

pfc_channel = 180;
ftr_files = ftr_files2;

for f = 1:length(ftr_files)
    data = load(ftr_files{f});
    pfc_hit(:,:,f+length(ftr_files1)) = data.lfp_session(pfc_channel,:).avg_spectrogram_Hit{1};
    try
        pfc_miss(:,:,f+length(ftr_files1)) = data.lfp_session(pfc_channel,:).avg_spectrogram_Miss{1};
    end
    pfc_cr(:,:,f+length(ftr_files1)) = data.lfp_session(pfc_channel,:).avg_spectrogram_CR{1};
    pfc_fa(:,:,f+length(ftr_files1)) = data.lfp_session(pfc_channel,:).avg_spectrogram_FA{1};
end

t = linspace(-3,5,size(pfc_hit,2));
f = linspace(0,250,size(pfc_hit,1));

% exlc_inds = [1:3,8,10,11,12];
pfc_hit(:,80:85,1) = nan(257,6);
% pfc_miss(:,80:85,1) = nan(257,6);
% pfc_cr(:,80:85,1) = nan(257,6);
% pfc_fa(:,80:85,1) = nan(257,6);
pfc_hit(:,80:85,2) = nan(257,6);
% pfc_miss(:,80:85,2) = nan(257,6);
% pfc_cr(:,80:85,2) = nan(257,6);
% pfc_fa(:,80:85,2) = nan(257,6);
pfc_hit(:,80:85,3) = nan(257,6);
% pfc_miss(:,80:85,3) = nan(257,6);
% pfc_cr(:,80:85,3) = nan(257,6);
% pfc_fa(:,80:85,3) = nan(257,6);
pfc_hit(:,80:85,11) = nan(257,6);
% pfc_miss(:,80:85,11) = nan(257,6);
% pfc_cr(:,80:85,11) = nan(257,6);
% pfc_fa(:,80:85,11) = nan(257,6);
pfc_hit(:,80:85,12) = nan(257,6);
% pfc_miss(:,80:85,12) = nan(257,6);
% pfc_cr(:,80:85,12) = nan(257,6);
% pfc_fa(:,80:85,12) = nan(257,6);

for i = 1:size(pfc_hit,1)
    pfc_hit(i,:,1) = fillmissing(pfc_hit(i,:,1), 'spline', 'SamplePoints', t);
    % pfc_miss(i,:,1) = fillmissing(pfc_miss(i,:,1), 'spline', 'SamplePoints', t);
    % pfc_cr(i,:,1) = fillmissing(pfc_cr(i,:,1), 'spline', 'SamplePoints', t);
    % pfc_fa(i,:,1) = fillmissing(pfc_fa(i,:,1), 'spline', 'SamplePoints', t);
    pfc_hit(i,:,2) = fillmissing(pfc_hit(i,:,2), 'spline', 'SamplePoints', t);
    % pfc_miss(i,:,2) = fillmissing(pfc_miss(i,:,2), 'spline', 'SamplePoints', t);
    % pfc_cr(i,:,2) = fillmissing(pfc_cr(i,:,2), 'spline', 'SamplePoints', t);
    % pfc_fa(i,:,2) = fillmissing(pfc_fa(i,:,2), 'spline', 'SamplePoints', t);
    pfc_hit(i,:,3) = fillmissing(pfc_hit(i,:,3), 'spline', 'SamplePoints', t);
    % pfc_miss(i,:,3) = fillmissing(pfc_miss(i,:,3), 'spline', 'SamplePoints', t);
    % pfc_cr(i,:,3) = fillmissing(pfc_cr(i,:,3), 'spline', 'SamplePoints', t);
    % pfc_fa(i,:,3) = fillmissing(pfc_fa(i,:,3), 'spline', 'SamplePoints', t);
    pfc_hit(i,:,11) = fillmissing(pfc_hit(i,:,11), 'spline', 'SamplePoints', t);
    % pfc_miss(i,:,11) = fillmissing(pfc_miss(i,:,11), 'spline', 'SamplePoints', t);
    % pfc_cr(i,:,11) = fillmissing(pfc_cr(i,:,11), 'spline', 'SamplePoints', t);
    % pfc_fa(i,:,11) = fillmissing(pfc_fa(i,:,11), 'spline', 'SamplePoints', t);
    pfc_hit(i,:,12) = fillmissing(pfc_hit(i,:,12), 'spline', 'SamplePoints', t);
    % pfc_miss(i,:,12) = fillmissing(pfc_miss(i,:,12), 'spline', 'SamplePoints', t);
    % pfc_cr(i,:,12) = fillmissing(pfc_cr(i,:,12), 'spline', 'SamplePoints', t);
    % pfc_fa(i,:,12) = fillmissing(pfc_fa(i,:,12), 'spline', 'SamplePoints', t);
end

exlc_inds = [8,10];
pfc_hit(:,:,exlc_inds) = [];
pfc_miss(:,:,exlc_inds) = [];
pfc_cr(:,:,exlc_inds) = [];
pfc_fa(:,:,exlc_inds) = [];

fig = figure('Position', [1220 899 1420 819]);
tl = tiledlayout(4,4);
axs(1) = nexttile; imagesc(t, f, nanmean(20*log10(s1_hit),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]); ylabel('S1', 'FontSize', 18); title('Hit', 'FontWeight', 'normal', 'FontSize', 18)
yticks([0,100])
xticks([])
ax = gca;
ax.YAxis.FontSize = 16;
axs(2) = nexttile; imagesc(t, f, nanmean(20*log10(s1_miss),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]); title('Miss', 'FontSize', 18, 'FontWeight', 'normal')
xticks([])
yticks([])
axs(3) = nexttile; imagesc(t, f, nanmean(20*log10(s1_cr),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]); title('Correct Rejection', 'FontSize', 18, 'FontWeight', 'normal')
xticks([])
yticks([])
axs(4) = nexttile; imagesc(t, f, nanmean(20*log10(s1_fa),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]); title('False Alarm', 'FontSize', 18, 'FontWeight', 'normal')
xticks([])
yticks([])

axs(5) = nexttile; imagesc(t, f, nanmean(20*log10(pfc_hit),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-210,-190]); ylabel('PFC', 'FontSize', 18)
yticks([0,100])
xticks([])
ax = gca;
ax.YAxis.FontSize = 16;
axs(6) = nexttile; imagesc(t, f, nanmean(20*log10(pfc_miss),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-210,-190]);
yticks([])
xticks([])
axs(7) = nexttile; imagesc(t, f, nanmean(20*log10(pfc_cr),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-210,-190]);
yticks([])
xticks([])
axs(8) = nexttile; imagesc(t, f, nanmean(20*log10(pfc_fa),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-210,-190]);
yticks([])
xticks([])

axs(9) = nexttile; imagesc(t, f, nanmean(20*log10(striatum_hit),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]); ylabel('Striatum', 'FontSize', 18)
yticks([0,100])
xticks([])
ax = gca;
ax.YAxis.FontSize = 16;
axs(10) = nexttile; imagesc(t, f, nanmean(20*log10(striatum_miss),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);
xticks([])
yticks([])
axs(11) = nexttile; imagesc(t, f, nanmean(20*log10(striatum_cr),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);
xticks([])
yticks([])
axs(12) = nexttile; imagesc(t, f, nanmean(20*log10(striatum_fa),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);
xticks([])
yticks([])

axs(13) = nexttile; imagesc(t, f, nanmean(20*log10(amygdala_hit),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]); ylabel('Amygdala', 'FontSize', 18)
yticks([0,100])
ax = gca;
ax.YAxis.FontSize = 16;
ax.XAxis.FontSize = 16;
axs(14) = nexttile; imagesc(t, f, nanmean(20*log10(amygdala_miss),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);
yticks([])
ax = gca;
ax.YAxis.FontSize = 16;
ax.XAxis.FontSize = 16;
axs(15) = nexttile; imagesc(t, f, nanmean(20*log10(amygdala_cr),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);
yticks([])
ax = gca;
ax.YAxis.FontSize = 16;
ax.XAxis.FontSize = 16;
axs(16) = nexttile; imagesc(t, f, nanmean(20*log10(amygdala_fa),3)); set(gca, 'YDir', 'normal'); ylim([0,100]); clim([-215,-184]);
yticks([])
ax = gca;
ax.YAxis.FontSize = 16;
ax.XAxis.FontSize = 16;
ylabel(tl, 'Frequency (Hz)', 'FontSize', 18)
xlabel(tl, 'Time (s)', 'FontSize', 18)
colorbar()

saveas(fig, '../Figures/specGrmByOutcome.svg')
saveas(fig, '../Figures/specGrmByOutcome.fig')


% if out_path
%     saveas(ap1_fig, '../Figures/ap1.fig')
%     saveas(ap2_fig, '../Figures/ap2.fig')
%     saveas(pfig1, '../Figures/p1.fig')
%     saveas(pfig2, '../Figures/p2.fig')
%     saveas(pfig3, '../Figures/p3.fig')
%     saveas(ap1_fig, '../Figures/ap1.svg')
%     saveas(ap2_fig, '../Figures/ap2.svg')
%     saveas(pfig1, '../Figures/p1.svg')
%     saveas(pfig2, '../Figures/p2.svg')
%     saveas(pfig3, '../Figures/p3.svg')
% end

% diary off