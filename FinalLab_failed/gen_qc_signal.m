function sigVec = gen_qc_signal(dataX, snr, qcCoefs)
%GEN_QC_SIGNAL 生成二次Chirp信号（基于Lab5的crcbgenqcsig）
%
%   输入参数：
%   dataX: 时间向量
%   snr: 信噪比
%   qcCoefs: 信号参数数组 [a1, a2, a3]
%
%   输出参数：
%   sigVec: 生成的信号向量

% 计算相位，注意这里使用2*pi因子
phaseVec = qcCoefs(1)*dataX + qcCoefs(2)*dataX.^2 + qcCoefs(3)*dataX.^3;
sigVec = sin(2*pi*phaseVec);

% 归一化并应用SNR
sigVec = snr*sigVec/norm(sigVec);

% 确保输出为列向量
sigVec = sigVec(:);

end
