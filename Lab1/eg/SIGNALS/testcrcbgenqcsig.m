clc;clear;
% 此文中发现一个非常抽象的问题：
% 所谓的Nyqust frequency，似乎有两种定义方式
% 一，临界采样频率，即PPT中的The critical sampling frequency$f_s = 2f_B$ is called the Nyquist frequency (or Nyquist rate) （临界采样频率 fs = 2fB 被称为Nyqust frequency（或Nyqust采样率）），这个值就将其称为Nyqust frequency
% 二，采样率的一半，即f_s/2，我将其称为 Nyquist limit
%在代码中用到了两次Nyqust frequency 我认为是两种定义都用到了

%% Plot the quadratic chirp signal  % 绘制二次调频信号(Chirp是指频率随时间变化的信号，这里的二次是指瞬时频率是二次的)
% Signal parameters  % 信号参数
a1=10;
a2=3;
a3=3;%这是相位的三个参数,
A = 10;% SNR参数 即信噪比
% Instantaneous frequency after 1 sec is  % 1秒后的瞬时频率为（因为瞬时频率是相位对时间求导，phi(t)=a1*t+a2*t^2+a3*t^3,so f(t)=dphi/dt=a1+2a2*t+3a3*t^2，t取1即得下式）
% 因为采样时间只取0-1s，且瞬时频率单增，所以t=1就是最大频率时
maxFreq = a1+2*a2+3*a3;
% 这里的Nyqust频率应该是第一种定义，临界采样频率
%Nyqust frequency guess: 2 * max. instantaneous frequency  % Nyqust频率估计：2倍最大瞬时频率，称为估计是因为最大瞬时频率不一定等于最大傅立叶频率
%信号频率范围为(-f_b,+f_b),f_b是频率带宽,f_s=2*f_b才被称为Nyqust频率
nyqFreq = 2*maxFreq;
% Sampling frequency  % 采样频率，取Nyqust频率五倍
samplFreq = 5*nyqFreq; 
% Sampling Interval 采杨间隔
samplIntrvl = 1/samplFreq;

% Time samples  % 时间采样点(只取0-1s)
timeVec = 0:samplIntrvl:1.0;
% Number of samples  % 采样点数量   
nSamples = length(timeVec);

% Generate the signal   生成信号
sigVec = crcbgenqcsig(timeVec,A,[a1,a2,a3]);

%%Plot the signal   绘制信号，注意这里的图像是离散的，plot自动在数据点间连直线 
figure;
plot(timeVec,sigVec,'Marker','.','MarkerSize',24);
xlabel('Time (sec)');
title('Sampled signal');


%%Plot the periodogram  % 绘制周期图
%--------------
%Length of data  % 数据长度 
dataLen = timeVec(end)-timeVec(1);

% 所有的频率，包括正和负
allFreq = ((-samplFreq/2):(-samplFreq/2+(nSamples-1)*(1/dataLen)));
% FFT of signal  % 信号的FFT
fftSig = fft(sigVec);%其对应的频率排列是【0hz，正频率...，Nyqust频率，负频率..... 】，在后面画图时，负频率被截断了

fftSig_shifted = fftshift(fftSig);% 将零频分量移到频谱中心，【负频率.....0hz，正频率...，Nyqust频率， 】

%%Plot periodogram  % 绘制周期图（带负频率，其实这是没必要的）
figure;
plot(allFreq,abs(fftSig_shifted));
xlabel('Frequency (Hz)');
ylabel('|FFT|');
title('Complete Spectrum (with negative frequencies)');

% 这里的Nyqust频率应该是第二种定义，采样率的一半（Nyquist limit）
% 
%DFT sample corresponding to Nyquist frequency  % 对应Nyqust频率的DFT采样点
kNyq = floor(nSamples/2)+1;
% Positive Fourier frequencies  % 正傅里叶频率
posFreq = (0:(kNyq-1))*(1/dataLen);
% Discard negative frequencies  % 丢弃负频率
%这样做的理由是：
% 1. 对于实值信号，FFT结果具有共轭对称性。这意味着：
% 如果X(k)是第k个FFT点，那么X(N-k) = X*(k)的复共轭
% 因此，FFT结果后半部分（对应于负频率）与前半部分（对应于正频率）包含完全相同的信息
% 在N点FFT中：
% 索引1到floor(N/2)+1对应频率0到fs/2（正频率）
% 索引floor(N/2)+2到N对应频率-fs/2到接近0（负频率）
% 正负频率部分是对称的，所以保留一半即可
% 为什么后半部分对应于负频率？
% X[k] = ∑ x[n]·e^(-j2πnk/N), k=0,1,...,N-1

% x[n] = ∑ X[k]·e^(+j2πnk/N), k=0,1,...,N-1
% 我们给e^(+j2πnk/N)乘一个1得： e^(j2πnk/N)*1 = e^(j2πnk/N)·e^(-j2πn) = e^(j2πn*delta(k-N)/(N*delta))，频率f正比于这个index，具体来说是f=(k-N)/(N*delta)=(k-N)/T(总周期长度) <0
% 这是由傅立叶变换本身决定的
fftSig = fftSig(1:kNyq);%只保留fftSig 1到kNyq的元素，(1:kNyq)是索引数组
%Plot periodogram  % 绘制周期图
figure;
plot(posFreq,abs(fftSig));
xlabel('Frequency (Hz)');
ylabel('|FFT|');
title('Periodogram');

