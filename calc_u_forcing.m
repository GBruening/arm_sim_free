function [u] = calc_u_forcing(u_in, act, count, shoulder, elbow, theta)
    
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
    if exist('act','var')
        if mod(count,200)==1
            for k = 1:8
                h = [];
                for x = 0:.01:1
                    if abs(act.(muscle_nums{k})(end)-x)>.2
                        h = [h;10];
                    else
                        h = [h;1];
                    end
                end
                x = 0:.01:1;
                u(k) = randpdf(h,x,[1,1]);
    %             if act.(muscle_nums{k})(end) > .7
    %                 u(k) = betarnd(1-act.(muscle_nums{k})(end),1,[1]);
    %             elseif act.(muscle_nums{k})(end) < .3
    %                 u(k) = betarnd(1,1-act.(muscle_nums{k})(end),[1]);
    %             else
    %                 u(k) = betarnd(1,1);
    %             end
            end
            if elbow.torque_c(end)>0
                u(1) = (1-u(1))*.75+u(1);
                u(2) = u(2)/(5.5+rand);
                u(3) = u(3)/(5.5+rand);
                u(7) = u(7)/(3.5+rand);
            else
                u(1) = u(1)/(2.5+rand);
                u(2) = (1-u(2))*.35+u(2);
                u(3) = (1-u(3))*.35+u(3);
            end
            if shoulder.torque_c(end)>0
                u(5) = (1-u(5))*.75+u(5);
                u(4) = u(4)/(5.5+rand);
                u(6) = u(6)/(5.5+rand);
            else
                u(4) = (1-u(4))*.75+u(4);
                u(6) = (1-u(6))*.75+u(6);
                u(5) = u(5)/(3.5+rand);
            end
            if shoulder.torque_c(end)>0 && elbow.torque_c(end)>0
                u(8) = (1-u(8))*.3+u(8);
                u(7) = u(7)/(3.5+rand);
            elseif shoulder.torque_c(end)<0 && elbow.torque_c(end)<0
                u(7) = (1-u(7))*.3+u(7);
                u(8) = u(8)/(3.5+rand);
            end
            for k = 1:8
                if u(k)<0
                   u(k)=0;
                elseif u(k)>1
                    u(k) = 1;
                end
            end
        elseif mod(count,25)==1
            scaler = 1;
            for k = 1:8
                u(k) = u_in(end,k)+((rand-.5)/100);
                if u(k)<0
                   u(k)=0;
                end
            end
            if elbow.torque_c(end)>0
                u(1) = (1-u(1))/scaler+u(1);
                u(2) = u(2)/(1+elbow.torque_c(end)/scaler+rand/scaler);
                u(3) = u(3)/(1+elbow.torque_c(end)/scaler+rand/scaler);
                u(7) = u(7)/(1+elbow.torque_c(end)/scaler+rand/scaler);
            else
                u(1) = u(1)/(1-elbow.torque_c(end)/10+rand/10);
                u(2) = (1-u(2))/scaler+u(2);
                u(3) = (1-u(3))/scaler+u(3);
            end
            if shoulder.torque_c(end)>0
                u(5) = (1-u(5))*.1+u(5);
                u(4) = u(4)/(1+shoulder.torque_c(end)*5/scaler+rand/scaler);
                u(6) = u(6)/(1+shoulder.torque_c(end)*5/scaler+rand/scaler);
            else
                u(4) = (1-u(4))/scaler+u(4);
                u(6) = (1-u(6))/scaler+u(6);
                u(5) = u(5)/(1-shoulder.torque_c(end)/scaler+rand/scaler);
            end
            if shoulder.torque_c(end)>0 && elbow.torque_c(end)>0
                u(8) = (1-u(8))*.01+u(8);
                u(7) = u(7)/(1+rand/100);
            elseif shoulder.torque_c(end)<0 && elbow.torque_c(end)<0
                u(7) = (1-u(7))*.01+u(7);
                u(8) = u(8)/(1+rand/100);
            end
            for k = 1:8
                if u(k)<0
                   u(k)=0;
                elseif u(k)>1
                    u(k) = 1;
                end
            end
        elseif mod(count,5)==1
            scaler = 5;
            for k = 1:8
                u(k) = u_in(end,k)+((rand-.5)/100);
                if u(k)<0
                   u(k)=0;
                end
            end
            if elbow.torque_c(end)>0
                u(1) = (1-u(1))/scaler+u(1);
                u(2) = u(2)/(1+elbow.torque_c(end)/scaler+rand/scaler);
                u(3) = u(3)/(1+elbow.torque_c(end)/scaler+rand/scaler);
                u(7) = u(7)/(1+elbow.torque_c(end)/scaler+rand/scaler);
            else
                u(1) = u(1)/(1-elbow.torque_c(end)/10+rand/10);
                u(2) = (1-u(2))/scaler+u(2);
                u(3) = (1-u(3))/scaler+u(3);
            end
            if shoulder.torque_c(end)>0
                u(5) = (1-u(5))*.1+u(5);
                u(4) = u(4)/(1+shoulder.torque_c(end)*5/scaler+rand/scaler);
                u(6) = u(6)/(1+shoulder.torque_c(end)*5/scaler+rand/scaler);
            else
                u(4) = (1-u(4))/scaler+u(4);
                u(6) = (1-u(6))/scaler+u(6);
                u(5) = u(5)/(1-shoulder.torque_c(end)/scaler+rand/scaler);
            end
            if shoulder.torque_c(end)>0 && elbow.torque_c(end)>0
                u(8) = (1-u(8))*.01+u(8);
                u(7) = u(7)/(1+rand/100);
            elseif shoulder.torque_c(end)<0 && elbow.torque_c(end)<0
                u(7) = (1-u(7))*.01+u(7);
                u(8) = u(8)/(1+rand/100);
            end
            for k = 1:8
                if u(k)<0
                   u(k)=0;
                elseif u(k)>1
                    u(k) = 1;
                end
            end
        else
            for k = 1:8
                u(k) = u_in(end,k)+((rand-.5)/10);
                if u(k)<0
                   u(k)=0;
                end
            end
            for k = 1:8
                if u(k)<0
                   u(k)=0;
                elseif u(k)>1
                    u(k) = 1;
                end
            end
        end
    else
        u = betarnd(1,1,[1,8]);
    end

        
