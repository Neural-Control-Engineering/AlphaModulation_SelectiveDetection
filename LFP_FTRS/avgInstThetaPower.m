function out = avgInstThetaPower(lfp_session, lfp_data, slrt_data, event_names)
    avg_theta_power = cell(size(lfp_session,1),1);
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    out = lfp_session;
    for o = 1:length(outcomes)
        for c = 1:size(lfp_session,1)
            tmp_lfp = lfp_data(strcmp(slrt_data.categorical_outcome, outcomes{o}),:);
            theta_power = zeros(size(tmp_lfp,1), 3999);
            for t = 1:size(tmp_lfp,1)
                for e = 1:length(event_names)
                    if ~isempty(tmp_lfp(t,:).(strcat(event_names{e}, '_aligned_lfp_time')){1})
                        inds = find(tmp_lfp(t,:).(strcat(event_names{e}, '_aligned_lfp_time')){1} > -3.0 ...
                            & tmp_lfp(t,:).(strcat(event_names{e}, '_aligned_lfp_time')){1} < 5.0);
                        y = bandpassFilter(tmp_lfp(t,:).lfp{1}(c,inds), 4, 8, 500);
                        Y = abs(hilbert(y)).^2;
                        theta_power(t,:) = Y(1:3999);
                    end
                end
            end
            if size(theta_power,1) > 1
                avg_theta_power{c} = mean(theta_power,1);
            else
                avg_theta_power{c} = theta_power;
            end
        end
        out = [out, table(avg_theta_power, 'VariableNames', {strcat('avg_theta_power_', outcomes{o})})];
    end
end

