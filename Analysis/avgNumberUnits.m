load('~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Subjects/3738-20240702/regionMap.mat')
sessionIDs
session_ids = horzcat(expert_3387_session_ids, expert_3738_session_ids);
ctx_counts = zeros(1,length(session_ids));
bg_counts = zeros(1,length(session_ids));
for s = 1:length(session_ids)
    load(sprintf('~/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/AP/%s.mat', session_ids{s}));
    spiking_data = ap_data(1,:).spiking_data{1};
    spiking_data = assignRegions(spiking_data, regMap);
    spiking_data = spiking_data(strcmp(spiking_data.quality, 'good'),:);
    ctx_counts(s) = sum(startsWith(spiking_data.region, 'SS'));
    bg_counts(s) = sum(strcmp(spiking_data.region, 'STR') + strcmp(spiking_data.region, 'CP'));
end

