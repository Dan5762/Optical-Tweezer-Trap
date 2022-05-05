function tweezerApp(app)
    % Tweezer App simulates the motion of particles in an optical dipole
    % trap
    subindex = @(A, i) A{i}; % Function for extracting single ouput of function call

    % Create simulation UI
    fig = uifigure('Position', [50 200 1400 800]);
    fig.Name = "Tweezer Trap";

    % Initialise simulation parameters
    data.runSim = true;
    data.startStopText = "Stop";
    data.nParticles = 5;
    data.vSpread = 1;
    data.mSpread = 1;
    data.axialTrapDepth = 1.5;
    data.radialTrapDepth = 0.1;
    data.axialWaist = 1;
    data.radialWaist = 1;
    data.wavelength = 1;
    data.rRange = 5;
    data.zRange = 5;
    data.duration = 5;
    data.reset = false;
    data.restart = false;
    guidata(fig, data)

    % Create main grid layout for UI
    gl = uigridlayout(fig, [2 3], 'Scrollable', 'on');
    gl.RowHeight = {'fit','fit'};
    gl.ColumnWidth = {'3x','1x','1x'};

    % Create panel for visualising the simulation, showing the surface plot
    % and the simulation duration
    plot_panel = uipanel(gl);
    plot_panel.Title = "Simulation";
    plot_panel.Layout.Row = [1 2];
    plot_panel.Layout.Column = 1;
    plot_panel_gl = uigridlayout(plot_panel, [2 1]);
    plot_panel_gl.RowHeight = {695, 30};

    ax = uiaxes(plot_panel_gl);
    ax.Layout.Row = 1;
    ax.Layout.Column = 1;

    time_lbl = uilabel(plot_panel_gl);
    time_lbl.Layout.Row = 2;
    time_lbl.Layout.Column = 1;
    time_lbl.Text = 'Simulation Duration: 0 seconds';

    % Create panel for the particle properties controls
    particle_panel = uipanel(gl);
    particle_panel.Title = "Particle Properties";
    particle_panel.Layout.Row = 1;
    particle_panel.Layout.Column = 2;
    particle_panel_gl = uigridlayout(particle_panel, [6 1]);
    particle_panel_gl.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit', 'fit'};

    n_particle_lbl = uilabel(particle_panel_gl);
    n_particle_lbl.Layout.Row = 1;
    n_particle_lbl.Layout.Column = 1;
    n_particle_lbl.Text = "Particle Count";

    n_particle_sld = uislider(particle_panel_gl);
    n_particle_sld.Layout.Row = 2;
    n_particle_sld.Layout.Column = 1;
    n_particle_sld.Value = data.nParticles;
    n_particle_sld.Limits = [1 100];
    n_particle_sld.ValueChangedFcn = {@changeNParticles};

    v_spread_lbl = uilabel(particle_panel_gl);
    v_spread_lbl.Layout.Row = 3;
    v_spread_lbl.Layout.Column = 1;
    v_spread_lbl.Text = "Velocity Spread";

    v_spread_sld = uislider(particle_panel_gl);
    v_spread_sld.Layout.Row = 4;
    v_spread_sld.Layout.Column = 1;
    v_spread_sld.Value = data.vSpread;
    v_spread_sld.Limits = [0 5];
    v_spread_sld.ValueChangedFcn = {@changeVSpread};

    v_spread_lbl = uilabel(particle_panel_gl);
    v_spread_lbl.Layout.Row = 5;
    v_spread_lbl.Layout.Column = 1;
    v_spread_lbl.Text = "Mass Spread";

    v_spread_sld = uislider(particle_panel_gl);
    v_spread_sld.Layout.Row = 6;
    v_spread_sld.Layout.Column = 1;
    v_spread_sld.Value = data.mSpread;
    v_spread_sld.Limits = [0.1 5];
    v_spread_sld.ValueChangedFcn = {@changeMSpread};


    % Create panel for the trap properties controls
    trap_panel = uipanel(gl);
    trap_panel.Title = "Trap Properties";
    trap_panel.Layout.Row = 2;
    trap_panel.Layout.Column = 2;
    trap_panel_gl = uigridlayout(trap_panel, [10 1]);
    trap_panel_gl.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit'};

    n_particle_lbl = uilabel(trap_panel_gl);
    n_particle_lbl.Layout.Row = 1;
    n_particle_lbl.Layout.Column = 1;
    n_particle_lbl.Text = "Axial Trap Depth";

    n_particle_sld = uislider(trap_panel_gl);
    n_particle_sld.Layout.Row = 2;
    n_particle_sld.Layout.Column = 1;
    n_particle_sld.Value = data.axialTrapDepth;
    n_particle_sld.Limits = [0 2];
    n_particle_sld.ValueChangedFcn = {@changeAxialTrapDepth};

    n_particle_lbl = uilabel(trap_panel_gl);
    n_particle_lbl.Layout.Row = 3;
    n_particle_lbl.Layout.Column = 1;
    n_particle_lbl.Text = "Radial Trap Depth";

    n_particle_sld = uislider(trap_panel_gl);
    n_particle_sld.Layout.Row = 4;
    n_particle_sld.Layout.Column = 1;
    n_particle_sld.Value = data.radialTrapDepth;
    n_particle_sld.Limits = [0 2];
    n_particle_sld.ValueChangedFcn = {@changeRadialTrapDepth};

    n_particle_lbl = uilabel(trap_panel_gl);
    n_particle_lbl.Layout.Row = 5;
    n_particle_lbl.Layout.Column = 1;
    n_particle_lbl.Text = "Axial Beam Waist Size";

    n_particle_sld = uislider(trap_panel_gl);
    n_particle_sld.Layout.Row = 6;
    n_particle_sld.Layout.Column = 1;
    n_particle_sld.Value = data.axialWaist;
    n_particle_sld.Limits = [0.2 2];
    n_particle_sld.ValueChangedFcn = {@changeAxialWaist};

    n_particle_lbl = uilabel(trap_panel_gl);
    n_particle_lbl.Layout.Row = 7;
    n_particle_lbl.Layout.Column = 1;
    n_particle_lbl.Text = "Radial Beam Waist Size";

    n_particle_sld = uislider(trap_panel_gl);
    n_particle_sld.Layout.Row = 8;
    n_particle_sld.Layout.Column = 1;
    n_particle_sld.Value = data.radialWaist;
    n_particle_sld.Limits = [0.2 2];
    n_particle_sld.ValueChangedFcn = {@changeRadialWaist};

    n_particle_lbl = uilabel(trap_panel_gl);
    n_particle_lbl.Layout.Row = 9;
    n_particle_lbl.Layout.Column = 1;
    n_particle_lbl.Text = "Beam Wavelength";

    n_particle_sld = uislider(trap_panel_gl);
    n_particle_sld.Layout.Row = 10;
    n_particle_sld.Layout.Column = 1;
    n_particle_sld.Value = data.wavelength;
    n_particle_sld.Limits = [0.2 2];
    n_particle_sld.ValueChangedFcn = {@changeWavelength};


    % Create panel for the simulation properties controls
    grid_panel = uipanel(gl);
    grid_panel.Title = "Simulation Properties";
    grid_panel.Layout.Row = 1;
    grid_panel.Layout.Column = 3;
    grid_panel_gl = uigridlayout(grid_panel, [6 1]);
    grid_panel_gl.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit', 'fit'};

    radial_range_lbl = uilabel(grid_panel_gl);
    radial_range_lbl.Layout.Row = 1;
    radial_range_lbl.Layout.Column = 1;
    radial_range_lbl.Text = "Radial Range";

    radial_range_sld = uislider(grid_panel_gl);
    radial_range_sld.Layout.Row = 2;
    radial_range_sld.Layout.Column = 1;
    radial_range_sld.Value = data.rRange;
    radial_range_sld.Limits = [1 10];
    radial_range_sld.ValueChangedFcn = {@changeRRange};

    axial_range_lbl = uilabel(grid_panel_gl);
    axial_range_lbl.Layout.Row = 3;
    axial_range_lbl.Layout.Column = 1;
    axial_range_lbl.Text = "Axial Range";

    axial_range_sld = uislider(grid_panel_gl);
    axial_range_sld.Layout.Row = 4;
    axial_range_sld.Layout.Column = 1;
    axial_range_sld.Value = data.zRange;
    axial_range_sld.Limits = [1 10];
    axial_range_sld.ValueChangedFcn = {@changeZRange};

    axial_range_lbl = uilabel(grid_panel_gl);
    axial_range_lbl.Layout.Row = 5;
    axial_range_lbl.Layout.Column = 1;
    axial_range_lbl.Text = "Simulation Duration";

    axial_range_sld = uislider(grid_panel_gl);
    axial_range_sld.Layout.Row = 6;
    axial_range_sld.Layout.Column = 1;
    axial_range_sld.Value = data.duration;
    axial_range_sld.Limits = [1 60];
    axial_range_sld.ValueChangedFcn = {@changeDuration};


    % Create panel for the simulation buttons
    button_panel = uipanel(gl);
    button_panel.Layout.Row = 2;
    button_panel.Layout.Column = 3;
    button_panel_gl = uigridlayout(button_panel, [2 1]);
    button_panel_gl.RowHeight = {'fit', 'fit'};

    startStopBtn = uibutton(button_panel_gl);
    startStopBtn.Layout.Row = 1;
    startStopBtn.Layout.Column = 1;
    startStopBtn.Text = data.startStopText;
    startStopBtn.ButtonPushedFcn = @startStopSim;

    resetBtn = uibutton(button_panel_gl);
    resetBtn.Layout.Row = 2;
    resetBtn.Layout.Column = 1;
    resetBtn.Text = "Restart";
    resetBtn.ButtonPushedFcn = @restartSim;
 
    % Run the simulation subroutine to generate the particles and their
    % dynamics
    [R, Z, I, particles] = simulate_system(data.nParticles, data.duration, data.rRange, data.zRange, data.vSpread, data.mSpread, data.radialTrapDepth, data.axialTrapDepth, data.radialWaist, data.axialWaist, data.wavelength);

   % Initialise the surface plot of the simulation
    particles = init_fig(ax, R, Z, I, particles);

    % When first plotted the surface plot's colour map is a uniform, likely
    % a matlab bug, replotting the surface at least once seems to fix the
    % issue (most of the time)
    first_plot = true;

    % Loop simulated duration
    i = 0;
    while true
        tic
        data = guidata(fig);
    
        if data.restart
            i = 0;
            data.restart = false;
            guidata(fig, data)
        end
        
        if (data.reset || first_plot)
            % Reset simulation by recalculating the dynamics reinitialising
            % the visualisation
            t1 = tic;
            [R, Z, I, particles] = simulate_system(data.nParticles, data.duration, data.rRange, data.zRange, data.vSpread, data.mSpread, data.radialTrapDepth, data.axialTrapDepth, data.radialWaist, data.axialWaist, data.wavelength);
            toc(t1);
            particles = init_fig(ax, R, Z, I, particles);
            i = 0;
            data.reset = false;
            guidata(fig, data)
            first_plot = false;
        end
        
        if data.runSim
            for j = 1:size(particles, 2)
                % Update particle positions
                set(particles(j).plot_point, 'XData', particles(j).position(i+1, 1), 'YData', particles(j).position(i+1, 2), 'ZData', particles(j).potential(i+1));
            end
            % Update iteration counter (loop over simulation duration)
            i = mod(i + 1, size(particles(1).position, 1));
        end
        % Update simulation duration UI label
        set(time_lbl, 'Text', "Simulation Duration: " + num2str(i .* 0.02) + " seconds");
        drawnow

        loop_duration = toc;
        if loop_duration < 0.02
            % Log elapsed time and prevent loop from running faster than real
            % time (will run more slowly if updating points takes more than
            % 0.02 seconds
            pause(0.02 - loop_duration)
        end
    end
    
end


% Callback functions for updating state after user interaction
function startStopSim(src, event)
    data = guidata(src);
    if data.runSim
        data.runSim = false;
        data.startStopText = "Start";
    else
        data.runSim = true;
        data.startStopText = "Stop";
    end
    guidata(src, data)
end

function restartSim(src, event)
    data = guidata(src);
    data.restart = true;
    guidata(src, data)
end

function changeNParticles(src, event)
    data = guidata(src);
    data.nParticles = round(event.Value);
    data.reset = true;
    guidata(src, data)
end

function changeVSpread(src, event)
    data = guidata(src);
    data.vSpread = event.Value;
    data.reset = true;
    guidata(src, data)
end

function changeMSpread(src, event)
    data = guidata(src);
    data.mSpread = event.Value;
    data.reset = true;
    guidata(src, data)
end

function changeAxialTrapDepth(src, event)
    data = guidata(src);
    data.axialTrapDepth = event.Value;
    data.reset = true;
    guidata(src, data)
end

function changeRadialTrapDepth(src, event)
    data = guidata(src);
    data.radialTrapDepth = event.Value;
    data.reset = true;
    guidata(src, data)
end

function changeAxialWaist(src, event)
    data = guidata(src);
    data.axialWaist = event.Value;
    data.reset = true;
    guidata(src, data)
end

function changeRadialWaist(src, event)
    data = guidata(src);
    data.radialWaist = event.Value;
    data.reset = true;
    guidata(src, data)
end

function changeWavelength(src, event)
    data = guidata(src);
    data.wavelength = event.Value;
    data.reset = true;
    guidata(src, data)
end

function changeRRange(src, event)
    data = guidata(src);
    data.rRange = event.Value;
    data.reset = true;
    guidata(src, data)
end

function changeZRange(src, event)
    data = guidata(src);
    data.zRange = event.Value;
    data.reset = true;
    guidata(src, data)
end

function changeDuration(src, event)
    data = guidata(src);
    data.duration = event.Value;
    data.reset = true;
    guidata(src, data)
end