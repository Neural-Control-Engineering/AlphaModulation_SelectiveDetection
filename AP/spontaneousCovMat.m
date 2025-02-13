function out = spontaneousCovMat(ap_data, event_names, edges)
    cov_mats = cell(size(ap_data,1),1);
    centers = (edges(1:end-1) + edges(2:end)) / 2;
    for t = 1:size(ap_data,1)
        spiking_data = ap_data(t,:).spiking_data{1};
        spiking_data = spiking_data(strcmp(spiking_data.quality, 'good'),:);
        variable_names = spiking_data.Properties.VariableNames;
        variable_name = [];
        for e = 1:length(event_names)
            if any(strcmp(variable_names, strcat(event_names{e}, '_aligned_fr')))
                variable_name = strcat(event_names{e}, '_aligned_fr');
            end
        end
        
        if ~isempty(variable_name)
            frs = cell2mat(spiking_data.(variable_name));
            cov_mat = zeros(size(frs,1), size(frs,1));
            for i = 1:size(frs,1)
                for j = 1:size(frs,1)
                    if i == j
                        cov_mat(i,j) = var(frs(i,centers < 0));
                    else
                        cvmat = cov(frs(i,centers < 0), frs(j,centers < 0));
                        cov_mat(i,j) = cvmat(1,2);
                    end
                end
            end
            for i = 1:size(frs,1)
                for j = 1:size(frs,1)
                    cov_mat(i,j) = cov_mat(i,j) / (sqrt(cov_mat(i,i))*sqrt(cov_mat(j,j)));
                end
            end
            cov_mats{t} = cov_mat;
        end
    end
    out = [ap_data, table(cov_mats, 'VariableNames', {'spontaneous_cov_mat'})];
end