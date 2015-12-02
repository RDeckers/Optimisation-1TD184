function [D2] = build_D2(n)
       h = 1/n;
       off(1:n-1) = 1/h^2;
       diag(1:n) = -2/h^2;
       D2 = gallery('tridiag', off, diag, off);
end