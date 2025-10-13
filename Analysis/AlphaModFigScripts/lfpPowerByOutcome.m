delete Stats/lfp_analysis.txt
diary Stats/lfp_analysis.txt
init_paths;
%% s1 
ftr_files = {strcat(ftr_path, 'LFP/date--2024-03-04_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-03-01_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-29_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-27_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-22_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g1.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-22_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-21_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-20_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-15_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat')};

s1_channel = 285;
striatum_channel = 138;
amygdala_channel = 160;

for f = 1:length(ftr_files)
    data = load(ftr_files{f});
    if f == 1
        s1_hit = data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit{1};
        s1_miss = data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Miss{1};
        s1_cr = data.lfp_session(s1_channel,:).right_trigger_baseline_spectra_CR{1};
        s1_fa = data.lfp_session(s1_channel,:).right_trigger_baseline_spectra_FA{1};
    else
        s1_hit = [s1_hit; data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit{1}];
        s1_miss = [s1_miss; data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Miss{1}];
        s1_cr = [s1_cr; data.lfp_session(s1_channel,:).right_trigger_baseline_spectra_CR{1}];
        s1_fa = [s1_fa; data.lfp_session(s1_channel,:).right_trigger_baseline_spectra_FA{1}];
    end
    if f == 1
        striatum_hit = data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Hit{1};
        striatum_miss = data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Miss{1};
        striatum_cr = data.lfp_session(striatum_channel,:).right_trigger_baseline_spectra_CR{1};
        striatum_fa = data.lfp_session(striatum_channel,:).right_trigger_baseline_spectra_FA{1};
    else
        striatum_hit = [striatum_hit; data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Hit{1}];
        striatum_miss = [striatum_miss; data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Miss{1}];
        striatum_cr = [striatum_cr; data.lfp_session(striatum_channel,:).right_trigger_baseline_spectra_CR{1}];
        striatum_fa = [striatum_fa; data.lfp_session(striatum_channel,:).right_trigger_baseline_spectra_FA{1}];
    end

    if f == 1
        amygdala_hit = data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Hit{1};
        amygdala_miss = data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Miss{1};
        amygdala_cr = data.lfp_session(amygdala_channel,:).right_trigger_baseline_spectra_CR{1};
        amygdala_fa = data.lfp_session(amygdala_channel,:).right_trigger_baseline_spectra_FA{1};
    else
        amygdala_hit = [amygdala_hit; data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Hit{1}];
        amygdala_miss = [amygdala_miss; data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Miss{1}];
        amygdala_cr = [amygdala_cr; data.lfp_session(amygdala_channel,:).right_trigger_baseline_spectra_CR{1}];
        amygdala_fa = [amygdala_fa; data.lfp_session(amygdala_channel,:).right_trigger_baseline_spectra_FA{1}];
    end
end

ftr_files = {strcat(ftr_path, 'LFP/date--2024-07-17_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
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

for f = 1:length(ftr_files)
    data = load(ftr_files{f});
    s1_hit = [s1_hit; data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit{1}];
    s1_miss = [s1_miss; data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Miss{1}];
    s1_cr = [s1_cr; data.lfp_session(s1_channel,:).right_trigger_baseline_spectra_CR{1}];
    s1_fa = [s1_fa; data.lfp_session(s1_channel,:).right_trigger_baseline_spectra_FA{1}];
    striatum_hit = [striatum_hit; data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Hit{1}];
    striatum_miss = [striatum_miss; data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Miss{1}];
    striatum_cr = [striatum_cr; data.lfp_session(striatum_channel,:).right_trigger_baseline_spectra_CR{1}];
    striatum_fa = [striatum_fa; data.lfp_session(striatum_channel,:).right_trigger_baseline_spectra_FA{1}];
    amygdala_hit = [amygdala_hit; data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Hit{1}];
    amygdala_miss = [amygdala_miss; data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Miss{1}];
    amygdala_cr = [amygdala_cr; data.lfp_session(amygdala_channel,:).right_trigger_baseline_spectra_CR{1}];
    amygdala_fa = [amygdala_fa; data.lfp_session(amygdala_channel,:).right_trigger_baseline_spectra_FA{1}];
end

%% pfc 
ftr_files = {strcat(ftr_path, 'LFP/date--2024-09-07_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-09-06_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-09-05_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-09-04_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-09-03_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-09-02_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat')};

pfc_channel = 300;

for f = 1:length(ftr_files)
    data = load(ftr_files{f});
    if f == 1
        pfc_hit = data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Hit{1};
        pfc_miss = data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Miss{1};
        pfc_cr = data.lfp_session(pfc_channel,:).right_trigger_baseline_spectra_CR{1};
        pfc_fa = data.lfp_session(pfc_channel,:).right_trigger_baseline_spectra_FA{1};
    else
        pfc_hit = [pfc_hit; data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Hit{1}];
        pfc_miss = [pfc_miss; data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Miss{1}];
        pfc_cr = [pfc_cr; data.lfp_session(pfc_channel,:).right_trigger_baseline_spectra_CR{1}];
        pfc_fa = [pfc_fa; data.lfp_session(pfc_channel,:).right_trigger_baseline_spectra_FA{1}];
    end
end

% ftr_files = {strcat(ftr_path, 'LFP/date--2024-12-20_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
%     strcat(ftr_path, 'LFP/date--2024-12-19_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
%     strcat(ftr_path, 'LFP/date--2024-12-18_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
%     strcat(ftr_path, 'LFP/date--2024-12-17_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
%     strcat(ftr_path, 'LFP/date--2024-12-16_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g1.mat'), ...
%     strcat(ftr_path, 'LFP/date--2024-12-16_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
%     strcat(ftr_path, 'LFP/date--2024-12-15_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat')};
ftr_files = {strcat(ftr_path, 'LFP/date--2024-12-20_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-19_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-18_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-17_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-16_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g1.mat'), ...
    strcat(ftr_path, 'LFP/date--2024-12-15_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat')};
% ftr_files = {strcat(ftr_path, 'LFP/date--2024-12-20_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
%     strcat(ftr_path, 'LFP/date--2024-12-18_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat'), ...
%     strcat(ftr_path, 'LFP/date--2024-12-16_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g1.mat'), ...
%     strcat(ftr_path, 'LFP/date--2024-12-15_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat')};

pfc_channel = 180;

for f = 1:length(ftr_files)
    data = load(ftr_files{f});
    pfc_hit = [pfc_hit; data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Hit{1}];
    try
        pfc_miss = [pfc_miss; data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Miss{1}];
    end
    pfc_cr = [pfc_cr; data.lfp_session(pfc_channel,:).right_trigger_baseline_spectra_CR{1}];
    pfc_fa = [pfc_fa; data.lfp_session(pfc_channel,:).right_trigger_baseline_spectra_FA{1}];
end

fig = figure('Position', [1220 881 1314 957]); 
tl = tiledlayout(4,4);
axs(1) = nexttile;
semshade(log10(s1_hit), 0.3, 'k', 'k', data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit_f{1}); 
xlim([0,30])
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
xticklabels({})
title('Hit', 'FontSize', 14, 'FontWeight', 'normal')
ylabel('S1', 'FontSize', 14)
axs(2) = nexttile;
semshade(log10(s1_miss), 0.3, 'k', 'k', data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit_f{1});
xlim([0,30])
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
xticklabels({})
yticklabels({})
title('Miss', 'FontSize', 14, 'FontWeight', 'normal')
axs(3) = nexttile;
semshade(log10(s1_cr), 0.3, 'k', 'k', data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit_f{1});  
xlim([0,30])
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
xticklabels({})
yticklabels({})
title('Correct Rejection', 'FontSize', 14, 'FontWeight', 'normal')
axs(4) = nexttile;
semshade(log10(s1_fa), 0.3, 'k', 'k', data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit_f{1});
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
xlim([0,30])
xticklabels({})
yticklabels({})
title('False Alarm', 'FontSize', 14, 'FontWeight', 'normal')

axs(5) = nexttile;
semshade(log10(pfc_hit), 0.3, 'k', 'k', data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Hit_f{1}); 
xlim([0,30])
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
xticklabels({})
ylabel('PFC', 'FontSize', 14)
axs(6) = nexttile;
semshade(log10(pfc_miss), 0.3, 'k', 'k', data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Hit_f{1});
xlim([0,30])
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
xticklabels({})
yticklabels({})
axs(7) = nexttile;
semshade(log10(pfc_cr), 0.3, 'k', 'k', data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Hit_f{1});  
xlim([0,30])
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
xticklabels({})
yticklabels({})
axs(8) = nexttile;
semshade(log10(pfc_fa), 0.3, 'k', 'k', data.lfp_session(pfc_channel,:).left_trigger_baseline_spectra_Hit_f{1});
xlim([0,30])
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
xticklabels({})
yticklabels({})

axs(9) = nexttile;
semshade(log10(striatum_hit), 0.3, 'k', 'k', data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Hit_f{1}); 
xlim([0,30])
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
xticklabels({})
ylabel('Striatum', 'FontSize', 14)
axs(10) = nexttile;
semshade(log10(striatum_miss), 0.3, 'k', 'k', data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Hit_f{1});
xlim([0,30])
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
xticklabels({})
yticklabels({})
axs(11) = nexttile;
semshade(log10(striatum_cr), 0.3, 'k', 'k', data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Hit_f{1});  
xlim([0,30])
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
xticklabels({})
yticklabels({})
axs(12) = nexttile;
semshade(log10(striatum_fa), 0.3, 'k', 'k', data.lfp_session(striatum_channel,:).left_trigger_baseline_spectra_Hit_f{1});
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
xlim([0,30])
xticklabels({})
yticklabels({})

axs(13) = nexttile;
semshade(log10(amygdala_hit), 0.3, 'k', 'k', data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Hit_f{1}); 
xlim([0,30])
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
ylabel('Amygdala', 'FontSize', 14)
axs(14) = nexttile;
semshade(log10(amygdala_miss), 0.3, 'k', 'k', data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Hit_f{1});
xlim([0,30])
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
yticklabels({})
axs(15) = nexttile;
semshade(log10(amygdala_cr), 0.3, 'k', 'k', data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Hit_f{1});  
xlim([0,30])
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
yticklabels({})
axs(16) = nexttile;
semshade(log10(amygdala_fa), 0.3, 'k', 'k', data.lfp_session(amygdala_channel,:).left_trigger_baseline_spectra_Hit_f{1});
ylim([-11.5,-8.5])
yticks([-11.5,-8.5])
xlim([0,30])
yticklabels({})
xlabel(tl, 'Frequency (Hz)', 'FontSize', 14)
ylabel(tl, 'log LFP power', 'FontSize', 14)

out_path = true; 
if out_path
    saveas(fig, '../Figures/lfp_power_by_outcome.fig')
    % saveas(fig, '../Figures/lfp_power_by_outcome.svg')
    print(gcf,'-vector','-dsvg','../Figures/lfp_power_by_outcome.svg')
end

args = struct();
args.peakWidth_min = 2;
args.peakWidth_max = 8;  
args.numPeaks_max = 8;
args.peakHeight_min = 0.;     
args.peakThreshold = 2;
args.chanRange_start = 1;
args.chanRange_end = 384;

%% s1 
f = data.lfp_session(s1_channel,:).left_trigger_baseline_spectra_Hit_f{1};
mat = s1_hit;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_hit = spectralParameterizationV0(DF_chg, args);
pparams_hit = [];
for i = 1:size(DF_specs_hit,1)
    if size(DF_specs_hit(i,:).periodic_params{1},1) > 1
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}(end,:)];
    else
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}];
    end
end

mat = s1_miss;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_miss = spectralParameterizationV0(DF_chg, args);
pparams_miss = [];
for i = 1:size(DF_specs_miss,1)
    if size(DF_specs_miss(i,:).periodic_params{1},1) > 1
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}(end,:)];
    else
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}];
    end
