function [ w, x_lambda, r_final, sigma, optim, lambda, ef] = fixed_rho(rho, allow_short_selling)
    Q = 2*1e-2*[4.01, -1.19, 0.60, 0.74, -0.21; -1.19, 1.12, 0.21, 0.54, 0.55; 0.60, 0.21, 3.04, 0.77, 0.29; 0.74, 0.54, 0.77, 3.74, -1.04; -0.21, 0.55, 0.29, -1.04, 3.8];
    r = 1e-2*[13 5.3 10.5 5.0 12.6];
    n = 5;
    options = optimoptions(@quadprog);
    options.Display = 'iter';
    options.Algorithm = 'active-set';%deprecated
    options.Display = 'none';
    warning('Off', 'optim:quadprog:WillBeRemoved');
    Aeq = [ones(1,n); r];
    beq = [1;rho];
    if allow_short_selling == 1
      KKT = [Q, Aeq.'; Aeq, [0,0;0,0]];
      x_lambda = KKT\[zeros(1,n) beq.'].';
      [w, fv, ef, optim, lambda] = quadprog(Q, [], [],[], Aeq, beq,[],[],[],options);
    else
      x_lambda = [];
      [w, fv, ef, optim, lambda] = quadprog(Q, [], [], [], Aeq, beq, zeros(n,1), [],[], options);
    end
    sigma = 1/2*w.'*Q*w;
    r_final = r*w;
    end
  