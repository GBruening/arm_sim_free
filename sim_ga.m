% Genetic Algorithm Script
clear
if isempty(gcp('nocreate'))
    if ~exist('num_workers')
        num_workers = 22;
    end
    mycluster=parcluster('local');
    mycluster.NumWorkers=num_workers;
    parpool(num_workers);
end

% lb = zeros(18*8,1);
% ub = lb + 1;

size1 = 30;
lb = -20*ones(size1*2,1);
ub = 20*ones(size1*2,1);

pop_size = 100000;
options = optimoptions('ga',...
    'Display','iter',...
    'MaxGenerations', 500,...
    'UseParallel', true,...
    'PopulationSize', pop_size,...
    'PlotFcns', 'gaplotbestf',...
    'EliteCount', pop_size*.05,...
    'CrossoverFraction', .5,...
    'MutationFcn', {@mutationadaptfeasible, .3});

animate = 0;
size2 = size1*2;

[x,fval,exitflag,output,population,scores]...
    = ga(@(x) ga_arm_sim_torque(x,size1,animate), size2,[],[],[],[],lb,ub,[],options);

animate = 1;
[~,out] = ga_arm_sim_torque(x,size1,animate);

f_name = strcat('ga_arm_sim_torque',date,'_',options.SwarmSize,'.mat');
save(f_name,'x','out');

sprintf('Force tot: %0.3f',out.force_tot);
sprintf('Pos Error: %0.3f',out.pos_error);

delete(gcp('nocreate'));

