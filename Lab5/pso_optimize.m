function [best_position, best_cost] = pso_optimize(objective_func, lb, ub, options)
% 粒子群优化算法实现
% objective_func: 目标函数句柄
% lb: 下界向量
% ub: 上界向量
% options: PSO参数结构体

% 设置默认参数
if ~isfield(options, 'SwarmSize')
    options.SwarmSize = 30;
end
if ~isfield(options, 'MaxIterations')
    options.MaxIterations = 100;
end
if ~isfield(options, 'C1')
    options.C1 = 1.5;
end
if ~isfield(options, 'C2')
    options.C2 = 1.5;
end
if ~isfield(options, 'W')
    options.W = 0.7;
end

dimensions = length(lb);

% 初始化粒子群
positions = repmat(lb, options.SwarmSize, 1) + ...
    repmat(ub - lb, options.SwarmSize, 1) .* rand(options.SwarmSize, dimensions);
velocities = 0.1 * (repmat(ub - lb, options.SwarmSize, 1) .* (rand(options.SwarmSize, dimensions) - 0.5));

% 计算初始适应度
costs = zeros(options.SwarmSize, 1);
for i = 1:options.SwarmSize
    costs(i) = objective_func(positions(i, :));
end

% 初始化个体最佳位置和适应度
pbest_positions = positions;
pbest_costs = costs;

% 初始化全局最佳位置和适应度
[best_cost, best_index] = min(pbest_costs);
best_position = pbest_positions(best_index, :);

% 记录最优适应度历史
cost_history = zeros(options.MaxIterations, 1);

% PSO主循环
for iter = 1:options.MaxIterations
    % 更新粒子速度和位置
    r1 = rand(options.SwarmSize, dimensions);
    r2 = rand(options.SwarmSize, dimensions);
    
    velocities = options.W * velocities + ...
        options.C1 * r1 .* (pbest_positions - positions) + ...
        options.C2 * r2 .* (repmat(best_position, options.SwarmSize, 1) - positions);
    
    % 更新位置
    positions = positions + velocities;
    
    % 处理边界约束
    positions = max(repmat(lb, options.SwarmSize, 1), ...
        min(repmat(ub, options.SwarmSize, 1), positions));
    
    % 计算新的适应度
    for i = 1:options.SwarmSize
        costs(i) = objective_func(positions(i, :));
    end
    
    % 更新个体最佳
    better_indices = costs < pbest_costs;
    pbest_costs(better_indices) = costs(better_indices);
    pbest_positions(better_indices, :) = positions(better_indices, :);
    
    % 更新全局最佳
    [current_best_cost, current_best_index] = min(costs);
    if current_best_cost < best_cost
        best_cost = current_best_cost;
        best_position = positions(current_best_index, :);
    end
    
    cost_history(iter) = best_cost;
    
    % 显示进度
    if mod(iter, 20) == 0
        fprintf('迭代 %d: 最佳适应度 = %.6f\n', iter, best_cost);
    end
end

% 绘制收敛曲线
figure;
semilogy(1:options.MaxIterations, cost_history, 'b-', 'LineWidth', 1.5);
title('PSO收敛曲线');
xlabel('迭代次数');
ylabel('最佳适应度值');
grid on;

end