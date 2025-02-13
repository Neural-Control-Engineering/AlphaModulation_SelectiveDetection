function out = avgPSTHbyEvent(npxls_session, slrt_data, ap_data, event_name, edges)
    out = npxls_session;
    ap_data = ap_data(~isnan(slrt_data.(event_name)),:);
    variable_name = strcat(event_name, '_aligned_psth');

    if ~isempty(ap_data)
        % compute avg PSTH across trials for each PSTH type
        avg_psths = cell(size(npxls_session,1),1);
        for i = 1:size(npxls_session, 1)
            psth_mat = zeros(size(ap_data,1), length(edges)-1);
            for j = 1:size(ap_data,1)
                if ~isempty(ap_data(j,:).spiking_data{1}(i,:).(variable_name){1})
                    psth_mat(j,:) = ap_data(j,:).spiking_data{1}(i,:).(variable_name){1};
                end
            end
            avg_psths{i} = mean(psth_mat, 1);
        end
        vn_parts = strsplit(variable_name, 'psth');
        col_title = strcat(vn_parts{1}, 'avg_psth');
        
        out = [out, table(avg_psths, 'VariableNames', {col_title})];
    end

end