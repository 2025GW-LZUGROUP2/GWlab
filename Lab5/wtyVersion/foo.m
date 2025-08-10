function SigVec=foo(dataX,SNR,P)
%FOO 生成具有二次相位调制的正弦信号
%   S = FOO(X, SNR, P) 生成一个具有二次相位调制的正弦信号 S。
%   X 是时间戳的向量，用于计算信号的采样值。SNR 是生成信号的信噪比。
%   P 是一个包含参数 a1, a2 和 a3 的结构体，这些参数定义了二次相位：
%   a1*t + a2*t^2 + a3*t^3。
%   
%   输入:
%       dataX - 时间戳向量 (1 x N)
%       SNR   - 信噪比 (标量)
%       P     - 结构体，包含以下字段:
%               a1 - 线性项系数 (标量)
%               a2 - 二次项系数 (标量)
%               a3 - 三次项系数 (标量)
%   
%   输出:
%       SigVec - 生成的正弦信号 (1 x N)

% 计算相位向量
phiVec = 2 * pi * (P.a1 * dataX + P.a2 * dataX.^2 + P.a3 * dataX.^3);

% 生成正弦信号
SigVec = sin(phiVec);

% 将信号归一化到指定的 SNR
SigVec = SNR * SigVec / norm(SigVec);

end