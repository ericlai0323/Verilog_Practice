function rotated_matrix = cordic_rotation(matrix, mode)
    n_iterations = 20; % 調整迭代次數

    % CORDIC angles for arctan(2^-i)
    angles = atan(2.^-(0:n_iterations));

    rotated_matrix = zeros(size(matrix));

    for i = 1:size(matrix, 1)
        for j = 1:size(matrix, 2)
            x = matrix(i, j);
            y = 0;
            z = 0;

            for k = 1:n_iterations
                sigma = sign(y);

                if mode == "rotation"
                    [x, y, z] = cordic_rotate(x, y, z, sigma, angles(k));
                elseif mode == "vectoring"
                    [x, y, z] = cordic_vector(x, y, z, sigma, angles(k));
                else
                    error('Invalid mode. Use "rotation" or "vectoring".');
                end
            end

            rotated_matrix(i, j) = x;
        end
    end
end