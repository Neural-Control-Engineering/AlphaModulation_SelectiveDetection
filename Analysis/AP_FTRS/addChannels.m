function out = addChannels(ap_session, ap_data)
    channels = ap_data(1,:).spiking_data{1}.channel;
    channels = channels(strcmp(ap_data(1,:).spiking_data{1}.quality, 'good'));
    out = [ap_session, table(channels, 'VariableNames', {'channel'})];
end