% 讀取 CSI.txt 文件
fileID = fopen('CSI.txt', 'r');
data = fscanf(fileID, '%e');
fclose(fileID);

% 將數據整形成 4*4*1000 的三維矩陣
data = reshape(data, [4, 4, 1000]);

Q_matrix = zeros(4, 4, 1000);
R_matrix = zeros(4, 4, 1000);

A_matrix = zeros(4, 4, 1000);

% [Q, R] = cordic_qr_decomposition(data(:, :, 1), 16,16);
% 
% A = Q * R;

% 循環處理每個4*4矩陣
for k = 1:1

    [Q, R] = cordic_qr_decomposition(data(:, :, k), 8);
    Q_matrix(:, :, k) = Q;
    R_matrix(:, :, k) = R;

    % A_matrix(:, :, k) = Q*R;
    % if(A_matrix(:, :, k) == data(:, :, k) )
    %     disp("A = QR");
    % else
    %     disp("A != QR Error!!");
    % end

    
    % [Q , R] = cordicqr(data(:, :, k));
    % [Real_Q, Real_R] = qr(data(:, :, k));
end

