function [ b, w, Q, sigma ] = optimize_w( n, w0 )
%OPTIMIZE_W Summary of this function goes here
%   Detailed explanation goes here
    q = -10*ones(n,1);
    rho = 7800;
    a = 4.5e-3;
    dL = 1/n;
    g = -9.81;
    E = 210e9;
    maximum_deflection(1:n) = 12e-3;
    maximum_deflection(1) = 0;
    maximum_deflection(end) = 0;
    maximum_deflection(2) = 0;
    maximum_deflection(end-1) = 0;
    if 0 == size(w0)
        w0 = -maximum_deflection(1)*ones(n,1)
    end
    maximum_stress(n,1) = 110e6;
    stress_matrix = a/2*E*build_D2(n);
    options = optimoptions('fmincon');
    %options.OutputFcn = @history_tracker;
    options.MaxFunEvals = 1000*n;
    options.TolX = 1e-30;
    %options.GradObj = 'on';
    options.UseParallel = 1;
    options.Display = 'iter';
    function [b] = compute_b(w)
        B = construct_B_matrix(w);
        %b = linprog(ones(n,1), [],[], B, q, 1e-12*ones(n,1),[]);
        b = abs(B\q);
    end
    function [norm] = objective_function(w)
       b = compute_b(w);
       norm = sum(b)*dL;
    end
    function [bound, equality] = constraint(w)
        b = compute_b(w);
        bound = [];%-(min([0, min(b)-1e-9]));
        equality = [];%max([0 max(abs(w))-maximum_deflection]);
    end
    fixed_matrix = zeros(n,n);
    fixed_matrix(1,1) = -1/dL;
    fixed_matrix(1,3) = 1/dL;
    fixed_matrix(end,end-2) = -1/dL;
    fixed_matrix(end,end) = 1/dL;
    fixed_matrix
    w = fmincon(@objective_function, w0, stress_matrix, maximum_stress, fixed_matrix, zeros(n,1), -maximum_deflection, maximum_deflection, [], options);
    b = compute_b(w);
    Q = q+a*rho*b*g;
    sigma = stress_matrix*w;
end
