function [ s, r ] = compute_sigma_r( Q, w )
  s = 1/2*w.'*Q*w;
  r = r*w;
end

