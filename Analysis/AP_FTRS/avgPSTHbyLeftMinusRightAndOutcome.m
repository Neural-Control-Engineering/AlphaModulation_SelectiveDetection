function out = avgPSTHbyLeftMinusRightAndOutcome(npxls_session, slrt_data, ap_data, edges)
    out = npxls_session;

    % tmp_ap = tmp_ap(~isnan(slrt_data.(event_name)),:);
    % variable_name = strcat(event_name, '_aligned_psth');
    lmr = unique(cell2mat(slrt_data.left_minus_right_amp));
    lmr = lmr(~isnan(lmr));
    variable_name = 'left_trigger_aligned_psth';
    for a = 1:length(lmr)
        amp = lmr(a);
        amp_ap = ap_data(cell2mat(slrt_data.left_minus_right_amp) == amp, :);
        amp_slrt = slrt_data(cell2mat(slrt_data.left_minus_right_amp) == amp, :);
        outcomes = unique(amp_slrt.categorical_outcome);
        for o = 1:length(outcomes)
            outcome = outcomes{o};
            tmp_ap = amp_ap(strcmp(amp_slrt.categorical_outcome, outcome),:);
            if ~isempty(tmp_ap)
                % compute avg PSTH across trials for each PSTH type
                avg_psths = cell(size(npxls_session,1),1);
                for i = 1:size(npxls_session, 1)
                    psth_mat = zeros(size(tmp_ap,1), length(edges)-1);
                    for j = 1:size(tmp_ap,1)
                        if ~isempty(tmp_ap(j,:).spiking_data{1}(i,:).(variable_name){1})
                            psth_mat(j,:) = tmp_ap(j,:).spiking_data{1}(i,:).(variable_name){1};
                        end
                    end
                    avg_psths{i} = mean(psth_mat, 1);
                end
                vn_parts = strsplit(variable_name, 'psth');
                col_title = strcat('amp_', num2str(amp), '_avg_psth_', outcome);
                out = [out, table(avg_psths, 'VariableNames', {col_title})];
            end
        end
    end
end