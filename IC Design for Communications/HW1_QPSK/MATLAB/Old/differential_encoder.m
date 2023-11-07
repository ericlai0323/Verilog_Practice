function [output_eik, output_eqk] = differential_encoder(input_ik, input_qk)
% 
output_eik = zeros(size(input_ik));
output_eqk = zeros(size(input_ik));
output_eik_prev = 0;
output_eqk_prev = 0;

% 
for i = 1:length(input_ik)
    % 
    output_eik(i) = and(not(xor(input_ik(i), input_qk(i))), xor(input_ik(i), output_eik_prev)) + and(xor(input_ik(i), input_qk(i)), xor(input_qk(i), output_eqk_prev));
    output_eqk(i) = and(not(xor(input_ik(i), input_qk(i))), xor(input_qk(i), output_eqk_prev)) + and(xor(input_ik(i), input_qk(i)), xor(input_ik(i), output_eik_prev));
    
    % 
    output_eik_prev = output_eik(i);
    output_eqk_prev = output_eqk(i);
end
    