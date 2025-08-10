%% 1. 读取数据 & 时间轴
fs = 1024;
T = 1;
N = round(T * fs);
t = (0:N-1) / fs;
data = readmatrix("generated_signal.txt")';  % 读取带噪信号

%% 2. 定义多项式调制信号模型
func = @(t, A, a1, a2, a3) A * sin(2 * pi * (a1 * t + a2 * t.^2 + a3 * t.^3));

%% 3. 定义目标函数 (均方误差)
objective_function = @(params) mse_objective(params, t, data, func);

%% 4. PSO 参数范围及初始化
% 参数下界 A, a1, a2, a3
lb = [0.1, 0, 0, 0];
% 参数上界
ub = [2.0, 40, 30, 30];

% PSO 参数设置
options = struct();
options.SwarmSize = 30;
options.MaxIterations = 100;
options.C1 = 1.5;  % 认知参数
options.C2 = 1.5;  % 社会参数
options.W = 0.6;   % 惯性权重

%% 5. 运行PSO优化
[best_pos, best_cost] = pso_optimize(objective_function, lb, ub, options);

fprintf('最优参数估计: A=%.3f, a1=%.3f, a2=%.3f, a3=%.3f\n', ...
    best_pos(1), best_pos(2), best_pos(3), best_pos(4));
fprintf('最小均方误差: %.6f\n', best_cost);

%% 6. 计算拟合信号和残差
fitted_signal = func(t, best_pos(1), best_pos(2), best_pos(3), best_pos(4));
residuals = data - fitted_signal;

%% 7. 估计噪声方差
sigma2 = var(residuals);

%% 8. 计算GLRT统计量
original_energy = sum(data.^2);
residual_energy = sum(residuals.^2);
glrt_stat = (original_energy - residual_energy) / (2 * sigma2);

fprintf('GLRT 统计量值: %.3f\n', glrt_stat);

%% 9. 根据信号检测阈值判决
threshold = 10;  % 阈值
if glrt_stat > threshold
    fprintf('检测到信号\n');
else
    fprintf('未检测到信号\n');
end

%% 10. 可视化结果
figure;
plot(t, data, 'b-', 'DisplayName', 'signal with noisy', 'LineWidth', 0.5);
hold on;
plot(t, fitted_signal, 'r-', 'DisplayName', 'fitted signal', 'LineWidth', 2);
title('PSO with GLRT');
xlabel('time');
ylabel('A');
legend('Location', 'best');
grid on;