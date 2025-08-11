% Final Lab Script

% 清理工作区和命令行
clear;
clc;
close all;

% --- 1. 加载数据 ---
% 加载训练数据和分析数据
try
    trainingDataStruct = load('TrainingData.mat');
    analysisDataStruct = load('analysisData.mat');
catch
    disp('错误：无法加载 TrainingData.mat 或 analysisData.mat。');
    disp('请确保这些文件与 finalLab.m 在同一目录下。');
    return;
end

% 从结构体中获取数据字段名称
trainingFields = fieldnames(trainingDataStruct);
analysisFields = fieldnames(analysisDataStruct);

% 检查.mat文件是否为空
if isempty(trainingFields) || isempty(analysisFields)
    disp('错误：.mat 文件中不包含任何变量。');
    return;
end

% 假设数据是.mat文件中的第一个变量
% 并假设 'sampFreq' 是一个独立的变量
dataField = '';
for i = 1:length(trainingFields)
    if ~strcmp(trainingFields{i}, 'sampFreq')
        dataField = trainingFields{i};
        break;
    end
end
if isempty(dataField)
    disp('错误：在 TrainingData.mat 中未找到数据变量。');
    return;
end
trainingData = trainingDataStruct.(dataField);

dataField = '';
for i = 1:length(analysisFields)
    if ~strcmp(analysisFields{i}, 'sampFreq')
        dataField = analysisFields{i};
        break;
    end
end
if isempty(dataField)
    disp('错误：在 analysisData.mat 中未找到数据变量。');
    return;
end
analysisData = analysisDataStruct.(dataField);


% 从加载的数据中获取采样频率
% 假设两个文件中的采样频率是相同的
if isfield(trainingDataStruct, 'sampFreq')
    fs = trainingDataStruct.sampFreq;
elseif isfield(analysisDataStruct, 'sampFreq')
    fs = analysisDataStruct.sampFreq;
else
    disp('错误：在加载的数据中未找到采样频率 (sampFreq)。');
    return;
end

% --- 2. 估计功率谱密度 (PSD) ---
% 使用 Welch 方法估计噪声的PSD
% pwelch(x, window, overlap, nfft, fs)
% x: 输入信号 (trainingData)
% window: 窗函数或窗口长度。使用汉宁窗以减少频谱泄漏。
% overlap: 重叠样本数。50%的重叠是常用选择。
% nfft: FFT点数。
% fs: 采样频率。

% 设置pwelch参数
winLen = 4096; % 窗口长度
overlap = winLen / 2; % 50% 重叠

% 使用 trainingData 估计 PSD
[psd, freq] = pwelch(trainingData, hanning(winLen), overlap, winLen, fs);

% pwelch 返回的psd与freq的长度可能和数据长度不一致
% 需要将psd插值到与数据FFT对应的频率点上
N = length(analysisData);
freq_data = (0:N-1)*(fs/N);
psd_interp = interp1(freq, psd, freq_data, 'linear', 'extrap');
psd_interp = psd_interp(:); % 确保为列向量


% --- 3. 设置并运行粒子群优化 (PSO) ---
% 只保留正频率部分的PSD
N = length(analysisData);
k_nyq = floor(N/2)+1;
psd_vec = psd_interp(1:k_nyq);

% 时间向量
time_vec = (0:N-1)/fs;

% 适应度函数：最大化GLRT等价于最小化其负值
fitnessFunc = @(params) -glrtqcsig(time_vec, analysisData, fs, psd_vec, params);

% 搜索范围
lowerBounds = [0, 0, 0];
upperBounds = [100, 100, 100];

nVars = 3;
options = optimoptions('particleswarm', ...
    'SwarmSize', 100, ...
    'MaxIterations', 200, ...
    'Display', 'iter', ...
    'UseParallel', false);

disp('开始运行粒子群优化算法...');
[bestParams, minNegGLRT] = particleswarm(fitnessFunc, nVars, lowerBounds, upperBounds, options);

% --- 4. 显示结果 ---
bestGLRT = -minNegGLRT;
estSNR = sqrt(bestGLRT);

fprintf('\nPSO 搜索完成。\n');
fprintf('最佳拟合参数 [a1, a2, a3]: [%.4f, %.4f, %.4f]\n', bestParams(1), bestParams(2), bestParams(3));
fprintf('对应的GLRT统计量: %.4f\n', bestGLRT);
fprintf('估计的SNR: %.4f\n', estSNR);
