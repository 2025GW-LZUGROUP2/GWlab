% Lab Topic 3 综合程序：噪声生成、分析与处理
% 功能：实现高斯白噪声生成、有色噪声生成、PSD估计、数据白化及LIGO噪声模拟
% 所有功能整合在一个程序中，每步操作均添加详细注释

% 清除工作区变量、关闭所有图形窗口、清空命令行
clear all;  % 清除工作区所有变量，避免历史变量干扰
close all;  % 关闭所有打开的图形窗口，确保绘图环境干净
clc;        % 清空命令行窗口，便于查看输出信息

%% ================== 1. 基础高斯白噪声(WGN)生成与分析 ==================
% 生成不同均值(μ)和标准差(σ)的高斯白噪声，验证其统计特性

% 定义噪声样本数量（样本数越多，统计特性越接近理论值）
nSamples_wgn = 10000;  

% 定义4组高斯噪声参数：每行对应[均值μ, 标准差σ]
mu_sigma = [0, 1;       % 第1组：μ=0, σ=1
            0, 2;       % 第2组：μ=0, σ=2
            0, sqrt(2); % 第3组：μ=0, σ=√2
            2, sqrt(2)];% 第4组：μ=2, σ=√2

% 创建图形窗口，用于显示高斯噪声分布
figure('Name', '高斯白噪声分布（直方图与理论PDF）- Gaussian White Noise Distribution (Histogram vs Theoretical PDF)'); 

% 循环生成4组噪声并绘图
for i = 1:4
    % 提取当前组的均值和标准差
    mu = mu_sigma(i, 1);     % 均值
    sigma = mu_sigma(i, 2);  % 标准差
    
    % 生成高斯白噪声：公式为μ + σ×randn()，randn()生成标准正态分布(μ=0,σ=1)
    wgn_signal = mu + sigma * randn(1, nSamples_wgn);
    
    % 创建2×2子图，当前绘制第i个位置
    subplot(2, 2, i);
    
    % 绘制噪声的直方图，归一化方式为概率密度函数(PDF)，分50个 bins
    histogram(wgn_signal, 50, 'Normalization', 'pdf');
    hold on;  % 保持当前图形，后续可叠加绘制
    
    % 生成理论PDF的x轴范围（从噪声最小值到最大值，取1000个点）
    x_range = linspace(min(wgn_signal), max(wgn_signal), 1000);
    
    % 绘制理论正态分布PDF曲线（红色，线宽2）
    plot(x_range, normpdf(x_range, mu, sigma), 'r', 'LineWidth', 2);
    
    % 设置子图标题，显示当前均值和标准差
    title(sprintf('均值μ=%.1f, 标准差σ=%.1f - Mean μ=%.1f, Std σ=%.1f', mu, sigma, mu, sigma));
    xlabel('噪声值 - Noise Value');       % x轴标签
    ylabel('概率密度 - Probability Density');     % y轴标签
    grid on;                % 显示网格线，便于观察
    
    % 在命令行输出实际计算的均值和标准差，验证与理论值的一致性
    fprintf('高斯噪声组 %d: 实际均值=%.4f, 实际标准差=%.4f - Gaussian Noise Group %d: Actual Mean=%.4f, Actual Std=%.4f\n', ...
            i, mean(wgn_signal), std(wgn_signal), i, mean(wgn_signal), std(wgn_signal));
end

%% ================== 2. 有色噪声生成 ==================
% 根据目标功率谱密度(PSD)生成有色噪声（非白噪声，频谱特性非平坦）

% 定义采样频率（Hz），表示每秒采集的样本数
sampFreq_color = 1024;  

% 定义有色噪声的样本数量（2的整数次幂便于后续FFT处理）
nSamples_color = 16384;  

% 生成时间向量（单位：秒），从0到(nSamples_color-1)/sampFreq_color
timeVec_color = (0:nSamples_color-1) / sampFreq_color;

% 定义目标PSD函数（抛物线形状，仅在100-300Hz有值）
% 公式：(f-100)*(300-f)/10000，其中f在100-300Hz之间，其他频率为0
targetPSD = @(f) (f >= 100 & f <= 300) .* (f - 100) .* (300 - f) / 10000;

% 生成频率向量（确保包含0和奈奎斯特频率，且严格递增）
nyquist_color = sampFreq_color / 2;  % 奈奎斯特频率
freqVec_color = 0:0.1:nyquist_color;  % 从0开始到奈奎斯特频率，步长0.1Hz

