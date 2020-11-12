function [error,out] = ga_arm_sim_torque(x,size1,animate)
% x = x*1e-6;
% x = reshape(x,[18,8]);
x = reshape(x,[size1,2]);
format long
time = 0;

input.added_mass  = 0;
input.subj_mass   = 60; % in kg
input.subj_height = 1.50; % in m
input.movedur     = 1;
input.normforce   = 200E4;
input.start_pos   = [-.0758,0.4878]; % Starting location in m
input.tar_rel_pos = [0.0707, 0.0707]; % Relative Target position in m

% Initialize some variables. 
vars.masses = input.added_mass;
vars.rnjesus = 0;
vars.time_inc = 0.05;
vars.speeds = input.movedur; % Movement Duration
vars.norm_force = input.normforce;
vars.minparam = 'drive2';

% Create the arm segments.
forearm.mass = 0.022*input.subj_mass;%;+2*vars{c,subj,s,t}.masses(c);
forearm.length = (0.632-0.425)*input.subj_height; % meters, taken from An iterative optimal control and estimation design for nonlinear stochastic system
forearm.l_com = 0.682*forearm.length;

forearm.l_com = (.417*(.632-.480)*input.subj_height*.016*input.subj_mass +...
        ((.632-.480)*input.subj_height+.515*((.480-.370)/2)*input.subj_height)*.006*input.subj_mass)/...
        (.016*input.subj_mass+.006*input.subj_mass); % Using Enoka
    
[forearm] = calc_forearmI(forearm,vars.masses);

upperarm.length = (0.825-0.632)*input.subj_height; % meters
upperarm.l_com = 0.436*upperarm.length;
upperarm.centl = 0.436*upperarm.length;
upperarm.mass = 0.028*input.subj_mass; %kg
upperarm.Ic = .0141;

shoulder = [];
elbow = [];
theta = [];

% Define the target spots.
ro = input.start_pos;
vars.target = input.tar_rel_pos;
rf = [vars.target(1)+ro(1),...
    vars.target(2)+ro(2)];

[ theta, pos ] = init_theta(ro(1),ro(2),forearm,upperarm,theta);

elbow.torque_c = [];
shoulder.torque_c = [];

if animate
    figure(1);
end
count = 0;
while count<size1-1
    count = count + 1;
    if count>1
        torque_in = x(end,:);
    else
        torque_in = x;
    end
    [theta] = torque_to_theta(torque_in,...
                           theta,...
                           forearm,...
                           upperarm,...
                           elbow,...
                           shoulder,...
                           vars);
                       
    pos = calc_endpos(theta, forearm, upperarm, pos);
    
    
    time = time + vars.time_inc;
    
    if animate
        % Animating it
        clf(1);hold on;
        xlim([.6*(-upperarm.length-forearm.length) .5*(upperarm.length+forearm.length)]);
        ylim([-0.1 upperarm.length+forearm.length]);
        
        plot(input.start_pos(1),input.start_pos(2),...
            'x','MarkerSize',15,'color','red');
        plot(input.start_pos(1)+input.tar_rel_pos(1),...
            input.start_pos(2)+input.tar_rel_pos(2),...
            'o','MarkerSize',15,'color','green');
        
        x1 = upperarm.length * cos(theta.S(end));

        y1 = upperarm.length * sin(theta.S(end));

        x2 = upperarm.length * cos(theta.S(end)) + ...
            forearm.length * cos(theta.S(end)+theta.E(end));

        y2 = upperarm.length * sin(theta.S(end)) + ...
            forearm.length * sin(theta.S(end)+theta.E(end));
        plot([0,x1],[0,y1], 'color', 'blue');
        plot([x1,x2],[y1,y2], 'color', 'blue');
        drawnow;
    end

    if sqrt((pos.x(end)-rf(1))^2+(pos.y(end)-rf(2))^2)<1e-5 &&...
            abs(theta.Sd(end)) < .01 && abs(theta.Ed(end)) < .01
        break
    end
end
out.pos     = pos;
% out.muscles = muscles;
out.theta   = theta;

pos_error = sqrt((pos.x(end)-rf(1))^2+(pos.y(end)-rf(2))^2);

muscle_nums = {'an','bs','br','da','dp','pc','bb','tb'};
% force_tot = 0;
% for k = 1:8
%    force_tot = force_tot + sum(out.muscles.(muscle_nums{k}).force); 
% end
out.pos_error = pos_error;
% out.force_tot = force_tot;
torque_tot = sum(x(:,1).^2)+sum(x(:,2).^2);
out.force_tot = torque_tot;

error = (pos_error+1)^10 + (torque_tot+1)^2;

% animate_position;
