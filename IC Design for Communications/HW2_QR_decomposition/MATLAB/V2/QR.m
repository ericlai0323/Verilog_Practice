clc;
clear all;

% Specify the matrix size
matrix_size = 4;

data_in = [
    4 3 1 2 ;
    3 4 1 2 ;
    3 4 2 1 ;
    3 2 4 1 ;
];

data_in = data_in * 2^8;

[data_out(:,1), di_out(:,:,1)] = testGG(data_in(:,1), matrix_size);
for col = 2:matrix_size
    [data_temp(1:matrix_size,col-1,1), data_out(matrix_size+1,col)] = testGR(data_in(:,col), di_out(:,:,1), matrix_size);
end

for row = matrix_size:-1:2
    [data_out(1:row-1,matrix_size-row+2), di_out(1:row-2,:,matrix_size-row+2)] = testGG(data_temp(:,1,matrix_size-row+1), row-1);
    for col = matrix_size-row+2:matrix_size-1
        [data_temp(1:row-1,col-matrix_size+row-1,col-matrix_size+1), data_out(row,col)] = testGR(data_temp(:,col-matrix_size+row-1,col-matrix_size), di_out(:,:,col-matrix_size+1), row-1);
    end
end

% Flip the output matrix
data_out = flipud(data_out);