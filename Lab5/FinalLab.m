%% 二次啁啾信号检测 - 使用PSO和匹配滤波
% 任务：使用训练数据估计PSD，然后在分析数据中搜索二次啁啾信号

clear; clc; close all;

%% 1. 加载数据
% 假设训练数据和分析数据已提供
% trainData - 用于估计PSD的训练数据
% analysisData - 需要分析的数据，其中可能包含二次啁啾信号

% 这里我们模拟数据加载过程
% trainData = readmatrix('trainData.txt');
% analysisData = readmatrix('analysisData.txt');

%% 2. 参数设置
fs = 1024;  % 采样频率
% nsamples = length(trainData);  % 样本数

%% 3. 使用Welch方法估计PSD
% 使用pwelch函数估计功率谱密度
[pxx, f] = pwelch(trainData, [], [], [], fs);

% 转换为双边PSD
psd_vec = pxx / 2;

% 生成DFT频率点
data_len = length(trainData) / fs;
k_nyq = length(trainData) / 2 + 1;
pos_freq = (0:k_nyq-1) / data_len;

% 线性插值到所需的DFT频率
psd_interp = interp1(f, psd_vec, pos_freq, 'linear', 'extrap');
f_psd = pos_freq;
psd_est = psd_interp;

%% 4. 绘制估计的PSD
figure;
loglog(f_psd(2:end), psd_est(2:end));  % 跳过直流分量
title('使用Welch方法估计的功率谱密度(PSD)');
xlabel('频率 [Hz]');
ylabel('PSD [V^2/Hz]');
grid on;

%% 5. 定义二次啁啾信号模型
quadratic_chirp = @(t, A, a1, a2, a3) A * sin(2*pi * (a1*t + a2*t.^2 + a3*t.^3));

%% 6. 定义匹配滤波目标函数
objective_function = @(params) matched_filter_objective(params, analysisData, fs, psd_est, f_psd, quadratic_chirp);

%% 7. 设置PSO参数
% 参数边界 [A, a1, a2, a3]
lb = [0.1, 0, 0, 0];      % 下界
ub = [5.0, 50, 50, 50];   % 上界

% PSO选项
pso_options = struct();
pso_options.SwarmSize = 50;
pso_options.MaxIterations = 200;
pso_options.C1 = 1.5;
pso_options.C2 = 1.5;
pso_options.W = 0.7;

%% 8. 运行PSO优化
fprintf('正在运行PSO优化...\n');
[best_params, best_fitness] = pso_optimize(objective_function, lb, ub, pso_options);

fprintf('\n=== PSO优化结果 ===\n');
fprintf('最佳参数:\n');
fprintf('  A (振幅): %.4f\n', best_params(1));
fprintf('  a1: %.4f\n', best_params(2));
fprintf('  a2: %.4f\n', best_params(3));
fprintf('  a3: %.4f\n', best_params(4));
fprintf('最佳适应度值: %.6f\n', best_fitness);

%% 9. 重构最佳拟合信号
t_analysis = (0:length(analysisData)-1) / fs;
best_signal = quadratic_chirp(t_analysis, best_params(1), best_params(2), best_params(3), best_params(4));

%% 10. 计算SNR
signal_power = sum(best_signal.^2) / length(best_signal);
residual = analysisData - best_signal;
noise_power = sum(residual.^2) / length(residual);
estimated_snr = 10 * log10(signal_power / noise_power);

fprintf('估计的SNR: %.2f dB\n', estimated_snr);

%% 11. 可视化结果
figure;
subplot(2,1,1);
plot(t_analysis, analysisData, 'b', 'DisplayName', '分析数据');
hold on;
plot(t_analysis, best_signal, 'r', 'LineWidth', 2, 'DisplayName', '拟合信号');
title('分析数据与最佳拟合信号');
xlabel('时间 [s]');
ylabel('幅度');
legend('Location', 'best');
grid on;

subplot(2,1,2);
plot(t_analysis, residual, 'g', 'LineWidth', 1);
title('残差');
xlabel('时间 [s]');
ylabel('幅度');
grid on;

%% 12. 频域可视化
figure;
N = length(analysisData);
analysisFFT = abs(fft(analysisData));
bestSignalFFT = abs(fft(best_signal));
freqs = (0:N-1) * fs / N;
kNyq = floor(N/2);

plot(freqs(1:kNyq), analysisFFT(1:kNyq), 'b', 'DisplayName', '分析数据FFT');
hold on;
plot(freqs(1:kNyq), bestSignalFFT(1:kNyq), 'r', 'LineWidth', 2, 'DisplayName', '拟合信号FFT');
title('频域比较');
xlabel('频率 [Hz]');
ylabel('幅度');
legend('Location', 'best');
grid on;