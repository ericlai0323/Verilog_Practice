% 讀取 CSI.txt 文件
fileID = fopen('CSI.txt', 'r');
data = fscanf(fileID, '%e');
fclose(fileID);

% 精度為2^8並捨去浮點數，預計誤差2.18%
for i = 1: 16000
    data(i) = fix(data(i) * 2^8);
end

% 將數據整形成 4*4*1000 的三維矩陣
data = reshape(data, [4, 4, 1000]);

Q_matrix = zeros(4, 4, 1000);
R_matrix = zeros(4, 4, 1000);

% 循環處理每個4*4矩陣
for k = 1:1
    
    [Q, R] = cordic_qr_decomposition(data(:, :, k), 10);
    Q_matrix(:, :, k) = Q;
    R_matrix(:, :, k) = R;
    
    disp(R);
    
    [Cordic_Q , Cordic_R] = cordicqr(data(:, :, k));
    [Real_Q, Real_R] = qr(data(:, :, k));
end

