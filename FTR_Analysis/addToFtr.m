function addToFtr(ftr_file, ext_path)
    load(ftr_file)
    sessions = unique(ap_ftr.session_id);

    for s = 1:length(sessions)
        session_id = sessions{s};
        tmp_ftr = ap_ftr(strcmp(ap_ftr.session_id, session_id),:);
        ap_ext = load(strcat(ext_path, 'AP/', session_id, '.mat'));
        slrt_ext = load(strcat(ext_path, 'SLRT/', session_id, '.mat'));
        for t = 1:size(ap_ext.ap_data,1)
            ap_ext.ap_data(t,:).spiking_data{1} = ap_ext.ap_data(t,:).spiking_data{1}(strcmp(ap_ext.ap_data(t,:).spiking_data{1}.quality, 'good'),:);
        end
        tmp = evokedLfpPhaseHists(tmp_ftr, ap_ext.ap_data, {'left_trigger', 'right_trigger'});
        tmp = evokedLfpPhaseHistByOutcome(tmp, ap_ext.ap_data, slrt_ext.slrt_data, {'left_trigger', 'right_trigger'});
        if s == 1
            out = tmp;
        else
            out = combineTables(out, tmp);
        end
    end

    ap_ftr = out;
    save(ftr_file, 'ap_ftr', '-v7.3')
end