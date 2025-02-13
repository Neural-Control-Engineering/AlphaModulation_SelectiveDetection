function compareApFtrs(ftr_files, out_path, signals)
    % compare animals 
    for i = 1:length(ftr_files)
        if iscell(ftr_files{i})
            % combine animals
            for j = 1:length(ftr_files{i})
                f = load(ftr_files{i}{j});
                if j == 1
                    ftrs = f.ap_ftr;
                else
                    ftrs = combineTables(ftrs, f.ap_ftr);
                end
            end
            expr = sprintf('ftr%i.ap_ftr = ftrs;', i);
            eval(expr)
        else
            expr = sprintf('ftr%i = load(ftr_files{%i});', i, i);
            eval(expr)
        end
    end

    mkdir(out_path)

    all_regions = unique(ftr1.ap_ftr.region);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% cortex 
    ctx_regions = all_regions(startsWith(all_regions,'SS'));

    ctx1 = ftr1.ap_ftr(startsWith(ftr1.ap_ftr.region, 'SS'),:);
    ctx1_driven = ctx1(cell2mat(ctx1.is_left_trigger_stim_modulated) == 1,:);
    ctx1_suppressed = ctx1(cell2mat(ctx1.is_left_trigger_stim_modulated) == -1,:);
    ctx1_nonenconding = ctx1(cell2mat(ctx1.is_left_trigger_stim_modulated) == 0,:);

    ctx2 = ftr2.ap_ftr(startsWith(ftr2.ap_ftr.region, 'SS'),:);
    ctx2_driven = ctx2(cell2mat(ctx2.is_left_trigger_stim_modulated) == 1,:);
    ctx2_suppressed = ctx2(cell2mat(ctx2.is_left_trigger_stim_modulated) == -1,:);
    ctx2_nonenconding = ctx2(cell2mat(ctx2.is_left_trigger_stim_modulated) == 0,:);

    fig_path = strcat(out_path, 'Cortex/');
    mkdir(fig_path)

    % keyboard
    after_signals = {{'left_trigger_aligned_avg_psth_afterHit', 'left_trigger_aligned_avg_psth_afterCR', 'left_trigger_aligned_avg_psth_afterMiss', 'left_trigger_aligned_avg_psth_afterFA'}, ...
        {'right_trigger_aligned_avg_psth_afterHit', 'right_trigger_aligned_avg_psth_afterCR', 'right_trigger_aligned_avg_psth_afterMiss', 'right_trigger_aligned_avg_psth_afterFA'}};
    % compareFRsByPreviousOutcome(ctx1, ctx2, after_signals, ctx_regions, 'Cortex: All', false, fig_path)
    % compareFRsByPreviousOutcome(ctx1_driven, ctx2_driven, after_signals, ctx_regions, 'Cortex: Driven', false, fig_path)
    % compareFRsByPreviousOutcome(ctx1_suppressed, ctx2_driven, after_signals, ctx_regions, 'Cortex: Suppressed', false, fig_path)
    compareFRsByPreviousOutcome(ctx1_nonenconding, ctx2_nonenconding, after_signals, ctx_regions, 'Cortex: Unmodulated', false, fig_path)

    compareFRsByPrevAndCurrentOutcome(ctx1, ctx2, ctx_regions, 'Cortex: All', false, fig_path)
    compareFRsByPrevAndCurrentOutcome(ctx1_driven, ctx2_driven, ctx_regions, 'Cortex: Driven', false, fig_path)
    compareFRsByPrevAndCurrentOutcome(ctx1_suppressed, ctx2_suppressed, ctx_regions, 'Cortex: Suppressed', false, fig_path)
    compareFRsByPrevAndCurrentOutcome(ctx1_nonencoding, ctx2_nonencoding, ctx_regions, 'Cortex: Unmodulated', false, fig_path)

    % %%% firing rates, all cells, each region 
    % compareCellTypeFRs(ctx1, ctx2, signals, {'3387', '3787'}, 'All', false, fig_path)
    % compareCellTypeFRs(ctx1_driven, ctx2_driven, signals, {'3387', '3787'}, 'Driven', false, fig_path)
    % compareCellTypeFRs(ctx1_suppressed, ctx2_suppressed, signals, {'3387', '3787'}, 'Suppressed', false, fig_path)
    % compareCellTypeFRs(ctx1_nonenconding, ctx2_nonenconding, signals, {'3387', '3787'}, 'Unmodulated', false, fig_path)

    % %%% firing rates, all cells, across regions 
    % compareRegionalCellTypeFRs(ctx1, ctx2, signals, ctx_regions, 'Cortex: All', false, fig_path)
    % compareRegionalCellTypeFRs(ctx1_driven, ctx2_driven, signals, ctx_regions, 'Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeFRs(ctx1_suppressed, ctx2_suppressed, signals, ctx_regions, 'Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeFRs(ctx1_nonenconding, ctx2_nonenconding, signals, ctx_regions, 'Cortex: Unmodulated', false, fig_path)

    % %%% firing rates, all cells, each region, zscore
    % compareCellTypeZscoreFRs(ctx1, ctx2, signals, {'3387', '3787'}, 'All', false, fig_path)
    % compareCellTypeZscoreFRs(ctx1_driven, ctx2_driven, signals, {'3387', '3787'}, 'Driven', false, fig_path)
    % compareCellTypeZscoreFRs(ctx1_suppressed, ctx2_suppressed, signals, {'3387', '3787'}, 'Suppressed', false, fig_path)
    % compareCellTypeZscoreFRs(ctx1_nonenconding, ctx2_nonenconding, signals, {'3387', '3787'}, 'Unmodulated', false, fig_path)

    % %%% firing rates, all cells, across regions, zscore
    % compareRegionalCellTypeZscoreFRs(ctx1, ctx2, signals, ctx_regions, 'Cortex: All', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(ctx1_driven, ctx2_driven, signals, ctx_regions, 'Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(ctx1_suppressed, ctx2_suppressed, signals, ctx_regions, 'Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(ctx1_nonenconding, ctx2_nonenconding, signals, ctx_regions, 'Cortex: Unmodulated', false, fig_path)

    % %%% baseline firing rates, all cells, each region 
    % compareCellTypeAvgBaselineFR(ctx1, ctx2, 'All', false, fig_path)
    % compareCellTypeAvgBaselineFR(ctx1_driven, ctx2_driven, 'Driven', false, fig_path)
    % compareCellTypeAvgBaselineFR(ctx1_suppressed, ctx2_suppressed, 'Suppressed', false, fig_path)
    % compareCellTypeAvgBaselineFR(ctx1_nonenconding, ctx2_nonenconding, 'Unmodulated', false, fig_path)

    % %%% baseline firing rates, all cells, each region 
    % compareRegionalCellTypeAvgBaselineFR(ctx1, ctx2, ctx_regions, 'Cortex: All', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(ctx1_driven, ctx2_driven, ctx_regions, 'Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(ctx1_suppressed, ctx2_suppressed, ctx_regions, 'Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(ctx1_nonenconding, ctx2_nonenconding, ctx_regions, 'Cortex: Unmodulated', false, fig_path)

    % %%% AUROC, all cells, each region 
    % compareCellTypeAUROC(ctx1, ctx2, 'All', false, fig_path)
    % compareCellTypeAUROC(ctx1_driven, ctx2_driven, 'Driven', false, fig_path)
    % compareCellTypeAUROC(ctx1_suppressed, ctx2_suppressed, 'Suppressed', false, fig_path)
    % compareCellTypeAUROC(ctx1_nonenconding, ctx2_nonenconding, 'Unmodulated', false, fig_path)

    % %%% AUROC, all cells, each region 
    % compareRegionalCellTypeAUROC(ctx1, ctx2, ctx_regions, 'Cortex: All', false, fig_path)
    % compareRegionalCellTypeAUROC(ctx1_driven, ctx2_driven, ctx_regions, 'Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeAUROC(ctx1_suppressed, ctx2_suppressed, ctx_regions, 'Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeAUROC(ctx1_nonenconding, ctx2_nonenconding, ctx_regions, 'Cortex: Unmodulated', false, fig_path)

    % %% superficial cortex 
    % superficial_ctx_regions = ctx_regions(contains(ctx_regions, '1') | contains(ctx_regions, '2') | contains(ctx_regions, '3'));

    % %%% firing rates, all cells, across regions 
    % compareRegionalCellTypeFRs(ctx1, ctx2, signals, superficial_ctx_regions, 'L1-3 Cortex: All', false, fig_path)
    % compareRegionalCellTypeFRs(ctx1_driven, ctx2_driven, signals, superficial_ctx_regions, 'L1-3 Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeFRs(ctx1_suppressed, ctx2_suppressed, signals, superficial_ctx_regions, 'L1-3 Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeFRs(ctx1_nonenconding, ctx2_nonenconding, signals, superficial_ctx_regions, 'L1-3 Cortex: Unmodulated', false, fig_path)

    % %% firing rates, all cells, across regions, zscore
    % compareRegionalCellTypeZscoreFRs(ctx1, ctx2, signals, superficial_ctx_regions, 'L1-3 Cortex: All', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(ctx1_driven, ctx2_driven, signals, superficial_ctx_regions, 'L1-3 Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(ctx1_suppressed, ctx2_suppressed, signals, superficial_ctx_regions, 'L1-3 Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(ctx1_nonenconding, ctx2_nonenconding, signals, superficial_ctx_regions, 'L1-3 Cortex: Unmodulated', false, fig_path)

    % %% baseline firing rates, all cells, each region 
    % compareRegionalCellTypeAvgBaselineFR(ctx1, ctx2, superficial_ctx_regions, 'L1-3 Cortex: All', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(ctx1_driven, ctx2_driven, superficial_ctx_regions, 'L1-3 Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(ctx1_suppressed, ctx2_suppressed, superficial_ctx_regions, 'L1-3 Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(ctx1_nonenconding, ctx2_nonenconding, superficial_ctx_regions, 'L1-3 Cortex: Unmodulated', false, fig_path)

    % %% AUROC, all cells, each region 
    % compareRegionalCellTypeAUROC(ctx1, ctx2, superficial_ctx_regions, 'L1-3 Cortex: All', false, fig_path)
    % compareRegionalCellTypeAUROC(ctx1_driven, ctx2_driven, superficial_ctx_regions, 'L1-3 Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeAUROC(ctx1_suppressed, ctx2_suppressed, superficial_ctx_regions, 'L1-3 Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeAUROC(ctx1_nonenconding, ctx2_nonenconding, superficial_ctx_regions, 'L1-3 Cortex: Unmodulated', false, fig_path)

    % %% superficial cortex 
    % semi_superficial_ctx_regions = ctx_regions(contains(ctx_regions, '1') | contains(ctx_regions, '2') | contains(ctx_regions, '3') | contains(ctx_regions, '4'));

    % %%% firing rates, all cells, across regions 
    % compareRegionalCellTypeFRs(ctx1, ctx2, signals, semi_superficial_ctx_regions, 'L1-4 Cortex: All', false, fig_path)
    % compareRegionalCellTypeFRs(ctx1_driven, ctx2_driven, signals, semi_superficial_ctx_regions, 'L1-4 Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeFRs(ctx1_suppressed, ctx2_suppressed, signals, semi_superficial_ctx_regions, 'L1-4 Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeFRs(ctx1_nonenconding, ctx2_nonenconding, signals, semi_superficial_ctx_regions, 'L1-4 Cortex: Unmodulated', false, fig_path)

    % %% firing rates, all cells, across regions, zscore
    % compareRegionalCellTypeZscoreFRs(ctx1, ctx2, signals, semi_superficial_ctx_regions, 'L1-4 Cortex: All', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(ctx1_driven, ctx2_driven, signals, semi_superficial_ctx_regions, 'L1-4 Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(ctx1_suppressed, ctx2_suppressed, signals, semi_superficial_ctx_regions, 'L1-4 Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(ctx1_nonenconding, ctx2_nonenconding, signals, semi_superficial_ctx_regions, 'L1-4 Cortex: Unmodulated', false, fig_path)

    % %% baseline firing rates, all cells, each region 
    % compareRegionalCellTypeAvgBaselineFR(ctx1, ctx2, semi_superficial_ctx_regions, 'L1-4 Cortex: All', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(ctx1_driven, ctx2_driven, semi_superficial_ctx_regions, 'L1-4 Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(ctx1_suppressed, ctx2_suppressed, semi_superficial_ctx_regions, 'L1-4 Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(ctx1_nonenconding, ctx2_nonenconding, semi_superficial_ctx_regions, 'L1-4 Cortex: Unmodulated', false, fig_path)

    % %% AUROC, all cells, each region 
    % compareRegionalCellTypeAUROC(ctx1, ctx2, semi_superficial_ctx_regions, 'L1-4 Cortex: All', false, fig_path)
    % compareRegionalCellTypeAUROC(ctx1_driven, ctx2_driven, semi_superficial_ctx_regions, 'L1-4 Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeAUROC(ctx1_suppressed, ctx2_suppressed, semi_superficial_ctx_regions, 'L1-4 Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeAUROC(ctx1_nonenconding, ctx2_nonenconding, semi_superficial_ctx_regions, 'L1-4 Cortex: Unmodulated', false, fig_path)

    % %% deep cortex 
    % deep_ctx_regions = ctx_regions(contains(ctx_regions, '5') | contains(ctx_regions, '6'));

    % %%% firing rates, all cells, across regions 
    % compareRegionalCellTypeFRs(ctx1, ctx2, signals, deep_ctx_regions, 'L5-6 Cortex: All', false, fig_path)
    % compareRegionalCellTypeFRs(ctx1_driven, ctx2_driven, signals, deep_ctx_regions, 'L5-6 Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeFRs(ctx1_suppressed, ctx2_suppressed, signals, deep_ctx_regions, 'L5-6 Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeFRs(ctx1_nonenconding, ctx2_nonenconding, signals, deep_ctx_regions, 'L5-6 Cortex: Unmodulated', false, fig_path)

    % %% firing rates, all cells, across regions, zscore
    % compareRegionalCellTypeZscoreFRs(ctx1, ctx2, signals, deep_ctx_regions, 'L5-6 Cortex: All', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(ctx1_driven, ctx2_driven, signals, deep_ctx_regions, 'L5-6 Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(ctx1_suppressed, ctx2_suppressed, signals, deep_ctx_regions, 'L5-6 Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(ctx1_nonenconding, ctx2_nonenconding, signals, deep_ctx_regions, 'L5-6 Cortex: Unmodulated', false, fig_path)

    % %% baseline firing rates, all cells, each region 
    % compareRegionalCellTypeAvgBaselineFR(ctx1, ctx2, deep_ctx_regions, 'L5-6 Cortex: All', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(ctx1_driven, ctx2_driven, deep_ctx_regions, 'L5-6 Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(ctx1_suppressed, ctx2_suppressed, deep_ctx_regions, 'L5-6 Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(ctx1_nonenconding, ctx2_nonenconding, deep_ctx_regions, 'L5-6 Cortex: Unmodulated', false, fig_path)

    % %% AUROC, all cells, each region 
    % compareRegionalCellTypeAUROC(ctx1, ctx2, deep_ctx_regions, 'L5-6 Cortex: All', false, fig_path)
    % compareRegionalCellTypeAUROC(ctx1_driven, ctx2_driven, deep_ctx_regions, 'L5-6 Cortex: Driven', false, fig_path)
    % compareRegionalCellTypeAUROC(ctx1_suppressed, ctx2_suppressed, deep_ctx_regions, 'L5-6 Cortex: Suppressed', false, fig_path)
    % compareRegionalCellTypeAUROC(ctx1_nonenconding, ctx2_nonenconding, deep_ctx_regions, 'L5-6 Cortex: Unmodulated', false, fig_path)

    close all

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% striatum
    striatum_regions = {'STR', 'CP'};
    striatum_inds = strcmp(ftr1.ap_ftr.region, 'STR') + strcmp(ftr1.ap_ftr.region, 'CP');
    striatum1 = ftr1.ap_ftr(logical(striatum_inds), :);
    striatum1_driven = striatum1(cell2mat(striatum1.is_left_trigger_stim_modulated) == 1,:);
    striatum1_suppressed = striatum1(cell2mat(striatum1.is_left_trigger_stim_modulated) == -1,:);
    striatum1_nonenconding = striatum1(cell2mat(striatum1.is_left_trigger_stim_modulated) == 0,:);

    striatum_inds = strcmp(ftr2.ap_ftr.region, 'STR') + strcmp(ftr2.ap_ftr.region, 'CP');
    striatum2 = ftr2.ap_ftr(logical(striatum_inds), :);
    striatum2_driven = striatum2(cell2mat(striatum2.is_left_trigger_stim_modulated) == 1,:);
    striatum2_suppressed = striatum2(cell2mat(striatum2.is_left_trigger_stim_modulated) == -1,:);
    striatum2_nonenconding = striatum2(cell2mat(striatum2.is_left_trigger_stim_modulated) == 0,:);

    fig_path = strcat(out_path, 'Basal_Ganglia/');
    mkdir(fig_path)

    % compareFRsByPreviousOutcome(striatum1, striatum2, after_signals, striatum_regions, 'Basal Ganglia: All', false, fig_path)
    % compareFRsByPreviousOutcome(striatum1_driven, striatum2_driven, after_signals, striatum_regions, 'Basal Ganglia: Driven', false, fig_path)
    % compareFRsByPreviousOutcome(striatum1_suppressed, striatum2_driven, after_signals, striatum_regions, 'Basal Ganglia: Suppressed', false, fig_path)
    compareFRsByPreviousOutcome(striatum1_nonenconding, striatum2_nonenconding, after_signals, striatum_regions, 'Basal Ganglia: Unmodulated', false, fig_path)

    compareFRsByPrevAndCurrentOutcome(striatum1, striatum2, striatum_regions, 'Basal Ganglia: All', false, fig_path)
    compareFRsByPrevAndCurrentOutcome(striatum1_driven, striatum2_driven, striatum_regions, 'Basal Ganglia: Driven', false, fig_path)
    compareFRsByPrevAndCurrentOutcome(striatum1_suppressed, striatum2_suppressed, striatum_regions, 'Basal Ganglia: Suppressed', false, fig_path)
    compareFRsByPrevAndCurrentOutcome(striatum1_nonencoding, striatum2_nonencoding, striatum_regions, 'Basal Ganglia: Unmodulated', false, fig_path)

    % %%% all cells, each region 
    % compareCellTypeFRs(striatum1, striatum2, signals, {'3387', '3787'}, 'All', false, fig_path)
    % compareCellTypeFRs(striatum1_driven, striatum2_driven, signals, {'3387', '3787'}, 'Driven', false, fig_path)
    % compareCellTypeFRs(striatum1_suppressed, striatum2_suppressed, signals, {'3387', '3787'}, 'Suppressed', false, fig_path)
    % compareCellTypeFRs(striatum1_nonenconding, striatum2_nonenconding, signals, {'3387', '3787'}, 'Unmodulated', false, fig_path)

    % %%% all cells across regions 
    % compareRegionalCellTypeFRs(striatum1, striatum2, signals, striatum_regions, 'Basal Ganglia: All', false, fig_path)
    % compareRegionalCellTypeFRs(striatum1_driven, striatum2_driven, signals, striatum_regions, 'Basal Ganglia: Driven', false, fig_path)
    % compareRegionalCellTypeFRs(striatum1_suppressed, striatum2_suppressed, signals, striatum_regions, 'Basal Ganglia: Suppressed', false, fig_path)
    % compareRegionalCellTypeFRs(striatum1_nonenconding, striatum2_nonenconding, signals, striatum_regions, 'Basal Ganglia: Unmodulated', false, fig_path)

    % %%% baseline firing rates, all cells, each region 
    % compareCellTypeAvgBaselineFR(striatum1, striatum2, 'All', false, fig_path)
    % compareCellTypeAvgBaselineFR(striatum1_driven, striatum2_driven, 'Driven', false, fig_path)
    % compareCellTypeAvgBaselineFR(striatum1_suppressed, striatum2_suppressed, 'Suppressed', false, fig_path)
    % compareCellTypeAvgBaselineFR(striatum1_nonenconding, striatum2_nonenconding, 'Unmodulated', false, fig_path)

    % %%% baseline firing rates, all cells, each region 
    % compareRegionalCellTypeAvgBaselineFR(striatum1, striatum2, striatum_regions, 'Basal Ganglia: All', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(striatum1_driven, striatum2_driven, striatum_regions, 'Basal Ganglia: Driven', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(striatum1_suppressed, striatum2_suppressed, striatum_regions, 'Basal Ganglia: Suppressed', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(striatum1_nonenconding, striatum2_nonenconding, striatum_regions, 'Basal Ganglia: Unmodulated', false, fig_path)

    % %%% AUROC, all cells, each region 
    % compareCellTypeAUROC(striatum1, striatum2, 'All', false, fig_path)
    % compareCellTypeAUROC(striatum1_driven, striatum2_driven, 'Driven', false, fig_path)
    % compareCellTypeAUROC(striatum1_suppressed, striatum2_suppressed, 'Suppressed', false, fig_path)
    % compareCellTypeAUROC(striatum1_nonenconding, striatum2_nonenconding, 'Unmodulated', false, fig_path)

    % %%% AUROC, all cells, each region 
    % compareRegionalCellTypeAUROC(striatum1, striatum2, striatum_regions, 'Basal Ganglia: All', false, fig_path)
    % compareRegionalCellTypeAUROC(striatum1_driven, striatum2_driven, striatum_regions, 'Basal Ganglia: Driven', false, fig_path)
    % compareRegionalCellTypeAUROC(striatum1_suppressed, striatum2_suppressed, striatum_regions, 'Striatuml: Suppressed', false, fig_path)
    % compareRegionalCellTypeAUROC(striatum1_nonenconding, striatum2_nonenconding, striatum_regions, 'Basal Ganglia: Unmodulated', false, fig_path)

    % %%% firing rates, all cells, each region, zscore
    % compareCellTypeZscoreFRs(striatum1, striatum2, signals, {'3387', '3787'}, 'All', false, fig_path)
    % compareCellTypeZscoreFRs(striatum1_driven, striatum2_driven, signals, {'3387', '3787'}, 'Driven', false, fig_path)
    % compareCellTypeZscoreFRs(striatum1_suppressed, striatum2_suppressed, signals, {'3387', '3787'}, 'Suppressed', false, fig_path)
    % compareCellTypeZscoreFRs(striatum1_nonenconding, striatum2_nonenconding, signals, {'3387', '3787'}, 'Unmodulated', false, fig_path)

    % %%% firing rates, all cells, across regions, zscore
    % compareRegionalCellTypeZscoreFRs(striatum1, striatum2, signals, striatum_regions, 'Basal Ganglia: All', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(striatum1_driven, striatum2_driven, signals, striatum_regions, 'Basal Ganglia: Driven', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(striatum1_suppressed, striatum2_suppressed, signals, striatum_regions, 'Basal Ganglia: Suppressed', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(striatum1_nonenconding, striatum2_nonenconding, signals, striatum_regions, 'Basal Ganglia: Unmodulated', false, fig_path)

    close all

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% amygdala
    amygdala_regions = {'BLAp', 'LA'};
    amygdala_inds = strcmp(ftr1.ap_ftr.region, 'BLAp') + strcmp(ftr1.ap_ftr.region, 'LA');
    amygdala1 = ftr1.ap_ftr(logical(amygdala_inds), :);
    amygdala1_driven = amygdala1(cell2mat(amygdala1.is_left_trigger_stim_modulated) == 1,:);
    amygdala1_suppressed = amygdala1(cell2mat(amygdala1.is_left_trigger_stim_modulated) == -1,:);
    amygdala1_nonenconding = amygdala1(cell2mat(amygdala1.is_left_trigger_stim_modulated) == 0,:);

    amygdala_inds = strcmp(ftr2.ap_ftr.region, 'BLAp') + strcmp(ftr2.ap_ftr.region, 'LA');
    amygdala2 = ftr2.ap_ftr(logical(amygdala_inds), :);
    amygdala2_driven = amygdala2(cell2mat(amygdala2.is_left_trigger_stim_modulated) == 1,:);
    amygdala2_suppressed = amygdala2(cell2mat(amygdala2.is_left_trigger_stim_modulated) == -1,:);
    amygdala2_nonenconding = amygdala2(cell2mat(amygdala2.is_left_trigger_stim_modulated) == 0,:);

    fig_path = strcat(out_path, 'Amygdala/');
    mkdir(fig_path)

    % compareFRsByPreviousOutcome(amygdala1, amygdala2, after_signals, amygdala_regions, 'Amygdala: All', false, fig_path)
    % compareFRsByPreviousOutcome(amygdala1_driven, amygdala2_driven, after_signals, amygdala_regions, 'Amygdala: Driven', false, fig_path)
    % compareFRsByPreviousOutcome(amygdala1_suppressed, amygdala2_driven, after_signals, amygdala_regions, 'Amygdala: Suppressed', false, fig_path)
    compareFRsByPreviousOutcome(amygdala1_nonenconding, amygdala2_nonenconding, after_signals, amygdala_regions, 'Amygdala: Unmodulated', false, fig_path)

    compareFRsByPrevAndCurrentOutcome(amygdala1, amygdala2, amygdala_regions, 'Amygdala: All', false, fig_path)
    compareFRsByPrevAndCurrentOutcome(amygdala1_driven, amygdala2_driven, amygdala_regions, 'Amygdala: Driven', false, fig_path)
    compareFRsByPrevAndCurrentOutcome(amygdala1_suppressed, amygdala2_suppressed, amygdala_regions, 'Amygdala: Suppressed', false, fig_path)
    compareFRsByPrevAndCurrentOutcome(amygdala1_nonencoding, amygdala2_nonencoding, amygdala_regions, 'Amygdala: Unmodulated', false, fig_path)

    % %%% all cells, each region 
    % compareCellTypeFRs(amygdala1, amygdala2, signals, {'3387', '3787'}, 'All', false, fig_path)
    % compareCellTypeFRs(amygdala1_driven, amygdala2_driven, signals, {'3387', '3787'}, 'Driven', false, fig_path)
    % compareCellTypeFRs(amygdala1_suppressed, amygdala2_suppressed, signals, {'3387', '3787'}, 'Suppressed', false, fig_path)
    % compareCellTypeFRs(amygdala1_nonenconding, amygdala2_nonenconding, signals, {'3387', '3787'}, 'Unmodulated', false, fig_path)

    % %%% all cells across regions 
    % compareRegionalCellTypeFRs(amygdala1, amygdala2, signals, amygdala_regions, 'Amygdala: All', false, fig_path)
    % compareRegionalCellTypeFRs(amygdala1_driven, amygdala2_driven, signals, amygdala_regions, 'Amygdala: Driven', false, fig_path)
    % compareRegionalCellTypeFRs(amygdala1_suppressed, amygdala2_suppressed, signals, amygdala_regions, 'Amygdala: Suppressed', false, fig_path)
    % compareRegionalCellTypeFRs(amygdala1_nonenconding, amygdala2_nonenconding, signals, amygdala_regions, 'Amygdala: Unmodulated', false, fig_path)

    % %%% baseline firing rates, all cells, each region 
    % compareCellTypeAvgBaselineFR(amygdala1, amygdala2, 'All', false, fig_path)
    % compareCellTypeAvgBaselineFR(amygdala1_driven, amygdala2_driven, 'Driven', false, fig_path)
    % compareCellTypeAvgBaselineFR(amygdala1_suppressed, amygdala2_suppressed, 'Suppressed', false, fig_path)
    % compareCellTypeAvgBaselineFR(amygdala1_nonenconding, amygdala2_nonenconding, 'Unmodulated', false, fig_path)

    % %%% baseline firing rates, all cells, each region 
    % compareRegionalCellTypeAvgBaselineFR(amygdala1, amygdala2, amygdala_regions, 'Amygdala: All', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(amygdala1_driven, amygdala2_driven, amygdala_regions, 'Amygdala: Driven', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(amygdala1_suppressed, amygdala2_suppressed, amygdala_regions, 'Amygdala: Suppressed', false, fig_path)
    % compareRegionalCellTypeAvgBaselineFR(amygdala1_nonenconding, amygdala2_nonenconding, striatum_regions, 'Amygdala: Unmodulated', false, fig_path)

    % %%% AUROC, all cells, each region 
    % compareCellTypeAUROC(amygdala1, amygdala2, 'All', false, fig_path)
    % compareCellTypeAUROC(amygdala1_driven, amygdala2_driven, 'Driven', false, fig_path)
    % compareCellTypeAUROC(amygdala1_suppressed, amygdala2_suppressed, 'Suppressed', false, fig_path)
    % compareCellTypeAUROC(amygdala1_nonenconding, amygdala2_nonenconding, 'Unmodulated', false, fig_path)

    % %%% AUROC, all cells, each region 
    % compareRegionalCellTypeAUROC(amygdala1, amygdala2, amygdala_regions, 'Amygdala: All', false, fig_path)
    % compareRegionalCellTypeAUROC(amygdala1_driven, amygdala2_driven, amygdala_regions, 'Amygdala: Driven', false, fig_path)
    % compareRegionalCellTypeAUROC(amygdala1_suppressed, amygdala2_suppressed, amygdala_regions, 'Amygdala: Suppressed', false, fig_path)
    % compareRegionalCellTypeAUROC(amygdala1_nonenconding, amygdala2_nonenconding, amygdala_regions, 'Amygdala: Unmodulated', false, fig_path)

    % %%% firing rates, all cells, each region, zscore
    % compareCellTypeZscoreFRs(amygdala1, amygdala2, signals, {'3387', '3787'}, 'All', false, fig_path)
    % compareCellTypeZscoreFRs(amygdala1_driven, amygdala2_driven, signals, {'3387', '3787'}, 'Driven', false, fig_path)
    % compareCellTypeZscoreFRs(amygdala1_suppressed, amygdala2_suppressed, signals, {'3387', '3787'}, 'Suppressed', false, fig_path)
    % compareCellTypeZscoreFRs(amygdala1_nonenconding, amygdala2_nonenconding, signals, {'3387', '3787'}, 'Unmodulated', false, fig_path)

    % %%% firing rates, all cells, across regions, zscore
    % compareRegionalCellTypeZscoreFRs(amygdala1, amygdala2, signals, amygdala_regions, 'Amygdala: All', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(amygdala1_driven, amygdala2_driven, signals, amygdala_regions, 'Amygdala: Driven', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(amygdala1_suppressed, amygdala2_suppressed, signals, amygdala_regions, 'Amygdala: Suppressed', false, fig_path)
    % compareRegionalCellTypeZscoreFRs(amygdala1_nonenconding, amygdala2_nonenconding, signals, amygdala_regions, 'Amygdala: Unmodulated', false, fig_path)

    close all
end