function autocorrQC(ap_ftr, excld_file)
    init_paths;
    session_id = ap_ftr(1,:).session_id{1};
    load(strcat(ext_path, 'AP/', session_id, '.mat'))
    binSize = 0.001;
    maxLag = 0.05;
    excld = [];
    %excld = [excld, c];
    for c = 1:size(ap_ftr,1)
        if ~strcmp(session_id, ap_ftr(c,:).session_id{1})
            session_id = ap_ftr(c,:).session_id{1};
            load(strcat(ext_path, 'AP/', session_id, '.mat'))
        end
        cluster_id = ap_ftr(c,:).cluster_id;
        spks = gatherSpikes(ap_data, cluster_id);
        [acf, binCenters] = compute_autocorrelogram(spks, binSize, maxLag);
        fig = figure();
        bar(binCenters, acf, 'k');
        xlabel('Lag (s)');
        ylabel('Count');
        xlim([-maxLag, maxLag]);
        keyboard 
    end
    save(excld_file, 'excld')
end
