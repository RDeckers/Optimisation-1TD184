  function [ H_our, H_obs ] = delta_H(n, A)
  persistent H_obs a dhdx g rho x    
  if size(x,1) == 0
    load('Sharad.mat')
  end
  H_our = zeros(size(x));
  for i = 1:size(x,2)
    H_our(i) = ((-a(i)*(n+2)) / (2*A*(rho*g)^n*abs(dhdx(i))^(n-1)*dhdx(i)) )^(1/(n+2));
    %H_our(i) = (-(a(i)*(n+2))/(2*A)*(rho*g)^(-n)*abs(dhdx(i))^(1-n)/dhdx(i))^(1/(n+2));
  end
 end