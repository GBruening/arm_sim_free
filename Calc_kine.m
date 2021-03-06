%% Calc_kine.m
% Created by: Gary Bruening
% Edited:     5-13-2019
% 
% The main inverse dynamics script.
% Calculates joint torques for shoulder and elbow. Does some smoothing of
% the data in the middle if your using resampled data from an experiment.

function [ theta ] = ...
    Calc_kine( x, y, forearm , upperarm, time_inc , add_mass)

order = 5;
window = 21;

% Init Variables
shoulder.torque = 
elbow.torque    = 
theta.E         = 
theta.S         = 
theta.Sd        = 
theta.Ed        = 
theta.Sdd       = 
theta.Edd       = 
    
%% Get joint angles
index = ~isnan(Data.x(:));

x = x[end];
y = y[end];

a = x.^2 + y.^2 - upperarm.length.^2 - forearm.length.^2;
b = 2 * upperarm.length * forearm.length;

theta.E(index) = acos(a./b);

k1 = upperarm.length + forearm.length*cos(theta.E(index));
k2 = forearm.length*sin(theta.E(index));
theta.S(index) = atan2(y,x)-asin(forearm.length.*sin(theta.E(index))./(sqrt(x.^2+y.^2)));

% Smooth and determine angular velocities.
s1 = diff23f5(theta.S,time_inc,3);
e1 = diff23f5(theta.E,time_inc,3);
theta.Sd = s1(:,2);
theta.Ed = e1(:,2);
theta.Sdd = [s1(:,3)];
theta.Edd = [e1(:,3)];
    
end

