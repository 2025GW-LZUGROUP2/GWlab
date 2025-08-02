function sigVec = crcbgenqcsig(dataX,snr,qcCoefs)
% Generate a quadratic chirp signal
% 生成二次调频信号
% S = CRCBGENQSIG(X,SNR,C)
% Generates a quadratic chirp signal S.
% 生成二次调频信号S。
% X is the vector of time stamps at which the samples of the signal are to be computed.
% [double数组]X是计算信号采样值的时间采样点向量。
% SNR is the matched filtering signal-to-noise ratio of S
% [double数字]SNR是信号S的匹配滤波信噪比，
% and C is the vector of three coefficients [a1, a2, a3] that parametrize the phase of the signal: a1*t+a2*t^2+a3*t^3.
% [1x3 double 数组]C是由三个系数[a1, a2, a3]组成的向量，用于参数化信号的相位函数：a1*t+a2*t^2+a3*t^3。

%Soumya D. Mohanty, May 2018

phaseVec = qcCoefs(1)*dataX + qcCoefs(2)*dataX.^2 + qcCoefs(3)*dataX.^3;%相位
sigVec = sin(2*pi*phaseVec);%生成原始的正弦信号
sigVec = snr*sigVec/norm(sigVec);%先用norm归一化，然后乘snr信噪比，这样的信号的范数一定是snr
%norm()计算范数

