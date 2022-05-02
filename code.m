% BME 3090, Module 10
% Sabrina Alessi
% Maddie Corona
% Cheney Knight
% Roman Ramirez
% Daniel Song

% INPUT: temporal signal
% OUTPUT: 

clear
raw = readtable('data/testingEEG2.csv');
t_data = raw{:,4} - raw{1,4};
y_data = raw{:,5};
sampleInterval = raw{2, 2};

%%

alphaBW = [8 13]; % Hz
betaBW = [13 30]; % Hz

L = length(y_data); % [samples]
T = t_data(2) - t_data(1); % [s]
Fs = 1/T; % [samples/s]
f = Fs * (0:L-1) / L;
f = f - f(end/2);
Y = abs(fftshift(fft(y_data)));

min_window = -50;
max_window = 50;


f = f((f > min_window) & (f < max_window));
Y = Y((f > min_window) & (f < max_window));

plot(f, Y);



%%
% fs = calcSamplingFrequency(t_data, sampleInterval);
% fs = 1./(t(2) - t(1));
% fs = length(t_data);                  % sampling frequency [1/s]
t = 0:(1/fs):(10-1/fs); % time vector
n = length(y_data);
f = (0:n-1)*(fs/n);     % frequency range

plot(f, spectralSignal);


