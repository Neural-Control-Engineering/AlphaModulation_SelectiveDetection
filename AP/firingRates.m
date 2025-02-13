function out = firingRates(ap_data, bin_size, gauss_bin_size)
    out = ap_data;
    for t = 1:size(ap_data,1)
        spiking_data = ap_data(t,:).spiking_data{1};
        variable_names = spiking_data.Properties.VariableNames;
        for vn = 1:length(variable_names)
            if contains(variable_names{vn}, 'psth') && ~all(cellfun(@isempty, spiking_data.(variable_names{vn})))
                psths = spiking_data.(variable_names{vn});
                bin_sizes = num2cell(repmat(bin_size, length(psths), 1));
                gauss_bin_sizes = num2cell(repmat(gauss_bin_size, length(psths), 1));
                frs = cellfun(@psth2fr, psths, bin_sizes, gauss_bin_sizes, 'UniformOutput', false);
                col_title = strrep(variable_names{vn}, 'psth', 'fr');
                out(t,:).spiking_data{1} = [out(t,:).spiking_data{1}, table(frs, 'VariableNames', {col_title})];
            end
        end
    end    
end

function out = psth2fr(psth, bin_size, gauss_bin_size)
    x = psth ./ bin_size;
    out = smoothdata(x, 'gaussian', gauss_bin_size);
end

