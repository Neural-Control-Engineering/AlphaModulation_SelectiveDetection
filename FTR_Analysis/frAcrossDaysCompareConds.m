function frAcrossDaysCompareConds(ftr1, ftr2)
    [~, inds] = sort(ftr1.position(:,2));
    ftr1 = ftr1(inds,:);
    [~, inds] = sort(ftr2.position(:,2));
    ftr2 = ftr2(inds,:);
    positions1 = ftr1.position;
    uniq_ys1 = unique(positions1(:,2));
    positions2 = ftr2.position;
    uniq_ys2 = unique(positions2(:,2));
    time = linspace(-2.8, 4.9, 80);
    for i = 1:length(uniq_ys1)
        y = uniq_ys1(i);
        y_pos1 = positions1(positions1(:,2) == y,:);
        y_ftr1 = ftr1(positions1(:,2) == y, :);
        y_pos2 = positions2(positions2(:,2) == y,:);
        y_ftr2 = ftr2(positions2(:,2) == y, :);
        uniq_xs = unique(y_pos1(:,1));
        for j = 1:length(uniq_xs)
            x = uniq_xs(j);
            x_ftr1 = y_ftr1(y_ftr1.position(:,1) == x, :);
            x_ftr2 = y_ftr2(y_ftr2.position(:,1) == x, :);
            if ~isempty(x_ftr2)
                fig = figure();
                tl = tiledlayout(1,4);
                axs = zeros(1,4);
                axs(1) = nexttile;
                hold on 
                mat1 = cell2mat(x_ftr1.left_trigger_aligned_avg_fr_Hit);
                mat2 = cell2mat(x_ftr2.left_trigger_aligned_avg_fr_Hit);
                if ~isempty(mat1)
                    try
                        semshade(mat1, 0.3, 'b', 'b', time, 1);
                    catch
                        plot(time, mat1, 'b')
                    end
                end
                if ~isempty(mat2)
                    try
                        semshade(mat2, 0.3, 'r', 'r', time, 1);
                    catch
                        plot(time, mat2, 'r')
                    end
                end
                axs(2) = nexttile;
                hold on 
                mat1 = cell2mat(x_ftr1.left_trigger_aligned_avg_fr_Miss);
                mat2 = cell2mat(x_ftr2.left_trigger_aligned_avg_fr_Miss);
                if ~isempty(mat1)
                    try
                        semshade(mat1, 0.3, 'b', 'b', time, 1);
                    catch
                        plot(time, mat1, 'b')
                    end
                end
                if ~isempty(mat2)
                    try
                        semshade(mat2, 0.3, 'r', 'r', time, 1);
                    catch
                        plot(time, mat2, 'r')
                    end
                end
                axs(3) = nexttile;
                hold on 
                mat1 = cell2mat(x_ftr1.left_trigger_aligned_avg_fr_CR);
                mat2 = cell2mat(x_ftr2.left_trigger_aligned_avg_fr_CR);
                if ~isempty(mat1)
                    try
                        semshade(mat1, 0.3, 'b', 'b', time, 1);
                    catch
                        plot(time, mat1, 'b')
                    end
                end
                if ~isempty(mat2)
                    try
                        semshade(mat2, 0.3, 'r', 'r', time, 1);
                    catch
                        plot(time, mat2, 'r')
                    end
                end
                axs(4) = nexttile;
                hold on 
                mat1 = cell2mat(x_ftr1.left_trigger_aligned_avg_fr_FA);
                mat2 = cell2mat(x_ftr2.left_trigger_aligned_avg_fr_FA);
                if ~isempty(mat1)
                    try
                        semshade(mat1, 0.3, 'b', 'b', time, 1);
                    catch
                        plot(time, mat1, 'b')
                    end
                end
                if ~isempty(mat2)
                    try
                        semshade(mat2, 0.3, 'r', 'r', time, 1);
                    catch
                        plot(time, mat2, 'r')
                    end
                end
            end
        end
    end

    % keyboard
    % for y = 1:length(uniq_ys)
    %     y_pos = positions(positions(:,2) == uniq_ys(y),:);
    %     y_ftr1 = ftr1(positions(:,2) == uniq_ys(y),:);
    %     uniq_xs = unique(y_pos(:,1));
    %     for x = 1:length(uniq_xs)
    %         x_ftr1 = y_ftr1(y_pos(:,1) == uniq_xs(x), :);
    %         % if length(unique(x_ftr1.session_id)) == length(x_ftr1.session_id)
    %             mat = cell2mat(x_ftr1.left_trigger_aligned_avg_fr_Hit);
    %             mat = mat.*2 + y_pos(x,2);
    %             offset = randi([-5,5]);
    %             time = linspace(-2.8, 4.9, 80) + uniq_xs(x) + offset;
    %             try
    %                 semshade(mat, 0.3, 'k', 'k', time, 1);
    %                 plot([uniq_xs(x)+offset, uniq_xs(x)+offset], [min(min(mat)), max(max(mat))], 'k--')
    %             catch
    %                 plot(time, mat, 'k')
    %                 plot([uniq_xs(x)+offset, uniq_xs(x)+offset], [min(min(mat)), max(max(mat))], 'k--')
    %             end
    %         % else
    %         %     keyboard
    %         %     for i = 1:size(x_ftr1,1)
    %         %         mat = x_ftr1(i,:).left_trigger_aligned_avg_fr_Hit{1};
    %         %         mat = mat.*2 + y_pos(x,2);
    %         %         time = linspace(-2.8, 4.9, 80) + uniq_xs(x) + (i-1)*10;
    %         %         plot(time, mat, 'k')
    %         %         plot([uniq_xs(x)+(i-1)*10, uniq_xs(x)+(i-1)*10], [min(min(mat)), max(max(mat))], 'k--')
    %         %     end
    %         % end
    %     end
    % end
end
