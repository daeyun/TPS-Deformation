% Compute TPS interpolation on randomly chosen control points and deform
% the surface with the computed mapping coefficients.

% number of randomly chosen control points
n_control_points = 10;


figure(1); clf; hold on;
axis equal;
axis([-1 1 -1 1 -1 1]);
set(gcf, 'renderer', 'opengl');
set(gca, 'CameraPosition', [-400 400 200]);

[X, Y] = meshgrid(-1:0.1:1, -1:0.1:1);
[h, w] = size(X);
Z = repmat((-1:0.1:1).^(3), [h 1]);


[p,q] = meshgrid(1:h, 1:w);
pairs = [p(:) q(:)];
cpoint_sub = pairs(randperm(h*w, n_control_points),:);

control_points = horzcat( ...
    X(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))), ...
    Y(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))), ...
    Z(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))));

% random displacements for the control points.
displacements = (rand(size(control_points))-0.5)*0.5;

drawPoint3d(control_points, 'color', 'blue');
drawPoint3d(control_points + displacements, 'color', 'red');
drawEdge([control_points control_points+displacements], 'color', 'r', 'linewidth', 2);

[mapping_coeffs, poly_coeffs] = ...
    find_tps_coefficients(control_points, displacements)

[fX, fY, fZ] = deform_surface_tps(X, Y, Z, control_points, mapping_coeffs, poly_coeffs);

surface(X, Y, Z)


figure(2); clf; hold on;
axis equal;
axis([-1 1 -1 1 -1 1]);
set(gcf, 'renderer', 'opengl');
set(gca, 'CameraPosition', [-400 400 200]);

drawPoint3d(control_points, 'color', 'blue');
drawPoint3d(control_points + displacements, 'color', 'red');
drawEdge([control_points control_points+displacements], 'color', 'r', 'linewidth', 2);


surface(fX, fY, fZ);