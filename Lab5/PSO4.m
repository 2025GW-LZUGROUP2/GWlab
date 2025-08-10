% filepath: ./data/pso_quadratic_chirp.m
% 利用crcbpso进行二次啁啾信号参数PSO搜索（使用白化后的数据）

% 1. 加载白化后的数据
dataStruct = load('C:\Users\30126\Desktop\Matlab专用\whitenedAnalysisData.mat');
varNames = fieldnames(dataStruct);
analysisData = dataStruct.(varNames{1});
analysisData = analysisData(:); % 保证为列向量

% 2. 基本参数
nSamples = length(analysisData);
fs = 1024;
time_vec = (0:(nSamples-1))/fs;

% 3. PSD（与白化前保持一致，实际白化后可用单位PSD，但为兼容GLRT流程仍保留）
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(fs/nSamples);
psd_vec = (posFreq>=100 & posFreq<=300).*(posFreq-100).*(300-posFreq)/10000 + 1;

% 4. PSO参数设置
psoParams = struct();
psoParams.popSize = 50;      % 建议先用较小粒子数加快调试
psoParams.maxSteps = 50;
psoParams.c1 = 0.2;
psoParams.c2 = 0.1;
psoParams.maxVelocity = 0.99;
psoParams.startInertia = 0.99;
psoParams.endInertia = 0.99;
psoParams.boundaryCond = '';

n_runs = 10;                % 建议先用10次，调试通过后可增大
min_bounds = [0, 0, 0];
max_bounds = [100, 100, 100];
dimensions = 3;

results = zeros(n_runs, dimensions+2); % [epoch, cost, pos1, pos2, pos3]

% 5. 定义适应度函数（标准化空间，需映射到实际参数空间）
fitFuncParams = struct('rmin', min_bounds, 'rmax', max_bounds);
obj_func = @(x) -GLRTqcsig(time_vec, analysisData, fs, psd_vec, s2rv(x, fitFuncParams));

for i = 1:n_runs
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