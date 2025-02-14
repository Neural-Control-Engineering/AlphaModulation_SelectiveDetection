sessionIDs;
init_paths; 

map1 = load(strcat(subject_path, '3738-20240702/regionMap.mat'));
map2 = load(strcat(subject_path, '3755-20240828/regionMap.mat'));
map3 = load(strcat(subject_path, '1075-20241202/regionMap.mat'));
ap_dir = strcat(ext_path, 'AP/');
ap_files = horzcat(expert_3387_session_ids, expert_3738_session_ids, expert_3755_session_ids, expert_1075_session_ids);
for i = 1:length(ap_files)
    ap_files{i} = strcat(ap_files{i}, '.mat');
    if contains(ap_files{i}, '3755')
        regMaps{i} = map2.regMap;
    elseif contains(ap_files{i}, '1075')
        regMaps{i} = map3.regMap;
    else
        regMaps{i} = map1.regMap;
    end
end
negativeSpikeWidths(ap_dir, ap_files, regMaps)
