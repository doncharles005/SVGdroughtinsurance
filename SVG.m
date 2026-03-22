% Clear workspace and command window
clear all;
clc;

% Define file path and name
file_path = 'G:\2018\Documents\papers\climate change\Climate Insurance';
file_name = 'SVGdata.xlsx';  % Assuming .xlsx extension
full_file = fullfile(file_path, file_name);

% Import data from Sheet 1, columns B to E
% Column B: FAO (agricultural price index)
% Column C: shipping (shipping costs)
% Column D: SITC0 (export values)
% Column E: rainfall

% Method 1: Using readtable (recommended for mixed data types)
data_table = readtable(full_file, 'Sheet', 1, 'Range', 'B:E');

% Extract variables
FAO = data_table{:, 1};        % Column B - agricultural price index
shipping = data_table{:, 2};    % Column C - shipping costs
SITC0 = data_table{:, 3};       % Column D - export values
rainfall = data_table{:, 4};    % Column E - rainfall

% Alternative Method 2: Using xlsread 
% [num, txt, raw] = xlsread(full_file, 1, 'B:E');
% FAO = num(:, 1);
% shipping = num(:, 2);
% SITC0 = num(:, 3);
% rainfall = num(:, 4);

% Check for missing values
fprintf('Checking for missing values (NaN):\n');
fprintf('FAO: %d missing\n', sum(isnan(FAO)));
fprintf('shipping: %d missing\n', sum(isnan(shipping)));
fprintf('SITC0: %d missing\n', sum(isnan(SITC0)));
fprintf('rainfall: %d missing\n', sum(isnan(rainfall)));

% Display first few rows to verify
fprintf('\nFirst 10 rows of data:\n');
disp([FAO(1:10), shipping(1:10), SITC0(1:10), rainfall(1:10)]);

% Create a summary
fprintf('\nData Summary:\n');
fprintf('Number of observations: %d\n', length(FAO));
fprintf('FAO range: [%.2f, %.2f]\n', min(FAO), max(FAO));
fprintf('Shipping range: [%.2f, %.2f]\n', min(shipping), max(shipping));
fprintf('SITC0 range: [%.2f, %.2f]\n', min(SITC0), max(SITC0));
fprintf('Rainfall range: [%.2f, %.2f]\n', min(rainfall), max(rainfall));


% Step 1: Create deflated agricultural output variable (agriout)
% agriout = SITC0 export value / (agricultural price × shipping costs)
% Add a small epsilon to avoid division by zero if needed
epsilon = 1e-10;
agriout = SITC0 ./ (FAO .* shipping + epsilon);

% Alternative approach using log transformation (more robust to scaling)
% agriout_log = log(SITC0 + epsilon) - log(FAO + epsilon) - log(shipping + epsilon);
% agriout = exp(agriout_log);

% Step 2: Normalize agriout and rainfall to mean 0, standard deviation 1
% Calculate mean and standard deviation
agriout_mean = mean(agriout, 'omitnan');
agriout_std = std(agriout, 'omitnan');
rainfall_mean = mean(rainfall, 'omitnan');
rainfall_std = std(rainfall, 'omitnan');

% Normalize
output_norm = (agriout - agriout_mean) / agriout_std;
rain_norm = (rainfall - rainfall_mean) / rainfall_std;

fprintf('\nNormalized variables created:\n');
fprintf('output_norm - mean: %.4f, std: %.4f\n', mean(output_norm, 'omitnan'), std(output_norm, 'omitnan'));
fprintf('rain_norm - mean: %.4f, std: %.4f\n', mean(rain_norm, 'omitnan'), std(rain_norm, 'omitnan'));

% Step 3: Apply transformation to create loss estimate
% transformed_loss = -output_norm + (rain_norm × 0.3)
transformed_loss = -output_norm + (rain_norm * 0.3);

fprintf('\nTransformed loss variable created:\n');
fprintf('transformed_loss range: [%.4f, %.4f]\n', min(transformed_loss), max(transformed_loss));
fprintf('transformed_loss mean: %.4f, std: %.4f\n', mean(transformed_loss, 'omitnan'), std(transformed_loss, 'omitnan'));
fprintf('\nAgricultural output (agriout) created successfully\n');
fprintf('agriout range: [%.4f, %.4f]\n', min(agriout), max(agriout));


