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
n_params = 2;
lb = 0*ones(size1*n_params,1);
ub = 1*ones(size1*n_params,1);

options = optimoptions(@particleswarm,...
    'UseParallel',true,...
    'Display','iter',...
    'SwarmSize', 5000,...
    'PlotFcn',@pswplotbestf);%,...
%     'InitialSwarmMatrix', zeros(1,8*size));
%     'InitialSwarmMatrix', reshape(u,[1,600*8]));

animate = 0;
size2 = size1*n_params;

[x,fval,exitflag,output] = ...
    particleswarm(@(x) ga_arm_sim_torque(x,size1,animate), size2, lb, ub, options);

animate = 1;
[~,out] = ga_arm_sim_torque(x,size1,animate);

f_name = strcat('ps_arm_sim_torque',date,'_',options.SwarmSize,'.mat');
save(f_name,'x','out');


fprintf('Force tot: %0.3f\n',out.force_tot);
fprintf('Pos Error: %0.3f\n',out.pos_error);

delete(gcp('nocreate'));
