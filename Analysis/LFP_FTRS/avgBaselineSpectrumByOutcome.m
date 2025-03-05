function out = avgBaselineSpectrumByOutcome(lfp_session, lfp_data, slrt_data, event_names)
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    actions = {{'Hit', 'FA'}, {'Miss', 'CR'}};
    performance = {{'Hit', 'CR'}, {'Miss', 'FA'}};
    p_labels = {'correct', 'incorrect'};
    a_labels = {'action', 'inaction'};
    out = lfp_session;
    params = struct();
    params.Fs = 500;
    params.tapers = [5,9];
    params.pad = 1;
    Fs = 500;  % Sampling frequency (Hz)
    f0 = 60;    % Frequency to remove (Hz)
    bw = 2;     % Bandwidth around f0 for the notch (Hz)
    % Design the notch filter
    d = designfilt('bandstopiir', ...
                'FilterOrder', 10, ...
                'HalfPowerFrequency1', f0 - bw/2, ...
                'HalfPowerFrequency2', f0 + bw/2, ...
                'DesignMethod', 'butter', ...
                'SampleRate', Fs);
    for i = 1:length(outcomes)
        outcome = outcomes{i};
        tmp_lfp = lfp_data(strcmp(slrt_data.categorical_outcome, outcome), :);
        variable_names = tmp_lfp.Properties.VariableNames;
        for e = 1:length(event_names)
            if ~all(cellfun(@isempty,tmp_lfp.(strcat(event_names{e}, '_aligned_lfp_time'))))
                event_name = strcat(event_names{e}, '_aligned_lfp_time');
                col_title = strcat(event_names{e}, '_baseline_spectra');
                spectra = cell(size(lfp_session,1),1);
                frequency = cell(size(lfp_session,1),1);
                for c = 1:size(lfp_session,1)
                    mat = {};
                    for t = 1:size(tmp_lfp,1)
                        mat{t,1} = tmp_lfp(t,:).lfp{1}(c, tmp_lfp(t,:).(event_name){1} > -3 & tmp_lfp(t,:).(event_name){1} < 0);
                    end
                    fin = min(cellfun(@size, mat, num2cell(repmat(2,length(mat),1))));
                    m = [];
                    for j = 1:length(mat)
                        data = mat{j}(1:fin);
                        data = data - mean(data);
                        data = filtfilt(d, data);
                        [S, f] = mtspectrumc(data, params);
                        m = [m; S'];
                    end
                    if size(m,1) > 1
                        spectra{c} = mean(m);
                    else
                        spectra{c} = m;
                    end
                    frequency{c} = f;
                end
                out = [out, table(spectra, frequency, 'VariableNames', {strcat(col_title, '_', outcome), strcat(col_title, '_', outcome, '_f')})];
            end
        end
    end

    for i = 1:length(performance)
        outcome = performance{i};
        tmp_lfp = lfp_data(strcmp(slrt_data.categorical_outcome, outcome{1}) | strcmp(slrt_data.categorical_outcome, outcome{2}), :);
        variable_names = tmp_lfp.Properties.VariableNames;
        spectra = cell(size(lfp_session,1),1);
        frequency = cell(size(lfp_session,1),1);
        for c = 1:size(lfp_session,1)
            mat = {};
            for t = 1:size(tmp_lfp,1)
                if isempty(tmp_lfp(t,:).left_trigger_aligned_lfp_time{1})
                    event_name = 'right_trigger_aligned_lfp_time';
                else
                    event_name = 'left_trigger_aligned_lfp_time';
                end
                mat{t,1} = tmp_lfp(t,:).lfp{1}(c, tmp_lfp(t,:).(event_name){1} > -3 & tmp_lfp(t,:).(event_name){1} < 0);
            end
            fin = min(cellfun(@size, mat, num2cell(repmat(2,length(mat),1))));
            m = [];
            for j = 1:length(mat)
                data = mat{j}(1:fin);
                data = data - mean(data);
                data = filtfilt(d, data);
                [S, f] = mtspectrumc(data, params);
                m = [m; S'];
            end
            if size(m,1) > 1
                spectra{c} = mean(m);
            else
                spectra{c} = m;
            end
            frequency{c} = f;
        end
        outcome = p_labels{i};
        col_title = 'baseline_spectra';
        out = [out, table(spectra, frequency, 'VariableNames', {strcat(col_title, '_', outcome), strcat(col_title, '_', outcome, '_f')})];
    end

    for i = 1:length(actions)
        outcome = actions{i};
        tmp_lfp = lfp_data(strcmp(slrt_data.categorical_outcome, outcome{1}) | strcmp(slrt_data.categorical_outcome, outcome{2}), :);
        variable_names = tmp_lfp.Properties.VariableNames;
        spectra = cell(size(lfp_session,1),1);
        frequency = cell(size(lfp_session,1),1);
        for c = 1:size(lfp_session,1)
            mat = {};
            for t = 1:size(tmp_lfp,1)
                if isempty(tmp_lfp(t,:).left_trigger_aligned_lfp_time{1})
                    event_name = 'right_trigger_aligned_lfp_time';
                else
                    event_name = 'left_trigger_aligned_lfp_time';
                end
                mat{t,1} = tmp_lfp(t,:).lfp{1}(c, tmp_lfp(t,:).(event_name){1} > -3 & tmp_lfp(t,:).(event_name){1} < 0);
            end
            fin = min(cellfun(@size, mat, num2cell(repmat(2,length(mat),1))));
            m = [];
            for j = 1:length(mat)
                data = mat{j}(1:fin);
                data = data - mean(data);
                data = filtfilt(d, data);
                [S, f] = mtspectrumc(data, params);
                m = [m; S'];
            end
            if size(m,1) > 1
                spectra{c} = mean(m);
            else
                spectra{c} = m;
            end
            frequency{c} = f;
        end
        outcome = a_labels{i};
        col_title = 'baseline_spectra';
        out = [out, table(spectra, frequency, 'VariableNames', {strcat(col_title, '_', outcome), strcat(col_title, '_', outcome, '_f')})];
    end
end