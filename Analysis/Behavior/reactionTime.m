function out = reactionTime(slrt_data)
    rts = cell(size(slrt_data,1),1);
    t = linspace(-3,5,8001);
    for i = 1:size(slrt_data,1)
        if strcmp(slrt_data(i,:).categorical_outcome{1}, 'Hit') || strcmp(slrt_data(i,:).categorical_outcome{1}, 'FA')
            stim_ind = slrt_data(i,:).left_trigger;
            if isnan(stim_ind)
                stim_ind = slrt_data(i,:).right_trigger;
            end
            try
                react_inds = find(slrt_data(i,:).lick_detector{1}(stim_ind:stim_ind+5000)==1);
            catch
                react_inds = find(slrt_data(i,:).lick_detector{1}(stim_ind:end)==1);
            end
            try
                rts{i} = t(react_inds(1)+3000);
            catch 
                rts{i} = nan;
            end
        end
    end
    out = [slrt_data, table(rts, 'VariableNames', {'reaction_time'})];
end