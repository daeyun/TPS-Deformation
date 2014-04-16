% PAIRWISE_RADIAL_BASIS - Compute the TPS radial basis function phi(r)
% between every row-pair of A and B where r is the Euclidean distance.
%
% Usage:    P = pairwise_radial_basis(A, B)
%
% Arguments:
%           A - n by p vector containing n p-dimensional points. 
%           B - n by q vector containing n q-dimensional points. 
%
% Returns:
%           P - P(i, j) = phi(norm(A(i,:)-B(j,:))) where
%                         phi(r) = r^2*log(r) for r >= 1
%                                  r*log(r^r) for r <  1
%
% References:
%           1. https://en.wikipedia.org/wiki/Polyharmonic_spline
%           2. https://en.wikipedia.org/wiki/Radial_basis_function
%
% Author:
% Daeyun Shin
% dshin11@illinois.edu  daeyunshin.com
%
% April 2014
function P = pairwise_radial_basis(A, B)

% r_mat(i, j) is the Euclidean distance between A(i, :) and B(j, :).
r_mat = pdist2(A, B);

% P correcponds to the matrix A from [1].
P = zeros(size(r_mat));

pwise_cond_ind1 = r_mat>=1;
pwise_cond_ind2 = r_mat<1;
r_mat_p1 = r_mat(pwise_cond_ind1);
r_mat_p2 = r_mat(pwise_cond_ind2);

P(pwise_cond_ind1) = (r_mat_p1.^2) .* log(r_mat_p1);
P(pwise_cond_ind2) = r_mat_p2 .* (log(r_mat_p2.^r_mat_p2));

end