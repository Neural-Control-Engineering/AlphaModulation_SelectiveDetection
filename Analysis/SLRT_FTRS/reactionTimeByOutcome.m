function out = reactionTimeByOutcome(slrt_data)
    outcomes = {'Hit', 'FA'};
    out = zeros(1,length(outcomes));
    for o = 1:length(outcomes)
        tmp_slrt = slrt_data(strcmp(slrt_data.categorical_outcome, outcomes{o}),:);
        out(o) = nanmean(cell2mat(tmp_slrt.reaction_time));
    end
end