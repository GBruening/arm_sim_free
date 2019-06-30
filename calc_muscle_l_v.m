function [muscles] = calc_muscle_l_v(theta, muscles)

    muscle_nums = {'an','bs','br','da','dp','pc','bb','tb'};
    
    muscles.an.m_arm_e = [muscles.an.m_arm_e,2*polyval(muscles.an.coef_e,theta.E(end))/1000]; %Divide by 10
    muscles.bs.m_arm_e = [muscles.bs.m_arm_e,polyval(muscles.bs.coef_e,theta.E(end))/1000]; %covnert mm to
    muscles.br.m_arm_e = [muscles.br.m_arm_e,polyval(muscles.br.coef_e,theta.E(end))/1000]; %cm
    muscles.da.m_arm_s = [muscles.da.m_arm_s,polyval(muscles.da.coef_s,theta.S(end))/1000];
    muscles.dp.m_arm_s = [muscles.dp.m_arm_s,polyval(muscles.dp.coef_s,theta.S(end))/1000];
    muscles.pc.m_arm_s = [muscles.pc.m_arm_s,polyval(muscles.pc.coef_s,theta.S(end))/1000];
    muscles.bb.m_arm_s = [muscles.bb.m_arm_s,polyval(muscles.bb.coef_s,theta.S(end))/1000];
    muscles.bb.m_arm_e = [muscles.bb.m_arm_e,polyval(muscles.bb.coef_e,theta.E(end))/1000];
    muscles.tb.m_arm_s = [muscles.tb.m_arm_s,polyval(muscles.tb.coef_s,theta.S(end))/1000];
    muscles.tb.m_arm_e = [muscles.tb.m_arm_e,2*polyval(muscles.tb.coef_e,theta.E(end))/1000];

    %Divide muscle lengths by 1000 to convert mm to m
    muscles.an.length = [muscles.an.length,(polyval(muscles.an.coef_l,theta.E(end)) + 53.57)/1000];
    muscles.bs.length = [muscles.bs.length,(polyval(muscles.bs.coef_l,theta.E(end)) + 137.48)/1000];
    muscles.br.length = [muscles.br.length,(polyval(muscles.br.coef_l,theta.E(end)) + 276.13)/1000];
    muscles.da.length = [muscles.da.length,(polyval(muscles.da.coef_l,theta.S(end)) + 172.84)/1000];
    muscles.dp.length = [muscles.dp.length,(polyval(muscles.dp.coef_l,theta.S(end)) + 157.64)/1000];
    muscles.pc.length = [muscles.pc.length,(polyval(muscles.pc.coef_l,theta.S(end)) + 155.19)/1000];
    muscles.bb.length = [muscles.bb.length,(polyval(muscles.bb.coef_l,theta.E(end)) + -5.0981E-1*theta.S(end)+378.06)/1000];
    muscles.tb.length = [muscles.tb.length,(polyval(muscles.tb.coef_l,theta.E(end)) + 4.4331E-1*theta.S(end) +260.05)/1000];

    for k = 1:length(muscle_nums) %1059.7 kg/m^3
        muscles.(muscle_nums{k}).norm_length =...
            [muscles.(muscle_nums{k}).norm_length,...
            muscles.(muscle_nums{k}).length(end)/muscles.(muscle_nums{k}).l0];
    end

    time_step = 0.0025;
    for k=1:length(muscle_nums)
        ii = length(muscles.(muscle_nums{k}).length);
        muscles.(muscle_nums{k}).v =...
            [muscles.(muscle_nums{k}).v,...
            (muscles.(muscle_nums{k}).length(ii)-...
            muscles.(muscle_nums{k}).length(ii-1))./...
            (muscles.(muscle_nums{k}).l0*time_step)];
    end
end

