function [ x_out,y_out ] = rotating_mode_cordic(x_value,y_value,iteration,angle)
factor = 1;

for ii=1:iteration
    t = 2^-(ii-1) ;
    factor_temp = (1/sqrt(1+(t^2)));
    factor = factor * factor_temp;
end

if angle~=0
    for ii=1:iteration
        t = 2^-(ii-1);
        sign_value = sign (angle);
        x1 = x_value - sign_value * y_value * t;
        y1 = y_value + sign_value * x_value * t;
        x_value = x1;
        y_value = y1;
        angle = angle - sign_value * atand(t);
    end
end
x_out = x_value * factor;
y_out = y_value * factor;