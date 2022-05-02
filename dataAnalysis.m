% BME 3090, Module 10
% Sabrina Alessi, sfa2xs@virginia.edu
% Meddie Corona, mjc3zj@virginia.edu
% Cheney Knight, cwk7ves@virginia.edu
% Roman Ramirez, rr8rk@virginia.edu
% Daniel Song, djs2jr@virginia.edu
% dataAnalysis.m

% This code was used to generate much of the analysis from the
% oscilloscope-compiled data.

%% IMPORTING THE DATA

clear
addpath('helpers/');

% file paths
c_roman  = "data/control/romantest" + [1:7] + "c";
c_maddie = "data/control/maddietest" + [1:4] + "c";
c_daniel = "data/control/danieltest" + [1:4] + "c";
s_roman  = "data/caffeine/romantest" + [1:5] + "s";
s_maddie = "data/caffeine/maddietest" + [1:5] + "s";
s_daniel = "data/caffeine/danieltest" + [1:6] + "s";

% used for struct
abv_c_roman  = "r" + [1:7] + "c";
abv_c_maddie = "m" + [1:4] + "c";
abv_c_daniel = "d" + [1:4] + "c";
abv_s_roman  = "r" + [1:5] + "s";
abv_s_maddie = "m" + [1:5] + "s";
abv_s_daniel = "d" + [1:6] + "s";

% aggregating all of the filenames and the structpaths into vectors
FILENAMES = [c_roman c_maddie c_daniel s_roman s_maddie s_daniel];
STRUCTPATHS = [abv_c_roman abv_c_maddie abv_c_daniel abv_s_roman abv_s_maddie abv_s_daniel];

% this is the data variable used to store all data for each trial!
data = struct;

% for every trial
for i=1:length(STRUCTPATHS)
    % create a new structure for each trial
    data.(STRUCTPATHS(i)) = struct;

    % add a field that specifies non-caffeinated/caffeinated
    nametemp = char(STRUCTPATHS(i));
    if (nametemp(end) == 's')
        data.(STRUCTPATHS(i)).caffeine = "s";
    elseif (nametemp(end) == 'c')
        data.(STRUCTPATHS(i)).caffeine = "c";
    end

end

clearvars -except FILENAMES STRUCTPATHS data

%% ADDING EYES METADATA

OPEN = "open";
CLOSE = "closed";

data.r1c.eyes = OPEN;
data.r2c.eyes = OPEN;
data.r3c.eyes = CLOSE;
data.r4c.eyes = CLOSE;
data.r5c.eyes = OPEN;
data.r6c.eyes = OPEN;
data.r7c.eyes = CLOSE;

data.m1c.eyes = OPEN;
data.m2c.eyes = OPEN;
data.m3c.eyes = CLOSE;
data.m4c.eyes = CLOSE;

data.d1c.eyes = OPEN;
data.d2c.eyes = OPEN;
data.d3c.eyes = CLOSE;
data.d4c.eyes = CLOSE;

data.r1s.eyes = OPEN;
data.r2s.eyes = OPEN;
data.r3s.eyes = CLOSE;
data.r4s.eyes = CLOSE;
data.r5s.eyes = CLOSE;
 
data.m1s.eyes = OPEN;
data.m2s.eyes = OPEN;
data.m3s.eyes = CLOSE;
data.m4s.eyes = CLOSE;
data.m5s.eyes = CLOSE;

data.d1s.eyes = OPEN;
data.d2s.eyes = OPEN;
data.d3s.eyes = CLOSE;
data.d4s.eyes = CLOSE;
data.d5s.eyes = CLOSE;
data.d6s.eyes = CLOSE;

clearvars -except FILENAMES STRUCTPATHS data

%% IMPORTING DATA, DATA ANALYSIS

% the upper and lower bounds for wavelengths
ALPHA_LOWER = 8;
ALPHA_UPPER = 13;
BETA_LOWER = 13;
BETA_UPPER = 30;

