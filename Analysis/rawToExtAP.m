function rawToExtAP(session_id, slrt_path, ap_path, lfp_path)
    % load extracted slrt
    path_parts = strsplit(slrt_path, 'RAW/');
    out_path = strcat(path_parts{1}, 'EXT/SLRT/');
    mkdir(out_path)
    slrt_ext = load(strcat(out_path, session_id, '.mat'));

    % ap extraction 
    % add columns to npxls 
    ap_data = extAP(slrt_ext.slrt_data, ap_path);
    ap_data = PSTHs(ap_data, -3, 5, 0.1);
    variable_names = getVariableNames(ap_data(1,:).spiking_data{1}, 'aligned_spike_times');
    ap_data = baselineFRs(ap_data, variable_names, -1, 0);
    ap_data = evokedFRs(ap_data, variable_names, 0, 0.2);
    ap_data = spontaneousCV(ap_data, {variable_names{1}, variable_names{3}});
    ap_data = firingRates(ap_data, 0.1, 5);
    ap_data = covarianceMatrix(ap_data, {'left_trigger', 'right_trigger'});
    ap_data = spontaneousCovMat(ap_data, {'left_trigger', 'right_trigger'}, -3:0.1:5);

    % load lfp data
    out_path = strcat(path_parts{1}, 'EXT/LFP/');
    mkdir(out_path)
    lfp_ext = load(strcat(out_path, session_id, '.mat'));

    ap_data = instDeltaPhaseEachSpike(ap_data, lfp_ext.lfp_data);
    ap_data = instThetaPhaseEachSpike(ap_data, lfp_ext.lfp_data);
    ap_data = instAlphaPhaseEachSpike(ap_data, lfp_ext.lfp_data);
    ap_data = instBetaPhaseEachSpike(ap_data, lfp_ext.lfp_data);

    % save ap data
    out_path = strcat(path_parts{1}, 'EXT/AP/');
    mkdir(out_path)
    save(strcat(out_path, session_id, '.mat'), 'ap_data', '-v7.3')

end