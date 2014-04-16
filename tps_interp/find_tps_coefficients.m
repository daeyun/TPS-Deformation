% FIND_TPS_COEFFICIENTS - Given a set of control points and their
% displacements, compute the coefficients of the TPS interpolant f(S)
% deforming surface S.
%
% Usage:    [mapping_coeffs, poly_coeffs] = ...
%             find_tps_coefficients(control_points, displacemets, lambda);
%
% Arguments:
%           control_points - p by d vector of control points.
%           displacemets   - p by d vector of displacements of
%                            corresponding control points in the mapping
%                            function f(S).
%           lambda         - regularization parameter. See page 4 of [3].
%
% Returns:
%           mapping_coeffs - p by d vector of TPS mapping coefficients.
%           poly_coeffs    - d+1 by d vector of TPS polynomial weights.
%
% References:
%           1. http://en.wikipedia.org/wiki/Polyharmonic_spline
%           2. http://en.wikipedia.org/wiki/Thin_plate_spline
%           3. http://cseweb.ucsd.edu/~sjb/pami_tps.pdf
%
% Author:
% Daeyun Shin
% dshin11@illinois.edu  daeyunshin.com
%
% April 2014
function [mapping_coeffs, poly_coeffs] = ...
    find_tps_coefficients(control_points, displacements, lambda)

p = size(control_points, 1);
d = size(control_points, 2);

assert(isequal(size(control_points), size(displacements)), ...
    'ERROR: size(control_points) must equal size(displacements).');

% This correcponds to the matrix A from [1].
A = pairwise_radial_basis(control_points, control_points);

% Relax the exact interpolation requirement by means of regularization. [3]
A = A + lambda * eye(size(A));

% This correcponds to V from [1].
V = [ones(p, 1), control_points]';

% Target points.
y = control_points + displacements;

M = [[A, V']; [V, zeros(d+1, d+1)]];
Y = [y;zeros(d+1, d)];

% solve for M*X = Y.
% At least d+1 control points should not be in a subspace; e.g. for d=2, at
% least 3 points are not on a straight line. Otherwise M will be singular.
X = M\Y;

mapping_coeffs = X(1:end-(d+1),:);
poly_coeffs = X((end-d):end,:);

end