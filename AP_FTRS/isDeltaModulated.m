function out = isDeltaModulated(ap_session)
    p_value = cell(size(ap_session,1),1);
    kappa = cell(size(ap_session,1),1);
    hists = cell(size(ap_session,1),1);
    p_threshold = cell(size(ap_session,1),1);
    p_value_hit = cell(size(ap_session,1),1);
    kappa_hit = cell(size(ap_session,1),1);
    hists_hit = cell(size(ap_session,1),1);
    p_threshold_hit = cell(size(ap_session,1),1);
    p_value_miss = cell(size(ap_session,1),1);
    kappa_miss = cell(size(ap_session,1),1);
    hists_miss = cell(size(ap_session,1),1);
    p_threshold_miss = cell(size(ap_session,1),1);
    p_value_cr = cell(size(ap_session,1),1);
    kappa_cr = cell(size(ap_session,1),1);
    hists_cr = cell(size(ap_session,1),1);
    p_threshold_cr = cell(size(ap_session,1),1);
    p_value_fa = cell(size(ap_session,1),1);
    kappa_fa = cell(size(ap_session,1),1);
    hists_fa = cell(size(ap_session,1),1);
    p_threshold_fa = cell(size(ap_session,1),1);
    for c = 1:size(ap_session,1)
        % spontaneous
        if ~isempty(ap_session(c,:).delta_spike_phases{1})
            R = circ_r(ap_session(c,:).delta_spike_phases{1});
            [p, ~] = circ_rtest(ap_session(c,:).delta_spike_phases{1});
            kappa{c} = circ_kappa(R);
            hists{c} = histcounts(ap_session(c,:).delta_spike_phases{1}, 20);
            p_threshold{c} = 0.05 / length(ap_session(c,:).delta_spike_phases{1});
            p_value{c} = p;
            % if p < p_threshold{c}
            %     fitVonMisesToHistogram(ap_session(c,:).delta_spike_phases{1}, 20);
            % end
        end

        % hit trials 
        if ~isempty(ap_session(c,:).delta_spike_phases_hit{1})
            R = circ_r(ap_session(c,:).delta_spike_phases_hit{1});
            [p, ~] = circ_rtest(ap_session(c,:).delta_spike_phases_hit{1});
            kappa_hit{c} = circ_kappa(R);
            hists_hit{c} = histcounts(ap_session(c,:).delta_spike_phases_hit{1}, 20);
            p_threshold_hit{c} = 0.05 / length(ap_session(c,:).delta_spike_phases_hit{1});
            p_value_hit{c} = p;
            % if p < p_threshold{c}
            %     fitVonMisesToHistogram(ap_session(c,:).delta_spike_phases_hit{1}, 20);
            % end
        end
        % miss trials 
        if ~isempty(ap_session(c,:).delta_spike_phases_miss{1})
            R = circ_r(ap_session(c,:).delta_spike_phases_miss{1});
            [p, ~] = circ_rtest(ap_session(c,:).delta_spike_phases_miss{1});
            kappa_miss{c} = circ_kappa(R);
            hists_miss{c} = histcounts(ap_session(c,:).delta_spike_phases_miss{1}, 20);
            p_threshold_miss{c} = 0.05 / length(ap_session(c,:).delta_spike_phases_miss{1});
            p_value_miss{c} = p;
            % if p < p_threshold{c}
            %     fitVonMisesToHistogram(ap_session(c,:).delta_spike_phases_miss{1}, 20);
            % end
        end
        % CR trials
        if ~isempty(ap_session(c,:).delta_spike_phases_cr{1}) 
            R = circ_r(ap_session(c,:).delta_spike_phases_cr{1});
            [p, ~] = circ_rtest(ap_session(c,:).delta_spike_phases_cr{1});
            kappa_cr{c} = circ_kappa(R);
            hists_cr{c} = histcounts(ap_session(c,:).delta_spike_phases_cr{1}, 20);
            p_threshold_cr{c} = 0.05 / length(ap_session(c,:).delta_spike_phases_cr{1});
            p_value_cr{c} = p;
            % if p < p_threshold{c}
            %     fitVonMisesToHistogram(ap_session(c,:).delta_spike_phases_cr{1}, 20);
            % end
        end
        % FA trials 
        if ~isempty(ap_session(c,:).delta_spike_phases_fa{1})
            R = circ_r(ap_session(c,:).delta_spike_phases_fa{1});
            [p, ~] = circ_rtest(ap_session(c,:).delta_spike_phases_fa{1});
            kappa_fa{c} = circ_kappa(R);
            hists_fa{c} = histcounts(ap_session(c,:).delta_spike_phases_fa{1}, 20);
            p_threshold_fa{c} = 0.05 / length(ap_session(c,:).delta_spike_phases_fa{1});
            p_value_fa{c} = p;
            % if p < p_threshold{c}
            %     fitVonMisesToHistogram(ap_session(c,:).delta_spike_phases_fa{1}, 20);
            % end
        end
    end
    out = [ap_session, table(p_value, kappa, hists, p_threshold, ...
        p_value_hit, kappa_hit, hists_hit, p_threshold_hit, ...
        p_value_miss, kappa_miss, hists_miss, p_threshold_miss, ...
        p_value_cr, kappa_cr, hists_cr, p_threshold_cr, ...
        p_value_fa, kappa_fa, hists_fa, p_threshold_fa, ...
        'VariableNames', {'p_value_delta', 'kappa_delta', 'hists_delta', 'p_threshold_delta', ...
        'p_value_delta_hit', 'kappa_delta_hit', 'hists_delta_hit', 'p_threshold_delta_hit', ...
        'p_value_delta_miss', 'kappa_delta_miss', 'hists_delta_miss', 'p_threshold_delta_miss', ...
        'p_value_delta_cr', 'kappa_delta_cr', 'hists_delta_cr', 'p_threshold_delta_cr', ...
        'p_value_delta_fa', 'kappa_delta_fa', 'hists_delta_fa', 'p_threshold_delta_fa'})];
end

function R = circ_r(delta)
    % Compute the resultant length
    N = length(delta);
    sin_sum = sum(sin(delta));
    cos_sum = sum(cos(delta));
    R = sqrt(sin_sum^2 + cos_sum^2) / N;
end

function kappa = circ_kappa(R)
    % Estimate the concentration parameter kappa
    if R < 0.53
        kappa = 2*R + R^3 + (5*R^5)/6;
    elseif R < 0.85
        kappa = -0.4 + 1.39*R + 0.43/(1 - R);
    else
        kappa = 1/(R^3 - 4*R^2 + 3*R);
    end
end