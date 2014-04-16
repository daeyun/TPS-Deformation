control_points = [[ 0     0     0];
                  [-0.4   0     0.5];
                  [ 0     0.4   0];
                  [ 0.1   0.4  -0.3]];

A = pairwise_radial_basis(control_points, control_points);

% Make sure the matrix structure makes sense
assert(A(1, 1) == 0);
assert(A(1, 2) == A(2, 1));
assert(A(3, 4) == A(4, 3));

% Test the piecewise function phi(r)
r = sum((control_points(1,:) - control_points(2,:)).^2).^(0.5);
assert(r < 1, 'r < 0 failed');
assert(A(1, 2) == r*log(r^r), 'P(1, 2) must be equal to r*log(r^r)');

r = sum((control_points(2,:) - control_points(4,:)).^2).^(0.5);
assert(r >= 1, 'r >= 1 failed');
assert(A(2, 4) == r^2*log(r), 'P(2, 4) must be equal to r^2*log(r)');

p = size(control_points, 1);

% V(:, i) must contain [1; Cix, Ciy, Ciz]
V = [ones(p, 1), control_points]';
assert(isequal(V(:,1), [1;control_points(1,:)']));
assert(isequal(V(:,2), [1;control_points(2,:)']));