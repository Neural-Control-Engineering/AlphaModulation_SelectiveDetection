addpath(genpath('./'))
addpath(genpath('~/n-CORTEx/'))

sessionIDs

session_ids = horzcat(expert_3387_session_ids, expert_3738_session_ids, expert_3755_session_ids, expert_1075_session_ids);

slrt_path = '~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/RAW/SLRT/';

for i = 1:length(session_ids)
    rawToExtSLRT(session_ids{i}, slrt_path)
end
