function sigVec = crcbgenqcsig(dataX,snr,qcCoefs)
% Generate a quadratic chirp signal
% 生成一个二次啁啾信号
% S = CRCBGENQSIG(X,SNR,C)
% Generates a quadratic chirp signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S and C is the vector of
% three coefficients [a1, a2, a3] that parametrize the phase of the signal:
% a1*t+a2*t^2+a3*t^3. 
% 生成一个二次啁啾信号S。X是时间戳的向量，用于计算信号的采样值。SNR是S的匹配滤波信噪比，C是一个包含三个系数[a1, a2, a3]的向量，用于参数化信号的相位：a1*t+a2*t^2+a3*t^3。

%Soumya D. Mohanty, May 2018

phaseVec = qcCoefs(1)*dataX + qcCoefs(2)*dataX.^2 + qcCoefs(3)*dataX.^3;
sigVec = sin(2*pi*phaseVec);
sigVec = snr*sigVec/norm(sigVec);


