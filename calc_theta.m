%% calc_theta.m
% Created by: Gary Bruening
% Edited:     5-13-2019
% 
% The main inverse dynamics script.
% Calculates joint torques for shoulder and elbow. Does some smoothing of
% the data in the middle if your using resampled data from an experiment.

function [ theta ] = ...
    calc_theta(x, y, forearm , upperarm, theta)
%% Get joint angles
index = ~isnan(x);

x = x(end);
y = y(end);

a = x.^2 + y.^2 - upperarm.length.^2 - forearm.length.^2;
b = 2 * upperarm.length * forearm.length;

theta.E = [theta.E,acos(a./b)];
theta.S=[theta.S,atan2(y,x)-asin(forearm.length.*sin(theta.E(index))./(sqrt(x.^2+y.^2)))];
    
end

