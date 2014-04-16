% DEFORM_SURFACE_TPS - Given a set of control points and mapping
% coefficients, compute a deformed surface f(S) using a thin plate spline
% radial basis function phi(r) as shown in [1].
%
% Usage:    [fX, fY, fZ] = deform_surface_tps(X, Y, Z, control_points, ...
%           mapping_coeffs, poly_coeffs)
%
% Arguments:
%           X, Y, Z        - h by w matrices of X, Y, Z components of the
%                            surface.
%           control_points - p by 3 vector of control points. Same as
%                            vector c in [1]. 
%           mapping_coeffs - p by 3 vector of weights of the basis
%                            functions. Same as vector w in [1].
%           poly_coeffs    - 4 by 3 vector of weights of the polynomial.
%                            Same as vector v in [1].
%
% Returns:
%           fX, fY, fZ     - h by w vectors of X, Y, Z compoments of the
%                            deformed surface.
%
% References:
%           1. http://en.wikipedia.org/wiki/Polyharmonic_spline
%
% Author:
% Daeyun Shin
% dshin11@illinois.edu  daeyunshin.com
%
% April 2014
function [fX, fY, fZ] = deform_surface_tps(X, Y, Z, control_points, ...
    mapping_coeffs, poly_coeffs)

assert(isequal(size(X), size(Y)) && isequal(size(Y), size(Z)), ...
    'size(X) must equal size(Y) and size(Z).');
assert(isequal(size(control_points), size(mapping_coeffs)), ...
    'size(control_points) must equal size(mapping_coeffs).');

% n by 3 vector containing n 3D points. n = h*w
surface = [reshape(X, [], 1), reshape(Y, [], 1), reshape(Z, [], 1)];

n = size(surface, 1);

A = pairwise_radial_basis(surface, control_points);
V = [ones(n, 1), surface];
f_surface = [A V] * [mapping_coeffs; poly_coeffs];

fX = reshape(f_surface(:, 1), size(X));
fY = reshape(f_surface(:, 2), size(X));
fZ = reshape(f_surface(:, 3), size(X));
    
end