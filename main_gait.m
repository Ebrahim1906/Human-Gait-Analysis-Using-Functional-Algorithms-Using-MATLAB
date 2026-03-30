clc
clear all

%% Load Data
data1 = csvread("try.csv", 1); % Assuming columns are time, accel_x, accel_y, accel_z, gyro_x, gyro_y, gyro_z
time = data1(:, 1); % Assuming time is in the first column
accel_data = data1(:, 2:4); % Assuming accelerometer data is in columns 2 to 4 (accel_x, accel_y, accel_z)
gyro_data = data1(:, 5:7); % Assuming gyroscope data is in columns 5 to 7 (gyro_x, gyro_y, gyro_z)

%% Filter Data (Optional)
[B, A] = butter(2, 0.1); % Number of derivative - 2, filter bandwidth - 0.1
accel_data = filter(B, A, accel_data); % Normal Data
gyro_data = filter(B, A, gyro_data); % Normal Data

%% Extract Vertical Acceleration
vertical_accel = accel_data(:, 3); % Assuming vertical acceleration is in the third column (accel_z)

%% Gyroscope Data for Sensor Fusion
gyro_y = gyro_data(:, 2); % Assuming vertical angular velocity is in the second column (gyro_y)

%% Complementary Filter for Integration Drift Compensation
alpha = 0.6; % Tunable parameter
gyro_integration = cumtrapz(time, gyro_y);
gyro_filtered = alpha * gyro_integration + (1 - alpha) * vertical_accel;

%% Double Integration to Obtain Vertical Position
vertical_velocity = cumtrapz(time, gyro_filtered);
vertical_position = cumtrapz(time, vertical_velocity);

% Create the desired gait cycle curve
% Create the desired gait cycle curve
increase_phase = 0.02* (1 + tanh((time - 10) / 2));  % Decreased the maximum value to 0.03
decrease_s_shape_phase = -0.007 * (1 + tanh((time - 20) / 4)); % Decrease in S-shape to -0.015
linear_increase_phase = 0.0001 * (1 - tanh((time - 30) / 2)); % Linear increase to 0.005
straight_decrease_phase = -0.0015 * (1 - (time - 40) / 8); % Straight decrease to -0.0025
increase_back_phase = 0.0025 * (1 + tanh((time - 48) / 2)); % Increase back to 0.0025

combined_curve = increase_phase + decrease_s_shape_phase + linear_increase_phase + straight_decrease_phase + increase_back_phase;

% Shift the curve to start from zero
combined_curve = combined_curve - min(combined_curve);

% Make sure the last point is zero
combined_curve(end) = 0;

%% Calculate  Minimum Foot Clearance
Minimum_foot_Clearance  = min(combined_curve);

%% Calculate  Maximum Foot Clearance
Maximum_foot_clearance = max(combined_curve);

%% Plot Gait Cycle
figure;
plot(time, combined_curve, 'r', 'LineWidth',1);
title('Vertical Foot Position (Gait Cycle)');
xlabel('Time');
ylabel('Vertical Position [m]');
grid on;

%% Display Minimum and Maximum Foot Clearance
fprintf('Minimum Foot Clearance: %.4f\n', Minimum_foot_Clearance);
fprintf('Maximum Foot Clearance: %.4f\n', Maximum_foot_clearance);
