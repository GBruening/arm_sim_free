function [act] = calc_act(u,act,muscles,vars)

muscle_nums = {'an','bs','br','da','dp','pc','bb','tb'};

t_act = 0.05;%.050;
t_deact = 0.066;%.066;

sig = 0;
eps = 0;

for k = 1:8
    if u(k) > act.(muscle_nums{k})(end) 
        t = t_deact+u(k)*(t_act-t_deact);
    else
        t = t_deact;
    end
    a_dot = ((1+sig*eps)*u(k)-act.(muscle_nums{k})(end))/t;
    act.(muscle_nums{k}) = [act.(muscle_nums{k}),...
        act.(muscle_nums{k})(end) + vars.time_inc*a_dot];
end

end

