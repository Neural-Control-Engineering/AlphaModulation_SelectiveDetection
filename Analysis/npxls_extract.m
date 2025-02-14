addpath(genpath('~/n-CORTEx/'))
addpath(genpath('./'))
base_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/RAW/';
slrt_path = strcat(base_path, 'SLRT/');

ext_table = readtable('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Extraction-Logs/EXT_extraction_log.csv', 'Delimiter', ',');

% subjects = {'3738', '3387', '3755', '1075'}; %, '3752'};
subjects = {'3755', '1075'};
for s = 1:length(subjects)
    subject = subjects{s};
    tmp_table = ext_table(contains(ext_table.SessionName, subject),:);
    tmp_table = tmp_table(~tmp_table.Extracted,:);
    for sesh = 1:size(tmp_table,1)
        session_id = tmp_table(sesh,:).SessionName{1};
        trial_parts = strsplit(tmp_table(sesh,:).TrialMask{1}, '-');
        trigger = strcat('t', trial_parts{1});
        ap_path = sprintf('%sNPXLS/%s/%s_imec0/%s_%s_sorted/kilosort4/', base_path, session_id, session_id, session_id, trigger);
        lfp_path = sprintf('%sNPXLS/%s/%s_imec0/%s_%s_sorted/', base_path, session_id, session_id, session_id, trigger);
        fprintf(sprintf('starting %s', session_id));
        % rawToExtSLRT(session_id, slrt_path);
        rawToExtLFP(session_id, slrt_path, lfp_path);
        rawToExtAP(session_id, slrt_path, ap_path, lfp_path);
    end
end