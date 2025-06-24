

Ms = [2, 10, 20, 30, 50];

for m = Ms
    % Retrieve eigenvalues vector for current M from workspace
    lambda_m = eval(sprintf('lambda_%d', m));  
    
    % Extract noise-subspace eigenvalues 
    noiseEigs = lambda_m(2:end);
    
    % Estimate white-noise variance σ^2_W as mean of noise eigenvalues
    sigma2_w = mean(noiseEigs);
    
    % Plot histogram of noise eigenvalues (normalized as PDF)
    figure;
    histogram(noiseEigs, 'Normalization', 'pdf');
    title(sprintf('Histogram of Noise Eigenvalues (M = %d)', m));
    xlabel('\lambda');
    ylabel('Probability Density');
    
    % Compute 1st and 2nd central moments of noise eigenvalues
    mu  = mean(noiseEigs);
    m1  = mean(noiseEigs - mu);          
    m2  = mean((noiseEigs - mu).^2);     
    
   
    fprintf('--- M = %d ---\n', m);
    fprintf('Estimated σ^2_W         = %.4f\n', sigma2_w);
    fprintf('1st central moment      = %.4e\n', m1);
    fprintf('2nd central moment (var)= %.4e\n\n', m2);
end
