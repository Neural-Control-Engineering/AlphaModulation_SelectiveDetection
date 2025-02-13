function spatialFiringRatePlots(ap_ftr, probe_type, out_path)
    if strcmp(probe_type, 'S1')
        ctx = ap_ftr(startsWith(ap_ftr.region, 'SS'), :);
        ctx_fs = ctx(strcmp(ctx.waveform_class, 'FS'), :);
        ctx_rs = ctx(strcmp(ctx.waveform_class, 'RS'), :);
        ctx_ps = ctx(strcmp(ctx.waveform_class, 'PS'), :);
        ctx_ts = ctx(strcmp(ctx.waveform_class, 'TS'), :);
        if ~isempty(out_path)
            fig = plotAcrossDays(ctx_rs, 'Somatosensory Cortex: RS');
            saveas(fig, strcat(out_path, 'ctx_rs_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'ctx_rs_spatial_fr_map.svg'))

            fig = plotAcrossDays(ctx_fs, 'Somatosensory Cortex: FS');
            saveas(fig, strcat(out_path, 'ctx_fs_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'ctx_fs_spatial_fr_map.svg'))
            
            fig = plotAcrossDays(ctx_ps, 'Somatosensory Cortex: PS');
            saveas(fig, strcat(out_path, 'ctx_ps_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'ctx_ps_spatial_fr_map.svg'))
            
            fig = plotAcrossDays(ctx_ts, 'Somatosensory Cortex: TS');
            saveas(fig, strcat(out_path, 'ctx_ts_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'ctx_ts_spatial_fr_map.svg'))
        end

        striatum_inds = strcmp(ap_ftr.region, 'STR') + strcmp(ap_ftr.region, 'CP');
        str = ap_ftr(logical(striatum_inds), :);
        str_fs = str(strcmp(str.waveform_class, 'FS'), :);
        str_rs = str(strcmp(str.waveform_class, 'RS'), :);
        str_ps = str(strcmp(str.waveform_class, 'PS'), :);
        str_ts = str(strcmp(str.waveform_class, 'TS'), :);
        if ~isempty(out_path)
            fig = plotAcrossDays(str_rs, 'Striatum: RS');
            saveas(fig, strcat(out_path, 'str_rs_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'str_rs_spatial_fr_map.svg'))
        
            fig = plotAcrossDays(str_fs, 'Striatum: FS');
            saveas(fig, strcat(out_path, 'str_fs_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'str_fs_spatial_fr_map.svg'))
            
            fig = plotAcrossDays(str_ps, 'Striatum: PS');
            saveas(fig, strcat(out_path, 'str_ps_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'str_ps_spatial_fr_map.svg'))
            
            fig = plotAcrossDays(str_ts, 'Striatum: TS');
            saveas(fig, strcat(out_path, 'str_ts_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'str_ts_spatial_fr_map.svg'))
        end

    elseif strcmp(probe_type, 'PFC')
        sm = ap_ftr(startsWith(ap_ftr.region, 'MO'),:);
        sm_rs = sm(strcmp(sm.waveform_class, 'RS'), :);
        sm_fs = sm(strcmp(sm.waveform_class, 'FS'), :);
        sm_ps = sm(strcmp(sm.waveform_class, 'PS'), :);
        sm_ts = sm(strcmp(sm.waveform_class, 'TS'), :);
        if ~isempty(out_path)
            fig = plotAcrossDays(sm_rs, 'Supplementary Motor Area: RS');
            saveas(fig, strcat(out_path, 'sma_rs_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'sma_rs_spatial_fr_map.svg'))

            fig = plotAcrossDays(sm_fs, 'Supplementary Motor Area: FS');
            saveas(fig, strcat(out_path, 'sma_fs_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'sma_fs_spatial_fr_map.svg'))
            
            fig = plotAcrossDays(sm_ps, 'Supplementary Motor Area: PS');
            saveas(fig, strcat(out_path, 'sma_ps_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'sma_ps_spatial_fr_map.svg'))
            
            fig = plotAcrossDays(sm_ts, 'Supplementary Motor Area: TS');
            saveas(fig, strcat(out_path, 'sma_ts_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'sma_ts_spatial_fr_map.svg'))
        end

        ac = ap_ftr(startsWith(ap_ftr.region, 'AC'),:);
        ac_rs = ac(strcmp(ac.waveform_class, 'RS'), :);
        ac_fs = ac(strcmp(ac.waveform_class, 'FS'), :);
        ac_ps = ac(strcmp(ac.waveform_class, 'PS'), :);
        ac_ts = ac(strcmp(ac.waveform_class, 'TS'), :);
        if ~isempty(out_path)
            fig = plotAcrossDays(ac_rs, 'Anterior Cingulate: RS');
            saveas(fig, strcat(out_path, 'ac_rs_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'ac_rs_spatial_fr_map.svg'))

            fig = plotAcrossDays(ac_fs, 'Anterior Cingulate: FS');
            saveas(fig, strcat(out_path, 'ac_fs_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'ac_fs_spatial_fr_map.svg'))

            fig = plotAcrossDays(ac_ps, 'Anterior Cingulate: PS');
            saveas(fig, strcat(out_path, 'ac_ps_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'ac_ps_spatial_fr_map.svg'))

            fig = plotAcrossDays(ac_ts, 'Anterior Cingulate: TS');
            saveas(fig, strcat(out_path, 'ac_ts_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'ac_ts_spatial_fr_map.svg'))
        end

        % prelimbic 
        pl = ap_ftr(startsWith(ap_ftr.region, 'PL'), :);
        pl_rs = pl(strcmp(pl.waveform_class, 'RS'), :);
        pl_fs = pl(strcmp(pl.waveform_class, 'FS'), :);
        pl_ps = pl(strcmp(pl.waveform_class, 'PS'), :);
        pl_ts = pl(strcmp(pl.waveform_class, 'TS'), :);
        if ~isempty(out_path)
            fig = plotAcrossDays(pl_rs, 'Prelimbic Cortex: RS');
            saveas(fig, strcat(out_path, 'pl_rs_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'pl_rs_spatial_fr_map.svg'))

            fig = plotAcrossDays(pl_fs, 'Prelimbic Cortex: FS');
            saveas(fig, strcat(out_path, 'pl_fs_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'pl_fs_spatial_fr_map.svg'))

            fig = plotAcrossDays(pl_ps, 'Prelimbic Cortex: PS');
            saveas(fig, strcat(out_path, 'pl_ps_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'pl_ps_spatial_fr_map.svg'))

            fig = plotAcrossDays(pl_ts, 'Prelimbic Cortex: TS');
            saveas(fig, strcat(out_path, 'pl_ts_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'pl_ts_spatial_fr_map.svg'))
        end

        % infralimbic cortex 
        il = ap_ftr(startsWith(ap_ftr.region, 'IL'), :);
        il_rs = il(strcmp(il.waveform_class, 'RS'), :);
        il_fs = il(strcmp(il.waveform_class, 'FS'), :);
        il_ps = il(strcmp(il.waveform_class, 'PS'), :);
        il_ts = il(strcmp(il.waveform_class, 'TS'), :);
        if ~isempty(out_path)
            fig = plotAcrossDays(il_rs, 'Infralimbic Cortex: RS');
            saveas(fig, strcat(out_path, 'sma_rs_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'sma_rs_spatial_fr_map.svg'))

            fig = plotAcrossDays(il_fs, 'Infralimbic Cortex: FS');
            saveas(fig, strcat(out_path, 'il_fs_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'il_fs_spatial_fr_map.svg'))

            fig = plotAcrossDays(il_ps, 'Infralimbic Cortex: PS');
            saveas(fig, strcat(out_path, 'il_ps_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'il_ps_spatial_fr_map.svg'))

            fig = plotAcrossDays(il_ts, 'Infralimbic Cortex: TS');
            saveas(fig, strcat(out_path, 'il_ts_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'il_ts_spatial_fr_map.svg'))
        end

        % orbitomedial 
        om = ap_ftr(startsWith(ap_ftr.region, 'OR'), :);
        om_rs = om(strcmp(om.waveform_class, 'RS'), :);
        om_fs = om(strcmp(om.waveform_class, 'FS'), :);
        om_ps = om(strcmp(om.waveform_class, 'PS'), :);
        om_ts = om(strcmp(om.waveform_class, 'TS'), :);
        if ~isempty(out_path)
            fig = plotAcrossDays(om_rs, 'Orbitomedial Cortex: RS');
            saveas(fig, strcat(out_path, 'om_rs_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'om_rs_spatial_fr_map.svg'))

            fig = plotAcrossDays(om_fs, 'Orbitomedial Cortex: FS');
            saveas(fig, strcat(out_path, 'om_fs_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'om_fs_spatial_fr_map.svg'))

            fig = plotAcrossDays(om_ps, 'Orbitomedial Cortex: PS');
            saveas(fig, strcat(out_path, 'om_ps_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'om_ps_spatial_fr_map.svg'))

            fig = plotAcrossDays(om_ts, 'Orbitomedial Cortex: TS');
            saveas(fig, strcat(out_path, 'om_ts_spatial_fr_map.fig'))
            saveas(fig, strcat(out_path, 'om_ts_spatial_fr_map.svg'))
        end
    end
    close all
end

function fig = plotAcrossDays(units, ttl)
    [~, inds] = sort(units.position(:,2));
    units = units(inds,:);
    positions = units.position;
    uniq_ys = unique(positions(:,2));
    fig = figure('Position', [1151, 841, 1850, 1081], 'Visible', 'off');
    tl = tiledlayout(1,4);
    axs = zeros(1,4);
    outcomes = {'Hit', 'Miss', 'Correct Rejection', 'False Alarm'};
    for i  = 1:4
        axs(i) = nexttile;
        hold on
        title(outcomes{i})
    end
    for y = 1:length(uniq_ys)
        y_pos = positions(positions(:,2) == uniq_ys(y),:);
        y_units = units(positions(:,2) == uniq_ys(y),:);
        uniq_xs = unique(y_pos(:,1));
        for x = 1:length(uniq_xs)
            x_units = y_units(y_pos(:,1) == uniq_xs(x), :);
            offset = randi([-5,5]);
            time = linspace(-2.8, 4.9, 80) + uniq_xs(x) + offset;
            % if length(unique(x_units.session_id)) == length(x_units.session_id)
            mat = cell2mat(x_units.left_trigger_aligned_avg_fr_Hit);
            mat = mat.*2 + y_pos(x,2);
            axes(axs(1))
            if ~isempty(mat)
                try
                    semshade(mat, 0.3, 'k', 'k', time, 1);
                    plot([uniq_xs(x)+offset, uniq_xs(x)+offset], [min(min(mat)), max(max(mat))], 'k--')
                catch
                    plot(time, mat, 'k')
                    plot([uniq_xs(x)+offset, uniq_xs(x)+offset], [min(min(mat)), max(max(mat))], 'k--')
                end
            end

            mat = cell2mat(x_units.left_trigger_aligned_avg_fr_Miss);
            mat = mat.*2 + y_pos(x,2);
            axes(axs(2))
            if ~isempty(mat)
                try
                    semshade(mat, 0.3, 'k', 'k', time, 1);
                    plot([uniq_xs(x)+offset, uniq_xs(x)+offset], [min(min(mat)), max(max(mat))], 'k--')
                catch
                    plot(time, mat, 'k')
                    plot([uniq_xs(x)+offset, uniq_xs(x)+offset], [min(min(mat)), max(max(mat))], 'k--')
                end
            end

            mat = cell2mat(x_units.right_trigger_aligned_avg_fr_FA);
            mat = mat.*2 + y_pos(x,2);
            axes(axs(3))
            if ~isempty(mat)
                try
                    semshade(mat, 0.3, 'k', 'k', time, 1);
                    plot([uniq_xs(x)+offset, uniq_xs(x)+offset], [min(min(mat)), max(max(mat))], 'k--')
                catch
                    plot(time, mat, 'k')
                    plot([uniq_xs(x)+offset, uniq_xs(x)+offset], [min(min(mat)), max(max(mat))], 'k--')
                end
            end

            mat = cell2mat(x_units.right_trigger_aligned_avg_fr_CR);
            mat = mat.*2 + y_pos(x,2);
            axes(axs(4))
            if ~isempty(mat)
                try
                    semshade(mat, 0.3, 'k', 'k', time, 1);
                    plot([uniq_xs(x)+offset, uniq_xs(x)+offset], [min(min(mat)), max(max(mat))], 'k--')
                catch
                    plot(time, mat, 'k')
                    plot([uniq_xs(x)+offset, uniq_xs(x)+offset], [min(min(mat)), max(max(mat))], 'k--')
                end
            end
            % else
            %     keyboard
            %     for i = 1:size(x_units,1)
            %         mat = x_units(i,:).left_trigger_aligned_avg_fr_Hit{1};
            %         mat = mat.*2 + y_pos(x,2);
            %         time = linspace(-2.8, 4.9, 80) + uniq_xs(x) + (i-1)*10;
            %         plot(time, mat, 'k')
            %         plot([uniq_xs(x)+(i-1)*10, uniq_xs(x)+(i-1)*10], [min(min(mat)), max(max(mat))], 'k--')
            %     end
            % end
        end
    end
    title(tl, ttl)
    ylabel(tl, 'Probe Depth')
    xlabel(tl, 'X-Position')
end