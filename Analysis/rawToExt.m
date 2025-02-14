function rawToExt(session_id, slrt_path, ap_path, lfp_path)
    % slrt extraction
    slrt_file = strcat(slrt_path, session_id, '.mat');
    slrt_data = extractEXT_SLRT(slrt_file);
    % add columns to slrt 
    slrt_data = categoricalOutcome(slrt_data, 200, 1500);
    slrt_data = dPrime(slrt_data);
    slrt_data = Criterion(slrt_data);
    % save extracted slrt
    path_parts = strsplit(slrt_path, 'RAW/');
    out_path = strcat(path_parts{1}, 'EXT/SLRT/');
    mkdir(out_path)
    save(strcat(out_path, session_id, '.mat'), 'slrt_data')

    % ap extraction 
    % add columns to npxls 
    ap_data = extAP(slrt_data, ap_path);
    ap_data = PSTHs(ap_data, -3, 5, 0.1);
    variable_names = getVariableNames(ap_data(1,:).spiking_data{1}, 'aligned_spike_times');
    ap_data = baselineFRs(ap_data, variable_names, -1, 0);
    ap_data = evokedFRs(ap_data, variable_names, 0, 0.2);
    ap_data = spontaneousCV(ap_data, {variable_names{1}, variable_names{4}});
    ap_data = firingRates(ap_data, 0.1, 5);
    ap_data = covarianceMatrix(ap_data, {'left_trigger', 'right_trigger'});
    ap_data = spontaneousCovMat(ap_data, {'left_trigger', 'right_trigger'}, -3:0.1:5);

    % generate LFP data table
    lfp_data = extLFP(slrt_data, lfp_path);

    % add columns to lfp data 
    variable_names = getVariableNames(lfp_data, 'aligned_lfp_time');
    variable_names = {variable_names{1}, variable_names{4}};
    lfp_data = baselineAlphaPower(lfp_data, variable_names, -1, 0);
    lfp_data = baselineDeltaPower(lfp_data, variable_names, -1, 0);
    lfp_data = baselineThetaPower(lfp_data, variable_names, -1, 0);
    lfp_data = baselineBetaPower(lfp_data, variable_names, -1, 0);
    lfp_data = baselineLowGammaPower(lfp_data, variable_names, -1, 0);
    lfp_data = baselineHighGammaPower(lfp_data, variable_names, -1, 0);
    lfp_data = baselineGammaPower(lfp_data, variable_names, -1, 0);

    ap_data = instDeltaPhaseEachSpike(ap_data, lfp_data);
    ap_data = instThetaPhaseEachSpike(ap_data, lfp_data);
    ap_data = instAlphaPhaseEachSpike(ap_data, lfp_data);
    ap_data = instBetaPhaseEachSpike(ap_data, lfp_data);

    % save ap data
    out_path = strcat(path_parts{1}, 'EXT/AP/');
    mkdir(out_path)
    save(strcat(out_path, session_id, '.mat'), 'ap_data')

    % save lfp data
    out_path = strcat(path_parts{1}, 'EXT/LFP/');
    mkdir(out_path)
    save(strcat(out_path, session_id, '.mat'), 'lfp_data', '-v7.3')

end