function out = channel2position(channels, probe)
    out = cell(size(channels));
    for i = 1:length(channels)
        channel = channels(i);
        x = probe.regMap.X{cell2mat(probe.regMap.channel) == channel};
        y = probe.regMap.Y{cell2mat(probe.regMap.channel) == channel};
        out{i} = [x,y];
    end
end