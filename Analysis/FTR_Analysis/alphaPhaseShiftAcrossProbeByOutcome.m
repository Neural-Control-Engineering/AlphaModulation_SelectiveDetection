function [xsession_Hit, xsession_Miss, xsession_FA, xsession_CR] = alphaPhaseShiftAcrossProbeByOutcome(session_ids, chanMap, ref)
    xsession_Hit = [];
    xsession_Miss = [];
    xsession_FA = [];
    xsession_CR = [];
    xsession_Correct = [];
    xsession_Incorrect = [];
    xsession_Action = [];
    xsession_Inaction = [];
    outcomes = {'Hit', 'Miss', 'CR', 'FA', 'Correct', 'Incorrect', 'Action', 'Inaction'};
    for s = 1:length(session_ids)
        session_id = session_ids{s};
        load(sprintf('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/AP/%s.mat', session_id));
        load(sprintf('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/LFP/%s.mat', session_id));
        load(sprintf('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/SLRT/%s.mat', session_id));
        channels = 1:4:385;
        alpha_powers = [];
        all_times = [];
        if chanMap
            idx = find(chanMap == 1);
        end

        for o = 1:4
            if o <= 4
                tmp_slrt = slrt_data(strcmp(slrt_data.categorical_outcome, outcomes{o}),:);
                tmp_lfp = lfp_data(strcmp(slrt_data.categorical_outcome, outcomes{o}),:);
                tmp_ap = ap_data(strcmp(slrt_data.categorical_outcome, outcomes{o}),:);
            end

            dist_mat = [];
            for t = 1:size(tmp_slrt,1)
                lfp = tmp_lfp(t,:).lfp{1}(ref,:);
                alpha = bandpassFilter(lfp, 8, 12, 500);
                lfp_times = tmp_lfp(t,:).left_trigger_aligned_lfp_time{1};
                ALPHA = abs(hilbert(alpha)).^2;
                ALPHA = ALPHA(lfp_times > -3 & lfp_times < 0);
                ref_alpha = alpha(lfp_times > -3 & lfp_times < 0);
                ref_phi = angle(hilbert(ref_alpha));
                lfp_times = lfp_times(lfp_times > -3 & lfp_times < 0);
                high_inds = findEvents(ALPHA, lfp_times, prctile(alpha_powers, 75), 0.33, 0.2, 'above');
                ref_phase = ref_phi;
                avg_dists = zeros(1, length(channels));
                mat = tmp_lfp(t,:).lfp{1};
                if chanMap
                    mat = [mat(idx+1:end,:); mat(1:idx,:)];
                end
                for c = 1:length(channels)
                    cluster_channel = channels(c);
                    lfp = mat(cluster_channel,:);
                    alpha = bandpassFilter(lfp, 8, 12, 500);
                    lfp_times = tmp_lfp(t,:).left_trigger_aligned_lfp_time{1};
                    alpha = alpha(lfp_times > -3 & lfp_times < 0);
                    alpha_phase = angle(hilbert(alpha));
                    avg_dists(c) = circ_mean(circ_dist(ref_phase, alpha_phase));
                end 
                dist_mat = [dist_mat; avg_dists];
            end
            expr = sprintf('xsession_%s = [xsession_%s; mean(dist_mat)];', outcomes{o}, outcomes{o});
            eval(expr);
        end
    end
end