%%Plot a spectrogram  % 绘制频谱图
%----------------
winLen = 0.2;%sec %window length 窗口长度:每次分析的时间段长短
ovrlp = 0.1;%sec  %overlap 窗口重叠：相邻窗口之间共享的时间长短
%Convert to integer number of samples  % 转换为整数采样点数量 
winLenSmpls = floor(winLen*samplFreq); %~对应的采样点数
ovrlpSmpls = floor(ovrlp*samplFreq);   %~对应的采样点数
[S,F,T]=spectrogram(sigVec,winLenSmpls,ovrlpSmpls,[],samplFreq);
figure;
imagesc(T,F,abs(S)); axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');

% spectrogram - 使用短时傅里叶变换（STFT）计算频谱图
% 此 MATLAB 函数返回输入信号 x 的短时傅里叶变换（STFT）。

% 语法
% s = spectrogram(x)
% s = spectrogram(x,window)
% s = spectrogram(x,window,noverlap)
% s = spectrogram(x,window,noverlap,nfft)
% [s,w,t] = spectrogram(___)
% [s,f,t] = spectrogram(___,fs)
% [s,w,t] = spectrogram(x,window,noverlap,w)

% [s,f,t] = spectrogram(x,window,noverlap,f,fs)
% 我们使用的是这一条

% [___,ps] = spectrogram(___,spectrumtype)
% [___] = spectrogram(___,"reassigned")
% [___,ps,fc,tc] = spectrogram(___)
% [___] = spectrogram(___,freqrange)
% [___] = spectrogram(___,Name=Value)
% spectrogram(___)
% spectrogram(___,freqloc)
% 输入参数
% x - 输入信号 向量 % window - 窗口 正整数 | 向量 | []
% noverlap - 重叠采样点数 非负整数 | []
% nfft - DFT 点数 正整数 | []
% w - 归一化频率 向量
% f - 循环频率 向量
% fs - 采样率 1 Hz（默认值）| 正标量
% freqrange - PSD 估计的频率范围 "onesided" | "twosided" | "centered"
% spectrumtype - 功率谱缩放方式 "psd"（默认值）| "power"
% freqloc - 频率显示轴 "xaxis"（默认值）| "yaxis" 

% 名称-值参数
% MinThreshold - 阈值 -Inf（默认值）| 实数标量
% OutputTimeDimension - 输出时间维度 "acrosscolumns"（默认值）| "downrows"

% 输出参数
% s - 短时傅里叶变换 矩阵
% w - 归一化频率 向量
% t - 时间点 向量
% f - 循环频率 向量
% ps - 功率谱密度或功率谱 矩阵
% fc - 能量中心的频率和时间 矩阵
% tc - 能量中心的频率和时间 矩阵

%%# 频率相关概念

%  1. 奈奎斯特频率（Nyquist frequency）

% 根据提供的参考资料，奈奎斯特频率有两种常见含义：

% - 严格定义（PPT中）：临界采样频率 fs = 2fB，即对带宽为fB的信号进行无损采样所需的最低采样频率。这是奈奎斯特采样定理中的核心概念。
  
% - 工程常用含义：采样频率的一半（fs/2），也称为奈奎斯特限制（Nyquist limit）。这表示在给定采样率下可以无混叠重建的最高信号频率。

% 在代码中两种定义都有使用：
% 第一种定义（临界采样频率）
% nyqFreq = 2*maxFreq;  % 信号最大频率的两倍
% 第二种定义（在FFT处理部分）
% kNyq = floor(nSamples/2)+1;  % 对应采样率一半的FFT索引

%  2. 带宽（bandwidth）
% 带宽是指信号在频域中非零部分所占据的频率范围。
% - 对于带限信号：频谱在[-fB, fB]范围之外为0，其中fB被称为带宽
% - 在代码中，`maxFreq`（最大瞬时频率）相当于信号的带宽，因为它决定了信号频谱的范围

%  3. 采样频率（sampling frequency）
% 采样频率是指单位时间内对信号进行采样的次数，用fs表示，单位为Hz。
% - 奈奎斯特定理要求：fs ≥ 2fB（采样频率必须至少是带宽的两倍）
% - 在代码中：`samplFreq = 5*nyqFreq;`（实际采样频率设为临界采样频率的5倍，以确保充分采样）

%  4. 循环频率（Cyclical frequencies）
% 循环频率是指信号在单位时间内完成的周期数，单位为Hz。
% - 在spectrogram函数中，参数`f`表示循环频率
% - 在代码中，变量`posFreq`存储了正的循环频率值
% - 循环频率反映了信号的物理频率特性

%  5. 采样率（Sample rate）
% 采样率与采样频率是同一概念，表示每秒钟采集的信号样本数。
% - 在代码中用`samplFreq`表示
% - 在spectrogram函数中用`fs`参数表示