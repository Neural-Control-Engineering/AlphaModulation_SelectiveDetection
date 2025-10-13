init_paths;
run_bootstrap = false;

if run_bootstrap
    % S1
    s1 = load(strcat(ftr_path,'/AP/FIG/S1_Expert_Combo_Revision/Cortex/Spontaneous_Alpha_Modulation/data.mat'));
    s1.out.alpha_modulated = s1.out.alpha_modulated(cell2mat(s1.out.alpha_modulated.avg_trial_fr) > 1, :);
    out = s1.out; clear s1;
    session_ids = unique(out.alpha_modulated.session_id);

    % quality control 
    exinds = load('ExcldInds/3738_excld.mat');
    for i = 1:length(exinds.excld{1})
        session_id = exinds.excld{1}{i};
        cid = exinds.excld{2}{i};
        out.alpha_modulated(strcmp(out.alpha_modulated.session_id, session_id) & out.alpha_modulated.cluster_id == cid,:) = [];
    end
    exinds = load('ExcldInds/3387_excld.mat');
    for i = 1:length(exinds.excld{1})
        session_id = exinds.excld{1}{i};
        cid = exinds.excld{2}{i};
        out.alpha_modulated(strcmp(out.alpha_modulated.session_id, session_id) & out.alpha_modulated.cluster_id == cid,:) = [];
    end

    out_path = strcat(ftr_path, 'AP/FIG/S1_Expert_Combo_Revision/Cortex/Spontaneous_Alpha_Modulation/Lick_NoLick_Shuffles/');
    if ~exist(out_path, 'dir')
        mkdir(out_path)
    end

    for s = 1:length(session_ids)
        fig_path = strcat(out_path, session_ids{s}, '/');
        if ~exist(fig_path, 'dir')
            mkdir(fig_path)
        end
        alpha_modulated = out.alpha_modulated(strcmp(out.alpha_modulated.session_id, session_ids{s}),:);
        alpha_modulated = alpha_modulated(strcmp(alpha_modulated.waveform_class, 'RS') | strcmp(alpha_modulated.waveform_class, 'FS'),:);
        slrt_ext = load(strcat(ext_path, 'SLRT/', session_ids{s}, '.mat'));
        ap_ext = load(strcat(ext_path, 'AP/', session_ids{s}, '.mat'));
        shuff_p = zeros(size(alpha_modulated,1),10);
        contains_lick = spontaneousLicks(slrt_ext.slrt_data);
        trial_inds = find(contains_lick);
        numLick = length(trial_inds);
        noLickInds = find(~contains_lick);
        alpha_modulated = alpha_modulated(cell2mat(alpha_modulated.avg_trial_fr) > 1,:);
        for i = 1:100
            choice_inds = noLickInds(randperm(length(noLickInds), numLick));
            tmp_ap = ap_ext.ap_data(choice_inds,:);
            tmp_slrt = slrt_ext.slrt_data(choice_inds,:);
            % table for session 
            sesh_id_array = cell(length(tmp_ap(1,:).spiking_data{1}.cluster_id), 1);
            session_id = tmp_slrt(1,:).session_label{1};
            for j = 1:length(sesh_id_array)
                sesh_id_array{j} = session_id;
            end
            positions =  cell2mat(tmp_ap(1,:).spiking_data{1}.position);
            tmp_session = table(sesh_id_array, tmp_ap(1,:).spiking_data{1}.cluster_id, ...
                    tmp_ap(1,:).spiking_data{1}.quality, ...
                    tmp_ap(1,:).spiking_data{1}.template, tmp_ap(1,:).spiking_data{1}.template_amplitude, positions, ...
                    'VariableNames', {'session_id', 'cluster_id', 'quality', 'template', 'template_amplitude', 'position'});
            tmp_session = lfpPhaseHists(tmp_session, tmp_ap, {'left_trigger', 'right_trigger'});
            % figure(); hist([tmp_session(ind, :).spon_alpha_spike_phases_hit{1}, tmp_session(ind, :).spon_alpha_spike_phases_cr{1}])
            for j = 1:size(alpha_modulated,1)
                ind = find(tmp_ap(1,:).spiking_data{1}.cluster_id == alpha_modulated(j,:).cluster_id);
                try
                    [p, ~] = circ_rtest(tmp_session(ind, :).spon_alpha_spike_phases{1});
                catch
                    p = nan;
                end
                shuff_p(j,i) = p;
            end
        end
        nolick_ptiles = [];
        for c = 1:size(alpha_modulated, 1)
            p_lick = alpha_modulated(c,:).p_lick;
            p_nolick = alpha_modulated(c,:).p_nolick;
            ptiles = zeros(1,100);
            for i = 1:100
                ptiles(i) = prctile(shuff_p(c,:),i);
            end
            [~, min_ind] = min((ptiles - p_lick) .^ 2);
            nolick_ptiles = [nolick_ptiles, min_ind];
            fig = figure('Visible', 'off');
            hold on 
            histogram(shuff_p(c,:),20)
            lims = ylim;
            plot([p_lick,p_lick], [0, lims(2)], 'r--')
            xlabel('Rayleigh Test p-value')
            ylabel('Count')
            cluster_id = alpha_modulated(c,:).cluster_id;
            saveas(fig, sprintf('%scluster_%i.svg', fig_path, cluster_id))
            saveas(fig, sprintf('%scluster_%i.fig', fig_path, cluster_id))
            close
        end
        save(sprintf('%sshuffle_data.mat', fig_path), 'nolick_ptiles')
    end

    %% PFC
    pfc = load(strcat(ftr_path,'/AP/FIG/PFC_Expert_Combo_Revision/PFC/Spontaneous_Alpha_Modulation/data.mat'));
    pfc.out.alpha_modulated = pfc.out.alpha_modulated(cell2mat(pfc.out.alpha_modulated.avg_trial_fr) > 1, :);
    out = pfc.out; clear pfc;
    session_ids = unique(out.alpha_modulated.session_id);

    % quality control 
    exinds = load('ExcldInds/3755_excld.mat');
    for i = 1:length(exinds.excld{1})
        session_id = exinds.excld{1}{i};
        cid = exinds.excld{2}{i};
        out.alpha_modulated(strcmp(out.alpha_modulated.session_id, session_id) & out.alpha_modulated.cluster_id == cid,:) = [];
    end
    exinds = load('ExcldInds/1075_excld.mat');
    for i = 1:length(exinds.excld{1})
        session_id = exinds.excld{1}{i};
        cid = exinds.excld{2}{i};
        out.alpha_modulated(strcmp(out.alpha_modulated.session_id, session_id) & out.alpha_modulated.cluster_id == cid,:) = [];
    end

    out_path = strcat(ftr_path, 'AP/FIG/PFC_Expert_Combo_Revision/PFC/Spontaneous_Alpha_Modulation/Lick_NoLick_Shuffles/');
    if ~exist(out_path, 'dir')
        mkdir(out_path)
    end

    for s = 1:length(session_ids)
        fig_path = strcat(out_path, session_ids{s}, '/');
        if ~exist(fig_path, 'dir')
            mkdir(fig_path)
        end
        alpha_modulated = out.alpha_modulated(strcmp(out.alpha_modulated.session_id, session_ids{s}),:);
        alpha_modulated = alpha_modulated(strcmp(alpha_modulated.waveform_class, 'RS') | strcmp(alpha_modulated.waveform_class, 'FS'),:);
        slrt_ext = load(strcat(ext_path, 'SLRT/', session_ids{s}, '.mat'));
        ap_ext = load(strcat(ext_path, 'AP/', session_ids{s}, '.mat'));
        shuff_p = zeros(size(alpha_modulated,1),10);
        contains_lick = spontaneousLicks(slrt_ext.slrt_data);
        trial_inds = find(contains_lick);
        numLick = length(trial_inds);
        noLickInds = find(~contains_lick);
        alpha_modulated = alpha_modulated(cell2mat(alpha_modulated.avg_trial_fr) > 1,:);
        for i = 1:100
            choice_inds = noLickInds(randperm(length(noLickInds), numLick));
            tmp_ap = ap_ext.ap_data(choice_inds,:);
            tmp_slrt = slrt_ext.slrt_data(choice_inds,:);
            % table for session 
            sesh_id_array = cell(length(tmp_ap(1,:).spiking_data{1}.cluster_id), 1);
            session_id = tmp_slrt(1,:).session_label{1};
            for j = 1:length(sesh_id_array)
                sesh_id_array{j} = session_id;
            end
            positions =  cell2mat(tmp_ap(1,:).spiking_data{1}.position);
            tmp_session = table(sesh_id_array, tmp_ap(1,:).spiking_data{1}.cluster_id, ...
                    tmp_ap(1,:).spiking_data{1}.quality, ...
                    tmp_ap(1,:).spiking_data{1}.template, tmp_ap(1,:).spiking_data{1}.template_amplitude, positions, ...
                    'VariableNames', {'session_id', 'cluster_id', 'quality', 'template', 'template_amplitude', 'position'});
            tmp_session = lfpPhaseHists(tmp_session, tmp_ap, {'left_trigger', 'right_trigger'});
            % figure(); hist([tmp_session(ind, :).spon_alpha_spike_phases_hit{1}, tmp_session(ind, :).spon_alpha_spike_phases_cr{1}])
            for j = 1:size(alpha_modulated,1)
                ind = find(tmp_ap(1,:).spiking_data{1}.cluster_id == alpha_modulated(j,:).cluster_id);
                try
                    [p, ~] = circ_rtest(tmp_session(ind, :).spon_alpha_spike_phases{1});
                catch
                    p = nan;
                end
                shuff_p(j,i) = p;
            end
        end
        nolick_ptiles = [];
        for c = 1:size(alpha_modulated, 1)
            p_lick = alpha_modulated(c,:).p_lick;
            p_nolick = alpha_modulated(c,:).p_nolick;
            ptiles = zeros(1,100);
            for i = 1:100
                ptiles(i) = prctile(shuff_p(c,:),i);
            end
            [~, min_ind] = min((ptiles - p_lick) .^ 2);
            nolick_ptiles = [nolick_ptiles, min_ind];
            fig = figure('Visible', 'off');
            hold on 
            histogram(shuff_p(c,:),20)
            lims = ylim;
            plot([p_lick,p_lick], [0, lims(2)], 'r--')
            xlabel('Rayleigh Test p-value')
            ylabel('Count')
            cluster_id = alpha_modulated(c,:).cluster_id;
            saveas(fig, sprintf('%scluster_%i.svg', fig_path, cluster_id))
            saveas(fig, sprintf('%scluster_%i.fig', fig_path, cluster_id))
            close
        end
        save(sprintf('%sshuffle_data.mat', fig_path), 'nolick_ptiles')
    end

    % Striatum
    s1 = load(strcat(ftr_path,'/AP/FIG/S1_Expert_Combo_Revision/Basal_Ganglia/Spontaneous_Alpha_Modulation/data.mat'));
    s1.out.alpha_modulated = s1.out.alpha_modulated(cell2mat(s1.out.alpha_modulated.avg_trial_fr) > 1, :);
    out = s1.out; clear s1;
    session_ids = unique(out.alpha_modulated.session_id);

    % quality control 
    exinds = load('ExcldInds/3738_excld.mat');
    for i = 1:length(exinds.excld{1})
        session_id = exinds.excld{1}{i};
        cid = exinds.excld{2}{i};
        out.alpha_modulated(strcmp(out.alpha_modulated.session_id, session_id) & out.alpha_modulated.cluster_id == cid,:) = [];
    end
    exinds = load('ExcldInds/3387_excld.mat');
    for i = 1:length(exinds.excld{1})
        session_id = exinds.excld{1}{i};
        cid = exinds.excld{2}{i};
        out.alpha_modulated(strcmp(out.alpha_modulated.session_id, session_id) & out.alpha_modulated.cluster_id == cid,:) = [];
    end

    out_path = strcat(ftr_path, 'AP/FIG/S1_Expert_Combo_Revision/Basal_Ganglia/Spontaneous_Alpha_Modulation/Lick_NoLick_Shuffles/');
    if ~exist(out_path, 'dir')
        mkdir(out_path)
    end

    for s = 1:length(session_ids)
        fig_path = strcat(out_path, session_ids{s}, '/');
        if ~exist(fig_path, 'dir')
            mkdir(fig_path)
        end
        alpha_modulated = out.alpha_modulated(strcmp(out.alpha_modulated.session_id, session_ids{s}),:);
        alpha_modulated = alpha_modulated(strcmp(alpha_modulated.waveform_class, 'RS') | strcmp(alpha_modulated.waveform_class, 'FS'),:);
        slrt_ext = load(strcat(ext_path, 'SLRT/', session_ids{s}, '.mat'));
        ap_ext = load(strcat(ext_path, 'AP/', session_ids{s}, '.mat'));
        shuff_p = zeros(size(alpha_modulated,1),10);
        contains_lick = spontaneousLicks(slrt_ext.slrt_data);
        trial_inds = find(contains_lick);
        numLick = length(trial_inds);
        noLickInds = find(~contains_lick);
        alpha_modulated = alpha_modulated(cell2mat(alpha_modulated.avg_trial_fr) > 1,:);
        for i = 1:100
            choice_inds = noLickInds(randperm(length(noLickInds), numLick));
            tmp_ap = ap_ext.ap_data(choice_inds,:);
            tmp_slrt = slrt_ext.slrt_data(choice_inds,:);
            % table for session 
            sesh_id_array = cell(length(tmp_ap(1,:).spiking_data{1}.cluster_id), 1);
            session_id = tmp_slrt(1,:).session_label{1};
            for j = 1:length(sesh_id_array)
                sesh_id_array{j} = session_id;
            end
            positions =  cell2mat(tmp_ap(1,:).spiking_data{1}.position);
            tmp_session = table(sesh_id_array, tmp_ap(1,:).spiking_data{1}.cluster_id, ...
                    tmp_ap(1,:).spiking_data{1}.quality, ...
                    tmp_ap(1,:).spiking_data{1}.template, tmp_ap(1,:).spiking_data{1}.template_amplitude, positions, ...
                    'VariableNames', {'session_id', 'cluster_id', 'quality', 'template', 'template_amplitude', 'position'});
            tmp_session = lfpPhaseHists(tmp_session, tmp_ap, {'left_trigger', 'right_trigger'});
            % figure(); hist([tmp_session(ind, :).spon_alpha_spike_phases_hit{1}, tmp_session(ind, :).spon_alpha_spike_phases_cr{1}])
            for j = 1:size(alpha_modulated,1)
                ind = find(tmp_ap(1,:).spiking_data{1}.cluster_id == alpha_modulated(j,:).cluster_id);
                try
                    [p, ~] = circ_rtest(tmp_session(ind, :).spon_alpha_spike_phases{1});
                catch
                    p = nan;
                end
                shuff_p(j,i) = p;
            end
        end
        nolick_ptiles = [];
        for c = 1:size(alpha_modulated, 1)
            p_lick = alpha_modulated(c,:).p_lick;
            p_nolick = alpha_modulated(c,:).p_nolick;
            ptiles = zeros(1,100);
            for i = 1:100
                ptiles(i) = prctile(shuff_p(c,:),i);
            end
            [~, min_ind] = min((ptiles - p_lick) .^ 2);
            nolick_ptiles = [nolick_ptiles, min_ind];
            fig = figure('Visible', 'off');
            hold on 
            histogram(shuff_p(c,:),20)
            lims = ylim;
            plot([p_lick,p_lick], [0, lims(2)], 'r--')
            xlabel('Rayleigh Test p-value')
            ylabel('Count')
            cluster_id = alpha_modulated(c,:).cluster_id;
            saveas(fig, sprintf('%scluster_%i.svg', fig_path, cluster_id))
            saveas(fig, sprintf('%scluster_%i.fig', fig_path, cluster_id))
            close
        end
        save(sprintf('%sshuffle_data.mat', fig_path), 'nolick_ptiles')
    end

