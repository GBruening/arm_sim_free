%% Inverse Kinematics Checker
muscle_nums = {'one','two','thr','fou','fiv','six'};


%% Forward Dynamics Checker
% function [muscles] = Forward_dynamics_check(muscles,theta,forearm,upperarm,elbow,shoulder)
%[~] = Forward_dynamics_check(muscles{c,subj,s,t},theta{c,subj,s,t},forearm{c,subj,s,t}.,upperarm{c,subj,s,t}.,elbow{c,subj,s,t},shoulder{c,subj,s,t})

muscle_nums = {'an','bs','br','da','dp','pc','bb','tb'};

for ii = 1:length(act{c,subj,s,t}.an)
    norm_force = vars{c,subj,s,t}.norm_force;
    for k = 1:length(muscle_nums)
        norm_length(k) = muscles{c,subj,s,t}.(muscle_nums{k}).length(ii)/muscles{c,subj,s,t}.(muscle_nums{k}).l0;
        vel(k) = muscles{c,subj,s,t}.(muscle_nums{k}).v(ii);
        
        a = act{c,subj,s,t}.(muscle_nums{k})(ii);
        
        check.stress(k,ii) = Fl_Fv_for(norm_length(k),vel(k),a)*norm_force;
        check.force(k,ii) = check.stress(k,ii)*muscles{c,subj,s,t}.(muscle_nums{k}).pcsa;
    end
    
    A1 = [muscles{c,subj,s,t}.an.m_arm_e(ii),...
        muscles{c,subj,s,t}.bs.m_arm_e(ii),...
        muscles{c,subj,s,t}.br.m_arm_e(ii),...
        0,...
        0,...
        0,...
        muscles{c,subj,s,t}.bb.m_arm_e(ii),...
        muscles{c,subj,s,t}.tb.m_arm_e(ii)];
    A2 = [0,...
        0,...
        0,...
        muscles{c,subj,s,t}.da.m_arm_s(ii),...
        muscles{c,subj,s,t}.dp.m_arm_s(ii),...
        muscles{c,subj,s,t}.pc.m_arm_s(ii),...
        muscles{c,subj,s,t}.bb.m_arm_s(ii),...
        muscles{c,subj,s,t}.tb.m_arm_s(ii)];
    A=[A1;A2];
    
    x = [check.force(1,ii),check.force(2,ii),check.force(3,ii),...
        check.force(4,ii),check.force(5,ii),check.force(6,ii),...
        check.force(7,ii),check.force(8,ii)]';

    check.elbow{c,subj,s,t}.torque_c(ii) = A1*x;
    check.shoulder{c,subj,s,t}.torque_c(ii) = A2*x;
    
    prm.m1 = upperarm{c,subj,s,t}.mass;
    prm.r1 = upperarm{c,subj,s,t}.centl;
    prm.l1 = upperarm{c,subj,s,t}.length;
    prm.i1 = upperarm{c,subj,s,t}.Ic;
    
    prm.m2 = forearm{c,subj,s,t}.mass;
    prm.r2 = forearm{c,subj,s,t}.l_com;
    prm.r22 = forearm{c,subj,s,t}.centl;
    prm.l2 = forearm{c,subj,s,t}.length;
    prm.i2 = forearm{c,subj,s,t}.Ic;
    
    prm.m = vars{c,subj,s,t}.masses;
    
    M11 = prm.m1*prm.r1^2 + prm.i1 +...
        (prm.m+prm.m2)*(prm.l1^2+prm.r22^2+...
        2*prm.l1*prm.r22*cos(theta{c,subj,s,t}.E(ii))) +...
        prm.i2;

    M12 = (prm.m2+prm.m)*(prm.r22^2+...
        prm.l1*prm.r22*cos(theta{c,subj,s,t}.E(ii))) +...
        prm.i2;

    M21 = M12;

    M22 = prm.m2*prm.r2^2+prm.m*prm.l2^2+prm.i2;
    
    C1 = -forearm{c,subj,s,t}.mass*forearm{c,subj,s,t}.centl*upperarm{c,subj,s,t}.length*(theta{c,subj,s,t}.Ed(ii).^2).*sin(theta{c,subj,s,t}.E(ii))-...
        2*forearm{c,subj,s,t}.mass*forearm{c,subj,s,t}.centl*upperarm{c,subj,s,t}.length*theta{c,subj,s,t}.Sd(ii).*theta{c,subj,s,t}.Ed(ii).*sin(theta{c,subj,s,t}.E(ii));

    C2 = forearm{c,subj,s,t}.mass*forearm{c,subj,s,t}.centl*upperarm{c,subj,s,t}.length*(theta{c,subj,s,t}.Sd(ii).^2).*sin(theta{c,subj,s,t}.E(ii));
    
    qdd = [M11,M12;M21,M22] \([check.shoulder{c,subj,s,t}.torque_c(ii); check.elbow{c,subj,s,t}.torque_c(ii)] - [C1;C2]);
    
    check.theta{c,subj,s,t}.Sdd(ii) = qdd(1);
    check.theta{c,subj,s,t}.Edd(ii) = qdd(2);
end
vars{c,subj,s,t}.masses