clc;  %clear command window
clear all;  %clear our workspace
close all;  %closes all other workable windows

% Read input data from a CSV file
input_data = readtable('input_data.csv');

% Extract binary data from the first column of the table
binary_data = input_data{:, 1}';

% Serial-to-Parallel
[ik, qk] = serial_to_parallel(binary_data);

% Differential Encoding
[diff_ik, diff_qk] = differential_encoder(ik, qk);

% Up-sampling
upsampled_data_ik = upsampling(diff_ik, 7);
upsampled_data_qk = upsampling(diff_qk, 7);

% Pulse Shaping Filter (You may need to adjust the parameters)
intp_num = 4; % Resolution points between symbols
symbol_interval = 1; % Span of the Nyquist filter
rolloff = 0.5; % Rolloff factor
srrcc = srrcf(intp_num, symbol_interval, rolloff);

% Convolution with Square Root Raised Cosine Filter
filtered_ik = conv(upsampled_data_ik, srrcc, 'same');
filtered_qk = conv(upsampled_data_qk, srrcc, 'same');

% Apply the Local Oscillator
frequency = 1e6; % 1 MHz
sampling_rate = 1e7; % Adjust according to your requirements
modulated_signal = local_oscillator(filtered_ik, filtered_qk, frequency, sampling_rate);

disp(size(filtered_ik)); % Display the size of filtered_ik
disp(size(filtered_qk)); % Display the size of filtered_qk
disp(frequency); % Display the value of frequency
disp(sampling_rate); % Display the value of sampling_rate


% Plot the modulated signal
plot(modulated_signal);
title('Differential QPSK Modulated Signal');
xlabel('Sample Index');
ylabel('Amplitude');

