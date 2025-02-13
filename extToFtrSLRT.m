function extToFtrSLRT(ext_path, session_ids, ftr_file)
    slrt_ftr = [];
    for i = 1:length(session_ids)
        % load ap and slrt data for each session 
        session_id = session_ids{i};
        sesh_id_parts = strsplit(session_id, '_');
        subj_id = session_id(length(sesh_id_parts{1})+2:end);
        slrt_ext = load(strcat(ext_path, 'SLRT/', session_id, '.mat'));
        dprime = slrt_ext.slrt_data(1,:).dprime;
        criterion = slrt_ext.slrt_data(1,:).criterion;
        if ~any(strcmp(slrt_ext.slrt_data.Properties.VariableNames, 'reaction_time'))
            slrt_ext.slrt_data = reactionTime(slrt_ext.slrt_data);
        end
        avg_rt = nanmean(cell2mat(slrt_ext.slrt_data.reaction_time));
        avg_rt_by_outcome = reactionTimeByOutcome(slrt_ext.slrt_data);
        avg_rt_by_prev_outcome = reactionTimeGivenPreviousOutcome(slrt_ext.slrt_data);
        dprimes_by_prev_outcome = dprimeGivenPreviousOutcome(slrt_ext.slrt_data);
        criteria_by_prev_outcome = criterionGivenPreviousOutcome(slrt_ext.slrt_data);
        hr = getHR(slrt_ext.slrt_data.categorical_outcome);
        far = getFAR(slrt_ext.slrt_data.categorical_outcome);
         % if any(strcmp(slrt_ext.slrt_data.Properties.VariableNames, 'left_minus_right_amp'))
        if contains(session_id, 'phase5')
            if ~any(strcmp(slrt_ext.slrt_data.Properties.VariableNames, 'left_minus_right_amp'))
                slrt_ext.slrt_data = leftMinusRight(slrt_ext.slrt_data);
            end
            [amps, response_prob] = singleSessionPsychCurve(slrt_ext.slrt_data, false, false);
            [~, rt_avg] = singleSessionReactionTimes(slrt_ext.slrt_data, false, false);
        end

        [tmp_slrt, last_good_ind] = lickQC(slrt_ext.slrt_data);
        last_good_trial = last_good_ind;
        tmp_slrt = removevars(tmp_slrt, {'dprime', 'criterion'});
        tmp_slrt = dPrime(tmp_slrt);
        tmp_slrt = Criterion(tmp_slrt);
        qc_dprime = tmp_slrt(1,:).dprime;
        qc_criterion = tmp_slrt(1,:).criterion;
        if ~any(strcmp(tmp_slrt.Properties.VariableNames, 'reaction_time'))
            tmp_slrt = reactionTime(tmp_slrt);
        end
        qc_avg_rt = nanmean(cell2mat(tmp_slrt.reaction_time));
        qc_avg_rt_by_outcome = reactionTimeByOutcome(tmp_slrt);
        qc_avg_rt_by_prev_outcome = reactionTimeGivenPreviousOutcome(tmp_slrt);
        qc_dprimes_by_prev_outcome = dprimeGivenPreviousOutcome(tmp_slrt);
        qc_criteria_by_prev_outcome = criterionGivenPreviousOutcome(tmp_slrt);
        qc_hr = getHR(tmp_slrt.categorical_outcome);
        qc_far = getFAR(tmp_slrt.categorical_outcome);
        
        % if any(strcmp(slrt_ext.slrt_data.Properties.VariableNames, 'left_minus_right_amp'))
        if contains(session_id, 'phase5')
            slrt_ftr = [slrt_ftr; table({session_id}, {subj_id}, dprime, criterion, avg_rt, {avg_rt_by_outcome}, ...
                {dprimes_by_prev_outcome}, {criteria_by_prev_outcome}, {avg_rt_by_prev_outcome}, ...
                qc_dprime, qc_criterion, qc_avg_rt, {qc_avg_rt_by_outcome}, ...
                {qc_dprimes_by_prev_outcome}, {qc_criteria_by_prev_outcome}, {qc_avg_rt_by_prev_outcome}, ...
                last_good_trial, {amps}, {response_prob}, {rt_avg}, hr, far, qc_hr, qc_far, ...
                'VariableNames', ...
                {'session_id', 'subject_id','dprime', 'criterion', 'avg_reaction_time', 'rt_by_outcome',...
                'dprime_by_previous_outcome', 'criterion_by_previous_outcome', 'rt_by_previous_outcome', ...
                'qc_dprime', 'qc_criterion', 'qc_avg_reaction_time', 'qc_rt_by_outcome',...
                'qc_dprime_by_previous_outcome', 'qc_criterion_by_previous_outcome', 'qc_rt_by_previous_outcome', ...
                'last_good_trial', 'left_minus_right_amp', 'response_probability', 'rt_by_diff', 'hr', 'far', 'qc_hr', 'qc_far'})];
        else
            slrt_ftr = [slrt_ftr; table({session_id}, {subj_id}, dprime, criterion, avg_rt, {avg_rt_by_outcome}, ...
                {dprimes_by_prev_outcome}, {criteria_by_prev_outcome}, {avg_rt_by_prev_outcome}, ...
                qc_dprime, qc_criterion, qc_avg_rt, {qc_avg_rt_by_outcome}, ...
                {qc_dprimes_by_prev_outcome}, {qc_criteria_by_prev_outcome}, {qc_avg_rt_by_prev_outcome}, ...
                last_good_trial, hr, far, qc_hr, qc_far, ...
                'VariableNames', ...
                {'session_id', 'subject_id','dprime', 'criterion', 'avg_reaction_time', 'rt_by_outcome',...
                'dprime_by_previous_outcome', 'criterion_by_previous_outcome', 'rt_by_previous_outcome', ...
                'qc_dprime', 'qc_criterion', 'qc_avg_reaction_time', 'qc_rt_by_outcome',...
                'qc_dprime_by_previous_outcome', 'qc_criterion_by_previous_outcome', 'qc_rt_by_previous_outcome', ...
                'last_good_trial', 'hr', 'far', 'qc_hr', 'qc_far'})];
        end
    end
    save(ftr_file, 'slrt_ftr')
end

function out = getHR(outcomes)
    hit_count = sum(strcmp(outcomes, 'Hit'));
    go_count = hit_count + sum(strcmp(outcomes, 'Miss'));
    out = hit_count / go_count;
end

function out = getFAR(outcomes)
    fa_count = sum(strcmp(outcomes, 'FA'));
    nogo_count = fa_count + sum(strcmp(outcomes, 'CR'));
    out = fa_count / nogo_count;
end
