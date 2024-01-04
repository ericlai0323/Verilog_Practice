function [x_out, y_out, angle] = vectoring_mode_cordic(x_value, y_value, iteration)

angle = 0;
factor = 1;
for ii = 1: iteration
    t = 2^-(ii-1);
    factor_temp = (1/sqrt(1+(t^2)));
    factor = factor * factor_temp;
    disp(factor);
end

for ii = 1: iteration
    sign_value = -sign(y_value*x_value);
    t = 2^-(ii-1);
    x1 = x_value - sign_value * y_value * t;
    y1 = y_value + sign_value * x_value * t;
    angle = angle - sign_value * atand(t);
    x_value = x1;
    y_value = y1;
end

x_out = x_value * factor;
y_out = y_value * factor;