% initialization
abTable       = table;
testname      = strings(size(STRUCTPATHS));
alpha_aoc     = zeros(size(STRUCTPATHS));
beta_aoc      = zeros(size(STRUCTPATHS));
caffeine_list = strings(size(STRUCTPATHS));
eyes_list     = strings(size(STRUCTPATHS));

% collecting/creating data from each 
for i=1:length(FILENAMES)

    % importing temporal data
    raw = readtable(FILENAMES(i));
    data.(STRUCTPATHS(i)).t = raw{1:end,4} - raw{1,4};
    data.(STRUCTPATHS(i)).y = raw{1:end,5};
    data.(STRUCTPATHS(i)).sampleInterval = raw{2, 2};

    % creating spectral data
    [freq, Y] = createFFTFigure(FILENAMES(i), false);
    data.(STRUCTPATHS(i)).freq = freq;
    data.(STRUCTPATHS(i)).Y = Y;

    % creating filters
    data.(STRUCTPATHS(i)).totalFilter = fir1(500, [ALPHA_LOWER, BETA_UPPER] / 50);
    data.(STRUCTPATHS(i)).alphaFilter = fir1(500, [ALPHA_LOWER, ALPHA_UPPER] / 50);
    data.(STRUCTPATHS(i)).betaFilter  = fir1(500, [BETA_LOWER BETA_UPPER] / 50);

    % applying filters
    data.(STRUCTPATHS(i)).y_total_filtered = filter(data.(STRUCTPATHS(i)).totalFilter, 1, data.(STRUCTPATHS(i)).y);
    data.(STRUCTPATHS(i)).y_alpha_filtered = filter(data.(STRUCTPATHS(i)).alphaFilter, 1, data.(STRUCTPATHS(i)).y);
    data.(STRUCTPATHS(i)).y_beta_filtered  = filter(data.(STRUCTPATHS(i)).betaFilter, 1, data.(STRUCTPATHS(i)).y);

    % creating spectral filtered data
    data.(STRUCTPATHS(i)).Y_total_filtered = abs(fftshift(fft(data.(STRUCTPATHS(i)).y_total_filtered)));
    data.(STRUCTPATHS(i)).Y_alpha_filtered = abs(fftshift(fft(data.(STRUCTPATHS(i)).y_alpha_filtered)));
    data.(STRUCTPATHS(i)).Y_beta_filtered  = abs(fftshift(fft(data.(STRUCTPATHS(i)).y_beta_filtered)));

    % determining total wave presence
    Y = data.(STRUCTPATHS(i)).Y_total_filtered;

    % determining alpha wave presence
    freq_alpha = freq((ALPHA_LOWER < freq) & (freq < ALPHA_UPPER));
    Y_alpha = Y((ALPHA_LOWER < freq) & (freq < ALPHA_UPPER));
    aoc_alpha = trapz(freq_alpha, Y_alpha);
    
    % determining beta wave prescence
    freq_beta = freq((BETA_LOWER < freq) & (freq < BETA_UPPER));
    Y_beta = Y((BETA_LOWER < freq) & (freq < BETA_UPPER));
    aoc_beta = trapz(freq_beta, Y_beta);

    % adds data with everything but alpha waves filtered
    % UNUSED
    data.(STRUCTPATHS(i)).freq_alpha = freq_alpha;
    data.(STRUCTPATHS(i)).Y_total_filtered_alpha = Y_alpha;
    data.(STRUCTPATHS(i)).aoc_total_filtered_alpha = aoc_alpha;

    % adds data with everything but beta waves filtered
    % UNUSED
    data.(STRUCTPATHS(i)).freq_beta = freq_beta;
    data.(STRUCTPATHS(i)).Y_total_filtered_beta = Y_beta;
    data.(STRUCTPATHS(i)).aoc_total_filtered_beta = aoc_beta;

    % adding iterative, calculated data to the vectors used for the table
    testname(i)      = STRUCTPATHS(i);
    alpha_aoc(i)     = aoc_alpha;
    beta_aoc(i)      = aoc_beta;
    caffeine_list(i) = data.(STRUCTPATHS(i)).caffeine;
    eyes_list(i)     = data.(STRUCTPATHS(i)).eyes;

