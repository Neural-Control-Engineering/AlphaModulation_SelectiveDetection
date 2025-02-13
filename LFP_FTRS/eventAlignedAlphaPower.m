function out = ERP(lfp_session, lfp_data, event_names, t0, t1)
    fs = round(1 / (lfp_data(1,:).lfpTime{1}(2) - lfp_data(1,:).lfpTime{1}(1)));
    out = lfp_session;
    for e = 1:length(event_names)
        event_name = strcat(event_names{e}, '_aligned_lfp_time');
        erps = cell(size(lfp_session,1),1);
        erp_times = cell(size(lfp_session,1),1);
        for c = 1:size(lfp_session,1)
            tmp_lfp = lfp_data(~cellfun(@isempty, lfp_data.(event_name)),:);
            mat = {};
            for t = 1:size(tmp_lfp,1)
                mat{t,1} = tmp_lfp(t,:).lfp{1}(c, tmp_lfp(t,:).(event_name){1} > t0 & tmp_lfp(t,:).(event_name){1} < t1);
            end
            fin = min(cellfun(@size, mat, num2cell(repmat(2,length(mat),1))));
            m = [];
            for i = 1:length(mat)
                m = [m; mat{i}(1:fin)];
            end
            erps{c} = mean(m);
            time = linspace(t0, t1, size(m,2));
            erp_times{c} = time;
        end
        col_title = strcat(event_names{e}, '_aligned_erp');
        time_title = strcat(col_title, '_time');
        out = [out, table(erps, erp_times, 'VariableNames', {col_title, time_title})];
    end
end