function [R, Z, I, particles] = simulate_system(n_particles, duration, r_range, z_range, v_spread, mass_spread, radialTrapDepth, axialTrapDepth, radialWaist, axialWaist, wavelength)
    subindex = @(A, i) A{i};
    r = linspace(-r_range, r_range, round(r_range * 20));
    z = linspace(-z_range, z_range, round(z_range * 20));
    [R, Z] = meshgrid(r, z);
    
    I = subindex(beam(R, Z, radialTrapDepth, axialTrapDepth, radialWaist, axialWaist, wavelength), 1);
    particles = generate_particles(n_particles, duration, mass_spread, v_spread, radialTrapDepth, axialTrapDepth, radialWaist, axialWaist, wavelength);

    % Clip particle trajectories that escape potential
    for i = 1:n_particles
        pos_r_esc_idx = find(particles(i).position(:, 1) > r_range, 1, 'first');
        neg_r_esc_idx = find(particles(i).position(:, 1) < -r_range, 1, 'first');
        pos_z_esc_idx = find(particles(i).position(:, 2) > z_range, 1, 'first');
        neg_z_esc_idx = find(particles(i).position(:, 2) < -z_range, 1, 'first');

        esc_idxs = [pos_r_esc_idx, neg_r_esc_idx, pos_z_esc_idx, neg_z_esc_idx];
        if ~isempty(esc_idxs)
            esc_idx = min(esc_idxs);
            particles(i).position(esc_idx:end, 1) = particles(i).position(esc_idx, 1);
            particles(i).position(esc_idx:end, 2) = particles(i).position(esc_idx, 2);
            particles(i).potential(esc_idx:end) = particles(i).potential(esc_idx);
        end
    end
end