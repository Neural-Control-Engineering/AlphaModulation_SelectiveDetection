function expandApFtr(ftr_file, ext_path, session_ids, fnc_handle, fnc_arg_str)
    ftr = load(ftr_file);
    out = [];
    for i = 1:length(session_ids)
        session_id = session_ids{i};
        slrt_ext = load(strcat(ext_path, 'SLRT/', session_id, '.mat'));
        ap_ext = load(strcat(ext_path, 'AP/', session_id, '.mat'));
        ap_ftr = ftr.ap_ftr(strcmp(ftr.ap_ftr.session_id, session_id),:);
        expression = sprintf('ap_ftr = fnc_handle(%s);', fnc_arg_str);
        eval(expression)
        if isempty(out)
            out = ap_ftr;
        else
            out = combineTables(out, ap_ftr);
        end
    end
    ap_ftr = out;
    keyboard
    save(ftr_file, 'ap_ftr', '-v7.3')
end