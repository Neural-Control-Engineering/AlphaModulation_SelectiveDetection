function negativeSpikeWidths(ap_dir, ap_files, regMaps, runAnalysis, loadData)
    init_paths;

    if runAnalysis
        all_widths = [];
        all_class = [];
        all_regions = {};
        all_end_slopes = [];
        all_t2p = [];
        all_frs = [];
        all_wvfrms = [];
        all_sessions = {};
        slrt_dir = strrep(ap_dir, 'AP', 'SLRT');
        for i = 1:length(ap_files)
            ap_ext = load(strcat(ap_dir, ap_files{i}));
            slrt_ext = load(strcat(slrt_dir, ap_files{i}));
            spiking_data = ap_ext.ap_data(1,:).spiking_data{1};
            spiking_data = avgTrialFR(spiking_data, slrt_ext.slrt_data, ap_ext.ap_data);
            spiking_data = assignRegions(spiking_data, regMaps{i});
            spike_class = cell(size(spiking_data,1),1);
            widths = zeros(size(spiking_data,1),1);
            es = zeros(size(spiking_data,1),1);
            t2p = zeros(size(spiking_data,1),1);
            sessions = cell(size(spiking_data,1),1);
            regions = spiking_data.region;
            wvfrms = [];
            for c = 1:size(spiking_data,1)
                wvfrm = spiking_data(c,:).template{1};
                wvfrms = [wvfrms; wvfrm];
                sessions{c} = ap_files{i};
                spike_class{c} = classifySpkWaveform(wvfrm);
                if strcmp(spike_class{c},'NS') && strcmp(spiking_data(c,:).quality, 'good')
                    % x1 = 1:length(wvfrm);
                    % x2 = 1:0.1:length(wvfrm);
                    % y = spline(x1, wvfrm, x2);
                    % [~, ~, last_ind, ~] = getSpikeWidth(wvfrm);
                    % last_ind = find(x2==last_ind);
                    % [post_peak, post_peak_ind] = max(y(last_ind:end));
                    % % [post_min, post_min_ind] = min(y(last_ind+post_peak_ind:end));
                    % try
                    %     post_min = y(last_ind+post_peak_ind+25);
                    % catch
                    %     post_min = y(end);
                    % end
                    % try
                    %     out = (post_min - post_peak) / (x2(last_ind+post_peak_ind+25) - x2(last_ind+post_peak_ind));
                    % catch
                    %     out = (post_min - post_peak) / (x2(end) - x2(last_ind+post_peak_ind));
                    % end
                    % [~, min_ind] = min(y);
                    % trough2peak = x2(last_ind+post_peak_ind) - x2(min_ind);
                    % if (trough2peak / 30) > 0.45
                    %     figure(); plot(x2, y); hold on;
                    %     plot(x2(last_ind+post_peak_ind), y(last_ind+post_peak_ind), '*')
                    %     plot(x2(min_ind), min(y), '*')
                    % end
                    try
                        [es(c), t2p(c)] = getEndSlope(wvfrm);
                    catch
                        es(c) = nan; t2p(c) = nan;
                    end
                else
                    es(c) = nan;
                    t2p(c) = nan;
                end
                try
                    [widths(c), ~, ~,  ~] = getSpikeWidth(wvfrm);
                    widths(c) = widths(c) / 30e3;
                catch
                    widths(c) = nan;
                end
                % try
                
                % catch
                %     es(c) = nan;
                %     t2p(c) = nan;
                % end
                if t2p(c) < 0 && strcmp(spike_class{c}, 'NS')
                    keyboard
                end
            end
            widths = widths(strcmp(spiking_data.quality, 'good'));
            sessions = sessions(strcmp(spiking_data.quality, 'good'));
            frs = spiking_data(strcmp(spiking_data.quality, 'good'),:).avg_trial_fr;
            es = es(strcmp(spiking_data.quality, 'good'));
            t2p = t2p(strcmp(spiking_data.quality, 'good'));
            spike_class = spike_class(strcmp(spiking_data.quality, 'good'));
            regions = regions(strcmp(spiking_data.quality, 'good'));
            wvfrms = wvfrms(strcmp(spiking_data.quality, 'good'),:);
            widths = widths(strcmp(spike_class, 'NS'));
            sessions = sessions(strcmp(spike_class, 'NS'));
            es = es(strcmp(spike_class, 'NS'));
            t2p = t2p(strcmp(spike_class, 'NS'));
            regions = regions(strcmp(spike_class, 'NS'));
            wvfrms = wvfrms(strcmp(spike_class, 'NS'),:);
            all_widths = [all_widths; widths];
            all_end_slopes = [all_end_slopes; es];
            all_t2p = [all_t2p; t2p];
            all_regions = vertcat(all_regions, regions);
            all_frs = [all_frs; frs];
            all_wvfrms = [all_wvfrms; wvfrms];
            all_sessions = vertcat(all_sessions, sessions);
        end
        
        all_t2p = all_t2p ./ 30;
        all_widths = all_widths * 10e2;
        
        pfc_inds = startsWith(all_regions, 'DP') + startsWith(all_regions, 'AC') ...
            + startsWith(all_regions, 'PL') + startsWith(all_regions, 'IL') ...
            + startsWith(all_regions, 'OR') + startsWith(all_regions, 'MO');
        ss_inds = startsWith(all_regions, 'SS');

        % classification and silhouette scores by session 
        X = [all_widths, all_t2p];
        idx = kmeans(X, 2);
        for i = 1:length(ap_files)
            X_tmp = X(strcmp(all_sessions, ap_files{i}),:);
            idx_tmp = idx(strcmp(all_sessions, ap_files{i}),:);
            s = silhouette(X_tmp, idx_tmp, 'sqeuclidean');
            figure(); histogram(s, -1:.2:1); xlim([-1,1])
        end
        s = silhouette(X, idx, 'sqeuclidean');
    end    

    % figure(); plot(all_t2p(idx == 1), all_widths(idx == 1), 'o', 'MarkerFaceColor', [0,0,0], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 5)
    % hold on
    % plot(all_t2p(idx == 2), all_widths(idx == 2), 'o', 'MarkerFaceColor', [0.5,0.5,0.5], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 5)

    resave = false;
    if resave
        last_animal = '';
        for i = 1:length(ap_files)
            session = ap_files{i}(1:end-4);
            sesh_parts = strsplit(session, '_');
            subj = sesh_parts{2};
            idx_tmp = idx(strcmp(all_sessions, ap_files{i}),:);
            s_tmp = s(strcmp(all_sessions, ap_files{i}),:);
            cell_count = 1;
            if ~strcmp(subj, last_animal)
                try 
                    ftr_file = strcat(ftr_path, 'AP/', session(18:end-3), '_adjusted.mat');
                    load(ftr_file)
                    last_ftr_file = ftr_file;
                    disp(ftr_file)
                catch
                    ftr_file = strcat(ftr_path, 'AP/', session(18:end), '.mat');
                    load(ftr_file)
                    disp(ftr_file)
                    last_ftr_file = ftr_file;
                end
            else
                ftr_file = last_ftr_file;
            end
            last_animal = subj;
            for c = 1:size(ap_ftr,1)
                if strcmp(ap_ftr(c,:).session_id, session) & (strcmp(ap_ftr(c,:).waveform_class, 'RS') || strcmp(ap_ftr(c,:).waveform_class, 'FS'))
                    if idx_tmp(cell_count) == 1 && s_tmp(cell_count) > 0.25
                        ap_ftr(c,:).waveform_class{1} = 'RS';
                        cell_count = cell_count + 1;
                    elseif idx_tmp(cell_count) == 2 && s_tmp(cell_count) > 0.25
                        ap_ftr(c,:).waveform_class{1} = 'FS';
                        cell_count = cell_count + 1;
                    elseif s_tmp(cell_count) <= 0.25
                        ap_ftr(c,:).waveform_class{1} = 'NS';
                        cell_count = cell_count + 1;
                    else
                        ap_ftr(c,:).waveform_class{1} = 'NS';
                    end
                end
            end
            ftr_parts = strsplit(ftr_file, '.');
            ftr_parts{1} = strcat(ftr_parts{1}, '_sill_v2');
            ftr_file = strcat(ftr_parts{1}, '.', ftr_parts{2});
            save(ftr_file, 'ap_ftr', '-v7.3')
        end
    end

    if loadData
        load('spike_classification_data_v2.mat')
    end

    % fig = figure(); plot(all_t2p(idx == 1 & s > 0.25), all_widths(idx == 1 & s > 0.25), 'o', 'MarkerFaceColor', [0.5,0.5,0.5], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 5)
    % hold on
    % plot(all_t2p(idx == 2 & s > 0.25), all_widths(idx == 2 & s > 0.25), 'o', 'MarkerFaceColor', [0,0,0], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 5)
    % plot(all_t2p(s <= 0.25), all_widths(s < 0.25), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 5)
    % xlim([0,0.9])
    
    fig = figure('Position', [1220 1298 560 420]); 
    hold on 
    tl = tiledlayout(1,1, 'TileSpacing', 'tight');
    axs(1) = nexttile;
    ctx_inds = logical(ss_inds);
    ctx_widths = all_widths(ctx_inds);
    ctx_t2p = all_t2p(ctx_inds);
    ctx_frs = cell2mat(all_frs(ctx_inds));
    ctx_s = s(ctx_inds);
    ctx_idx = idx(ctx_inds);
    ctx_wvfrms = all_wvfrms(ctx_inds,:);
    ctx_widths = ctx_widths(~isnan(ctx_t2p));
    ctx_wvfrms = ctx_wvfrms(~isnan(ctx_t2p),:);
    ctx_frs = ctx_frs(~isnan(ctx_t2p),:);
    ctx_s = ctx_s(~isnan(ctx_t2p),:);
    ctx_idx = ctx_idx(~isnan(ctx_t2p),:);
    ctx_t2p = ctx_t2p(~isnan(ctx_t2p));
    ctx_widths = ctx_widths(ctx_s > 0.25);
    ctx_wvfrms = ctx_wvfrms(ctx_s > 0.25,:);
    ctx_frs = ctx_frs(ctx_s > 0.25,:);
    ctx_t2p = ctx_t2p(ctx_s > 0.25);
    ctx_idx = ctx_idx(ctx_s > 0.25);
    % scatter(ctx_t2p(ctx_idx == 1), ctx_widths(ctx_idx == 1), [], [0,0,0]);
    plot(ctx_t2p(ctx_idx == 1), ctx_widths(ctx_idx == 1), 'o', 'MarkerFaceColor', [0,0,0], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 5);
    hold on
    % scatter(ctx_t2p(ctx_idx == 2), ctx_widths(ctx_idx == 2), [], [0.5,0.5,0.5]);
    plot(ctx_t2p(ctx_idx == 2), ctx_widths(ctx_idx == 2), 'o', 'MarkerFaceColor', [0.5,0.5,0.5], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 5);
    xlim([0,0.9])
    ylim([0,0.6])
    title('Somatosensory Cortex')
    xlabel(tl, 'Trough-to-Peak (ms)')
    ylabel(tl, 'AP Half-Width (ms)')
    saveas(fig, '../Figures/ss_spikeWidth_by_peak2trough.svg')
    saveas(fig, '../Figures/ss_spikeWidth_by_peak2trough.fig')
    ss_wvfrms = ctx_wvfrms;
    ss_widths = ctx_widths;
    ss_wvfrms = ctx_wvfrms;
    ss_frs = ctx_frs;
    ss_t2p = ctx_t2p;
    ss_idx = ctx_idx;

    fig = figure('Position', [1220 1298 560 420]); 
    hold on 
    tl = tiledlayout(1,1, 'TileSpacing', 'tight');
    axs(1) = nexttile;
    ctx_inds = logical(pfc_inds);
    ctx_widths = all_widths(ctx_inds);
    ctx_t2p = all_t2p(ctx_inds);
    ctx_frs = cell2mat(all_frs(ctx_inds));
    ctx_s = s(ctx_inds);
    ctx_idx = idx(ctx_inds);
    ctx_wvfrms = all_wvfrms(ctx_inds,:);
    ctx_widths = ctx_widths(~isnan(ctx_t2p));
    ctx_wvfrms = ctx_wvfrms(~isnan(ctx_t2p),:);
    ctx_frs = ctx_frs(~isnan(ctx_t2p),:);
    ctx_s = ctx_s(~isnan(ctx_t2p),:);
    ctx_idx = ctx_idx(~isnan(ctx_t2p),:);
    ctx_t2p = ctx_t2p(~isnan(ctx_t2p));
    ctx_widths = ctx_widths(ctx_s > 0.25);
    ctx_wvfrms = ctx_wvfrms(ctx_s > 0.25,:);
    ctx_frs = ctx_frs(ctx_s > 0.25,:);
    ctx_t2p = ctx_t2p(ctx_s > 0.25);
    ctx_idx = ctx_idx(ctx_s > 0.25);
    % scatter(ctx_t2p(ctx_idx == 1), ctx_widths(ctx_idx == 1), [], [0,0,0]);
    plot(ctx_t2p(ctx_idx == 1), ctx_widths(ctx_idx == 1), 'o', 'MarkerFaceColor', [0,0,0], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 5);
    hold on
    % scatter(ctx_t2p(ctx_idx == 2), ctx_widths(ctx_idx == 2), [], [0.5,0.5,0.5]);
    plot(ctx_t2p(ctx_idx == 2), ctx_widths(ctx_idx == 2), 'o', 'MarkerFaceColor', [0.5,0.5,0.5], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 5);
    xlim([0,0.9])
    ylim([0,0.6])
    title('Prefrontal Cortex')
    xlabel(tl, 'Trough-to-Peak (ms)')
    ylabel(tl, 'AP Half-Width (ms)')
    saveas(fig, '../Figures/pfc_spikeWidth_by_peak2trough.svg')
    saveas(fig, '../Figures/pfc_spikeWidth_by_peak2trough.fig')
    pfc_wvfrms = ctx_wvfrms;
    pfc_widths = ctx_widths;
    pfc_wvfrms = ctx_wvfrms;
    pfc_frs = ctx_frs;
    pfc_t2p = ctx_t2p;
    pfc_idx = ctx_idx;

    fig = figure('Position', [1220 1298 560 420]); 
    hold on 
    tl = tiledlayout(1,1, 'TileSpacing', 'tight');
    axs(1) = nexttile;
    ctx_inds = strcmp(all_regions, 'STR') + strcmp(all_regions, 'CP');
    ctx_inds = logical(ctx_inds);
    ctx_widths = all_widths(ctx_inds);
    ctx_t2p = all_t2p(ctx_inds);
    ctx_frs = cell2mat(all_frs(ctx_inds));
    ctx_s = s(ctx_inds);
    ctx_idx = idx(ctx_inds);
    ctx_wvfrms = all_wvfrms(ctx_inds,:);
    ctx_widths = ctx_widths(~isnan(ctx_t2p));
    ctx_wvfrms = ctx_wvfrms(~isnan(ctx_t2p),:);
    ctx_frs = ctx_frs(~isnan(ctx_t2p),:);
    ctx_s = ctx_s(~isnan(ctx_t2p),:);
    ctx_idx = ctx_idx(~isnan(ctx_t2p),:);
    ctx_t2p = ctx_t2p(~isnan(ctx_t2p));
    ctx_widths = ctx_widths(ctx_s > 0.25);
    ctx_wvfrms = ctx_wvfrms(ctx_s > 0.25,:);
    ctx_frs = ctx_frs(ctx_s > 0.25,:);
    ctx_t2p = ctx_t2p(ctx_s > 0.25);
    ctx_idx = ctx_idx(ctx_s > 0.25);
    % scatter(ctx_t2p(ctx_idx == 1), ctx_widths(ctx_idx == 1), [], [0,0,0]);
    plot(ctx_t2p(ctx_idx == 1), ctx_widths(ctx_idx == 1), 'o', 'MarkerFaceColor', [0,0,0], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 5);
    hold on
    % scatter(ctx_t2p(ctx_idx == 2), ctx_widths(ctx_idx == 2), [], [0.5,0.5,0.5]);
    plot(ctx_t2p(ctx_idx == 2), ctx_widths(ctx_idx == 2), 'o', 'MarkerFaceColor', [0.5,0.5,0.5], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 5);
    xlim([0,0.9])
    ylim([0,0.6])
    title('Striatum')
    xlabel(tl, 'Trough-to-Peak (ms)')
    ylabel(tl, 'AP Half-Width (ms)')
    saveas(fig, '../Figures/str_spikeWidth_by_peak2trough.svg')
    saveas(fig, '../Figures/str_spikeWidth_by_peak2trough.fig')
    str_wvfrms = ctx_wvfrms;
    str_widths = ctx_widths;
    str_frs = ctx_frs;
    str_t2p = ctx_t2p;
    str_idx = ctx_idx;

    fig = figure('Position', [1220 1298 560 420]); 
    hold on 
    tl = tiledlayout(1,1, 'TileSpacing', 'tight');
    axs(1) = nexttile;
    ctx_inds = strcmp(all_regions, 'BLAp') + strcmp(all_regions, 'LA');
    ctx_inds = logical(ctx_inds);
    ctx_widths = all_widths(ctx_inds);
    ctx_t2p = all_t2p(ctx_inds);
    ctx_frs = cell2mat(all_frs(ctx_inds));
    ctx_s = s(ctx_inds);
    ctx_idx = idx(ctx_inds);
    ctx_wvfrms = all_wvfrms(ctx_inds,:);
    ctx_widths = ctx_widths(~isnan(ctx_t2p));
    ctx_wvfrms = ctx_wvfrms(~isnan(ctx_t2p),:);
    ctx_frs = ctx_frs(~isnan(ctx_t2p),:);
    ctx_s = ctx_s(~isnan(ctx_t2p),:);
    ctx_idx = ctx_idx(~isnan(ctx_t2p),:);
    ctx_t2p = ctx_t2p(~isnan(ctx_t2p));
    ctx_widths = ctx_widths(ctx_s > 0.25);
    ctx_wvfrms = ctx_wvfrms(ctx_s > 0.25,:);
    ctx_frs = ctx_frs(ctx_s > 0.25,:);
    ctx_t2p = ctx_t2p(ctx_s > 0.25);
    ctx_idx = ctx_idx(ctx_s > 0.25);
    % scatter(ctx_t2p(ctx_idx == 1), ctx_widths(ctx_idx == 1), [], [0,0,0]);
    plot(ctx_t2p(ctx_idx == 1), ctx_widths(ctx_idx == 1), 'o', 'MarkerFaceColor', [0,0,0], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 5);
    hold on
    % scatter(ctx_t2p(ctx_idx == 2), ctx_widths(ctx_idx == 2), [], [0.5,0.5,0.5]);
    plot(ctx_t2p(ctx_idx == 2), ctx_widths(ctx_idx == 2), 'o', 'MarkerFaceColor', [0.5,0.5,0.5], 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 5);
    xlim([0,0.9])
    ylim([0,0.6])
    title('Amygdala')
    xlabel(tl, 'Trough-to-Peak (ms)')
    ylabel(tl, 'AP Half-Width (ms)')
    saveas(fig, '../Figures/amyg_spikeWidth_by_peak2trough.svg')
    saveas(fig, '../Figures/amyg_spikeWidth_by_peak2trough.fig')
    ag_wvfrms = ctx_wvfrms;
    ag_widths = ctx_widths;
    ag_frs = ctx_frs;
    ag_t2p = ctx_t2p;
    ag_idx = ctx_idx;

    ss_fig = figure();
    p = piechart([sum(ss_idx == 2), sum(ss_idx == 1)], {'FS', 'RS'});
    colororder([0.5,0.5,0.5;0,0,0])
    p.FaceAlpha = 1;
    % p.LabelStyle = None;
    saveas(ss_fig, '../Figures/ss_cellClass_pct.svg')
    saveas(ss_fig, '../Figures/ss_cellClass_pct.fig')

    pfc_fig = figure();
    p = piechart([sum(pfc_idx == 2), sum(pfc_idx == 1)], {'FS', 'RS'});
    colororder([0.5,0.5,0.5;0,0,0])
    p.FaceAlpha = 1;
    % p.LabelStyle = None;
    saveas(pfc_fig, '../Figures/pfc_cellClass_pct.svg')
    saveas(pfc_fig, '../Figures/pfc_cellClass_pct.fig')

    bg_fig = figure();
    p = piechart([sum(str_idx == 2), sum(str_idx == 1)], {'FS', 'RS'});
    % p.LabelStyle = None;
    colororder([0.5,0.5,0.5;0,0,0])
    p.FaceAlpha = 1;
    saveas(bg_fig, '../Figures/bg_cellClass_pct.svg')
    saveas(bg_fig, '../Figures/bg_cellClass_pct.fig')

    ag_fig = figure();
    p = piechart([sum(ag_idx == 2), sum(ag_idx == 1)], {'FS', 'RS'});
    colororder([0.5,0.5,0.5;0,0,0])
    p.FaceAlpha = 1;
    % p.LabelStyle = None;
    saveas(ag_fig, '../Figures/ag_cellClass_pct.svg')
    saveas(ag_fig, '../Figures/ag_cellClass_pct.fig')

    rs_ss_wvfrms = ss_wvfrms(ss_idx == 2, :);
    fs_ss_wvfrms = ss_wvfrms(ss_idx == 1, :);
    ss_wvfrm_fig = figure(); hold on;
    plot(linspace(0,(size(rs_ss_wvfrms,1)/30),61), mean(rs_ss_wvfrms), 'Color', [0.5,0.5,0.5], 'LineWidth', 3)
    plot(linspace(0,(size(rs_ss_wvfrms,1)/30),61), mean(fs_ss_wvfrms), 'Color', [0.0,0.0,0.0], 'LineWidth', 3)
    xlabel('Time (ms)')
    ylabel('Voltage (\muV)')
    saveas(ss_wvfrm_fig, '../Figures/ss_wvfrms.svg')
    saveas(ss_wvfrm_fig, '../Figures/ss_wvfrms.fig')

    rs_pfc_wvfrms = pfc_wvfrms(pfc_idx == 2, :);
    fs_pfc_wvfrms = pfc_wvfrms(pfc_idx == 1, :);
    pfc_wvfrm_fig = figure(); hold on;
    plot(linspace(0,(size(rs_pfc_wvfrms,1)/30),61), mean(rs_pfc_wvfrms), 'Color', [0.5,0.5,0.5], 'LineWidth', 3)
    plot(linspace(0,(size(rs_pfc_wvfrms,1)/30),61), mean(fs_pfc_wvfrms), 'Color', [0.0,0.0,0.0], 'LineWidth', 3)
    xlabel('Time (ms)')
    ylabel('Voltage (\muV)')
    saveas(pfc_wvfrm_fig, '../Figures/pfc_wvfrms.svg')
    saveas(pfc_wvfrm_fig, '../Figures/pfc_wvfrms.fig')

    rs_str_wvfrms = str_wvfrms(str_idx == 2, :);
    fs_str_wvfrms = str_wvfrms(str_idx == 1, :);
    str_wvfrm_fig = figure(); hold on;
    plot(linspace(0,(size(rs_str_wvfrms,1)/30),61), mean(rs_str_wvfrms), 'Color', [0.5,0.5,0.5], 'LineWidth', 3)
    plot(linspace(0,(size(rs_str_wvfrms,1)/30),61), mean(fs_str_wvfrms), 'Color', [0.0,0.0,0.0], 'LineWidth', 3)
    xlabel('Time (ms)')
    ylabel('Voltage (\muV)')
    saveas(str_wvfrm_fig, '../Figures/str_wvfrms.svg')
    saveas(str_wvfrm_fig, '../Figures/str_wvfrms.fig')

    rs_ag_wvfrms = ag_wvfrms(ag_idx == 2, :);
    fs_ag_wvfrms = ag_wvfrms(ag_idx == 1, :);
    ag_wvfrm_fig = figure(); hold on;
    plot(linspace(0,(size(rs_ag_wvfrms,1)/30),61), mean(rs_ag_wvfrms), 'Color', [0.5,0.5,0.5], 'LineWidth', 3)
    plot(linspace(0,(size(rs_ag_wvfrms,1)/30),61), mean(fs_ag_wvfrms), 'Color', [0.0,0.0,0.0], 'LineWidth', 3)
    xlabel('Time (ms)')
    ylabel('Voltage (\muV)')
    saveas(ag_wvfrm_fig, '../Figures/ag_wvfrms.svg')
    saveas(ag_wvfrm_fig, '../Figures/ag_wvfrms.fig')

    if ~loadData
        save('spike_classification_data_v2.mat')
    end

