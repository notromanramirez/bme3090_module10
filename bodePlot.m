% BME 3090, Module 10
% Sabrina Alessi, sfa2xs@virginia.edu
% Meddie Corona, mjc3zj@virginia.edu
% Cheney Knight, cwk7ves@virginia.edu
% Roman Ramirez, rr8rk@virginia.edu
% Daniel Song, djs2jr@virginia.edu
% bodePlot.m

%% experimental calculations of our band-pass filter

% importing the data
raw = readtable('data/module10data.xlsx');

%% cleaning
% reading the data
stage34 = raw(45:63, 1:5);
% calculating the output amplitude in decibels
stage34.OutputAmplitude_dB_ = 20 .* log10(stage34.OutputAmplitude_V_);
% calculating the gain for each frequency
stage34.Gain = stage34.OutputAmplitude_V_ ./ stage34.InputAmplitude_V_;

%% plotting

% plotting the values to the Bode Plot
upper = log10(40.9); %[dec]
lower = log10(7.23); %[dec]

% creating the asymptotes for our Bode Plot
tspan = linspace(0, 2.5, 1000); 
yspan = zeros(size(tspan));
yspan(tspan > upper) = -20 .* (tspan(tspan > upper) - upper);
yspan(tspan < lower) = 20 .* (tspan(tspan < lower) - lower);

% saving the figure to experimentalBodePlot
experimentalBodePlot = figure;
hold on

% experimental frequency-sweep values, log-log scaled
scatter(stage34.InputFrequency_dec_, stage34.OutputAmplitude_dB_);
% theoretical Bode Plot aasymptotes of our EEG
plot(tspan, yspan);
title('Stage 3 and 4 Amplitude Response');
xlabel('Input Frequency [dec]');
ylabel('Output Amplitude [dB]');

legend(["Experimental Values", "Theoretical Asymptotes"], 'location', 'south');

grid on 
hold off
set(gca, 'FontName', 'Times New Roman');
% saving the figure to the 'figures' folder
saveas(experimentalBodePlot, 'figures/experimentalBodePlot', 'png');
