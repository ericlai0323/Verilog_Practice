function [Q, R] = cordic_qr_decomposition(A,iteration)
% Perform QR decomposition of a 4x4 matrix using Cordic algorithm.

% Initialize Q and R matrices
Q = eye(4);
R = A;

% Iterate through columns of R
% disp([R(1,1),R(4,1)]);

[R(1,1),R(4,1),angle] = vectoring_mode_cordic(R(1,1),R(4,1),iteration);
[R(1,2),R(4,2)] = rotating_mode_cordic(R(1,2),R(4,2),iteration,angle);
[R(1,3),R(4,3)] = rotating_mode_cordic(R(1,3),R(4,3),iteration,angle);
[R(1,4),R(4,4)] = rotating_mode_cordic(R(1,4),R(4,4),iteration,angle);

[R(1,1),R(3,1),angle] = vectoring_mode_cordic(R(1,1),R(3,1),iteration);
[R(1,2),R(3,2)] = rotating_mode_cordic(R(1,2),R(3,2),iteration,angle);
[R(1,3),R(3,3)] = rotating_mode_cordic(R(1,3),R(3,3),iteration,angle);
[R(1,4),R(3,4)] = rotating_mode_cordic(R(1,4),R(3,4),iteration,angle);

[R(1,1),R(2,1),angle] = vectoring_mode_cordic(R(1,1),R(2,1),iteration);
[R(1,2),R(2,2)] = rotating_mode_cordic(R(1,2),R(2,2),iteration,angle);
[R(1,3),R(2,3)] = rotating_mode_cordic(R(1,3),R(2,3),iteration,angle);
[R(1,4),R(2,4)] = rotating_mode_cordic(R(1,4),R(2,4),iteration,angle);

[R(1,2),R(4,2),angle] = vectoring_mode_cordic(R(1,2),R(4,2),iteration);
[R(1,3),R(4,3)] = rotating_mode_cordic(R(1,3),R(4,3),iteration,angle);
[R(1,4),R(4,4)] = rotating_mode_cordic(R(1,4),R(4,4),iteration,angle);

[R(1,2),R(3,2),angle] = vectoring_mode_cordic(R(1,2),R(3,2),iteration);
[R(1,3),R(3,3)] = rotating_mode_cordic(R(1,3),R(3,3),iteration,angle);
[R(1,4),R(3,4)] = rotating_mode_cordic(R(1,4),R(3,4),iteration,angle);

[R(1,3),R(4,3),angle] = vectoring_mode_cordic(R(1,3),R(4,3),iteration);
[R(1,4),R(4,4)] = rotating_mode_cordic(R(1,4),R(4,4),iteration,angle);


R = fix(R);

% for i = 1:4
%     for j = 1:4