end

session_ids = {'date--2024-12-20_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0',...
    'date--2024-12-19_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0',...
    'date--2024-12-18_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0',...
    'date--2024-12-17_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0',...
    'date--2024-12-16_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g1',...
    'date--2024-12-16_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0',...
    'date--2024-12-15_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0',...
    'date--2024-09-07_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0',...
    'date--2024-09-06_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0',...
    'date--2024-09-05_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0',...
    'date--2024-09-04_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0',...
    'date--2024-09-03_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0',...
    'date--2024-09-02_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0',...
    'date--2024-08-02_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-08-01_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-31_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-29_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-25_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-24_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-17_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-16_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-15_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-13_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-07-12_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-03-04_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-03-01_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-02-29_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-02-27_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-02-22_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g1', ...
    'date--2024-02-22_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-02-21_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-02-20_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-02-15_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0', ...
    'date--2024-02-14_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0'};
session_ids = fliplr(session_ids);

s1_path = strcat(ftr_path, 'AP/FIG/S1_Expert_Combo_Revision/Cortex/Spontaneous_Alpha_Modulation/Lick_NoLick_Shuffles/');
str_path = strcat(ftr_path, 'AP/FIG/S1_Expert_Combo_Revision/Basal_Ganglia/Spontaneous_Alpha_Modulation/Lick_NoLick_Shuffles/');
pfc_path = strcat(ftr_path, 'AP/FIG/PFC_Expert_Combo_Revision/PFC/Spontaneous_Alpha_Modulation/Lick_NoLick_Shuffles/');
ptiles = [];
for s = 1:length(session_ids)
    try
        load(sprintf('%s%s/shuffle_data.mat', s1_path, session_ids{s}));
        ptiles = [ptiles, nolick_ptiles];
    end
    try
        load(sprintf('%s%s/shuffle_data.mat', str_path, session_ids{s}));
        ptiles = [ptiles, nolick_ptiles];
    end
    try
        load(sprintf('%s%s/shuffle_data.mat', pfc_path, session_ids{s}));
        ptiles = [ptiles, nolick_ptiles];
    end
    
end

delete Stats/lick_no_lick_shuffle.txt 
diary Stats/lick_no_lick_shuffle.txt 

fig = figure();
histogram(ptiles, 20, 'FaceColor', [0.5,0.5,0.5], 'EdgeColor', [0.5, 0.5, 0.5])
hold on 
plot([95,95],[0,60],'k--')
xlabel('Boostrapped Percentile on Lick Trials')
ylabel('Number of Units')
fprintf(sprintf('Proportion of neurons > 95th percentile: %d\n', sum(ptiles>95)/length(ptiles)))
fprintf(sprintf('Proportion of neurons < 5th percentile: %d\n', sum(ptiles<5)/length(ptiles)))
saveas(fig, '../Figures/lick_bootstrap_summary.svg')
saveas(fig, '../Figures/lick_bootstrap_summary.fig')

diary off

% ptiles = [];
% s = 4;
% load(sprintf('%s%s/shuffle_data.mat', s1_path, session_ids{s}));
% ptiles = [ptiles, nolick_ptiles];