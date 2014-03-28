figure(1); clf; hold on;
axis equal;
axis([-1 1 -1 1 -1 1]);
set(gcf, 'renderer', 'opengl');
set(gca, 'CameraPosition', [400 -400 400]);

[X, Y] = meshgrid(-1:0.1:1, -1:0.1:1);
Z = zeros(21);

d = [0.1+0.1, 0.15-0.1, 0.1];

%X(13, 13) = X(13, 13) + d(1);
%Y(13, 13) = Y(13, 13) + d(2);
%Z(13, 13) = Z(13, 13) + d(3);

% Z = exp((-X.^2 - Y.^2)*10);
% Z = Z + exp((-(X+0.45).^2 - (Y+0.45).^2)*10);

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

[X, Y, Z] = deform_surface(X, Y, Z, control_points, mapping_coeffs, 3);

surface(X, Y, Z);

drawPoint3d(control_points, 'color', 'blue');
drawPoint3d(control_points + mapping_coeffs, 'color', 'red');


drawEdge(horzcat(control_points, control_points + mapping_coeffs), 'color', 'r', 'linewidth', 2);


% dp2_ = [0.1, -0.1, 0.1];
% dpoints_ = [dp2_];
% 
% lines = createLine3d(control_points + mapping_coeffs, control_points + mapping_coeffs + dpoints_);
% drawLine3d(lines, 'color', 'k');
