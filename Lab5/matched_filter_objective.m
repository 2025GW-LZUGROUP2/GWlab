function fitness = matched_filter_objective(params, data, fs, psd_est, f_psd, signal_model)
% 匹配滤波目标函数
% params: [A, a1, a2, a3] 参数向量
% data: 分析数据
% fs: 采样频率
% psd_est: 估计的PSD
% f_psd: PSD频率点
% signal_model: 信号模型函数

% 提取参数
A = params(1);
a1 = params(2);
a2 = params(3);
a3 = params(4);

% 生成时间向量
t = (0:length(data)-1) / fs;

% 生成模型信号
model_signal = signal_model(t, A, a1, a2, a3);

% 计算匹配滤波器输出 (简化版本)
% 在实际应用中，这里应该实现完整的匹配滤波过程，包括白化滤波

% 计算负SNR作为目标函数 (最小化)
signal_energy = sum(model_signal.^2);
residual = data - model_signal;
noise_energy = sum(residual.^2);

if noise_energy > 0
    snr = 10 * log10(signal_energy / noise_energy);
else
    snr = -inf;
end

% 返回负SNR作为适应度值 (PSO最小化问题)
fitness = -snr;

% 处理无效值
if isnan(fitness) || isinf(fitness)
    fitness = 1e6;  % 给一个大的惩罚值
end
end