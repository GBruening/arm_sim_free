
figure(1);
for k = 1:length(theta.E)
    clf(1);hold on;
    xlim([-upperarm.length-forearm.length upperarm.length+forearm.length]);
    ylim([-upperarm.length-forearm.length upperarm.length+forearm.length]);
    x1 = upperarm.length * cos(theta.S(k));
    
    y1 = upperarm.length * sin(theta.S(k));
    
    x2 = upperarm.length * cos(theta.S(k)) + ...
        forearm.length * cos(theta.S(k)+theta.E(k));
    
    y2 = upperarm.length * sin(theta.S(k)) + ...
        forearm.length * sin(theta.S(k)+theta.E(k));
    plot([0,x1],[0,y1], 'color', 'blue');
    plot([x1,x2],[y1,y2], 'color', 'blue');
    drawnow;
end