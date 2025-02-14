function firingRatesByStimContrast(ap_ftr, slrt_ftr, probe_type, out_path)
    if strcmp(probe_type, 'S1')
        ctx = ap_ftr(startsWith(ap_ftr.region, 'SS'), :);
        ctx_fs = ctx(strcmp(ctx.waveform_class, 'FS'), :);
        ctx_rs = ctx(strcmp(ctx.waveform_class, 'RS'), :);
        ctx_ps = ctx(strcmp(ctx.waveform_class, 'PS'), :);
        ctx_ts = ctx(strcmp(ctx.waveform_class, 'TS'), :);

        ctx_fs_regard_fig = regardlessOfOutcome(ctx_fs, 'Cortex FS');
        ctx_fs_ambig_fig = ambigStim(ctx_fs, 'Cortex FS');
        ctx_fs_contrast_outcome_fig = stimContrastAndOutcome(ctx_fs, 'Cortex FS');
        ctx_fs_outcome_fig = byOutcome(ctx_fs, 'Cortex FS');

        saveas(ctx_fs_regard_fig, strcat(out_path, 'ctx_fs_regard.fig'))
        saveas(ctx_fs_ambig_fig, strcat(out_path, 'ctx_fs_ambig.fig'))
        saveas(ctx_fs_contrast_outcome_fig, strcat(out_path, 'ctx_fs_contrast_outcome.fig'))
        saveas(ctx_fs_outcome_fig, strcat(out_path, 'ctx_fs_outcome.fig'))

        saveas(ctx_fs_regard_fig, strcat(out_path, 'ctx_fs_regard.svg'))
        saveas(ctx_fs_ambig_fig, strcat(out_path, 'ctx_fs_ambig.svg'))
        saveas(ctx_fs_contrast_outcome_fig, strcat(out_path, 'ctx_fs_contrast_outcome.svg'))
        saveas(ctx_fs_outcome_fig, strcat(out_path, 'ctx_fs_outcome.svg'))

        ctx_ts_regard_fig = regardlessOfOutcome(ctx_ts, 'Cortex TS');
        ctx_ts_ambig_fig = ambigStim(ctx_ts, 'Cortex TS');
        ctx_ts_contrast_outcome_fig = stimContrastAndOutcome(ctx_ts, 'Cortex TS');
        ctx_ts_outcome_fig = byOutcome(ctx_ts, 'Cortex TS');

        saveas(ctx_ts_regard_fig, strcat(out_path, 'ctx_ts_regard.fig'))
        saveas(ctx_ts_ambig_fig, strcat(out_path, 'ctx_ts_ambig.fig'))
        saveas(ctx_ts_contrast_outcome_fig, strcat(out_path, 'ctx_ts_contrast_outcome.fig'))
        saveas(ctx_ts_outcome_fig, strcat(out_path, 'ctx_ts_outcome.fig'))

        saveas(ctx_ts_regard_fig, strcat(out_path, 'ctx_ts_regard.svg'))
        saveas(ctx_ts_ambig_fig, strcat(out_path, 'ctx_ts_ambig.svg'))
        saveas(ctx_ts_contrast_outcome_fig, strcat(out_path, 'ctx_ts_contrast_outcome.svg'))
        saveas(ctx_ts_outcome_fig, strcat(out_path, 'ctx_ts_outcome.svg'))

        ctx_ps_regard_fig = regardlessOfOutcome(ctx_ps, 'Cortex PS');
        ctx_ps_ambig_fig = ambigStim(ctx_ps, 'Cortex PS');
        ctx_ps_contrast_outcome_fig = stimContrastAndOutcome(ctx_ps, 'Cortex PS');
        ctx_ps_outcome_fig = byOutcome(ctx_ps, 'Cortex PS');

        saveas(ctx_ps_regard_fig, strcat(out_path, 'ctx_ps_regard.fig'))
        saveas(ctx_ps_ambig_fig, strcat(out_path, 'ctx_ps_ambig.fig'))
        saveas(ctx_ps_contrast_outcome_fig, strcat(out_path, 'ctx_ps_contrast_outcome.fig'))
        saveas(ctx_ps_outcome_fig, strcat(out_path, 'ctx_ps_outcome.fig'))

        saveas(ctx_ps_regard_fig, strcat(out_path, 'ctx_ps_regard.svg'))
        saveas(ctx_ps_ambig_fig, strcat(out_path, 'ctx_ps_ambig.svg'))
        saveas(ctx_ps_contrast_outcome_fig, strcat(out_path, 'ctx_ps_contrast_outcome.svg'))
        saveas(ctx_ps_outcome_fig, strcat(out_path, 'ctx_ps_outcome.svg'))

        ctx_rs_regard_fig = regardlessOfOutcome(ctx_rs, 'Cortex RS');
        ctx_rs_ambig_fig = ambigStim(ctx_rs, 'Cortex RS');
        ctx_rs_contrast_outcome_fig = stimContrastAndOutcome(ctx_rs, 'Cortex RS');
        ctx_rs_outcome_fig = byOutcome(ctx_rs, 'Cortex RS');

        saveas(ctx_rs_regard_fig, strcat(out_path, 'ctx_rs_regard.fig'))
        saveas(ctx_rs_ambig_fig, strcat(out_path, 'ctx_rs_ambig.fig'))
        saveas(ctx_rs_contrast_outcome_fig, strcat(out_path, 'ctx_rs_contrast_outcome.fig'))
        saveas(ctx_rs_outcome_fig, strcat(out_path, 'ctx_rs_outcome.fig'))

        saveas(ctx_rs_regard_fig, strcat(out_path, 'ctx_rs_regard.svg'))
        saveas(ctx_rs_ambig_fig, strcat(out_path, 'ctx_rs_ambig.svg'))
        saveas(ctx_rs_contrast_outcome_fig, strcat(out_path, 'ctx_rs_contrast_outcome.svg'))
        saveas(ctx_rs_outcome_fig, strcat(out_path, 'ctx_rs_outcome.svg'))

        striatum_inds = strcmp(ap_ftr.region, 'STR') + strcmp(ap_ftr.region, 'CP');
        str = ap_ftr(logical(striatum_inds), :);
        str_fs = str(strcmp(str.waveform_class, 'FS'), :);
        str_rs = str(strcmp(str.waveform_class, 'RS'), :);
        str_ps = str(strcmp(str.waveform_class, 'PS'), :);
        str_ts = str(strcmp(str.waveform_class, 'TS'), :);

        str_fs_regard_fig = regardlessOfOutcome(str_fs, 'Striatum FS');
        str_fs_ambig_fig = ambigStim(str_fs, 'Striatum FS');
        str_fs_contrast_outcome_fig = stimContrastAndOutcome(str_fs, 'Striatum FS');
        str_fs_outcome_fig = byOutcome(str_fs, 'Striatum FS');

        saveas(str_fs_regard_fig, strcat(out_path, 'str_fs_regard.fig'))
        saveas(str_fs_ambig_fig, strcat(out_path, 'str_fs_ambig.fig'))
        saveas(str_fs_contrast_outcome_fig, strcat(out_path, 'str_fs_contrast_outcome.fig'))
        saveas(str_fs_outcome_fig, strcat(out_path, 'str_fs_outcome.fig'))

        saveas(str_fs_regard_fig, strcat(out_path, 'str_fs_regard.svg'))
        saveas(str_fs_ambig_fig, strcat(out_path, 'str_fs_ambig.svg'))
        saveas(str_fs_contrast_outcome_fig, strcat(out_path, 'str_fs_contrast_outcome.svg'))
        saveas(str_fs_outcome_fig, strcat(out_path, 'str_fs_outcome.svg'))

        str_ps_regard_fig = regardlessOfOutcome(str_ps, 'Striatum PS');
        str_ps_ambig_fig = ambigStim(str_ps, 'Striatum PS');
        str_ps_contrast_outcome_fig = stimContrastAndOutcome(str_ps, 'Striatum PS');
        str_ps_outcome_fig = byOutcome(str_ps, 'Striatum PS');

        saveas(str_ps_regard_fig, strcat(out_path, 'str_ps_regard.fig'))
        saveas(str_ps_ambig_fig, strcat(out_path, 'str_ps_ambig.fig'))
        saveas(str_ps_contrast_outcome_fig, strcat(out_path, 'str_ps_contrast_outcome.fig'))
        saveas(str_ps_outcome_fig, strcat(out_path, 'str_ps_outcome.fig'))

        saveas(str_ps_regard_fig, strcat(out_path, 'str_ps_regard.svg'))
        saveas(str_ps_ambig_fig, strcat(out_path, 'str_ps_ambig.svg'))
        saveas(str_ps_contrast_outcome_fig, strcat(out_path, 'str_ps_contrast_outcome.svg'))
        saveas(str_ps_outcome_fig, strcat(out_path, 'str_ps_outcome.svg'))

        str_ts_regard_fig = regardlessOfOutcome(str_ts, 'Striatum TS');
        str_ts_ambig_fig = ambigStim(str_ts, 'Striatum TS');
        str_ts_contrast_outcome_fig = stimContrastAndOutcome(str_ts, 'Striatum TS');
        str_ts_outcome_fig = byOutcome(str_ts, 'Striatum TS');

        saveas(str_ts_regard_fig, strcat(out_path, 'str_ts_regard.fig'))
        saveas(str_ts_ambig_fig, strcat(out_path, 'str_ts_ambig.fig'))
        saveas(str_ts_contrast_outcome_fig, strcat(out_path, 'str_ts_contrast_outcome.fig'))
        saveas(str_ts_outcome_fig, strcat(out_path, 'str_ts_outcome.fig'))

        saveas(str_ts_regard_fig, strcat(out_path, 'str_ts_regard.svg'))
        saveas(str_ts_ambig_fig, strcat(out_path, 'str_ts_ambig.svg'))
        saveas(str_ts_contrast_outcome_fig, strcat(out_path, 'str_ts_contrast_outcome.svg'))
        saveas(str_ts_outcome_fig, strcat(out_path, 'str_ts_outcome.svg'))

        str_rs_regard_fig = regardlessOfOutcome(str_rs, 'Striatum RS');
        str_rs_ambig_fig = ambigStim(str_rs, 'Striatum RS');
        str_rs_contrast_outcome_fig = stimContrastAndOutcome(str_rs, 'Striatum RS');
        str_rs_outcome_fig = byOutcome(str_rs, 'Striatum RS');

        saveas(str_rs_regard_fig, strcat(out_path, 'str_rs_regard.fig'))
        saveas(str_rs_ambig_fig, strcat(out_path, 'str_rs_ambig.fig'))
        saveas(str_rs_contrast_outcome_fig, strcat(out_path, 'str_rs_contrast_outcome.fig'))
        saveas(str_rs_outcome_fig, strcat(out_path, 'str_rs_outcome.fig'))

        saveas(str_rs_regard_fig, strcat(out_path, 'str_rs_regard.svg'))
        saveas(str_rs_ambig_fig, strcat(out_path, 'str_rs_ambig.svg'))
        saveas(str_rs_contrast_outcome_fig, strcat(out_path, 'str_rs_contrast_outcome.svg'))
        saveas(str_rs_outcome_fig, strcat(out_path, 'str_rs_outcome.svg'))
        
    elseif strcmp(probe_type, 'PFC')
        sm = ap_ftr(startsWith(ap_ftr.region, 'MO'),:);

        ac = ap_ftr(startsWith(ap_ftr.region, 'AC'),:);

        % prelimbic 
        pl = ap_ftr(startsWith(ap_ftr.region, 'PL'), :);
        pl_rs = pl(strcmp(pl.waveform_class, 'RS'), :);
        pl_fs = pl(strcmp(pl.waveform_class, 'FS'), :);
        pl_ps = pl(strcmp(pl.waveform_class, 'PS'), :);
        pl_ts = pl(strcmp(pl.waveform_class, 'TS'), :);
        
        pl_rs_driven = pl_rs(cell2mat(pl_rs.is_left_trigger_stim_modulated) == 1,:);
        pl_rs_suppressed = pl_rs(cell2mat(pl_rs.is_left_trigger_stim_modulated) == -1,:);
        pl_fs_driven = pl_fs(cell2mat(pl_fs.is_left_trigger_stim_modulated) == 1,:);
        pl_fs_suppressed = pl_fs(cell2mat(pl_fs.is_left_trigger_stim_modulated) == -1,:);

        pl_fs_regard_fig = regardlessOfOutcome(pl_fs, 'Prelimbic Cortex FS');
        pl_fs_ambig_fig = ambigStim(pl_fs, 'Prelimbic Cortex FS');
        pl_fs_contrast_outcome_fig = stimContrastAndOutcome(pl_fs, 'Prelimbic Cortex FS');
        pl_fs_outcome_fig = byOutcome(pl_fs, 'Prelimbic Cortex FS');

        saveas(pl_fs_regard_fig, strcat(out_path, 'pl_fs_regard.fig'))
        saveas(pl_fs_ambig_fig, strcat(out_path, 'pl_fs_ambig.fig'))
        saveas(pl_fs_contrast_outcome_fig, strcat(out_path, 'pl_fs_contrast_outcome.fig'))
        saveas(pl_fs_outcome_fig, strcat(out_path, 'pl_fs_outcome.fig'))

        saveas(pl_fs_regard_fig, strcat(out_path, 'pl_fs_regard.svg'))
        saveas(pl_fs_ambig_fig, strcat(out_path, 'pl_fs_ambig.svg'))
        saveas(pl_fs_contrast_outcome_fig, strcat(out_path, 'pl_fs_contrast_outcome.svg'))
        saveas(pl_fs_outcome_fig, strcat(out_path, 'pl_fs_outcome.svg'))

        pl_ps_regard_fig = regardlessOfOutcome(pl_ps, 'Prelimbic Cortex PS');
        pl_ps_ambig_fig = ambigStim(pl_ps, 'Prelimbic Cortex PS');
        pl_ps_contrast_outcome_fig = stimContrastAndOutcome(pl_ps, 'Prelimbic Cortex PS');
        pl_ps_outcome_fig = byOutcome(pl_ps, 'Prelimbic Cortex PS');

        saveas(pl_ps_regard_fig, strcat(out_path, 'pl_ps_regard.fig'))
        saveas(pl_ps_ambig_fig, strcat(out_path, 'pl_ps_ambig.fig'))
        saveas(pl_ps_contrast_outcome_fig, strcat(out_path, 'pl_ps_contrast_outcome.fig'))
        saveas(pl_ps_outcome_fig, strcat(out_path, 'pl_ps_outcome.fig'))

        saveas(pl_ps_regard_fig, strcat(out_path, 'pl_ps_regard.svg'))
        saveas(pl_ps_ambig_fig, strcat(out_path, 'pl_ps_ambig.svg'))
        saveas(pl_ps_contrast_outcome_fig, strcat(out_path, 'pl_ps_contrast_outcome.svg'))
        saveas(pl_ps_outcome_fig, strcat(out_path, 'pl_ps_outcome.svg'))

        pl_ts_regard_fig = regardlessOfOutcome(pl_ts, 'Prelimbic Cortex TS');
        pl_ts_ambig_fig = ambigStim(pl_ts, 'Prelimbic Cortex TS');
        pl_ts_contrast_outcome_fig = stimContrastAndOutcome(pl_ts, 'Prelimbic Cortex TS');
        pl_ts_outcome_fig = byOutcome(pl_ts, 'Prelimbic Cortex TS');

        saveas(pl_ts_regard_fig, strcat(out_path, 'pl_ts_regard.fig'))
        saveas(pl_ts_ambig_fig, strcat(out_path, 'pl_ts_ambig.fig'))
        saveas(pl_ts_contrast_outcome_fig, strcat(out_path, 'pl_ts_contrast_outcome.fig'))
        saveas(pl_ts_outcome_fig, strcat(out_path, 'pl_ts_outcome.fig'))

        saveas(pl_ts_regard_fig, strcat(out_path, 'pl_ts_regard.svg'))
        saveas(pl_ts_ambig_fig, strcat(out_path, 'pl_ts_ambig.svg'))
        saveas(pl_ts_contrast_outcome_fig, strcat(out_path, 'pl_ts_contrast_outcome.svg'))
        saveas(pl_ts_outcome_fig, strcat(out_path, 'pl_ts_outcome.svg'))

        pl_rs_regard_fig = regardlessOfOutcome(pl_rs, 'Prelimbic Cortex RS');
        pl_rs_ambig_fig = ambigStim(pl_rs, 'Prelimbic Cortex RS');
        pl_rs_contrast_outcome_fig = stimContrastAndOutcome(pl_rs, 'Prelimbic Cortex RS');
        pl_rs_outcome_fig = byOutcome(pl_rs, 'Prelimbic Cortex RS');

        saveas(pl_rs_regard_fig, strcat(out_path, 'pl_rs_regard.fig'))
        saveas(pl_rs_ambig_fig, strcat(out_path, 'pl_rs_ambig.fig'))
        saveas(pl_rs_contrast_outcome_fig, strcat(out_path, 'pl_rs_contrast_outcome.fig'))
        saveas(pl_rs_outcome_fig, strcat(out_path, 'pl_rs_outcome.fig'))

        saveas(pl_rs_regard_fig, strcat(out_path, 'pl_rs_regard.svg'))
        saveas(pl_rs_ambig_fig, strcat(out_path, 'pl_rs_ambig.svg'))
        saveas(pl_rs_contrast_outcome_fig, strcat(out_path, 'pl_rs_contrast_outcome.svg'))
        saveas(pl_rs_outcome_fig, strcat(out_path, 'pl_rs_outcome.svg'))

        % infralimbic cortex 
        il = ap_ftr(startsWith(ap_ftr.region, 'IL'), :);
        il_rs = il(strcmp(il.waveform_class, 'RS'), :);
        il_fs = il(strcmp(il.waveform_class, 'FS'), :);
        il_ps = il(strcmp(il.waveform_class, 'PS'), :);
        il_ts = il(strcmp(il.waveform_class, 'TS'), :);

        il_rs_driven = il_rs(cell2mat(il_rs.is_left_trigger_stim_modulated) == 1,:);
        il_rs_suppressed = il_rs(cell2mat(il_rs.is_left_trigger_stim_modulated) == -1,:);
        il_fs_driven = il_fs(cell2mat(il_fs.is_left_trigger_stim_modulated) == 1,:);
        il_fs_suppressed = il_fs(cell2mat(il_fs.is_left_trigger_stim_modulated) == -1,:);

        il_fs_regard_fig = regardlessOfOutcome(il_fs, 'Infralimbic Cortex FS');
        il_fs_ambig_fig = ambigStim(il_fs, 'Infralimbic Cortex FS');
        il_fs_contrast_outcome_fig = stimContrastAndOutcome(il_fs, 'Infralimbic Cortex FS');
        il_fs_outcome_fig = byOutcome(il_fs, 'Infralimbic Cortex FS');

        saveas(il_fs_regard_fig, strcat(out_path, 'il_fs_regard.fig'))
        saveas(il_fs_ambig_fig, strcat(out_path, 'il_fs_ambig.fig'))
        saveas(il_fs_contrast_outcome_fig, strcat(out_path, 'il_fs_contrast_outcome.fig'))
        saveas(il_fs_outcome_fig, strcat(out_path, 'il_fs_outcome.fig'))

        saveas(il_fs_regard_fig, strcat(out_path, 'il_fs_regard.svg'))
        saveas(il_fs_ambig_fig, strcat(out_path, 'il_fs_ambig.svg'))
        saveas(il_fs_contrast_outcome_fig, strcat(out_path, 'il_fs_contrast_outcome.svg'))
        saveas(il_fs_outcome_fig, strcat(out_path, 'il_fs_outcome.svg'))

        il_ps_regard_fig = regardlessOfOutcome(il_ps, 'Infralimbic Cortex PS');
        il_ps_ambig_fig = ambigStim(il_ps, 'Infralimbic Cortex PS');
        il_ps_contrast_outcome_fig = stimContrastAndOutcome(il_ps, 'Infralimbic Cortex PS');
        il_ps_outcome_fig = byOutcome(il_ps, 'Infralimbic Cortex PS');

        saveas(il_ps_regard_fig, strcat(out_path, 'il_ps_regard.fig'))
        saveas(il_ps_ambig_fig, strcat(out_path, 'il_ps_ambig.fig'))
        saveas(il_ps_contrast_outcome_fig, strcat(out_path, 'il_ps_contrast_outcome.fig'))
        saveas(il_ps_outcome_fig, strcat(out_path, 'il_ps_outcome.fig'))

        saveas(il_ps_regard_fig, strcat(out_path, 'il_ps_regard.svg'))
        saveas(il_ps_ambig_fig, strcat(out_path, 'il_ps_ambig.svg'))
        saveas(il_ps_contrast_outcome_fig, strcat(out_path, 'il_ps_contrast_outcome.svg'))
        saveas(il_ps_outcome_fig, strcat(out_path, 'il_ps_outcome.svg'))

        il_ts_regard_fig = regardlessOfOutcome(il_ts, 'Infralimbic Cortex TS');
        il_ts_ambig_fig = ambigStim(il_ts, 'Infralimbic Cortex TS');
        il_ts_contrast_outcome_fig = stimContrastAndOutcome(il_ts, 'Infralimbic Cortex TS');
        il_ts_outcome_fig = byOutcome(il_ts, 'Infralimbic Cortex TS');

        saveas(il_ts_regard_fig, strcat(out_path, 'il_ts_regard.fig'))
        saveas(il_ts_ambig_fig, strcat(out_path, 'il_ts_ambig.fig'))
        saveas(il_ts_contrast_outcome_fig, strcat(out_path, 'il_ts_contrast_outcome.fig'))
        saveas(il_ts_outcome_fig, strcat(out_path, 'il_ts_outcome.fig'))

        saveas(il_ts_regard_fig, strcat(out_path, 'il_ts_regard.svg'))
        saveas(il_ts_ambig_fig, strcat(out_path, 'il_ts_ambig.svg'))
        saveas(il_ts_contrast_outcome_fig, strcat(out_path, 'il_ts_contrast_outcome.svg'))
        saveas(il_ts_outcome_fig, strcat(out_path, 'il_ts_outcome.svg'))

        il_rs_regard_fig = regardlessOfOutcome(il_rs, 'Infralimbic Cortex RS');
        il_rs_ambig_fig = ambigStim(il_rs, 'Infralimbic Cortex RS');
        il_rs_contrast_outcome_fig = stimContrastAndOutcome(il_rs, 'Infralimbic Cortex RS');
        il_rs_outcome_fig = byOutcome(il_rs, 'Infralimbic Cortex RS');

        saveas(il_rs_regard_fig, strcat(out_path, 'il_rs_regard.fig'))
        saveas(il_rs_ambig_fig, strcat(out_path, 'il_rs_ambig.fig'))
        saveas(il_rs_contrast_outcome_fig, strcat(out_path, 'il_rs_contrast_outcome.fig'))
        saveas(il_rs_outcome_fig, strcat(out_path, 'il_rs_outcome.fig'))

        saveas(il_rs_regard_fig, strcat(out_path, 'il_rs_regard.svg'))
        saveas(il_rs_ambig_fig, strcat(out_path, 'il_rs_ambig.svg'))
        saveas(il_rs_contrast_outcome_fig, strcat(out_path, 'il_rs_contrast_outcome.svg'))
        saveas(il_rs_outcome_fig, strcat(out_path, 'il_rs_outcome.svg'))

        % orbitomedial 
        om = ap_ftr(startsWith(ap_ftr.region, 'OR'), :);
        om_rs = om(strcmp(om.waveform_class, 'RS'), :);
        om_fs = om(strcmp(om.waveform_class, 'FS'), :);
        om_ps = om(strcmp(om.waveform_class, 'PS'), :);
        om_ts = om(strcmp(om.waveform_class, 'TS'), :);

        om_rs_driven = om_rs(cell2mat(om_rs.is_left_trigger_stim_modulated) == 1,:);
        om_rs_suppressed = om_rs(cell2mat(om_rs.is_left_trigger_stim_modulated) == -1,:);
        om_fs_driven = om_fs(cell2mat(om_fs.is_left_trigger_stim_modulated) == 1,:);
        om_fs_suppressed = om_fs(cell2mat(om_fs.is_left_trigger_stim_modulated) == -1,:);

        om_fs_regard_fig = regardlessOfOutcome(om_fs, 'Oribitomedial Cortex FS');
        om_fs_ambig_fig = ambigStim(om_fs, 'Oribitomedial Cortex FS');
        om_fs_contrast_outcome_fig = stimContrastAndOutcome(om_fs, 'Oribitomedial Cortex FS');
        om_fs_outcome_fig = byOutcome(om_fs, 'Oribitomedial Cortex FS');

        saveas(om_fs_regard_fig, strcat(out_path, 'om_fs_regard.fig'))
        saveas(om_fs_ambig_fig, strcat(out_path, 'om_fs_ambig.fig'))
        saveas(om_fs_contrast_outcome_fig, strcat(out_path, 'om_fs_contrast_outcome.fig'))
        saveas(om_fs_outcome_fig, strcat(out_path, 'om_fs_outcome.fig'))

        saveas(om_fs_regard_fig, strcat(out_path, 'om_fs_regard.svg'))
        saveas(om_fs_ambig_fig, strcat(out_path, 'om_fs_ambig.svg'))
        saveas(om_fs_contrast_outcome_fig, strcat(out_path, 'om_fs_contrast_outcome.svg'))
        saveas(om_fs_outcome_fig, strcat(out_path, 'om_fs_outcome.svg'))

        om_ps_regard_fig = regardlessOfOutcome(om_ps, 'Oribitomedial Cortex PS');
        om_ps_ambig_fig = ambigStim(om_ps, 'Oribitomedial Cortex PS');
        om_ps_contrast_outcome_fig = stimContrastAndOutcome(om_ps, 'Oribitomedial Cortex PS');
        om_ps_outcome_fig = byOutcome(om_ps, 'Oribitomedial Cortex PS');

        saveas(om_ps_regard_fig, strcat(out_path, 'om_ps_regard.fig'))
        saveas(om_ps_ambig_fig, strcat(out_path, 'om_ps_ambig.fig'))
        saveas(om_ps_contrast_outcome_fig, strcat(out_path, 'om_ps_contrast_outcome.fig'))
        saveas(om_ps_outcome_fig, strcat(out_path, 'om_ps_outcome.fig'))

        saveas(om_ps_regard_fig, strcat(out_path, 'om_ps_regard.svg'))
        saveas(om_ps_ambig_fig, strcat(out_path, 'om_ps_ambig.svg'))
        saveas(om_ps_contrast_outcome_fig, strcat(out_path, 'om_ps_contrast_outcome.svg'))
        saveas(om_ps_outcome_fig, strcat(out_path, 'om_ps_outcome.svg'))

        om_ts_regard_fig = regardlessOfOutcome(om_ts, 'Oribitomedial Cortex TS');
        om_ts_ambig_fig = ambigStim(om_ts, 'Oribitomedial Cortex TS');
        om_ts_contrast_outcome_fig = stimContrastAndOutcome(om_ts, 'Oribitomedial Cortex TS');
        om_ts_outcome_fig = byOutcome(om_ts, 'Oribitomedial Cortex TS');

        saveas(om_ts_regard_fig, strcat(out_path, 'om_ts_regard.fig'))
        saveas(om_ts_ambig_fig, strcat(out_path, 'om_ts_ambig.fig'))
        saveas(om_ts_contrast_outcome_fig, strcat(out_path, 'om_ts_contrast_outcome.fig'))
        saveas(om_ts_outcome_fig, strcat(out_path, 'om_ts_outcome.fig'))

        saveas(om_ts_regard_fig, strcat(out_path, 'om_ts_regard.svg'))
        saveas(om_ts_ambig_fig, strcat(out_path, 'om_ts_ambig.svg'))
        saveas(om_ts_contrast_outcome_fig, strcat(out_path, 'om_ts_contrast_outcome.svg'))
        saveas(om_ts_outcome_fig, strcat(out_path, 'om_ts_outcome.svg'))

        om_rs_regard_fig = regardlessOfOutcome(om_rs, 'Orbitomedial Cortex RS');
        om_rs_ambig_fig = ambigStim(om_rs, 'Orbitomedial Cortex RS');
        om_rs_contrast_outcome_fig = stimContrastAndOutcome(om_rs, 'Orbitomedial Cortex RS');
        om_rs_outcome_fig = byOutcome(om_rs, 'Orbitomedial Cortex RS');

        saveas(om_rs_regard_fig, strcat(out_path, 'om_rs_regard.fig'))
        saveas(om_rs_ambig_fig, strcat(out_path, 'om_rs_ambig.fig'))
        saveas(om_rs_contrast_outcome_fig, strcat(out_path, 'om_rs_contrast_outcome.fig'))
        saveas(om_rs_outcome_fig, strcat(out_path, 'om_rs_outcome.fig'))

        saveas(om_rs_regard_fig, strcat(out_path, 'om_rs_regard.svg'))
        saveas(om_rs_ambig_fig, strcat(out_path, 'om_rs_ambig.svg'))
        saveas(om_rs_outcome_fig, strcat(out_path, 'om_rs_outcome.svg'))
        saveas(om_rs_contrast_outcome_fig, strcat(out_path, 'om_rs_contrast_outcome.svg'))
    end
