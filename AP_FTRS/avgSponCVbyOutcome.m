function out = avgSponCVbyOutcome(ap_session, slrt_data, ap_data, outcome)
    ap_data = ap_data(strcmp(slrt_data.categorical_outcome, outcome),:);
    if ~isempty(ap_data)
        if ~any(contains(ap_data(1,:).spiking_data{1}.Properties.VariableNames, 'spontaneousCV'))
            ap_data = spontaneousCV(ap_data, {'right_trigger_aligned_spike_times', 'left_trigger_aligned_spike_times'});
        end
        cvs = cell(size(ap_session,1),1);
        for c = 1:size(ap_session,1)
            cell_cvs = nan(size(ap_data,1),1);
            for t = 1:size(ap_data,1)
                spiking_data = ap_data(t,:).spiking_data{1};
                variable_names = spiking_data.Properties.VariableNames;
                variable_name = variable_names{contains(variable_names, 'spontaneousCV')};
                cell_cvs(t) = spiking_data(c,:).(variable_name){1};
            end
            cvs{c} = mean(cell_cvs, 'omitnan');
        end
        out = [ap_session, table(cvs, 'VariableNames', {strcat('spontaneousCV_', outcome)})];
    else
        out = ap_session;
    end

end