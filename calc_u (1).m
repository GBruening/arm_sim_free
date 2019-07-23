function [u] = calc_u(theta,muscles,shoulder,elbow)
    
    muscle_nums = {'an','bs','br','da','dp','pc','bb','tb'};
    
%     in = [theta.S(end),...
%           theta.E(end)];
%     for k = 1:8
%         in = [in,...
%               muscles.(muscle_nums{k}).norm_length(end),...
%               muscles.(muscle_nums{k}).v(end)...
% %               muscles.(muscle_nums{k}).force,...
%               ];
%     end
%     u = in*m;

    if theta.Sd(end) > 0
        u(4) = betarnd(2,5);
        u(5) = betarnd(2,5)*-1+1;
        u(6) = betarnd(2,5);
    else
        u(4) = betarnd(2,5)*-1+1;
        u(5) = betarnd(2,5);
        u(6) = betarnd(2,5)*-1+1;
    end
    
    if theta.Ed(end) > 0
        u(1) = betarnd(2,5)*-1+1;
        u(2) = betarnd(2,5);
        u(3) = betarnd(2,5);
    else
        u(1) = betarnd(2,5);
        u(2) = betarnd(2,5)*-1+1;
        u(3) = betarnd(2,5)*-1+1;
    end
        
    if theta.Sd(end) > 0 && theta.Ed(end) >0
        u(7) = betarnd(2,5)*-1+1;
        u(8) = betarnd(2,5);
    elseif theta.Sd(end) < 0 && theta.Ed(end) < 0
        u(7) = betarnd(2,5);
        u(8) = betarnd(2,5)*-1+1;
    else
        u(7) = betarnd(5,5);
        u(8) = betarnd(5,5);
    end
    
%     if shoulder.torque_c(end) > 0
%         u(4) = betarnd(2,5);
%         u(5) = betarnd(2,5)*-1+1;
%         u(6) = betarnd(2,5);
%     else
%         u(4) = betarnd(2,5)*-1+1;
%         u(5) = betarnd(2,5);
%         u(6) = betarnd(2,5)*-1+1;
%     end
%     
%     if elbow.torque_c(end) > 0
%         u(1) = betarnd(2,5)*-1+1;
%         u(2) = betarnd(2,5);
%         u(3) = betarnd(2,5);
%     else
%         u(1) = betarnd(2,5);
%         u(2) = betarnd(2,5)*-1+1;
%         u(3) = betarnd(2,5)*-1+1;
%     end
%         
%     if shoulder.torque_c(end) > 0 && elbow.torque_c(end) >0
%         u(7) = betarnd(2,5)*-1+1;
%         u(8) = betarnd(2,5);
%     elseif shoulder.torque_c(end) < 0 && elbow.torque_c(end) < 0
%         u(7) = betarnd(2,5);
%         u(8) = betarnd(2,5)*-1+1;
%     else
%         u(7) = betarnd(5,5);
%         u(8) = betarnd(5,5);
%     end
        
end

