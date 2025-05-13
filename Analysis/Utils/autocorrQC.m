function autocorrQC(ap_ftr, excld_file)
    init_paths;
    session_id = ap_ftr(1,:).session_id{1};
    load(strcat(ext_path, 'AP/', session_id, '.mat'))
    binSize = 0.001;
    maxLag = 0.05;
    excld = {{}, {}};
    %excld = [excld, c];
    for c = 704:size(ap_ftr,1)
        if ~strcmp(session_id, ap_ftr(c,:).session_id{1})
            session_id = ap_ftr(c,:).session_id{1};
            load(strcat(ext_path, 'AP/', session_id, '.mat'))
        end
        cluster_id = ap_ftr(c,:).cluster_id;
        spks = gatherSpikes(ap_data, cluster_id);
        if length(spks) > 10000
            spks = spks(1:10000);
        end
        [acf, binCenters] = compute_autocorrelogram(spks, binSize, maxLag);
        fig = figure();
        bar(binCenters, acf, 'k');
        xlabel('Lag (s)');
        ylabel('Count');
        xlim([-maxLag, maxLag]);
        keyboard 
        % excld{1} = vertcat(excld{1}, ap_ftr(c,:).session_id{1});
        % excld{2} = vertcat(excld{2}, ap_ftr(c,:).cluster_id);
    end
    save(excld_file, 'excld')
end


function out = addCluster(excld, c, ap_ftr)
    excld{1} = vertcat(excld{1}, ap_ftr(c,:).session_id{1});
    excld{2} = vertcat(excld{2}, ap_ftr(c,:).cluster_id);
    out = excld;
end