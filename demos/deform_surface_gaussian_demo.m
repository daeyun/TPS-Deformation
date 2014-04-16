% Deform a surface f(x) [1] using a Gaussian radial basis function phi(r) is as
% shown in [2].
%
% References:
%       1. http://en.wikipedia.org/wiki/Thin_plate_spline#Radial_basis_function
%       2. http://en.wikipedia.org/wiki/Radial_basis_function

figure(1); clf; hold on;
axis equal;
axis([-1 1 -1 1 -1 1]);
set(gcf, 'renderer', 'opengl');
set(gca, 'CameraPosition', [400 -400 400]);

[X, Y] = meshgrid(-1:0.1:1, -1:0.1:1);
Z = zeros(21);

p1 = [0.2, 0.2, 0];
p2 = [0.4, 0.4, 0];
p3 = [-0.4, -0.4, 0];
p4 = [-0.4, -0.6, 0];
p5 = [-0.6, 0.6, 0];
control_points = [p1; p2; p3; p4; p5];

mc1 = [0.2, 0.05, 0.1];
mc2 = [0.2, 0.05, 0.1];
mc3 = [0.2, 0.05, 0.1];
mc4 = [0.1, -0.15, -0.1];
mc5 = [0.2, 0.05, 0.1];
mapping_coeffs = [mc1; mc2; mc3; mc4; mc5];

[X, Y, Z] = deform_surface_gaussian(X, Y, Z, control_points, mapping_coeffs, 3);

surface(X, Y, Z);

drawPoint3d(control_points, 'color', 'blue');
drawPoint3d(control_points + mapping_coeffs, 'color', 'red');

drawEdge(horzcat(control_points, control_points + mapping_coeffs), 'color', 'r', 'linewidth', 2);