end

% creating data for the table
abTable.testname  = testname';
abTable.caffeinated = caffeine_list';
abTable.eyes = eyes_list';
abTable.alpha_aoc = alpha_aoc';
abTable.beta_aoc  = beta_aoc';

% displaying the talbe
disp(abTable);

% writing the beta-alpha table to an .xlsx spreadsheet in 'data' folder
% writetable(abTable, 'data/aocTable.xlsx');

% further analysis from this table is done in data/aocTable.xlsx

clearvars alpha_aoc aoc_alpha beta_aoc aoc_beta caffeine_list eyes_list
clearvars freq freq_alpha freq_beta i raw testname Y Y_alpha Y_beta

%% PLOTTING FILTERING PROCESS

% Roman, Trial 4, Non-Caffeinated will be used as the example filtering process
mydata = data.r4c;

% creating the figure
filteringProcessFigure = figure; 

% unfiltered temporal data
subplot(4, 1, 1);
plot(mydata.t, mydata.y);
title("Example Trial Temporal Data");
xlabel("Time [s]");
ylabel("Voltage [V]");
set(gca, 'fontname', 'Times New Roman')

% unfiltered spectral data
subplot(4, 1, 2);
plot(mydata.freq, mydata.Y);
title("Example Trial Spectral Data");
xlabel("Frequency [Hz]");
ylabel("Amplitude [V / Hz]");
set(gca, 'fontname', 'Times New Roman')

% filtered spectral data
subplot(4, 1, 3);
plot(mydata.freq, mydata.Y_total_filtered);
title("Example Trial Filtered Spectral Data");
xlabel("Frequency [Hz]");
ylabel("Amplitude [V / Hz]");
set(gca, 'fontname', 'Times New Roman')

% filtered temporal data
subplot(4, 1, 4);
plot(mydata.t, mydata.y_total_filtered);
title("Example Trial Filtered Temporal Data");
xlabel("Time [s]");
ylabel("Voltage [V]");
set(gca, 'fontname', 'Times New Roman')

sgtitle("Example of Digital Filtering Process", 'fontname', 'Times New Roman');
% saving the figure to the 'figures' folder
saveas(filteringProcessFigure, 'figures/filteringProcessFigure', 'png');

clearvars n mydata

%% CREATING EXAMPLE INTEGRATION FIGURE

exampleAOCFigure = figure;

% Roman, Trial 4, Non-Caffeinated will be used as the example
myplotter = data.r4c;
hold on

% plotting the filtered spectral data
plot(myplotter.freq(myplotter.freq > 0), myplotter.Y_total_filtered(myplotter.freq > 0), 'Color', 'black');
% plotting the area between the alpha bandwidth
area(myplotter.freq((myplotter.freq > ALPHA_LOWER) & (myplotter.freq < ALPHA_UPPER)), ...
    myplotter.Y_total_filtered((myplotter.freq > ALPHA_LOWER) & (myplotter.freq < ALPHA_UPPER)), 'FaceColor', '#A2142F');
% plotting the area between the beta bandwidth
area(myplotter.freq((myplotter.freq > BETA_LOWER) & (myplotter.freq < BETA_UPPER)), ...
    myplotter.Y_total_filtered((myplotter.freq > BETA_LOWER) & (myplotter.freq < BETA_UPPER)), 'FaceColor', '#4DBEEE');
title('Example One-Sided Spectral Data');
xlabel('Frequency [Hz]');
ylabel('Amplitude [V / Hz]');

legend(["Filtered Spectral Data", "Total Alpha Waves", "Total Beta Waves"]);
set(gca, 'FontName', 'Times New Roman');

grid on
hold off

% saving the figure to the 'figures' folder
saveas(exampleAOCFigure, 'figures/exampleAOCFigure', 'png');


