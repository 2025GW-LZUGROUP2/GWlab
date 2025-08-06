function energy = getEnergy(mf, freqVec, ESD)
% 输入：maxFreq(mf)、频率轴(freqVec)、能量谱密度(ESD)
% 输出：[-mf, mf]内的能量
    
    idx = (freqVec >= -mf) & (freqVec <= mf); % 逻辑索引
    freqSub = freqVec(idx);
    esdSub = ESD(idx);
    
    if length(freqSub) < 2
        energy = 0; % 单元素/空向量的积分结果为0
    else
        energy = trapz(freqSub, esdSub); % 正常积分
    end
end
