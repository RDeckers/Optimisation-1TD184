function [ b, w ] = optimize( n )
%OPTIMIZE Summary of this function goes here
%   Detailed explanation goes here
    q = 10*ones(n,1);
    rho = 7800;
    a = 3e-3;
    dL = 1/n;
    b0 = ones(n,1);
    maximum_deflection = 12e-3;
    function [norm] = objective_function(b)
    %minimize b subject to |w|_max < constraint
        %M = build_matrix(b);
        %Q = q+dL*a*rho*b;
        %w = M\Q;
        %norm = w;
        norm = sum(b);
    end
    function [w] = compute_w(b)
        M = build_matrix(b);
        Q = q+dL*a*rho*b;
        w = M\Q;
    end
    function [bound, equality] = constraint(b)
        w = compute_w(b);
        bound = max(abs(w))-maximum_deflection;
        equality = [];
    end
    %w = lsqnonlin(@objective_function, b0, -maximum_deflection, maximum_deflection);
    b = fmincon(@objective_function, b0, [], [], [], [], [], [], @constraint);
    w = compute_w(b);
end

