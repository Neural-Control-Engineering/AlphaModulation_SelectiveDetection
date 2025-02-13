function xsession = alphaPhaseShiftAcrossProbe(session_ids, chanMap, ref)
    xsession = [];
    for s = 1:length(session_ids)
        session_id = session_ids{s};
        load(sprintf('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/AP/%s.mat', session_id));
        load(sprintf('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/LFP/%s.mat', session_id));
        load(sprintf('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/SLRT/%s.mat', session_id));
        channels = 1:4:385;
        alpha_powers = [];
        all_phases = [];
        all_times = [];
        if chanMap
            idx = find(chanMap == 1);
        end
        for t = 1:size(slrt_data,1)
            cluster_channel = ref;
            lfp = lfp_data(t,:).lfp{1}(cluster_channel,:);
            lfp_times = lfp_data(t,:).left_trigger_aligned_lfp_time{1};
            lfp_time = lfp_data(t,:).lfpTime{1};
            alpha = bandpassFilter(lfp, 8, 12, 500);
            phi = angle(hilbert(alpha));
            ALPHA = abs(hilbert(alpha)).^2;
            alpha_powers = [alpha_powers, ALPHA(lfp_times > -3 & lfp_times < 0)];
            all_times = [all_times, lfp_time(lfp_times > -3 & lfp_times < 0)];
        end
        dist_mat = [];
        for t = 1:size(slrt_data,1)
            lfp = lfp_data(t,:).lfp{1}(ref,:);
            alpha = bandpassFilter(lfp, 8, 12, 500);
            lfp_times = lfp_data(t,:).left_trigger_aligned_lfp_time{1};
            ALPHA = abs(hilbert(alpha)).^2;
            ALPHA = ALPHA(lfp_times > -3 & lfp_times < 0);
            ref_alpha = alpha(lfp_times > -3 & lfp_times < 0);
            ref_phi = angle(hilbert(ref_alpha));
            lfp_times = lfp_times(lfp_times > -3 & lfp_times < 0);
            high_inds = findEvents(ALPHA, lfp_times, prctile(alpha_powers, 75), 0.33, 0.2, 'above');
            if size(high_inds,1)
                for n = 1:size(high_inds,1)
                    ref_phase = ref_phi(high_inds(n,1):high_inds(n,2));
                    avg_dists = zeros(1, length(channels));
                    mat = lfp_data(t,:).lfp{1};
                    if chanMap
                        mat = [mat(idx+1:end,:); mat(1:idx,:)];
                    end
                    for c = 1:length(channels)
                        cluster_channel = channels(c);
                        lfp = mat(cluster_channel,:);
                        alpha = bandpassFilter(lfp, 8, 12, 500);
                        lfp_times = lfp_data(t,:).left_trigger_aligned_lfp_time{1};
                        alpha = alpha(lfp_times > -3 & lfp_times < 0);
                        alpha_phase = angle(hilbert(alpha));
                        alpha_phase = alpha_phase(high_inds(n,1):high_inds(n,2));
                        avg_dists(c) = circ_mean(circ_dist(ref_phase, alpha_phase));
                    end 
                    dist_mat = [dist_mat; avg_dists];
                end
            end
        end
        xsession = [xsession; mean(dist_mat)];
    end
end
