
mycluster=parcluster('local');
mycluster.NumWorkers=num_workers;
parpool(num_workers);

lb = zeros(18*8,1);
ub = lb + 1e-2;

options = optimoptions(@particleswarm,...
    'UseParallel',1);
animate = 0;
[x,fval,exitflag,output] = ...
    particleswarm(@(x) ga_arm_sim(x,animate), 18*8, lb, ub, options);

animate = 0;
[~,out] = ps_arm_sim(x,animate);

save('ps_arm_sim.mat','x','out');

sprintf('Force tot: %0.3f',out.force_tot);
sprintf('Pos Error: %0.3f',out.pos_error);
