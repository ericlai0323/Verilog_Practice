function [ik, qk] = serial_to_parallel(binary_data)
    % Initialize ik and qk as empty arrays
    ik = [];
    qk = [];

    % Iterate through the binary data
    for i = 1:length(binary_data)
        % Append the binary digit to ik or qk based on its position
        binary_digit = binary_data(i);
        if mod(i, 2) == 1
            ik = [ik binary_digit];
        else
            qk = [qk binary_digit];
        end
    end
end
