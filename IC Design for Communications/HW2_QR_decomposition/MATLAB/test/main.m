% 讀取 CSI.txt 文件
fileID = fopen('CSI.txt', 'r');
data = fscanf(fileID, '%e');
fclose(fileID);

% 將數據整形成 4*4*1000 的三維矩陣
data = reshape(data, [4, 4, 1000]);

disp(data(:,:,1) );

% 初始化輸出數據
result_rt = zeros(1000, 1);
result_vt = zeros(1001, 1);

% 循環處理每個4*4矩陣
for k = 1:1000
    % 調用 rt 函數
    [data_out_rt, ~] = rt(data(:, :, k), di_in, index);
    
    % 調用 vt 函數
    [data_out_vt, ~] = vt(data(:, :, k), index);
    
    % 將結果保存到結果數組中
    result_rt(k) = data_out_rt(index);
    result_vt(k) = data_out_vt(index + 1);
end

% 將結果保存到文件
writematrix(result_rt, 'result_rt.txt');
writematrix(result_vt, 'result_vt.txt');
