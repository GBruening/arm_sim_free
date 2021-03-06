% if ~exist('num_workers','var')
%     num_workers = 6;
% end
% mycluster=parcluster('local');
% mycluster.NumWorkers=num_workers;
% parpool(num_workers);

lb = zeros(18*8,1);
ub = lb + 10;
pop_size = 10000;
options = optimoptions('ga',...
    'Display','iter',...
    'MaxGenerations', 50,...
    'UseParallel', true,...
    'PopulationSize', pop_size,...
    'PlotFcns', 'gaplotbestf',...
    'EliteCount', pop_size*.05,...
    'CrossoverFraction', .5,...
    'MutationFcn', {@mutationadaptfeasible, .3});

animate = 0;
[x,fval,exitflag,output,population,scores]...
    = ga(@(x) ga_arm_sim(x,animate),18*8,[],[],[],[],lb,ub,[],options);

animate = 0;
[~,out] = ga_arm_sim(x,animate);

save('ga_arm_sim.mat','x','out');

sprintf('Force tot: %0.3f',out.force_tot);
sprintf('Pos Error: %0.3f',out.pos_error);
