function [fX, fY, fZ] = deform_surface_tps(X, Y, Z, control_points, mapping_coeffs, poly_coeffs)

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
    
    radial_basis_mat = zeros(size(r_mat));
    ge1_ind = r_mat>=1;
    lt1_ind = r_mat<1;
    radial_basis_mat(ge1_ind) = r_mat(ge1_ind).^2 .* log(r_mat(ge1_ind));
    radial_basis_mat(lt1_ind) = r_mat(lt1_ind) .* log(r_mat(lt1_ind).^r_mat(lt1_ind));
    radial_basis_mat = repmat(radial_basis_mat,[1 1 3]);

    mapping_coeff_mat = repmat(reshape(mapping_coeffs(i, :), [1 1 3]), [h w 1]);
    output_mat = output_mat + radial_basis_mat .* mapping_coeff_mat;
end


a = cat(3, ones(size(X)), mesh_mat);
for i = 1:3
    b = repmat(permute(poly_coeffs(:, i), [2, 3, 1]), [size(X), 1]);
    output_mat(:,:,i) = output_mat(:,:,i) + sum(a.*b, 3);
end

fX = output_mat(:,:,1);
fY = output_mat(:,:,2);
fZ = output_mat(:,:,3);
    
end