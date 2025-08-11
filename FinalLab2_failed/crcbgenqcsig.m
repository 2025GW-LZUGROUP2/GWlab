function sig = crcbgenqcsig(timeVec, snr, qcCoefs)
% 生成二次 chirp: sin(2*pi*(a1*t + a2*t^2 + a3*t^3))，再按欧氏范数归一到 snr
timeVec = timeVec(:).';
a1 = qcCoefs(1); a2 = qcCoefs(2); a3 = qcCoefs(3);
phi = a1*timeVec + a2*(timeVec.^2) + a3*(timeVec.^3);
sig = sin(2*pi*phi);
sig = snr*sig/norm(sig);
end
