clc; clear;
syms t;
addpath ../Lab1
% 任务：第4组
%  已提供3个数据实例，名为DETEST/data<n>.txt，其中𝑛=1,2,3
%  每个实例是采样频率为1024Hz的时间序列
%  每个数据实例中的信号是二次调频率，但振幅未知（也可能为零！）
%        信号参数为：a1=10；a2=3；a3=3；
%  使用的噪声功率谱密度在DETEST/SNRCalc.m中
%       noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;
%  使用glrtqcsig.m为3个数据实例中的每个计算广义似然比检验统计量（GLRT）
%  在𝐻₀（无信号）下生成M个数据实例，并使用相关的GLRT值来估计3个给定数据实例中每个GLRT值的显著性
%    不断增加M，直到获得的显著性稳定
%    如果你的代码运行缓慢，考虑如何加快它
%    学习在Matlab中使用‘profile’命令检查代码中消耗时间最多的部分以及可以采取哪些措施来加快它
dataVec1 = load('data1.txt'); dataVec1 = dataVec1';
dataVec2 = load('data2.txt'); dataVec2 = dataVec2';
dataVec3 = load('data3.txt'); dataVec3 = dataVec3';
nSamples = length(dataVec1);
sampFreq = 1024;
timeVec = (0:(nSamples - 1)) / sampFreq;
timeLen = timeVec(end) - timeVec(1);

%% 生成噪声PSD向量，应覆盖所有正DFT频率。
noisePSD = @(f) (f >= 100 & f <= 300) .* (f - 100) .* (300 - f) / 10000 + 1;
dataLen = nSamples / sampFreq;
kNyq = floor(nSamples / 2) + 1;
posFreq = (0:(kNyq - 1)) * (1 / dataLen);
psdPosFreq = noisePSD(posFreq);
figure("Name", '噪声PSD');
plot(posFreq, psdPosFreq);
axis([0, posFreq(end), 0, max(psdPosFreq)]);
xlabel('Frequency (Hz)');
ylabel('PSD ((data unit)^2/Hz)');

%% 定义二次调频信号的参数和表达式
% Define parameters and expression for the quadratic chirp signal
coeffNames_qc = {'a_1', 'a_2', 'a_3', 'A'}; % 参数名称
syms(coeffNames_qc{:}); % 定义符号变量
phi_qc = 2 * pi * (a_1 * t + a_2 * t ^ 2 + a_3 * t ^ 3); % 相位表达式
sigExpr_qc = A * sin(phi_qc); % 信号表达式
coeffValues_qc = [10, 3, 3, 1]; % 参数值 %因为振幅未知且会归一化，设振幅为1
Sig_qc = Signal('Quadratic Chirp', timeVec, sigExpr_qc, ...
    t, coeffNames_qc, coeffValues_qc); % 创建信号对象

SigNow = Sig_qc; % 当前信号
SigVec = SigNow.SigVec;
%%使用glrtqcsig.m为3个数据实例（data）中的每个计算广义似然比检验统计量（GLRT）
GLRT_data1 = glrtqcsig(dataVec1, timeVec, psdPosFreq, SigVec);
GLRT_data2 = glrtqcsig(dataVec2, timeVec, psdPosFreq, SigVec);
GLRT_data3 = glrtqcsig(dataVec3, timeVec, psdPosFreq, SigVec);
fprintf('data 1:借助glrtqcsig函数算出的GLRT值为%.4f \n', GLRT_data1);
fprintf('data 2:借助glrtqcsig函数算出的GLRT值为%.4f \n', GLRT_data2);
fprintf('data 3:借助glrtqcsig函数算出的GLRT值为%.4f \n', GLRT_data3);


%%在𝐻₀（无信号）下(y=n, <y.s>=<n.s>)生成M个数据实例，并使用相关的GLRT值来估计3个给定数据实例中每个GLRT值的显著性
%不断增加M，直到获得的显著性稳定

% Generate a noise realization from a stochastic process with the specified PSD 从具有指定PSD的随机过程生成噪声实现。

Rlz=5*nSamples;%模拟realization的次数

% DSVec=zeros(1,Rlz);%detection statistic Vector 统计检测量向量
% for i = 1:Rlz
%    noiseVec = statGaussNoiseGen(nSamples, [posFreq(:), psdPosFreq(:)], 100, sampFreq);
%     DSVec(i) = glrtqcsig(noiseVec, timeVec,  psdPosFreq,SigVec); %detection statistic统计检测量-广义似然比
    
