% Show TPS interpolation and deformation given a minimum number (4) of control
% points.

figure(1); clf; hold on;
axis equal;
axis([-1 1 -1 1 -1 1]);
set(gcf, 'renderer', 'opengl');
set(gca, 'CameraPosition', [-400 400 200]);

X = [[-0.4 -0.4 -0.4]; [0    0   0]; [ 0.1  0.1  0.1]];
Y = [[-0.4    0  0.4]; [-0.4 0 0.4]; [-0.4  0    0.4]];
Z = [[0.5   0.5  0.5]; [0    0   0]; [-0.3 -0.3 -0.3]];

control_points = [[0 0 0]; [-0.4 0 0.5]; [0 0.4 0]; [0.1 0.4 -0.3]];
displacements = [[-0.2 0 0]; [0.2 0 0]; [0.1 0.1 0]; [0.1 0.1 0]];

surface(X, Y, Z);

drawPoint3d(control_points, 'color', 'blue');
drawPoint3d(control_points + displacements, 'color', 'red');

[mapping_coeffs, poly_coeffs] = ...
    find_tps_coefficients(control_points, displacements, 0);

[fX, fY, fZ] = deform_surface_tps(X, Y, Z, control_points, mapping_coeffs, poly_coeffs);

surface(fX, fY, fZ);
