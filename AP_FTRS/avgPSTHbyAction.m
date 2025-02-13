function out = avgPSTHbyAction(ap_session, slrt_data, ap_data, events, edges)
    avg_psths = cell(size(ap_session,1),1);
    % action
    tmp_ap = ap_data(strcmp(slrt_data.categorical_outcome, 'Hit') | strcmp(slrt_data.categorical_outcome, 'CR'),:);
    if ~isempty(tmp_ap)
        for c = 1:size(ap_session, 1)
            psth_mat = zeros(size(tmp_ap,1), length(edges)-1);
            for j = 1:size(tmp_ap,1)
                for e = 1:length(events)
                    variable_name = strcat(events{e}, '_aligned_psth');
                    if any(strcmp(tmp_ap(j,:).spiking_data{1}(c,:).Properties.VariableNames, variable_name))
                        psth_mat(j,:) = tmp_ap(j,:).spiking_data{1}(c,:).(variable_name){1};
                    end
                end
            end
            avg_psths{c} = mean(psth_mat);
        end
        out = [ap_session, table(avg_psths, 'VariableNames', {'stim_aligned_psth_action'})];
    else
        out = ap_session;
    end

    avg_psths = cell(size(ap_session,1),1);
    % withheld
    tmp_ap = ap_data(strcmp(slrt_data.categorical_outcome, 'Miss') | strcmp(slrt_data.categorical_outcome, 'FA'),:);
    if ~isempty(tmp_ap)
        for c = 1:size(ap_session, 1)
            psth_mat = zeros(size(tmp_ap,1), length(edges)-1);
            for j = 1:size(tmp_ap,1)
                for e = 1:length(events)
                    variable_name = strcat(events{e}, '_aligned_psth');
                    if any(strcmp(tmp_ap(j,:).spiking_data{1}(c,:).Properties.VariableNames, variable_name))
                        psth_mat(j,:) = tmp_ap(j,:).spiking_data{1}(c,:).(variable_name){1};
                    end
                end
            end
            avg_psths{c} = mean(psth_mat);
        end
        out = [out, table(avg_psths, 'VariableNames', {'stim_aligned_psth_withheld'})];
    end

end