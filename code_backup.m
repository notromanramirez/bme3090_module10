% BME 3090, Module 10
% Sabrina Alessi
% Maddie Corona
% Cheney Knight
% Roman Ramirez
% Daniel Song

% INPUT: temporal signal
% OUTPUT: 

clear
% raw = readtable('data/testingEEG2.csv');

FILENAME = 'test2_5s';
EXTENSION = '.csv';
FILEPATH = ['data/debug/' FILENAME EXTENSION];
FILETITLE = FILEPATH;
FILETITLE(FILETITLE == '_') = '-';

raw = readtable(FILEPATH);
t_data = raw{:,4} - raw{1,4};
y_data = raw{:,5};
sampleInterval = raw{2, 2};

alphaBW = [8 13]; % Hz
betaBW = [13 30]; % Hz

L = length(y_data); % [samples]
T = t_data(2) - t_data(1); % [s]
Fs = 1/T; % [samples/s]

% Fs = Fs / 100;

df = Fs/L;
half_res = df/2;
freq = -Fs/2+half_res:df:Fs/2-half_res;


Y = abs(fftshift(fft(y_data)));

fftFigure = figure;
hold on
plot(freq, Y);
title(['FFT of ' FILETITLE]);
xlabel('Frequency [Hz]');
ylabel('Amplitude');

grid on
hold off

saveas(fftFigure, ['figures/fftFigure_' FILENAME], 'png');



