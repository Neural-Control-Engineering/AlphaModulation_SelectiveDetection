function compareReactionTimeCurves(ftr_files, visualize, out_path, ftr_names)
    % compare animals 
    for i = 1:length(ftr_files)
        if iscell(ftr_files{i})
            % combine animals
            for j = 1:length(ftr_files{i})
                f = load(ftr_files{i}{j});
                if j == 1
                    ftrs = f.slrt_ftr;
                else
                    ftrs = combineTables(ftrs, f.slrt_ftr);
                end
            end
            expr = sprintf('ftr%i = ftrs;', i);
            eval(expr)
        else
            expr = sprintf('ftr%i = load(ftr_files{%i});', i, i);
            eval(expr)
            expr = sprintf('ftr%i = ftr%i.slrt_ftr;', i, i);
            eval(expr)
        end
    end

    if visualize 
        fig = figure();
    else
        fig = figure('Visible', 'off');
    end
    hold on
    cols = {'b', 'r', 'm', 'g'};
    if length(ftr_files) == 1
        expr = sprintf('mat%i = cell2mat(ftr%i.rt_by_diff);', i, i);
        eval(expr)
        n = eval(sprintf('size(mat%i,1)', i));
        name = sprintf('%s (n = %i)', ftr_names{i}, n);
        expr = sprintf("semshade(mat%i, 0.3, 'k', 'k', -10:2:10, 1, '%s');",i,name);
        eval(expr)
    else
        for i = 1:length(ftr_files)
            expr = sprintf('mat%i = cell2mat(ftr%i.rt_by_diff);', i, i);
            eval(expr)
            n = eval(sprintf('size(mat%i,1)', i));
            name = sprintf('%s (n = %i)', ftr_names{i}, n);
            expr = sprintf("semshade(mat%i, 0.3, cols{%i}, cols{%i}, -10:2:10, 1, '%s');", i,i,i,name);
            eval(expr)
        end
    end
    xlabel('Left - Right Amplitude')
    ylabel('Reaction Time (s)')
    legend()

    if out_path 
        saveas(fig, 'reaction_time_curve_comparison.fig')
    end

end
