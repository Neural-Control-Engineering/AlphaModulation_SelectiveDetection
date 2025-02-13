function out = assignRegions(ap_session, regMap)
    reg_positions = cell2mat(regMap.Y);
    regions = cell(size(ap_session,1),1);
    for c = 1:size(ap_session,1)
        try
            y = ap_session(c,:).position(2);
        catch
            y = ap_session(c,:).position{1}(2);
        end
        [~, ind] = min((reg_positions-y).^2);
        regions{c} = regMap(ind,:).region{1};
    end
    out = [ap_session, table(regions, 'VariableNames', {'region'})];
end