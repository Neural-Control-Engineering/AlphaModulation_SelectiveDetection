function out = avgTrialFR(npxls_session, slrt_data, ap_data)
    avg_trial_frs = cell(size(npxls_session, 1),1);
    for i = 1:size(npxls_session,1)
        frs = zeros(size(slrt_data,1),1);
        for j = 1:size(slrt_data,1)
            start_time = slrt_data(j,:).clock_time{1}(1);
            fin_time = slrt_data(j,:).clock_time{1}(end);
            spk_times = ap_data(j,:).spiking_data{1}(i,:).spike_times{1};
            spk_times = spk_times(spk_times >= start_time & spk_times <= fin_time);
            frs(j) = length(spk_times) / (fin_time - start_time);
        end
        avg_trial_frs{i} = mean(frs);
    end
    out = [npxls_session, table(avg_trial_frs, 'VariableNames', {'avg_trial_fr'})];
end