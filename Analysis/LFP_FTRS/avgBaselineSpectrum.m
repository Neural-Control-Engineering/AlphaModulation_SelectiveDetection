function out = avgBaselineSpectrum(lfp_session, lfp_data, event_names)
    fs = round(1 / (lfp_data(1,:).lfpTime{1}(2) - lfp_data(1,:).lfpTime{1}(1)));
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
    for e = 1:length(event_names)
        event_name = strcat(event_names{e}, '_aligned_lfp_time');
        spectra = cell(size(lfp_session,1),1);
        frequency = cell(size(lfp_session,1),1);
        for c = 1:size(lfp_session,1)
            tmp_lfp = lfp_data(~cellfun(@isempty, lfp_data.(event_name)),:);
            mat = {};
            for t = 1:size(tmp_lfp,1)
                mat{t,1} = tmp_lfp(t,:).lfp{1}(c, tmp_lfp(t,:).(event_name){1} > -3 & tmp_lfp(t,:).(event_name){1} < 0);
            end
            fin = min(cellfun(@size, mat, num2cell(repmat(2,length(mat),1))));
            m = [];
            for i = 1:length(mat)
                data = mat{i}(1:fin);
                data = data - mean(data);
                data = filtfilt(d, data);
                [S, f] = mtspectrumc(data, params);
                m = [m; S'];
            end
            spectra{c} = mean(m);
            frequency{c} = f;
        end
        col_title = strcat(event_names{e}, '_aligned_baselineSpectra');
        time_title = strcat(col_title, '_baseline_f');
        out = [out, table(spectra, frequency, 'VariableNames', {col_title, time_title})];
    end
end