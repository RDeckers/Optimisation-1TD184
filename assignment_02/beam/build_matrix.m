function [ M ] = build_matrix(b)
%BUILD_MATRIX Creates the matrix needed to solve for Q, size is determined
%implicitly from b.
    persistent D2;
    n = size(b,1);
    if size(D2) ~= [n n]
        disp('rebuilding matrix');
        D2 = build_D2(n);
    end
    a = 3e-3;
    E = 210e9;
    c = E*a^3/12;
    M= c*D2*diag(b)*D2;
end

