function [ norm ] = H_norm(n, A)
  [H_our, H_obs] = delta_H(n, A);
  diff = H_our-H_obs;
  norm = sum((diff).^2);
 end
  