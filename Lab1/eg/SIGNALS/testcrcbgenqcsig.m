%% Plot the quadratic chirp signal  % 绘制二次调频信号(Chirp是指频率随时间变化的信号，这里的二次是指瞬时频率是二次的)
% Signal parameters  % 信号参数
a1=10;
a2=3;
a3=3;%这是相位的三个参数
A = 10;% SNR参数 即信噪比
% Instantaneous frequency after 1 sec is  % 1秒后的瞬时频率为（因为瞬时频率是相位对时间求导，phi(t)=a1*t+a2*t^2+a3*t^3,so f(t)=dphi/dt=a1+2a2*t+3a3*t^2，t取1即得下式）
% 因为采样时间只取0-1s，且瞬时频率单增，所以t=1就是最大频率时
maxFreq = a1+2*a2+3*a3;
%Nyqust frequency guess: 2 * max. instantaneous frequency  % Nyqust频率估计：2倍最大瞬时频率，这是能无误差采样的最小采杨频率，
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

%Plot the signal   绘制信号，注意这里的图像是离散的，plot自动在数据点间连直线 
figure;
plot(timeVec,sigVec,'Marker','.','MarkerSize',24);
xlabel('Time (sec)');
title('Sampled signal');


%Plot the periodogram  % 绘制周期图
%--------------
%Length of data  % 数据长度 
dataLen = timeVec(end)-timeVec(1);
%DFT sample corresponding to Nyquist frequency  % 对应奈奎斯特频率的DFT采样点
kNyq = floor(nSamples/2)+1;
% Positive Fourier frequencies  % 正傅里叶频率
posFreq = (0:(kNyq-1))*(1/dataLen);
% FFT of signal  % 信号的FFT
fftSig = fft(sigVec);
% Discard negative frequencies  % 丢弃负频率
fftSig = fftSig(1:kNyq);

%Plot periodogram  % 绘制周期图
figure;
plot(posFreq,abs(fftSig));
xlabel('Frequency (Hz)');
ylabel('|FFT|');
title('Periodogram');

%Plot a spectrogram  % 绘制频谱图
%----------------
winLen = 0.2;%sec
ovrlp = 0.1;%sec
%Convert to integer number of samples  % 转换为整数采样点数量 
winLenSmpls = floor(winLen*samplFreq);
ovrlpSmpls = floor(ovrlp*samplFreq);
[S,F,T]=spectrogram(sigVec,winLenSmpls,ovrlpSmpls,[],samplFreq);
figure;
imagesc(T,F,abs(S)); axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
