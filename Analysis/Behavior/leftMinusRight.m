function out = leftMinusRight(slrt_data)
    left_minus_right_amp = cell(size(slrt_data,1),1);
    for t = 1:size(slrt_data,1)
        try
            left_amp = slrt_data(t,:).left_amp{1}(slrt_data(t,:).left_trigger);
            right_amp = slrt_data(t,:).right_amp{1}(slrt_data(t,:).right_trigger);
            left_minus_right_amp{t} = left_amp - right_amp;
        catch 
            left_minus_right_amp{t} = nan;
        end
    end
    out = [slrt_data, table(left_minus_right_amp, 'VariableNames', {'left_minus_right_amp'})];
end