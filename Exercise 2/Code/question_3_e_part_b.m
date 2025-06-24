
% Compute the empirical mean over realizations:
Ymean = mean(Y, 1);    


figure;
plot(n, Ymean, 'LineWidth',1.5);
xlabel('n');
ylabel('Mean\{Y(n)\}');
title(' Mean of Filtered Outputs Y(n)');
grid on;


figure;
stem(n(1:200), Ymean(1:200), 'filled');
xlabel('n');
ylabel('Mean\{Y(n)\}');
title(' Stem of Mean Y(n) (n=0..199)');
