function [funValueVec,FreqExpr] = gen_qcSig(timeVec,Coe_qcSig,SNR)
%Generate a quadratic chirp signal
% gen_qcSig=gen_qcSig(timeVec,Coe_qcSig,SNR)
% f(t)=sin(2*pi*phi(t)),phi(t)=a_1*t+a_2*t^2+a_3*t^3
% 输入
% timeVec 矢量，其分量是各个时间序列
% Coe_qcSig 矢量，分量为quadratic chirp signal的相位的三个系数
% SNR 浮点数，指信噪比
% 输出
% funValueVec 矢量，函数值矢量各个分量相当于信号的采样点
% FreqExpr 函数，相位表达式，自变量t，用来后续求瞬时频率最大值的位置

% 定义符号变量 t
syms t;

% 计算相位表达式
phiVec = timeVec*Coe_qcSig(1) + timeVec.^2*Coe_qcSig(2) + timeVec.^3*Coe_qcSig(3);
funValueVec = SNR * sin(2 * pi * phiVec) / norm(2 * pi * phiVec);

% 定义符号相位表达式
phiExpr = Coe_qcSig(1)*t + Coe_qcSig(2)*t^2 + Coe_qcSig(3)*t^3;
FreqExpr = diff(phiExpr, t); % 瞬时频率表达式
end