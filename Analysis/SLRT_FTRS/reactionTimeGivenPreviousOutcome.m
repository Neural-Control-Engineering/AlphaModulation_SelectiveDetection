function out = reactionTimeGivenPreviousOutcome(slrt_data)
    outcomes = {'Hit', 'Miss', 'CR', 'FA', 'Pass'};
    rt_outcome = zeros(1,length(outcomes));
    for o = 1:length(outcomes)
        outcome = outcomes{o};
        outcome_inds = find(strcmp(slrt_data.categorical_outcome, outcome));
        next_inds = outcome_inds + 1;
        next_inds = next_inds(next_inds <= size(slrt_data,1));
        tmp_slrt = slrt_data(next_inds,:);
        rt_outcome(o) = nanmean(cell2mat(tmp_slrt.reaction_time));
    end
    performance = {{'Hit', 'CR'}, {'Miss', 'FA'}};
    rt_performance = zeros(1,length(performance));
    for p = 1:length(performance)
        rts = [];
        for o = 1:length(performance{p})
            outcome = performance{p}{o};
            outcome_inds = find(strcmp(slrt_data.categorical_outcome, outcome));
            next_inds = outcome_inds + 1;
            next_inds = next_inds(next_inds <= size(slrt_data,1));
            tmp_slrt = slrt_data(next_inds,:);
            rts = [rts; cell2mat(tmp_slrt.reaction_time)];
        end
        rt_performance(p) = nanmean(rts);
    end
    action = {{'Hit', 'FA'}, {'Miss', 'CR'}};
    rt_action = zeros(1,length(performance));
    for p = 1:length(action)
        rts = [];
        for o = 1:length(action{p})
            outcome = action{p}{o};
            outcome_inds = find(strcmp(slrt_data.categorical_outcome, outcome));
            next_inds = outcome_inds + 1;
            next_inds = next_inds(next_inds <= size(slrt_data,1));
            tmp_slrt = slrt_data(next_inds,:);
            rts = [rts; cell2mat(tmp_slrt.reaction_time)];
        end
        rt_action(p) = nanmean(rts);
    end
    out = [rt_outcome, rt_performance, rt_action];
end