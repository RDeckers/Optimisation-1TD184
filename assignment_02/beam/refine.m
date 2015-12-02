function [  b, w, Q, sigma ] = refine( n0, steps, b0 )
%REFINE Summary of this function goes here
%   Detailed explanation goes here
    for i = 1:steps
        [b,w,Q,sigma] = optimize_constr(250, b0);
        figure(1)
        plot(w)
        figure(2)
        plot(b)
        for j = 1:size(b)-1
            b_new(j*2-1) = b(j);
            b_new(j*2) = (b(j)+b(j+1))/2;
        end
        b_new(end) = b(end);
    end

end

