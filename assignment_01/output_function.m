function stop = output_function(x,optimValues,state)
persistent X Y
stop = false;
   switch state
       case 'init'
           X = [];
           Y = [];
           hold on
       case 'iter'
           X = [X [x(1)]];
           Y = [Y [x(2)]];
           % Label points with iteration number.
           % Add .15 to x(1) to separate label from plotted 'o'
           %text(x(1)+.15,x(2),num2str(optimValues.iteration));
       case 'done'
           plot(X, Y)
           hold off
       otherwise
   end
end