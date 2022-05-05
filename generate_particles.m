function particles = generate_particles(n, T, v_spread, mass_spread, radialTrapDepth, axialTrapDepth, radialWaist, axialWaist, wavelength)
    % GENERATE_PARTICLES  Randomly generates a set of particles according
    % to the user defined properties
    particles = struct('position', {}, 'velocity', {}, 'mass', {});
    for i = 1:n
        particles(i).position = [randn(1), randn(1)];
        particles(i).velocity = v_spread .* [randn(1), randn(1)];
        particles(i).mass = mass_spread .* rand;
    end

    % Compute trajectories using eval_trajectories subroutine
    particles = eval_trajectories(particles, T, radialTrapDepth, axialTrapDepth, radialWaist, axialWaist, wavelength);
end