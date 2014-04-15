% FIND_TPS_COEFFICIENTS - Given a surface S, set of control points, and
% their displacements, compute the mapping coefficients needed for the
% surface deformation function f(S).
%
% Usage:    [w, a] = find_tps_coefficients(surface, control_points, ...
%                    displacemets);
%
% Arguments:
%           surface        - n by d vector of surface points where d is the
%                            number of dimensions.
%           control_points - p by d vector of control points.
%           displacemets   - p by d vector of displacements of
%                            corresponding control points in the mapping
%                            function f(S).
%
% Returns:
%           w              - p by d vector of mapping coefficients.
%           a              - n by d+1 vector of TPS polynomial weights.
%
% Author:
% Daeyun Shin
% dshin11@illinois.edu  daeyunshin.com
%
% April 2014
function [w, a] = find_tps_coefficients(surface, control_points, displacements)
    
end