%% Drive to theta
function [theta, muscles] = drive_to_theta(act,...
                                           muscles,...
                                           theta,...
                                           forearm,...
                                           upperarm,...
                                           elbow,...
                                           shoulder,...
                                           vars)
%[~] = Forward_dynamics_check(muscles,theta,forearm.,upperarm.,elbow,shoulder)

muscle_nums = {'an','bs','br','da','dp','pc','bb','tb'};

norm_force = vars.norm_force;
for k = 1:length(muscle_nums)
    norm_length(k) = muscles.(muscle_nums{k}).length(end)/muscles.(muscle_nums{k}).l0;
    vel(k) = muscles.(muscle_nums{k}).v(end);
    
    a = act.(muscle_nums{k})(end);

    stress(k) = Fl_Fv_for(norm_length(k),vel(k),a)*norm_force;
    force(k) = stress(k)*muscles.(muscle_nums{k}).pcsa;
    
    muscles.(muscle_nums{k}).force = ...
        [muscles.(muscle_nums{k}).force, force(k)];
    muscles.(muscle_nums{k}).stress = ...
        [muscles.(muscle_nums{k}).stress, stress(k)];
end

A1 = [muscles.an.m_arm_e(end),...
    muscles.bs.m_arm_e(end),...
    muscles.br.m_arm_e(end),...
    0,...
    0,...
    0,...
    muscles.bb.m_arm_e(end),...
    muscles.tb.m_arm_e(end)];
A2 = [0,...
    0,...
    0,...
    muscles.da.m_arm_s(end),...
    muscles.dp.m_arm_s(end),...
    muscles.pc.m_arm_s(end),...
    muscles.bb.m_arm_s(end),...
    muscles.tb.m_arm_s(end)];
A=[A1;A2];

x = [force(1),force(2),force(3),...
    force(4),force(5),force(6),...
    force(7),force(8)]';

elbow.torque_c = [elbow.torque_c, A1*x];
shoulder.torque_c = [shoulder.torque_c, A2*x];

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
elseif e_s > deg2rad(135)
    theta.S = [theta.S, deg2rad(135)];
else
    theta.S = [theta.S, theta.S(end) + theta.Sd(end)*vars.time_inc];
end

e_f = theta.E(end) + theta.Ed(end)*vars.time_inc;
if e_f < deg2rad(3)
    theta.E = [theta.E, deg2rad(3)];
elseif e_f > deg2rad(177)
    theta.E = [theta.E, deg2rad(177)];
else
    theta.E = [theta.E, theta.E(end) + theta.Ed(end)*vars.time_inc];
end
if ~isreal(theta.E(end))
    1;
end
    

end
