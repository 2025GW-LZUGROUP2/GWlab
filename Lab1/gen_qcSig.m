function output = gen_qcSig(timeVec,Coe_qcSig,SNR)
%Generate a quadratic chirp signal
% gen_qcSig=gen_qcSig(timeVec,Coe_qcSig,SNR)
% f(t)=sin(2*pi*phi(t)),phi(t)=a_1*t+a_2*t^2+a_3*t^3
% f(t)的输出会被归一化然后乘SNR,最终其范数为SNR
% timeVec 矢量，其分量是各个时间序列
% Coe_qcSig 矢量，分量为quadratic chirp signal的相位的三个系数
% SNR 浮点数，指信噪比
phiVec=timeVec*Coe_qcSig(1)+timeVec.^2*Coe_qcSig(2)+timeVec.^3*Coe_qcSig(3);
output= SNR*sin(2*pi*phiVec)/norm(2*pi*phiVec) ;
end