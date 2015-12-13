function [x, fval] = part_1( )
staff = [700 500 600 300 100 50];
cost = [1,1,1,1,2,2];
%minimize cost.allocated_staff subject to -(allocated_staff[i-1] +
%allocated_staff[i]) <= -staff[i]
A = speye(6, 6)+diag(ones(5,1), -1);
A(1,6) = 1;
A = sparse(A);

options = optimset('Simplex','on','LargeScale','off');
[x, fval] = linprog(cost, -A, -staff, [],[],[],[],[],options)
options = optimset('LargeScale','on');
[x, fval] = linprog(cost, -A, -staff, [],[],zeros(6),[],[],options);

end

