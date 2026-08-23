% Define the time vector
fs = 50000; % Set the sampling frequency to 25 kHz
t = 0:1/fs:0.01; % Time vector from 0 to 1 second

% Get user input for sine wave frequency
sine_freq = 1000;

% Generate sine wave signal
sine_wave = sin(2*pi*sine_freq*t);

% Get user input for noisy signal frequency
noisy_freq = 15000;

% Generate noisy signal with random noise
noise = 0.1*randn(size(t));
noisy_signal = sine_wave + noise;

% Scale the signals to fit within the range of a 16-bit integer
scaled_sine_wave = int16(sine_wave * (2^15 - 1));
scaled_noisy_signal = int16(noisy_signal * (2^15 - 1));

% Convert the scaled signals to binary representation
binary_sine_wave = dec2bin(typecast(scaled_sine_wave, 'uint16'), 16);
binary_noisy_signal = dec2bin(typecast(scaled_noisy_signal, 'uint16'), 16);

% Save each 16-bit binary value on a separate line in the text file
fileID_sine = fopen('binary_sine_wave.txt', 'w');
for i = 1:size(binary_sine_wave, 1)
    fprintf(fileID_sine, '%s\n', binary_sine_wave(i, :));
end
fclose(fileID_sine);

fileID_noisy = fopen('binary_noisy_signal.txt', 'w');
for i = 1:size(binary_noisy_signal, 1)
    fprintf(fileID_noisy, '%s\n', binary_noisy_signal(i, :));
end
fclose(fileID_noisy);

% Plot the original signals in time domain
figure('Position', [100, 200, 1000, 600]);

subplot(2,1,1);
plot(t, sine_wave);
title(['Sine Wave with Frequency ', num2str(sine_freq), ' Hz']);
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, noisy_signal);
title(['Noisy Signal with Frequency ', num2str(noisy_freq), ' Hz']);
xlabel('Time (s)');
ylabel('Amplitude');
