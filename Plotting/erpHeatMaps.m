function erpHeatMaps(lfp_session)
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    variable_names = lfp_session.Properties.VariableNames;
    outcome_fig = figure();
    outcome_tl = tiledlayout(1,4);
    outcome_axs = zeros(1,4);
    for o = 1:length(outcomes)
        variable_name = variable_names{endsWith(variable_names, strcat('aligned_erp_', outcomes{o}))};
        mat = cell2mat(lfp_session.(variable_name));
        mat = mat - mean(mat(:,1:1499),2);
        outcome_axs(o) = nexttile;
        imagesc(mat)
        title(outcomes{o})
    end

    stim_fig = figure();
    stim_tl = tiledlayout(1,2);
    stim_axs = zeros(1,2);
    events = {'right_trigger', 'left_trigger'};
    for e = 1:length(events)
        variable_name = strcat(events{e}, '_aligned_erp');
        mat = cell2mat(lfp_session.(variable_name));
        mat = mat - mean(mat(:,1:1499),2);
        stim_axs(e) = nexttile;
        imagesc(mat);
        title(strrep(events{e}, '_', ' '))
    end
end