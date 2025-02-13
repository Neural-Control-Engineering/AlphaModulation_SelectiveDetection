function avgBaselineSpctrmByOutcomeAcrossSessions(ftr_path, session_ids, out_path)
    for s = 1:length(session_ids)
        ftr_files{s} = strcat(ftr_path, session_ids{s}, '.mat');
    end
    mkdir(out_path)
    for channel = 1:5:385
        for f = 1:length(ftr_files)
            data = load(ftr_files{f});
            if f == 1
                hit = data.lfp_session(channel,:).left_trigger_baseline_spectra_Hit{1};
                miss = data.lfp_session(channel,:).left_trigger_baseline_spectra_Miss{1};
                cr = data.lfp_session(channel,:).right_trigger_baseline_spectra_CR{1};
                fa = data.lfp_session(channel,:).right_trigger_baseline_spectra_FA{1};
                freq = data.lfp_session(channel,:).left_trigger_baseline_spectra_Hit_f{1};
            else
                hit(:,:,f) = data.lfp_session(channel,:).left_trigger_baseline_spectra_Hit{1};
                miss(:,:,f) = data.lfp_session(channel,:).left_trigger_baseline_spectra_Miss{1};
                cr(:,:,f) = data.lfp_session(channel,:).right_trigger_baseline_spectra_CR{1};
                fa(:,:,f) = data.lfp_session(channel,:).right_trigger_baseline_spectra_FA{1};
            end
            figure();
            tl = tiledlayout(1,4)
            axs(1) = nexttile;
            plot(freq, log10(data.lfp_session(channel,:).left_trigger_baseline_spectra_Hit{1}))
            xlim([0,100])
            axs(2) = nexttile;
            plot(freq, log10(data.lfp_session(channel,:).left_trigger_baseline_spectra_Miss{1}))
            xlim([0,100])
            axs(3) = nexttile;
            plot(freq, log10(data.lfp_session(channel,:).right_trigger_baseline_spectra_CR{1}))
            xlim([0,100])
            axs(4) = nexttile;
            plot(freq, log10(data.lfp_session(channel,:).right_trigger_baseline_spectra_FA{1}))
            xlim([0,100])
            title(tl, session_ids{f})
        end
        keyboard
        sz = size(hit);
        hit = reshape(hit, sz(2:end));
        sz = size(miss);
        miss = reshape(miss, sz(2:end));
        sz = size(cr);
        cr = reshape(cr, sz(2:end));
        sz = size(fa);
        fa = reshape(fa, sz(2:end));
        fig = figure('Position', [1220 1195 935 350]);
        tl = tiledlayout(1,4,'TileSpacing', 'tight');
        colormap('jet')
        axs = zeros(1,4);
        axs(1) = nexttile;
        semshade(log10(hit'), 0.3, 'k', 'k', freq, 1);
        xlim([0,30])
        set(gca, 'YDir', 'normal')
        title('Hit')
        axs(2) = nexttile;
        semshade(log10(miss'), 0.3, 'k', 'k', freq, 1);
        xlim([0,30])
        set(gca, 'YDir', 'normal')
        title('Miss')
        yticklabels({})
        axs(3) = nexttile;
        semshade(log10(cr'), 0.3, 'k', 'k', freq, 1);
        xlim([0,30])
        set(gca, 'YDir', 'normal')
        title('Correct Rejection')
        yticklabels({})
        axs(4) = nexttile;
        semshade(log10(fa'), 0.3, 'k', 'k', freq, 1);
        xlim([0,30])
        title('False Alarm')
        xlabel(tl, 'Frequency')
        ylabel(tl, 'log power')
        title(tl, sprintf('Channel: %i', channel))
        yticklabels({})
        unifyYLimits(fig)
        fname = sprintf('%s/avg_spcgrm_%i.fig', out_path, channel);
        saveas(fig, fname); 
        fname = sprintf('%s/avg_spcgrm_%i.svg', out_path, channel);
        saveas(fig, fname); 
        close; clear fig
    end
end
