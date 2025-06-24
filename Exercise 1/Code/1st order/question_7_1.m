
Ms = [2, 10, 20, 30, 50];

for k = 1:numel(Ms)
    m  = Ms(k);
    Rm = Rxx_sub{k};              
    
    % eigen-decomposition
    [V,D] = eig(Rm);
    [lambda, idx] = sort(diag(D), 'descend');
    V = V(:, idx);
    
    % assign variables 
    eval(sprintf('lambda_%d = lambda;', m));   
    eval(sprintf('e%d       = V(:,1);', m));   
    eval(sprintf('n%d       = V(:,2:end);', m));
    
   
    fprintf('\nM = %2d\n', m);
    
    fprintf('  lambda_%d = [ %s]\n', m, sprintf('%.4f ', lambda));
    
    % steering vector
    fprintf('  e%d = [', m);
    for i = 1:m
        fprintf(' %.4f%+.4fj', V(i,1), imag(V(i,1)));
    end
    fprintf(' ]''\n');
    
    fprintf('  n%d is %dx%d  (columns are n_2 … n_%d)\n', m, m, m-1, m);
end