% 计算目标PSD在上述频率点的值
psdVec_color = targetPSD(freqVec_color);

% 定义FIR滤波器阶数（阶数越高，滤波效果越接近目标，但计算量越大）
fltrOrdr_color = 500;

% 调用自定义函数生成符合目标PSD的有色噪声
coloredNoise = statgaussnoisegen(nSamples_color, ...  % 样本数
                                 [freqVec_color(:), psdVec_color(:)], ...  % 频率-PSD矩阵
                                 fltrOrdr_color, ...  % 滤波器阶数
                                 sampFreq_color);     % 采样频率

% 创建图形窗口，显示有色噪声的目标PSD和时域波形
figure('Name', '有色噪声生成结果 - Colored Noise Generation Results');

% 第1个子图：绘制目标PSD曲线
subplot(2, 1, 1);
plot(freqVec_color, psdVec_color, 'LineWidth', 2);  % 线宽2，清晰显示
title('目标功率谱密度(PSD) - Target Power Spectral Density');  % 子图标题
xlabel('频率 (Hz) - Frequency (Hz)');           % x轴标签
ylabel('PSD值 - PSD Value');               % y轴标签
grid on;                       % 显示网格

% 第2个子图：绘制有色噪声的时域波形（仅显示前1秒数据，避免过于密集）
subplot(2, 1, 2);
plot(timeVec_color, coloredNoise);  % 时间-幅值曲线
title('有色噪声时域波形 - Colored Noise Time-Domain Waveform');          % 子图标题
xlabel('时间 (秒) - Time (seconds)');                % x轴标签
ylabel('噪声幅值 - Noise Amplitude');                 % y轴标签
xlim([0, 1]);  % 限制x轴范围为0-1秒，便于观察细节
grid on;       % 显示网格

%% ================== 3. 功率谱密度(PSD)估计 ==================
% 使用Welch方法估计有色噪声的PSD，并与目标PSD对比

% 调用pwelch函数估计PSD：
% 输入：噪声信号、窗长512、无重叠（默认）、FFT点数（默认与窗长相同）、采样频率
% 输出：估计的PSD值(pxx)和对应的频率向量(f)
[pxx_est, f_est] = pwelch(coloredNoise, 512, [], [], sampFreq_color);

% 创建图形窗口，对比估计的PSD与目标PSD
figure('Name', 'PSD估计与目标对比 - PSD Estimation vs Target Comparison');
plot(f_est, pxx_est, 'b', 'LineWidth', 1.5);  % 绘制估计的PSD（蓝色）
hold on;  % 保持图形，叠加绘制目标PSD
plot(freqVec_color, psdVec_color, 'r--', 'LineWidth', 2);  % 目标PSD（红色虚线）
xlabel('频率 (Hz) - Frequency (Hz)');  % x轴标签
ylabel('功率谱密度(PSD) - Power Spectral Density');  % y轴标签
legend('Welch方法估计的PSD - Estimated PSD by Welch Method', '目标PSD - Target PSD');  % 图例说明
title('PSD估计结果与目标对比 - PSD Estimation Results vs Target');  % 图形标题
grid on;  % 显示网格

%% ================== 4. 数据白化处理 ==================
% 对含噪声的信号进行白化处理（使噪声功率谱平坦），提高信噪比

% 加载测试数据（假设文件为testData.txt，第1列是时间，第2列是信号）
% 注意：请确保当前目录下存在该文件，或修改为实际文件路径
testData = load('testData.txt');  % 加载数据
timeVec_data = testData(:, 1);    % 提取时间向量
dataVec = testData(:, 2);         % 提取信号数据

% 定义信号开始时间（用于区分纯噪声段和含信号段）
signalStart = 5.0;  % 信号在5秒时开始

% 提取纯噪声部分（信号开始前的数据）
noiseOnly = dataVec(timeVec_data < signalStart);

% 计算采样频率（根据时间向量的间隔，1/(t2-t1)）
sampFreq_data = 1 / (timeVec_data(2) - timeVec_data(1));

% 估计噪声的PSD（使用Welch方法）
nfft = 1024;  % FFT点数，影响频率分辨率
[pxx_noise, freqVec_noise] = pwelch(noiseOnly, nfft, [], nfft, sampFreq_data);
psdVec_noise = pxx_noise;  % 单边PSD（pwelch默认返回单边）

