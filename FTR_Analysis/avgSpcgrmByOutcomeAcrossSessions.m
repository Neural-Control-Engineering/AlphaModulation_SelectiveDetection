function avgSpcgrmByOutcomeAcrossSessions(ftr_path, session_ids, out_path)
    for s = 1:length(session_ids)
        ftr_files{s} = strcat(ftr_path, session_ids{s}, '.mat');
    end
    mkdir(out_path)
    for channel = 1:5:385
        for f = 1:length(ftr_files)
            data = load(ftr_files{f});
            if f == 1
                hit = data.lfp_session(channel,:).avg_spectrogram_Hit{1};
                miss = data.lfp_session(channel,:).avg_spectrogram_Miss{1};
                cr = data.lfp_session(channel,:).avg_spectrogram_CR{1};
                fa = data.lfp_session(channel,:).avg_spectrogram_FA{1};
            else
                hit(:,:,f) = data.lfp_session(channel,:).avg_spectrogram_Hit{1};
                miss(:,:,f) = data.lfp_session(channel,:).avg_spectrogram_Miss{1};
                cr(:,:,f) = data.lfp_session(channel,:).avg_spectrogram_CR{1};
                fa(:,:,f) = data.lfp_session(channel,:).avg_spectrogram_FA{1};
            end
        end
        t = linspace(-3,5,size(hit,2));
        f = linspace(0,250,size(hit,1));
        fig = figure('Position', [1220 1195 935 350]);
        tl = tiledlayout(1,4,'TileSpacing', 'tight');
        colormap('jet')
        axs = zeros(1,4);
        axs(1) = nexttile;
        imagesc(t,f,log10(mean(hit,3)))
        xlim([-1,3])
        ylim([0,100])
        clim([-11,-9])
        set(gca, 'YDir', 'normal')
        title('Hit')
        axs(2) = nexttile;
        imagesc(t,f,log10(mean(miss,3)))
        xlim([-1,3])
        ylim([0,100])
        clim([-11,-9])
        set(gca, 'YDir', 'normal')
        title('Miss')
        yticklabels({})
        axs(3) = nexttile;
        imagesc(t,f,log10(mean(cr,3)))
        xlim([-1,3])
        ylim([0,100])
        clim([-11,-9])
        set(gca, 'YDir', 'normal')
        title('Correct Rejection')
        yticklabels({})
        axs(4) = nexttile;
        imagesc(t,f,log10(mean(fa,3)))
        xlim([-1,3])
        ylim([0,100])
        clim([-11,-9])
        title('False Alarm')
        yticklabels({})
        cbar = colorbar();
        set(gca, 'YDir', 'normal')
        xlabel(tl, 'Time (s)')
        ylabel(tl, 'Frequency')
        title(cbar, 'log power')
        title(tl, sprintf('Channel: %i', channel))
        fname = sprintf('%s/avg_spcgrm_%i.svg', out_path, channel);
        saveas(fig, fname); 
        fname = sprintf('%s/avg_spcgrm_%i.fig', out_path, channel);
        saveas(fig, fname); 
        close; clear fig
    end
end