%     if theta.Sd(end) > 0
%         u(4) = betarnd(2,5);
%         u(5) = betarnd(2,5)*-1+1;
%         u(6) = betarnd(2,5);
%     else
%         u(4) = betarnd(2,5)*-1+1;
%         u(5) = betarnd(2,5);
%         u(6) = betarnd(2,5)*-1+1;
%     end
%     
%     if theta.Ed(end) > 0
%         u(1) = betarnd(2,5)*-1+1;
%         u(2) = betarnd(2,5);
%         u(3) = betarnd(2,5);
%     else
%         u(1) = betarnd(2,5);
%         u(2) = betarnd(2,5)*-1+1;
%         u(3) = betarnd(2,5)*-1+1;
%     end
%         
%     if theta.Sd(end) > 0 && theta.Ed(end) >0
%         u(7) = betarnd(2,5)*-1+1;
%         u(8) = betarnd(2,5);
%     elseif theta.Sd(end) < 0 && theta.Ed(end) < 0
%         u(7) = betarnd(2,5);
%         u(8) = betarnd(2,5)*-1+1;
%     else
%         u(7) = betarnd(5,5);
%         u(8) = betarnd(5,5);
%     end
    
%     if shoulder.torque_c_c(end) > 0
%         u(4) = betarnd(2,5);
%         u(5) = betarnd(2,5)*-1+1;
%         u(6) = betarnd(2,5);
%     else
%         u(4) = betarnd(2,5)*-1+1;
%         u(5) = betarnd(2,5);
%         u(6) = betarnd(2,5)*-1+1;
%     end
%     
%     if elbow.torque_c_c(end) > 0
%         u(1) = betarnd(2,5)*-1+1;
%         u(2) = betarnd(2,5);
%         u(3) = betarnd(2,5);
%     else
%         u(1) = betarnd(2,5);
%         u(2) = betarnd(2,5)*-1+1;
%         u(3) = betarnd(2,5)*-1+1;
%     end
%         
%     if shoulder.torque_c_c(end) > 0 && elbow.torque_c_c(end) >0
%         u(7) = betarnd(2,5)*-1+1;
%         u(8) = betarnd(2,5);
%     elseif shoulder.torque_c_c(end) < 0 && elbow.torque_c_c(end) < 0
%         u(7) = betarnd(2,5);
%         u(8) = betarnd(2,5)*-1+1;
%     else
%         u(7) = betarnd(5,5);
%         u(8) = betarnd(5,5);
%     end
        
end

