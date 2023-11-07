function [output] = local_oscillator(filtered_ik, filtered_qk, frequency, sampling_rate)

filtered_ik_data = filtered_ik(1,:);
filtered_qk_data = filtered_qk(1,:);

% Calculate the time vector
t = 0:1/sampling_rate:(length(filtered_ik_data)-1)/sampling_rate;

% Generate the local oscillator signals
cos_signal = cos(2*pi*frequency*t);
sin_signal = sin(2*pi*frequency*t);

% Multiply the filtered signals by the local oscillator signals
output_i = filtered_ik_data .* cos_signal;
output_q = filtered_qk_data .* -sin_signal;

% Combine the I and Q components into a complex signal
output = output_i + output_q;

end
