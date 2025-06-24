
%  Compute the empirical mean over realizations:
Xmean = mean(X, 1);   


figure;
plot(n, Xmean, 'LineWidth',1.5);
xlabel('n');
ylabel('Mean\{X(n)\}');
title(' Mean process across K realizations');
grid on;


figure;
stem(n(1:200), Xmean(1:200), 'filled');
xlabel('n');
ylabel('Mean\{X(n)\}');
title(' Stem of mean process (n=0..199)');
