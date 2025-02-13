function avg_psths = cellTypeFiringRateAvgs(ap_session, event_names)
    cell_types = unique(ap_session.waveform_class);
    ap_session = ap_session(strcmp(ap_session.quality, 'good'),:);
    outcomes = {'Hit', 'Miss', 'FA', 'CR'};
    actions = {{'Hit', 'FA'}, {'Miss', 'CR'}};
    performance = {{'Hit', 'CR'}, {'Miss', 'FA'}};
    avg_psths = cell(length(cell_types), length(outcomes)+length(actions)+length(performance)+1);
    for ct = 1:length(cell_types)
        tmp_ap_sesh = ap_session(strcmp(ap_session.waveform_class, cell_types{ct}),:);
        for o = 1:length(outcomes)
            vn = find(contains(tmp_ap_sesh.Properties.VariableNames, strcat('psth_', outcomes{o})) & ...
                (contains(tmp_ap_sesh.Properties.VariableNames, event_names{1}) | ...
                contains(tmp_ap_sesh.Properties.VariableNames, event_names{2})));
            psth_mat = cell2mat(tmp_ap_sesh.(tmp_ap_sesh.Properties.VariableNames{vn}));
            avg_psths{ct, o} = mean(psth_mat, 1, 'omitnan');
        end
    end
end