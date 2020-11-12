% Particle Swarm Script
clear
if isempty(gcp('nocreate'))
    if ~exist('num_workers')
        num_workers = 22;
    end
    mycluster=parcluster('local');
    mycluster.NumWorkers=num_workers;
    parpool(num_workers);
end

size1 = 30;
n_params = 8;
lb = zeros(size1*n_params,1);
ub = lb + 1;

% init_ps_u = load('init_ps_u.mat');
% init_ps_u = init_ps_u.init_ps_u;
% u = zeros(size,8);
% names = fieldnames(init_ps_u);
% for k = 1:8
%     times = [0:0.0025:0.0025*(length(init_ps_u.(names{k}))-1)];
%     times_new = [0:0.0050:0.0050*(size-1)];
%     u(:,k) = interp1(times,init_ps_u.(names{k}),times_new);
% end

options = optimoptions(@particleswarm,...
    'UseParallel',true,...
    'Display','iter',...
    'SwarmSize', 20000,...
    'PlotFcn',@pswplotbestf);%,...
%     'InitialSwarmMatrix', zeros(1,8*size));
%     'InitialSwarmMatrix', reshape(u,[1,600*8]));

animate = 0;
size2 = size1*n_params;

[x,fval,exitflag,output] = ...
    particleswarm(@(x) ga_arm_sim(x,size1,animate), size2, lb, ub, options);

animate = 1;
[~,out] = ga_arm_sim(x,size1,animate);

f_name = strcat('ps_arm_sim_torque',date,'_',options.SwarmSize,'.mat');
save(f_name,'x','out');


fprintf('Force tot: %0.3f\n',out.force_tot);
fprintf('Pos Error: %0.3f\n',out.pos_error);

% delete(gcp('nocreate'));
