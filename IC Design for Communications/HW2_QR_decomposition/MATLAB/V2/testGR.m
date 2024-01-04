function [data_out, data_out_1] = testGR(data_in, di_in, index) 
    shift = 4;
    data_in_reg = int64(data_in) * (2^shift);
    k = 155;

    x_reg = zeros(index, 13);
    y_reg = zeros(index, 13);

    x_reg(1,1) = data_in_reg(2,1);
    y_reg(1,1) = data_in_reg(1,1);

    for i = 1 : index
        if  i > 1
            x_reg(i,1) = data_in_reg(i+1,1);
            y_reg(i,1) = x_reg(i-1,13);
        end
        for j = 1 : 12
            temp(i,j) = (2 ^ -(j-1));
            x_reg(i,j+1) = x_reg(i,j) - (y_reg(i,j) * temp(i,j) * di_in(i,j));
            y_reg(i,j+1) = y_reg(i,j) + (x_reg(i,j) * temp(i,j) * di_in(i,j));
        end
        x_reg(i,13) = x_reg(i,13) * k / (2^8);
        y_reg(i,13) = y_reg(i,13) * k / (2^8);
    end

    x_reg_shift = x_reg / (2^shift);
    y_reg_shift = y_reg / (2^shift);

    data_out(1:index) = y_reg_shift(1:index,13);
    data_out_1 = x_reg_shift(index,13);
end