init_paths;

run_analysis = false;
if run_analysis
    s1 = load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Adjusted/Cortex/Spontaneous_Alpha_Modulation/data.mat'));
    pfc = load(strcat(ftr_path, '/AP/FIG/PFC_Expert_Combo_Adjusted/PFC/Spontaneous_Alpha_Modulation/data.mat'));
    striatum = load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Adjusted/Basal_Ganglia/Spontaneous_Alpha_Modulation/data.mat'));
    amygdala = load(strcat(ftr_path, '/AP/FIG/S1_Expert_Combo_Adjusted/Amygdala/Spontaneous_Alpha_Modulation/data.mat'));

    %% s1 sessions
    % combine animals
    ftr_files = {strcat(ftr_path, '/AP/subj--3387-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_adjusted.mat'), ...
        strcat(ftr_path, '/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_adjusted.mat')};
    for i = 1:length(ftr_files)
        f = load(ftr_files{i});
        if i == 1
            ftrs = f.ap_ftr;
        else
            ftrs = combineTables(ftrs, f.ap_ftr);
        end
    end
    S1 = ftrs(startsWith(ftrs.region, 'SS'),:);
    striatum_inds = strcmp(ftrs.region, 'STR') + strcmp(ftrs.region, 'CP');
    Striatum = ftrs(logical(striatum_inds), :);
    amygdala_inds = strcmp(ftrs.region, 'BLAp') + strcmp(ftrs.region, 'LA');
    Amygdala = ftrs(logical(amygdala_inds), :);

    ftr_files = {strcat(ftr_path, '/AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
        strcat(ftr_path, '/AP/subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat')};
    for i = 1:length(ftr_files)
        f = load(ftr_files{i});
        if i == 1
            ftrs = f.ap_ftr;
        else
            ftrs = combineTables(ftrs, f.ap_ftr);
        end
    end
    pfc_inds = startsWith(ftrs.region, 'DP') + startsWith(ftrs.region, 'AC') ...
        + startsWith(ftrs.region, 'PL') + startsWith(ftrs.region, 'IL') ...
        + startsWith(ftrs.region, 'OR');
    pfc_inds = logical(pfc_inds);
    PFC = ftrs(pfc_inds,:);

    %-----------------------------------------------------%
    % quality control
    S1 = S1(cell2mat(S1.avg_trial_fr) > 1, :);
    Striatum = Striatum(cell2mat(Striatum.avg_trial_fr) > 1, :);
    Amygdala = Amygdala(cell2mat(Amygdala.avg_trial_fr) > 1, :);
    PFC = PFC(cell2mat(PFC.avg_trial_fr) > 1, :);
    s1.out.alpha_modulated = s1.out.alpha_modulated(cell2mat(s1.out.alpha_modulated.avg_trial_fr) > 1, :);
    striatum.out.alpha_modulated = striatum.out.alpha_modulated(cell2mat(striatum.out.alpha_modulated.avg_trial_fr) > 1, :);
    amygdala.out.alpha_modulated = amygdala.out.alpha_modulated(cell2mat(amygdala.out.alpha_modulated.avg_trial_fr) > 1, :);
    pfc.out.alpha_modulated = pfc.out.alpha_modulated(cell2mat(pfc.out.alpha_modulated.avg_trial_fr) > 1, :);

    exinds = load('ExcldInds/3738_excld_v2.mat');
    for i = 1:length(exinds.new_excld{1})
        session_id = exinds.new_excld{1}{i};
        cid = exinds.new_excld{2}{i};
        S1(strcmp(S1.session_id, session_id) & S1.cluster_id == cid,:) = [];
        s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.session_id, session_id) & s1.out.alpha_modulated.cluster_id == cid,:) = [];
        Striatum(strcmp(Striatum.session_id, session_id) & Striatum.cluster_id == cid,:) = [];
        striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.session_id, session_id) & striatum.out.alpha_modulated.cluster_id == cid,:) = [];
        Amygdala(strcmp(Amygdala.session_id, session_id) & Amygdala.cluster_id == cid,:) = [];
        amygdala.out.alpha_modulated(strcmp(amygdala.out.alpha_modulated.session_id, session_id) & amygdala.out.alpha_modulated.cluster_id == cid,:) = [];
    end
    exinds = load('ExcldInds/3387_excld.mat');
    for i = 1:length(exinds.excld{1})
        session_id = exinds.excld{1}{i};
        cid = exinds.excld{2}{i};
        S1(strcmp(S1.session_id, session_id) & S1.cluster_id == cid,:) = [];
        s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.session_id, session_id) & s1.out.alpha_modulated.cluster_id == cid,:) = [];
        Striatum(strcmp(Striatum.session_id, session_id) & Striatum.cluster_id == cid,:) = [];
        striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.session_id, session_id) & striatum.out.alpha_modulated.cluster_id == cid,:) = [];
        Amygdala(strcmp(Amygdala.session_id, session_id) & Amygdala.cluster_id == cid,:) = [];
        amygdala.out.alpha_modulated(strcmp(amygdala.out.alpha_modulated.session_id, session_id) & amygdala.out.alpha_modulated.cluster_id == cid,:) = [];
    end

    inds = find(contains(PFC.region, 'AC') & strcmp(PFC.waveform_class, 'RS') & cell2mat(PFC.avg_trial_fr) > 15);
    for i = 1:length(inds)
        PFC(inds(i),:).waveform_class{1} = 'FS';
    end
    inds = find(contains(pfc.out.alpha_modulated.region, 'AC') & strcmp(pfc.out.alpha_modulated.waveform_class, 'RS') & cell2mat(pfc.out.alpha_modulated.avg_trial_fr) > 15);
    for i = 1:length(inds)
        pfc.out.alpha_modulated(inds(i),:).waveform_class{1} = 'FS';
    end

    exinds = load('ExcldInds/1075_excld.mat');
    for i = 1:length(exinds.excld{1})
        session_id = exinds.excld{1}{i};
        cid = exinds.excld{2}{i};
        PFC(strcmp(PFC.session_id, session_id) & PFC.cluster_id == cid,:) = [];
        pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.session_id, session_id) & pfc.out.alpha_modulated.cluster_id == cid,:) = [];
    end
    exinds = load('ExcldInds/3755_excld.mat');
    for i = 1:length(exinds.excld{1})
        session_id = exinds.excld{1}{i};
        cid = exinds.excld{2}{i};
        PFC(strcmp(PFC.session_id, session_id) & PFC.cluster_id == cid,:) = [];
        pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.session_id, session_id) & pfc.out.alpha_modulated.cluster_id == cid,:) = [];
    end

    pfc_rs = pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.waveform_class,'RS'),:);
    pfc_fs = pfc.out.alpha_modulated(strcmp(pfc.out.alpha_modulated.waveform_class,'FS'),:);
    s1_rs = s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.waveform_class,'RS'),:);
    s1_fs = s1.out.alpha_modulated(strcmp(s1.out.alpha_modulated.waveform_class,'FS'),:);
    striatum_rs = striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.waveform_class,'RS'),:);
    striatum_fs = striatum.out.alpha_modulated(strcmp(striatum.out.alpha_modulated.waveform_class,'FS'),:);

    PFC_rs = PFC(strcmp(PFC.waveform_class,'RS'),:);
    PFC_fs = PFC(strcmp(PFC.waveform_class,'FS'),:);
    pfc_rs_ids = pfc_rs.cluster_id;
    for id = 1:length(pfc_rs_ids)
        PFC_rs(PFC_rs.cluster_id == pfc_rs_ids(id),:) = [];
    end
    pfc_fs_ids = pfc_fs.cluster_id;
    for id = 1:length(pfc_fs_ids)
        PFC_fs(PFC_fs.cluster_id == pfc_fs_ids(id),:) = [];
    end
    S1_rs = S1(strcmp(S1.waveform_class,'RS'),:);
    S1_fs = S1(strcmp(S1.waveform_class,'FS'),:);
    s1_rs_ids = s1_rs.cluster_id;
    for id = 1:length(s1_rs_ids)
        S1_rs(S1_rs.cluster_id == s1_rs_ids(id),:) = [];
    end
    s1_fs_ids = s1_fs.cluster_id;
    for id = 1:length(s1_fs_ids)
        S1_fs(S1_fs.cluster_id == s1_fs_ids(id),:) = [];
    end
    Striatum_rs = Striatum(strcmp(Striatum.waveform_class,'RS'),:);
    Striatum_fs = Striatum(strcmp(Striatum.waveform_class,'FS'),:);
    striatum_rs_ids = striatum_rs.cluster_id;
    for id = 1:length(striatum_rs_ids)
        Striatum_rs(Striatum_rs.cluster_id == striatum_rs_ids(id),:) = [];
    end
    striatum_fs_ids = striatum_fs.cluster_id;
    for id = 1:length(striatum_fs_ids)
        Striatum_fs(Striatum_fs.cluster_id == striatum_fs_ids(id),:) = [];
    end

    last_session_id = '';
    s1_rs_all_lick_frs = {};
    s1_rs_all_no_lick_frs = {};
    s1_rs_lick_aligned_avg_frs = {};
    edges = -0.2:0.01:0.2;
    for nrn = 1:size(s1_rs,1)
        cid = s1_rs(nrn,:).cluster_id;
        if nrn == 1
            last_session_id = '';
        else
            last_session_id = session_id;
        end
        session_id = s1_rs(nrn,:).session_id{1};
        if ~strcmp(session_id, last_session_id)
            load(sprintf('%sAP/%s.mat', ext_path, session_id));
            load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
        end 
        c = find(ap_data(1,:).spiking_data{1}.cluster_id == cid);
        contains_lick = spontaneousLicks(slrt_data);
        trial_inds = find(contains_lick);
        psths = {};
        lick_count = 1;
        lick_frs = nan(length(trial_inds),1);
        for li = 1:length(trial_inds)
            t = trial_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            stim_ind = slrt_data(t,:).right_trigger;
            if isnan(stim_ind)
                stim_ind = slrt_data(t,:).left_trigger;
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            lick_inds = find(slrt_data(t,:).lick_detector{1}(stim_ind-3000:stim_ind));
            baseline_time = slrt_data(t,:).clock_time{1}(stim_ind-3000:stim_ind);
            stim_time = slrt_data(t,:).clock_time{1}(stim_ind);
            lick_times = baseline_time(lick_inds) - stim_time;
            if length(lick_times) > 1
                ind = 2;
                while ind <= length(lick_times)
                    if (lick_times(ind) - lick_times(ind-1)) < 0.1
                        lick_times(ind) = [];
                    else
                        ind = ind + 1;
                    end
                end
            end
            for lt = 1:length(lick_times)
                lick_time = lick_times(lt);
                tmp_spks = spks(spks > (lick_time - 0.2) & spks < (lick_time + 0.2)) - lick_time;
                psths{lick_count} = histcounts(tmp_spks, edges);
                lick_count = lick_count + 1;
            end
            lick_frs(li) = length(spks)/3;
        end
        s1_rs_all_lick_frs{nrn} = lick_frs;
        mat = [];
        for i = 1:length(psths)
            mat(i,:) = psths{i};
        end
        s1_rs_lick_aligned_avg_frs{nrn} = nanmean(mat) ./ 0.01;
        no_lick_inds = find(~contains_lick);
        no_lick_frs = nan(length(no_lick_inds),1);
        for li = 1:length(no_lick_inds)
            t = no_lick_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            no_lick_frs(li) = length(spks)/3;
        end
        s1_rs_all_no_lick_frs{nrn} = no_lick_frs;
    end

    last_session_id = '';
    s1_fs_all_lick_frs = {};
    s1_fs_all_no_lick_frs = {};
    s1_fs_lick_aligned_avg_frs = {};
    edges = -0.2:0.01:0.2;
    for nrn = 1:size(s1_fs,1)
        cid = s1_fs(nrn,:).cluster_id;
        if nrn == 1
            last_session_id = '';
        else
            last_session_id = session_id;
        end
        session_id = s1_fs(nrn,:).session_id{1};
        if ~strcmp(session_id, last_session_id)
            load(sprintf('%sAP/%s.mat', ext_path, session_id));
            load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
        end 
        c = find(ap_data(1,:).spiking_data{1}.cluster_id == cid);
        contains_lick = spontaneousLicks(slrt_data);
        trial_inds = find(contains_lick);
        psths = {};
        lick_count = 1;
        lick_frs = nan(length(trial_inds),1);
        for li = 1:length(trial_inds)
            t = trial_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            stim_ind = slrt_data(t,:).right_trigger;
            if isnan(stim_ind)
                stim_ind = slrt_data(t,:).left_trigger;
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            lick_inds = find(slrt_data(t,:).lick_detector{1}(stim_ind-3000:stim_ind));
            baseline_time = slrt_data(t,:).clock_time{1}(stim_ind-3000:stim_ind);
            stim_time = slrt_data(t,:).clock_time{1}(stim_ind);
            lick_times = baseline_time(lick_inds) - stim_time;
            if length(lick_times) > 1
                ind = 2;
                while ind <= length(lick_times)
                    if (lick_times(ind) - lick_times(ind-1)) < 0.1
                        lick_times(ind) = [];
                    else
                        ind = ind + 1;
                    end
                end
            end
            for lt = 1:length(lick_times)
                lick_time = lick_times(lt);
                tmp_spks = spks(spks > (lick_time - 0.2) & spks < (lick_time + 0.2)) - lick_time;
                psths{lick_count} = histcounts(tmp_spks, edges);
                lick_count = lick_count + 1;
            end
            lick_frs(li) = length(spks)/3;
        end
        s1_fs_all_lick_frs{nrn} = lick_frs;
        mat = [];
        for i = 1:length(psths)
            mat(i,:) = psths{i};
        end
        s1_fs_lick_aligned_avg_frs{nrn} = nanmean(mat) ./ 0.01;
        no_lick_inds = find(~contains_lick);
        no_lick_frs = nan(length(no_lick_inds),1);
        for li = 1:length(no_lick_inds)
            t = no_lick_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            no_lick_frs(li) = length(spks)/3;
        end
        s1_fs_all_no_lick_frs{nrn} = no_lick_frs;
    end

    last_session_id = '';
    S1_rs_all_lick_frs = {};
    S1_rs_all_no_lick_frs = {};
    S1_rs_lick_aligned_avg_frs = {};
    edges = -0.2:0.01:0.2;
    for nrn = 1:size(S1_rs,1)
        cid = S1_rs(nrn,:).cluster_id;
        if nrn == 1
            last_session_id = '';
        else
            last_session_id = session_id;
        end
        session_id = S1_rs(nrn,:).session_id{1};
        if ~strcmp(session_id, last_session_id)
            load(sprintf('%sAP/%s.mat', ext_path, session_id));
            load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
        end 
        c = find(ap_data(1,:).spiking_data{1}.cluster_id == cid);
        contains_lick = spontaneousLicks(slrt_data);
        trial_inds = find(contains_lick);
        psths = {};
        lick_count = 1;
        lick_frs = nan(length(trial_inds),1);
        for li = 1:length(trial_inds)
            t = trial_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            stim_ind = slrt_data(t,:).right_trigger;
            if isnan(stim_ind)
                stim_ind = slrt_data(t,:).left_trigger;
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            lick_inds = find(slrt_data(t,:).lick_detector{1}(stim_ind-3000:stim_ind));
            baseline_time = slrt_data(t,:).clock_time{1}(stim_ind-3000:stim_ind);
            stim_time = slrt_data(t,:).clock_time{1}(stim_ind);
            lick_times = baseline_time(lick_inds) - stim_time;
            if length(lick_times) > 1
                ind = 2;
                while ind <= length(lick_times)
                    if (lick_times(ind) - lick_times(ind-1)) < 0.1
                        lick_times(ind) = [];
                    else
                        ind = ind + 1;
                    end
                end
            end
            for lt = 1:length(lick_times)
                lick_time = lick_times(lt);
                tmp_spks = spks(spks > (lick_time - 0.2) & spks < (lick_time + 0.2)) - lick_time;
                psths{lick_count} = histcounts(tmp_spks, edges);
                lick_count = lick_count + 1;
            end
            lick_frs(li) = length(spks)/3;
        end
        S1_rs_all_lick_frs{nrn} = lick_frs;
        mat = [];
        for i = 1:length(psths)
            mat(i,:) = psths{i};
        end
        S1_rs_lick_aligned_avg_frs{nrn} = nanmean(mat) ./ 0.01;
        no_lick_inds = find(~contains_lick);
        no_lick_frs = nan(length(no_lick_inds),1);
        for li = 1:length(no_lick_inds)
            t = no_lick_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            no_lick_frs(li) = length(spks)/3;
        end
        S1_rs_all_no_lick_frs{nrn} = no_lick_frs;
    end

    last_session_id = '';
    S1_fs_all_lick_frs = {};
    S1_fs_all_no_lick_frs = {};
    S1_fs_lick_aligned_avg_frs = {};
    edges = -0.2:0.01:0.2;
    for nrn = 1:size(S1_fs,1)
        cid = S1_fs(nrn,:).cluster_id;
        if nrn == 1
            last_session_id = '';
        else
            last_session_id = session_id;
        end
        session_id = S1_fs(nrn,:).session_id{1};
        if ~strcmp(session_id, last_session_id)
            load(sprintf('%sAP/%s.mat', ext_path, session_id));
            load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
        end 
        c = find(ap_data(1,:).spiking_data{1}.cluster_id == cid);
        contains_lick = spontaneousLicks(slrt_data);
        trial_inds = find(contains_lick);
        psths = {};
        lick_count = 1;
        lick_frs = nan(length(trial_inds),1);
        for li = 1:length(trial_inds)
            t = trial_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            stim_ind = slrt_data(t,:).right_trigger;
            if isnan(stim_ind)
                stim_ind = slrt_data(t,:).left_trigger;
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            lick_inds = find(slrt_data(t,:).lick_detector{1}(stim_ind-3000:stim_ind));
            baseline_time = slrt_data(t,:).clock_time{1}(stim_ind-3000:stim_ind);
            stim_time = slrt_data(t,:).clock_time{1}(stim_ind);
            lick_times = baseline_time(lick_inds) - stim_time;
            if length(lick_times) > 1
                ind = 2;
                while ind <= length(lick_times)
                    if (lick_times(ind) - lick_times(ind-1)) < 0.1
                        lick_times(ind) = [];
                    else
                        ind = ind + 1;
                    end
                end
            end
            for lt = 1:length(lick_times)
                lick_time = lick_times(lt);
                tmp_spks = spks(spks > (lick_time - 0.2) & spks < (lick_time + 0.2)) - lick_time;
                psths{lick_count} = histcounts(tmp_spks, edges);
                lick_count = lick_count + 1;
            end
            lick_frs(li) = length(spks)/3;
        end
        S1_fs_all_lick_frs{nrn} = lick_frs;
        mat = [];
        for i = 1:length(psths)
            mat(i,:) = psths{i};
        end
        S1_fs_lick_aligned_avg_frs{nrn} = nanmean(mat) ./ 0.01;
        no_lick_inds = find(~contains_lick);
        no_lick_frs = nan(length(no_lick_inds),1);
        for li = 1:length(no_lick_inds)
            t = no_lick_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            no_lick_frs(li) = length(spks)/3;
        end
        S1_fs_all_no_lick_frs{nrn} = no_lick_frs;
    end

    last_session_id = '';
    striatum_rs_all_lick_frs = {};
    striatum_rs_all_no_lick_frs = {};
    striatum_rs_lick_aligned_avg_frs = {};
    edges = -0.2:0.01:0.2;
    for nrn = 1:size(striatum_rs,1)
        cid = striatum_rs(nrn,:).cluster_id;
        if nrn == 1
            last_session_id = '';
        else
            last_session_id = session_id;
        end
        session_id = striatum_rs(nrn,:).session_id{1};
        if ~strcmp(session_id, last_session_id)
            load(sprintf('%sAP/%s.mat', ext_path, session_id));
            load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
        end 
        c = find(ap_data(1,:).spiking_data{1}.cluster_id == cid);
        contains_lick = spontaneousLicks(slrt_data);
        trial_inds = find(contains_lick);
        psths = {};
        lick_count = 1;
        lick_frs = nan(length(trial_inds),1);
        for li = 1:length(trial_inds)
            t = trial_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            stim_ind = slrt_data(t,:).right_trigger;
            if isnan(stim_ind)
                stim_ind = slrt_data(t,:).left_trigger;
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            lick_inds = find(slrt_data(t,:).lick_detector{1}(stim_ind-3000:stim_ind));
            baseline_time = slrt_data(t,:).clock_time{1}(stim_ind-3000:stim_ind);
            stim_time = slrt_data(t,:).clock_time{1}(stim_ind);
            lick_times = baseline_time(lick_inds) - stim_time;
            if length(lick_times) > 1
                ind = 2;
                while ind <= length(lick_times)
                    if (lick_times(ind) - lick_times(ind-1)) < 0.1
                        lick_times(ind) = [];
                    else
                        ind = ind + 1;
                    end
                end
            end
            for lt = 1:length(lick_times)
                lick_time = lick_times(lt);
                tmp_spks = spks(spks > (lick_time - 0.2) & spks < (lick_time + 0.2)) - lick_time;
                psths{lick_count} = histcounts(tmp_spks, edges);
                lick_count = lick_count + 1;
            end
            lick_frs(li) = length(spks)/3;
        end
        striatum_rs_all_lick_frs{nrn} = lick_frs;
        mat = [];
        for i = 1:length(psths)
            mat(i,:) = psths{i};
        end
        striatum_rs_lick_aligned_avg_frs{nrn} = nanmean(mat) ./ 0.01;
        no_lick_inds = find(~contains_lick);
        no_lick_frs = nan(length(no_lick_inds),1);
        for li = 1:length(no_lick_inds)
            t = no_lick_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            no_lick_frs(li) = length(spks)/3;
        end
        striatum_rs_all_no_lick_frs{nrn} = no_lick_frs;
    end

    last_session_id = '';
    striatum_fs_all_lick_frs = {};
    striatum_fs_all_no_lick_frs = {};
    striatum_fs_lick_aligned_avg_frs = {};
    edges = -0.2:0.01:0.2;
    for nrn = 1:size(striatum_fs,1)
        cid = striatum_fs(nrn,:).cluster_id;
        if nrn == 1
            last_session_id = '';
        else
            last_session_id = session_id;
        end
        session_id = striatum_fs(nrn,:).session_id{1};
        if ~strcmp(session_id, last_session_id)
            load(sprintf('%sAP/%s.mat', ext_path, session_id));
            load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
        end 
        c = find(ap_data(1,:).spiking_data{1}.cluster_id == cid);
        contains_lick = spontaneousLicks(slrt_data);
        trial_inds = find(contains_lick);
        psths = {};
        lick_count = 1;
        lick_frs = nan(length(trial_inds),1);
        for li = 1:length(trial_inds)
            t = trial_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            stim_ind = slrt_data(t,:).right_trigger;
            if isnan(stim_ind)
                stim_ind = slrt_data(t,:).left_trigger;
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            lick_inds = find(slrt_data(t,:).lick_detector{1}(stim_ind-3000:stim_ind));
            baseline_time = slrt_data(t,:).clock_time{1}(stim_ind-3000:stim_ind);
            stim_time = slrt_data(t,:).clock_time{1}(stim_ind);
            lick_times = baseline_time(lick_inds) - stim_time;
            if length(lick_times) > 1
                ind = 2;
                while ind <= length(lick_times)
                    if (lick_times(ind) - lick_times(ind-1)) < 0.1
                        lick_times(ind) = [];
                    else
                        ind = ind + 1;
                    end
                end
            end
            for lt = 1:length(lick_times)
                lick_time = lick_times(lt);
                tmp_spks = spks(spks > (lick_time - 0.2) & spks < (lick_time + 0.2)) - lick_time;
                psths{lick_count} = histcounts(tmp_spks, edges);
                lick_count = lick_count + 1;
            end
            lick_frs(li) = length(spks)/3;
        end
        striatum_fs_all_lick_frs{nrn} = lick_frs;
        mat = [];
        for i = 1:length(psths)
            mat(i,:) = psths{i};
        end
        striatum_fs_lick_aligned_avg_frs{nrn} = nanmean(mat) ./ 0.01;
        no_lick_inds = find(~contains_lick);
        no_lick_frs = nan(length(no_lick_inds),1);
        for li = 1:length(no_lick_inds)
            t = no_lick_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            no_lick_frs(li) = length(spks)/3;
        end
        striatum_fs_all_no_lick_frs{nrn} = no_lick_frs;
    end

    last_session_id = '';
    Striatum_rs_all_lick_frs = {};
    Striatum_rs_all_no_lick_frs = {};
    Striatum_rs_lick_aligned_avg_frs = {};
    edges = -0.2:0.01:0.2;
    for nrn = 1:size(Striatum_rs,1)
        cid = Striatum_rs(nrn,:).cluster_id;
        if nrn == 1
            last_session_id = '';
        else
            last_session_id = session_id;
        end
        session_id = Striatum_rs(nrn,:).session_id{1};
        if ~strcmp(session_id, last_session_id)
            load(sprintf('%sAP/%s.mat', ext_path, session_id));
            load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
        end 
        c = find(ap_data(1,:).spiking_data{1}.cluster_id == cid);
        contains_lick = spontaneousLicks(slrt_data);
        trial_inds = find(contains_lick);
        psths = {};
        lick_count = 1;
        lick_frs = nan(length(trial_inds),1);
        for li = 1:length(trial_inds)
            t = trial_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            stim_ind = slrt_data(t,:).right_trigger;
            if isnan(stim_ind)
                stim_ind = slrt_data(t,:).left_trigger;
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            lick_inds = find(slrt_data(t,:).lick_detector{1}(stim_ind-3000:stim_ind));
            baseline_time = slrt_data(t,:).clock_time{1}(stim_ind-3000:stim_ind);
            stim_time = slrt_data(t,:).clock_time{1}(stim_ind);
            lick_times = baseline_time(lick_inds) - stim_time;
            if length(lick_times) > 1
                ind = 2;
                while ind <= length(lick_times)
                    if (lick_times(ind) - lick_times(ind-1)) < 0.1
                        lick_times(ind) = [];
                    else
                        ind = ind + 1;
                    end
                end
            end
            for lt = 1:length(lick_times)
                lick_time = lick_times(lt);
                tmp_spks = spks(spks > (lick_time - 0.2) & spks < (lick_time + 0.2)) - lick_time;
                psths{lick_count} = histcounts(tmp_spks, edges);
                lick_count = lick_count + 1;
            end
            lick_frs(li) = length(spks)/3;
        end
        Striatum_rs_all_lick_frs{nrn} = lick_frs;
        mat = [];
        for i = 1:length(psths)
            mat(i,:) = psths{i};
        end
        Striatum_rs_lick_aligned_avg_frs{nrn} = nanmean(mat) ./ 0.01;
        no_lick_inds = find(~contains_lick);
        no_lick_frs = nan(length(no_lick_inds),1);
        for li = 1:length(no_lick_inds)
            t = no_lick_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            no_lick_frs(li) = length(spks)/3;
        end
        Striatum_rs_all_no_lick_frs{nrn} = no_lick_frs;
    end

    last_session_id = '';
    Striatum_fs_all_lick_frs = {};
    Striatum_fs_all_no_lick_frs = {};
    Striatum_fs_lick_aligned_avg_frs = {};
    edges = -0.2:0.01:0.2;
    for nrn = 1:size(Striatum_fs,1)
        cid = Striatum_fs(nrn,:).cluster_id;
        if nrn == 1
            last_session_id = '';
        else
            last_session_id = session_id;
        end
        session_id = Striatum_fs(nrn,:).session_id{1};
        if ~strcmp(session_id, last_session_id)
            load(sprintf('%sAP/%s.mat', ext_path, session_id));
            load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
        end 
        c = find(ap_data(1,:).spiking_data{1}.cluster_id == cid);
        contains_lick = spontaneousLicks(slrt_data);
        trial_inds = find(contains_lick);
        psths = {};
        lick_count = 1;
        lick_frs = nan(length(trial_inds),1);
        for li = 1:length(trial_inds)
            t = trial_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            stim_ind = slrt_data(t,:).right_trigger;
            if isnan(stim_ind)
                stim_ind = slrt_data(t,:).left_trigger;
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            lick_inds = find(slrt_data(t,:).lick_detector{1}(stim_ind-3000:stim_ind));
            baseline_time = slrt_data(t,:).clock_time{1}(stim_ind-3000:stim_ind);
            stim_time = slrt_data(t,:).clock_time{1}(stim_ind);
            lick_times = baseline_time(lick_inds) - stim_time;
            if length(lick_times) > 1
                ind = 2;
                while ind <= length(lick_times)
                    if (lick_times(ind) - lick_times(ind-1)) < 0.1
                        lick_times(ind) = [];
                    else
                        ind = ind + 1;
                    end
                end
            end
            for lt = 1:length(lick_times)
                lick_time = lick_times(lt);
                tmp_spks = spks(spks > (lick_time - 0.2) & spks < (lick_time + 0.2)) - lick_time;
                psths{lick_count} = histcounts(tmp_spks, edges);
                lick_count = lick_count + 1;
            end
            lick_frs(li) = length(spks)/3;
        end
        Striatum_fs_all_lick_frs{nrn} = lick_frs;
        mat = [];
        for i = 1:length(psths)
            mat(i,:) = psths{i};
        end
        Striatum_fs_lick_aligned_avg_frs{nrn} = nanmean(mat) ./ 0.01;
        no_lick_inds = find(~contains_lick);
        no_lick_frs = nan(length(no_lick_inds),1);
        for li = 1:length(no_lick_inds)
            t = no_lick_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            no_lick_frs(li) = length(spks)/3;
        end
        Striatum_fs_all_no_lick_frs{nrn} = no_lick_frs;
    end

    last_session_id = '';
    pfc_rs_all_lick_frs = {};
    pfc_rs_all_no_lick_frs = {};
    pfc_rs_lick_aligned_avg_frs = {};
    edges = -0.2:0.01:0.2;
    for nrn = 1:size(pfc_rs,1)
        cid = pfc_rs(nrn,:).cluster_id;
        if nrn == 1
            last_session_id = '';
        else
            last_session_id = session_id;
        end
        session_id = pfc_rs(nrn,:).session_id{1};
        if ~strcmp(session_id, last_session_id)
            load(sprintf('%sAP/%s.mat', ext_path, session_id));
            load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
        end 
        c = find(ap_data(1,:).spiking_data{1}.cluster_id == cid);
        contains_lick = spontaneousLicks(slrt_data);
        trial_inds = find(contains_lick);
        psths = {};
        lick_count = 1;
        lick_frs = nan(length(trial_inds),1);
        for li = 1:length(trial_inds)
            t = trial_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            stim_ind = slrt_data(t,:).right_trigger;
            if isnan(stim_ind)
                stim_ind = slrt_data(t,:).left_trigger;
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            lick_inds = find(slrt_data(t,:).lick_detector{1}(stim_ind-3000:stim_ind));
            baseline_time = slrt_data(t,:).clock_time{1}(stim_ind-3000:stim_ind);
            stim_time = slrt_data(t,:).clock_time{1}(stim_ind);
            lick_times = baseline_time(lick_inds) - stim_time;
            if length(lick_times) > 1
                ind = 2;
                while ind <= length(lick_times)
                    if (lick_times(ind) - lick_times(ind-1)) < 0.1
                        lick_times(ind) = [];
                    else
                        ind = ind + 1;
                    end
                end
            end
            for lt = 1:length(lick_times)
                lick_time = lick_times(lt);
                tmp_spks = spks(spks > (lick_time - 0.2) & spks < (lick_time + 0.2)) - lick_time;
                psths{lick_count} = histcounts(tmp_spks, edges);
                lick_count = lick_count + 1;
            end
            lick_frs(li) = length(spks)/3;
        end
        pfc_rs_all_lick_frs{nrn} = lick_frs;
        mat = [];
        for i = 1:length(psths)
            mat(i,:) = psths{i};
        end
        pfc_rs_lick_aligned_avg_frs{nrn} = nanmean(mat) ./ 0.01;
        no_lick_inds = find(~contains_lick);
        no_lick_frs = nan(length(no_lick_inds),1);
        for li = 1:length(no_lick_inds)
            t = no_lick_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            no_lick_frs(li) = length(spks)/3;
        end
        pfc_rs_all_no_lick_frs{nrn} = no_lick_frs;
    end

    last_session_id = '';
    pfc_fs_all_lick_frs = {};
    pfc_fs_all_no_lick_frs = {};
    pfc_fs_lick_aligned_avg_frs = {};
    edges = -0.2:0.01:0.2;
    for nrn = 1:size(pfc_fs,1)
        cid = pfc_fs(nrn,:).cluster_id;
        if nrn == 1
            last_session_id = '';
        else
            last_session_id = session_id;
        end
        session_id = pfc_fs(nrn,:).session_id{1};
        if ~strcmp(session_id, last_session_id)
            load(sprintf('%sAP/%s.mat', ext_path, session_id));
            load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
        end 
        c = find(ap_data(1,:).spiking_data{1}.cluster_id == cid);
        contains_lick = spontaneousLicks(slrt_data);
        trial_inds = find(contains_lick);
        psths = {};
        lick_count = 1;
        lick_frs = nan(length(trial_inds),1);
        for li = 1:length(trial_inds)
            t = trial_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            stim_ind = slrt_data(t,:).right_trigger;
            if isnan(stim_ind)
                stim_ind = slrt_data(t,:).left_trigger;
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            lick_inds = find(slrt_data(t,:).lick_detector{1}(stim_ind-3000:stim_ind));
            baseline_time = slrt_data(t,:).clock_time{1}(stim_ind-3000:stim_ind);
            stim_time = slrt_data(t,:).clock_time{1}(stim_ind);
            lick_times = baseline_time(lick_inds) - stim_time;
            if length(lick_times) > 1
                ind = 2;
                while ind <= length(lick_times)
                    if (lick_times(ind) - lick_times(ind-1)) < 0.1
                        lick_times(ind) = [];
                    else
                        ind = ind + 1;
                    end
                end
            end
            for lt = 1:length(lick_times)
                lick_time = lick_times(lt);
                tmp_spks = spks(spks > (lick_time - 0.2) & spks < (lick_time + 0.2)) - lick_time;
                psths{lick_count} = histcounts(tmp_spks, edges);
                lick_count = lick_count + 1;
            end
            lick_frs(li) = length(spks)/3;
        end
        pfc_fs_all_lick_frs{nrn} = lick_frs;
        mat = [];
        for i = 1:length(psths)
            mat(i,:) = psths{i};
        end
        pfc_fs_lick_aligned_avg_frs{nrn} = nanmean(mat) ./ 0.01;
        no_lick_inds = find(~contains_lick);
        no_lick_frs = nan(length(no_lick_inds),1);
        for li = 1:length(no_lick_inds)
            t = no_lick_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            no_lick_frs(li) = length(spks)/3;
        end
        pfc_fs_all_no_lick_frs{nrn} = no_lick_frs;
    end

    last_session_id = '';
    PFC_rs_all_lick_frs = {};
    PFC_rs_all_no_lick_frs = {};
    PFC_rs_lick_aligned_avg_frs = {};
    edges = -0.2:0.01:0.2;
    for nrn = 1:size(PFC_rs,1)
        cid = PFC_rs(nrn,:).cluster_id;
        if nrn == 1
            last_session_id = '';
        else
            last_session_id = session_id;
        end
        session_id = PFC_rs(nrn,:).session_id{1};
        if ~strcmp(session_id, last_session_id)
            load(sprintf('%sAP/%s.mat', ext_path, session_id));
            load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
        end 
        c = find(ap_data(1,:).spiking_data{1}.cluster_id == cid);
        contains_lick = spontaneousLicks(slrt_data);
        trial_inds = find(contains_lick);
        psths = {};
        lick_count = 1;
        lick_frs = nan(length(trial_inds),1);
        for li = 1:length(trial_inds)
            t = trial_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            stim_ind = slrt_data(t,:).right_trigger;
            if isnan(stim_ind)
                stim_ind = slrt_data(t,:).left_trigger;
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            lick_inds = find(slrt_data(t,:).lick_detector{1}(stim_ind-3000:stim_ind));
            baseline_time = slrt_data(t,:).clock_time{1}(stim_ind-3000:stim_ind);
            stim_time = slrt_data(t,:).clock_time{1}(stim_ind);
            lick_times = baseline_time(lick_inds) - stim_time;
            if length(lick_times) > 1
                ind = 2;
                while ind <= length(lick_times)
                    if (lick_times(ind) - lick_times(ind-1)) < 0.1
                        lick_times(ind) = [];
                    else
                        ind = ind + 1;
                    end
                end
            end
            for lt = 1:length(lick_times)
                lick_time = lick_times(lt);
                tmp_spks = spks(spks > (lick_time - 0.2) & spks < (lick_time + 0.2)) - lick_time;
                psths{lick_count} = histcounts(tmp_spks, edges);
                lick_count = lick_count + 1;
            end
            lick_frs(li) = length(spks)/3;
        end
        PFC_rs_all_lick_frs{nrn} = lick_frs;
        mat = [];
        for i = 1:length(psths)
            mat(i,:) = psths{i};
        end
        PFC_rs_lick_aligned_avg_frs{nrn} = nanmean(mat) ./ 0.01;
        no_lick_inds = find(~contains_lick);
        no_lick_frs = nan(length(no_lick_inds),1);
        for li = 1:length(no_lick_inds)
            t = no_lick_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            no_lick_frs(li) = length(spks)/3;
        end
        PFC_rs_all_no_lick_frs{nrn} = no_lick_frs;
    end

    last_session_id = '';
    PFC_fs_all_lick_frs = {};
    PFC_fs_all_no_lick_frs = {};
    PFC_fs_lick_aligned_avg_frs = {};
    edges = -0.2:0.01:0.2;
    for nrn = 1:size(PFC_fs,1)
        cid = PFC_fs(nrn,:).cluster_id;
        if nrn == 1
            last_session_id = '';
        else
            last_session_id = session_id;
        end
        session_id = PFC_fs(nrn,:).session_id{1};
        if ~strcmp(session_id, last_session_id)
            load(sprintf('%sAP/%s.mat', ext_path, session_id));
            load(sprintf('%sSLRT/%s.mat', ext_path, session_id));
        end 
        c = find(ap_data(1,:).spiking_data{1}.cluster_id == cid);
        contains_lick = spontaneousLicks(slrt_data);
        trial_inds = find(contains_lick);
        psths = {};
        lick_count = 1;
        lick_frs = nan(length(trial_inds),1);
        for li = 1:length(trial_inds)
            t = trial_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            stim_ind = slrt_data(t,:).right_trigger;
            if isnan(stim_ind)
                stim_ind = slrt_data(t,:).left_trigger;
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            lick_inds = find(slrt_data(t,:).lick_detector{1}(stim_ind-3000:stim_ind));
            baseline_time = slrt_data(t,:).clock_time{1}(stim_ind-3000:stim_ind);
            stim_time = slrt_data(t,:).clock_time{1}(stim_ind);
            lick_times = baseline_time(lick_inds) - stim_time;
            if length(lick_times) > 1
                ind = 2;
                while ind <= length(lick_times)
                    if (lick_times(ind) - lick_times(ind-1)) < 0.1
                        lick_times(ind) = [];
                    else
                        ind = ind + 1;
                    end
                end
            end
            for lt = 1:length(lick_times)
                lick_time = lick_times(lt);
                tmp_spks = spks(spks > (lick_time - 0.2) & spks < (lick_time + 0.2)) - lick_time;
                psths{lick_count} = histcounts(tmp_spks, edges);
                lick_count = lick_count + 1;
            end
            lick_frs(li) = length(spks)/3;
        end
        PFC_fs_all_lick_frs{nrn} = lick_frs;
        mat = [];
        for i = 1:length(psths)
            mat(i,:) = psths{i};
        end
        PFC_fs_lick_aligned_avg_frs{nrn} = nanmean(mat) ./ 0.01;
        no_lick_inds = find(~contains_lick);
        no_lick_frs = nan(length(no_lick_inds),1);
        for li = 1:length(no_lick_inds)
            t = no_lick_inds(li);
            variable_name = 'left_trigger_aligned_spike_times';
            if isempty(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1})
                variable_name = 'right_trigger_aligned_spike_times';
            end
            spks = ap_data(t,:).spiking_data{1}(c,:).(variable_name){1}(ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} > -3 & ...
                ap_data(t,:).spiking_data{1}(c,:).(variable_name){1} < 0);
            no_lick_frs(li) = length(spks)/3;
        end
        PFC_fs_all_no_lick_frs{nrn} = no_lick_frs;
    end

    out = struct();
    out.s1_rs_all_no_lick_frs = s1_rs_all_no_lick_frs;
    out.s1_rs_all_lick_frs = s1_rs_all_lick_frs;
    out.s1_rs_lick_aligned_avg_frs = s1_rs_lick_aligned_avg_frs;
    out.s1_fs_all_no_lick_frs = s1_fs_all_no_lick_frs;
    out.s1_fs_all_lick_frs = s1_fs_all_lick_frs;
    out.s1_fs_lick_aligned_avg_frs = s1_fs_lick_aligned_avg_frs;
    out.S1_rs_all_no_lick_frs = S1_rs_all_no_lick_frs;
    out.S1_rs_all_lick_frs = S1_rs_all_lick_frs;
    out.S1_rs_lick_aligned_avg_frs = S1_rs_lick_aligned_avg_frs;
    out.S1_fs_all_no_lick_frs = S1_fs_all_no_lick_frs;
    out.S1_fs_all_lick_frs = S1_fs_all_lick_frs;
    out.S1_fs_lick_aligned_avg_frs = S1_fs_lick_aligned_avg_frs;
    out.striatum_rs_all_no_lick_frs = striatum_rs_all_no_lick_frs;
    out.striatum_rs_all_lick_frs = striatum_rs_all_lick_frs;
    out.striatum_rs_lick_aligned_avg_frs = striatum_rs_lick_aligned_avg_frs;
    out.striatum_fs_all_no_lick_frs = striatum_fs_all_no_lick_frs;
    out.striatum_fs_all_lick_frs = striatum_fs_all_lick_frs;
    out.striatum_fs_lick_aligned_avg_frs = striatum_fs_lick_aligned_avg_frs;
    out.Striatum_rs_all_no_lick_frs = Striatum_rs_all_no_lick_frs;
    out.Striatum_rs_all_lick_frs = Striatum_rs_all_lick_frs;
    out.Striatum_rs_lick_aligned_avg_frs = Striatum_rs_lick_aligned_avg_frs;
    out.Striatum_fs_all_no_lick_frs = Striatum_fs_all_no_lick_frs;
    out.Striatum_fs_all_lick_frs = Striatum_fs_all_lick_frs;
    out.Striatum_fs_lick_aligned_avg_frs = Striatum_fs_lick_aligned_avg_frs;
    out.pfc_rs_all_no_lick_frs = pfc_rs_all_no_lick_frs;
    out.pfc_rs_all_lick_frs = pfc_rs_all_lick_frs;
    out.pfc_rs_lick_aligned_avg_frs = pfc_rs_lick_aligned_avg_frs;
    out.pfc_fs_all_no_lick_frs = pfc_fs_all_no_lick_frs;
    out.pfc_fs_all_lick_frs = pfc_fs_all_lick_frs;
    out.pfc_fs_lick_aligned_avg_frs = pfc_fs_lick_aligned_avg_frs;
    out.PFC_rs_all_no_lick_frs = PFC_rs_all_no_lick_frs;
    out.PFC_rs_all_lick_frs = PFC_rs_all_lick_frs;
    out.PFC_rs_lick_aligned_avg_frs = PFC_rs_lick_aligned_avg_frs;
    out.PFC_fs_all_no_lick_frs = PFC_fs_all_no_lick_frs;
    out.PFC_fs_all_lick_frs = PFC_fs_all_lick_frs;
    out.PFC_fs_lick_aligned_avg_frs = PFC_fs_lick_aligned_avg_frs;
    save('phase_mod_licking_frs.mat', 'out')
