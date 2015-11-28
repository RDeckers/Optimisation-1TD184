function [ dH ] = objective_rescaled( x0, x1  )    
  n = x0/10;
  A = 10^x1;
  [H_our, H_obs] = delta_H(n, A);
  %size(H_our) 3
  diff = H_our-H_obs;
  dH = log(sum((diff).^2));
   %dH = sum((((-a.*(n+2)/(2*A*(rho*g).^n.*abs(dhdx).^(n-1).*dhdx)).^(1/(n+2)))-H_obs).^2);
end