function energy = getEnergy(mf, freqVec, ESD)
%getEnergy  计算频率区间[-mf, mf]内的信号能量
%
%   energy = getEnergy(mf, freqVec, ESD)
%
%   该函数用于计算能量谱密度ESD在频率区间[-mf, mf]内的积分值。
%
%   输入参数
%   ----------
%   mf : double
%       最大频率（Hz），积分区间为[-mf, mf]
%   freqVec : double array
%       频率轴向量（Hz）
%   ESD : double array
%       能量谱密度（与freqVec等长）
%
%   输出参数
%   ----------
%   energy : double
%       区间[-mf, mf]内的总能量
%
%   示例
%   ----------
%   e = getEnergy(50, freqVec, ESD);
%
%   作者：2025GW-LZUGROUP2
%   日期：2025-08-08

    % 选取频率区间[-mf, mf]内的索引
    idx = (freqVec >= -mf) & (freqVec <= mf);
    freqSub = freqVec(idx);
    esdSub = ESD(idx);

    % 若区间内点数过少，能量视为0，否则用梯形积分
    if length(freqSub) < 2
        energy = 0;
    else
        energy = trapz(freqSub, esdSub);
    end
end
