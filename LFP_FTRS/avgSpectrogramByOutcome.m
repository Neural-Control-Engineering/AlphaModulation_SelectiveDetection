function out = avgSpectrogramByOutcome(lfp_session, lfp_data, slrt_data)
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    params = struct();
    params.pad = 2;
    params.Fs = 500;
    params.tapers = [3, 5];
    movingwin = [0.2, 0.05];
    Fs = 500;  % Sampling frequency (Hz)
    f0 = 60;    % Frequency to remove (Hz)
    bw = 2;     % Bandwidth around f0 for the notch (Hz)
    out = lfp_session;
    % Design the notch filter
    d = designfilt('bandstopiir', ...
                'FilterOrder', 10, ...
                'HalfPowerFrequency1', f0 - bw/2, ...
                'HalfPowerFrequency2', f0 + bw/2, ...
                'DesignMethod', 'butter', ...
                'SampleRate', Fs);
    outs = {{}, {}, {}, {}};
    slrt_data = slrt_data(1:size(slrt_data,1)-1,:);
    for c = 1:size(lfp_session,1)
        for o = 1:length(outcomes)
            tmp_lfp = lfp_data(strcmp(slrt_data.categorical_outcome, outcomes{o}),:);
            for trial = 1:size(tmp_lfp,1)
                time = tmp_lfp(trial,:).left_trigger_aligned_lfp_time{1};
                if isempty(time)
                    time = tmp_lfp(trial,:).right_trigger_aligned_lfp_time{1};
                end
                data = tmp_lfp(trial,:).lfp{1}(c,:);
                data = filtfilt(d, data);
                data = data(time > -3 & time < 5);
                data = data - mean(data);
                [s,t,f] = mtspecgramc(data(1:3999), movingwin, params);
                if trial == 1
                    S = s';
                else
                    S(:,:,trial) = s';
                end
            end
            outs{o}{c} = mean(S,3);
        end
    end
    for o = 1:length(outcomes)
        col_title = sprintf('avg_spectrogram_%s',outcomes{o});
        out = [out, table(outs{o}', 'VariableNames', {col_title})];
    end
end