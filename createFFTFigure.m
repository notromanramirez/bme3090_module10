% BME 3090, Module 10
% Sabrina Alessi, sfa2xs@virginia.edu
% Meddie Corona, mjc3zj@virginia.edu
% Cheney Knight, cwk7ves@virginia.edu
% Roman Ramirez, rr8rk@virginia.edu
% Daniel Song, djs2jr@virginia.edu
% createFFTFigure.m

% INPUT: temporal signal
% OUTPUT: frequency and spectral Y vectors

% to display the figure, pass in 'true' to the parameter: output
function [freq, Y] = createFFTFigure(FILEPATH, output)

% creating char vector for the figure title
FILETITLE = FILEPATH;
FILETITLE(FILETITLE == '_') = '-';
% creating char vector used for saving to a directory
SAVETITLE = FILETITLE(1:end-4);
SAVETITLE(SAVETITLE == '/') = '-';

% reading in the data
raw = readtable(FILEPATH);
t_data = raw{1:end,4} - raw{1,4};
y_data = raw{1:end,5};
% sampleInterval = raw{2, 2}; % unused

% calculating the frequency vector
L = length(y_data); % [samples]
T = t_data(2) - t_data(1); % [s]
Fs = 1/T; % [samples/s]
df = Fs/L;
half_res = df/2;
freq = -Fs/2+half_res:df:Fs/2-half_res;

% creating the Fourier-transform of the data
Y = abs(fftshift(fft(y_data)));

% create the figure only if output is true!
if output
    
    fftFigure = figure;
    hold on
    plot(freq, Y);
    title(['FFT of ' FILETITLE]);
    xlabel('Frequency [Hz]');
    ylabel('Amplitude');
    
    grid on
    hold off
    
    set(gca, 'fontname', 'Calibri');
    % saving the figure to the 'figures' folder
    saveas(fftFigure, ['figures/fftFigure_' SAVETITLE], 'png');
    
end

end
