

% ---------------------------------------

X = SITC0 ./ (FAO_rebased .* Shipping_rebased);
% ---------------------------------------
mdl = fitlm(X, newSITC0);


% ---------------------------------------
a = mdl.Coefficients.Estimate(2);
b = mdl.Coefficients.Estimate(1);
% ---------------------------------------

% ---------------------------------------
newS_est = a * X + b;

% ---------------------------------------
figure;
plot(newS, 'k', 'LineWidth', 1.5); hold on
plot(newS_est, 'r--', 'LineWidth', 1.5);
legend('Actual newSITC0','Estimated newSITC0')
title('Construction of newSITC0')
grid on

% ---------------------------------------
R2 = mdl.Rsquared.Ordinary;

