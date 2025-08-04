%% 1. 二变量正态分布
% 定义参数
muVec_biv = [1,1];      % 均值向量
stdevX_biv = 2.0;       % X标准差
stdevY_biv = 1.0;        % Y标准差
rho_biv = -0.8;         % 相关系数

% 如果plotbivarcontours函数存在，运行它
if exist('plotbivarcontours', 'file')
    plotbivarcontours(rho_biv, stdevX_biv, stdevY_biv, muVec_biv);
else
    disp('plotbivarcontours函数未找到，跳过二维绘图');
end

%% 2. 二变量相关系数生成
theta = 35;              % 角度参数(度)
rho = sind(theta);       % 理论相关系数
nTrials = 50000;         % 试验次数
X = randn(1, nTrials);   % X~N(0,1)
Y = randn(1, nTrials);   % Y~N(0,1)，独立于X
W = X;                   % W = X
Z = sind(theta)*X + cosd(theta)*Y; % Z = sinθ*X + cosθ*Y

% 计算并显示相关系数
R_biv = corrcoef([W(:), Z(:)]);
disp(['理论相关系数: ', num2str(rho)]);
disp(['模拟相关系数: ', num2str(R_biv(1,2))]);

% 绘制散点图
figure;
scatter(W, Z, 10, 'filled', 'MarkerFaceAlpha', 0.1);
axis tight;
axis equal;
xlabel('W');
ylabel('Z');
title(['W与Z的散点图 (理论 \rho = ', num2str(rho), ')']);
grid on;

%% 3. 三变量正态分布生成

% ===== 输入参数 =====
% 三元正态分布均值向量
muVec = [2; 1; 3];  % 均值向量 (列向量)

% 三元正态分布协方差矩阵
C = [4.0,  1.2, -0.8;   % 注意：必须对称正定
     1.2,  3.0,  0.6;
     -0.8, 0.6,  2.0];

% 生成样本数量（复用您设定的参数）
nTrials = 50000;

% ===== 计算变换矩阵 A =====
% 检查协方差矩阵是否对称
if ~issymmetric(C)
    warning('协方差矩阵不对称！将强制对称化');
    C = (C + C')/2;  % 对称化
end

% 检查正定性（特征值均大于0）
eigenvalues = eig(C);
if any(eigenvalues <= 1e-8)
    disp('协方差矩阵接近半正定，添加小扰动使其正定');
    minEig = min(eigenvalues);
    if minEig <= 0
        adjustment = abs(minEig) + 1e-5;
        C = C + adjustment * eye(3);
        disp(['添加 ', num2str(adjustment), ' 到对角元素']);
    end
end

% Cholesky分解计算变换矩阵A
try
    A = chol(C, 'lower');  % 获取下三角分解矩阵 C = A*A'
catch ME
    disp('Cholesky分解失败：');
    disp(ME.message);
    % 使用替代方法（奇异值分解）
    [U, S, V] = svd(C);
    A = U * sqrt(S);  % A = U*sqrt(S)
    disp('使用SVD替代Cholesky分解');
end

disp('变换矩阵 A =');
disp(A);

% ===== 生成独立正态随机变量 =====
X1 = randn(1, nTrials);  % X1 ~ N(0,1)
X2 = randn(1, nTrials);  % X2 ~ N(0,1)
X3 = randn(1, nTrials);  % X3 ~ N(0,1)

% 组成随机变量矩阵 X = [X1; X2; X3]
X = [X1; X2; X3];  % 3×nTrials矩阵

% ===== 线性变换生成多元正态变量 Z = A*X + μ =====
Z = A * X + muVec;  % 线性变换（均值偏移）

% ===== 验证结果 =====
% 计算样本均值
mu_sim = mean(Z, 2);
disp('目标均值:'); disp(muVec);
disp('样本均值:'); disp(mu_sim);

% 计算样本协方差
C_sim = cov(Z');  % cov函数要求行是变量，列是观测值
disp('目标协方差矩阵:');
disp(C);
disp('样本协方差矩阵:');
disp(C_sim);

% ===== 可视化 =====
% 1. 三维散点图
figure;
scatter3(Z(1,:), Z(2,:), Z(3,:), 10, 'filled', 'MarkerFaceAlpha', 0.1);
xlabel('Z_1'); ylabel('Z_2'); zlabel('Z_3');
title(['三元正态分布样本 (n=', num2str(nTrials), ')']);
grid on;
rotate3d on;  % 启用旋转

% 2. 三变量边际分布直方图
figure;
subplot(3,1,1);
histogram(Z(1,:), 50, 'Normalization', 'pdf');
hold on;
% 理论边际分布（正态分布）
x1 = linspace(min(Z(1,:)), max(Z(1,:)), 200);
pdf1 = normpdf(x1, muVec(1), sqrt(C(1,1)));
plot(x1, pdf1, 'r', 'LineWidth', 2);
title('Z_1 的边际分布');
legend('样本分布', '理论分布');

subplot(3,1,2);
histogram(Z(2,:), 50, 'Normalization', 'pdf');
hold on;
x2 = linspace(min(Z(2,:)), max(Z(2,:)), 200);
pdf2 = normpdf(x2, muVec(2), sqrt(C(2,2)));
plot(x2, pdf2, 'r', 'LineWidth', 2);
title('Z_2 的边际分布');

subplot(3,1,3);
histogram(Z(3,:), 50, 'Normalization', 'pdf');
hold on;
x3 = linspace(min(Z(3,:)), max(Z(3,:)), 200);
pdf3 = normpdf(x3, muVec(3), sqrt(C(3,3)));
plot(x3, pdf3, 'r', 'LineWidth', 2);
title('Z_3 的边际分布');

% 3. 成对变量散点图
figure;
subplot(2,2,1);
scatter(Z(1,:), Z(2,:), 10, 'filled', 'MarkerFaceAlpha', 0.1);
axis equal; grid on;
xlabel('Z_1'); ylabel('Z_2');
title('Z_1 与 Z_2');

subplot(2,2,2);
scatter(Z(1,:), Z(3,:), 10, 'filled', 'MarkerFaceAlpha', 0.1);
axis equal; grid on;
xlabel('Z_1'); ylabel('Z_3');
title('Z_1 与 Z_3');

subplot(2,2,3);
scatter(Z(2,:), Z(3,:), 10, 'filled', 'MarkerFaceAlpha', 0.1);
axis equal; grid on;
xlabel('Z_2'); ylabel('Z_3');
title('Z_2 与 Z_3');