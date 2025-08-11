function sigVec = crcbgenqcsig(dataX, snr, qcCoefs)
% 生成二次chirp信号（与Python完全对应）
% sig(t) = sin(2*pi*(a1*t + a2*t^2 + a3*t^3))，再按欧氏范数归一后乘以snr
dataX   = dataX(:).';
qcCoefs = qcCoefs(:).';
phaseVec = qcCoefs(1)*dataX + qcCoefs(2)*dataX.^2 + qcCoefs(3)*dataX.^3;
sigVec = sin(2*pi*phaseVec);
sigVec = snr * sigVec / norm(sigVec);
end