%     % fprintf('when M=%.d,detection statistic=%.4f \n', M, DetctStats);
% end
% 预计算归一化模板信号
[templateVec, ~] = normSig4PSD(SigVec, sampFreq, psdPosFreq, 1);
% 预计算模板信号的FFT
templateVec_fft = fft(templateVec);
% 预计算用于内积的PSD范数
NyqIdx = floor(nSamples / 2) + 1;
if mod(nSamples, 2) == 0
    PSDnorm = [psdPosFreq(NyqIdx - 1:-1:2), psdPosFreq];
else
    PSDnorm = [psdPosFreq(NyqIdx:-1:2), psdPosFreq];
end
% 预计算滤波器系数
filt_b = fir2(100, posFreq / (sampFreq / 2), sqrt(psdPosFreq));
% 一次性生成所有需要的白噪声
whiteNoise_matrix = randn(Rlz, nSamples);
% 使用fftfilt进行批处理滤波 (注意：fftfilt处理列向量)
noise_matrix = sqrt(sampFreq) * fftfilt(filt_b, whiteNoise_matrix')';

% 向量化计算所有噪声实现的GLRT值
noise_fft_matrix = fft(noise_matrix, [], 2); % 对每一行进行FFT
% 计算内积 (llr)
llr_vec = (1 / (nSamples * sampFreq)) * sum((noise_fft_matrix ./ PSDnorm) .* conj(templateVec_fft), 2);
DSVec = abs(llr_vec).^2; % GLRT是llr的模平方


meanNglrt=mean(DSVec);%mean noise GLRT
varNglrt=var(DSVec,1);%variant of noise GLRT
signfc1=sum(DSVec>GLRT_data1)/Rlz;
signfc2=sum(DSVec>GLRT_data2)/Rlz;
signfc3=sum(DSVec>GLRT_data3)/Rlz;
fprintf('significance of data1: %.5f \nsignificance of data2: %.5f \nsignificance of data3: %.5f \n',signfc1,signfc2,signfc3);
alpha1=(GLRT_data1-meanNglrt)/varNglrt;
alpha2=(GLRT_data2-meanNglrt)/varNglrt;
alpha3=(GLRT_data3-meanNglrt)/varNglrt;
fprintf('alpha of data1: %.5f \nalpha of data2: %.5f \nalpha of data3: %.5f \n',alpha1,alpha2,alpha3);
% 绘制GLRT噪声分布直方图及观测值
figure('Name','GLRT值与噪声分布');
histogram(DSVec, 50, 'FaceAlpha', 0.5, 'FaceColor', [0 0.447 0.741]);
hold on;
xline(GLRT_data1, 'r--', 'LineWidth', 1.5, 'Label', sprintf('GLRT1: %.2f', GLRT_data1), 'LabelOrientation','horizontal');
xline(GLRT_data2, 'g--', 'LineWidth', 1.5, 'Label', sprintf('GLRT2: %.2f', GLRT_data2), 'LabelOrientation','horizontal');
xline(GLRT_data3, 'm--', 'LineWidth', 1.5, 'Label', sprintf('GLRT3: %.2f', GLRT_data3), 'LabelOrientation','horizontal');
title('GLRT值与噪声分布');
xlabel('GLRT Value');
ylabel('Frequency');
legend('Noise GLRT Distribution', 'GLRT1', 'GLRT2', 'GLRT3');
grid on;
hold off;
% %
% data 1:借助glrtqcsig函数算出的GLRT值为10.6069 
% data 2:借助glrtqcsig函数算出的GLRT值为71.4193 
% data 3:借助glrtqcsig函数算出的GLRT值为2.7811 
% significance of data1: 0.00093 
% significance of data2: 0.00000 
% significance of data3: 0.09409 
% alpha of data1: 5.01058 
% alpha of data2: 36.67218 
% alpha of data3: 0.93612 

% significance of data2: 0.00000 
% significance of data3: 0.09639 
% alpha of data1: 5.06264 
% alpha of data2: 37.10399 
% alpha of data3: 0.93932 

% significance of data1: 0.00029 
% significance of data2: 0.00000 
% significance of data3: 0.09258 
% alpha of data1: 5.07463 
% alpha of data2: 37.11610 
% alpha of data3: 0.95129 

% significance of data1: 0.00029 
% significance of data2: 0.00000 
% significance of data3: 0.09258 
% alpha of data1: 5.07463 
% alpha of data2: 37.11610 
% alpha of data3: 0.95129