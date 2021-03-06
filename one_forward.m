function [error] = ga_arm_sim(m)
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
vars.time_inc = 0.0150;
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

[ muscles, act] = calc_muscle_initvars(vars,theta);

% m = (.00001).*rand(18,8);

% x=.01;
% for x = .01:.01:.10
%     theta = calc_theta(ro(1)+x,ro(2)+x,forearm,upperarm,theta);
% 
%     [muscles] = calc_muscle_l_v(theta, muscles);
% end
u = [];
elbow.torque_c = [];
shoulder.torque_c = [];

% figure(1);
while time<10
    theta = drive_to_theta(act,...
                           muscles,...
                           theta,...
                           forearm,...
                           upperarm,...
                           elbow,...
                           shoulder,...
                           vars);
                       
    [muscles] = calc_muscle_l_v(theta, muscles);
    
    u = [u;calc_u(theta,muscles,m)];
    
    act = calc_act(u(end,:),act,muscles,vars);
    
    pos = calc_endpos(theta, forearm, upperarm, pos);
    
    time = time + vars.time_inc;
    
    % Animating it
%     clf(1);hold on;
%     xlim([-upperarm.length-forearm.length upperarm.length+forearm.length]);
%     ylim([-upperarm.length-forearm.length upperarm.length+forearm.length]);
%     x1 = upperarm.length * cos(theta.S(end));
%     
%     y1 = upperarm.length * sin(theta.S(end));
%     
%     x2 = upperarm.length * cos(theta.S(end)) + ...
%         forearm.length * cos(theta.S(end)+theta.E(end));
%     
%     y2 = upperarm.length * sin(theta.S(end)) + ...
%         forearm.length * sin(theta.S(end)+theta.E(end));
%     plot([0,x1],[0,y1], 'color', 'blue');
%     plot([x1,x2],[y1,y2], 'color', 'blue');
%     drawnow;
end

error = sqrt((pos.x(end)-rf(1))^2+(pos.y(end)-rf(2))^2);

% animate_position;
