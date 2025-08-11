clc; clear;
syms t;
%
%
% Note: To run this file, you need Lab1 folder, at least GWlab\Lab1\Lab1SigDef.m and GWlab\Lab1\Signal.m (注意：运行本文件需Lab1文件夹)
%
%% Calculate GLRT for Quadratic chirp signal 计算二次调频信号的GLRT
% Generalized Likelihood ratio test (GLRT) for a quadratic chirp when only the amplitude is unknown. 当仅幅度未知时，二次啁啾信号的广义似然比检验（GLRT）。

%%
% We will reuse codes that have already been written. 我们将重用已编写的代码。
% Path to folder containing signal and noise generation codes. 包含信号和噪声生成代码的文件夹路径。
% addpath ../SIGNALS
% addpath ../NOISE
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

figure;
LData=plot(timeVec, dataVec);%数据实现 = 噪声实现 + 信号
hold on;
LSig=plot(timeVec, sig4data);%信号
legend([LData,LSig],'Data (数据实现)','Signal (信号)')
xlabel('Time (sec) (时间(秒))')
ylabel('Data (数据)');
title('Data realization for calculation of LR (数据实现用于计算LR)');

figure("Name",'Periodogram (周期图)');
kNyq = floor(nSamples / 2) + 1;
dataLen = nSamples / sampFreq;
posFreq = (0:(kNyq - 1)) * (1 / dataLen);
datFFT = abs(fft(dataVec));
sigFFT = abs(fft(sig4data));
LfftData=plot(posFreq, datFFT(1:kNyq));%数据
hold on;
LfftSig=plot(posFreq, sigFFT(1:kNyq));%信号
legend([LfftData,LfftSig],'Data (数据)','Signal (信号)')
xlabel('Frequency (Hz) (频率(赫兹))');
ylabel('|FFT| (|傅里叶变换|)');

figure("Name",'Spectrogram (时频图)');
[S, F, T] = spectrogram(dataVec, 64, 60, [], sampFreq);
imagesc(T, F, abs(S)); axis xy;
xlabel('Time (sec) (时间(秒))')
ylabel('Frequency (Hz) (频率(赫兹))');

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
%% Estimate the distribution of GLRT under the null and alternative hypotheses 估计GLRT在原假设和备择假设下的分布
% Number of data realizations to generate under each hypothesis 在每个假设下生成的数据实现数量。
nRlz = 500;
% GLRT values stored for each realization 为每个实现存储的GLRT值。
glrtH0 = zeros(1, nRlz); % Null hypothesis 原假设。
glrtH1 = zeros(1, nRlz); % Alternative hypothesis 备择假设。

% Always a good idea to reset the random number generator when doing large simulations for later reproducibility 在进行大规模模拟以便以后重现时，重置随机数生成器总是一个好主意。
rng('default');

% Calculate GLRT under null hypothesis: data is pure noise 计算原假设下的GLRT：数据是纯噪声。
for lpr = 1:nRlz
    % Generate noise realization 生成噪声实现。
    noiseVec = statGaussNoiseGen(nSamples, [posFreq(:), psdPosFreq(:)], 100, sampFreq);
    % Compute GLRT 计算GLRT。
    llr = innerProdPSD(noiseVec, templateVec, sampFreq, psdPosFreq);
    glrtH0(lpr) = llr ^ 2;
end

% Calculate GLRT under alternative hypothesis: data contains the signal generated above. 计算备择假设下的GLRT：数据包含上述生成的信号。
for lpr = 1:nRlz
    % Generate noise realization 生成噪声实现。
    noiseVec = statGaussNoiseGen(nSamples, [posFreq(:), psdPosFreq(:)], 100, sampFreq);
    % Add signal 添加信号。
    dataVec = noiseVec + sig4data;
    % Compute GLRT 计算GLRT。
    llr = innerProdPSD(dataVec, templateVec, sampFreq, psdPosFreq);
    glrtH1(lpr) = llr ^ 2;
end

% Plot histograms 绘制直方图。
figure("Name",'Plot histograms (绘制直方图)');
hold on;
histogram(glrtH0, 'Normalization', "pdf");
histogram(glrtH1, 'Normalization', "pdf")
legend('H0 only Noise (H0仅噪声)', 'H1 Noise+Signal (H1噪声+信号)');
xlabel('GLRT (广义似然比检验)');
ylabel('PDF (概率密度)');
