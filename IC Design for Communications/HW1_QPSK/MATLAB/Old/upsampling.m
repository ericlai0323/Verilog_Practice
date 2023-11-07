function output = upsampling(input_data, insert_zero_amount)
    % 获取输入数据的长度
    len = length(input_data);
    
    % 初始化输出数据
    output = zeros(1, len + (len - 1) * insert_zero_amount);
    
    % 将输入数据复制到输出数据，并插入零
    output(1:(insert_zero_amount+1):end) = input_data;
end
