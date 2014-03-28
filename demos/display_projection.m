% requires geom2d and geom3d

figure(1); clf; hold on;
axis equal;
axis([-1 1 -1 1 -1 1]);
set(gcf, 'renderer', 'opengl');
set(gca, 'CameraPosition', [400 -400 400]);

[X, Y] = meshgrid(-1:0.1:1, -1:0.1:1);
Z = zeros(21);

% Z = exp((-X.^2 - Y.^2)*10);
% Z = Z + exp((-(X+0.45).^2 - (Y+0.45).^2)*10);

surface(X, Y, Z);

p1 = [0, 0, 0];
p2 = [0.5, 0.5, 0];
p3 = [0.5, -0.5, 0];
points = [p1; p2; p3];

dp1 = [0.15, 0.1, 0];
dp2 = [0.1, 0.15, 0];
dp3 = [-0.2, 0.15, 0];
dpoints = [dp1; dp2; dp3];


drawPoint3d(points, 'color', 'blue');
drawPoint3d(points + dpoints, 'color', 'red');

drawEdge(horzcat(points, points + dpoints), 'color', 'r', 'linewidth', 2);

dp1_ = [0.1, -0.1, 0.1];
dp2_ = [0.1, -0.1, 0.1];
dp3_ = [0.1, -0.1, 0.1];
dpoints_ = [dp1_; dp2_; dp3_];

lines = createLine3d(points + dpoints, points + dpoints + dpoints_);
drawLine3d(lines, 'color', 'k');