function particles = init_fig(ax, R, Z, I, particles)
    % INIT_FIG  Initialises surface plot of potential and particles
    surf(ax, R, Z, I, 'FaceAlpha', 0.5);
    drawnow
    xlabel(ax, 'Radial Position, m')
    ylabel(ax, 'Axial Position, m')
    zlabel(ax, 'Particle Potential, J')
    xlim(ax, [min(R, [], 'all') max(R, [], 'all')])
    ylim(ax, [min(Z, [], 'all') max(Z, [], 'all')])

    hold(ax, 'on')
    for i = 1:length(particles)
        particles(i).plot_point = scatter3(ax,particles(i).position(1, 1), particles(i).position(1, 2), particles(i).potential(1),100 * particles(i).mass,'o','filled');
    end
    hold(ax, 'off')
end