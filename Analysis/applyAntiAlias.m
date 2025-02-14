addpath(genpath('~/n-CORTEx/'))
addpath(genpath('./'))
setenv('UNZIP_DISABLE_ZIPBOMB_DETECTION', 'TRUE')
chan_imec = 1:385;
base_path = '/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/RAW/';
slrt_path = strcat(base_path, 'SLRT/');
ext_table = readtable('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Extraction-Logs/EXT_extraction_log.csv', 'Delimiter', ',');
subjects = {'3387', '3738', '3755'};
for s = 1:length(subjects)
    subject = subjects{s};
    tmp_table = ext_table(contains(ext_table.SessionName, subject),:);
    for sesh = 1:size(tmp_table,1)
        sesh_name = tmp_table(sesh,:).SessionName{1};
        fprintf(sprintf('%s\n',sesh_name))
        trial_mask = tmp_table(sesh,:).TrialMask{1};
        extracted = tmp_table(sesh,:).Extracted;
        if extracted
            binFldr = sprintf('%s/NPXLS/%s/%s_imec0/',base_path, sesh_name, sesh_name);
            imec_zip = sprintf('%sIMEC.zip', binFldr);
            exec_str = sprintf('unzip %s -d %s', imec_zip, binFldr);
            system(exec_str);
            rep = sprintf('t%s.imec0.lf.bin', trial_mask(1));
            file_list = dir(binFldr);
            for i = 1:length(file_list)
                files{i} = file_list(i).name;
            end
            lfpFileName = files(contains(files, rep));
            lfpFileName = lfpFileName{1};
            lfp = ReadSGLXData(lfpFileName, binFldr, chan_imec);
            Fs = lfp.meta.imSampRate;  % Sampling frequency (Hz)
            % Design the notch filter
            d = designfilt('bandpassiir', ...
                        'FilterOrder', 4, ...
                        'HalfPowerFrequency1', 0.1, ...
                        'HalfPowerFrequency2', 100, ...
                        'DesignMethod', 'butter', ...
                        'SampleRate', Fs);
            tmpLfp = filtfilt(d, lfp.dataArray);
            lfp = downsample(tmpLfp', 5)';
            kSortOutPath = sprintf('%s/%s_t%s_sorted/', binFldr, sesh_name, trial_mask(1));
            lfp_file = sprintf('%slfp.mat', kSortOutPath);
            delete(lfp_file);
            save(lfp_file, 'lfp', '-v7.3');
            exec_str = sprintf('rm -f %s*.ap.*', binFldr);
            system(exec_str);
            exec_str = sprintf('rm -f %s*.lf.*', binFldr);
            system(exec_str);
        end
    end
end