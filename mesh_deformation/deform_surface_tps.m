function [fX, fY, fZ] = deform_surface_tps(X, Y, Z, control_points, mapping_coeffs, poly_coeffs)

assert(isequal(size(X), size(Y)) && isequal(size(Y), size(Z)), ...
    'size(X) must equal size(Y) and size(Z).');
assert(isequal(size(control_points), size(mapping_coeffs)), ...
    'size(control_points) must equal size(mapping_coeffs).');

% n by 3 vector containing n 3D points
surface = [reshape(X, [], 1), reshape(Y, [], 1), reshape(Z, [], 1)];

n = size(surface, 1);

A = pairwise_radial_basis(surface, control_points);
V = [ones(n, 1), surface];
f_surface = [A V] * [mapping_coeffs; poly_coeffs];

fX = reshape(f_surface(:, 1), size(X));
fY = reshape(f_surface(:, 2), size(X));
fZ = reshape(f_surface(:, 3), size(X));
    
end