end

function fig = regardlessOfOutcome(units, ttl)
    fig = figure('Visible', 'off', 'Position', [1220, 1287, 625, 551]);
    hold on 
    amps = -5:5;
    cmap = colormap('jet');
    cinds = round(linspace(1,256,length(amps)));
    for a = 1:length(amps)
        expr = sprintf('amp_%i_avg_psth', amps(a));
        mat = cell2mat(units.(expr));
        semshade(mat ./ 0.1, 0.3, cmap(cinds(a),:), cmap(cinds(a),:), linspace(-2.8,4.9,80), 1, num2str(amps(a)));
    end
    leg = legend('Location', 'northwest');
    title(leg, 'Stimulus Contrast')
    xlabel('Time (s)')
    ylabel('Firing Rate (Hz)')
    xlim([-2.8,4.8])
    title(ttl)
end

function fig = ambigStim(units, ttl)
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    fig = figure('Visible', 'off', 'Position', [1215, 1419, 1604, 407]);
    tl = tiledlayout(1,4);
    axs = zeros(1,4);
    for o = 1:length(outcomes)
        axs(o) = nexttile;
        expr = sprintf('amp_0_avg_psth_%s', outcomes{o});
        mat = cell2mat(units.(expr));
        if ~isempty(mat)
            try
                semshade(mat ./ 0.1, 0.3, 'k', 'k', linspace(-2.8,4.9,80), 1);
            catch
                plot(linspace(-2.8,4.9,80),  mat ./ 0.1, 'k')
            end
        end
        t = outcomes{o};
        if strcmp(t, 'CR')
            t = 'Correct Rejection';
        elseif strcmp(t, 'FA');
            t = 'False Alarm';
        end 
        title(t)
        xlim([-2.8,4.8])
    end
    unifyYLimits(gcf)
    title(tl, ttl)
