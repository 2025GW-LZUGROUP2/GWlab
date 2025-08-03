%% 二次调频信号生成与分析
% 本脚本演示了二次调频信号的生成、时域分析、频域分析和时频分析
% 作者：[您的姓名]
% 日期：[当前日期]
% 版本：1.0

%% 参数设置
% 相位参数（决定瞬时频率的变化）
% φ(t) = a1·t + a2·t² + a3·t³
% 瞬时频率 f(t) = (1/2π)·dφ(t)/dt = (1/2π)·(a1 + 2a2·t + 3a3·t²)
a1 = 10;  % 相位一阶项系数（对应常数频率分量）
a2 = 3;   % 相位二阶项系数（对应线性调频分量）
a3 = 3;   % 相位三阶项系数（对应二次调频分量）
A = 10;   % 信号幅度

%% Nyquist频率计算
% 信号的最大瞬时角频率（在t=1秒时达到）
% f_angular(t) = a1 + 2a2·t + 3a3·t²，代入t=1得到：
maxAngFreq = a1 + 2*a2 + 3*a3;
% 信号的最大瞬时频率 (Hz)
maxFreqHz = maxAngFreq / (2*pi);
fprintf('信号最大瞬时频率: %.2f Hz\n', maxFreqHz);

% Nyquist频率（定义一：临界采样频率）
% 根据采样定理，采样频率至少为信号最高频率的两倍
nyqRate = 2*maxFreqHz;
fprintf('Nyquist频率(临界采样频率): %.2f Hz\n', nyqRate);

% 实际采样频率（设为Nyquist频率的5倍，以确保充分采样）
samplFreq = 5*nyqRate;
fprintf('实际采样频率: %.2f Hz\n', samplFreq);

% 采样间隔
samplIntrvl = 1/samplFreq;

%% 信号生成
% 时间向量（0到1秒）
timeVec = 0:samplIntrvl:1.0;
% 样本数量
nSamples = length(timeVec);
fprintf('样本数量: %d\n', nSamples);

% 生成二次调频信号
sigVec = crcbgenqcsig(timeVec, A, [a1, a2, a3]);

%% 时域分析与可视化
figure('Name', '时域信号', 'NumberTitle', 'off');
plot(timeVec, sigVec, 'Marker', '.', 'MarkerSize', 12);
grid on;
xlabel('时间 (秒)', 'FontSize', 12);
ylabel('幅度', 'FontSize', 12);
title('二次调频信号的时域表示', 'FontSize', 14);
annotation('textbox', [0.15, 0.8, 0.3, 0.1], 'String', ...
    sprintf('相位参数: a1=%.1f, a2=%.1f, a3=%.1f', a1, a2, a3), ...
    'FitBoxToText', 'on', 'BackgroundColor', 'white');

%% 频域分析 - 包含正负频率的完整频谱
% 数据长度（秒）
dataLen = timeVec(end) - timeVec(1);

% 计算频率向量（包括正负频率）
allFreq = ((-samplFreq/2):(-samplFreq/2+(nSamples-1)*(1/dataLen)));

% 计算FFT并将零频率分量移到中心
fftSig = fft(sigVec);
fftSig_shifted = fftshift(fftSig);

% 绘制完整频谱（包含正负频率）
figure('Name', '完整频谱', 'NumberTitle', 'off');
plot(allFreq, abs(fftSig_shifted));
grid on;
xlabel('频率 (Hz)', 'FontSize', 12);
ylabel('幅度', 'FontSize', 12);
title('完整频谱（包含正负频率）', 'FontSize', 14);

% 添加最大频率标记
hold on;
plot([-maxFreqHz maxFreqHz], [max(abs(fftSig_shifted))*0.8 max(abs(fftSig_shifted))*0.8], 'ro', 'MarkerSize', 10);
text(-maxFreqHz, max(abs(fftSig_shifted))*0.85, '最大频率', 'Color', 'r');
text(maxFreqHz, max(abs(fftSig_shifted))*0.85, '最大频率', 'Color', 'r');
hold off;

%% 频域分析 - 仅正频率的周期图
% Nyquist频率（定义二：采样率的一半）- 对应的FFT索引
kNyq = floor(nSamples/2) + 1;
fprintf('Nyquist频率(采样率一半): %.2f Hz\n', samplFreq/2);

% 正频率向量
posFreq = (0:(kNyq-1))*(1/dataLen);

% 提取正频率部分的FFT（实信号的FFT具有共轭对称性，所以只需要保留一半）
fftSig_pos = fftSig(1:kNyq);

% 绘制周期图（仅正频率）
figure('Name', '周期图（正频率）', 'NumberTitle', 'off');
plot(posFreq, abs(fftSig_pos));
grid on;
xlabel('频率 (Hz)', 'FontSize', 12);
ylabel('幅度', 'FontSize', 12);
title('信号周期图（仅正频率）', 'FontSize', 14);

% 添加最大频率标记
hold on;
plot(maxFreqHz, max(abs(fftSig_pos))*0.8, 'ro', 'MarkerSize', 10);
text(maxFreqHz, max(abs(fftSig_pos))*0.85, '最大频率', 'Color', 'r');
hold off;

%% 时频分析 - 频谱图
% 窗口长度和重叠参数（秒）
winLen = 0.2;  % 窗口长度（秒）
ovrlp = 0.1;   % 重叠长度（秒）

% 转换为对应的采样点数
winLenSmpls = floor(winLen*samplFreq);
ovrlpSmpls = floor(ovrlp*samplFreq);

% 计算频谱图
[S, F, T] = spectrogram(sigVec, winLenSmpls, ovrlpSmpls, [], samplFreq);

% 绘制频谱图
figure('Name', '频谱图', 'NumberTitle', 'off');
imagesc(T, F, abs(S)); 
axis xy;  % 设置y轴正常显示（从下到上增加）
colorbar;  % 添加颜色条
xlabel('时间 (秒)', 'FontSize', 12);
ylabel('频率 (Hz)', 'FontSize', 12);
title('信号的时频表示（频谱图）', 'FontSize', 14);

% 添加理论瞬时频率曲线 (Hz)
hold on;
instFreqHz = @(t) (a1 + 2*a2*t + 3*a3*t.^2) / (2*pi);  % 瞬时频率函数 (Hz)
t_curve = linspace(0, 1, 100);
plot(t_curve, instFreqHz(t_curve), 'r--', 'LineWidth', 2);
legend('理论瞬时频率', 'Location', 'northwest');
hold off;

% 打印窗口参数信息
fprintf('频谱图参数 - 窗口长度: %.3f 秒 (%d 样本), 重叠: %.3f 秒 (%d 样本)\n', ...
    winLen, winLenSmpls, ovrlp, ovrlpSmpls);
