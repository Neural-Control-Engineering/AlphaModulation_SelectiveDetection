function out = avgInstAlphaPower(lfp_session, lfp_data, slrt_data, event_names)
    avg_alpha_power = cell(size(lfp_session,1),1);
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    out = lfp_session;
    for o = 1:length(outcomes)
        for c = 1:size(lfp_session,1)
            tmp_lfp = lfp_data(strcmp(slrt_data.categorical_outcome, outcomes{o}),:);
            alpha_power = zeros(size(tmp_lfp,1), 3999);
            for t = 1:size(tmp_lfp,1)
                for e = 1:length(event_names)
                    if ~isempty(tmp_lfp(t,:).(strcat(event_names{e}, '_aligned_lfp_time')){1})
                        inds = find(tmp_lfp(t,:).(strcat(event_names{e}, '_aligned_lfp_time')){1} > -3.0 ...
                            & tmp_lfp(t,:).(strcat(event_names{e}, '_aligned_lfp_time')){1} < 5.0);
                        y = bandpassFilter(tmp_lfp(t,:).lfp{1}(c,inds), 8, 12, 500);
                        Y = abs(hilbert(y)).^2;
                        alpha_power(t,:) = Y(1:3999);
                    end
                end
            end
            if size(alpha_power,1) > 1
                avg_alpha_power{c} = mean(alpha_power,1);
            else
                avg_alpha_power{c} = alpha_power;
            end
        end
        out = [out, table(avg_alpha_power, 'VariableNames', {strcat('avg_alpha_power_', outcomes{o})})];
    end
end

