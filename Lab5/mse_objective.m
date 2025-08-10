function loss = mse_objective(params, t, data, func)
% 计算均方误差目标函数
% params: 粒子位置矩阵 (n_particles x 4)
% t: 时间向量
% data: 观测数据
% func: 信号模型函数

% 如果params是向量，则转换为矩阵
if isrow(params) || isvector(params)
    params = params(:)';  % 转换为行向量
end

% 如果params是单个粒子
if size(params, 1) == 1 || size(params, 2) == 4 && size(params, 1) ~= 4
    % 处理单个粒子情况
    A = params(1);
    a1 = params(2);
    a2 = params(3);
    a3 = params(4);
    model = func(t, A, a1, a2, a3);
    loss = mean((data - model).^2);
else
    % 处理多个粒子情况
    n_particles = size(params, 1);
    loss = zeros(n_particles, 1);
    
    for i = 1:n_particles
        A = params(i, 1);
        a1 = params(i, 2);
        a2 = params(i, 3);
        a3 = params(i, 4);
        model = func(t, A, a1, a2, a3);
        loss(i) = mean((data - model).^2);
    end
end
end