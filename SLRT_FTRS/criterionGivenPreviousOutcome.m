function out = criterionGivenPreviousOutcome(slrt_data)
    outcomes = {'Hit', 'Miss', 'CR', 'FA', 'Pass'};
    criterion_outcome = zeros(1,length(outcomes));
    for o = 1:length(outcomes)
        outcome = outcomes{o};
        outcome_inds = find(strcmp(slrt_data.categorical_outcome, outcome));
        next_inds = outcome_inds + 1;
        next_inds = next_inds(next_inds <= size(slrt_data,1));
        tmp_slrt = slrt_data(next_inds,:);
        hit_count = sum(strcmp(tmp_slrt.categorical_outcome, 'Hit'));
        fa_count = sum(strcmp(tmp_slrt.categorical_outcome, 'FA'));
        miss_count = sum(strcmp(tmp_slrt.categorical_outcome, 'Miss'));
        cr_count = sum(strcmp(tmp_slrt.categorical_outcome, 'CR'));

        target_count = hit_count + miss_count;
        distractor_count = fa_count + cr_count;

        hr = (hit_count+0.5)/(target_count+1.0);
        far = (fa_count+0.5)/(distractor_count+1.0);
            
        criterion = -0.5 * (norminv(hr) + norminv(far));
        criterion_outcome(o) = criterion;
    end
    performance = {{'Hit', 'CR'}, {'Miss', 'FA'}};
    criterion_performance = zeros(1,length(performance));
    for p = 1:length(performance)
        hit_count = 0;
        fa_count = 0;
        miss_count = 0;
        cr_count = 0;
        for o = 1:length(performance{p})
            outcome = performance{p}{o};
            outcome_inds = find(strcmp(slrt_data.categorical_outcome, outcome));
            next_inds = outcome_inds + 1;
            next_inds = next_inds(next_inds <= size(slrt_data,1));
            tmp_slrt = slrt_data(next_inds,:);
            hit_count = hit_count + sum(strcmp(tmp_slrt.categorical_outcome, 'Hit'));
            fa_count = fa_count + sum(strcmp(tmp_slrt.categorical_outcome, 'FA'));
            miss_count = miss_count + sum(strcmp(tmp_slrt.categorical_outcome, 'Miss'));
            cr_count = cr_count + sum(strcmp(tmp_slrt.categorical_outcome, 'CR'));
        end
        target_count = hit_count + miss_count;
        distractor_count = fa_count + cr_count;

        hr = (hit_count+0.5)/(target_count+1.0);
        far = (fa_count+0.5)/(distractor_count+1.0);
            
        criterion = -0.5 * (norminv(hr) + norminv(far));
        criterion_performance(p) = criterion;
    end
    action = {{'Hit', 'FA'}, {'Miss', 'CR'}};
    criterion_action = zeros(1,length(performance));
    for p = 1:length(action)
        hit_count = 0;
        fa_count = 0;
        miss_count = 0;
        cr_count = 0;
        for o = 1:length(action{p})
            outcome = action{p}{o};
            outcome_inds = find(strcmp(slrt_data.categorical_outcome, outcome));
            next_inds = outcome_inds + 1;
            next_inds = next_inds(next_inds <= size(slrt_data,1));
            tmp_slrt = slrt_data(next_inds,:);
            hit_count = hit_count + sum(strcmp(tmp_slrt.categorical_outcome, 'Hit'));
            fa_count = fa_count + sum(strcmp(tmp_slrt.categorical_outcome, 'FA'));
            miss_count = miss_count + sum(strcmp(tmp_slrt.categorical_outcome, 'Miss'));
            cr_count = cr_count + sum(strcmp(tmp_slrt.categorical_outcome, 'CR'));
        end
        target_count = hit_count + miss_count;
        distractor_count = fa_count + cr_count;

        hr = (hit_count+0.5)/(target_count+1.0);
        far = (fa_count+0.5)/(distractor_count+1.0);
            
        criterion = -0.5 * (norminv(hr) + norminv(far));
        criterion_action(p) = criterion;
    end
    out = [criterion_outcome, criterion_performance, criterion_action];
end