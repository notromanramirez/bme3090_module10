% BME 3090, Module 10
% Sabrina Alessi
% Maddie Corona
% Cheney Knight
% Roman Ramirez
% Daniel Song

% INPUT
    % sampling frequency [samples/s]
% OUTPUT
    % Nyquist frequency [1/s]

function [nf] = calcNyquistFrequency(samplingFrequency)
    nf = 0.5 * samplingFrequency;
end