function [ b, w ] = optimize_lsqnonlin( n )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    q = -10*ones(n,1);
    rho = 7800;
    a = 3e-3;
    dL = 1/n;
    w0 = zeros(n,1);
    maximum_deflection(n:1) = 12e-3;
    function [norm] = objective_function(w)
    %minimize b subject to |w|_max < constraint
        Q = q;
        a = 3e-3;
        E = 210e9;
        c = E*a^3/12;
        D2 = build_D2(n);
        cw2 = c*D2*w
        bQ = D2\Q;
        norm = bQ./cw2 %=b
    end
    [w, b] = lsqnonlin(@objective_function, w0, -maximum_deflection, maximum_deflection);
end

