function [] = make_plots()
history_x =[];
history_y =[];
    function stop = history_tracker(x, optimvalues, state);
        stop = false;
        switch state
            case 'init'
                history_x = [];
                history_y = [];
            case 'iter'
                history_x = [history_x [x(1)]];
                if(numel(x) >= 2)
                    history_y = [history_y [x(2)]];
                end
                % Label points with iteration number.
                % Add .15 to x(1) to separate label from plotted 'o'
                %text(x(1)+.15,x(2),num2str(optimValues.iteration));
            case 'done'
            otherwise
        end
    end

figure(1)
options = optimoptions('lsqnonlin');
options.OutputFcn = @history_tracker;
options.MaxFunEvals = 10000;
options.Algorithm = 'levenberg-marquardt';
point1 = lsqnonlin(@objective_rescaled, [10, -25],[],[],options)
history_x1 = history_x
history_y1 = history_y
point2 = lsqnonlin(@objective_rescaled, [30, -25],[],[],options)
history_x2 = history_x;
history_y2 = history_y;
range_x = [min([history_x1 history_x2 point1(1) point2(1)]) max([history_x1 history_x1 point1(1) point2(1)])]
dx = (range_x(2) - range_x(1))/100;
range_y = [min([history_y1 history_y2 point1(2) point2(2)]) max([history_y1 history_y2 point1(2) point2(2)])]
dy = (range_y(2) - range_y(1))/100;
options.Algorithm = 'levenberg-marquardt';
%point3 = lsqnonlin(@objective_rescaled, [10, -25],[],[], options)
%point4 = lsqnonlin(@objective_rescaled, [30, -25],[],[], options)
x = range_x(1)-5*dx:dx:range_x(2)+5*dx
y = range_y(1)-5*dy:dy:range_y(2)+5*dy
[X, Y] = meshgrid(x,y);
Z = arrayfun(@objective_rescaled_dual, X, Y);
hold on;
h= pcolor(X, Y, Z);
set(h,'edgecolor','none')
scatter(point1(1), point1(2), 'r');
plot(history_x1, history_y1, 'r');
scatter(point2(1), point2(2), 'rd');
plot(history_x2, history_y2, 'r');
%scatter(point3(1), point3(2), 'r');
%scatter(point4(1), point4(2), 'rd');
hold off;
hcb = colorbar('location','EastOutside');

figure(2)
hold on;
min_minunc = fminunc(@objective_rescaled_n, 10, options);
history_x1 = history_x
history_y1 = arrayfun(@objective_rescaled_n, history_x1);
min_lsqnonlin = lsqnonlin(@objective_rescaled_n, 10, [], [], options)
history_x2 = history_x
history_y2 = arrayfun(@objective_rescaled_n, history_x2);

range_x = [min([history_x1 history_x2]) max([history_x1 history_x1])]
dx = (range_x(2) - range_x(1))/100;
range_y = [min([history_y1 history_y2]) max([history_y1 history_y2])]
dy = (range_y(2) - range_y(1))/100;
x = range_x(1)-5*dx:dx:range_x(2)+5*dx;
y = range_y(1)-5*dy:dy:range_y(2)+5*dy;
y_fixed_A = arrayfun(@objective_rescaled_n, x);
plot(x, y_fixed_A, 'k');
plot(history_x1, history_y1, 'b');
plot(history_x2, history_y2, 'r');
%plot(history_x2, history_y2, 'rd');
%plot(history_x1, history_y1, 'bo');
plot([min_minunc min_minunc], [min([y_fixed_A(:)]) max([y_fixed_A(:)])],'b');
axis([min([x(:)]) max([x(:)]) min([y_fixed_A(:)]) max([y_fixed_A(:)])]);
plot([min_lsqnonlin min_lsqnonlin], [min([y_fixed_A(:)]) max([y_fixed_A(:)])],'--r');
axis([min([x(:)]) max([x(:)]) min([y_fixed_A(:)]) max([y_fixed_A(:)])]);

figure(3)
min_minunc = fminunc(@objective_rescaled_A, -25, options);
history_x1 = history_x
history_y1 = arrayfun(@objective_rescaled_A, history_x1);
min_lsqnonlin = lsqnonlin(@objective_rescaled_A, -25, [], [], options)
history_x2 = history_x
history_y2 = arrayfun(@objective_rescaled_A, history_x2);
range_x = [min([history_x1 history_x2]) max([history_x1 history_x1])]
dx = (range_x(2) - range_x(1))/100;
range_y = [min([history_y1 history_y2]) max([history_y1 history_y2])]
dy = (range_y(2) - range_y(1))/100;
x = range_x(1)-5*dx:dx:range_x(2)+5*dx
y = range_y(1)-5*dy:dy:range_y(2)+5*dy

y_fixed_N = arrayfun(@objective_rescaled_A, x);
hold on;
plot(x, y_fixed_N, 'k');
plot(history_x1, history_y1, 'b');
plot(history_x2, history_y2, 'r');
%plot(history_x2, history_y2, 'rd');
%plot(history_x1, history_y1, 'bo');
plot([min_minunc min_minunc], [min([y_fixed_N(:)]) max([y_fixed_N(:)])], 'b');
axis([min([x(:)]) max([x(:)]) min([y_fixed_N(:)]) max([y_fixed_N(:)])]);
plot([min_lsqnonlin min_lsqnonlin], [min([y_fixed_A(:)]) max([y_fixed_N(:)])], '--r');
axis([min([x(:)]) max([x(:)]) min([y_fixed_N(:)]) max([y_fixed_N(:)])]);
end

