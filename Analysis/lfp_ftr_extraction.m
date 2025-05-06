addpath(genpath('./'))
addpath(genpath('~/n-CORTEx/'))
addpath(genpath('~/circstat-matlab/'))
addpath(genpath('~/chronux_2_12/'))
sessionIDs 
init_paths 

ksChanMap = load(strcat(subject_path, '3387-20240121/neuropixPhase3A_kilosortChanMap.mat'));

% extToFtrLFP(ext_path, expert_3387_lfp_session_ids, ftr_path, ksChanMap.chanMap);

extToFtrLFP(ext_path, expert_3738_lfp_session_ids, ftr_path, false);

% extToFtrLFP(ext_path, expert_3755_session_ids, ftr_path, false)

% extToFtrLFP(ext_path, expert_1075_session_ids, ftr_path, false)