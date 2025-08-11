function [dataVec,sigVec] = crcbgenqcdata(dataX,snr,qcCoefs)
% Generate data containing a quadratic chirp signal  % 生成包含二次啁啾信号的数据
% [Y,S] = CRCBGENQCDATA(X,SNR,C)  % [Y,S] = CRCBGENQCDATA(X,SNR,C)
% Generates a realization of data containing a quadratic chirp signal S  % 生成包含二次啁啾信号S的数据实例
% embedded in white Gaussian noise with unit variance. X is the vector of  % 嵌入单位方差的白高斯噪声中。X是数据Y中样本的时间戳向量
% time stamps at which the samples of data in Y are to be computed. SNR is  % Y中数据样本的时间戳。SNR是S的匹配滤波信噪比
% the matched filtering signal-to-noise ratio of S and C is the vector of  % S的匹配滤波信噪比，C是参数化信号相位的三个系数[a1, a2, a3]的向量
% three coefficients [a1, a2, a3] that parametrize the signal phase, given  % 信号相位由a1*t+a2*t^2+a3*t^3给出
% by a1*t+a2*t^2+a3*t^3.  % 由a1*t+a2*t^2+a3*t^3给出

%Soumya D. Mohanty, May 2018  % Soumya D. Mohanty, 2018年5月

nSamples = length(dataX);

sigVec = crcbgenqcsig(dataX,snr,qcCoefs);

dataVec = sigVec+randn(1,nSamples);

