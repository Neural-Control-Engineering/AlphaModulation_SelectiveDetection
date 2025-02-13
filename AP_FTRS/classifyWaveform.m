function out = classifyWaveform(ap_session, fsRsThreshold)
    classes = cell(size(ap_session,1),1);
    for c = 1:size(ap_session,1)
        classes{c} = classifySpkWaveform(ap_session(c,:).template{1}, fsRsThreshold);
    end
    out = [ap_session, table(classes, 'VariableNames', {'waveform_class'})];
end 

function out = classifySpkWaveform(wvfrm, fsRsThreshold)
    [neg_amp, neg_ind] = max(abs(wvfrm));
    if wvfrm(neg_ind) > 0
        out = 'PS';
    else
        [width, first_ind, last_ind, half_max] = getSpikeWidth(wvfrm);
        [pks, locs] = findpeaks(wvfrm, 'MinPeakProminence', 1);
        if ~isempty(pks) && locs(1) < neg_ind
            if length(locs(locs < neg_ind)) > 1
                [first_peak, fp_ind] = max(pks(locs < neg_ind));
                try
                    nplocs = locs(locs > neg_ind);
                    np_ind = nplocs(1);
                catch
                    [~, np_ind] = max(wvfrm(neg_ind+1:end));
                    np_ind = np_ind + neg_ind;
                end
            else
                first_peak = pks(1);
                fp_ind = locs(1);
                try
                    np_ind = locs(2);
                catch
                    [~, np_ind] = max(wvfrm(neg_ind+1:end));
                    np_ind = np_ind + neg_ind;
                end
            end
            if (first_peak >= 0.1*neg_amp) 
                if width < 20
                    out = 'TS';
                else
                    out = 'CS';
                end
            else 
                [~, trough2peak] = getEndSlope(wvfrm);
                if ~isnan(trough2peak)
                    trough2peak = trough2peak / 30;
                    if trough2peak < fsRsThreshold
                        out = 'FS';
                    else
                        out = 'RS';
                    end
                else
                    out = 'NS';
                end
            end
        else
            [~, trough2peak] = getEndSlope(wvfrm);
            if ~isnan(trough2peak)
                trough2peak = trough2peak / 30;
                if trough2peak < fsRsThreshold
                    out = 'FS';
                else
                    out = 'RS';
                end
            else
                out = 'NS';
            end
        end
    end
end

function [out, first_ind, last_ind, half_max] = getSpikeWidth(wvfrm)
    y = abs(wvfrm);
    x1 = 1:length(wvfrm);
    x2 = 1:0.25:length(wvfrm);
    y = spline(x1, y, x2);
    [amp, ind] = max(y);
    half_max = amp / 4;
    first_ind = find(y(1:ind) <= half_max, 1, 'last');
    last_ind = find(y(ind+1:end) <= half_max, 1, 'first') + ind;
    first_ind = x2(first_ind);
    last_ind = x2(last_ind);
    out = last_ind - first_ind;
    % figure(); plot(y); hold on; plot([first_ind, last_ind],[half_max, half_max], 'k--')
end

function [out, trough2peak] = getEndSlope(wvfrm)
    x1 = 1:length(wvfrm);
    x2 = 1:0.25:length(wvfrm);
    y = spline(x1, wvfrm, x2);
    [~, ~, last_ind, ~] = getSpikeWidth(wvfrm);
    last_ind = find(x2==last_ind);
    [post_peak, post_peak_ind] = max(y(last_ind:end));
    % [post_min, post_min_ind] = min(y(last_ind+post_peak_ind:end));
    try
        post_min = y(last_ind+post_peak_ind+25);
        out = (post_min - post_peak) / (x2(last_ind+post_peak_ind+25) - x2(last_ind+post_peak_ind));
        [~, min_ind] = min(y);
        trough2peak = x2(last_ind+post_peak_ind) - x2(min_ind);
    catch
        out = nan;
        trough2peak = nan;
    end 
end