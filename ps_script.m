% Particle Swarm Script
clear
if ~exist('num_workers','var')
    num_workers = 8;
end
mycluster=parcluster('local');
mycluster.NumWorkers=num_workers;
parpool(num_workers);

lb = zeros(18*8,1);
ub = lb + 1;

options = optimoptions(@particleswarm,...
    'UseParallel',true,...
    'Display','iter',...
    'SwarmSize', 100);

animate = 0;
[x,fval,exitflag,output] = ...
    particleswarm(@(x) ga_arm_sim(x,animate), 18*8, lb, ub, options);

animate = 1 ;
[~,out] = ga_arm_sim(x,animate);

save('ps_arm_sim.mat','x','out');

sprintf('Force tot: %0.3f',out.force_tot);
sprintf('Pos Error: %0.3f',out.pos_error);

delete(gcp('nocreate'));