end

function out = classifySpkWaveform(wvfrm, fsRsThreshold)
    [neg_amp, neg_ind] = max(abs(wvfrm));
    if wvfrm(neg_ind) > 0
        out = 'PS';
    else
        [width, first_ind, last_ind, half_max] = getSpikeWidth(wvfrm);
        [pks, locs] = findpeaks(wvfrm, 'MinPeakProminence', 1);
        if ~isempty(pks) && locs(1) < neg_ind
            if length(locs(locs < neg_ind)) > 1
                [first_peak, fp_ind] = max(pks(locs < neg_ind));
                try
                    nplocs = locs(locs > neg_ind);
                    np_ind = nplocs(1);
                catch
                    [~, np_ind] = max(wvfrm(neg_ind+1:end));
                    np_ind = np_ind + neg_ind;
                end
            else
                first_peak = pks(1);
                fp_ind = locs(1);
                try
                    np_ind = locs(2);
                catch
                    [~, np_ind] = max(wvfrm(neg_ind+1:end));
                    np_ind = np_ind + neg_ind;
                end
            end
            if (first_peak >= 0.1*neg_amp) 
                if width < 20
                    out = 'TS';
                else
                    out = 'CS';
                end
            else 
                % if width < fsRsThreshold
                %     out = 'FS';
                % else
                %     out = 'RS';
                % end
                out = 'NS';
            end
        else
            % if width < fsRsThreshold
            %     out = 'FS';
            % else
            %     out = 'RS';
            % end
            out = 'NS';
        end
    end
