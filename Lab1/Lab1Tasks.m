%本文件将一次性完成Lab1的所有任务
%我们定义了一个类Signal 用于描述和生成参数化数学信号，支持符号表达式、参数替换和信号向量生成。
%请使用命令help Signal;help ExactEstmFreqBW;以帮助你理解此文件

clc;clear;
% 定义符号变量
syms t;
tIntvl = [0, 1]; % timeInterval 时间区间[0,1]
fsInit = 300; % 先给一个较高的采样率，保证后续分析准确
timeLength = tIntvl(2) - tIntvl(1);
timeVec = (tIntvl(1):1 / fsInit:tIntvl(2));
run(fullfile(fileparts(mfilename('fullpath')), 'Lab1SigDef.m'))%引用Lab1SigDef.m文件(这个文件定义了各个信号)

%%
SigNow = Sig_qc; % 当前信号
phiNow = phi_qc; %是正弦类信号就保留（即能否通过表达式直接算出瞬时最大频率），如果不是请注释掉这行
% phiNow = [];%如果不是正弦类信号就保留本行，取消本行的注释
%后缀可选：
% 后缀      英文含义                               中文含义
% ----------------------------------------------------------
% qc        Quadratic Chirp                        二次调频信号
% lc        Linear Chirp                           线性调频信号
% ss        Sinusoidal Signal                      正弦信号
% FM        Frequency Modulated (FM) Sinusoid      频率调制正弦信号
% 以下是非标准正弦类，phiNow =?；一行需要注释掉
% Sg        Sine-Gaussian Signal                   正弦-高斯信号
% AM        Amplitude Modulated (AM) Sinusoid      幅度调制正弦信号
% AMFM      AM-FM Sinusoid                         幅度-频率调制正弦信号
% ----------------------------------------------------------
maxFreq = ExactEstmFreqBW(SigNow);
NyqFreq = 2 * maxFreq;
sampFreq=5*NyqFreq;%采样频率 5倍安全系数
sampIntvl=1/sampFreq;
timeVec=tIntvl(1):sampIntvl:tIntvl(2);
SigNow.timeVec = timeVec;%更新SigNow，使其生成正确的SigVec
SigVec = SigNow.SigVec;%取出生成的SigVec
SigVec = SigVec / norm(SigVec);%归一化
N = length(timeVec);%时间向量的分量数
fftVec = fft(SigVec);
%% 画信号图，信号的Signal-Time图
figure;
plot(timeVec, SigVec, 'Marker', '.', 'MarkerSize', 20);
xlabel('Time/s');
ylabel('Signal');


%% 画Periodogram图，信号的|fft|-f图
fprintf('判断标准：如果0-NyqFreq区间内，覆盖了|fft|的绝大部分面积，即可认为maxFreq估计正确');
NyqLimIdx = floor(N / 2) + 1; %Nyquist Limit频率所对应的指数 Nyquist Limit Index(the the index when f=fs/2)
posFreq = (0:(NyqLimIdx - 1) / timeLength);
fftVec_posFreq = fftVec(1:NyqLimIdx);
figure('Name', '判断maxFreq是否估计正确', 'Position', [100 100 800 600]);
fftline = plot(posFreq, abs(fftVec_posFreq));
hold on;
xlabel("频率Frequency(Hz)");
ylabel("|fft|");
% 填充曲线下方的颜色
fillX = [posFreq(posFreq <= NyqFreq), NyqFreq]; % 添加 NyqFreq 作为最后一个点
fillY = [abs(fftVec_posFreq(1:sum(posFreq <= NyqFreq))), 0]; % 对应 NyqFreq 的 y 值为 0
fill([fillX, flip(fillX)], [fillY, zeros(size(fillY))], 'cyan', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
h1 = xline(maxFreq, 'r--', 'LineWidth', 1);
h2 = xline(NyqFreq, 'b--', 'LineWidth', 1);
grid on;
legend([fftline, h1, h2], {'|fft|', 'max Frequency(band width)', 'Nyquist Frequency'});

%% Play the signal!
% sound(SigNow.SigVec);
%>> help sound
%  sound - 将信号数据矩阵转换为声音
%     此 MATLAB 函数 以默认采样率 8192 Hz 向扬声器发送音频信号 y。

%     语法
%       sound(y)
%       sound(y,Fs)
%       sound(y,Fs,nBits)

%     输入参数
%       y - 音频数据
%         数值向量 | 数值矩阵
%       Fs - 采样率
%         8192 (默认值) | 正标量
%       nBits - 采样位数。
%         16 (默认值) | 8 | 24
%% 