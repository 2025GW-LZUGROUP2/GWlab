clc;clear;
syms t;
%% How to normalize a signal for a given SNR 如何对信号进行归一化以获得指定SNR
% We will normalize a signal such that the Likelihood ratio (LR) test for it has a given signal-to-noise ratio (SNR) in noise with a given Power Spectral Density (PSD). 我们将对信号进行归一化，使其在具有给定功率谱密度（PSD）的噪声中，似然比（LR）检验具有指定的信噪比（SNR）。
% [We often shorten this statement to say: "Normalize the signal to have a given SNR." ] [我们通常简化为："将信号归一化为具有指定SNR。"]

%%
% Path to folder containing signal and noise generation codes 包含信号和噪声生成代码的文件夹路径
addpath ../Lab1
% addpath ../NOISE

%%
% This is the target SNR for the LR 这是LR检验的目标信噪比
snr = 10;

%%
% Data generation parameters 数据生成参数
nSamples = 2048;
sampFreq = 1024;
timeVec = (0:(nSamples - 1)) / sampFreq;
timeLen=timeVec(end)-timeVec(1);
run('Lab1SigDef.m'); %引用Lab1SigDef.m文件(这个文件定义了各个信号)
%%
% Generate the signal that is to be normalized 生成待归一化的信号
% Amplitude value does not matter as it will be changed in the normalization 幅值无关紧要，归一化时会被改变

SigNow = Sig_qc; % 当前信号 %后缀可选：
% qc Quadratic Chirp 二次调频信号
% lc Linear Chirp 线性调频信号
% ss Sinusoidal Signal 正弦信号
% FM Frequency Modulated (FM) Sinusoid 频率调制正弦信号
% 以下是非标准正弦类
% Sg  Sine-Gaussian Signal 正弦-高斯信号
% AM  Amplitude Modulated (AM) Sinusoid 幅度调制正弦信号
% AMFM AM-FM Sinusoid 幅度-频率调制正弦信号
% SigVec = crcbgenqcsig(timeVec, 1, [a1, a2, a3]);
SigVec=SigNow.SigVec;

%%
% We will use the noise PSD used in colGaussNoiseDemo.m but add a constant to remove the parts that are zero. 我们将使用colGaussNoiseDemo.m中用到的噪声PSD，但加一个常数以去除为零的部分。
% (Exercise: Prove that if the noise PSD is zero at some frequencies but the signal added to the noise is not, then one can create a detection statistic with infinite SNR.) （思考题：证明如果噪声PSD在某些频率为零，而信号在这些频率不为零，则可以构造出具有无限SNR的检测统计量。）
noisePSD = @(f) (f >= 100 & f <= 300) .* (f - 100) .* (300 - f) / 10000 + 1;

%%
% Generate the PSD vector to be used in the normalization. Should be generated for all positive DFT frequencies. 生成用于归一化的PSD向量，应覆盖所有正DFT频率。
dataLen = nSamples / sampFreq;
kNyq = floor(nSamples / 2) + 1;
posFreq = (0:(kNyq - 1)) * (1 / dataLen);
psdPosFreq = noisePSD(posFreq);
figure("Name", '生成用于归一化的PSD向量，应覆盖所有正DFT频率。');
plot(posFreq, psdPosFreq);
axis([0, posFreq(end), 0, max(psdPosFreq)]);
xlabel('Frequency (Hz)');
ylabel('PSD ((data unit)^2/Hz)');

%% Calculation of the norm 范数计算
% Norm of signal squared is inner product of signal with itself 信号范数的平方是信号自身的内积
normSigSqrd = innerProdPSD(SigVec, SigVec, sampFreq, psdPosFreq);
% Normalize signal to specified SNR 将信号归一化到指定SNR
SigVec = snr * SigVec / sqrt(normSigSqrd);

%% Test 测试
% Obtain LLR values for multiple noise realizations 获取多次噪声实现的LLR值
nH0Data = 1000;
llrH0 = zeros(1, nH0Data);

for lp = 1:nH0Data
    noiseVec = statGaussNoiseGen(nSamples, [posFreq(:), psdPosFreq(:)], 100, sampFreq);
    llrH0(lp) = innerProdPSD(noiseVec, SigVec, sampFreq, psdPosFreq);
end

% Obtain LLR for multiple data (=signal+noise) realizations 获取多次数据（=信号+噪声）实现的LLR值
nH1Data = 1000;
llrH1 = zeros(1, nH1Data);

for lp = 1:nH0Data
    noiseVec = statGaussNoiseGen(nSamples, [posFreq(:), psdPosFreq(:)], 100, sampFreq);
    % Add normalized signal 添加归一化信号
    dataVec = noiseVec + SigVec;
    llrH1(lp) = innerProdPSD(dataVec, SigVec, sampFreq, psdPosFreq);
end

%%
% Signal to noise ratio estimate 信噪比估计
estSNR = (mean(llrH1) - mean(llrH0)) / std(llrH0);

figure("Name", 'Signal to noise ratio estimate 信噪比估计');
histogram(llrH0);
hold on;
histogram(llrH1);
xlabel('LLR');
ylabel('Counts');
legend('H_0', 'H_1');
title(['Estimated SNR = ', num2str(estSNR)]);

%%
% A noise realization 一次噪声实现
figure('Name', 'A noise realization 一次噪声实现');
plot(timeVec, noiseVec);
xlabel('Time (sec)');
ylabel('Noise');

%%
% A data realization 一次数据实现
figure("Name", 'A data realization 一次数据实现');
plot(timeVec, dataVec);
hold on;
plot(timeVec, SigVec);
xlabel('Time (sec)');
ylabel('Data');
%%Plot the periodogram of the signal and data画信号和数据的周期图（数据=信号+噪声）
%data的periodogram图(signal+noise)
N = length(timeVec); %时间向量的分量数
timeLength=timeVec(end)-timeVec(1);
fftVec = fft(SigVec);
NyqLimIdx = floor(N / 2) + 1; %Nyquist Limit频率所对应的指数 Nyquist Limit Index(the the index when f=fs/2)
posFreq = (0:(NyqLimIdx - 1) );
fftVec_posFreq = fftVec(1:NyqLimIdx);
figure('Name', 'Periodogram(|fft|-f)', 'Position', [100 100 800 600]);
fftline = plot(posFreq, abs(fftVec_posFreq));
hold on;
xlabel("频率Frequency(Hz)");
ylabel("|fft|");

%%Plot the spectrogram of the data画数据的时频图
%% 画出时频图spectrogram
figure("Name",'时频图spectrogram');
winTlen = 0.2/20; % second
ovlTlen = 0.1/20; % second
winSamplN = floor(winTlen * sampFreq * 10);
ovlSamplN = floor(ovlTlen * sampFreq * 10);
[S, F, T] = spectrogram(SigVec, winSamplN, ovlSamplN, [], sampFreq * 10);
imagesc(T, F, abs(S));
axis xy;
xlabel('Time /s'); ylabel('Frequency /Hz')