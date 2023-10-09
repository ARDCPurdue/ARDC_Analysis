function result = matchAndExtract(A, B)
    % Initialize a result array with NaN values
    result = NaN(size(B));

    % Find the indices where B matches A's first column
    [~, indices] = ismember(B, A(:, 1));
    
    % Find the rows where matches were found
    validRows = indices ~= 0;
    
    % Fill the result array with values from A's second column
    result(validRows) = A(indices(validRows), 2);
end