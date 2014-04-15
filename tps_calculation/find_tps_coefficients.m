% FIND_TPS_COEFFICIENTS - Given a set of control points and their
% displacements, compute the coefficients of the TPS interpolant f(S)
% deforming surface S.
%
% Usage:    [mapping_coeffs, poly_coeffs] = ...
%           find_tps_coefficients(control_points, displacemets);
%
% Arguments:
%           control_points - p by d vector of control points.
%           displacemets   - p by d vector of displacements of
%                            corresponding control points in the mapping
%                            function f(S).
%
% Returns:
%           mapping_coeffs - p by d vector of TPS mapping coefficients.
%           poly_coeffs    - d+1 by d vector of TPS polynomial weights.
%
% References:
%           1. http://en.wikipedia.org/wiki/Polyharmonic_spline
%           2. http://en.wikipedia.org/wiki/Thin_plate_spline 
%
% Author:
% Daeyun Shin
% dshin11@illinois.edu  daeyunshin.com
%
% April 2014
function [mapping_coeffs, poly_coeffs] = ...
    find_tps_coefficients(control_points, displacements)

p = size(control_points, 1);
d = size(control_points, 2);

assert(size(displacements, 1) == p, ...
    'ERROR: size(control_points, 1) must equal size(displacements, 1)');
assert(size(displacements, 2) == d, ...
    'ERROR: size(control_points, 2) must equal size(displacements, 2)');

% r_mat(i, j) is the Euclidean distance between control_points(i, :) and
% control_points(j, :).
r_mat = pdist2(control_points, control_points);

% Thin plate spline radial basis function phi(r) = r^2*log(r).
% This correcponds to the matrix A from [1].
A = zeros(size(r_mat));
ge1_ind = r_mat>=1;
lt1_ind = r_mat<1;
A(ge1_ind) = r_mat(ge1_ind).^2 .* log(r_mat(ge1_ind));
A(lt1_ind) = r_mat(lt1_ind) .* log(r_mat(lt1_ind).^r_mat(lt1_ind));

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