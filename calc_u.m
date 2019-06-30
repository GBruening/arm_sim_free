function [u] = calc_u(theta,muscles,m)
    
    muscle_nums = {'an','bs','br','da','dp','pc','bb','tb'};
    
    in = [theta.S(end),...
          theta.E(end)];
    for k = 1:8
        in = [in,...
              muscles.(muscle_nums{k}).norm_length(end),...
              muscles.(muscle_nums{k}).v(end)...
%               muscles.(muscle_nums{k}).force,...
              ];
    end
    u = in*m;
    
end

