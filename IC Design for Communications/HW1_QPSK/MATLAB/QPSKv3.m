clc;  % Clear command window
clear all;  % Clear the workspace
close all;  % Close all other workable windows

% Read input data from a CSV file
input_data = readtable('input_data.csv');

% Extract binary data from the first column of the table
binary_data = input_data{:, 1}';

%% Serial to parallel
% Initialize s2p_ik and s2p_qk as empty arrays
s2p_ik = [];
s2p_qk = [];

% Iterate through the binary data
for i = 1:length(binary_data)
    % Append the binary digit to s2p_ik or s2p_qk based on its position
    binary_digit = binary_data(i);
    if mod(i, 2) == 1
        s2p_ik = [s2p_ik binary_digit];
    else
        s2p_qk = [s2p_qk binary_digit];
    end
end

%% Differential Encoder
% Initialize diff_output_eik and diff_output_eqk as zero arrays
diff_output_eik = zeros(1, length(s2p_ik));
diff_output_eqk = zeros(1, length(s2p_qk));

% Iterate through s2p_ik and s2p_qk to perform differential encoding
for i = 2:length(s2p_ik)
    % Calculate differential encoding for s2p_ik and s2p_qk
    diff_output_eik(i) = and(not(xor(s2p_ik(i), s2p_qk(i))), xor(s2p_ik(i), diff_output_eik(i-1))) + and(xor(s2p_ik(i), s2p_qk(i)), xor(s2p_qk(i), diff_output_eqk(i-1)));
    diff_output_eqk(i) = and(not(xor(s2p_ik(i), s2p_qk(i))), xor(s2p_qk(i), diff_output_eqk(i-1))) + and(xor(s2p_ik(i), s2p_qk(i)), xor(s2p_ik(i), diff_output_eik(i-1)));
end

% Remapping
for i = 1:length(diff_output_eik)
    if diff_output_eik(i) == 0 && diff_output_eqk(i) == 0
        diff_output_eik(i) = 1;
        diff_output_eqk(i) = 1;
    elseif diff_output_eik(i) == 1 && diff_output_eqk(i) == 0
        diff_output_eik(i) = -1;
        diff_output_eqk(i) = 1;
    elseif diff_output_eik(i) == 1 && diff_output_eqk(i) == 1
        diff_output_eik(i) = -1;
        diff_output_eqk(i) = -1;
    elseif diff_output_eik(i) == 0 && diff_output_eqk(i) == 1
        diff_output_eik(i) = 1;
        diff_output_eqk(i) = -1;
    end       
end

%% Upsampling eik
% Get the length of the diff_output_eik
len_diff_output_eik = length(diff_output_eik);

% Initialize the output data for upsampling eik
output_upsampling_eik = zeros(1, len_diff_output_eik + (len_diff_output_eik) * 7);

% Copy the input data to the output data and insert zeros
output_upsampling_eik(1:(7+1):end) = diff_output_eik;

%% Upsampling eqk
% Get the length of the diff_output_eqk
len_diff_output_eqk = length(diff_output_eqk);

% Initialize the output data for upsampling eqk
output_upsampling_eqk = zeros(1, len_diff_output_eqk + (len_diff_output_eqk) * 7);

% Copy the input data to the output data and insert zeros
output_upsampling_eqk(1:(7+1):end) = diff_output_eqk;

%% Pulse Shaping Filter
intp_num = 4; % Resolution points between symbols
symbol_interval = 4; % Span of the Nyquist filter
rolloff = 0.49; % Rolloff factor
srrcc = srrcf(intp_num, symbol_interval, rolloff);

cof = srrcc * 1000;
disp(cof);

srrcc_data_i = conv(srrcc, output_upsampling_eik);
srrcc_data_q = conv(srrcc, output_upsampling_eqk);

%% Local Oscillator
filtered_ik_data = srrcc_data_i(1,:);
filtered_qk_data = srrcc_data_q(1,:);

% Generate the local oscillator signals
cos_signal = cos(2*pi*filtered_ik_data(:)/8);
sin_signal = sin(2*pi*filtered_qk_data(:)/8);

% Multiply the filtered signals by the local oscillator signals
output_i = filtered_ik_data .* cos_signal;
output_q = filtered_qk_data .* -sin_signal;

output_i = output_i(1,:);
output_q = output_q(1,:);

% Combine the I and Q components into a complex signal
output = output_i + output_q;


%% Plot Figure
% % Create a figure
% figure;
% 
% % Plot binary_data
% subplot(3, 1, 1);
% plot(binary_data);
% title('Binary Data');
% xlabel('Sample Index');
% ylabel('Value');
% 
% % Plot s2p_ik
% subplot(3, 1, 2);
% plot(s2p_ik,'g');
% title('s2p ik');
% xlabel('Sample Index');
% ylabel('Value');
% 
% % Plot s2p_qk
% subplot(3, 1, 3);
% plot(s2p_qk,'b');
% title('s2p qk');
% xlabel('Sample Index');
% ylabel('Value');

% Create a figure
% figure;
% 
% % Plot diff_output_eik
% subplot(3, 1, 1);
% plot(diff_output_eik);
% title('Diff Output eik');
% xlabel('Sample Index');
% ylabel('Value');
% 
% % Plot diff_output_eqk
% subplot(3, 1, 2);
% plot(diff_output_eqk);
% title('Diff Output eqk');
% xlabel('Sample Index');
% ylabel('Value');
% 
% % subplot(3, 1, 3);
% % plot(diff_output_quadrant);
% % title('Diff Output Quadrant');
% % xlabel('Sample Index');
% % ylabel('Value');

% Create a figure
figure;
% Plot output_upsampling_eik
subplot(4, 1, 1);
plot(output_upsampling_eik);
title('Upsampled eik');
xlabel('Sample Index');
ylabel('Value');

% Plot output_upsampling_eqk
subplot(4, 1, 2);
plot(output_upsampling_eqk);
title('Upsampled eqk');
xlabel('Sample Index');
ylabel('Value');

% Plot srrcc_data_i
subplot(4, 1, 3);
plot(srrcc_data_i);
title('SRRCC Data (I)');
xlabel('Sample Index');
ylabel('Value');

% Plot srrcc_data_q
subplot(4, 1, 4);
plot(srrcc_data_q);
title('SRRCC Data (Q)');
xlabel('Sample Index');
ylabel('Value');

figure;
subplot(3, 1, 1);
plot(output_i);
title('Local Oscillator I');
xlabel('Sample Index');
ylabel('Value');
subplot(3, 1, 2);

plot(output_q);
title('Local Oscillator Q');
xlabel('Sample Index');
ylabel('Value');
% Plot Local Oscillator Output
subplot(3, 1, 3);
plot(output);
title('Local Oscillator Output');
xlabel('Sample Index');
ylabel('Value');

