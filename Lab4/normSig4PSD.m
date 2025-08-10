function [NormSigVec, NormCoef] = normSig4PSD(SigVec, sampFreq, psdVec, SNR)
    %NORMSIG4PSD  归一化信号以获得指定SNR（带PSD加权）
    %   [NormSigVec, NormCoef] = NORMSIG4PSD(SigVec, sampFreq, psdVec, SNR)
    %   将输入信号SigVec归一化，使其在指定噪声PSD（psdVec）下具有目标信噪比SNR。
    %
    %   输入参数：
    %     SigVec   - 要归一化的信号向量
    %     sampFreq - 采样频率 (Hz)
    %     psdVec   - 正DFT频率对应的PSD向量，长度应为floor(N/2)+1
    %     SNR      - 目标信噪比（标量）
    %
    %   输出参数：
    %     NormSigVec - 归一化后的信号向量
    %     NormCoef   - 归一化因子
    %
    %   说明：
    %     该函数通过PSD加权内积计算信号范数，并据此缩放信号以达到指定SNR。
    %     常用于引力波等信号检测的归一化处理。
    %
    %   示例：
    %     [ns, coef] = normSig4PSD(sig, 1024, psd, 10);
    %
    %   作者：2025GW-LZUGROUP2
    %   日期：2025-08-10
    
    nSamp = length(SigVec);
    NyqIdx = floor(nSamp / 2) + 1; %Nyquist Limit Frequency所对应的序号

    if NyqIdx ~= length(psdVec)
        error('错误：输入的PSD并不对应正频率，长度有误')
    end

    SigSquar = innerProdPSD(SigVec, SigVec, sampFreq, psdVec);
    NormCoef = SNR/sqrt(SigSquar);
    NormSigVec = NormCoef*SigVec;
end
