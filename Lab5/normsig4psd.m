function [normSig, normFac] = normsig4psd(sigVec, fs, psdVec, reqSNR)
% PSD加权归一化
% sigVec: 原始信号
% fs: 采样率
% psdVec: PSD向量（正频率）
% reqSNR: 归一化到的信噪比（幅度）

    nSamples = length(sigVec);
    sigFFT = fft(sigVec);
    kNyq = floor(nSamples/2)+1;
    sigFFTPos = sigFFT(1:kNyq);

    % 保证psdVec为列向量
    psdVec = psdVec(:);

    % 计算PSD加权能量
    sigNorm = sqrt(2*sum(abs(sigFFTPos).^2 ./ psdVec)/nSamples^2);

    % 归一化到单位能量
    normSig = sigVec / sigNorm;

    % 如果需要指定SNR，则乘以幅度
    if nargin >= 4 && ~isempty(reqSNR)
        normSig = normSig * reqSNR;
    end

    normFac = sigNorm;
end