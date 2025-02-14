function out = fixLeftMinusRightPSTHS(ap_ftr, slrt_ftr)
    amps = -5:5;
    to_correct = -10:2:10;
    out = ap_ftr;
    for i = 1:size(ap_ftr,1)
        session_id = ap_ftr(i,:).session_id;
        tmp_slrt = slrt_ftr(strcmp(slrt_ftr.session_id, session_id),:);
        if max(tmp_slrt(1,:).left_minus_right_amp{1}) == 10
            for a = 1:length(to_correct)
                expr = sprintf('amp_%i', to_correct(a));
                variables = ap_ftr.Properties.VariableNames(startsWith(ap_ftr.Properties.VariableNames, expr));
                variables = variables(~contains(variables, 'Pass'));
                for v = 1:length(variables)
                    variable_parts = strsplit(variables{v}, '_');
                    new_var = strcat(variable_parts{1}, '_', num2str(to_correct(a)/2));
                    for p = 3:length(variable_parts)
                        new_var = strcat(new_var, '_', variable_parts{p});
                    end
                    try
                        out(i,:).(new_var) = ap_ftr(i,:).(variables{v});
                    catch
                        keyboard
                    end
                end 
            end 
        end 
    end
end