%% Lab 5 - MATLAB Version
% This script replicates the full functionality of the Python notebook for Lab 5
%
% Hi,All
%
% Here is the final lab with details given in lab5, in which the template 
% model is Quadratic chirp, and SNR=10，a1 = 10, a2=3, a3 = 3 are the true 
% parameters used in lab5 for illustration. 
%
% In the final lab,  the PSD and the true values of SNR,a1,a2,a3 are unknown 
% for you. We provide TrainningData for you to estimate the PSD numerically 
% via pwelch,  then you would take the estimated PSD to matched filtering, 
% searching the Quadratic chirp signal injected in analysisData by running PSO.  
% The bestfit SNR，a1, a2, a3 returned by PSO should be considsent with our 
% injected values  if you handle it in a correct way.

clear; clc; close all;

%% Load the TrainingData.mat file
data1 = load('trainData.mat');

% Display the fields in the loaded data (equivalent to Python's .keys())
fprintf('Keys in the loaded data from trainData.mat: ');
fields1 = fieldnames(data1);
disp(fields1);

% Sample frequency
fs = data1.sampFreq;
% Handle case where sampFreq might be stored as a cell or array
if iscell(fs)
    fs = fs{1};
elseif ~isscalar(fs)
    fs = fs(1);
end
fprintf('sample frequency: %g\n', fs);

% Training data
trainData = data1.trainData(:); % Convert to column vector
fprintf('train data shape: [%d, %d]\n', size(trainData, 1), size(trainData, 2));

% Display first and last few elements of trainData
if length(trainData) > 6
    fprintf('train data: [%e %e %e ... %e %e %e]\n', trainData(1), trainData(2), trainData(3), ...
        trainData(end-2), trainData(end-1), trainData(end));
else
    fprintf('train data: ');
    disp(trainData.');
end
fprintf('\n');

%% Load the analysisData.mat file
data2 = load('analysisData.mat');

% Display the fields in the loaded data
fprintf('Keys in the loaded data from analysisData.mat: ');
fields2 = fieldnames(data2);
disp(fields2);

% Analysis data
analysisData = data2.dataVec(:); % Convert to column vector
nsamples = length(analysisData);
fprintf('analysis data shape: [%d, %d]\n', size(analysisData, 1), size(analysisData, 2));

% Display first and last few elements of analysisData
if length(analysisData) > 6
    fprintf('analysis data: [%e %e %e ... %e %e %e]\n', analysisData(1), analysisData(2), analysisData(3), ...
        analysisData(end-2), analysisData(end-1), analysisData(end));
else
    fprintf('analysis data: ');
    disp(analysisData.');
end

% Time vector
time_vec = (0:length(analysisData)-1) / fs;

%% Display additional information
fprintf('\nAdditional information:\n');
fprintf('Length of time vector: %d\n', length(time_vec));
fprintf('First few time values: ');
disp(time_vec(1:min(5, end)).');
fprintf('Last few time values: ');
disp(time_vec(end-min(4, end-1):end).');

%% Estimate the PSD using Welch's method
% Note: MATLAB's pwelch returns two-sided PSD by default for real signals
[f, psd_vec] = pwelch(trainData, [], [], [], fs);
psd_vec = psd_vec/2; % Scale the PSD to convert it from one-sided to two-sided.

% Convert frequencies into the required DFT frequencies using linear interpolation
data_len = nsamples / fs;
k_nyq = floor(nsamples / 2) + 1;
pos_freq = (0:k_nyq-1) / data_len;

% Interpolate the PSD to the required frequencies
psd_interp = interp1(f, psd_vec, pos_freq, 'linear', 'extrap');
f = pos_freq;
psd_vec = psd_interp;

% Plot the estimated PSD
figure('Position', [100, 100, 1000, 600]);
plot(f, psd_vec);
title('Estimated Power Spectral Density (PSD) using Welch''s Method');
xlabel('Frequency [Hz]');
ylabel('PSD [V^2/Hz]');
grid on;

%% Run PSO optimization
% Number of runs for PSO
n_runs = 10; % Reduced for demonstration - increase for better results

% Bounds for a1, a2, a3 of the quadratic chirp signal
min_bounds = [0, 0, 0];
max_bounds = [100, 100, 100];

% Store results
results = zeros(n_runs, 5); % [run_index, cost, a1, a2, a3]

% Create global variables for the objective function
global g_time_vec g_analysisData g_fs g_psd_vec
g_time_vec = time_vec;
g_analysisData = analysisData;
g_fs = fs;
g_psd_vec = psd_vec;

% Run PSO for n_runs iterations
for i = 1:n_runs
    % Print progress
    progress = (i) / n_runs * 100;
    fprintf('\rProgress: %.1f%%', progress);
    
    % Define options for PSO
    options = optimoptions('particleswarm', 'SwarmSize', 50, ...
        'MaxIterations', 50, 'Display', 'off');
    
    % Run particle swarm optimization
    % Note: particleswarm minimizes the objective function
    [pos, cost] = particleswarm(@objective_func, 3, min_bounds, max_bounds, options);
    
    % Store results
    results(i, :) = [i, cost, pos];
end
fprintf('\n');

% Find the best result
[~, best_idx] = min(results(:, 2));
best_record = results(best_idx, :);

% Display results
fprintf('result corresponding to min cost:\n');
fprintf('Run: %d\n', best_record(1));
fprintf('cost(-GLRT): %f\n', best_record(2));
fprintf('\n');
fprintf('Estimated parameters of the quadratic chirp signal:\n');
fprintf('position[a1,a2,a3]: [%.4f %.4f %.4f]\n', best_record(3), best_record(4), best_record(5));
fprintf('Estimated SNR: %.4f\n', sqrt(-best_record(2)));

% Plot the cost vs run
figure('Position', [100, 100, 1000, 600]);
plot(results(:, 1), results(:, 2), 'o-');
title('Cost vs Runs');
xlabel('Runs');
ylabel('Cost');
grid on;