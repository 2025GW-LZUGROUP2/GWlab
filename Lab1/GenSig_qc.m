function SigVec = GenSig_qc(timeVec,SNR,qcCoefs)
% GenSig_qc - Generate a quadratic chirp signal
% GenSig_qc - 生成二次调频信号
%
% Syntax:
%   SigVec = GenSig_qc(timeVec, SNR, qcCoefs)
%
% Description:
%   This function generates a quadratic chirp signal based on the input
%   time vector, signal-to-noise ratio (SNR), and quadratic chirp
%   coefficients. The generated signal is normalized to ensure its norm
%   equals the specified SNR.
%   此函数根据输入的时间向量、信噪比 (SNR) 和二次调频系数生成二次调频信号。
%   生成的信号经过归一化处理，以确保其范数等于指定的 SNR。
%
% Inputs:
%   timeVec - Vector of time stamps at which the signal is computed
%             [double array]
%             计算信号的时间采样点向量 [double 数组]
%   SNR     - Matched filtering signal-to-noise ratio of the signal
%             [double scalar]
%             信号的匹配滤波信噪比 [double 数字]
%   qcCoefs - Vector of three coefficients [a1, a2, a3] that parametrize
%             the phase of the signal: a1*t + a2*t^2 + a3*t^3
%             [1x3 double array]
%             参数化信号相位的三个系数向量 [1x3 double 数组]
%
% Outputs:
%   SigVec  - Generated quadratic chirp signal
%             [double array]
%             生成的二次调频信号 [double 数组]
%
% Example:
%   timeVec = 0:0.01:1;
%   SNR = 10;
%   qcCoefs = [1, 0.5, 0.1];
%   SigVec = GenSig_qc(timeVec, SNR, qcCoefs);
%   plot(timeVec, SigVec);
%   xlabel('Time (s)');
%   ylabel('Amplitude');
%   title('Quadratic Chirp Signal');
%
% See also:
%   norm
%
% Author:
%   %   作者：2025GW-LZUGROUP2
    %   日期：2025-08-8




phaseVec = qcCoefs(1)*timeVec + qcCoefs(2)*timeVec.^2 + qcCoefs(3)*timeVec.^3;%相位
SigVec = sin(2*pi*phaseVec);%生成原始的正弦信号
SigVec = SNR*SigVec/norm(SigVec);%先用norm归一化，然后乘snr信噪比，这样的信号的范数一定是snr
%norm()计算范数

