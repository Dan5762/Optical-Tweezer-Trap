function beam_fields = beam(R, Z, radialTrapDepth, axialTrapDepth, radialWaist, axialWaist, wavelength)
    % z0 parameter for each beam (defined in equation 3)
    z0_r = (pi .* radialWaist.^2) ./ wavelength;
    z0_z = (pi .* axialWaist.^2) ./ wavelength;

    % Waist size of each beam (defined in equation 2)
    W_r = radialWaist .* sqrt(1 + (R.^2 ./ z0_r.^2));
    W_z = axialWaist .* sqrt(1 + (Z.^2 ./ z0_z.^2));
 
    % Beam potentials (defined in equation 5)
    U_r = -radialTrapDepth .* (exp((-2 .* Z.^2) ./ (W_r.^2)) ./ (1 + (R ./ z0_r).^2));
    U_z = -axialTrapDepth .* (exp((-2 .* R.^2) ./ (W_z.^2)) ./ (1 + (Z ./ z0_z).^2));
    U = U_r + U_z;

    % Force due to radial beam (defined in equation 6)
    Fr_r = radialTrapDepth .* ((4 .* Z.^2 .* R) ./ (radialWaist.^2 .* z0_r.^2 .* (1 + (R ./ z0_r).^2).^3) - ((2 .* R) ./ (z0_r.^2 .* (1 + (R ./ z0_r).^2).^2))) .* exp((-2 .* Z.^2) ./ (W_r.^2));
    Fz_r = radialTrapDepth .* ((-4 .* Z) ./ (radialWaist.^2 .* (1 + (R ./ z0_r).^2))) .* exp((-2 .* Z.^2) ./ (W_r.^2));

    % Force due to axial beam (defined in equation 6)
    Fz_z = axialTrapDepth .* ((4 .* R.^2 .* Z) ./ (axialWaist.^2 .* z0_z.^2 .* (1 + (Z ./ z0_z).^2).^3) - ((2 .* Z) ./ (z0_z.^2 .* (1 + (Z ./ z0_z).^2).^2))) .* exp((-2 .* R.^2) ./ (W_z.^2));
    Fr_z = axialTrapDepth .* ((-4 .* R) ./ (axialWaist.^2 .* (1 + (Z ./ z0_z).^2))) .* exp((-2 .* R.^2) ./ (W_z.^2));
    
    % Total forces in radial and axial directions
    Fr = Fr_r + Fr_z;
    Fz = Fz_r + Fz_z;

    beam_fields = {U, Fr, Fz};
end