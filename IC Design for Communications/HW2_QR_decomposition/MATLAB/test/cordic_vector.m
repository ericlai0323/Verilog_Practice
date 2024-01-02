function [x, y, z] = cordic_vector(x, y, z, sigma, angle)
    x_new = x - sigma * y * 2^(-angle);
    y = sigma * x * 2^(-angle);
    z = z - sigma * angle;
    x = x_new;
end