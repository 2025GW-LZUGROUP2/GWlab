% 完全对齐你给的 Python 流程的 MATLAB 版本
% - 时间基准：t = (0:N-1)/fs
% - Welch: nperseg=256
% - PSD: 插值到正频 DFT 后，**除以 2**（与Python一致）
% - 目标函数：sin单模板GLRT（GLRT = LLR^2），PSO 最小化 -GLRT
% - PSO: GlobalBestPSO 风格（c1=0.2, c2=0.1, w=0.99），100粒子，100 迭代，独立重复 n_runs 次，取最小
% !!! 警告：n_runs=2000 非常慢（Python 也一样）。先小一点试通再拉满。

% clear; clc; close all;

% === 读数据 ===
S1 = load('TrainingData.mat');   % fields: trainData, sampFreq
S2 = load('analysisData.mat');   % fields: dataVec, sampFreq
fs   = double(S1.sampFreq);
xTr  = S1.trainData(:).';
xAna = S2.dataVec(:).';
nsamples = numel(xAna);
time_vec = (0:nsamples-1)/fs;

fprintf('sample frequency: %.0f\n', fs);
fprintf('analysis data shape: [%d]\n', nsamples);

% === Welch 单边 PSD ===
[f, psd_vec_one] = estimatePSD_welch(xTr, fs);  % one-sided PSD（密度）
% === 插值到正频 DFT ===
psd_pos = interpPSD2DFTBins(f, psd_vec_one, nsamples, fs);
% === 与 Python 完全一致：除以 2 ===
psd_pos = psd_pos/2;

% 可视化 PSD（与 Python 类似）
figure; plot(f, psd_vec_one); grid on;
title('Estimated PSD (Welch, one-sided)'); xlabel('Hz'); ylabel('PSD (density)');

% === 目标函数（PSO 要求批量） ===
% 输入：qcCoefs_mat [n_particles x 3]，输出：每行一个 -GLRT 值
obj_fun = @(qcCoefs_mat) batch_neg_glrt(qcCoefs_mat, time_vec, xAna, fs, psd_pos);

% === PSO 参数（与Python近似） ===
c1 = 0.2; c2 = 0.1; w = 0.99;
popSize = 100;        % 粒子数
iters   = 100;        % 每个PSO运行迭代步数
n_runs  = 30;       % !!! 非常慢，先改小比如 100 再拉到2000

% 搜索边界（与Python一致）
min_bounds = [0,0,0];
max_bounds = [100,100,100];

% === 多次独立运行，取最优 ===
results = zeros(n_runs, 1+3);  % [cost , a1 a2 a3]
best_cost = inf; best_pos = [NaN,NaN,NaN];

for ep = 1:n_runs
    % 进度条（和Python打印类似）
    fprintf('\rProgress: %5.1f%%', ep*100/n_runs);
    
    % 随机初始化种群（在边界内均匀）
    swarm = rand(popSize,3).* (max_bounds - min_bounds) + min_bounds;
    vel   = zeros(popSize,3);
    pbest_pos = swarm;
    pbest_val = obj_fun(swarm);                 % 计算初值 -GLRT
    [gbest_val, idx] = min(pbest_val);
    gbest_pos = pbest_pos(idx,:);
    
    % 迭代
    for it = 1:iters
        % 更新速度、位置（GlobalBest）
        r1 = rand(popSize,3); r2 = rand(popSize,3);
        vel = w*vel + c1*r1.*(pbest_pos - swarm) + c2*r2.*(repmat(gbest_pos,popSize,1) - swarm);
        swarm = swarm + vel;
        % 约束到边界
        swarm = max(swarm, repmat(min_bounds,popSize,1));
        swarm = min(swarm, repmat(max_bounds,popSize,1));
        % 计算适应度
        fvals = obj_fun(swarm);
        % 更新pbest、gbest
        upd = fvals < pbest_val;
        pbest_pos(upd,:) = swarm(upd,:);
        pbest_val(upd)   = fvals(upd);
        [cur_best, idx]  = min(pbest_val);
        if cur_best < gbest_val
            gbest_val = cur_best;
            gbest_pos = pbest_pos(idx,:);
        end
    end
    
    results(ep,:) = [gbest_val, gbest_pos];
    if gbest_val < best_cost
        best_cost = gbest_val;
        best_pos  = gbest_pos;
    end
end
fprintf('\n');

% === 打印最优 ===
fprintf('result corresponding to min cost:\n');
fprintf('Epoch： %d\n', find(results(:,1)==best_cost,1,'first')-1); % 0-based 风格
fprintf('cost(-GLRT)： %0.14f\n\n', best_cost);
fprintf('Estimated parameters of the quadratic chirp signal:\n');
fprintf('position[a1,a2,a3]： [%0.8f %0.8f %0.8f]\n', best_pos(1), best_pos(2), best_pos(3));
fprintf('Estimated SNR: %0.12f\n', sqrt(-best_cost));

% === 画“成本 vs 轮次”的曲线（与Python类似） ===
figure; plot(0:n_runs-1, results(:,1), '-o'); grid on;
title('Cost vs Epochs'); xlabel('Epochs'); ylabel('Cost (-GLRT)');

% === 辅助函数（批量 -GLRT） ===
function out = batch_neg_glrt(qcCoefs_mat, time_vec, data_vec, fs, psd_pos)
nP = size(qcCoefs_mat,1);
out = zeros(nP,1);
for i=1:nP
    glrt = glrtqcsig(time_vec, data_vec, fs, psd_pos, qcCoefs_mat(i,:));
    out(i) = -glrt;       % PSO 最小化 -GLRT
end
end
