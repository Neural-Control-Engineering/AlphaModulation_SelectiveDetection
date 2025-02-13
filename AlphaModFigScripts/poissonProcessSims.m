addpath(genpath('~/circstat-matlab/'))

load_results = true;

if ~load_results
    if isempty(gcp('nocreate'))
        parpool; % Start a parallel pool if none exists
    end
    sessionIDs;
    session_ids = horzcat(expert_3387_session_ids, expert_3738_session_ids, expert_1075_session_ids, expert_3755_session_ids);
    n_trials = zeros(1,length(session_ids));
    parfor i = 1:length(session_ids)
        session_id = session_ids{i};
        slrt_ext = load(sprintf('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/SLRT/%s.mat', session_id));
        n_trials(i) = size(slrt_ext.slrt_data,1);
    end

    duration = 100 %3*round(mean(n_trials));
    % duration = 20;
    Fs = 1000;
    L = duration * Fs;
    T = 1/Fs;
    t = (0:L-1)*T;
    Nruns = 10;
    lfp_fs = 8:0.1:12;
    firing_rates = 1:0.5:20;
    mis = zeros(length(lfp_fs),length(firing_rates), Nruns);
    mse = zeros(length(lfp_fs),length(firing_rates), Nruns);
    ps = zeros(length(lfp_fs),length(firing_rates), Nruns);

    % Preallocate the 'mis' array for efficiency
    mis = zeros(length(lfp_fs), length(firing_rates), Nruns);
    temp_mis = zeros(length(lfp_fs) * length(firing_rates), Nruns);
    mse = zeros(length(lfp_fs), length(firing_rates), Nruns);
    temp_mse = zeros(length(lfp_fs) * length(firing_rates), Nruns);
    ps = zeros(length(lfp_fs), length(firing_rates), Nruns);
    temp_ps = zeros(length(lfp_fs) * length(firing_rates), Nruns);
    % Parallelize the outer loop
    for n = 1:Nruns
        % Each worker gets its own copy of 't' and 'duration' if they are not broadcast variables
        t_local = t;
        duration_local = duration;
        for fi = 1:length(lfp_fs)
            f = lfp_fs(fi);
            y = sin(2*pi*f*t_local);
            phi = angle(hilbert(y));
            
            for fr = 1:length(firing_rates)
                % Compute modulation index and store in preallocated array
                linear_index = (fi - 1) * length(firing_rates) + fr; % Map (fi, fr) to a single index

                spikeTimes = generatePoissonSpikes(fr, duration_local);
                spike_phases = zeros(1,length(spikeTimes));
                for st = 1:length(spikeTimes)
                    [~, ind] = min((t-spikeTimes(st)).^2);
                    spike_phases(st) = phi(ind);
                end 
                [N, ~] = histcounts(spike_phases, 20);
                % temp_result_mis(linear_index) = compute_modulation_index(N);
                mis(fi,fr,n) = compute_modulation_index(N);
                [x,y, ~, ~, ~] = vonMises(spike_phases);
                [N, edges] = histcounts(spike_phases, 20, 'Normalization', 'pdf');
                centers = zeros(length(edges)-1,1);
                for e = 1:(length(edges)-1)
                    centers(e) = mean(edges(e:(e+1)));
                end
                y_interpolated = interp1(x, y, centers(2:end-1), 'linear');
                % temp_result_mse(linear_index) = mean((N(2:end-1) - y_interpolated').^2);
                % [temp_result_ps(linear_index), ~] = circ_rtest(spike_phases);                                                                                                                
                mse(fi,fr,n) = mean((N(2:end-1) - y_interpolated').^2);
                [ps(fi,fr,n), ~] = circ_rtest(spike_phases);                                                                                                                
                
            end
        end
    end

    for fi = 1:length(lfp_fs)
        for fr = 1:length(firing_rates)
            fracs(fi,fr) = sum(ps(fi,fr,:) < (0.05/Nruns)) / Nruns;
        end
    end

    frac_fig = figure(); imagesc(firing_rates, lfp_fs, fracs); colorbar(); saveas(frac_fig, 'tmp/pois_frac.fig'); saveas(frac_fig, 'tmp/pois_frac.svg'); close;
    mse_fig = figure(); imagesc(firing_rates, lfp_fs, mean(mis,3)); colorbar(); saveas(mse_fig, 'tmp/pois_mse.fig'); saveas(mse_fig, 'tmp/pois_mse.svg'); close;
    mis_fig = figure(); imagesc(firing_rates, lfp_fs, mean(mse,3)); colorbar(); saveas(mis_fig, 'tmp/pois_mis.fig'); saveas(mis_fig, 'tmp/pois_mis.svg'); close;

    out_file = 'pois_sim_results.mat';
    out = struct();
    out.ps = ps;
    out.mse = mse;
    out.mis = mis;
    out.lfp_fs = lfp_fs;
    out.firing_rates = firing_rates;
    save(out_file, 'out', '-v7.3');
else
    out_file = 'pois_sim_results.mat';
    load(out_file)

    Nruns = size(out.mis,3);
    for fi = 1:length(out.lfp_fs)
        for fr = 1:length(out.firing_rates)
            fracs(fi,fr) = sum(out.ps(fi,fr,:) < (0.05/Nruns)) / Nruns;
        end
    end

    summary_fig = figure('Position', [1220 1334 1409 384]);
    tl = tiledlayout(1,3);
    axs(1) = nexttile;
    imagesc(out.firing_rates, out.lfp_fs, fracs.*100); cbar1 = colorbar();
    cbar1.Label.String = '% p < 0.05';
    xticks([1.0,20.0])
    yticks([8,12])
    axs(2) = nexttile;
    imagesc(out.firing_rates, out.lfp_fs, mean(out.mis,3)); cbar2 = colorbar();
    cbar2.Label.String = 'Modulation Index';
    xticks([1.0,20.0])
    yticks([8,12])
    axs(3) = nexttile;
    imagesc(out.firing_rates, out.lfp_fs, mean(out.mse,3)); cbar3 = colorbar();
    cbar3.Label.String = 'MSE';
    xlabel(tl, 'Neuronal Firing Rate (Hz)')
    ylabel(tl, 'LFP Frequency (Hz)')
    saveas(summary_fig, 'Figures/poisson_sim_results.fig')
    saveas(summary_fig, 'Figures/poisson_sim_results.svg')
end