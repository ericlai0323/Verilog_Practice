function [data_out, di_out] = vt(data_in, index)

    shift = 50; % 调整为足够大的值，以容纳 +1.000000000000000 到 -1.000000000000000 的范围
    data_in_reg = int64(data_in) * (2^shift);
    k = 2^8;    % 调整为适当的值
    
    x_reg(1, 1) = data_in_reg(2, 1);
    y_reg(1, 1) = data_in_reg(1, 1);
    
    for i = 1:index
        if i > 1
            x_reg(i, 1) = data_in_reg(i + 1, 1);
            y_reg(i, 1) = x_reg(i - 1, 13);
        end
        for j = 1:12
            if (x_reg(i, j) > 0 && y_reg(i, j) > 0) || (x_reg(i, j) < 0 && y_reg(i, j) < 0)
                di_out(i, j) = -1;
            else
                di_out(i, j) = 1;
            end
            temp(i, j) = (2^-(j - 1));
            x_reg(i, j + 1) = x_reg(i, j) - (y_reg(i, j) * temp(i, j) * di_out(i, j));
            y_reg(i, j + 1) = y_reg(i, j) + (x_reg(i, j) * temp(i, j) * di_out(i, j));
        end
        x_reg(i, 13) = x_reg(i, 13) * k / (2^8);
        y_reg(i, 13) = y_reg(i, 13) * k / (2^8);
    end
    
    x_reg_shift = x_reg / (2^shift);
    y_reg_shift = y_reg / (2^shift);
    
    data_out(1:index) = y_reg_shift(1:index, 13);
    data_out(index + 1) = x_reg_shift(index, 13);
    
    end
    