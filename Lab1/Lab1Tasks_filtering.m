clc; clear;
%% 定义符号变量 t
% 用于表示时间的符号变量
syms t;

%% 滤波演示 % Filtering demonstration
% 定义采样参数
filtNsampl = 2048; % 采样点数
filtSamplFreq = 1024; % 采样频率 (Hz)
filtTintv = 1 / filtSamplFreq; % 采样时间间隔
filtTlen = (filtNsampl - 1) / filtSamplFreq; % 信号总时长
filtTimeVec = 0:filtTintv:filtTlen; % 时间向量

%% 定义信号参数
% 定义信号的幅度、频率和相位参数
filtCoeffName = {"fA1", "fA2", "fA3", "fF1", "fF2", "fF3", "fphi1", "fphi2", "fphi3"};
syms(filtCoeffName{:});
filtCoeffValue = [10, 5, 2.5, 100, 200, 300, 0, pi / 6, pi / 4];

%% 生成信号表达式
% 生成三个正弦信号并将其叠加
filtSig1 = fA1 * sin(fF1 * t + fphi1); % 第一个正弦信号
filtSig2 = fA1 * sin(fF2 * t + fphi2); % 第二个正弦信号
filtSig3 = fA1 * sin(fF3 * t + fphi3); % 第三个正弦信号
filtSigExpr = filtSig1 + filtSig2 + filtSig3; % 合成信号表达式

%% 创建信号对象
% 使用 Signal 类创建信号对象
filtSig = Signal('sum of three sinusoids', filtTimeVec, filtSigExpr, t, filtCoeffName, filtCoeffValue);

%% 估计信号的最大频率
% 使用 ExactEstmFreqBW 函数估计信号的最大频率
flitMaxFreq = ExactEstmFreqBW(filtSig);
fprintf(' the maximum frequency of the discrete time sinusoid you can generate with this sampling frequency is %.4f',flitMaxFreq);

%% 设计低通滤波器
% 针对不同频率设计三个低通滤波器
filtOrder = 30; % 滤波器阶数
[fF1, fF2, fF3] = deal(100, 200, 300); % 定义频率参数
Wn1 = (fF1 / 2) / (filtSamplFreq / 2); % 截止频率 1
Wn2 = (fF2 / 2) / (filtSamplFreq / 2); % 截止频率 2
Wn3 = (fF3 / 2) / (filtSamplFreq / 2); % 截止频率 3
b1 = fir1(filtOrder, Wn1, 'low'); % 滤波器 1
b2 = fir1(filtOrder, Wn2, 'low'); % 滤波器 2
b3 = fir1(filtOrder, Wn3, 'low'); % 滤波器 3

%% 应用滤波器
% 对信号应用低通滤波器
filtVec1 = fftfilt(b1, filtSig.SigVec); % 滤波结果 1
filtVec2 = fftfilt(b2, filtSig.SigVec); % 滤波结果 2
filtVec3 = fftfilt(b3, filtSig.SigVec); % 滤波结果 3

%% 绘制滤波结果
% 绘制原始信号和滤波后的信号
figure('Name', '低通滤f1波');
hold on;
filtL1 = plot(filtTimeVec, filtVec1); % 滤波信号 1
oriL = plot(filtTimeVec, filtSig.SigVec); % 原始信号
legend([filtL1, oriL], {'低通滤f1波', '原波'});
axis xy;
xlabel('Time /s');

figure('Name', '低通滤f2波');
hold on;
filtL2 = plot(filtTimeVec, filtVec2); % 滤波信号 2
oriL = plot(filtTimeVec, filtSig.SigVec); % 原始信号
legend([filtL2, oriL], {'低通滤f2波', '原波'});
axis xy;
xlabel('Time /s');

figure('Name', '低通滤f3波');
hold on;
filtL3 = plot(filtTimeVec, filtVec3); % 滤波信号 3
oriL = plot(filtTimeVec, filtSig.SigVec); % 原始信号
legend([filtL3, oriL], {'低通滤f3波', '原波'});
axis xy;
xlabel('Time /s');