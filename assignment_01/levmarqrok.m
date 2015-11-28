function [x,resnorm,residual,xOld] = levmarqrok(func,x0,varargin)
%   Solve least square problem using Levenberg - Marquardt algorithm.
%
%   [x,resnorm,residual] = levmarq(func,x0,'options')
%
%   x0       =  initial coefficients guess vector
%   func     =  function
%   x        =  final coefficients
%   resnorm  =  norm of the final residual
%   residual =  final residual
%   xOld     =  old approximations
%
%   Optional parameters:
%       'maxIter'   = maximum number of iterations
%       'tolerance' = treshold to stop the iteration
%       'initU'     = initial value for \mu
%       'tr1'       = trust region treshold below which we reject step
%       'tr2'       = trust region treshold above which we reduce \mu
%       'trfactor'  = factor with which we change \mu

% Read Options --------------------------------------------------------
options = struct('maxiter',10000,...
                 'tolerance',1e-6,...
                 'initu',1e-2,...
                 'tr1',1/4,...
                 'tr2',3/4,...
                 'trfactor',2); % define defaults

optionNames = fieldnames(options); % read the acceptable names

nArgs = length(varargin); % count arguments
if round(nArgs/2)~=nArgs/2
   error('levmarq needs propertyName/propertyValue pairs')
end

for pair = reshape(varargin,2,[]) % pair is {propName;propValue}
   inpName = lower(pair{1}); % make case insensitive
   if any(strcmp(inpName,optionNames))
      options.(inpName) = pair{2}; % overwrite options
   else
      error('%s is not a recognized parameter name',inpName)
   end
end

% Execution -----------------------------------------------------------

f = str2func(func);
x = x0;
maxIter = options.maxiter;
tol = options.tolerance;
u = options.initu;
tr1 = options.tr1;
tr2 = options.tr2;
trfactor = options.trfactor;
resnorm = 0;
resnormOld = resnorm;
xOld = zeros(2,maxIter+1);
xOld(:,1) = x0;



for i = 1:maxIter
    %disp('Next step:');
    
    % get the residual and it's norm
    residual = f(x);
    %resnorm = norm(residual); %!!!!!!!!!!!!!!
    resnorm = residual'*residual/2; %must be scalar
    
    % break if correction is small
    if abs(resnormOld-resnorm) < tol
        break
    end
    
    % get the gradient of the residual
    if nargout(f) == 1
        gres = zeros(length(x0),length(residual));
        x1 = x; x2 = x
        for j = 1:length(x0)
            dx = x(j) * 1e-5;
            x1(j) = x1(j) + dx; %Check these numbers
            x2(j) = x2(j) - dx;
            gres(j,:) = (f(x1) - f(x2)) / (2*dx);
        end
    elseif nargout(f) == 2
        [~, gres] = f(x);
    else
        disp('Something wrong with func.');
    end
    
    % solve to get p
    %p = - (gres*gres' + u * eye(length(x0))) \ (gres*residual);
    p = [gres';sqrt(u)*eye(length(x0))]\[-residual;zeros(length(x0),1)];
    
    % check if we are satisfied with solution
    %rho = (f(x)'*f(x) - f(x+p')'*f(x+p')) / (-2 * (residual'*gres'*p));
    rho = (f(x)'*f(x) - f(x+p')'*f(x+p')) /...
            (-2 * (residual'*gres'*p) -...
            p'*(gres*gres' + u * eye(length(x0)))*p);
    %[~,w] = chol(gres*gres' + u * eye(length(x0))) % check if pos. def.
    
    % update u
    if abs(rho) <= tr1 %|| w > 0
        u = u*11;%u;
        disp('Enlarging u!');
    elseif abs(rho) >= tr2
        u = u/9;%;//trfactor;
        disp('Reducing u!');
    end
    
    % update x
    if abs(rho) <= tr1 %|| w > 0
        xOld(:,i+1) = x;
    else
        x = x + p';
        xOld(:,i+1) = x;
        resnormOld = resnorm; % set current resnorm to old one
    end
    
end
disp('Steps needed:')
disp(i)

xOld = xOld(:,1:i);

