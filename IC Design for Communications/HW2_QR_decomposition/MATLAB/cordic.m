% 向量模式
x_value_vector = 1;
y_value_vector = 1;
iteration_vector = 10;

x_vector = zeros(1, iteration_vector + 1);
y_vector = zeros(1, iteration_vector + 1);

[x_out_vector, y_out_vector, angle_vector] = vectoring_mode(x_value_vector, y_value_vector, iteration_vector);

x_vector(1) = x_value_vector;
y_vector(1) = y_value_vector;

for ii = 1:iteration_vector
    t = 2^(-ii);
    sign_value = -sign(y_vector(ii) * x_vector(ii));
    x1 = x_vector(ii) - sign_value * y_vector(ii) * t;
    y1 = y_vector(ii) - sign_value * x_vector(ii) * t;
    x_vector(ii + 1) = x1;
    y_vector(ii + 1) = y1;
end

% 顯示結果
disp('Vectoring Mode:');
disp(['Input: x = ', num2str(x_value_vector), ', y = ', num2str(y_value_vector)]);
disp(['Output: x = ', num2str(x_out_vector), ', y = ', num2str(y_out_vector)]);
disp(['Final Angle: ', num2str(angle_vector)]);

% 繪製向量模式的軌跡
figure;
plot(x_vector, y_vector, '-o');
title('Vectoring Mode Trajectory');
xlabel('x');
ylabel('y');
grid on;

% 旋轉模式
x_value_rotating = 1;
y_value_rotating = 1;
iteration_rotating = 10;
angle_rotating = 45; % 設定旋轉角度

x_rotating = zeros(1, iteration_rotating + 1);
y_rotating = zeros(1, iteration_rotating + 1);

[x_out_rotating, y_out_rotating] = rotating_mode(x_value_rotating, y_value_rotating, iteration_rotating, angle_rotating);

x_rotating(1) = x_value_rotating;
y_rotating(1) = y_value_rotating;

for ii = 1:iteration_rotating
    t = 2^(-ii);
    sign_value = sign(angle_rotating);
    x1 = x_rotating(ii) - sign_value * y_rotating(ii) * t;
    y1 = y_rotating(ii) + sign_value * x_rotating(ii) * t;
    x_rotating(ii + 1) = x1;
    y_rotating(ii + 1) = y1;
    angle_rotating = angle_rotating - sign_value * atand(t);
end

% 顯示結果
disp('Rotating Mode:');
disp(['Input: x = ', num2str(x_value_rotating), ', y = ', num2str(y_value_rotating)]);
disp(['Output: x = ', num2str(x_out_rotating), ', y = ', num2str(y_out_rotating)]);

% 繪製旋轉模式的軌跡
figure;
plot(x_rotating, y_rotating, '-o');
title('Rotating Mode Trajectory');
xlabel('x');
ylabel('y');
grid on;