end

mat = s1_cr;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_cr = spectralParameterizationV0(DF_chg, args);
pparams_cr = [];
for i = 1:size(DF_specs_cr,1)
    if size(DF_specs_cr(i,:).periodic_params{1},1) > 1
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}(end,:)];
    else
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}];
    end
end

mat = s1_fa;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_fa = spectralParameterizationV0(DF_chg, args);
pparams_fa = [];
for i = 1:size(DF_specs_fa,1)
    if size(DF_specs_fa(i,:).periodic_params{1},1) > 1
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}(end,:)];
    else
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}];
    end
end

pparams_s1= pparams_hit;
pparams_s1_hit= pparams_hit;
pparams_s1_miss= pparams_miss;
pparams_s1_cr= pparams_cr;
pparams_s1_fa= pparams_fa;
DF_specs_s1_hit = DF_specs_hit;
DF_specs_s1_miss = DF_specs_miss;
DF_specs_s1_cr = DF_specs_cr;
DF_specs_s1_fa = DF_specs_fa;
DF_specs_s1 = DF_specs_hit;

period_fig = figure('Position', [1475 745 1316 978]);
tl = tiledlayout(4,5);
axs(1,1) = nexttile;
hold on
avg = [mean(DF_specs_hit.aperiodic_params(:,1)), ...
    mean(DF_specs_miss.aperiodic_params(:,1)), ...
    mean(DF_specs_cr.aperiodic_params(:,1)), ...
    mean(DF_specs_fa.aperiodic_params(:,1))];
err = [std(DF_specs_hit.aperiodic_params(:,1)) / sqrt(size(DF_specs_hit,1)), ...
    std(DF_specs_miss.aperiodic_params(:,1)) / sqrt(size(DF_specs_miss,1)), ...
    std(DF_specs_cr.aperiodic_params(:,1)) / sqrt(size(DF_specs_cr,1)), ...
    std(DF_specs_fa.aperiodic_params(:,1)) / sqrt(size(DF_specs_fa,1))];
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_hit.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_miss.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_cr.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_fa.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xlim([0.5,4.5])
xticks([])
%ylim([-10,-8])
%yticks([-10,-8])

axs(1,2) = nexttile;
avg = [mean(DF_specs_hit.aperiodic_params(:,2)), ...
    mean(DF_specs_miss.aperiodic_params(:,2)), ...
    mean(DF_specs_cr.aperiodic_params(:,2)), ...
    mean(DF_specs_fa.aperiodic_params(:,2))];