end

function fig = byOutcome(units, ttl)
    fig = figure('Visible', 'off', 'Position', [1215, 1419, 1604, 407]);
    tl = tiledlayout(1,4);
    axs = zeros(1,4);
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    for o = 1:length(outcomes)
        axs(o) = nexttile;
        mat = cell2mat(units.(strcat('left_trigger_aligned_avg_psth_', outcomes{o})));
        semshade(mat ./ 0.1, 0.3, 'k', 'k', linspace(-2.8,4.9,80), 1);
        t = outcomes{o};
        if strcmp(t, 'CR')
            t = 'Correct Rejection';
        elseif strcmp(t, 'FA');
            t = 'False Alarm';
        end 
        title(t)
        xlim([-2.8,4.8])
    end
    xlabel(tl, 'Time (s)')
    ylabel(tl, 'Firing Rate (Hz)')
    title(tl, ttl)
    unifyYLimits(fig)
end

function fig = stimContrastAndOutcome(units, ttl)
    % start with no-go 
    fig = figure('Visible', 'off', 'Position', [1215, 1419, 1604, 407]);
    amps = -5:5;
    neg_amps = amps(amps < 0);
    pos_amps = amps(amps > 0);
    cmap = colormap('jet');
    cinds = round(linspace(1,256,length(amps)));
    tl = tiledlayout(1,4);
    axs = zeros(1,4);
    axs(1) = nexttile;  hold on;
    axs(2) = nexttile; hold on;
    axs(3) = nexttile; hold on;
    axs(4) = nexttile; hold on;
    for a = 1:length(neg_amps)
        % correct rejection 
        expr = sprintf('amp_%i_avg_psth_CR', neg_amps(a));
        mat = cell2mat(units.(expr));
        axes(axs(3))
        if ~isempty(mat)
            try
                semshade(mat ./ 0.1, 0.3, cmap(cinds(a),:), cmap(cinds(a),:), linspace(-2.8,4.9,80), 1, num2str(neg_amps(a)));
            catch 
                plot(linspace(-2.8,4.9,80), mat ./ 0.1, cmap(cinds(a),:))
            end
        end
        % false alarm 
        expr = sprintf('amp_%i_avg_psth_FA', neg_amps(a));
        mat = cell2mat(units.(expr));
        axes(axs(4))
        if ~isempty(mat)
            try
                semshade(mat ./ 0.1, 0.3, cmap(cinds(a),:), cmap(cinds(a),:), linspace(-2.8,4.9,80), 1, num2str(neg_amps(a)));
            catch
                plot(linspace(-2.8,4.9,80), mat ./ 0.1, 'Color', cmap(cinds(a),:))
            end
        end
    end
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    for o = 1:length(outcomes)
        axes(axs(o))
        expr = sprintf('amp_0_avg_psth_%s', outcomes{o});
        mat = cell2mat(units.(expr));
        if ~isempty(mat)
            try
                semshade(mat ./ 0.1, 0.3, cmap(cinds(length(neg_amps)+1),:), cmap(cinds(length(neg_amps)+1),:), linspace(-2.8,4.9,80), 1, '0');
            catch 
                plot(linspace(-2.8,4.9,80), mat ./ 0.1, 'Color', cmap(cinds(length(neg_amps)+1),:))
            end
        end
        t = outcomes{o};
        if strcmp(t, 'CR')
            t = 'Correct Rejection';
        elseif strcmp(t, 'FA');
            t = 'False Alarm';
        end 
        title(t)
    end
    for a = 1:length(pos_amps)
        % correct rejection 
        expr = sprintf('amp_%i_avg_psth_Hit', pos_amps(a));
        mat = cell2mat(units.(expr));
        axes(axs(1))
        if ~isempty(mat)
            try
                semshade(mat ./ 0.1, 0.3, cmap(cinds(length(neg_amps)+1+a),:), cmap(cinds(length(neg_amps)+1+a),:), linspace(-2.8,4.9,80), 1, num2str(pos_amps(a)));
            catch
                plot(linspace(-2.8,4.9,80), mat ./ 0.1, 'Color', cmap(cinds(length(neg_amps)+1+a),:))
            end
        end
        % false alarm 
        expr = sprintf('amp_%i_avg_psth_Miss', pos_amps(a));
        mat = cell2mat(units.(expr));
        axes(axs(2))
        if ~isempty(mat)
            try
                semshade(mat ./ 0.1, 0.3, cmap(cinds(length(neg_amps)+1+a),:), cmap(cinds(length(neg_amps)+1+a),:), linspace(-2.8,4.9,80), 1, num2str(pos_amps(a)));
            catch
                plot(linspace(-2.8,4.9,80), mat ./ 0.1, 'Color', cmap(cinds(length(neg_amps)+1+a),:))
            end
        end
    end
    unifyYLimits(gcf)
    for i = 1:4
        axes(axs(i)); xlim([-2.8,4.8])
    end
    xlabel(tl, 'Time (s)')
    ylabel(tl, 'Firing Rate (Hz)')
    title(tl, ttl)
end

