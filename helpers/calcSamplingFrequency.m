% BME 3090, Module 10
% Sabrina Alessi
% Maddie Corona
% Cheney Knight
% Roman Ramirez
% Daniel Song

% INPUT
    % time signal        [V]
    % time per division  [s/div]
% OUTPUT
    % sampling frequency [samples/s]

function [sf] = calcSamplingFrequency(timeSignal, timePerDivision)
    n_samples = length(timeSignal);
    n_divisions = 10; % comes from the oscilloscope
    sf = n_samples ./ (n_divisions .* timePerDivision);

end