end

load phase_mod_licking_frs.mat
fig = figure('Position', [1220 1122 1432 596]);
tl = tiledlayout(1,2);
axs(1) = nexttile;
hold on 
for i = 1:length(out.s1_rs_all_lick_frs)
    x = (rand()-0.5) * 0.3;
    plot(2+x, nanmean(out.s1_rs_all_lick_frs{i}), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot(1+x, nanmean(out.s1_rs_all_no_lick_frs{i}), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot([2,1]+x, [nanmean(out.s1_rs_all_lick_frs{i}), nanmean(out.s1_rs_all_no_lick_frs{i})], '--', 'Color', [0.5, 0.5, 0.5])
end
for i = 1:length(out.s1_fs_all_lick_frs)
    x = (rand()-0.5) * 0.3;
    plot(5+x, nanmean(out.s1_fs_all_lick_frs{i}), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot(4+x, nanmean(out.s1_fs_all_no_lick_frs{i}), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot([5,4]+x, [nanmean(out.s1_fs_all_lick_frs{i}), nanmean(out.s1_fs_all_no_lick_frs{i})], '--', 'Color', [0.5, 0.5, 0.5])
end
for i = 1:length(out.pfc_rs_all_lick_frs)
    x = (rand()-0.5) * 0.3;
    plot(8+x, nanmean(out.pfc_rs_all_lick_frs{i}), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot(7+x, nanmean(out.pfc_rs_all_no_lick_frs{i}), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot([8,7]+x, [nanmean(out.pfc_rs_all_lick_frs{i}), nanmean(out.pfc_rs_all_no_lick_frs{i})], '--', 'Color', [0.5, 0.5, 0.5])
end
for i = 1:length(out.pfc_fs_all_lick_frs)
    x = (rand()-0.5) * 0.3;
    plot(11+x, nanmean(out.pfc_fs_all_lick_frs{i}), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot(10+x, nanmean(out.pfc_fs_all_no_lick_frs{i}), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot([11,10]+x, [nanmean(out.pfc_fs_all_lick_frs{i}), nanmean(out.pfc_fs_all_no_lick_frs{i})], '--', 'Color', [0.5, 0.5, 0.5])
end
for i = 1:length(out.striatum_rs_all_lick_frs)
    x = (rand()-0.5) * 0.3;
    plot(14+x, nanmean(out.striatum_rs_all_lick_frs{i}), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot(13+x, nanmean(out.striatum_rs_all_no_lick_frs{i}), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot([14,13]+x, [nanmean(out.striatum_rs_all_lick_frs{i}), nanmean(out.striatum_rs_all_no_lick_frs{i})], '--', 'Color', [0.5, 0.5, 0.5])
end
for i = 1:length(out.striatum_fs_all_lick_frs)
    x = (rand()-0.5) * 0.3;
    plot(17+x, nanmean(out.striatum_fs_all_lick_frs{i}), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot(16+x, nanmean(out.striatum_fs_all_no_lick_frs{i}), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot([17,16]+x, [nanmean(out.striatum_fs_all_lick_frs{i}), nanmean(out.striatum_fs_all_no_lick_frs{i})], '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar([2,5,8,11,14,17], ...
    [nanmean(cellfun(@nanmean, out.s1_rs_all_lick_frs)), nanmean(cellfun(@nanmean, out.s1_fs_all_lick_frs)), ...
    nanmean(cellfun(@nanmean, out.pfc_rs_all_lick_frs)), nanmean(cellfun(@nanmean, out.pfc_fs_all_lick_frs)), ...
    nanmean(cellfun(@nanmean, out.striatum_rs_all_lick_frs)), nanmean(cellfun(@nanmean, out.striatum_fs_all_lick_frs))], ...
    [ste(cellfun(@nanmean, out.s1_rs_all_lick_frs)), ste(cellfun(@nanmean, out.s1_fs_all_lick_frs)), ...
    ste(cellfun(@nanmean, out.pfc_rs_all_lick_frs)), ste(cellfun(@nanmean, out.pfc_fs_all_lick_frs)), ...
    ste(cellfun(@nanmean, out.striatum_rs_all_lick_frs)), ste(cellfun(@nanmean, out.striatum_fs_all_lick_frs))], ...
    'k.', 'CapSize', 15, 'LineWidth', 2)
errorbar([1,4,7,10,13,16], ...
    [nanmean(cellfun(@nanmean, out.s1_rs_all_no_lick_frs)), nanmean(cellfun(@nanmean, out.s1_fs_all_no_lick_frs)), ...
    nanmean(cellfun(@nanmean, out.pfc_rs_all_no_lick_frs)), nanmean(cellfun(@nanmean, out.pfc_fs_all_no_lick_frs)), ...
    nanmean(cellfun(@nanmean, out.striatum_rs_all_no_lick_frs)), nanmean(cellfun(@nanmean, out.striatum_fs_all_no_lick_frs))], ...
    [ste(cellfun(@nanmean, out.s1_rs_all_no_lick_frs)), ste(cellfun(@nanmean, out.s1_fs_all_no_lick_frs)), ...
    ste(cellfun(@nanmean, out.pfc_rs_all_no_lick_frs)), ste(cellfun(@nanmean, out.pfc_fs_all_no_lick_frs)), ...
    ste(cellfun(@nanmean, out.striatum_rs_all_no_lick_frs)), ste(cellfun(@nanmean, out.striatum_fs_all_no_lick_frs))], ...
    'k.', 'CapSize', 15, 'LineWidth', 2)
% ylabel('Firing Rate (Hz)')
xticks([1.5, 4.5, 7.5, 10.5, 13.5, 16.5])
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS'})
xtickangle(45)
lims = ylim;
yticks([0, lims(2)])
title('Alpha Modulated', 'FontWeight', 'normal', 'FontSize', 16)
ax = gca;
ax.YAxis.FontSize = 14;
ax.XAxis.FontSize = 14;

axs(2) = nexttile;
hold on 
for i = 1:length(out.S1_rs_all_lick_frs)
    x = (rand()-0.5) * 0.3;
    plot(2+x, nanmean(out.S1_rs_all_lick_frs{i}), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot(1+x, nanmean(out.S1_rs_all_no_lick_frs{i}), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot([2,1]+x, [nanmean(out.S1_rs_all_lick_frs{i}), nanmean(out.S1_rs_all_no_lick_frs{i})], '--', 'Color', [0.5, 0.5, 0.5])
end
for i = 1:length(out.S1_fs_all_lick_frs)
    x = (rand()-0.5) * 0.3;
    plot(5+x, nanmean(out.S1_fs_all_lick_frs{i}), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot(4+x, nanmean(out.S1_fs_all_no_lick_frs{i}), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot([5,4]+x, [nanmean(out.S1_fs_all_lick_frs{i}), nanmean(out.S1_fs_all_no_lick_frs{i})], '--', 'Color', [0.5, 0.5, 0.5])
end
for i = 1:length(out.PFC_rs_all_lick_frs)
    x = (rand()-0.5) * 0.3;
    plot(8+x, nanmean(out.PFC_rs_all_lick_frs{i}), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot(7+x, nanmean(out.PFC_rs_all_no_lick_frs{i}), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot([8,7]+x, [nanmean(out.PFC_rs_all_lick_frs{i}), nanmean(out.PFC_rs_all_no_lick_frs{i})], '--', 'Color', [0.5, 0.5, 0.5])
end
for i = 1:length(out.PFC_fs_all_lick_frs)
    x = (rand()-0.5) * 0.3;
    plot(11+x, nanmean(out.PFC_fs_all_lick_frs{i}), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot(10+x, nanmean(out.PFC_fs_all_no_lick_frs{i}), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot([11,10]+x, [nanmean(out.PFC_fs_all_lick_frs{i}), nanmean(out.PFC_fs_all_no_lick_frs{i})], '--', 'Color', [0.5, 0.5, 0.5])
end
for i = 1:length(out.Striatum_rs_all_lick_frs)
    x = (rand()-0.5) * 0.3;
    plot(14+x, nanmean(out.Striatum_rs_all_lick_frs{i}), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot(13+x, nanmean(out.Striatum_rs_all_no_lick_frs{i}), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot([14,13]+x, [nanmean(out.Striatum_rs_all_lick_frs{i}), nanmean(out.Striatum_rs_all_no_lick_frs{i})], '--', 'Color', [0.5, 0.5, 0.5])
end
for i = 1:length(out.Striatum_fs_all_lick_frs)
    x = (rand()-0.5) * 0.3;
    plot(17+x, nanmean(out.Striatum_fs_all_lick_frs{i}), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot(16+x, nanmean(out.Striatum_fs_all_no_lick_frs{i}), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', [1,1,1], 'MarkerSize', 10)
    plot([17,16]+x, [nanmean(out.Striatum_fs_all_lick_frs{i}), nanmean(out.Striatum_fs_all_no_lick_frs{i})], '--', 'Color', [0.5, 0.5, 0.5])
end
errorbar([2,5,8,11,14,17], ...
    [nanmean(cellfun(@nanmean, out.S1_rs_all_lick_frs)), nanmean(cellfun(@nanmean, out.S1_fs_all_lick_frs)), ...
    nanmean(cellfun(@nanmean, out.PFC_rs_all_lick_frs)), nanmean(cellfun(@nanmean, out.PFC_fs_all_lick_frs)), ...
    nanmean(cellfun(@nanmean, out.Striatum_rs_all_lick_frs)), nanmean(cellfun(@nanmean, out.Striatum_fs_all_lick_frs))], ...
    [ste(cellfun(@nanmean, out.S1_rs_all_lick_frs)), ste(cellfun(@nanmean, out.S1_fs_all_lick_frs)), ...
    ste(cellfun(@nanmean, out.PFC_rs_all_lick_frs)), ste(cellfun(@nanmean, out.PFC_fs_all_lick_frs)), ...
    ste(cellfun(@nanmean, out.Striatum_rs_all_lick_frs)), ste(cellfun(@nanmean, out.Striatum_fs_all_lick_frs))], ...
    'k.', 'CapSize', 15, 'LineWidth', 2)
errorbar([1,4,7,10,13,16], ...
    [nanmean(cellfun(@nanmean, out.S1_rs_all_no_lick_frs)), nanmean(cellfun(@nanmean, out.S1_fs_all_no_lick_frs)), ...
    nanmean(cellfun(@nanmean, out.PFC_rs_all_no_lick_frs)), nanmean(cellfun(@nanmean, out.PFC_fs_all_no_lick_frs)), ...
    nanmean(cellfun(@nanmean, out.Striatum_rs_all_no_lick_frs)), nanmean(cellfun(@nanmean, out.Striatum_fs_all_no_lick_frs))], ...
    [ste(cellfun(@nanmean, out.S1_rs_all_no_lick_frs)), ste(cellfun(@nanmean, out.S1_fs_all_no_lick_frs)), ...
    ste(cellfun(@nanmean, out.PFC_rs_all_no_lick_frs)), ste(cellfun(@nanmean, out.PFC_fs_all_no_lick_frs)), ...
    ste(cellfun(@nanmean, out.Striatum_rs_all_no_lick_frs)), ste(cellfun(@nanmean, out.Striatum_fs_all_no_lick_frs))], ...
    'k.', 'CapSize', 15, 'LineWidth', 2)
xticks([1.5, 4.5, 7.5, 10.5, 13.5, 16.5])
xticklabels({'S1 RS', 'S1 FS', 'PFC RS', 'PFC FS', 'Striatum RS', 'Striatum FS'})
xtickangle(45)
ylim([0, lims(2)])
yticks([0, lims(2)])
title('Unmodulated', 'FontWeight', 'normal', 'FontSize', 16)
ax = gca;
ax.YAxis.FontSize = 14;
ax.XAxis.FontSize = 14;
ylabel(tl, 'Firing Rate (Hz)', 'FontSize', 16)
saveas(fig, '../Figures/mod_unmod_fr_licks.svg')
saveas(fig, '../Figures/mod_unmod_fr_licks.fig')

if KStest(cellfun(@nanmean, out.S1_rs_all_lick_frs)) || KStest(cellfun(@nanmean, out.S1_rs_all_no_lick_frs))
    p = signrank(cellfun(@nanmean, out.S1_rs_all_lick_frs), cellfun(@nanmean, out.S1_rs_all_no_lick_frs));
    fprintf(sprintf('S1 RS unmod lick vs no lick (signed-rank): p = = %d\n', p))
else
    [~,p] = ttest(cellfun(@nanmean, out.S1_rs_all_lick_frs), cellfun(@nanmean, out.S1_rs_all_no_lick_frs));
    fprintf(sprintf('S1 RS unmod lick vs no lick (paried t-test): p = = %d\n', p))
end
if KStest(cellfun(@nanmean, out.S1_fs_all_lick_frs)) || KStest(cellfun(@nanmean, out.S1_fs_all_no_lick_frs))
    p = signrank(cellfun(@nanmean, out.S1_fs_all_lick_frs), cellfun(@nanmean, out.S1_fs_all_no_lick_frs));
    fprintf(sprintf('S1 FS unmod lick vs no lick (signed-rank): p = = %d\n', p))
else
    [~,p] = ttest(cellfun(@nanmean, out.S1_fs_all_lick_frs), cellfun(@nanmean, out.S1_fs_all_no_lick_frs));
    fprintf(sprintf('S1 FS unmod lick vs no lick (paried t-test): p = = %d\n', p))
end
if KStest(cellfun(@nanmean, out.PFC_rs_all_lick_frs)) || KStest(cellfun(@nanmean, out.PFC_rs_all_no_lick_frs))
    p = signrank(cellfun(@nanmean, out.PFC_rs_all_lick_frs), cellfun(@nanmean, out.PFC_rs_all_no_lick_frs));
    fprintf(sprintf('PFC RS unmod lick vs no lick (signed-rank): p = = %d\n', p))
else
    [~,p] = ttest(cellfun(@nanmean, out.PFC_rs_all_lick_frs), cellfun(@nanmean, out.PFC_rs_all_no_lick_frs));
    fprintf(sprintf('PFC RS unmod lick vs no lick (paried t-test): p = = %d\n', p))
end
if KStest(cellfun(@nanmean, out.PFC_fs_all_lick_frs)) || KStest(cellfun(@nanmean, out.PFC_fs_all_no_lick_frs))
    p = signrank(cellfun(@nanmean, out.PFC_fs_all_lick_frs), cellfun(@nanmean, out.PFC_fs_all_no_lick_frs));
    fprintf(sprintf('PFC FS unmod lick vs no lick (signed-rank): p = = %d\n', p))
else
    [~,p] = ttest(cellfun(@nanmean, out.PFC_fs_all_lick_frs), cellfun(@nanmean, out.PFC_fs_all_no_lick_frs));
    fprintf(sprintf('PFC FS unmod lick vs no lick (paried t-test): p = = %d\n', p))
end
if KStest(cellfun(@nanmean, out.Striatum_rs_all_lick_frs)) || KStest(cellfun(@nanmean, out.Striatum_rs_all_no_lick_frs))
    p = signrank(cellfun(@nanmean, out.Striatum_rs_all_lick_frs), cellfun(@nanmean, out.Striatum_rs_all_no_lick_frs));
    fprintf(sprintf('Striatum RS unmod lick vs no lick (signed-rank): p = = %d\n', p))
else
    [~,p] = ttest(cellfun(@nanmean, out.Striatum_rs_all_lick_frs), cellfun(@nanmean, out.Striatum_rs_all_no_lick_frs));
    fprintf(sprintf('Striatum RS unmod lick vs no lick (paried t-test): p = = %d\n', p))
end
if KStest(cellfun(@nanmean, out.Striatum_fs_all_lick_frs)) || KStest(cellfun(@nanmean, out.Striatum_fs_all_no_lick_frs))
    p = signrank(cellfun(@nanmean, out.Striatum_fs_all_lick_frs), cellfun(@nanmean, out.Striatum_fs_all_no_lick_frs));
    fprintf(sprintf('Striatum FS unmod lick vs no lick (signed-rank): p = = %d\n', p))
else
    [~,p] = ttest(cellfun(@nanmean, out.Striatum_fs_all_lick_frs), cellfun(@nanmean, out.Striatum_fs_all_no_lick_frs));
    fprintf(sprintf('Striatum FS unmod lick vs no lick (paried t-test): p = = %d\n', p))
end

if KStest(cellfun(@nanmean, out.s1_rs_all_lick_frs)) || KStest(cellfun(@nanmean, out.s1_rs_all_no_lick_frs))
    p = signrank(cellfun(@nanmean, out.s1_rs_all_lick_frs), cellfun(@nanmean, out.s1_rs_all_no_lick_frs));
    fprintf(sprintf('S1 RS mod lick vs no lick (signed-rank): p = = %d\n', p))
else
    [~,p] = ttest(cellfun(@nanmean, out.s1_rs_all_lick_frs), cellfun(@nanmean, out.s1_rs_all_no_lick_frs));
    fprintf(sprintf('S1 RS mod lick vs no lick (paried t-test): p = = %d\n', p))
end
if KStest(cellfun(@nanmean, out.s1_fs_all_lick_frs)) || KStest(cellfun(@nanmean, out.s1_fs_all_no_lick_frs))
    p = signrank(cellfun(@nanmean, out.s1_fs_all_lick_frs), cellfun(@nanmean, out.s1_fs_all_no_lick_frs));
    fprintf(sprintf('S1 FS mod lick vs no lick (signed-rank): p = = %d\n', p))
else
    [~,p] = ttest(cellfun(@nanmean, out.s1_fs_all_lick_frs), cellfun(@nanmean, out.s1_fs_all_no_lick_frs));
    fprintf(sprintf('S1 FS mod lick vs no lick (paried t-test): p = = %d\n', p))
end
if KStest(cellfun(@nanmean, out.pfc_rs_all_lick_frs)) || KStest(cellfun(@nanmean, out.pfc_rs_all_no_lick_frs))
    p = signrank(cellfun(@nanmean, out.pfc_rs_all_lick_frs), cellfun(@nanmean, out.pfc_rs_all_no_lick_frs));
    fprintf(sprintf('PFC RS mod lick vs no lick (signed-rank): p = = %d\n', p))
else
    [~,p] = ttest(cellfun(@nanmean, out.pfc_rs_all_lick_frs), cellfun(@nanmean, out.pfc_rs_all_no_lick_frs));
    fprintf(sprintf('PFC RS mod lick vs no lick (paried t-test): p = = %d\n', p))
end
if KStest(cellfun(@nanmean, out.pfc_fs_all_lick_frs)) || KStest(cellfun(@nanmean, out.pfc_fs_all_no_lick_frs))
    p = signrank(cellfun(@nanmean, out.pfc_fs_all_lick_frs), cellfun(@nanmean, out.pfc_fs_all_no_lick_frs));
    fprintf(sprintf('PFC FS mod lick vs no lick (signed-rank): p = = %d\n', p))
else
    [~,p] = ttest(cellfun(@nanmean, out.pfc_fs_all_lick_frs), cellfun(@nanmean, out.pfc_fs_all_no_lick_frs));
    fprintf(sprintf('PFC FS mod lick vs no lick (paried t-test): p = = %d\n', p))
end
if KStest(cellfun(@nanmean, out.striatum_rs_all_lick_frs)) || KStest(cellfun(@nanmean, out.striatum_rs_all_no_lick_frs))
    p = signrank(cellfun(@nanmean, out.striatum_rs_all_lick_frs), cellfun(@nanmean, out.striatum_rs_all_no_lick_frs));
    fprintf(sprintf('Striatum RS mod lick vs no lick (signed-rank): p = = %d\n', p))
else
    [~,p] = ttest(cellfun(@nanmean, out.striatum_rs_all_lick_frs), cellfun(@nanmean, out.striatum_rs_all_no_lick_frs));
    fprintf(sprintf('Striatum RS mod lick vs no lick (paried t-test): p = = %d\n', p))
end
if KStest(cellfun(@nanmean, out.striatum_fs_all_lick_frs)) || KStest(cellfun(@nanmean, out.striatum_fs_all_no_lick_frs))
    p = signrank(cellfun(@nanmean, out.striatum_fs_all_lick_frs), cellfun(@nanmean, out.striatum_fs_all_no_lick_frs));
    fprintf(sprintf('Striatum FS mod lick vs no lick (signed-rank): p = = %d\n', p))
else
    [~,p] = ttest(cellfun(@nanmean, out.striatum_fs_all_lick_frs), cellfun(@nanmean, out.striatum_fs_all_no_lick_frs));
    fprintf(sprintf('Striatum FS mod lick vs no lick (paried t-test): p = = %d\n', p))
end

lick_aligned_fig = figure('Position', [ 1151 721 925 1081]);
tl = tiledlayout(3,2);
time = linspace(-0.2,0.2,40);
axs(1) = nexttile;
hold on 
mat = [];
for i = 1:length(out.s1_rs_lick_aligned_avg_frs)
    mat(i,:) = out.s1_rs_lick_aligned_avg_frs{i};
end
semshade(mat, 0.3, 'b', 'b', time);
title('Regular Spiking', 'FontSize', 16, 'FontWeight', 'normal')
mat = [];
for i = 1:length(out.S1_rs_lick_aligned_avg_frs)
    mat(i,:) = out.S1_rs_lick_aligned_avg_frs{i};
end
semshade(mat, 0.3, 'r', 'r', time);
ylabel('S1', 'FontSize', 16)
axs(2) = nexttile;
hold on 
mat = [];
for i = 1:length(out.s1_fs_lick_aligned_avg_frs)
    mat(i,:) = out.s1_fs_lick_aligned_avg_frs{i};
end
semshade(mat, 0.3, 'b', 'b', time);
mat = [];
for i = 1:length(out.S1_fs_lick_aligned_avg_frs)
    mat(i,:) = out.S1_fs_lick_aligned_avg_frs{i};
end
semshade(mat, 0.3, 'r', 'r', time);
title('Fast Spiking', 'FontSize', 16, 'FontWeight', 'normal')

axs(3) = nexttile;
hold on 
mat = [];
for i = 1:length(out.pfc_rs_lick_aligned_avg_frs)
    mat(i,:) = out.pfc_rs_lick_aligned_avg_frs{i};
end
semshade(mat, 0.3, 'b', 'b', time);
mat = [];
for i = 1:length(out.PFC_rs_lick_aligned_avg_frs)
    mat(i,:) = out.PFC_rs_lick_aligned_avg_frs{i};
end
semshade(mat, 0.3, 'r', 'r', time);
ylabel('PFC', 'FontSize', 16)
axs(4) = nexttile;
hold on 
mat = [];
for i = 1:length(out.pfc_fs_lick_aligned_avg_frs)
    mat(i,:) = out.pfc_fs_lick_aligned_avg_frs{i};
end
semshade(mat, 0.3, 'b', 'b', time);
mat = [];
for i = 1:length(out.PFC_fs_lick_aligned_avg_frs)
    mat(i,:) = out.PFC_fs_lick_aligned_avg_frs{i};
end
semshade(mat, 0.3, 'r', 'r', time);

axs(5) = nexttile;
hold on 
mat = [];
for i = 1:length(out.striatum_rs_lick_aligned_avg_frs)
    mat(i,:) = out.striatum_rs_lick_aligned_avg_frs{i};
end
semshade(mat, 0.3, 'b', 'b', time);
mat = [];
for i = 1:length(out.Striatum_rs_lick_aligned_avg_frs)
    mat(i,:) = out.Striatum_rs_lick_aligned_avg_frs{i};
end
semshade(mat, 0.3, 'r', 'r', time);
ylabel('Striatum', 'FontSize', 16)
axs(6) = nexttile;
hold on 
mat = [];
for i = 1:length(out.striatum_fs_lick_aligned_avg_frs)
    mat(i,:) = out.striatum_fs_lick_aligned_avg_frs{i};
end
semshade(mat, 0.3, 'b', 'b', time);
mat = [];
for i = 1:length(out.Striatum_fs_lick_aligned_avg_frs)
    mat(i,:) = out.Striatum_fs_lick_aligned_avg_frs{i};
end
semshade(mat, 0.3, 'r', 'r', time);
xlabel(tl, 'Time (s)', 'FontSize', 16)
ylabel(tl, 'Firing Rate (Hz)', 'FontSize', 16)
saveas(lick_aligned_fig, '../Figures/lick_aligned.svg')
saveas(lick_aligned_fig, '../Figures/lick_aligned.fig')