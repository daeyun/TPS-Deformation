% requires geom2d and geom3d

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
    find_tps_coefficients(control_points, displacements);

[fX, fY, fZ] = deform_surface_tps(X, Y, Z, control_points, mapping_coeffs, poly_coeffs);

surface(fX, fY, fZ);


% 
% XYZ = cat(3, X, Y, Z);
% 
% point_ind = 1:441;
% 
% control_points = [X(point_ind);Y(point_ind);Z(point_ind)]';
% 
% d1 = [0.2, 0.05, 0.1];
% d2 = [-0.1, -0.05, 0.2];
% d3 = [0.2, 0.05, 0.1];
% d4 = [0.1, -0.15, -0.1];
% % d5 = [0.2, 0.05, 0.1];
% % d6 = [0.5, 0.1, 0.1];
% % d7 = [0.1, 0.05, 0.1];
% displacemets = [repmat(d1, [200 1]); repmat(d2, [241 1])];
% 
% surface(X, Y, Z);
% 
% drawPoint3d(control_points, 'color', 'blue');
% drawPoint3d(control_points + displacemets, 'color', 'red');
% 
% [mapping_coeffs, poly_coeffs] = ...
%     find_tps_coefficients(control_points, displacemets)
% 
% [fX, fY, fZ] = deform_surface_tps(X, Y, Z, control_points, mapping_coeffs, poly_coeffs);
% surface(fX, fY, fZ);
