function customViolinPlot(data, positions, width)
    % customViolinPlot creates violin plots for the given data.
    % data: Cell array where each cell contains a vector of data points for a group.
    % positions: Vector specifying the x-axis positions for each violin.
    % width: Scalar specifying the maximum width of each violin.

    if nargin < 3
        width = 0.3; % Default width
    end

    numGroups = numel(data);
    hold on;

    for i = 1:numGroups
        % Extract data for the current group
        groupData = data{i}(:);

        % Compute kernel density estimate
        [density, value] = ksdensity(groupData, 'Function', 'pdf');

        % Normalize the density to match the specified width
        density = density / max(density) * width;

        % Create the violin plot by mirroring the density
        fill([positions(i) - density, fliplr(positions(i) + density)], ...
             [value, fliplr(value)], [0.5 0.5 0.5], 'FaceAlpha', 0.5, 'EdgeColor', 'none');

        % % Plot the median
        % plot(positions(i), median(groupData), 'ko', 'MarkerFaceColor', 'k');

        % Plot whiskers (1.5*IQR)
        q1 = prctile(groupData, 25);
        q3 = prctile(groupData, 75);
        IQR = q3 - q1;
        lowerWhisker = max(min(groupData), q1 - 1.5 * IQR);
        upperWhisker = min(max(groupData), q3 + 1.5 * IQR);
        % plot([positions(i), positions(i)], [lowerWhisker, upperWhisker], 'k-', 'LineWidth', 1.5);

        % % Plot the interquartile range box
        % fill([positions(i) - width/4, positions(i) + width/4, positions(i) + width/4, positions(i) - width/4], ...
        %      [q1, q1, q3, q3], 'k', 'FaceAlpha', 0.1, 'EdgeColor', 'k');
    end

    hold off;
    set(gca, 'XTick', positions, 'XTickLabel', arrayfun(@(x) ['Group ' num2str(x)], 1:numGroups, 'UniformOutput', false));
end
