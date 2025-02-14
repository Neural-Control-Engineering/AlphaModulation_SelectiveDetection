function rawToExtLFP(session_id, slrt_path, lfp_path)
    % load extracted slrt
    path_parts = strsplit(slrt_path, 'RAW/');
    out_path = strcat(path_parts{1}, 'EXT/SLRT/');
    mkdir(out_path)
    slrt_ext = load(strcat(out_path, session_id, '.mat'));

    % generate LFP data table
    lfp_data = extLFP(slrt_ext.slrt_data, lfp_path);

    % add columns to lfp data 
    variable_names = getVariableNames(lfp_data, 'aligned_lfp_time');
    variable_names = {variable_names{1}, variable_names{3}};
    lfp_data = baselineAlphaPower(lfp_data, variable_names, -1, 0);
    lfp_data = baselineDeltaPower(lfp_data, variable_names, -1, 0);
    lfp_data = baselineThetaPower(lfp_data, variable_names, -1, 0);
    lfp_data = baselineBetaPower(lfp_data, variable_names, -1, 0);
    lfp_data = baselineLowGammaPower(lfp_data, variable_names, -1, 0);
    lfp_data = baselineHighGammaPower(lfp_data, variable_names, -1, 0);
    lfp_data = baselineGammaPower(lfp_data, variable_names, -1, 0);

    % save lfp data
    out_path = strcat(path_parts{1}, 'EXT/LFP/');
    mkdir(out_path)
    save(strcat(out_path, session_id, '.mat'), 'lfp_data', '-v7.3')

end