end

function [out, first_ind, last_ind, half_max] = getSpikeWidth(wvfrm)
    y = abs(wvfrm);
    x1 = 1:length(wvfrm);
    x2 = 1:0.1:length(wvfrm);
    y = spline(x1, y, x2);
    [amp, ind] = max(y);
    half_max = amp / 2;
    first_ind = find(y(1:ind) <= half_max, 1, 'last');
    last_ind = find(y(ind+1:end) <= half_max, 1, 'first') + ind;
    first_ind = x2(first_ind);
    last_ind = x2(last_ind);
    out = last_ind - first_ind;
    % figure(); plot(y); hold on; plot([first_ind, last_ind],[half_max, half_max], 'k--')
end

function [out, trough2peak] = getEndSlope(wvfrm)
    x1 = 1:length(wvfrm);
    x2 = 1:0.1:length(wvfrm);
    y = spline(x1, wvfrm, x2);
    [~, ~, last_ind, ~] = getSpikeWidth(wvfrm);
    last_ind = find(x2==last_ind);
    [post_peak, post_peak_ind] = max(y(last_ind:end));
    % [post_min, post_min_ind] = min(y(last_ind+post_peak_ind:end));
    try
        post_min = y(last_ind+post_peak_ind+25);
    catch
        post_min = y(end);
    end
    try
        out = (post_min - post_peak) / (x2(last_ind+post_peak_ind+25) - x2(last_ind+post_peak_ind));
    catch
        out = (post_min - post_peak) / (x2(end) - x2(last_ind+post_peak_ind));
    end
    [~, min_ind] = min(y);
    trough2peak = x2(last_ind+post_peak_ind) - x2(min_ind);

    % figure(); plot(x2, y); hold on;
    % plot(x2(last_ind+post_peak_ind), post_peak, 'b*')
    % plot(x2(last_ind+post_peak_ind+20), post_min, 'r*')
    % if out > 0
    %     keyboard
    % end
end