% 测试Signal类并绘制时间序列图和周期图
% (1) 创建信号对象
% (2) 绘制时间序列图
% (3) 绘制正频段周期图

% 清除工作区和图形
clear; clc; close all;

% 创建时间向量 (0到1秒，采样间隔0.001秒)
t_vec = 0:0.001:1;

% 定义符号变量
syms t A a1 a2 a3;

% 定义信号表达式: 二次调频信号
expr = A * sin(2*pi*(a1*t + a2*t^2 + a3*t^3));

% 创建Signal对象
s = Signal('QuadraticChirp', t_vec, expr, t, {'A', 'a1', 'a2', 'a3'}, [2, 10, 5, 1]);

% 绘制时间序列图
figure;
subplot(2,1,1);
plot(s.timeVec, s.SigVec, 'b-', 'LineWidth', 1.2);
xlabel('时间 (秒)');
ylabel('幅度');
title(['信号 "' s.name '" 时间序列图']);
grid on;

% 计算并绘制正频段周期图
% 使用FFT计算频谱
N = length(s.SigVec);
Y = fft(s.SigVec);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);

% 创建频率轴 (Hz)
fs = 1/(s.timeVec(2)-s.timeVec(1)); % 采样频率
f = fs*(0:(N/2))/N;

% 绘制周期图
subplot(2,1,2);
plot(f, P1, 'r-', 'LineWidth', 1.2);
xlabel('频率 (Hz)');
ylabel('幅度');
title(['信号 "' s.name '" 正频段周期图']);
grid on;
xlim([0 max(f)]); % 只显示正频率部分

% 调整图形布局
sgtitle(['信号 "' s.name '" 分析结果'], 'FontSize', 14);