function [Q, R] = cordic_qr_decomposition_X(A, vectoring_iterations, rotating_iterations)
    [m, n] = size(A);
    
    if m ~= n
        error('Input matrix must be square for QR decomposition.');
    end
    
    Q = eye(m);
    R = A;
    
    for col = 1:min(m-1, n)
        x = R(col:m, col);
        y = zeros(size(x));
        
        % Apply CORDIC vectoring mode to find rotation matrix
        [~, ~, rot_vectoring] = vectoring_mode_cordic(x(1), x(2), vectoring_iterations);
        
        % Create rotation matrix
        G_vectoring = eye(m);
        G_vectoring(col:col+1, col:col+1) = [cosd(rot_vectoring) -sind(rot_vectoring); sind(rot_vectoring) cosd(rot_vectoring)];
        
        % Update Q and R
        Q = Q * G_vectoring';
        R = G_vectoring * R;
        
        % Apply CORDIC rotating mode to further refine the result
        [x, y] = rotating_mode_cordic(x(1), x(2), rotating_iterations, rot_vectoring);
        
        % Create rotation matrix
        G_rotating = eye(m);
        G_rotating(col:col+1, col:col+1) = [cosd(rot_vectoring) -sind(rot_vectoring); sind(rot_vectoring) cosd(rot_vectoring)];
        
        % Update R (upper triangular part)
        R(col, col) = sqrt(x(1)^2 + y(1)^2);
        R(col, col+1) = 0; % The upper triangular part of R is updated
        
        % Update Q and R
        Q = Q * G_rotating';
        R = G_rotating * R;
    end
end
