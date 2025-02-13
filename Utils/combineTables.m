function combinedTable = combineTables(table1, table2)
    % Identify missing columns in table1
    missingColsInTable1 = setdiff(table2.Properties.VariableNames, table1.Properties.VariableNames);
    
    % Identify missing columns in table2
    missingColsInTable2 = setdiff(table1.Properties.VariableNames, table2.Properties.VariableNames);
    
    % Add missing columns to table1 with appropriate empty values
    for i = 1:length(missingColsInTable1)
        varName = missingColsInTable1{i};
        % if iscell(table2.(varName))
        %     table1.(varName) = repmat({''}, height(table1), 1);  % Empty cells for text data
        % else
        table1.(varName) = cell(height(table1), 1);  % NaN for numeric data
        % end
    end
    
    % Add missing columns to table2 with appropriate empty values
    for i = 1:length(missingColsInTable2)
        varName = missingColsInTable2{i};
        % if iscell(table1.(varName))
        %     table2.(varName) = repmat({''}, height(table2), 1);  % Empty cells for text data
        % else
        table2.(varName) = cell(height(table2), 1);  % NaN for numeric data
        % end
    end
    
    % Ensure both tables have the same column order
    table1 = table1(:, sort(table1.Properties.VariableNames));
    table2 = table2(:, sort(table2.Properties.VariableNames));
    
    % Concatenate the tables
    combinedTable = [table1; table2];
end
