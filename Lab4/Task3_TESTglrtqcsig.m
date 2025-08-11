%% Test function glrtqcsig.m (测试函数glrtqcsig.m)
clc; clear;
syms t;
% Note: To run this file, you need Lab1 folder, at least GWlab\Lab1\Lab1SigDef.m and GWlab\Lab1\Signal.m (注意：运行本文件需Lab1文件夹)
addpath ../Lab1
%% Parameters for data realization 数据实现的参数
% Number of samples and sampling frequency. 样本数和采样频率。
nSamples = 2048;
sampFreq = 1024;
timeVec = (0:(nSamples - 1)) / sampFreq;
%% Supply PSD values 提供PSD值
% This is the noise psd we will use. 这是我们将使用的噪声PSD。
noisePSD = @(f) (f >= 100 & f <= 300) .* (f - 100) .* (300 - f) / 10000 + 1;
dataLen = nSamples / sampFreq;
kNyq = floor(nSamples / 2) + 1;
posFreq = (0:(kNyq - 1)) * (1 / dataLen);
psdPosFreq = noisePSD(posFreq);

%% Generate data realization 生成数据实现
% Parameters of the signal to be injected. 要注入信号的参数。

run('Lab1SigDef.m');
coeffNames_qc = {'a_1', 'a_2', 'a_3', 'A'}; % 参数名称
syms(coeffNames_qc{:}); % 定义符号变量
SNR=2;%信噪比
coeffValues_qc = [9.5, 2.8, 3.2, SNR]; % 参数值
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

% The signal will be normalized, so generate with an arbitrary amplitude 信号将被归一化，因此以任意幅度生成。
sig4data = SigNow.SigVec;
% Signal normalized to SNR = A in noise with the specified PSD 信号在具有指定PSD的噪声中归一化到SNR = A。
[sig4data, ~] = normSig4PSD(sig4data, sampFreq, psdPosFreq, SNR);
sig4data=double(subs(sig4data,SigNow.coeffName,SigNow.coeffValue));
% Generate a noise realization from a stochastic process with the specified PSD 从具有指定PSD的随机过程生成噪声实现。
noiseVec = statGaussNoiseGen(nSamples, [posFreq(:), psdPosFreq(:)], 100, sampFreq);

% Data realization = noise realization + signal 数据实现 = 噪声实现 + 信号。
dataVec = noiseVec + sig4data;

%% Compute GLRT 计算GLRT
% Generate the unit norm signal (i.e., template). As before, the value used for 'A' does not matter because we are going to normalize the signal anyway. 生成单位范数信号（即模板）。与之前一样，使用的“A”值无关紧要，因为我们无论如何都会对信号进行归一化。
% Note: the GLRT here is for the unknown amplitude case, that is all other signal parameters are known 注意：此处的GLRT适用于未知幅度的情况，即所有其他信号参数已知。
sigVec = SigNow.SigVec;
% We do not need the normalization factor, just the template vector with unit norm. 我们不需要归一化因子，只需要具有单位范数的模板向量。
[templateVec, ~] = normSig4PSD(sigVec, sampFreq, psdPosFreq, 1);
% Calculate inner product of the data with the unit norm template 计算数据与单位范数模板的内积。
llr = innerProdPSD(dataVec, templateVec, sampFreq, psdPosFreq);
% GLRT is its square GLRT是其平方。
llr = llr ^ 2;
disp(llr);
myGLRT=glrtqcsig(dataVec,timeVec,psdPosFreq,sigVec);
fprintf('\nThe GLRT value calculated using glrtqcsig function is %.4f (借助glrtqcsig函数算出的GLRT值为%.4f) \n',myGLRT,myGLRT);