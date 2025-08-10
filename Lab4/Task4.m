clc;clear;
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
dataVec1=load('data1.txt');dataVec1=dataVec1';
dataVec2=load('data2.txt');dataVec2=dataVec2';
dataVec3=load('data3.txt');dataVec3=dataVec3';
nSamples=length(dataVec1);
sampFreq=1024;
timeVec = (0:(nSamples - 1)) / sampFreq;
timeLen=timeVec(end)-timeVec(1);


%% 生成噪声PSD向量，应覆盖所有正DFT频率。
noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;
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
coeffValues_qc = [10, 3, 3, 1]; % 参数值%因为振幅未知且会归一化，设振幅为1
Sig_qc = Signal('Quadratic Chirp', timeVec, sigExpr_qc, ...
    t, coeffNames_qc, coeffValues_qc); % 创建信号对象
    
SigNow = Sig_qc; % 当前信号
SigVec=SigNow.SigVec;
%%使用glrtqcsig.m为3个数据实例（data）中的每个计算广义似然比检验统计量（GLRT）
GLRT_Sig1=glrtqcsig(dataVec1,timeVec,psdPosFreq,SigVec);
GLRT_Sig2=glrtqcsig(dataVec2,timeVec,psdPosFreq,SigVec);
GLRT_Sig3=glrtqcsig(dataVec3,timeVec,psdPosFreq,SigVec);
fprintf('data 1:借助glrtqcsig函数算出的GLRT值为%.4f \n',GLRT_Sig1);
fprintf('data 2:借助glrtqcsig函数算出的GLRT值为%.4f \n',GLRT_Sig2);
fprintf('data 3:借助glrtqcsig函数算出的GLRT值为%.4f \n',GLRT_Sig3);

%%在𝐻₀（无信号）下(y=n, y.s=n.s)生成M个数据实例，并使用相关的GLRT值来估计3个给定数据实例中每个GLRT值的显著性
%不断增加M，直到获得的显著性稳定

% Generate a noise realization from a stochastic process with the specified PSD 从具有指定PSD的随机过程生成噪声实现。
M=10;
MnoiseVec = statGaussNoiseGen(M, [posFreq(:), psdPosFreq(:)], 100, sampFreq);
% MsigVec=
DetctStats=innerProdPSD();%detection statistic统计检测量
