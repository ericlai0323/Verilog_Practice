% 4x4矩陣
matrix = [1, 2, 3, 4; 5, 6, 7, 8; 9, 10, 11, 12; 13, 14, 15, 16];

% 對矩陣進行CORDIC旋轉（旋轉模式）
rotated_matrix_rotation = cordic_rotation(matrix, "rotation");

% 對矩陣進行CORDIC旋轉（向量模式）
rotated_matrix_vectoring = cordic_rotation(matrix, "vectoring");

% 顯示原始矩陣和旋轉後的矩陣（旋轉模式）
disp('Original Matrix:');
disp(matrix);
disp('Rotated Matrix using CORDIC (Rotation Mode):');
disp(rotated_matrix_rotation);

% 顯示原始矩陣和旋轉後的矩陣（向量模式）
disp('Rotated Matrix using CORDIC (Vectoring Mode):');
disp(rotated_matrix_vectoring);
