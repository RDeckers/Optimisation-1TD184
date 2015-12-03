function [] = make_results()
  [w, x_lambda, r_final, sigma, optim,lambda ] = compute_least_variance();
  disp('ASSIGNMENT 2')
  disp('===================')
  disp('weights:')
  disp(w)  
  fprintf('predicted value: %f +- %f\n', r_final, sqrt(sigma))
  fprintf('optimality condition: %f\n\n',  optim.firstorderopt);
  disp('x_lambda ([solution lambda.ineqlin])')
  disp(x_lambda)
  disp('lambdas: ')
  disp(lambda.lower)
  disp(lambda.upper)
  disp(lambda.eqlin)
  disp(lambda.ineqlin)

  disp('')
  disp('ASSIGNMENT 3b')
  disp('===================')
  disp('WITH SHORTING')
  [w, x_lambda, r_final, sigma, optim,lambda ] = fixed_rho(0.1, 1);
  disp('weights:')
  disp(w)  
  fprintf('predicted value: %f +- %f\n', r_final, sqrt(sigma))
  fprintf('optimality condition: %f\n\n',  optim.firstorderopt);
  disp('x_lambda ([solution lambda.ineqlin])')
  disp(x_lambda)
  disp('lambdas: ')
  disp(lambda.lower)
  disp(lambda.upper)
  disp(lambda.eqlin)
  disp(lambda.ineqlin)
  
  disp('WITHOUT SHORTING')
  [w, x_lambda, r_final, sigma, optim,lambda ] = fixed_rho(0.1, 0);
  disp('weights:')
  disp(w)  
  fprintf('predicted value: %f +- %f\n', r_final, sqrt(sigma))
  fprintf('optimality condition: %f\n\n',  optim.firstorderopt);
  disp('lambdas: ')
  disp(lambda.lower)
  disp(lambda.upper)
  disp(lambda.eqlin)
  disp(lambda.ineqlin)
  
  disp('Generating extra graphs of sigma vs. rho...')
  R = 0.01:0.001:0.15;
  S2 = [];
  X2 = [];
  S = [];
  X = [];
  for r = R
    [w, x_lambda, r_final, sigma, optim,lambda, ef ] = fixed_rho(r, 0);
    if ef >= 0 %if sucessfully computed
      X = [X r_final];
      S = [S sigma];
    end
    [w, x_lambda, r_final, sigma, optim,lambda, ef ] = fixed_rho(r, 1);
    if ef >= 0
      X2 = [X2 r_final];
      S2 = [S2 sigma];
    end
  end
  figure(1)
  clf();
  hold on;  
  plot(X, S) %sigma vs rho
  plot(X2, S2)

  disp('')
  disp('ASSIGNMENT 4b')
  disp('===================')
  disp('WITH SHORTING, a = 0.5')
  [w, x_lambda, r_final, sigma, optim,lambda ] = compute_optimality(0.5, 1);
  disp('weights:')
  disp(w)  
  fprintf('predicted value: %f +- %f\n', r_final, sqrt(sigma))
  fprintf('optimality condition: %f\n\n',  optim.firstorderopt);
  disp('x_lambda ([solution lambda.ineqlin])')
  disp(x_lambda)
  disp('lambdas: ')
  disp(lambda.lower)
  disp(lambda.upper)
  disp(lambda.eqlin)
  disp(lambda.ineqlin)
  
  disp('WITHOUT SHORTING')
  [w, x_lambda, r_final, sigma, optim,lambda ] = compute_optimality(0.5, 1);
  disp('weights:')
  disp(w)  
  fprintf('predicted value: %f +- %f\n', r_final, sqrt(sigma))
  fprintf('optimality condition: %f\n\n',  optim.firstorderopt);
  disp('lambdas: ')
  disp(lambda.lower)
  disp(lambda.upper)
  disp(lambda.eqlin)
  disp(lambda.ineqlin)
  
  disp('Generating alpha graphs (same as other)')
  R = 0.05:0.05:1.0;
  S2 = [];
  X2 = [];
  S = [];
  X = [];
  for r = R
    [w, x_lambda, r_final, sigma, optim,lambda, ef ] = compute_optimality(r, 0);
    if ef >= 0 %if sucessfully computed
      X = [X r_final];
      S = [S sigma];
    end
    [w, x_lambda, r_final, sigma, optim,lambda, ef ] = compute_optimality(r, 1);
    if ef >= 0
      X2 = [X2 r_final];
      S2 = [S2 sigma];
    end
  end
  figure(2)
  plot(X, S, '-o') %sigma vs rho
  figure(3)
  plot(X2, S2, '-*')
  
  disp('Generating extra graphs of delta_r...')
  R = 0.01:0.001:0.15;
  S2 = [];
  X2 = [];
  S = [];
  X = [];
  for r = R
    [w, x_lambda, r_final, sigma, optim,lambda, ef ] = min_rho(r, 0);
    if ef >= 0 %if sucessfully computed
      X = [X r];
      S = [S r_final-r];
    end
    [w, x_lambda, r_final, sigma, optim,lambda, ef ] = min_rho(r, 1);
    if ef >= 0
      X2 = [X2 r];
      S2 = [S2 r_final-r];
    end
  end
  figure(4)
  clf();
  hold on;  
  plot(X, S) %sigma vs rho
  plot(X2, S2)
  
end
