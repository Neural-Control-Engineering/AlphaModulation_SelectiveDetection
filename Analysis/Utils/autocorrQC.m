function autocorrQC(ap_ftr, excld_file)
    init_paths;
    session_id = ap_ftr(1,:).session_id{1};
    load(strcat(ext_path, 'AP/', session_id, '.mat'))
    binSize = 0.001;
    maxLag = 0.05;
    if exist(excld_file, 'file')
        load(excld_file)
    else
        excld = {{}, {}};
    end
    ap_ftr = ap_ftr(cell2mat(ap_ftr.avg_trial_fr) > 0.5,:);
    ap_ftr = ap_ftr(strcmp(ap_ftr.waveform_class, 'RS') | strcmp(ap_ftr.waveform_class, 'FS'),:);
    for i = 1:length(excld{1})
        session_id = excld{1}{i};
        cid = excld{2}{i};
        ap_ftr(strcmp(ap_ftr.session_id, session_id) & ap_ftr.cluster_id == cid,:) = [];
    end

    %excld = [excld, c];
    for c = 1:size(ap_ftr,1)
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
        % [a,b] = findpeaks(acf, 'MinPeakHeight', 800);
        % if ~isempty(b)
        fig = figure();
        bar(binCenters, acf, 'k');
        xlabel('Lag (s)');
        ylabel('Count');
        xlim([-maxLag, maxLag]);
        keyboard
        % end
        % inpt_str = input('not good?');
        % if ~isempty(input_str)
        %     excld = addCluster(excld, c, ap_ftr);
        % end
        
        % excld{1} = vertcat(excld{1}, ap_ftr(c,:).session_id{1});
        % excld{2} = vertcat(excld{2}, ap_ftr(c,:).cluster_id);
    end
    % save(excld_file, 'excld')
    keyboard 
end


function out = addCluster(excld, c, ap_ftr)
    excld{1} = vertcat(excld{1}, ap_ftr(c,:).session_id{1});
    excld{2} = vertcat(excld{2}, ap_ftr(c,:).cluster_id);
    out = excld;
end