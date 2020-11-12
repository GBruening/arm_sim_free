% function [error,out] = ga_arm_sim(animate)
animate  = 1;
% x = x*1e-6;
% x = reshape(x,[18,8]);
format long
<<<<<<< HEAD
=======
time = 0;
>>>>>>> master

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
vars.time_inc = 0.0050;
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

u = [];
elbow.torque_c = [];
shoulder.torque_c = [];

if animate
    figure(1);
end
<<<<<<< HEAD
count = 0;
for time = [0:0.005:10]
    if mod(time,5) <= 1e-4
        fprintf('T = %g\n',time);
    end
    count = count + 1;
=======
while time<10
>>>>>>> master
    [theta, muscles, shoulder, elbow] = drive_to_theta(act,...
                           muscles,...
                           theta,...
                           forearm,...
                           upperarm,...
                           elbow,...
                           shoulder,...
                           vars);
                       
    [muscles] = calc_muscle_l_v(theta, muscles);
    
<<<<<<< HEAD
    if exist('act','var')
        u = [u;calc_u_forcing(u,act,count, shoulder, elbow, theta)];
    else
        u = [u;calc_u_forcing(u,[],count, shoulder, elbow, theta)];
    end
%     u = [u;betarnd(5,5,[1,8])];
%     u = [u;rand(1,8)];
=======
%     u = [u;calc_u(theta,muscles,shoulder,elbow)];
%     u = [u;betarnd(5,5,[1,8])];
    u = [u;rand(1,8)];
>>>>>>> master
    
    act = calc_act(u(end,:),act,muscles,vars);
    
    pos = calc_endpos(theta, forearm, upperarm, pos);
<<<<<<< HEAD
    if mod(time,.005)~= 0
        1;
    end
    
    if animate
        % Animating it
        figure(1);clf(1);hold on;
=======
    
    time = time + vars.time_inc;
    
    if animate
        % Animating it
        clf(1);hold on;
>>>>>>> master
        xlim([.6*(-upperarm.length-forearm.length) .5*(upperarm.length+forearm.length)]);
        ylim([-0.1 upperarm.length+forearm.length]);
        x1 = upperarm.length * cos(theta.S(end));

        y1 = upperarm.length * sin(theta.S(end));

        x2 = upperarm.length * cos(theta.S(end)) + ...
            forearm.length * cos(theta.S(end)+theta.E(end));

        y2 = upperarm.length * sin(theta.S(end)) + ...
            forearm.length * sin(theta.S(end)+theta.E(end));
        plot([0,x1],[0,y1], 'color', 'blue');
        plot([x1,x2],[y1,y2], 'color', 'blue');
        drawnow;
<<<<<<< HEAD
        
=======
>>>>>>> master
    end

    if sqrt((pos.x(end)-rf(1))^2+(pos.y(end)-rf(2))^2)<1e-5 &&...
            abs(theta.Sd(end)) < .01 && abs(theta.Ed(end)) < .01
        break
    end
end
<<<<<<< HEAD

muscle_nums = {'an','bs','br','da','dp','pc','bb','tb'};
figure(6);clf(6);
subplot(2,3,3);
hold on
for k = 1:8
    plot(act.(muscle_nums{k}));
end
ax = gca;
legend(muscle_nums);
xlabel('Time');
ylabel('Activation State');
xticklabels({ax.XTick*vars.time_inc});

subplot(2,3,6);
hold on
for k = 1:8
    plot(u(:,k));
end
legend(muscle_nums);
xlabel('Time');
ylabel('Neural Drive');
xticklabels({ax.XTick*vars.time_inc});

subplot(2,3,[1,4]);
hold on
plot(shoulder.torque_c);
plot(elbow.torque_c);
legend({'Shoulder','Elbow'});
xlabel('Time');
ylabel('Joint Torque');
xticklabels({ax.XTick*vars.time_inc});

subplot(2,3,[2,5]);
hold on
plot(theta.S);
plot(theta.E);
legend({'Shoulder','Elbow'});
xlabel('Time');
ylabel('Position');
xticklabels({ax.XTick*vars.time_inc});

=======
>>>>>>> master
out.pos     = pos;
out.muscles = muscles;
out.theta   = theta;

pos_error = sqrt((pos.x(end)-rf(1))^2+(pos.y(end)-rf(2))^2);

muscle_nums = {'an','bs','br','da','dp','pc','bb','tb'};
force_tot = 0;
for k = 1:8
   force_tot = force_tot + sum(out.muscles.(muscle_nums{k}).force); 
end
out.pos_error = pos_error;
out.force_tot = force_tot;

error = pos_error*100000 + force_tot*0.0001;

% animate_position;
