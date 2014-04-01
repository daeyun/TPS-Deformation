% DEFORM_SURFACE - Given a set of control points and mapping coefficients,
%                  compute a deformed surface.
%
% Usage:    [fX, fY, fZ] = deform_surface(X, Y, Z, control_points, mapping_coeffs, epsilon)
%
% Arguments:
%           X, Y, Z        - X, Y, Z components of the surface.
%           control_points - n by 3 matrix of control points.
%           mapping_coeffs - n by 3 matrix of displacements of
%                            corresponding control points in the mapping
%                            function f(x).
%           epsilon        - width of the Gaussian radial basis function.
%                            See https://en.wikipedia.org/wiki/Radial_basis_function
%
% Returns:
%           fX, fY, fZ     - X, Y, Z components of the deformed surface.
%
% Author:
% Daeyun Shin
% dshin11@illinois.edu  daeyunshin.com
%
% March 2014

function [ fX, fY, fZ ] = deform_surface(X, Y, Z, control_points, mapping_coeffs, epsilon)
    assert(isequal(size(X), size(Y)) && isequal(size(Y), size(Z)), ...
        'size(X) must equal size(Y) and size(Z).');
    assert(isequal(size(control_points), size(mapping_coeffs)), ...
        'size(control_points) must equal size(mapping_coeffs).');

    mesh_mat = cat(3, X, Y, Z);
    output_mat = mesh_mat;

    for i = 1:size(control_points, 1)
        [h, w] = size(X);
        control_point_mat = repmat(reshape(control_points(i, :), [1 1 3]), [h w 1]);

        % Euclidean distance
        r_mat = sqrt(sum((mesh_mat - control_point_mat).^2, 3));

        % Gaussian radial basis function
        radial_basis_mat = repmat(exp(-(epsilon*r_mat).^2),[1 1 3]);

        mapping_coeff_mat = repmat(reshape(mapping_coeffs(i, :), [1 1 3]), [h w 1]);
        output_mat = output_mat + radial_basis_mat .* mapping_coeff_mat;
    end

    fX = output_mat(:,:,1);
    fY = output_mat(:,:,2);
    fZ = output_mat(:,:,3);
end