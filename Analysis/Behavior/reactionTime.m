function out = reactionTime(slrt_data)
    rts = cell(size(slrt_data,1),1);
    t = linspace(-3.5,5,8501);
    for i = 1:size(slrt_data,1)
        if strcmp(slrt_data(i,:).categorical_outcome{1}, 'Hit') || strcmp(slrt_data(i,:).categorical_outcome{1}, 'FA')
            stim_ind = slrt_data(i,:).left_trigger;
            if isnan(stim_ind)
                stim_ind = slrt_data(i,:).right_trigger;
            end
            try
                zero_ind = find(abs(linspace(-3.5,5,8501)) == min(abs(linspace(-3.5,5,8501))));
                zero_ind = zero_ind;
                react_inds = find(slrt_data(i,:).lick_detector{1}(stim_ind:stim_ind+(8501-zero_ind))==1);
            catch
                react_inds = find(slrt_data(i,:).lick_detector{1}(stim_ind:end)==1);
            end
            try
                rts{i} = t(react_inds(1)+zero_ind);
            catch 
                rts{i} = nan;
            end
        end
    end
    out = [slrt_data, table(rts, 'VariableNames', {'reaction_time'})];
end