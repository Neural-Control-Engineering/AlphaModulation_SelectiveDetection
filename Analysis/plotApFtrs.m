function plotApFtrs(ftr_files, out_path, signals, probeType)
    % combine animals
    for i = 1:length(ftr_files)
        f = load(ftr_files{i});
        if i == 1
            ftrs = f.ap_ftr;
        else
            ftrs = combineTables(ftrs, f.ap_ftr);
        end
    end

    mkdir(out_path)
    
    if strcmp(probeType, 'S1')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% cortex 
        all_regions = unique(ftrs.region);
        ctx_regions = all_regions(startsWith(all_regions,'SS'));
        ctx = ftrs(startsWith(ftrs.region, 'SS'),:);
        ctx_driven = ctx(cell2mat(ctx.is_left_trigger_stim_modulated) == 1,:);
        ctx_suppressed = ctx(cell2mat(ctx.is_left_trigger_stim_modulated) == -1,:);
        ctx_nonencoding = ctx(cell2mat(ctx.is_left_trigger_stim_modulated) == 0,:);

        fig_path = strcat(out_path, 'Cortex/');
        mkdir(fig_path)

        % %%% all cells, each region 
        % cellTypeFRs(ctx, signals, 'All', false, fig_path)
        % cellTypeFRs(ctx_driven, signals, 'Driven', false, fig_path)
        % cellTypeFRs(ctx_suppressed, signals, 'Suppressed', false, fig_path)
        % cellTypeFRs(ctx_nonencoding, signals, 'Unmodulated', false, fig_path)

        % %%% all cells across regions 
        % regionalCellTypeFRs(ctx, signals, ctx_regions, 'All Cortical', false, fig_path)
        % regionalCellTypeFRs(ctx_driven, signals, ctx_regions, 'Cortex: Driven', false, fig_path)
        % regionalCellTypeFRs(ctx_suppressed, signals, ctx_regions, 'Cortex: Suppressed', false, fig_path)
        % regionalCellTypeFRs(ctx_nonencoding, signals, ctx_regions, 'Cottex: Unmodulated', false, fig_path)

        % %%% all cells, each region 
        % cellTypeZscoreFRs(ctx, signals, 'All', false, fig_path)
        % cellTypeZscoreFRs(ctx_driven, signals, 'Driven', false, fig_path)
        % cellTypeZscoreFRs(ctx_suppressed, signals, 'Suppressed', false, fig_path)
        % cellTypeZscoreFRs(ctx_nonencoding, signals, 'Unmodulated', false, fig_path)

        % %%% all cells across regions 
        % regionalCellTypeZscoreFRs(ctx, signals, ctx_regions, 'Cortex: All', false, fig_path)
        % regionalCellTypeZscoreFRs(ctx_driven, signals, ctx_regions, 'Cortex: Driven', false, fig_path)
        % regionalCellTypeZscoreFRs(ctx_suppressed, signals, ctx_regions, 'Cortex: Suppressed', false, fig_path)
        % regionalCellTypeZscoreFRs(ctx_nonencoding, signals, ctx_regions, 'Cortex: Unmodulated', false, fig_path)

        % %%% baseline firing rates, all cells, each region 
        % cellTypeAvgBaselineFR(ctx, 'All', false, fig_path)
        % cellTypeAvgBaselineFR(ctx_driven, 'Driven', false, fig_path)
        % cellTypeAvgBaselineFR(ctx_suppressed, 'Suppressed', false, fig_path)
        % cellTypeAvgBaselineFR(ctx_nonencoding, 'Unmodulated', false, fig_path)

        % %%% baseline firing rates, all cells, across regions
        % regionalCellTypeAvgBaselineFR(ctx, ctx_regions, 'Cortex: All', false, fig_path)
        % regionalCellTypeAvgBaselineFR(ctx_driven, ctx_regions, 'Cortex: Driven', false, fig_path)
        % regionalCellTypeAvgBaselineFR(ctx_suppressed, ctx_regions, 'Cortex: Suppressed', false, fig_path)
        % regionalCellTypeAvgBaselineFR(ctx_nonencoding, ctx_regions, 'Cortex: Unmodulated', false, fig_path)

        % %%% AUROC, all cells, each region 
        % cellTypeAUROC(ctx, 'All', false, fig_path)
        % cellTypeAUROC(ctx_driven, 'Driven', false, fig_path)
        % cellTypeAUROC(ctx_suppressed, 'Suppressed', false, fig_path)
        % cellTypeAUROC(ctx_nonencoding, 'Unmodulated', false, fig_path)

        % %%% AUROC, all cells, across regions 
        % regionalCellTypeAUROC(ctx, ctx_regions, 'Cortex: All', false, fig_path)
        % regionalCellTypeAUROC(ctx_driven, ctx_regions, 'Cortex: Driven', false, fig_path)
        % regionalCellTypeAUROC(ctx_suppressed, ctx_regions, 'Cortex: Suppressed', false, fig_path)
        % regionalCellTypeAUROC(ctx_nonencoding, ctx_regions, 'Cortex: Unmodulated', false, fig_path)

        % %%% lfp modulated cells 
        % deltaModulation(ctx, false, fig_path)
        % alphaModulation(ctx, false, fig_path)
        % thetaModulation(ctx, false, fig_path)
        % betaModulation(ctx, false, fig_path)

        % %%% spontaneous CV by outcome, all cells, each region
        % regionalCellTypeSpontaneousCV(ctx, ctx_regions, 'Cortex: All', false, fig_path)
        % regionalCellTypeSpontaneousCV(ctx_driven, ctx_regions, 'Cortex: Driven', false, fig_path)
        % regionalCellTypeSpontaneousCV(ctx_suppressed, ctx_regions, 'Cortex: Suppressed', false, fig_path)
        % regionalCellTypeSpontaneousCV(ctx_nonencoding, ctx_regions, 'Cortex: Unmodulated', false, fig_path)
        regionalSpontaneousCV(ctx, ctx_regions, 'Cortex: All', false, fig_path)
        regionalSpontaneousCV(ctx_driven, ctx_regions, 'Cortex: Driven', false, fig_path)
        regionalSpontaneousCV(ctx_suppressed, ctx_regions, 'Cortex: Suppressed', false, fig_path)
        regionalSpontaneousCV(ctx_nonencoding, ctx_regions, 'Cortex: Unmodulated', false, fig_path)

        % % %%% spontaneous CV by outcome, all cells, across regions
        % cellTypeSpontaneousCV(ctx, 'All', false, fig_path)
        % cellTypeSpontaneousCV(ctx_driven, 'Driven', false, fig_path)
        % cellTypeSpontaneousCV(ctx_suppressed, 'Suppressed', false, fig_path)
        % cellTypeSpontaneousCV(ctx_nonencoding, 'Unmodulated', false, fig_path)

        % keyboard

        %% superficial cortex 
        superficial_ctx_regions = ctx_regions(contains(ctx_regions, '1') | contains(ctx_regions, '2') | contains(ctx_regions, '3'));

        % %%% all cells across regions 
        % regionalCellTypeFRs(ctx, signals, superficial_ctx_regions, 'L1-3: All', false, fig_path)
        % regionalCellTypeFRs(ctx_driven, signals, superficial_ctx_regions, 'L1-3: Driven', false, fig_path)
        % regionalCellTypeFRs(ctx_suppressed, signals, superficial_ctx_regions, 'L1-3: Suppressed', false, fig_path)
        % regionalCellTypeFRs(ctx_nonencoding, signals, superficial_ctx_regions, 'L1-3: Unmodulated', false, fig_path)

        % %%% all cells across regions 
        % regionalCellTypeZscoreFRs(ctx, signals, superficial_ctx_regions, 'L1-3: All', false, fig_path)
        % regionalCellTypeZscoreFRs(ctx_driven, signals, superficial_ctx_regions, 'L1-3: Driven', false, fig_path)
        % regionalCellTypeZscoreFRs(ctx_suppressed, signals, superficial_ctx_regions, 'L1-3: Suppressed', false, fig_path)
        % regionalCellTypeZscoreFRs(ctx_nonencoding, signals, superficial_ctx_regions, 'L1-3: Unmodulated', false, fig_path)

        % %%% baseline firing rates, all cells, across regions
        % regionalCellTypeAvgBaselineFR(ctx, superficial_ctx_regions, 'L1-3: All', false, fig_path)
        % regionalCellTypeAvgBaselineFR(ctx_driven, superficial_ctx_regions, 'L1-3: Driven', false, fig_path)
        % regionalCellTypeAvgBaselineFR(ctx_suppressed, superficial_ctx_regions, 'L1-3: Suppressed', false, fig_path)
        % regionalCellTypeAvgBaselineFR(ctx_nonencoding, superficial_ctx_regions, 'L1-3: Unmodulated', false, fig_path)

        % %%% AUROC, all cells, across regions 
        % regionalCellTypeAUROC(ctx, superficial_ctx_regions, 'L1-3: All', false, fig_path)
        % regionalCellTypeAUROC(ctx_driven, superficial_ctx_regions, 'L1-3: Driven', false, fig_path)
        % regionalCellTypeAUROC(ctx_suppressed, superficial_ctx_regions, 'L1-3: Suppressed', false, fig_path)
        % regionalCellTypeAUROC(ctx_nonencoding, superficial_ctx_regions, 'L1-3: Unmodulated', false, fig_path)

        % %%% spontaneous CV by outcome, all cells, each region
        % regionalCellTypeSpontaneousCV(ctx, superficial_ctx_regions, 'L1-3: All', false, fig_path)
        % regionalCellTypeSpontaneousCV(ctx_driven, superficial_ctx_regions, 'L1-3: Driven', false, fig_path)
        % regionalCellTypeSpontaneousCV(ctx_suppressed, superficial_ctx_regions, 'L1-3: Suppressed', false, fig_path)
        % regionalCellTypeSpontaneousCV(ctx_nonencoding, superficial_ctx_regions, 'L1-3: Unmodulated', false, fig_path)
        regionalSpontaneousCV(ctx, superficial_ctx_regions, 'L1-3: All', false, fig_path)
        regionalSpontaneousCV(ctx_driven, superficial_ctx_regions, 'L1-3: Driven', false, fig_path)
        regionalSpontaneousCV(ctx_suppressed, superficial_ctx_regions, 'L1-3: Suppressed', false, fig_path)
        regionalSpontaneousCV(ctx_nonencoding, superficial_ctx_regions, 'L1-3: Unmodulated', false, fig_path)


        %% superficial cortex 
        semi_superficial_ctx_regions = ctx_regions(contains(ctx_regions, '1') | contains(ctx_regions, '2') | contains(ctx_regions, '3') | contains(ctx_regions, '4'));

        % %%% all cells across regions 
        % regionalCellTypeFRs(ctx, signals, semi_superficial_ctx_regions, 'L1-4: All', false, fig_path)
        % regionalCellTypeFRs(ctx_driven, signals, semi_superficial_ctx_regions, 'L1-4: Driven', false, fig_path)
        % regionalCellTypeFRs(ctx_suppressed, signals, semi_superficial_ctx_regions, 'L1-4: Suppressed', false, fig_path)
        % regionalCellTypeFRs(ctx_nonencoding, signals, semi_superficial_ctx_regions, 'L1-4: Unmodulated', false, fig_path)

        % %%% all cells across regions 
        % regionalCellTypeZscoreFRs(ctx, signals, semi_superficial_ctx_regions, 'L1-4: All', false, fig_path)
        % regionalCellTypeZscoreFRs(ctx_driven, signals, semi_superficial_ctx_regions, 'L1-4: Driven', false, fig_path)
        % regionalCellTypeZscoreFRs(ctx_suppressed, signals, semi_superficial_ctx_regions, 'L1-4: Suppressed', false, fig_path)
        % regionalCellTypeZscoreFRs(ctx_nonencoding, signals, semi_superficial_ctx_regions, 'L1-4: Unmodulated', false, fig_path)

        % %%% baseline firing rates, all cells, across regions
        % regionalCellTypeAvgBaselineFR(ctx, semi_superficial_ctx_regions, 'L1-4: All', false, fig_path)
        % regionalCellTypeAvgBaselineFR(ctx_driven, semi_superficial_ctx_regions, 'L1-4: Driven', false, fig_path)
        % regionalCellTypeAvgBaselineFR(ctx_suppressed, semi_superficial_ctx_regions, 'L1-4: Suppressed', false, fig_path)
        % regionalCellTypeAvgBaselineFR(ctx_nonencoding, semi_superficial_ctx_regions, 'L1-4: Unmodulated', false, fig_path)

        % %%% AUROC, all cells, across regions 
        % regionalCellTypeAUROC(ctx, semi_superficial_ctx_regions, 'L1-4: All', false, fig_path)
        % regionalCellTypeAUROC(ctx_driven, semi_superficial_ctx_regions, 'L1-4: Driven', false, fig_path)
        % regionalCellTypeAUROC(ctx_suppressed, semi_superficial_ctx_regions, 'L1-4: Suppressed', false, fig_path)
        % regionalCellTypeAUROC(ctx_nonencoding, semi_superficial_ctx_regions, 'L1-4: Unmodulated', false, fig_path)

        % %%% spontaneous CV by outcome, all cells, each region
        % regionalCellTypeSpontaneousCV(ctx, semi_superficial_ctx_regions, 'L1-4: All', false, fig_path)
        % regionalCellTypeSpontaneousCV(ctx_driven, semi_superficial_ctx_regions, 'L1-4: Driven', false, fig_path)
        % regionalCellTypeSpontaneousCV(ctx_suppressed, semi_superficial_ctx_regions, 'L1-4: Suppressed', false, fig_path)
        % regionalCellTypeSpontaneousCV(ctx_nonencoding, semi_superficial_ctx_regions, 'L1-4: Unmodulated', false, fig_path)
        regionalSpontaneousCV(ctx, semi_superficial_ctx_regions, 'L1-4: All', false, fig_path)
        regionalSpontaneousCV(ctx_driven, semi_superficial_ctx_regions, 'L1-4: Driven', false, fig_path)
        regionalSpontaneousCV(ctx_suppressed, semi_superficial_ctx_regions, 'L1-4: Suppressed', false, fig_path)
        regionalSpontaneousCV(ctx_nonencoding, semi_superficial_ctx_regions, 'L1-4: Unmodulated', false, fig_path)

        %% deep cortex 
        deep_ctx_regions = ctx_regions(contains(ctx_regions, '5') | contains(ctx_regions, '6'));

        % %%% all cells across regions 
        % regionalCellTypeFRs(ctx, signals, deep_ctx_regions, 'L5-6: All', false, fig_path)
        % regionalCellTypeFRs(ctx_driven, signals, deep_ctx_regions, 'L5-6: Driven', false, fig_path)
        % regionalCellTypeFRs(ctx_suppressed, signals, deep_ctx_regions, 'L5-6: Suppressed', false, fig_path)
        % regionalCellTypeFRs(ctx_nonencoding, signals, deep_ctx_regions, 'L5-6: Unmodulated', false, fig_path)

        % %%% all cells across regions 
        % regionalCellTypeZscoreFRs(ctx, signals, deep_ctx_regions, 'L5-6: All', false, fig_path)
        % regionalCellTypeZscoreFRs(ctx_driven, signals, deep_ctx_regions, 'L5-6: Driven', false, fig_path)
        % regionalCellTypeZscoreFRs(ctx_suppressed, signals, deep_ctx_regions, 'L5-6: Suppressed', false, fig_path)
        % regionalCellTypeZscoreFRs(ctx_nonencoding, signals, deep_ctx_regions, 'L5-6: Unmodulated', false, fig_path)

        % %%% baseline firing rates, all cells, across regions
        % regionalCellTypeAvgBaselineFR(ctx, deep_ctx_regions, 'L5-6: All', false, fig_path)
        % regionalCellTypeAvgBaselineFR(ctx_driven, deep_ctx_regions, 'L5-6: Driven', false, fig_path)
        % regionalCellTypeAvgBaselineFR(ctx_suppressed, deep_ctx_regions, 'L5-6: Suppressed', false, fig_path)
        % regionalCellTypeAvgBaselineFR(ctx_nonencoding, deep_ctx_regions, 'L5-6: Unmodulated', false, fig_path)

        % %%% AUROC, all cells, across regions 
        % regionalCellTypeAUROC(ctx, deep_ctx_regions, 'L5-6: All', false, fig_path)
        % regionalCellTypeAUROC(ctx_driven, deep_ctx_regions, 'L5-6: Driven', false, fig_path)
        % regionalCellTypeAUROC(ctx_suppressed, deep_ctx_regions, 'L5-6: Suppressed', false, fig_path)
        % regionalCellTypeAUROC(ctx_nonencoding, deep_ctx_regions, 'L5-6: Unmodulated', false, fig_path)

        % %%% spontaneous CV by outcome, all cells, each region
        % regionalCellTypeSpontaneousCV(ctx, deep_ctx_regions, 'L5-6: All', false, fig_path)
        % regionalCellTypeSpontaneousCV(ctx_driven, deep_ctx_regions, 'L5-6: Driven', false, fig_path)
        % regionalCellTypeSpontaneousCV(ctx_suppressed, deep_ctx_regions, 'L5-6: Suppressed', false, fig_path)
        % regionalCellTypeSpontaneousCV(ctx_nonencoding, deep_ctx_regions, 'L5-6: Unmodulated', false, fig_path)
        regionalSpontaneousCV(ctx, deep_ctx_regions, 'L5-6: All', false, fig_path)
        regionalSpontaneousCV(ctx_driven, deep_ctx_regions, 'L5-6: Driven', false, fig_path)
        regionalSpontaneousCV(ctx_suppressed, deep_ctx_regions, 'L5-6: Suppressed', false, fig_path)
        regionalSpontaneousCV(ctx_nonencoding, deep_ctx_regions, 'L5-6: Unmodulated', false, fig_path)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% striatum
        striatum_regions = {'STR', 'CP'};
        striatum_inds = strcmp(ftrs.region, 'STR') + strcmp(ftrs.region, 'CP');
        striatum = ftrs(logical(striatum_inds), :);
        striatum_driven = striatum(cell2mat(striatum.is_left_trigger_stim_modulated) == 1,:);
        striatum_suppressed = striatum(cell2mat(striatum.is_left_trigger_stim_modulated) == -1,:);
        striatum_nonencoding = striatum(cell2mat(striatum.is_left_trigger_stim_modulated) == 0,:);

        fig_path = strcat(out_path, 'Basal_Ganglia/');
        mkdir(fig_path)

        % %%% all cells, each region 
        % cellTypeFRs(striatum, signals, 'All', false, fig_path)
        % cellTypeFRs(striatum_driven, signals, 'Driven', false, fig_path)
        % cellTypeFRs(striatum_suppressed, signals, 'Suppressed', false, fig_path)
        % cellTypeFRs(striatum_nonencoding, signals, 'Unmodulated', false, fig_path)

        % %%% all cells across regions 
        % regionalCellTypeFRs(striatum, signals, striatum_regions, 'Basal Ganglia: All', false, fig_path)
        % regionalCellTypeFRs(striatum_driven, signals, striatum_regions, 'Basal Ganglia: Driven', false, fig_path)
        % regionalCellTypeFRs(striatum_suppressed, signals, striatum_regions, 'Basal Ganglia: Suppressed', false, fig_path)
        % regionalCellTypeFRs(striatum_nonencoding, signals, striatum_regions, 'Basal Ganglia: Unmodulated', false, fig_path)

        % %%% all cells, each region 
        % cellTypeZscoreFRs(striatum, signals, 'All', false, fig_path)
        % cellTypeZscoreFRs(striatum_driven, signals, 'Driven', false, fig_path)
        % cellTypeZscoreFRs(striatum_suppressed, signals, 'Suppressed', false, fig_path)
        % cellTypeZscoreFRs(striatum_nonencoding, signals, 'Unmodulated', false, fig_path)

        % %%% all cells across regions 
        % regionalCellTypeZscoreFRs(striatum, signals, striatum_regions, 'Basal Ganglia: All', false, fig_path)
        % regionalCellTypeZscoreFRs(striatum_driven, signals, striatum_regions, 'Basal Ganglia: Driven', false, fig_path)
        % regionalCellTypeZscoreFRs(striatum_suppressed, signals, striatum_regions, 'Basal Ganglia: Suppressed', false, fig_path)
        % regionalCellTypeZscoreFRs(striatum_nonencoding, signals, striatum_regions, 'Basal Ganglia: Unmodulated', false, fig_path)

        % %%% baseline firing rates, all cells, each region 
        % cellTypeAvgBaselineFR(striatum, 'All', false, fig_path)
        % cellTypeAvgBaselineFR(striatum_driven, 'Driven', false, fig_path)
        % cellTypeAvgBaselineFR(striatum_suppressed, 'Suppressed', false, fig_path)
        % cellTypeAvgBaselineFR(striatum_nonencoding, 'Unmodulated', false, fig_path)

        % %%% baseline firing rates, all cells, across regions 
        % regionalCellTypeAvgBaselineFR(striatum, striatum_regions, 'Basal Ganglia: All', false, fig_path)
        % regionalCellTypeAvgBaselineFR(striatum_driven, striatum_regions, 'Basal Ganglia: Driven', false, fig_path)
        % regionalCellTypeAvgBaselineFR(striatum_suppressed, striatum_regions, 'Basal Ganglia: Suppressed', false, fig_path)
        % regionalCellTypeAvgBaselineFR(striatum_nonencoding, striatum_regions, 'Basal Ganglia: Unmodulated', false, fig_path)

        % %%% AUROC, all cells, each region 
        % cellTypeAUROC(striatum, 'All', false, fig_path)
        % cellTypeAUROC(striatum_driven, 'Driven', false, fig_path)
        % cellTypeAUROC(striatum_suppressed, 'Suppressed', false, fig_path)
        % cellTypeAUROC(striatum_nonencoding, 'Unmodulated', false, fig_path)

        % %%% AUROC, all cells, across regions
        % regionalCellTypeAUROC(striatum, striatum_regions, 'Basal Ganglia: All', false, fig_path)
        % regionalCellTypeAUROC(striatum_driven, striatum_regions, 'Basal Ganglia: Driven', false, fig_path)
        % regionalCellTypeAUROC(striatum_suppressed, striatum_regions, 'Basal Ganglia: Suppressed', false, fig_path)
        % regionalCellTypeAUROC(striatum_nonencoding, striatum_regions, 'Non-Basal Ganglia: Enconding', false, fig_path)

        % %%% lfp modulated cells 
        % deltaModulation(striatum, false, fig_path)
        % alphaModulation(striatum, false, fig_path)
        % thetaModulation(striatum, false, fig_path)
        % betaModulation(striatum, false, fig_path)

        % %%% spontaneous CV by outcome, all cells, each region
        % regionalCellTypeSpontaneousCV(striatum, striatum_regions, 'Basal Ganglia: All', false, fig_path)
        % regionalCellTypeSpontaneousCV(striatum_driven, striatum_regions, 'Basal Ganglia: Driven', false, fig_path)
        % regionalCellTypeSpontaneousCV(striatum_suppressed, striatum_regions, 'Basal Ganglia: Suppressed', false, fig_path)
        % regionalCellTypeSpontaneousCV(striatum_nonencoding, striatum_regions, 'Basal Ganglia: Unmodulated', false, fig_path)
        regionalSpontaneousCV(striatum, striatum_regions, 'Basal Ganglia: All', false, fig_path)
        regionalSpontaneousCV(striatum_driven, striatum_regions, 'Basal Ganglia: Driven', false, fig_path)
        regionalSpontaneousCV(striatum_suppressed, striatum_regions, 'Basal Ganglia: Suppressed', false, fig_path)
        regionalSpontaneousCV(striatum_nonencoding, striatum_regions, 'Basal Ganglia: Unmodulated', false, fig_path)

        % % %%% spontaneous CV by outcome, all cells, across regions
        % cellTypeSpontaneousCV(striatum, 'All', false, fig_path)
        % cellTypeSpontaneousCV(striatum_driven, 'Driven', false, fig_path)
        % cellTypeSpontaneousCV(striatum_suppressed, 'Suppressed', false, fig_path)
        % cellTypeSpontaneousCV(striatum_nonencoding, 'Unmodulated', false, fig_path)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% amygdala
        amygdala_regions = {'BLAp', 'LA'};
        amygdala_inds = strcmp(ftrs.region, 'BLAp') + strcmp(ftrs.region, 'LA');
        amygdala = ftrs(logical(amygdala_inds), :);
        amygdala_driven = amygdala(cell2mat(amygdala.is_left_trigger_stim_modulated) == 1,:);
        amygdala_suppressed = amygdala(cell2mat(amygdala.is_left_trigger_stim_modulated) == -1,:);
        amygdala_nonencoding = amygdala(cell2mat(amygdala.is_left_trigger_stim_modulated) == 0,:);

        fig_path = strcat(out_path, 'Amygdala/');
        mkdir(fig_path)

        % %%% all cells, each region 
        % cellTypeFRs(amygdala, signals, 'All', false, fig_path)
        % cellTypeFRs(amygdala_driven, signals, 'Driven', false, fig_path)
        % cellTypeFRs(amygdala_suppressed, signals, 'Suppressed', false, fig_path)
        % cellTypeFRs(amygdala_nonencoding, signals, 'Unmodulated', false, fig_path)

        % %%% all cells across regions 
        % regionalCellTypeFRs(amygdala, signals, amygdala_regions, 'Amygdala: All', false, fig_path)
        % regionalCellTypeFRs(amygdala_driven, signals, amygdala_regions, 'Amygdala: Driven', false, fig_path)
        % regionalCellTypeFRs(amygdala_suppressed, signals, amygdala_regions, 'Amygdala: Suppressed', false, fig_path)
        % regionalCellTypeFRs(amygdala_nonencoding, signals, amygdala_regions, 'Non-Amygdala: Encoding', false, fig_path)

        % %%% all cells, each region, zscore 
        % cellTypeZscoreFRs(amygdala, signals, 'All', false, fig_path)
        % cellTypeZscoreFRs(amygdala_driven, signals, 'Driven', false, fig_path)
        % cellTypeZscoreFRs(amygdala_suppressed, signals, 'Suppressed', false, fig_path)
        % cellTypeZscoreFRs(amygdala_nonencoding, signals, 'Unmodulated', false, fig_path)

        % %%% all cells across regions, zscore
        % regionalCellTypeZscoreFRs(amygdala, signals, amygdala_regions, 'Amygdala: All', false, fig_path)
        % regionalCellTypeZscoreFRs(amygdala_driven, signals, amygdala_regions, 'Amygdala: Driven', false, fig_path)
        % regionalCellTypeZscoreFRs(amygdala_suppressed, signals, amygdala_regions, 'Amygdala: Suppressed', false, fig_path)
        % regionalCellTypeZscoreFRs(amygdala_nonencoding, signals, amygdala_regions, 'Non-Amygdala: Encoding', false, fig_path)

        % %%% baseline firing rates, all cells, each region 
        % cellTypeAvgBaselineFR(amygdala, 'All', false, fig_path)
        % cellTypeAvgBaselineFR(amygdala_driven, 'Driven', false, fig_path)
        % cellTypeAvgBaselineFR(amygdala_suppressed, 'Suppressed', false, fig_path)
        % cellTypeAvgBaselineFR(amygdala_nonencoding, 'Unmodulated', false, fig_path)

        % %%% baseline firing rates, all cells, across regions
        % regionalCellTypeAvgBaselineFR(amygdala, amygdala_regions, 'Amygdala: All', false, fig_path)
        % regionalCellTypeAvgBaselineFR(amygdala_driven, amygdala_regions, 'Amygdala: Driven', false, fig_path)
        % regionalCellTypeAvgBaselineFR(amygdala_suppressed, amygdala_regions, 'Amygdala: Suppressed', false, fig_path)
        % regionalCellTypeAvgBaselineFR(amygdala_nonencoding, amygdala_regions, 'Amygdala: Unmodulated', false, fig_path)

        % %%% AUROC, all cells, each region 
        % cellTypeAUROC(amygdala, 'All', false, fig_path)
        % cellTypeAUROC(amygdala_driven, 'Driven', false, fig_path)
        % cellTypeAUROC(amygdala_suppressed, 'Suppressed', false, fig_path)
        % cellTypeAUROC(amygdala_nonencoding, 'Unmodulated', false, fig_path)

        % %%% AUROC, all cells, across regions
        % regionalCellTypeAUROC(amygdala, amygdala_regions, 'Amygdala: All', false, fig_path)
        % regionalCellTypeAUROC(amygdala_driven, amygdala_regions, 'Amygdala: Driven', false, fig_path)
        % regionalCellTypeAUROC(amygdala_suppressed, amygdala_regions, 'Amygdala: Suppressed', false, fig_path)
        % regionalCellTypeAUROC(amygdala_nonencoding, amygdala_regions, 'Amygdala: Unmodulated', false, fig_path)

        % %%% lfp modulated cells 
        % deltaModulation(amygdala, false, fig_path)
        % alphaModulation(amygdala, false, fig_path)
        % thetaModulation(amygdala, false, fig_path)
        % betaModulation(amygdala, false, fig_path)

        % %%% spontaneous CV by outcome, all cells, each region
        % regionalCellTypeSpontaneousCV(amygdala, amygdala_regions, 'Amygdala: All', false, fig_path)
        % regionalCellTypeSpontaneousCV(amygdala_driven, amygdala_regions, 'Amygdala: Driven', false, fig_path)
        % regionalCellTypeSpontaneousCV(amygdala_suppressed, amygdala_regions, 'Amygdala: Suppressed', false, fig_path)
        % regionalCellTypeSpontaneousCV(amygdala_nonencoding, amygdala_regions, 'Amygdala: Unmodulated', false, fig_path)
        regionalSpontaneousCV(amygdala, amygdala_regions, 'Amygdala: All', false, fig_path)
        regionalSpontaneousCV(amygdala_driven, amygdala_regions, 'Amygdala: Driven', false, fig_path)
        regionalSpontaneousCV(amygdala_suppressed, amygdala_regions, 'Amygdala: Suppressed', false, fig_path)
        regionalSpontaneousCV(amygdala_nonencoding, amygdala_regions, 'Amygdala: Unmodulated', false, fig_path)

        % % %%% spontaneous CV by outcome, all cells, across regions
        % cellTypeSpontaneousCV(amygdala, 'All', false, fig_path)
        % cellTypeSpontaneousCV(amygdala_driven, 'Driven', false, fig_path)
        % cellTypeSpontaneousCV(amygdala_suppressed, 'Suppressed', false, fig_path)
        % cellTypeSpontaneousCV(amygdala_nonencoding, 'Unmodulated', false, fig_path)
    elseif strcmp(probeType, 'PFC')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% cortex 
        % all_regions = unique(ftrs.region);
        pfc_inds = startsWith(ftrs.region, 'DP') + startsWith(ftrs.region, 'AC') ...
            + startsWith(ftrs.region, 'PL') + startsWith(ftrs.region, 'IL') ...
            + startsWith(ftrs.region, 'OR') + startsWith(ftrs.region, 'MO');
        ctx = ftrs(logical(pfc_inds),:);
        ctx_regions = unique(ctx.region);
        ctx_driven = ctx(cell2mat(ctx.is_left_trigger_stim_modulated) == 1,:);
        ctx_suppressed = ctx(cell2mat(ctx.is_left_trigger_stim_modulated) == -1,:);
        ctx_nonencoding = ctx(cell2mat(ctx.is_left_trigger_stim_modulated) == 0,:);

        fig_path = strcat(out_path, 'Cortex/');
        mkdir(fig_path)

        %%% all cells, each region 
        cellTypeFRs(ctx, signals, 'All', false, fig_path)
        cellTypeFRs(ctx_driven, signals, 'Driven', false, fig_path)
        cellTypeFRs(ctx_suppressed, signals, 'Suppressed', false, fig_path)
        cellTypeFRs(ctx_nonencoding, signals, 'Unmodulated', false, fig_path)

        %%% all cells across regions 
        regionalCellTypeFRs(ctx, signals, ctx_regions, 'All Cortical', false, fig_path)
        regionalCellTypeFRs(ctx_driven, signals, ctx_regions, 'Cortex: Driven', false, fig_path)
        regionalCellTypeFRs(ctx_suppressed, signals, ctx_regions, 'Cortex: Suppressed', false, fig_path)
        regionalCellTypeFRs(ctx_nonencoding, signals, ctx_regions, 'Cottex: Unmodulated', false, fig_path)

        % %%% all cells, each region 
        % cellTypeZscoreFRs(ctx, signals, 'All', false, fig_path)
        % cellTypeZscoreFRs(ctx_driven, signals, 'Driven', false, fig_path)
        % cellTypeZscoreFRs(ctx_suppressed, signals, 'Suppressed', false, fig_path)
        % cellTypeZscoreFRs(ctx_nonencoding, signals, 'Unmodulated', false, fig_path)

        % %%% all cells across regions 
        % regionalCellTypeZscoreFRs(ctx, signals, ctx_regions, 'Cortex: All', false, fig_path)
        % regionalCellTypeZscoreFRs(ctx_driven, signals, ctx_regions, 'Cortex: Driven', false, fig_path)
        % regionalCellTypeZscoreFRs(ctx_suppressed, signals, ctx_regions, 'Cortex: Suppressed', false, fig_path)
        % regionalCellTypeZscoreFRs(ctx_nonencoding, signals, ctx_regions, 'Cortex: Unmodulated', false, fig_path)

        %%% baseline firing rates, all cells, each region 
        cellTypeAvgBaselineFR(ctx, 'All', false, fig_path)
        cellTypeAvgBaselineFR(ctx_driven, 'Driven', false, fig_path)
        cellTypeAvgBaselineFR(ctx_suppressed, 'Suppressed', false, fig_path)
        cellTypeAvgBaselineFR(ctx_nonencoding, 'Unmodulated', false, fig_path)

        %%% baseline firing rates, all cells, across regions
        regionalCellTypeAvgBaselineFR(ctx, ctx_regions, 'Cortex: All', false, fig_path)
        regionalCellTypeAvgBaselineFR(ctx_driven, ctx_regions, 'Cortex: Driven', false, fig_path)
        regionalCellTypeAvgBaselineFR(ctx_suppressed, ctx_regions, 'Cortex: Suppressed', false, fig_path)
        regionalCellTypeAvgBaselineFR(ctx_nonencoding, ctx_regions, 'Cortex: Unmodulated', false, fig_path)

        %%% AUROC, all cells, each region 
        cellTypeAUROC(ctx, 'All', false, fig_path)
        cellTypeAUROC(ctx_driven, 'Driven', false, fig_path)
        cellTypeAUROC(ctx_suppressed, 'Suppressed', false, fig_path)
        cellTypeAUROC(ctx_nonencoding, 'Unmodulated', false, fig_path)

        %%% AUROC, all cells, across regions 
        regionalCellTypeAUROC(ctx, ctx_regions, 'Cortex: All', false, fig_path)
        regionalCellTypeAUROC(ctx_driven, ctx_regions, 'Cortex: Driven', false, fig_path)
        regionalCellTypeAUROC(ctx_suppressed, ctx_regions, 'Cortex: Suppressed', false, fig_path)
        regionalCellTypeAUROC(ctx_nonencoding, ctx_regions, 'Cortex: Unmodulated', false, fig_path)

        % %%% lfp modulated cells 
        % deltaModulation(ctx, false, fig_path)
        % alphaModulation(ctx, false, fig_path)
        % thetaModulation(ctx, false, fig_path)
        % betaModulation(ctx, false, fig_path)

        % %%% spontaneous CV by outcome, all cells, each region
        % regionalCellTypeSpontaneousCV(ctx, ctx_regions, 'Cortex: All', false, fig_path)
        % regionalCellTypeSpontaneousCV(ctx_driven, ctx_regions, 'Cortex: Driven', false, fig_path)
        % regionalCellTypeSpontaneousCV(ctx_suppressed, ctx_regions, 'Cortex: Suppressed', false, fig_path)
        % regionalCellTypeSpontaneousCV(ctx_nonencoding, ctx_regions, 'Cortex: Unmodulated', false, fig_path)
        % regionalSpontaneousCV(ctx, ctx_regions, 'Cortex: All', false, fig_path)
        % regionalSpontaneousCV(ctx_driven, ctx_regions, 'Cortex: Driven', false, fig_path)
        % regionalSpontaneousCV(ctx_suppressed, ctx_regions, 'Cortex: Suppressed', false, fig_path)
        % regionalSpontaneousCV(ctx_nonencoding, ctx_regions, 'Cortex: Unmodulated', false, fig_path)

        % % %%% spontaneous CV by outcome, all cells, across regions
        % cellTypeSpontaneousCV(ctx, 'All', false, fig_path)
        % cellTypeSpontaneousCV(ctx_driven, 'Driven', false, fig_path)
        % cellTypeSpontaneousCV(ctx_suppressed, 'Suppressed', false, fig_path)
        % cellTypeSpontaneousCV(ctx_nonencoding, 'Unmodulated', false, fig_path)
    end

end