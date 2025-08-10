% 测试Signal类并绘制不同SNR值的信号时间序列图
% 使用函数句柄实现添加噪声功能

clear; clc; close all;

% 创建时间向量
t_vec = 0:0.001:1;

% 定义符号变量和信号表达式
syms t A a1 a2 a3;
expr = A * sin(2*pi*(a1*t + a2*t^2 + a3*t^3));

% 创建基础Signal对象
s = Signal('QuadraticChirp', t_vec, expr, t, {'A', 'a1', 'a2', 'a3'}, [2, 10, 5, 1]);

% 定义添加噪声的函数句柄
add_noise = @(signal, snr) awgn(signal, snr, 'measured');

% SNR值列表
snr_values = [10, 12, 15];

% 创建图形
figure;
hold on;

% 绘制原始信号（无噪声）
plot(s.timeVec, s.SigVec, 'k-', 'LineWidth', 1.5);
legend_str{1} = 'Original Signal';

% 为每个SNR值添加噪声并绘制
for i = 1:length(snr_values)
    snr = snr_values(i);
    % 使用函数句柄添加噪声
    noisy_signal = add_noise(s.SigVec, snr);
    
    % 绘制添加噪声后的信号
    plot(s.timeVec, noisy_signal, '-', 'LineWidth', 1);
    legend_str{i+1} = sprintf('SNR = %d dB', snr);
end

% 图形设置
xlabel('时间 (秒)');
ylabel('幅度');
title('不同SNR值的信号时间序列对比');
legend(legend_str, 'Location', 'best');
grid on;

% 单独绘制子图版本
figure;

% 绘制原始信号
subplot(2,2,1);
plot(s.timeVec, s.SigVec, 'k-', 'LineWidth', 1.2);
title('原始信号');
xlabel('时间 (秒)');
ylabel('幅度');
grid on;

% 为每个SNR值绘制子图
for i = 1:length(snr_values)
    snr = snr_values(i);
    % 使用函数句柄添加噪声
    noisy_signal = add_noise(s.SigVec, snr);
    
    % 绘制子图
    subplot(2,2,i+1);
    plot(s.timeVec, noisy_signal, 'b-', 'LineWidth', 1.2);
    title(sprintf('SNR = %d dB', snr));
    xlabel('时间 (秒)');
    ylabel('幅度');
    grid on;
end

sgtitle('不同SNR值的信号时间序列图', 'FontSize', 14);