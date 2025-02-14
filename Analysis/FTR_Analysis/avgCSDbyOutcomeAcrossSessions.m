function avgCSDByOutcomeAcrossSessions(ftr_path, session_ids, out_path)
    for s = 1:length(session_ids)
        ftr_files{s} = strcat(ftr_path, session_ids{s}, '.mat');
    end
    mkdir(out_path)
    for f = 1:length(ftr_files)
        data = load(ftr_files{f});
        if f == 1
            hit = data.outs{1}(:,1:3999);
            miss = data.outs{2}(:,1:3999);
            cr = data.outs{3}(:,1:3999);
            fa = data.outs{4}(:,1:3999);
        else
            hit(:,:,f) = data.outs{1}(:,1:3999);
            miss(:,:,f) = data.outs{2}(:,1:3999);
            cr(:,:,f) = data.outs{3}(:,1:3999);
            fa(:,:,f) = data.outs{4}(:,1:3999);
        end
    end
    t = linspace(-3,5,size(hit,2));
    y = 1:size(hit,1);
    fig = figure('Position', [1220 1195 935 350]);
    tl = tiledlayout(1,4,'TileSpacing', 'tight');
    colormap('jet')
    axs = zeros(1,4);
    axs(1) = nexttile;
    imagesc(t,f,(mean(hit,3)))
    xlim([-1,3])
    set(gca, 'YDir', 'normal')
    title('Hit')
    axs(2) = nexttile;
    imagesc(t,f,(mean(miss,3)))
    xlim([-1,3])
    set(gca, 'YDir', 'normal')
    title('Miss')
    axs(3) = nexttile;
    imagesc(t,f,(mean(cr,3)))
    xlim([-1,3])
    set(gca, 'YDir', 'normal')
    title('Correct Rejection')
    axs(4) = nexttile;
    imagesc(t,f,(mean(fa,3)))
    xlim([-1,3])
    title('False Alarm')
    cbar = colorbar();
    set(gca, 'YDir', 'normal')
    xlabel(tl, 'Time (s)')
    ylabel(tl, 'Frequency')
    fname = sprintf('%s/avg_csd.png', out_path, channel);
    saveas(fig, fname); close; clear fig
end
