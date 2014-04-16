X = [[-0.4 -0.4 -0.4]; [0    0   0]; [ 0.1  0.1  0.1]];
Y = [[-0.4    0  0.4]; [-0.4 0 0.4]; [-0.4  0    0.4]];
Z = [[0.5   0.5  0.5]; [0    0   0]; [-0.3 -0.3 -0.3]];

cpoint_sub = [[2 2]; [1 2]; [2 3]; [3 3]];

cpoints = horzcat( ...
    X(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))), ...
    Y(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))), ...
    Z(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))));
% cpoints =  [[ 0     0     0];
%             [-0.4   0     0.5];
%             [ 0     0.4   0];
%             [ 0.1   0.4  -0.3]];
% assert(isequal(cpoints, cpoints2))

displacements = [[-0.2 0   0];
                 [ 0.2 0   0];
                 [ 0.1 0.1 0];
                 [ 0.1 0.1 0]];

A = pairwise_radial_basis(cpoints, cpoints);

% Make sure the matrix structure makes sense
assert(A(1, 1) == 0);
assert(A(1, 2) == A(2, 1));
assert(A(3, 4) == A(4, 3));

% Test the piecewise function phi(r)
r = sum((cpoints(1,:) - cpoints(2,:)).^2).^(0.5);
assert(r < 1, 'r < 0 failed.');
assert(A(1, 2) == r*log(r^r), 'P(1, 2) must be equal to r*log(r^r).');

r = sum((cpoints(2,:) - cpoints(4,:)).^2).^(0.5);
assert(r >= 1, 'r >= 1 failed.');
assert(A(2, 4) == r^2*log(r), 'P(2, 4) must be equal to r^2*log(r).');

p = size(cpoints, 1);
d = size(cpoints, 2);

% V(:, i) must contain [1; Cix, Ciy, Ciz]
V = [ones(p, 1), cpoints]';
assert(isequal(V(:,1), [1;cpoints(1,:)']), ...
    'V(:, 1) must contain [1; C1x, C1y, C1z].');
assert(isequal(V(:,2), [1;cpoints(2,:)']), ...
    'V(:, 2) must contain [1; C2x, C2y, C2z].');

y = cpoints + displacements;

M = [[A, V']; [V, zeros(d+1, d+1)]];
Y = [y;zeros(d+1, d)];

X = M\Y;

assert(norm(M*X - Y) < 0.01, 'M*X must be close to Y.');

mapping_coeffs = X(1:end-(d+1),:);
poly_coeffs = X((end-d):end,:);


%% test deform_surface_tps()

X = [[-0.4 -0.4 -0.4]; [0    0   0]; [ 0.1  0.1  0.1]];
Y = [[-0.4    0  0.4]; [-0.4 0 0.4]; [-0.4  0    0.4]];
Z = [[0.5   0.5  0.5]; [0    0   0]; [-0.3 -0.3 -0.3]];

cpoint_sub = [[2 2]; [1 2]; [2 3]; [3 3]];

cpoints = horzcat( ...
    X(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))), ...
    Y(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))), ...
    Z(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))));

displacements = [[-0.2 0   0];
                 [ 0.2 0   0];
                 [ 0.1 0.1 0];
                 [ 0.1 0.1 0]];

[mapping_coeffs, poly_coeffs] = ...
    find_tps_coefficients(cpoints, displacements);

% n by 3 vector containing n 3D points
surface = [reshape(X, [], 1), reshape(Y, [], 1), reshape(Z, [], 1)];

n = size(surface, 1);

A = pairwise_radial_basis(surface, cpoints);
V = [ones(n, 1), surface];
f_surface = [A V] * [mapping_coeffs; poly_coeffs];

fX = reshape(f_surface(:, 1), size(X));
fY = reshape(f_surface(:, 2), size(X));
fZ = reshape(f_surface(:, 3), size(X));

deformed_points = horzcat( ...
    fX(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))), ...
    fY(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))), ...
    fZ(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))));

assert(norm(deformed_points - (cpoints + displacements)) < 0.01, ...
    'Deformed control_points must be close to control_points+displacements');


%% test deform_surface_tps()

X = [[-0.4 -0.4 -0.4]; [0    0   0]; [ 0.1  0.1  0.1]];
Y = [[-0.4    0  0.4]; [-0.4 0 0.4]; [-0.4  0    0.4]];
Z = [[0.5   0.5  0.5]; [0    0   0]; [-0.3 -0.3 -0.3]];

cpoint_sub = [[2 2]; [1 2]; [2 3]; [3 3]];

cpoints = horzcat( ...
    X(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))), ...
    Y(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))), ...
    Z(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))));

displacements = [[-0.2 0   0];
                 [ 0.2 0   0];
                 [ 0.1 0.1 0];
                 [ 0.1 0.1 0]];

[mapping_coeffs, poly_coeffs] = ...
    find_tps_coefficients(cpoints, displacements);

[fX, fY, fZ] = deform_surface_tps(X, Y, Z, cpoints, ...
    mapping_coeffs, poly_coeffs);

deformed_points = horzcat( ...
    fX(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))), ...
    fY(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))), ...
    fZ(sub2ind(size(X), cpoint_sub(:,1), cpoint_sub(:,2))));

assert(norm(deformed_points - (cpoints + displacements)) < 0.01, ...
    'Deformed control_points must be close to control_points+displacements');