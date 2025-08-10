% filepath: ./data/pso_quadratic_chirp.m
% 利用crcbpso全局优化二次啁啾信号参数，目标函数为GLRT（幅度未知）

addpath ../SIGNALS
addpath ../NOISE

%% 数据与参数准备
nSamples = 2048;
sampFreq = 1024;
timeVec = (0:(nSamples-1))/sampFreq;

% PSD
noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);

% 生成信号与数据
a1=9.5; a2=2.8; a3=3.2; A=2;
sig4data = crcbgenqcsig(timeVec,1,[a1,a2,a3]);
[sig4data,~]=normsig4psd(sig4data,sampFreq,psdPosFreq,A);
noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
dataVec = noiseVec+sig4data;

% 目标数据
analysisData = dataVec;
psd_vec = psdPosFreq;
fs = sampFreq;

%% PSO参数
psoParams = struct();
psoParams.popSize = 50;      % 可适当减小加快速度
psoParams.maxSteps = 50;
psoParams.c1 = 0.2;
psoParams.c2 = 0.1;
psoParams.maxVelocity = 0.99;
psoParams.startInertia = 0.99;
psoParams.endInertia = 0.99;
psoParams.boundaryCond = '';

n_runs = 10;                % 建议先用10次
min_bounds = [0, 0, 0];
max_bounds = [100, 100, 100];
dimensions = 3;

results = zeros(n_runs, dimensions+2); % [epoch, cost, pos1, pos2, pos3]

% --------- 定义GLRT目标函数 -------------
obj_func = @(x) -glrtqcsig(timeVec, analysisData, fs, psd_vec, s2rv(x, struct('rmin',min_bounds,'rmax',max_bounds)));

for i = 1:n_runs
    progress = (i / n_runs) * 100;
    fprintf('\rProgress: %.1f%%', progress);

    % PSO全局搜索
    psoOut = crcbpso(obj_func, dimensions, psoParams);

    best_real = s2rv(psoOut.bestLocation, struct('rmin',min_bounds,'rmax',max_bounds));
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

%% --------- glrtqcsig函数实现建议 ----------
% 你需要在路径下有如下函数（可放在单独的glrtqcsig.m文件中）：

% function val = glrtqcsig(time_vec, data_vec, fs, psd_vec, qcCoefs)
%     sigVec = crcbgenqcsig(time_vec,1,qcCoefs);
%     [templateVec,~] = normsig4psd(sigVec,fs,psd_vec,1);
%     llr = innerprodpsd(data_vec,templateVec,fs,psd_vec);
%     val = llr^2;
% end

% 这样PSO每次搜索一组[a1,a2,a3]，都用GLRT作为适应度，自动找到最优参数。