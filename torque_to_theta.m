%% Drive to theta
function [theta, muscles, shoulder, elbow] = drive_to_theta(x,theta,...
                                           forearm,...
                                           upperarm,...
                                           elbow,...
                                           shoulder,...
                                           vars)
elbow.torque_c = [elbow.torque_c, x(1)];
shoulder.torque_c = [shoulder.torque_c, x(2)];

prm.m1 = upperarm.mass;
prm.r1 = upperarm.centl;
prm.l1 = upperarm.length;
prm.i1 = upperarm.Ic;

prm.m2 = forearm.mass;
prm.r2 = forearm.l_com;
prm.r22 = forearm.centl;
prm.l2 = forearm.length;
prm.i2 = forearm.Ic;

prm.m = vars.masses;

M11 = prm.m1*prm.r1^2 + prm.i1 +...
    (prm.m+prm.m2)*(prm.l1^2+prm.r22^2+...
    2*prm.l1*prm.r22*cos(theta.E(end))) +...
    prm.i2;

M12 = (prm.m2+prm.m)*(prm.r22^2+...
    prm.l1*prm.r22*cos(theta.E(end))) +...
    prm.i2;

M21 = M12;

M22 = prm.m2*prm.r2^2+prm.m*prm.l2^2+prm.i2;

C1 = -forearm.mass*forearm.centl*upperarm.length*(theta.Ed(end).^2).*sin(theta.E(end))-...
    2*forearm.mass*forearm.centl*upperarm.length*theta.Sd(end).*theta.Ed(end).*sin(theta.E(end));

C2 = forearm.mass*forearm.centl*upperarm.length*(theta.Sd(end).^2).*sin(theta.E(end));

qdd = [M11,M12;M21,M22] \([shoulder.torque_c(end); elbow.torque_c(end)] - [C1;C2]);

theta.Sdd = [theta.Sdd, qdd(1)];
theta.Edd = [theta.Edd, qdd(2)];

theta.Sd = [theta.Sd, theta.Sd(end) + theta.Sdd(end)*vars.time_inc];
theta.Ed = [theta.Ed, theta.Ed(end) + theta.Edd(end)*vars.time_inc];

e_s = theta.S(end) + theta.Sd(end)*vars.time_inc;
if e_s < deg2rad(-45)
    theta.S = [theta.S, deg2rad(-45)];
    theta.Sd(end) = 0;
elseif e_s > deg2rad(135)
    theta.S = [theta.S, deg2rad(135)];
    theta.Sd(end) = 0;
else
    theta.S = [theta.S, theta.S(end) + theta.Sd(end)*vars.time_inc];
end

e_f = theta.E(end) + theta.Ed(end)*vars.time_inc;
if e_f < deg2rad(3)
    theta.E = [theta.E, deg2rad(3)];
    theta.Ed(end) = 0;
elseif e_f > deg2rad(177)
    theta.E = [theta.E, deg2rad(177)];
    theta.Ed(end) = 0;
else
    theta.E = [theta.E, theta.E(end) + theta.Ed(end)*vars.time_inc];
end

end
