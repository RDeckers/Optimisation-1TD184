function [] = plot_rescaled_objective(x,y)
  [X, Y] = meshgrid(x,y);
  Z = arrayfun(@objective_rescaled, X, Y);
  [M,I] = min(Z(:))
  [row, col] = ind2sub(size(Z),I)
  figure(1)
  surf(X,Y,Z)
  figure(2)
  contour(X,Y,Z)
end  