% 设计白化滤波器的传递函数：1/sqrt(PSD)（使输出噪声PSD为1）
whiteningTF = 1 ./ sqrt(psdVec_noise);
% 处理PSD为0导致的无穷大值（设置为0，避免计算错误）
whiteningTF(isinf(whiteningTF)) = 0;

% 对原始数据进行频域白化处理
dataFFT = fft(dataVec, nfft);  % 对信号做FFT（点数nfft）
freqBins = floor(nfft / 2) + 1;  % 单边频谱的点数（0到Nyquist频率）
% 频域相乘：用白化滤波器传递函数处理单边频谱
whitenedFFT = dataFFT(1:freqBins) .* whiteningTF;

% 将频域白化结果转换回时域（取实部，确保信号为实数）
whitenedData = real(ifft(whitenedFFT, length(dataVec)));

% 创建图形窗口，对比白化前后的数据
figure('Name', '数据白化效果对比 - Data Whitening Effect Comparison');

% 第1个子图：原始数据（含噪声和信号）
subplot(2, 1, 1);
plot(timeVec_data, dataVec);  % 绘制原始数据
title('原始数据（含噪声和信号）- Original Data (with Noise and Signal)');  % 子图标题
xlabel('时间 (秒) - Time (seconds)');                % x轴标签
ylabel('信号幅值 - Signal Amplitude');                 % y轴标签
xline(signalStart, 'r--', '信号开始 - Signal Start');  % 标记信号开始时间（红色虚线）
grid on;  % 显示网格

% 第2个子图：白化后的数据
subplot(2, 1, 2);
plot(timeVec_data, whitenedData);  % 绘制白化后数据
title('白化处理后的数据 - Whitened Data');          % 子图标题
xlabel('时间 (秒) - Time (seconds)');                % x轴标签
ylabel('信号幅值 - Signal Amplitude');                 % y轴标签
xline(signalStart, 'r--', '信号开始 - Signal Start');  % 标记信号开始时间
grid on;  % 显示网格

% 计算并输出白化前后的信噪比（SNR），验证白化效果
% 信噪比定义：信号段功率 / 噪声段功率
% 白化前SNR：信号段（时间>signalStart）的均值平方 / 噪声段方差
snr_before = mean(dataVec(timeVec_data > signalStart).^2) / var(noiseOnly);
% 白化后SNR：白化后信号段的均值平方 / 白化后噪声段的方差
snr_after = mean(whitenedData(timeVec_data > signalStart).^2) / ...
            var(whitenedData(timeVec_data < signalStart));

% 在命令行输出SNR结果
fprintf('白化前信噪比: %.4f - SNR Before Whitening: %.4f\n', snr_before, snr_before);
fprintf('白化后信噪比: %.4f - SNR After Whitening: %.4f\n', snr_after, snr_after);

%% ================== 5. LIGO噪声模拟 ==================
% 基于LIGO引力波探测器的灵敏度曲线，模拟其噪声特性

% 加载LIGO灵敏度曲线数据（文件iLIGOSensitivity.txt，第1列频率，第2列ASD）
% ASD（振幅谱密度）= sqrt(PSD)，单位1/√Hz
% 注意：请确保当前目录下存在该文件，或修改为实际文件路径
ligoSens = load('iLIGOSensitivity.txt');
freqLigo = ligoSens(:, 1);  % 频率向量（Hz）
asdLigo = ligoSens(:, 2);   % 振幅谱密度（ASD）

% 将ASD转换为双边PSD（功率谱密度）：PSD = ASD² / 2（双边谱需除以2）
psdLigo = (asdLigo) .^ 2 / 2;

% 设置频带限制（LIGO主要敏感频段：40-700Hz）
fLow_ligo = 40;    % 低频截止
fHigh_ligo = 700;  % 高频截止

% 处理频段外的PSD（设为频段边缘的值，避免频率响应突变）
% 低于40Hz的频率，PSD设为40Hz处的值
psdLigo(freqLigo < fLow_ligo) = psdLigo(find(freqLigo >= fLow_ligo, 1));
% 高于700Hz的频率，PSD设为700Hz处的值
psdLigo(freqLigo > fHigh_ligo) = psdLigo(find(freqLigo <= fHigh_ligo, 1, 'last'));

% 定义LIGO噪声的采样参数
sampFreqLigo = 4096;  % LIGO实际采样频率（Hz）
nSamplesLigo = 16384; % 噪声样本数
nyquistLigo = sampFreqLigo / 2;  % 计算奈奎斯特频率

