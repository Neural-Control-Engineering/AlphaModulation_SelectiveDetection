function out = ISIhist(ap_session, ap_data, slrt_data)
    isis = cell(size(ap_session,1),1);
    edges = isis;
    for c = 1:length(isis)
        isi = [];
        for t = 1:size(slrt_data,1)
            start = slrt_data(t,:).clock_time{1}(1);
            fin = slrt_data(t,:).clock_time{1}(end);
            spiking_data = ap_data(t,:).spiking_data{1};
            spike_times = spiking_data(c,:).spike_times{1}(spiking_data(c,:).spike_times{1} >= start & spiking_data(c,:).spike_times{1} <= fin);
            if ~isempty(spike_times)
                isi = [isi, diff(spike_times)];
            end
        end
        [isi_hist, hist_edges] = histcounts(isi, 100);
        isis{c} = isi_hist;
        edges{c} = hist_edges;
    end
    out = [ap_session, table(isis, edges, 'VariableNames', ...
        {'isi_hist', 'isi_hist_edges'})];
end