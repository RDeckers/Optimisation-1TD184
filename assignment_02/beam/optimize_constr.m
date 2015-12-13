function [ b, w, Q, sigma ] = optimize_constr( n, b0 )
%OPTIMIZE Summary of this function goes here
%   Detailed explanation goes here
    q = -10*ones(n,1);
    rho = 7800;
    a = 4.5e-3;
    dL = 1/n;
    if 0 == size(b0)
        b0 = 1e-2*ones(n,1);
    end
    g = -9.81;
    E = 210e9;
    maximum_deflection = 12e-3;
    maximum_stress(n,1) = 110e6;
    stress_matrix = a/2*E*build_D2(n);
    options = optimoptions('fmincon');
    %options.OutputFcn = @history_tracker;
    options.MaxFunEvals = 1000*n;
    options.TolX = 1e-200;
    options.GradObj = 'on';
    options.UseParallel = 1;
    %options.Algorithm = 'trust-region-reflective';
    options.Display = 'iter';

    function [norm, gradient] = objective_function(b)
        norm = sum(b)*dL;
        gradient = ones(n,1);
    end

    function [w] = compute_w(b)
        M = build_matrix(b)
        Q = q+a*rho*b*g
        w = M\Q;
    end
    
    function [bound, equality] = constraint(b)
        w = compute_w(b);
        bound = max(abs(w))-maximum_deflection;
        equality = [];%max([0 max(abs(w))-maximum_deflection]);
    end

    b = fmincon(@objective_function, b0, stress_matrix, maximum_stress, [], [], zeros(n,1), [], @constraint, options);
    w = compute_w(b);
    Q = q+a*rho*b*g;
    sigma = stress_matrix*w;
end

