% filepath: ./data/pso_quadratic_chirp.m
% 利用crcbpso进行二次啁啾信号参数PSO搜索
% 使用白化后的数据

% 1. 加载白化后的数据
dataStruct = load('c:\Users\30126\Desktop\Matlab专用\whitenedAnalysisData.mat');
varNames = fieldnames(dataStruct);
analysisData = dataStruct.(varNames{1});
analysisData = analysisData(:); % 保证为列向量

% 2. 构造时间向量
nSamples = length(analysisData);
fs = 1024;
time_vec = (0:(nSamples-1))/fs;

% 3. PSO参数设置
psoParams = struct();
psoParams.popSize = 100;      % 粒子数
psoParams.maxSteps = 100;     % 每次PSO迭代步数
psoParams.c1 = 0.2;           % 认知因子
psoParams.c2 = 0.1;           % 社会因子
psoParams.maxVelocity = 0.99; % 最大速度
psoParams.startInertia = 0.99;% 初始惯性权重
psoParams.endInertia = 0.99;  % 终止惯性权重
psoParams.boundaryCond = '';  % 边界条件

n_runs = 1000;                % PSO运行次数
min_bounds = [0, 0, 0];
max_bounds = [100, 100, 100];
dimensions = 3;

results = zeros(n_runs, dimensions+2); % [epoch, cost, pos1, pos2, pos3]

% 4. 构造适应度函数参数
fitFuncParams = struct();
fitFuncParams.rmin = min_bounds;
fitFuncParams.rmax = max_bounds;
fitFuncParams.dataY = analysisData(:)';         % 数据向量
fitFuncParams.dataX = time_vec(:)';             % 时间向量
fitFuncParams.dataXSq = (time_vec(:)').^2;      % 时间平方
fitFuncParams.dataXCb = (time_vec(:)').^3;      % 时间立方

% 5. 适应度函数句柄
obj_func = @(x) crcbqcfitfunc(x, fitFuncParams);

for i = 1:n_runs
    pause(0.1);
    progress = (i / n_runs) * 100;
    fprintf('\rProgress: %.1f%%', progress);

    % 调用crcbpso，返回结构体
    psoOut = crcbpso(obj_func, dimensions, psoParams);

    % 记录结果（注意bestLocation为标准化坐标，需转为实际参数）
    best_real = s2rv(psoOut.bestLocation, fitFuncParams);
    results(i, :) = [i, psoOut.bestFitness, best_real(:)'];
end

% 找到最优结果
[~, idx] = min(results(:,2));
best_record = results(idx, :);

fprintf('\nresult corresponding to min cost:\n');
fprintf('Epoch: %d\n', best_record(1));
fprintf('cost(-GLRT): %f\n', best_record(2));
fprintf('\nEstimated parameters of the quadratic chirp signal:\n');
fprintf('position[a1,a2,a3]: [%f, %f, %f]\n', best_record(3), best_record(4), best_record(5));
fprintf('Estimated SNR: %f\n', sqrt(-best_record(2)));

% 绘制 cost vs epoch
figure;
plot(results(:,1), results(:,2), 'o-');
title('Cost vs Epochs');
xlabel('Epochs');
ylabel('Cost');
grid on;