err = [std(DF_specs_hit.aperiodic_params(:,2)) / sqrt(size(DF_specs_hit,1)), ...
    std(DF_specs_miss.aperiodic_params(:,2)) / sqrt(size(DF_specs_miss,1)), ...
    std(DF_specs_cr.aperiodic_params(:,2)) / sqrt(size(DF_specs_cr,1)), ...
    std(DF_specs_fa.aperiodic_params(:,2)) / sqrt(size(DF_specs_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_hit.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_miss.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_cr.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_fa.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xlim([0.5,4.5])
xticks([])
%ylim([0,2])
%yticks([0,2])

axs(1,3) = nexttile;
avg = [mean(pparams_hit(:,1)), ...
    mean(pparams_miss(:,1)), ...
    mean(pparams_cr(:,1)), ...
    mean(pparams_fa(:,1))];
err = [std(pparams_hit(:,1)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,1)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,1)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,1)) / sqrt(size(pparams_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_hit(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_miss(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_cr(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_fa(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xticks([1,2,3,4])
xticklabels({'','','',''})
%ylim([0,20])
%yticks([0,20])
xlim([0.5,4.5])
% ylabel('Peak Frequency (Hz)')

axs(1,4) = nexttile;
avg = [mean(pparams_hit(:,2)), ...
    mean(pparams_miss(:,2)), ...
    mean(pparams_cr(:,2)), ...
    mean(pparams_fa(:,2))];
err = [std(pparams_hit(:,2)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,2)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,2)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,2)) / sqrt(size(pparams_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_hit(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_miss(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_cr(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_fa(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xticks([1,2,3,4])
xticklabels({'','','',''})
%ylim([0,0.8])
%yticks([0,0.8])
xlim([0.5,4.5])
% ylabel('Relative Power (a.u.)')

axs(1,5) = nexttile;
avg = [mean(pparams_hit(:,3)), ...
    mean(pparams_miss(:,3)), ...
    mean(pparams_cr(:,3)), ...
    mean(pparams_fa(:,3))];
err = [std(pparams_hit(:,3)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,3)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,3)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,3)) / sqrt(size(pparams_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_hit(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_miss(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_cr(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_fa(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xticks([1,2,3,4])
xticklabels({'','','',''})
%ylim([0,8])
%yticks([0,8])
xlim([0.5,4.5])
% ylabel('Bandwidth (Hz)')

mat = pfc_hit;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_hit = spectralParameterizationV0(DF_chg, args);
pparams_hit = [];
for i = 1:size(DF_specs_hit,1)
    if size(DF_specs_hit(i,:).periodic_params{1},1) > 1
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}(end,:)];
    else
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}];
    end
end

mat = pfc_miss;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_miss = spectralParameterizationV0(DF_chg, args);
pparams_miss = [];
for i = 1:size(DF_specs_miss,1)
    if size(DF_specs_miss(i,:).periodic_params{1},1) > 1
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}(end,:)];
    else
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}];
    end
end

mat = pfc_cr;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_cr = spectralParameterizationV0(DF_chg, args);
pparams_cr = [];
for i = 1:size(DF_specs_cr,1)
    if size(DF_specs_cr(i,:).periodic_params{1},1) > 1
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}(end,:)];
    else
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}];
    end
end

mat = pfc_fa;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_fa = spectralParameterizationV0(DF_chg, args);
pparams_fa = [];
for i = 1:size(DF_specs_fa,1)
    if size(DF_specs_fa(i,:).periodic_params{1},1) > 1
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}(end,:)];
    else
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}];
    end
end

axs(2,1) = nexttile;
avg = [mean(DF_specs_hit.aperiodic_params(:,1)), ...
    mean(DF_specs_miss.aperiodic_params(:,1)), ...
    mean(DF_specs_cr.aperiodic_params(:,1)), ...
    mean(DF_specs_fa.aperiodic_params(:,1))];