% 关键修复：首先限制频率范围到奈奎斯特频率以内
% 过滤掉超过奈奎斯特频率的数据点
validIdx = freqLigo <= nyquistLigo;
freqLigo = freqLigo(validIdx);
psdLigo = psdLigo(validIdx);

% 确保频率向量包含0和奈奎斯特频率，满足fir2函数要求
if freqLigo(1) ~= 0
    % 在频率向量开头添加0频率点，PSD值与第一个点相同
    freqLigo = [0; freqLigo];
    psdLigo = [psdLigo(1); psdLigo];
end
if freqLigo(end) ~= nyquistLigo
    % 在频率向量末尾添加奈奎斯特频率点，PSD值与最后一个点相同
    freqLigo = [freqLigo; nyquistLigo];
    psdLigo = [psdLigo; psdLigo(end)];
end

% 确保频率向量严格非递减排序
[ freqLigo, sortIdx ] = sort(freqLigo);  % 对频率进行排序
psdLigo = psdLigo(sortIdx);             % 按相同顺序排序PSD值

% 去除可能的重复频率点（fir2不允许重复频率）
[ freqLigo, uniqueIdx ] = unique(freqLigo);  % 保留唯一频率点
psdLigo = psdLigo(uniqueIdx);                % 对应调整PSD值

% 输出调试信息，帮助诊断问题
fprintf('频率向量长度: %d - Frequency Vector Length: %d\n', length(freqLigo), length(freqLigo));
fprintf('第一个频率: %.4f, 最后一个频率: %.4f - First Frequency: %.4f, Last Frequency: %.4f\n', freqLigo(1), freqLigo(end), freqLigo(1), freqLigo(end));
fprintf('奈奎斯特频率: %.4f - Nyquist Frequency: %.4f\n', nyquistLigo, nyquistLigo);
fprintf('频率向量是否单调递增: %d - Is Frequency Vector Monotonically Increasing: %d\n', issorted(freqLigo), issorted(freqLigo));
fprintf('归一化后的最后频率: %.4f - Normalized Last Frequency: %.4f\n', freqLigo(end)/(sampFreqLigo/2), freqLigo(end)/(sampFreqLigo/2));

% 生成符合LIGO PSD的噪声
ligoNoise = statgaussnoisegen(nSamplesLigo, ...  % 样本数
                              [freqLigo, psdLigo], ...  % 频率-PSD矩阵
                              1000, ...  % 滤波器阶数（更高阶数，更接近目标）
                              sampFreqLigo);  % 采样频率

% 估计生成的LIGO噪声的PSD（验证效果）
[pxxLigo, fLigo] = pwelch(ligoNoise, 2048, [], 2048, sampFreqLigo);

% 创建图形窗口，显示LIGO噪声模拟结果
figure('Name', 'LIGO噪声模拟与验证 - LIGO Noise Simulation and Verification');

% 第1个子图：对比目标ASD与模拟噪声的ASD（对数坐标）
subplot(2, 1, 1);
loglog(freqLigo, sqrt(psdLigo * 2));  % 目标ASD（sqrt(双边PSD×2)=sqrt(单边PSD)）
hold on;
loglog(fLigo, sqrt(pxxLigo), 'r');    % 模拟噪声的ASD（pwelch返回单边PSD）
title('LIGO灵敏度曲线对比 - LIGO Sensitivity Curve Comparison');          % 子图标题
xlabel('频率 (Hz) - Frequency (Hz)');                  % x轴标签
ylabel('振幅谱密度 (1/√Hz) - Amplitude Spectral Density (1/√Hz)');     % y轴标签
legend('目标ASD - Target ASD', '模拟噪声ASD - Simulated Noise ASD');     % 图例
grid on;  % 对数坐标下网格更易读

% 第2个子图：LIGO噪声的时域波形（显示前2秒数据）
subplot(2, 1, 2);
timeVecLigo = (0:nSamplesLigo-1) / sampFreqLigo;  % 时间向量
plot(timeVecLigo, ligoNoise);  % 绘制时域波形
xlabel('时间 (秒) - Time (seconds)');            % x轴标签
ylabel('应变值 - Strain Value');               % y轴标签（LIGO测量的是时空应变）
title('LIGO噪声时域波形 - LIGO Noise Time-Domain Waveform');      % 子图标题
xlim([0, 2]);  % 限制显示前2秒，避免波形过密
grid on;       % 显示网格


