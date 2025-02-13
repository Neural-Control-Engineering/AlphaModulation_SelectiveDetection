function out = auROC(npxls_session, ap_data, slrt_data, event_names, bin_size)
    aucs = cell(size(npxls_session,1),1);
    for c = 1:size(npxls_session,1)
        tmp_slrt = slrt_data(strcmp(slrt_data.categorical_outcome, 'Hit') | strcmp(slrt_data.categorical_outcome, 'Miss'),:);
        for e = 1:length(event_names)
            if ~all(isnan(tmp_slrt.(event_names{e})))
                event_name = strcat(event_names{e}, '_aligned_evokedFR');
            end
        end
        tmp_ap = ap_data(strcmp(slrt_data.categorical_outcome, 'Hit') | strcmp(slrt_data.categorical_outcome, 'Miss'),:);
        target_responses = zeros(size(tmp_ap,1),1);
        
        for t = 1:size(tmp_ap,1)
            target_responses(t) = tmp_ap(t,:).spiking_data{1}(c,:).(event_name){1} * bin_size;
        end

        tmp_slrt = slrt_data(strcmp(slrt_data.categorical_outcome, 'FA') | strcmp(slrt_data.categorical_outcome, 'CR'),:);
        for e = 1:length(event_names)
            if ~all(isnan(tmp_slrt.(event_names{e})))
                event_name = strcat(event_names{e}, '_aligned_evokedFR');
            end
        end
        tmp_ap = ap_data(strcmp(slrt_data.categorical_outcome, 'FA') | strcmp(slrt_data.categorical_outcome, 'CR'),:);
        distractor_responses = zeros(size(tmp_ap,1),1);
        
        for t = 1:size(tmp_ap,1)
            distractor_responses(t) = tmp_ap(t,:).spiking_data{1}(c,:).(event_name){1} * bin_size;
        end

        % 9 = max([max(target_responses), max(distractor_responses)]);
        hr = zeros(1,length(0:9));
        fa = zeros(1,length(0:9));
        for i = 0:9
            hr(i+1) = sum(target_responses >= i) / length(target_responses);
            fa(i+1) = sum(distractor_responses >= i) / length(distractor_responses);
        end
        hr = [hr, 0];
        fa = [fa, 0];
        hr = fliplr(hr);
        fa = fliplr(fa);
        auc = trapz(fa, hr);
        aucs{c} = abs(auc - 0.5);
    end     
    out = [npxls_session, table(aucs, 'VariableNames', {'auROC'})];
end