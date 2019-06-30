function [pos] = calc_endpos(theta, forearm, upperarm, pos)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    x = upperarm.length * cos(theta.S(end)) + ...
        forearm.length * cos(theta.S(end)+theta.E(end));
    
    y = upperarm.length * sin(theta.S(end)) + ...
        forearm.length * sin(theta.S(end)+theta.E(end));

    pos.x = [pos.x, x];
    pos.y = [pos.y, y];
end

