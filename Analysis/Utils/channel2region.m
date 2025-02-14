function out = channel2region(channels, probe)
    out = cell(size(channels));
    for i = 1:length(channels)
        channel = channels(i);
        try 
            out{i} = probe.regMap.region{channel};
        catch
            out{i} = probe.regMap.region{channel-1};
        end
    end
end