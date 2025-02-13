function out = Criterion(slrt_data)
    if ~sum(strcmp(slrt_data.Properties.VariableNames, 'categorical_outcome'))
        error('First compute categorical outcomes')
    end

    hit_count = sum(strcmp(slrt_data.categorical_outcome, 'Hit'));
    fa_count = sum(strcmp(slrt_data.categorical_outcome, 'FA'));
    miss_count = sum(strcmp(slrt_data.categorical_outcome, 'Miss'));
    cr_count = sum(strcmp(slrt_data.categorical_outcome, 'CR'));

    target_count = hit_count + miss_count;
    distractor_count = fa_count + cr_count;

    hr = (hit_count+0.5)/(target_count+1.0);
    far = (fa_count+0.5)/(distractor_count+1.0);
    
    criterion = -0.5 * (norminv(hr) + norminv(far));
    fprintf(sprintf('Criterion = %.2f\n', criterion))
    criterion = repmat(criterion, size(slrt_data,1), 1);

    out = [slrt_data, table(criterion, 'VariableNames', {'criterion'})];
end