function particles = eval_trajectories(particles, T, radialTrapDepth, axialTrapDepth, radialWaist, axialWaist, wavelength)
    % EVAL_TRAJECTORIES  Evaluate the trajecotires of a set of particles in
    % a potential created by the beam array

    subindex = @(A, i) A{i}; % Function for extracting single ouput of function call
    for i = 1:size(particles, 2)
        % Define set of coupled equations
        f = @(t,x) [x(2); subindex(beam(x(1), x(3), radialTrapDepth, axialTrapDepth, radialWaist, axialWaist, wavelength), 2) ./ particles(i).mass; x(4); subindex(beam(x(1), x(3), radialTrapDepth, axialTrapDepth, radialWaist, axialWaist, wavelength), 3) ./ particles(i).mass];
        % Solve coupled differential equations over time array
        [~, trajectories] = ode45(f, linspace(0, T, T*50), [particles(i).position(1) particles(i).velocity(1) particles(i).position(2) particles(i).velocity(2)]);
        
        particles(i).position = [trajectories(:, 1), trajectories(:, 3)];
        particles(i).velocity = [trajectories(:, 2), trajectories(:, 4)];
        % Extract beam potential at each position for later plotting
        particles(i).potential = subindex(beam(particles(i).position(:, 1), particles(i).position(:, 2), radialTrapDepth, axialTrapDepth, radialWaist, axialWaist, wavelength), 1);
    end
end