function contains_lick = spontaneousLicks(slrt_data)
    contains_lick = zeros(size(slrt_data,1),1);
    for i = 1:size(slrt_data,1)
        stim_ind = slrt_data(i,:).right_trigger;
        if isnan(stim_ind)
            stim_ind = slrt_data(i,:).left_trigger;
        end

        if ~isnan(stim_ind)
            numLicks = sum(slrt_data(i,:).lick_detector{1}(stim_ind-3000:stim_ind));
            if numLicks 
                contains_lick(i) = 1;
            end
        end
    end
end