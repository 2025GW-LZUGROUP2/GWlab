% 随机种子
rng(42);

% 目标均值 & 协方差（可自行修改）
mu = [1.0; -0.5];
Sigma = [1.5 0.9; 0.9 1.0];   % 对称正定

% Cholesky：MATLAB 的 chol 返回上三角 R，使得 Sigma = R' * R
R = chol(Sigma, 'upper');

% 从标准正态采样（行向量样本；每行一个样本）
n = 5000;
X = randn(n, 2);

% 线性变换：Y = mu' + X * R
Y = X * R + mu';

% 样本协方差与目标对比
sampleCov = cov(Y, 1);   % 以总体无偏/有偏均可，这里用有偏(除以 n)
diff = sampleCov - Sigma;
froNorm = norm(diff, 'fro');

disp('目标 Σ ='); disp(Sigma);
disp('Cholesky 上三角 R （Σ = R^T R） ='); disp(R);
disp('样本协方差 ='); disp(sampleCov);
disp(['‖sampleCov − Σ‖_F = ', num2str(froNorm)]);