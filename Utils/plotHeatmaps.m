function [fig, axs, t, cb] = plotHeatmaps(cellArray, titles)
    % Determine global color limits
    allData = cell2mat(cellfun(@(x) x(:), cellArray, 'UniformOutput', false));
    clim = [min(min(allData)), max(max(allData))];
    
    % Create a figure and a tiled layout
    fig = figure;
    axs = zeros(1:numel(cellArray));
    t = tiledlayout(1, numel(cellArray), 'TileSpacing', 'compact', 'Padding', 'compact');
    
    % Plot each matrix as a heatmap in a subplot
    for i = 1:numel(cellArray)
        ax = nexttile;
        axs(i) = ax;
        imagesc(cellArray{i});
        set(ax, 'CLim', clim); % Apply the same color limits
        axis(ax, 'equal', 'tight');
        title(titles{i})
    end
    
    % Add a single colorbar that applies to all subplots
    cb = colorbar;
    cb.Layout.Tile = 'east'; % Position the colorbar to the right of the subplots
    
    % Return the figure object
    if nargout > 0
        fig = gcf;
    end
end
