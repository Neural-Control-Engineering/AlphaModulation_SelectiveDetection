function out = categoricalOutcome(slrt_data, lockout, opportunity_window)
    % Adds column to slrt data for categorical outcome of each trial. 
    % Requires duration of lockout window and window of opportunity.
    
    outcomes = cell(size(slrt_data,1),1);
    for i = 1:size(slrt_data,1)
        stim_ind = slrt_data(i,:).right_trigger;
        if isnan(stim_ind)
            stim_ind = slrt_data(i,:).left_trigger;
        end
        if isnan(stim_ind) || length(slrt_data(i,:).lick_detector{1}) < (stim_ind+lockout+opportunity_window)
            outcomes{i} = 'Pass';
        elseif ~isempty(find(slrt_data(i,:).lick_detector{1}(stim_ind:(stim_ind+lockout))))
            outcomes{i} = 'Pass';
        elseif ~isnan(slrt_data(i,:).reward_trigger)
            outcomes{i} = 'Hit';
        elseif slrt_data(i,:).was_target{1}(stim_ind+1)
            outcomes{i} = 'Miss';
        elseif sum(slrt_data(i,:).lick_detector{1}(stim_ind:(stim_ind+lockout+opportunity_window)))
            outcomes{i} = 'FA';
        else
            outcomes{i} = 'CR';
        end
    end

    out = [slrt_data, table(outcomes, 'VariableNames', {'categorical_outcome'})];

end