clc
clear all
%% Data Load
% use 'data' variable for normal data loading 
data = csvread("Tanim gait data.csv",1); % Leaving first '1' row // Normal data

%% Reading Normal Data
time = data(:,1); %all row 1 column // Normal Data
xrotation = data(:,2); %all row 2 column // Normal Data
yrotation = data(:,3); %all row 3 column // Normal Data
zrotation = data(:,4); %all row 4 column // Normal Data

%% Filtering
[B,A] = butter(2, 0.1); % Number of derivative - 2, filter bandwidth - 0.1
xrotation = filter (B,A, xrotation); % Normal Data
yrotation = filter (B,A, yrotation); % Normal Data
zrotation = filter (B,A, zrotation); % Normal Data
%% Accelaration plotting
subplot (3,3,1); plot(time,xrotation,'r'); xlabel("Time"); ylabel("X-axis"); title ("Accelaration in x axis"); grid on; 
subplot (3,3,2); plot(time,yrotation, 'g'); xlabel("Time"); ylabel("Y-axis"); title ("Accelaration in y axis");grid on; 
subplot (3,3,3); plot(time,zrotation, 'b'); xlabel("Time"); ylabel("Z-axis"); title ("Accelaration in z axis"); grid on; 
%% velocity by integration
xvel = cumtrapz(time, xrotation); % Normal Data
yvel = cumtrapz(time, yrotation); % Normal Data
zvel = cumtrapz(time,zrotation); % Normal Data
subplot (3,3,4); plot(time,xvel,'r'); xlabel("Time"); ylabel("X-axis"); title ("velocity in x axis");grid on; 
subplot (3,3,5); plot(time,yvel, 'g'); xlabel("Time"); ylabel("Y-axis"); title ("velocity in y axis"); grid on; 
subplot (3,3,6); plot(time,zvel, 'b'); xlabel("Time"); ylabel("Z-axis"); title ("velocity in z axis"); grid on; 
%% Displacement
xdis = cumtrapz(time, xvel); % Normal Data
ydis = cumtrapz(time, yvel); % Normal Data
zdis = cumtrapz(time, zvel); % Normal Data
subplot (3,3,7); plot(time,xdis,'r'); xlabel("Time"); ylabel("X-axis"); title ("Displacement in x axis");grid on; 
subplot (3,3,8); plot(time,ydis, 'g'); xlabel("Time"); ylabel("Y-axis"); title ("Displacement in y axis"); grid on; 
subplot (3,3,9); plot(time,zdis, 'b'); xlabel("Time"); ylabel("Z-axis"); title ("Displacementin z axis"); grid on;

