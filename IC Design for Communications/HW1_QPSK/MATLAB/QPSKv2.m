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

s2p_ik(1) = 0;
s2p_qk(1) = 0;
% Iterate through the binary data
for i = 2:(length(binary_data)+1)
    % Append the binary digit to s2p_ik or s2p_qk based on its position
    binary_digit = binary_data(i-1);
    if mod(i, 2) == 1
        s2p_ik = [s2p_ik binary_digit];
    else
        s2p_qk = [s2p_qk binary_digit];
    end
end

%% Differential Encoder
% Initialize diff_output_eik and diff_output_eqk as zero arrays
diff_output_eik = zeros(1, length(s2p_ik) + 1);
diff_output_eqk = zeros(1, length(s2p_qk) + 1);

% diff_output_quadrant = zeros(size(s2p_ik)+1);

% disp(['Length of diff_output_eik: ' num2str(length(diff_output_eik))]);
% disp(['Length of diff_output_eqk: ' num2str(length(diff_output_eqk))]);


% Iterate through s2p_ik and s2p_qk to perform differential encoding
for i = 1:(length(s2p_ik)-1)
    % Calculate differential encoding for s2p_ik and s2p_qk
    diff_output_eik(i+1) = and(not(xor(s2p_ik(i+1), s2p_qk(i+1))), xor(s2p_ik(i+1), diff_output_eik(i))) + and(xor(s2p_ik(i+1), s2p_qk(i+1)), xor(s2p_qk(i+1), diff_output_eqk(i)));
    diff_output_eqk(i+1) = and(not(xor(s2p_ik(i+1), s2p_qk(i+1))), xor(s2p_qk(i+1), diff_output_eqk(i))) + and(xor(s2p_ik(i+1), s2p_qk(i+1)), xor(s2p_ik(i+1), diff_output_eik(i)));
    
    % if diff_output_eik(i+1) == 0 && diff_output_eqk(i+1) == 0
    %     diff_output_quadrant(i+1) = 1;
    % elseif diff_output_eik(i+1) == 1 && diff_output_eqk(i+1) == 0
    %     diff_output_quadrant(i+1) = 2;
    % elseif diff_output_eik(i+1) == 0 && diff_output_eqk(i+1) == 1
    %     diff_output_quadrant(i+1) = 3;
    % elseif diff_output_eik(i+1) == 1 && diff_output_eqk(i+1) == 1
    %     diff_output_quadrant(i+1) = 4;
    % end
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
symbol_interval = 4 % Span of the Nyquist filter
rolloff = 0.5; % Rolloff factor
srrcc = srrcf(intp_num, symbol_interval, rolloff);

% srrcc_data_i = srrcf(output_upsampling_eik, symbol_interval, rolloff);
% srrcc_data_q = srrcf(output_upsampling_eqk, symbol_interval, rolloff);
disp(srrcc);

srrcc_data_i = conv(srrcc, output_upsampling_eik);
srrcc_data_q = conv(srrcc, output_upsampling_eqk);

%% Local Oscillator
frequency = 1e6; % 1 MHz
sampling_rate = 1e7; % Adjust according to your requirements
filtered_ik_data = srrcc_data_i(1,:);
filtered_qk_data = srrcc_data_q(1,:);

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


%% Plot Figure
% Create a figure
figure;

% Plot binary_data
subplot(3, 1, 1);
plot(binary_data);
title('Binary Data');
xlabel('Sample Index');
ylabel('Value');

% Plot s2p_ik
subplot(3, 1, 2);
plot(s2p_ik,'g');
title('s2p ik');
xlabel('Sample Index');
ylabel('Value');

% Plot s2p_qk
subplot(3, 1, 3);
plot(s2p_qk,'b');
title('s2p qk');
xlabel('Sample Index');
ylabel('Value');

% Create a figure
figure;

% Plot diff_output_eik
subplot(3, 1, 1);
plot(diff_output_eik);
title('Diff Output eik');
xlabel('Sample Index');
ylabel('Value');

% Plot diff_output_eqk
subplot(3, 1, 2);
plot(diff_output_eqk);
title('Diff Output eqk');
xlabel('Sample Index');
ylabel('Value');

% subplot(3, 1, 3);
% plot(diff_output_quadrant);
% title('Diff Output Quadrant');
% xlabel('Sample Index');
% ylabel('Value');

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
% Plot Local Oscillator Output
subplot(1, 1, 1);
plot(output);
title('Local Oscillator Output');
xlabel('Sample Index');
ylabel('Value');

