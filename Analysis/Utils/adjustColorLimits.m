function adjustColorLimits(fig, newClim)
    % Find all axes in the figure
    ax = findall(fig, 'type', 'axes');
    
    % Adjust color limits for each axis
    for i = 1:length(ax)
        set(ax(i), 'CLim', newClim);
    end
    
    % Adjust color limits for the colorbar
    cb = findall(fig, 'Type', 'ColorBar');
    if ~isempty(cb)
        set(cb, 'Limits', newClim);
    end
end
