clc; clear;
%% Define symbolic variable t (用于表示时间的符号变量)
% 用于表示时间的符号变量
syms t;

%% Filtering demonstration (滤波演示)
% Define sampling parameters (采样参数)
% 采样参数
filtNsampl = 2048; % Number of samples (采样点数)
filtSamplFreq = 1024; % Sampling frequency (Hz) (采样频率)
filtTintv = 1 / filtSamplFreq; % Sampling interval (采样时间间隔)
filtTlen = (filtNsampl - 1) / filtSamplFreq; % Total signal duration (信号总时长)
filtTimeVec = 0:filtTintv:filtTlen; % Time vector (时间向量)

%% Signal parameters (信号参数)
% 定义信号的幅度、频率和相位参数
filtCoeffName = {"fA1", "fA2", "fA3", "fF1", "fF2", "fF3", "fphi1", "fphi2", "fphi3"};
syms(filtCoeffName{:});
filtCoeffValue = [10, 5, 2.5, 100, 200, 300, 0, pi / 6, pi / 4];

%% Generate signal expression (生成信号表达式)
% 生成三个正弦信号并将其叠加
filtSig1 = fA1 * sin(fF1 * t + fphi1); % First sinusoid (第一个正弦信号)
filtSig2 = fA1 * sin(fF2 * t + fphi2); % Second sinusoid (第二个正弦信号)
filtSig3 = fA1 * sin(fF3 * t + fphi3); % Third sinusoid (第三个正弦信号)
filtSigExpr = filtSig1 + filtSig2 + filtSig3; % Composite signal (合成信号)

%% Create signal object (创建信号对象)
% 使用 Signal 类创建信号对象
filtSig = Signal('sum of three sinusoids', filtTimeVec, filtSigExpr, t, filtCoeffName, filtCoeffValue);

%% Estimate max frequency (估计最大频率)
% 使用 ExactEstmFreqBW 函数估计信号的最大频率
flitMaxFreq = ExactEstmFreqBW(filtSig);
fprintf('The maximum frequency of the discrete time sinusoid you can generate with this sampling frequency is %.4f Hz (可生成的最大离散正弦频率)\n',flitMaxFreq);

%% Design low-pass filters (设计低通滤波器)
% 针对不同频率设计三个低通滤波器
filtOrder = 30; % Filter order (滤波器阶数)
[fF1, fF2, fF3] = deal(100, 200, 300); % Frequency parameters (频率参数)
Wn1 = (fF1 / 2) / (filtSamplFreq / 2); % Cutoff 1 (截止频率1)
Wn2 = (fF2 / 2) / (filtSamplFreq / 2); % Cutoff 2 (截止频率2)
Wn3 = (fF3 / 2) / (filtSamplFreq / 2); % Cutoff 3 (截止频率3)
b1 = fir1(filtOrder, Wn1, 'low'); % Filter 1 (滤波器1)
b2 = fir1(filtOrder, Wn2, 'low'); % Filter 2 (滤波器2)
b3 = fir1(filtOrder, Wn3, 'low'); % Filter 3 (滤波器3)

%% Apply filters (应用滤波器)
% 对信号应用低通滤波器
filtVec1 = fftfilt(b1, filtSig.SigVec); % Result 1 (滤波结果1)
filtVec2 = fftfilt(b2, filtSig.SigVec); % Result 2 (滤波结果2)
filtVec3 = fftfilt(b3, filtSig.SigVec); % Result 3 (滤波结果3)

%% Plot results (绘制结果)
% 绘制原始信号和滤波后的信号
figure('Name', 'Low-pass f1 (低通滤f1波)');
hold on;
filtL1 = plot(filtTimeVec, filtVec1); % Filtered signal 1 (滤波信号1)
oriL = plot(filtTimeVec, filtSig.SigVec); % Original signal (原始信号)
legend([filtL1, oriL], {'Low-pass f1', 'Original'}); % 图例
axis xy;
xlabel('Time (s) (时间)');

figure('Name', 'Low-pass f2 (低通滤f2波)');
hold on;
filtL2 = plot(filtTimeVec, filtVec2); % Filtered signal 2 (滤波信号2)
oriL = plot(filtTimeVec, filtSig.SigVec); % Original signal (原始信号)
legend([filtL2, oriL], {'Low-pass f2', 'Original'});
axis xy;
xlabel('Time (s) (时间)');

figure('Name', 'Low-pass f3 (低通滤f3波)');
hold on;
filtL3 = plot(filtTimeVec, filtVec3); % Filtered signal 3 (滤波信号3)
oriL = plot(filtTimeVec, filtSig.SigVec); % Original signal (原始信号)
legend([filtL3, oriL], {'Low-pass f3', 'Original'});
axis xy;
xlabel('Time (s) (时间)');