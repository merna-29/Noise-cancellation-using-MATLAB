% Noise cancellation example in MATLAB

% Import the sound file with noise
[y, fs] = audioread('noisy_sound.mp3');

% Create a reference noise signal
reference_noise = randn(size(y));

% Set up parameters for the adaptive filter
filter_order = 64;
mu = 0.01;

% Apply the LMS adaptive filter for noise cancellation
[y_clean, ~] = adaptive_filter(y, reference_noise, filter_order, mu);

% Plot the original, noisy, and cleaned signals
t = (0:length(y)-1)/fs;

figure;
subplot(3,1,1);
plot(t, y);
title('Original Signal');

subplot(3,1,2);
plot(t, y + 0.5 * reference_noise); % Adding reference noise for visualization
title('Noisy Signal');

subplot(3,1,3);
plot(t, y_clean);
title('Cleaned Signal');

% Play the original, noisy, and cleaned signals
sound(y, fs);
pause(length(y)/fs + 1);

sound(y + 0.5 * reference_noise, fs);
pause(length(y)/fs + 1);

sound(y_clean, fs);

% Function for LMS adaptive filtering
function [output, error] = adaptive_filter(input, reference, order, mu)
    % LMS adaptive filter implementation
    
    input_length = length(input);
    
    % Initialize filter coefficients
    weights = zeros(order, 1);
    
    % Initialize output and error signals
    output = zeros(input_length, 1);
    error = zeros(input_length, 1);
    
    % Apply adaptive filtering
    for i = order+1:input_length
        x = input(i:-1:i-order+1);
        y_hat = weights' * x;
        error(i) = reference(i) - y_hat;
        weights = weights + mu * error(i) * x;
        output(i) = y_hat;
    end
end