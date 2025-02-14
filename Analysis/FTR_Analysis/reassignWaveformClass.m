function out = reassignWaveformClass(ap_session)
    ap_session = removevars(ap_session, 'waveform_class');
    wvfrm_classes = cell(size(ap_session,1),1);
    fsRsThreshold = 7;
    for i = 1:size(ap_session,1)
        wvfrm = ap_session(i,:).template{1};
        [neg_amp, neg_ind] = max(abs(wvfrm));
        if wvfrm(neg_ind) > 0
            wvfrm_class = 'PS';
        else
            [width, first_ind, last_ind, half_max] = getSpikeWidth(wvfrm);
            [pks, locs] = findpeaks(wvfrm, 'MinPeakProminence', 100);
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
                        wvfrm_class = 'TS';
                    else
                        wvfrm_class = 'CS';
                    end
                else 
                    if width < fsRsThreshold
                        wvfrm_class = 'FS';
                    else
                        wvfrm_class = 'RS';
                    end
                end
            else
                if width < fsRsThreshold
                    wvfrm_class = 'FS';
                else
                    wvfrm_class = 'RS';
                end
            end
        end
        wvfrm_classes{i} = wvfrm_class;
    end
    out = [ap_session, table(wvfrm_classes, 'VariableNames', {'waveform_class'})];
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
