function [ B ] = construct_B_matrix( w )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    persistent D2;
    n = size(w,1);
    if size(D2) ~= [n n]
        disp('rebuilding matrix');
        D2 = build_D2(n);
    end
    a = 3e-3;
    E = 210e9;
    c = E*a^3/12;
    rho = 7800;
    g = -9.81;
    c2 = a*rho*g;
    x = sparse(c*D2*diag(D2*w));
    
    B = x-c2*speye(n);
end

