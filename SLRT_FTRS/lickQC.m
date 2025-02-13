function [out, ind] = lickQC(slrt_data)
    time = cell2mat(slrt_data.clock_time);
    lick_detector = cell2mat(slrt_data.lick_detector);
    lick_times = time(logical(lick_detector));
    inter_lick = diff(lick_times);
    t_end = max(time);
    for j = 2:length(lick_times)
        t = mean([lick_times(j-1), lick_times(j)]);
        if inter_lick(j-1) > 120
            t_end = t;
            break
        end
    end
    for i = 1:size(slrt_data,1)
        if any(slrt_data(i,:).clock_time{1} > t_end)
            break
        end
    end
    out = slrt_data(1:i-1,:);
    ind = i;
end