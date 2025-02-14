function avgCsdByOutcome(lfp_data, slrt_data, chanMap, ftr_path, session_id)
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    params = struct();
    params.pad = 2;
    params.Fs = 500;
    params.tapers = [3, 5];
    movingwin = [0.2, 0.05];
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
    % f0 = 1; f1 = 30;
    % d = designfilt('bandpassiir', ...
    %     'FilterOrder', 10, ...
    %     'HalfPowerFrequency1', f0, ...
    %     'HalfPowerFrequency2', f1, ...
    %     'DesignMethod', 'butter', ...
    %     'SampleRate', Fs);
    if chanMap
        idx = find(chanMap == 1);
    end
    % outs = {{}, {}, {}, {}};
    slrt_data = slrt_data(1:size(slrt_data,1)-1,:);
    for o = 1:length(outcomes)
        tmp_lfp = lfp_data(strcmp(slrt_data.categorical_outcome, outcomes{o}),:);
        for trial = 1:size(tmp_lfp,1)
            time = tmp_lfp(trial,:).left_trigger_aligned_lfp_time{1};
            if isempty(time)
                time = tmp_lfp(trial,:).right_trigger_aligned_lfp_time{1};
            end
            mat = tmp_lfp(trial,:).lfp{1};
            if chanMap
                mat = [mat(idx+1:end,:); mat(1:idx,:)];
            end
            mat = mat(:, (time > -3 & time < 5));
            data = [];
            for r = 1:size(mat,1)
                vec = filtfilt(d,mat(r,:));
                data = [data; vec-mean(vec)];
            end 
            data_trim = [];
            for i = 1:5:385
                data_trim = [data_trim; data(i,:)];
            end
            csd = computeCSD(data_trim, 1);
            if trial == 1
                S = csd(:,1:3999);
            else
                S(:,:,trial) = csd(:,1:3999);
            end
        end
        outs{o} = mean(S,3);
    end
    mkdir(strcat(ftr_path, 'LFP/CSD/'))
    save(strcat(ftr_path, 'LFP/CSD/', session_id, '.mat'), 'outs')
    % keyboard
    % y = 1:size(outs{1},1);
    % time = linspace(-3,5,size(outs{1},2));
    % fig = figure('Position', [1220 1195 935 350]);
    % tl = tiledlayout(1,4);
    % for o = 1:length(outs)
    %     axs(o) = nexttile;
    %     imagesc(time, y, outs{o});
    %     xlim([-0.5 ,1.5])
    %     ylim([50,75])
    %     set(gca, 'YDir', 'normal')
    %     clim([-1e-4,1e-4])
    %     title(outcomes{o})
    % end
    % colorbar()
    % saveas(fig, 'tmp/csd_by_outcome2.png')

    % for o = 1:length(outcomes)
    %     col_title = sprintf('avg_spectrogram_%s',outcomes{o});
    %     out = [out, table(outs{o}', 'VariableNames', {col_title})];
    % end
end