function out = baselineDeltaPowerByOutcome(lfp_session, lfp_data, slrt_data, event_names)
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    actions = {{'Hit', 'FA'}, {'Miss', 'CR'}};
    performance = {{'Hit', 'CR'}, {'Miss', 'FA'}};
    out = lfp_session;
    for i = 1:length(outcomes)
        outcome = outcomes{i};
        tmp_lfp = lfp_data(strcmp(slrt_data.categorical_outcome, outcome), :);
        for e = 1:length(event_names)
            if ~all(cellfun(@isempty,tmp_lfp.(strcat(event_names{e}, '_aligned_baseline_delta_power'))))
                variable_name = strcat(event_names{e}, '_aligned_baseline_delta_power');
                mat = zeros(385, size(tmp_lfp,1));
                for t = 1:size(tmp_lfp,1)
                    mat(:,t) = tmp_lfp.(variable_name){1};
                end
                avg_baseline = num2cell(mean(mat,2));
                out = [out, table(avg_baseline, 'VariableNames', {strcat('avg_baseline_delta_power_', outcomes{i})})];
            end
        end
    end
end