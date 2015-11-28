function [] = make_plots()
figure(1)
options = optimoptions('lsqnonlin');

options.Algorithm = 'trust-region-reflective';
point1 = lsqnonlin(@objective_rescaled, [10, -25],[],[],options)
point2 = lsqnonlin(@objective_rescaled, [30, -25],[],[],options)

options.Algorithm = 'levenberg-marquardt';
point3 = lsqnonlin(@objective_rescaled, [10, -25],[],[], options)
point4 = lsqnonlin(@objective_rescaled, [30, -25],[],[], options)
x = [min([point1(1) point2(1) point3(1) point4(1)])-2:0.1:max([point1(1) point2(1) point3(1) point4(1)])+2];
y = [min([point1(2) point2(2) point3(2) point4(2)])-2:0.1:max([point1(2) point2(2) point3(2) point4(2)])+2];
[X, Y] = meshgrid(x,y);
Z = arrayfun(@objective_rescaled_dual, X, Y);
hold on;
h= pcolor(X, Y, Z);
set(h,'edgecolor','none')
[C,hfigc] = contour(X, Y, Z);
set(hfigc, ...
    'LineWidth',1.0, ...
    'Color', [1 1 1]);
scatter(point1(1), point1(2), 'r');
scatter(point2(1), point2(2), 'rd');
%scatter(point3(1), point3(2), 'r');
%scatter(point4(1), point4(2), 'rd');
hold off;
hcb = colorbar('location','EastOutside');

figure(2)
x= [25:0.025:35];
y= [-27:0.01:-23];
y_fixed_A = arrayfun(@objective_rescaled_n, x);
plot(x, y_fixed_A, 'k');
hold on;
min_minunc = fminunc(@objective_rescaled_n, 3);
min_lsqnonlin = lsqnonlin(@objective_rescaled_n, 3)
plot([min_minunc min_minunc], [min([y_fixed_A(:)]) max([y_fixed_A(:)])],'b');
axis([min([x(:)]) max([x(:)]) min([y_fixed_A(:)]) max([y_fixed_A(:)])]);
plot([min_lsqnonlin min_lsqnonlin], [min([y_fixed_A(:)]) max([y_fixed_A(:)])],'--r');
axis([min([x(:)]) max([x(:)]) min([y_fixed_A(:)]) max([y_fixed_A(:)])]);
figure(3)
y_fixed_N = arrayfun(@objective_rescaled_A, y);
plot(y, y_fixed_N, 'k');
min_minunc = fminunc(@objective_rescaled_A, -25);
min_lsqnonlin = lsqnonlin(@objective_rescaled_A, -25)
hold on;
plot([min_minunc min_minunc], [min([y_fixed_N(:)]) max([y_fixed_N(:)])], 'b');
axis([min([y(:)]) max([y(:)]) min([y_fixed_N(:)]) max([y_fixed_N(:)])]);
plot([min_lsqnonlin min_lsqnonlin], [min([y_fixed_N(:)]) max([y_fixed_N(:)])], '--r');
axis([min([y(:)]) max([y(:)]) min([y_fixed_N(:)]) max([y_fixed_N(:)])]);
end

