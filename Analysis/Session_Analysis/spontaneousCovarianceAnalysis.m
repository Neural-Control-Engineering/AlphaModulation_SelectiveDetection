function avg_cov_mats = spontaneousCovarianceAnalysis(ap_data, slrt_data)
    % 1-Hit, 2-Miss, 3-FA, 4-CR, 5-action, 6-withheld, 7-correct, 8-incorrect, 9-all
    outcomes = {'Hit', 'Miss', 'CR', 'FA'};
    actions = {{'Hit', 'FA'}, {'Miss', 'CR'}};
    performance = {{'Hit', 'CR'}, {'FA', 'Miss'}};
    avg_cov_mats = cell(length(outcomes)+length(actions)+length(performance)+1,1);

    for i =1:length(outcomes)
        tmp_ap = ap_data(strcmp(slrt_data.categorical_outcome, outcomes{i}),:);
        cov_mats = concatenateCellArray(tmp_ap.spontaneous_cov_mat);
        avg_cov_mats{i} = mean(cov_mats, 3, 'omitnan');
    end

    for i = 1:length(actions)
        tmp_ap = ap_data(strcmp(slrt_data.categorical_outcome, actions{i}{1}) | strcmp(slrt_data.categorical_outcome, actions{i}{2}),:);
        cov_mats = concatenateCellArray(tmp_ap.spontaneous_cov_mat);
        avg_cov_mats{i+length(outcomes)} = mean(cov_mats, 3, 'omitnan');
    end

    for i = 1:length(performance)
        tmp_ap = ap_data(strcmp(slrt_data.categorical_outcome, performance{i}{1}) | strcmp(slrt_data.categorical_outcome, performance{i}{2}),:);
        cov_mats = concatenateCellArray(tmp_ap.spontaneous_cov_mat);
        avg_cov_mats{i+length(outcomes)+length(performance)} = mean(cov_mats, 3, 'omitnan');
    end

    tmp_ap = ap_data(~strcmp(slrt_data.categorical_outcome, 'Pass'),:);
    cov_mats = concatenateCellArray(tmp_ap.spontaneous_cov_mat);
    avg_cov_mats{end} = mean(cov_mats, 3, 'omitnan');
end

function output3D = concatenateCellArray(cellArray)
    % Determine the size of the 2D matrices
    [rows, cols] = size(cellArray{1});
    
    % Preallocate the 3D matrix
    numMatrices = numel(cellArray);
    output3D = zeros(rows, cols, numMatrices);
    
    % Populate the 3D matrix with the contents of the cell array
    for k = 1:numMatrices
        output3D(:, :, k) = cellArray{k};
    end
end