err = [std(DF_specs_hit.aperiodic_params(:,1)) / sqrt(size(DF_specs_hit,1)), ...
    std(DF_specs_miss.aperiodic_params(:,1)) / sqrt(size(DF_specs_miss,1)), ...
    std(DF_specs_cr.aperiodic_params(:,1)) / sqrt(size(DF_specs_cr,1)), ...
    std(DF_specs_fa.aperiodic_params(:,1)) / sqrt(size(DF_specs_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_hit.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_miss.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_cr.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_fa.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xlim([0.5,4.5])
xticks([])
%ylim([-10,-8])
%yticks([-10,-8])

axs(2,2) = nexttile;
avg = [mean(DF_specs_hit.aperiodic_params(:,2)), ...
    mean(DF_specs_miss.aperiodic_params(:,2)), ...
    mean(DF_specs_cr.aperiodic_params(:,2)), ...
    mean(DF_specs_fa.aperiodic_params(:,2))];
err = [std(DF_specs_hit.aperiodic_params(:,2)) / sqrt(size(DF_specs_hit,1)), ...
    std(DF_specs_miss.aperiodic_params(:,2)) / sqrt(size(DF_specs_miss,1)), ...
    std(DF_specs_cr.aperiodic_params(:,2)) / sqrt(size(DF_specs_cr,1)), ...
    std(DF_specs_fa.aperiodic_params(:,2)) / sqrt(size(DF_specs_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_hit.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_miss.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_cr.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_fa.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xlim([0.5,4.5])
xticks([])
%ylim([0,2])
%yticks([0,2])

axs(2,3) = nexttile;
avg = [mean(pparams_hit(:,1)), ...
    mean(pparams_miss(:,1)), ...
    mean(pparams_cr(:,1)), ...
    mean(pparams_fa(:,1))];
err = [std(pparams_hit(:,1)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,1)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,1)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,1)) / sqrt(size(pparams_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_hit(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_miss(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_cr(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_fa(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xticks([1,2,3,4])
xticklabels({'','','',''})
%ylim([0,20])
%yticks([0,20])
xlim([0.5,4.5])
% ylabel('Peak Frequency (Hz)')

axs(2,4) = nexttile;
avg = [mean(pparams_hit(:,2)), ...
    mean(pparams_miss(:,2)), ...
    mean(pparams_cr(:,2)), ...
    mean(pparams_fa(:,2))];
err = [std(pparams_hit(:,2)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,2)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,2)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,2)) / sqrt(size(pparams_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_hit(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_miss(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_cr(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_fa(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xticks([1,2,3,4])
xticklabels({'','','',''})
%ylim([0,0.8])
%yticks([0,0.8])
xlim([0.5,4.5])
% ylabel('Relative Power (a.u.)')


axs(2,5) = nexttile;
avg = [mean(pparams_hit(:,3)), ...
    mean(pparams_miss(:,3)), ...
    mean(pparams_cr(:,3)), ...
    mean(pparams_fa(:,3))];
err = [std(pparams_hit(:,3)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,3)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,3)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,3)) / sqrt(size(pparams_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_hit(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_miss(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_cr(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_fa(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xticks([1,2,3,4])
xticklabels({'','','',''})
%ylim([0,8])
%yticks([0,8])
xlim([0.5,4.5])
% ylabel('Bandwidth (Hz)')

pparams_pfc= pparams_hit;
pparams_pfc_hit= pparams_hit;
pparams_pfc_miss= pparams_miss;
pparams_pfc_cr= pparams_cr;
pparams_pfc_fa= pparams_fa;
DF_specs_pfc_hit = DF_specs_hit;
DF_specs_pfc_miss = DF_specs_miss;
DF_specs_pfc_cr = DF_specs_cr;
DF_specs_pfc_fa = DF_specs_fa;
DF_specs_pfc = DF_specs_hit;

mat = striatum_hit;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_hit = spectralParameterizationV0(DF_chg, args);
pparams_hit = [];
for i = 1:size(DF_specs_hit,1)
    if size(DF_specs_hit(i,:).periodic_params{1},1) > 1
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}(end,:)];
    else
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}];
    end
end

mat = striatum_miss;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_miss = spectralParameterizationV0(DF_chg, args);
pparams_miss = [];
for i = 1:size(DF_specs_miss,1)
    if size(DF_specs_miss(i,:).periodic_params{1},1) > 1
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}(end,:)];
    else
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}];
    end
end

mat = striatum_cr;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_cr = spectralParameterizationV0(DF_chg, args);
pparams_cr = [];
for i = 1:size(DF_specs_cr,1)
    if size(DF_specs_cr(i,:).periodic_params{1},1) > 1
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}(end,:)];
    else
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}];
    end
end

mat = striatum_fa;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_fa = spectralParameterizationV0(DF_chg, args);
pparams_fa = [];
for i = 1:size(DF_specs_fa,1)
    if size(DF_specs_fa(i,:).periodic_params{1},1) > 1
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}(end,:)];
    else
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}];
    end
end

axs(3,1) = nexttile;
avg = [mean(DF_specs_hit.aperiodic_params(:,1)), ...
    mean(DF_specs_miss.aperiodic_params(:,1)), ...
    mean(DF_specs_cr.aperiodic_params(:,1)), ...
    mean(DF_specs_fa.aperiodic_params(:,1))];
err = [std(DF_specs_hit.aperiodic_params(:,1)) / sqrt(size(DF_specs_hit,1)), ...
    std(DF_specs_miss.aperiodic_params(:,1)) / sqrt(size(DF_specs_miss,1)), ...
    std(DF_specs_cr.aperiodic_params(:,1)) / sqrt(size(DF_specs_cr,1)), ...
    std(DF_specs_fa.aperiodic_params(:,1)) / sqrt(size(DF_specs_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_hit.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_miss.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_cr.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_fa.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xlim([0.5,4.5])
xticks([])
%ylim([-10,-8])
%yticks([-10,-8])

axs(3,2) = nexttile;
avg = [mean(DF_specs_hit.aperiodic_params(:,2)), ...
    mean(DF_specs_miss.aperiodic_params(:,2)), ...
    mean(DF_specs_cr.aperiodic_params(:,2)), ...
    mean(DF_specs_fa.aperiodic_params(:,2))];
err = [std(DF_specs_hit.aperiodic_params(:,2)) / sqrt(size(DF_specs_hit,1)), ...
    std(DF_specs_miss.aperiodic_params(:,2)) / sqrt(size(DF_specs_miss,1)), ...
    std(DF_specs_cr.aperiodic_params(:,2)) / sqrt(size(DF_specs_cr,1)), ...
    std(DF_specs_fa.aperiodic_params(:,2)) / sqrt(size(DF_specs_fa,1))];
hold on 
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_hit.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_miss.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_cr.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_fa.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xlim([0.5,4.5])
xticks([])
%ylim([0,2])
%yticks([0,2])

axs(3,3) = nexttile;
avg = [mean(pparams_hit(:,1)), ...
    mean(pparams_miss(:,1)), ...
    mean(pparams_cr(:,1)), ...
    mean(pparams_fa(:,1))];
err = [std(pparams_hit(:,1)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,1)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,1)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,1)) / sqrt(size(pparams_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_hit(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_miss(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_cr(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_fa(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xticks([1,2,3,4])
xticklabels({'','','',''})
%ylim([0,20])
xlim([0.5,4.5])
%yticks([0,20])
% ylabel('Peak Frequency (Hz)')

axs(3,4) = nexttile;
avg = [mean(pparams_hit(:,2)), ...
    mean(pparams_miss(:,2)), ...
    mean(pparams_cr(:,2)), ...
    mean(pparams_fa(:,2))];
err = [std(pparams_hit(:,2)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,2)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,2)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,2)) / sqrt(size(pparams_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_hit(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_miss(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_cr(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_fa(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xticks([1,2,3,4])
xticklabels({'','','',''})
%ylim([0,0.8])
%yticks([0,0.8])
xlim([0.5,4.5])
% ylabel('Relative Power (a.u.)')

axs(3,5) = nexttile;
avg = [mean(pparams_hit(:,3)), ...
    mean(pparams_miss(:,3)), ...
    mean(pparams_cr(:,3)), ...
    mean(pparams_fa(:,3))];
err = [std(pparams_hit(:,3)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,3)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,3)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,3)) / sqrt(size(pparams_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_hit(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_miss(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_cr(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_fa(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xticks([1,2,3,4])
xticklabels({'','','',''})
%ylim([0,8])
%yticks([0,8])
xlim([0.5,4.5])
% ylabel('Bandwidth (Hz)')

pparams_bg= pparams_hit;
pparams_bg_hit= pparams_hit;
pparams_bg_miss= pparams_miss;
pparams_bg_cr= pparams_cr;
pparams_bg_fa= pparams_fa;
DF_specs_bg_hit = DF_specs_hit;
DF_specs_bg_miss = DF_specs_miss;
DF_specs_bg_cr = DF_specs_cr;
DF_specs_bg_fa = DF_specs_fa;
DF_specs_bg = DF_specs_hit;

mat = amygdala_hit;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_hit = spectralParameterizationV0(DF_chg, args);
pparams_hit = [];
for i = 1:size(DF_specs_hit,1)
    if size(DF_specs_hit(i,:).periodic_params{1},1) > 1
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}(end,:)];
    else
        pparams_hit = [pparams_hit; DF_specs_hit(i,:).periodic_params{1}];
    end
end

mat = amygdala_miss;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_miss = spectralParameterizationV0(DF_chg, args);
pparams_miss = [];
for i = 1:size(DF_specs_miss,1)
    if size(DF_specs_miss(i,:).periodic_params{1},1) > 1
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}(end,:)];
    else
        pparams_miss = [pparams_miss; DF_specs_miss(i,:).periodic_params{1}];
    end
end

mat = amygdala_cr;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_cr = spectralParameterizationV0(DF_chg, args);
pparams_cr = [];
for i = 1:size(DF_specs_cr,1)
    if size(DF_specs_cr(i,:).periodic_params{1},1) > 1
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}(end,:)];
    else
        pparams_cr = [pparams_cr; DF_specs_cr(i,:).periodic_params{1}];
    end
end

mat = amygdala_fa;
DF_chg = struct();
DF_chg.df = mat(:,f<30)';
F = 0:0.122:30;
DF_chg.ax.f = F;
DF_specs_fa = spectralParameterizationV0(DF_chg, args);
pparams_fa = [];
for i = 1:size(DF_specs_fa,1)
    if size(DF_specs_fa(i,:).periodic_params{1},1) > 1
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}(end,:)];
    else
        pparams_fa = [pparams_fa; DF_specs_fa(i,:).periodic_params{1}];
    end
end


axs(4,1) = nexttile;
avg = [mean(DF_specs_hit.aperiodic_params(:,1)), ...
    mean(DF_specs_miss.aperiodic_params(:,1)), ...
    mean(DF_specs_cr.aperiodic_params(:,1)), ...
    mean(DF_specs_fa.aperiodic_params(:,1))];
err = [std(DF_specs_hit.aperiodic_params(:,1)) / sqrt(size(DF_specs_hit,1)), ...
    std(DF_specs_miss.aperiodic_params(:,1)) / sqrt(size(DF_specs_miss,1)), ...
    std(DF_specs_cr.aperiodic_params(:,1)) / sqrt(size(DF_specs_cr,1)), ...
    std(DF_specs_fa.aperiodic_params(:,1)) / sqrt(size(DF_specs_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_hit.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_miss.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_cr.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_fa.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xlim([0.5,4.5])
xticks(1:4)
xticklabels({'Hit','Miss','CR','FA'})
%ylim([-10,-8])
%yticks([-10,-8])

axs(4,2) = nexttile;
avg = [mean(DF_specs_hit.aperiodic_params(:,2)), ...
    mean(DF_specs_miss.aperiodic_params(:,2)), ...
    mean(DF_specs_cr.aperiodic_params(:,2)), ...
    mean(DF_specs_fa.aperiodic_params(:,2))];
err = [std(DF_specs_hit.aperiodic_params(:,2)) / sqrt(size(DF_specs_hit,1)), ...
    std(DF_specs_miss.aperiodic_params(:,2)) / sqrt(size(DF_specs_miss,1)), ...
    std(DF_specs_cr.aperiodic_params(:,2)) / sqrt(size(DF_specs_cr,1)), ...
    std(DF_specs_fa.aperiodic_params(:,2)) / sqrt(size(DF_specs_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_hit.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_miss.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_cr.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_fa.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xlim([0.5,4.5])
xticks(1:4)
xticklabels({'Hit','Miss','CR','FA'})
%ylim([0,2])
%yticks([0,2])

axs(4,3) = nexttile;
avg = [mean(pparams_hit(:,1)), ...
    mean(pparams_miss(:,1)), ...
    mean(pparams_cr(:,1)), ...
    mean(pparams_fa(:,1))];
err = [std(pparams_hit(:,1)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,1)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,1)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,1)) / sqrt(size(pparams_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_hit(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_miss(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_cr(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_fa(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xticks([1,2,3,4])
xticklabels({'Hit','Miss','CR','FA'})
%ylim([0,20])
%yticks([0,20])
xlim([0.5,4.5])
% ylabel('Peak Frequency (Hz)')

axs(4,4) = nexttile;
avg = [mean(pparams_hit(:,2)), ...
    mean(pparams_miss(:,2)), ...
    mean(pparams_cr(:,2)), ...
    mean(pparams_fa(:,2))];
err = [std(pparams_hit(:,2)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,2)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,2)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,2)) / sqrt(size(pparams_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_hit(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_miss(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_cr(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_fa(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xticks([1,2,3,4])
xticklabels({'Hit','Miss','CR','FA'})
%ylim([0,0.8])
%yticks([0,0.8])
xlim([0.5,4.5])
% ylabel('Relative Power (a.u.)')

axs(4,5) = nexttile;
avg = [mean(pparams_hit(:,3)), ...
    mean(pparams_miss(:,3)), ...
    mean(pparams_cr(:,3)), ...
    mean(pparams_fa(:,3))];
err = [std(pparams_hit(:,3)) / sqrt(size(pparams_hit,1)), ...
    std(pparams_miss(:,3)) / sqrt(size(pparams_miss,1)), ...
    std(pparams_cr(:,3)) / sqrt(size(pparams_cr,1)), ...
    std(pparams_fa(:,3)) / sqrt(size(pparams_fa,1))];
hold on 
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+1+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_hit(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+2+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_miss(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+3+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_cr(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_hit.aperiodic_params,1))+4+(rand(1,size(DF_specs_hit.aperiodic_params,1))-0.5)*0.3, ...
    pparams_fa(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xticks([1,2,3,4])
xticklabels({'Hit','Miss','CR','FA'})
%ylim([0,8])
xlim([0.5,4.5])
%yticks([0,8])

pparams_ag= pparams_hit;
pparams_ag_hit= pparams_hit;
pparams_ag_miss= pparams_miss;
pparams_ag_cr= pparams_cr;
pparams_ag_fa= pparams_fa;
DF_specs_ag_hit = DF_specs_hit;
DF_specs_ag_miss = DF_specs_miss;
DF_specs_ag_cr = DF_specs_cr;
DF_specs_ag_fa = DF_specs_fa;
DF_specs_ag = DF_specs_hit;

if out_path
    saveas(period_fig, '../Figures/periodic_aperiodic.fig')
    saveas(period_fig, '../Figures/periodic_aperiodic.svg')
end

ap1_fig = figure('Position', [1215 1378 381 328]);
avg = [mean(DF_specs_s1.aperiodic_params(:,1)), ...
    mean(DF_specs_pfc.aperiodic_params(:,1)), ...
    mean(DF_specs_bg.aperiodic_params(:,1)), ...
    mean(DF_specs_ag.aperiodic_params(:,1))];
err = [std(DF_specs_s1.aperiodic_params(:,1)) / sqrt(size(DF_specs_s1,1)), ...
    std(DF_specs_pfc.aperiodic_params(:,1)) / sqrt(size(DF_specs_pfc,1)), ...
    std(DF_specs_bg.aperiodic_params(:,1)) / sqrt(size(DF_specs_bg,1)), ...
    std(DF_specs_ag.aperiodic_params(:,1)) / sqrt(size(DF_specs_ag,1))];
hold on 
plot(zeros(1,size(DF_specs_s1.aperiodic_params,1))+1+(rand(1,size(DF_specs_s1.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_s1.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_pfc.aperiodic_params,1))+2+(rand(1,size(DF_specs_pfc.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_pfc.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_bg.aperiodic_params,1))+3+(rand(1,size(DF_specs_bg.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_bg.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_ag.aperiodic_params,1))+4+(rand(1,size(DF_specs_ag.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_ag.aperiodic_params(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 3)
xlim([0.5,4.5])
xticks(1:4)
xticklabels({'S1', 'PFC', 'Striatum', 'Amygdala'})
ylim([-10,-4])
yticks([-10,-4])
xtickangle(45)

ap2_fig = figure('Position', [1215 1378 381 328]);
avg = [mean(DF_specs_s1.aperiodic_params(:,2)), ...
    mean(DF_specs_pfc.aperiodic_params(:,2)), ...
    mean(DF_specs_bg.aperiodic_params(:,2)), ...
    mean(DF_specs_ag.aperiodic_params(:,2))];
err = [std(DF_specs_s1.aperiodic_params(:,2)) / sqrt(size(DF_specs_s1,1)), ...
    std(DF_specs_pfc.aperiodic_params(:,2)) / sqrt(size(DF_specs_pfc,1)), ...
    std(DF_specs_bg.aperiodic_params(:,2)) / sqrt(size(DF_specs_bg,1)), ...
    std(DF_specs_ag.aperiodic_params(:,2)) / sqrt(size(DF_specs_ag,1))];
hold on 
plot(zeros(1,size(DF_specs_s1.aperiodic_params,1))+1+(rand(1,size(DF_specs_s1.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_s1.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_pfc.aperiodic_params,1))+2+(rand(1,size(DF_specs_pfc.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_pfc.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_bg.aperiodic_params,1))+3+(rand(1,size(DF_specs_bg.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_bg.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_ag.aperiodic_params,1))+4+(rand(1,size(DF_specs_ag.aperiodic_params,1))-0.5)*0.3, ...
    DF_specs_ag.aperiodic_params(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xlim([0.5,4.5])
xticks(1:4)
xticklabels({'S1', 'PFC', 'Striatum', 'Amygdala'})
xtickangle(45)
ylim([0,2])
yticks([0,2])

pfig1 = figure('Position', [1215 1378 381 328]);
avg = [mean(pparams_s1(:,1)), ...
    mean(pparams_pfc(:,1)), ...
    mean(pparams_bg(:,1)), ...
    mean(pparams_ag(:,1))];
err = [std(pparams_s1(:,1)) / sqrt(size(pparams_s1,1)), ...
    std(pparams_pfc(:,1)) / sqrt(size(pparams_pfc,1)), ...
    std(pparams_bg(:,1)) / sqrt(size(pparams_bg,1)), ...
    std(pparams_ag(:,1)) / sqrt(size(pparams_ag,1))];
hold on 
plot(zeros(1,size(DF_specs_s1.aperiodic_params,1))+1+(rand(1,size(DF_specs_s1.aperiodic_params,1))-0.5)*0.3, ...
    pparams_s1(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_pfc.aperiodic_params,1))+2+(rand(1,size(DF_specs_pfc.aperiodic_params,1))-0.5)*0.3, ...
    pparams_pfc(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_bg.aperiodic_params,1))+3+(rand(1,size(DF_specs_bg.aperiodic_params,1))-0.5)*0.3, ...
    pparams_bg(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_ag.aperiodic_params,1))+4+(rand(1,size(DF_specs_ag.aperiodic_params,1))-0.5)*0.3, ...
    pparams_ag(:,1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xticks([1,2,3,4])
xticklabels({'S1', 'PFC', 'Striatum', 'Amygdala'})
ylim([0,20])
yticks([0,20])
xlim([0.5,4.5])
% ylabel('Peak Frequency (Hz)')

pfig2 = figure('Position', [1215 1378 381 328]);
avg = [mean(pparams_s1(:,2)), ...
    mean(pparams_pfc(:,2)), ...
    mean(pparams_bg(:,2)), ...
    mean(pparams_ag(:,2))];
err = [std(pparams_s1(:,2)) / sqrt(size(pparams_s1,1)), ...
    std(pparams_pfc(:,2)) / sqrt(size(pparams_pfc,1)), ...
    std(pparams_bg(:,2)) / sqrt(size(pparams_bg,1)), ...
    std(pparams_ag(:,2)) / sqrt(size(pparams_ag,1))];
hold on 
plot(zeros(1,size(DF_specs_s1.aperiodic_params,1))+1+(rand(1,size(DF_specs_s1.aperiodic_params,1))-0.5)*0.3, ...
    pparams_s1(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_pfc.aperiodic_params,1))+2+(rand(1,size(DF_specs_pfc.aperiodic_params,1))-0.5)*0.3, ...
    pparams_pfc(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_bg.aperiodic_params,1))+3+(rand(1,size(DF_specs_bg.aperiodic_params,1))-0.5)*0.3, ...
    pparams_bg(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_ag.aperiodic_params,1))+4+(rand(1,size(DF_specs_ag.aperiodic_params,1))-0.5)*0.3, ...
    pparams_ag(:,2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xticks([1,2,3,4])
xticklabels({'S1', 'PFC', 'Striatum', 'Amygdala'})
ylim([0,0.8])
yticks([0,0.8])
xlim([0.5,4.5])
% ylabel('Relative Power (a.u.)')

pfig3 = figure('Position', [1215 1378 381 328]);
avg = [mean(pparams_s1(:,3)), ...
    mean(pparams_pfc(:,3)), ...
    mean(pparams_bg(:,3)), ...
    mean(pparams_ag(:,3))];
err = [std(pparams_s1(:,3)) / sqrt(size(pparams_s1,1)), ...
    std(pparams_pfc(:,3)) / sqrt(size(pparams_pfc,1)), ...
    std(pparams_bg(:,3)) / sqrt(size(pparams_bg,1)), ...
    std(pparams_ag(:,3)) / sqrt(size(pparams_ag,1))];
hold on 
plot(zeros(1,size(DF_specs_s1.aperiodic_params,1))+1+(rand(1,size(DF_specs_s1.aperiodic_params,1))-0.5)*0.3, ...
    pparams_s1(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_pfc.aperiodic_params,1))+2+(rand(1,size(DF_specs_pfc.aperiodic_params,1))-0.5)*0.3, ...
    pparams_pfc(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_bg.aperiodic_params,1))+3+(rand(1,size(DF_specs_bg.aperiodic_params,1))-0.5)*0.3, ...
    pparams_bg(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
plot(zeros(1,size(DF_specs_ag.aperiodic_params,1))+4+(rand(1,size(DF_specs_ag.aperiodic_params,1))-0.5)*0.3, ...
    pparams_ag(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', [0.3, 0.3, 0.3], 'MarkerEdgeColor', [1, 1, 1])
errorbar(1:4, avg, err, 'bo', 'CapSize', 10, 'MarkerSize', 1, 'LineWidth', 2)
xticks([1,2,3,4])
xticklabels({'S1', 'PFC', 'Striatum', 'Amygdala'})
ylim([0,8])
xlim([0.5,4.5])
yticks([0,8])

fprintf('S1 params\n')
fprintf('Aperiodic 1:\n')
mat = [DF_specs_s1_hit.aperiodic_params(:,1), DF_specs_s1_miss.aperiodic_params(:,1), DF_specs_s1_cr.aperiodic_params(:,1), DF_specs_s1_fa.aperiodic_params(:,1)];
anova1(mat)
fprintf('Aperiodic 2:\n')
mat = [DF_specs_s1_hit.aperiodic_params(:,2), DF_specs_s1_miss.aperiodic_params(:,2), DF_specs_s1_cr.aperiodic_params(:,2), DF_specs_s1_fa.aperiodic_params(:,2)];
anova1(mat)
fprintf('Periodic 1:\n')
mat = [pparams_s1_hit(:,1), pparams_s1_miss(:,1), pparams_s1_cr(:,1), pparams_s1_fa(:,1)];
anova1(mat)
fprintf('Periodic 2:\n')
mat = [pparams_s1_hit(:,2), pparams_s1_miss(:,2), pparams_s1_cr(:,2), pparams_s1_fa(:,2)];
anova1(mat)
fprintf('Periodic 3:\n')
mat = [pparams_s1_hit(:,3), pparams_s1_miss(:,3), pparams_s1_cr(:,3), pparams_s1_fa(:,3)];
anova1(mat)

fprintf('PFC params\n')
fprintf('Aperiodic 1:\n')
mat = [DF_specs_pfc_hit.aperiodic_params(:,1), DF_specs_pfc_miss.aperiodic_params(:,1), DF_specs_pfc_cr.aperiodic_params(:,1), DF_specs_pfc_fa.aperiodic_params(:,1)];
anova1(mat)
fprintf('Aperiodic 2:\n')
mat = [DF_specs_pfc_hit.aperiodic_params(:,2), DF_specs_pfc_miss.aperiodic_params(:,2), DF_specs_pfc_cr.aperiodic_params(:,2), DF_specs_pfc_fa.aperiodic_params(:,2)];
anova1(mat)
fprintf('Periodic 1:\n')
mat = [pparams_pfc_hit(:,1), pparams_pfc_miss(:,1), pparams_pfc_cr(:,1), pparams_pfc_fa(:,1)];
anova1(mat)
fprintf('Periodic 2:\n')
mat = [pparams_pfc_hit(:,2), pparams_pfc_miss(:,2), pparams_pfc_cr(:,2), pparams_pfc_fa(:,2)];
anova1(mat)
fprintf('Periodic 3:\n')
mat = [pparams_pfc_hit(:,3), pparams_pfc_miss(:,3), pparams_pfc_cr(:,3), pparams_pfc_fa(:,3)];
anova1(mat)

fprintf('Striatum params\n')
fprintf('Aperiodic 1:\n')
mat = [DF_specs_bg_hit.aperiodic_params(:,1), DF_specs_bg_miss.aperiodic_params(:,1), DF_specs_bg_cr.aperiodic_params(:,1), DF_specs_bg_fa.aperiodic_params(:,1)];
anova1(mat)
fprintf('Aperiodic 2:\n')
mat = [DF_specs_bg_hit.aperiodic_params(:,2), DF_specs_bg_miss.aperiodic_params(:,2), DF_specs_bg_cr.aperiodic_params(:,2), DF_specs_bg_fa.aperiodic_params(:,2)];
anova1(mat)
fprintf('Periodic 1:\n')
mat = [pparams_bg_hit(:,1), pparams_bg_miss(:,1), pparams_bg_cr(:,1), pparams_bg_fa(:,1)];
anova1(mat)
fprintf('Periodic 2:\n')
mat = [pparams_bg_hit(:,2), pparams_bg_miss(:,2), pparams_bg_cr(:,2), pparams_bg_fa(:,2)];
anova1(mat)
fprintf('Periodic 3:\n')
mat = [pparams_bg_hit(:,3), pparams_bg_miss(:,3), pparams_bg_cr(:,3), pparams_bg_fa(:,3)];
anova1(mat)

fprintf('Amygdala params\n')
fprintf('Aperiodic 1:\n')
mat = [DF_specs_ag_hit.aperiodic_params(:,1), DF_specs_ag_miss.aperiodic_params(:,1), DF_specs_ag_cr.aperiodic_params(:,1), DF_specs_ag_fa.aperiodic_params(:,1)];
anova1(mat)
fprintf('Aperiodic 2:\n')
mat = [DF_specs_ag_hit.aperiodic_params(:,2), DF_specs_ag_miss.aperiodic_params(:,2), DF_specs_ag_cr.aperiodic_params(:,2), DF_specs_ag_fa.aperiodic_params(:,2)];
anova1(mat)
fprintf('Periodic 1:\n')
mat = [pparams_ag_hit(:,1), pparams_ag_miss(:,1), pparams_ag_cr(:,1), pparams_ag_fa(:,1)];
anova1(mat)
fprintf('Periodic 2:\n')
mat = [pparams_ag_hit(:,2), pparams_ag_miss(:,2), pparams_ag_cr(:,2), pparams_ag_fa(:,2)];
anova1(mat)
fprintf('Periodic 3:\n')
mat = [pparams_ag_hit(:,3), pparams_ag_miss(:,3), pparams_ag_cr(:,3), pparams_ag_fa(:,3)];
anova1(mat)

fprintf('\nInter-region\n')
fprintf('Aperiodic 1:\n')
if KStest(DF_specs_s1.aperiodic_params(:,1)) || KStest(DF_specs_pfc.aperiodic_params(:,1))
    p = ranksum(DF_specs_s1.aperiodic_params(:,1), DF_specs_pfc.aperiodic_params(:,1));
    fprintf(sprintf('S1 vs PFC (mann-whitney): p = %d\n', p))
else
    [~,p] = ttest2(DF_specs_s1.aperiodic_params(:,1), DF_specs_pfc.aperiodic_params(:,1));
    fprintf(sprintf('S1 vs PFC (2-sample t-test): p = %d\n', p))
end

if KStest(DF_specs_s1.aperiodic_params(:,1)) || KStest(DF_specs_bg.aperiodic_params(:,1))
    p = signrank(DF_specs_s1.aperiodic_params(:,1), DF_specs_bg.aperiodic_params(:,1));
    fprintf(sprintf('S1 vs Striatum (wilcoxon sign-rank): p = %d\n', p))
else
    [~,p] = ttest(DF_specs_s1.aperiodic_params(:,1), DF_specs_bg.aperiodic_params(:,1));
    fprintf(sprintf('S1 vs Striatum (paired t-test): p = %d\n', p))
end

if KStest(DF_specs_s1.aperiodic_params(:,1)) || KStest(DF_specs_ag.aperiodic_params(:,1))
    p = signrank(DF_specs_s1.aperiodic_params(:,1), DF_specs_ag.aperiodic_params(:,1));
    fprintf(sprintf('S1 vs Amygdala (wilcoxon sign-rank): p = %d\n', p))
else
    [~,p] = ttest(DF_specs_s1.aperiodic_params(:,1), DF_specs_ag.aperiodic_params(:,1));
    fprintf(sprintf('S1 vs Amygdala (paired t-test): p = %d\n', p))
end

if KStest(DF_specs_ag.aperiodic_params(:,1)) || KStest(DF_specs_bg.aperiodic_params(:,1))
    p = signrank(DF_specs_ag.aperiodic_params(:,1), DF_specs_bg.aperiodic_params(:,1));
    fprintf(sprintf('Amygdala vs Striatum (wilcoxon sign-rank): p = %d\n', p))
else
    [~,p] = ttest(DF_specs_ag.aperiodic_params(:,1), DF_specs_bg.aperiodic_params(:,1));
    fprintf(sprintf('Amygdala vs Striatum (paired t-test): p = %d\n', p))
end

if KStest(DF_specs_bg.aperiodic_params(:,1)) || KStest(DF_specs_pfc.aperiodic_params(:,1))
    p = ranksum(DF_specs_bg.aperiodic_params(:,1), DF_specs_pfc.aperiodic_params(:,1));
    fprintf(sprintf('Striatum vs PFC (mann-whitney): p = %d\n', p))
else
    [~,p] = ttest2(DF_specs_bg.aperiodic_params(:,1), DF_specs_pfc.aperiodic_params(:,1));
    fprintf(sprintf('Striatum vs PFC (2-sample t-test): p = %d\n', p))
end

if KStest(DF_specs_ag.aperiodic_params(:,1)) || KStest(DF_specs_pfc.aperiodic_params(:,1))
    p = ranksum(DF_specs_ag.aperiodic_params(:,1), DF_specs_pfc.aperiodic_params(:,1));
    fprintf(sprintf('Amygdala vs PFC (mann-whitney): p = %d\n', p))
else
    [~,p] = ttest2(DF_specs_ag.aperiodic_params(:,1), DF_specs_pfc.aperiodic_params(:,1));
    fprintf(sprintf('Amygdala vs PFC (2-sample t-test): p = %d\n', p))
end

fprintf('\nAperiodic 2:\n')
if KStest(DF_specs_s1.aperiodic_params(:,2)) || KStest(DF_specs_pfc.aperiodic_params(:,2))
    p = ranksum(DF_specs_s1.aperiodic_params(:,2), DF_specs_pfc.aperiodic_params(:,2));
    fprintf(sprintf('S1 vs PFC (mann-whitney): p = %d\n', p))
else
    [~,p] = ttest2(DF_specs_s1.aperiodic_params(:,2), DF_specs_pfc.aperiodic_params(:,2));
    fprintf(sprintf('S1 vs PFC (2-sample t-test): p = %d\n', p))
end

if KStest(DF_specs_s1.aperiodic_params(:,2)) || KStest(DF_specs_bg.aperiodic_params(:,2))
    p = signrank(DF_specs_s1.aperiodic_params(:,2), DF_specs_bg.aperiodic_params(:,2));
    fprintf(sprintf('S1 vs Striatum (wilcoxon sign-rank): p = %d\n', p))
else
    [~,p] = ttest(DF_specs_s1.aperiodic_params(:,2), DF_specs_bg.aperiodic_params(:,2));
    fprintf(sprintf('S1 vs Striatum (paired t-test): p = %d\n', p))
end

if KStest(DF_specs_s1.aperiodic_params(:,2)) || KStest(DF_specs_ag.aperiodic_params(:,2))
    p = signrank(DF_specs_s1.aperiodic_params(:,2), DF_specs_ag.aperiodic_params(:,2));
    fprintf(sprintf('S1 vs Amygdala (wilcoxon sign-rank): p = %d\n', p))
else
    [~,p] = ttest(DF_specs_s1.aperiodic_params(:,2), DF_specs_ag.aperiodic_params(:,2));
    fprintf(sprintf('S1 vs Amygdala (paired t-test): p = %d\n', p))
end

if KStest(DF_specs_ag.aperiodic_params(:,2)) || KStest(DF_specs_bg.aperiodic_params(:,2))
    p = signrank(DF_specs_ag.aperiodic_params(:,2), DF_specs_bg.aperiodic_params(:,2));
    fprintf(sprintf('Amygdala vs Striatum (wilcoxon sign-rank): p = %d\n', p))
else
    [~,p] = ttest(DF_specs_ag.aperiodic_params(:,2), DF_specs_bg.aperiodic_params(:,2));
    fprintf(sprintf('Amygdala vs Striatum (paired t-test): p = %d\n', p))
end

if KStest(DF_specs_bg.aperiodic_params(:,2)) || KStest(DF_specs_pfc.aperiodic_params(:,2))
    p = ranksum(DF_specs_bg.aperiodic_params(:,2), DF_specs_pfc.aperiodic_params(:,2));
    fprintf(sprintf('Striatum vs PFC (mann-whitney): p = %d\n', p))
else
    [~,p] = ttest2(DF_specs_bg.aperiodic_params(:,2), DF_specs_pfc.aperiodic_params(:,2));
    fprintf(sprintf('Striatum vs PFC (2-sample t-test): p = %d\n', p))
end

if KStest(DF_specs_ag.aperiodic_params(:,2)) || KStest(DF_specs_pfc.aperiodic_params(:,2))
    p = ranksum(DF_specs_ag.aperiodic_params(:,2), DF_specs_pfc.aperiodic_params(:,2));
    fprintf(sprintf('Amygdala vs PFC (mann-whitney): p = %d\n', p))
else
    [~,p] = ttest2(DF_specs_ag.aperiodic_params(:,2), DF_specs_pfc.aperiodic_params(:,2));
    fprintf(sprintf('Amygdala vs PFC (2-sample t-test): p = %d\n', p))
end

fprintf('\nPeriodic 1:\n')
if KStest(pparams_s1(:,1)) || KStest(pparams_pfc(:,1))
    p = ranksum(pparams_s1(:,1), pparams_pfc(:,1));
    fprintf(sprintf('S1 vs PFC (mann-whitney): p = %d\n', p))
else
    [~,p] = ttest2(pparams_s1(:,1), pparams_pfc(:,1));
    fprintf(sprintf('S1 vs PFC (2-sample t-test): p = %d\n', p))
end

if KStest(pparams_ag(:,1)) || KStest(pparams_bg(:,1))
    p = signrank(pparams_ag(:,1), pparams_bg(:,1));
    fprintf(sprintf('Amygdala vs Striatum (wilcoxon sign-rank): p = %d\n', p))
else
    [~,p] = ttest(pparams_ag(:,1), pparams_bg(:,1));
    fprintf(sprintf('Amygdala vs Striatum (paired t-test): p = %d\n', p))
end

if KStest(pparams_s1(:,1)) || KStest(pparams_bg(:,1))
    p = signrank(pparams_s1(:,1), pparams_bg(:,1));
    fprintf(sprintf('S1 vs Striatum (wilcoxon sign-rank): p = %d\n', p))
else
    [~,p] = ttest(pparams_s1(:,1), pparams_bg(:,1));
    fprintf(sprintf('S1 vs Striatum (paired t-test): p = %d\n', p))
end

if KStest(pparams_s1(:,1)) || KStest(pparams_ag(:,1))
    p = signrank(pparams_s1(:,1), pparams_ag(:,1));
    fprintf(sprintf('S1 vs Amygdala (wilcoxon sign-rank): p = %d\n', p))
else
    [~,p] = ttest(pparams_s1(:,1), pparams_ag(:,1));
    fprintf(sprintf('S1 vs Amygdala (paired t-test): p = %d\n', p))
end

if KStest(pparams_bg(:,1)) || KStest(pparams_pfc(:,1))
    p = ranksum(pparams_bg(:,1), pparams_pfc(:,1));
    fprintf(sprintf('Striatum vs PFC (mann-whitney): p = %d\n', p))
else
    [~,p] = ttest2(pparams_bg(:,1), pparams_pfc(:,1));
    fprintf(sprintf('Striatum vs PFC (2-sample t-test): p = %d\n', p))
end

if KStest(pparams_ag(:,1)) || KStest(pparams_pfc(:,1))
    p = ranksum(pparams_ag(:,1), pparams_pfc(:,1));
    fprintf(sprintf('Amygdala vs PFC (mann-whitney): p = %d\n', p))
else
    [~,p] = ttest2(pparams_ag(:,1), pparams_pfc(:,1));
    fprintf(sprintf('Amygdala vs PFC (2-sample t-test): p = %d\n', p))
end

fprintf('\nPeriodic 2:\n')
if KStest(pparams_s1(:,2)) || KStest(pparams_pfc(:,2))
    p = ranksum(pparams_s1(:,2), pparams_pfc(:,2));
    fprintf(sprintf('S1 vs PFC (mann-whitney): p = %d\n', p))
else
    [~,p] = ttest2(pparams_s1(:,2), pparams_pfc(:,2));
    fprintf(sprintf('S1 vs PFC (2-sample t-test): p = %d\n', p))
end

if KStest(pparams_ag(:,2)) || KStest(pparams_bg(:,2))
    p = signrank(pparams_ag(:,2), pparams_bg(:,2));
    fprintf(sprintf('Amygdala vs Striatum (wilcoxon sign-rank): p = %d\n', p))
else
    [~,p] = ttest(pparams_ag(:,2), pparams_bg(:,2));
    fprintf(sprintf('Amygdala vs Striatum (paired t-test): p = %d\n', p))
end

if KStest(pparams_s1(:,2)) || KStest(pparams_bg(:,2))
    p = signrank(pparams_s1(:,2), pparams_bg(:,2));
    fprintf(sprintf('S1 vs Striatum (wilcoxon sign-rank): p = %d\n', p))
else
    [~,p] = ttest(pparams_s1(:,2), pparams_bg(:,2));
    fprintf(sprintf('S1 vs Striatum (paired t-test): p = %d\n', p))
end

if KStest(pparams_s1(:,2)) || KStest(pparams_ag(:,2))
    p = signrank(pparams_s1(:,2), pparams_ag(:,2));
    fprintf(sprintf('S1 vs Amygdala (wilcoxon sign-rank): p = %d\n', p))
else
    [~,p] = ttest(pparams_s1(:,2), pparams_ag(:,2));
    fprintf(sprintf('S1 vs Amygdala (paired t-test): p = %d\n', p))
end

if KStest(pparams_bg(:,2)) || KStest(pparams_pfc(:,2))
    p = ranksum(pparams_bg(:,2), pparams_pfc(:,2));
    fprintf(sprintf('Striatum vs PFC (mann-whitney): p = %d\n', p))
else
    [~,p] = ttest2(pparams_bg(:,2), pparams_pfc(:,2));
    fprintf(sprintf('Striatum vs PFC (2-sample t-test): p = %d\n', p))
end

if KStest(pparams_ag(:,2)) || KStest(pparams_pfc(:,2))
    p = ranksum(pparams_ag(:,2), pparams_pfc(:,2));
    fprintf(sprintf('Amygdala vs PFC (mann-whitney): p = %d\n', p))
else
    [~,p] = ttest2(pparams_ag(:,2), pparams_pfc(:,2));
    fprintf(sprintf('Amygdala vs PFC (2-sample t-test): p = %d\n', p))
end

fprintf('\nPeriodic 3:\n')
if KStest(pparams_s1(:,3)) || KStest(pparams_pfc(:,3))
    p = ranksum(pparams_s1(:,3), pparams_pfc(:,3));
    fprintf(sprintf('S1 vs PFC (mann-whitney): p = %d\n', p))
else
    [~,p] = ttest2(pparams_s1(:,3), pparams_pfc(:,3));
    fprintf(sprintf('S1 vs PFC (2-sample t-test): p = %d\n', p))
end

if KStest(pparams_ag(:,3)) || KStest(pparams_bg(:,3))
    p = signrank(pparams_ag(:,3), pparams_bg(:,3));
    fprintf(sprintf('Amygdala vs Striatum (wilcoxon sign-rank): p = %d\n', p))
else
    [~,p] = ttest(pparams_ag(:,3), pparams_bg(:,3));
    fprintf(sprintf('Amygdala vs Striatum (paired t-test): p = %d\n', p))
end

if KStest(pparams_s1(:,3)) || KStest(pparams_bg(:,3))
    p = signrank(pparams_s1(:,3), pparams_bg(:,3));
    fprintf(sprintf('S1 vs Striatum (wilcoxon sign-rank): p = %d\n', p))
else
    [~,p] = ttest(pparams_s1(:,3), pparams_bg(:,3));
    fprintf(sprintf('S1 vs Striatum (paired t-test): p = %d\n', p))
end

if KStest(pparams_s1(:,3)) || KStest(pparams_ag(:,3))
    p = signrank(pparams_s1(:,3), pparams_ag(:,3));
    fprintf(sprintf('S1 vs Amygdala (wilcoxon sign-rank): p = %d\n', p))
else
    [~,p] = ttest(pparams_s1(:,3), pparams_ag(:,3));
    fprintf(sprintf('S1 vs Amygdala (paired t-test): p = %d\n', p))
end

if KStest(pparams_bg(:,3)) || KStest(pparams_pfc(:,3))
    p = ranksum(pparams_bg(:,3), pparams_pfc(:,3));
    fprintf(sprintf('Striatum vs PFC (mann-whitney): p = %d\n', p))
else
    [~,p] = ttest2(pparams_bg(:,3), pparams_pfc(:,3));
    fprintf(sprintf('Striatum vs PFC (2-sample t-test): p = %d\n', p))
end

if KStest(pparams_ag(:,3)) || KStest(pparams_pfc(:,3))
    p = ranksum(pparams_ag(:,3), pparams_pfc(:,3));
    fprintf(sprintf('Amygdala vs PFC (mann-whitney): p = %d\n', p))
else
    [~,p] = ttest2(pparams_ag(:,3), pparams_pfc(:,3));
    fprintf(sprintf('Amygdala vs PFC (2-sample t-test): p = %d\n', p))
end

if out_path
    saveas(ap1_fig, '../Figures/ap1.fig')
    saveas(ap2_fig, '../Figures/ap2.fig')
    saveas(pfig1, '../Figures/p1.fig')
    saveas(pfig2, '../Figures/p2.fig')
    saveas(pfig3, '../Figures/p3.fig')
    saveas(ap1_fig, '../Figures/ap1.svg')
    saveas(ap2_fig, '../Figures/ap2.svg')
    saveas(pfig1, '../Figures/p1.svg')
    saveas(pfig2, '../Figures/p2.svg')
    saveas(pfig3, '../Figures/p3.svg')
end

diary off