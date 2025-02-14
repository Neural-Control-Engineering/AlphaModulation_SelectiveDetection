function rawToExtSLRT(session_id, slrt_path)
    % slrt extraction
    slrt_file = strcat(slrt_path, session_id, '.mat');
    slrt_data = extractEXT_SLRT(slrt_file);
    % add columns to slrt 
    slrt_data = categoricalOutcome(slrt_data, 200, 1000);
    slrt_data = dPrime(slrt_data);
    slrt_data = Criterion(slrt_data);
    slrt_data = reactionTime(slrt_data);
    if contains(session_id, 'phase5')
        slrt_data = leftMinusRight(slrt_data);
    end
    % save extracted slrt
    path_parts = strsplit(slrt_path, 'RAW/');
    out_path = strcat(path_parts{1}, 'EXT/SLRT/');
    mkdir(out_path)
    save(strcat(out_path, session_id, '.mat'), 'slrt_data')
end