function finalProd = innerProdPSD(xVal, yVal, sampFreq, PSD4posFreq)
%innerProdPSD 计算带PSD加权的信号内积（频域）
%   finalProd = INNERPRODPSD(xVal, yVal, sampFreq, PSD4posFreq)
%   计算两个实信号xVal和yVal在给定功率谱密度(PSD)下的加权内积，常用于引力波等信号检测中的似然比检验。
%
%   输入参数：
%     xVal         - 信号1的时域采样向量
%     yVal         - 信号2的时域采样向量
%     sampFreq     - 采样频率 (Hz)
%     PSD4posFreq  - 正频率对应的PSD向量（长度应为floor(N/2)+1）
%
%   输出参数：
%     finalProd    - 归一化后的内积（实数）
%
%   说明：
%     该函数将输入信号变换到频域后，按PSD加权计算内积，常用于噪声加权的信号检测。
%     PSD4posFreq应与正频率分量一一对应。
%
%   参考：
%     见引力波数据分析教材、Matched Filtering等相关资料。
%
%   示例：
%     prod = innerProdPSD(x, y, 1024, psdVec);
%
%   作者：2025GW-LZUGROUP2
%   日期：2025-08-10
    nSamp = length(xVal);

    if nSamp ~= length(yVal)
        error('错误：内积的两向量长度不相同')
    end

    NyqIdx = floor(nSamp / 2) + 1; %Nyquist Limit Frequency所对应的序号

    if NyqIdx ~= length(PSD4posFreq)
        error('错误：输入的PSD并不对应正频率，长度有误')
    end

    xfft = fft(xVal); yfft = fft(yVal);
    xfftSft = fftshift(xfft); yfftSft = fftshift(yfft);
    %fft所对应的频率是
    %0 1 2 3 4 %5% -4 -3 -2 -1(nSamp=even，5为Nyquist频率)
    %0 1 2 3 -3 -2 -1(nSamp=odd，无Nyq频率)

    %fftshift 所对应的频率是
    %-4 -3 -2 -1 0 1 2 3 4 %5% (nSamp=even，5为Nyquist频率,)但是要注意，PSD4posFreq虽然叫正频率所对应的PSD，但实际上第一个分量是直流分量，即PSD4posFreq(1)对应频率为0的量
    %-3 -2 -1 0 1 2 3 (nSamp=odd，无Nyq频率)

    if mod(nSamp, 2) == 0 %nSamp为偶数时,如上例中NyqIdx=6，对应f=5
        PSDnorm = [PSD4posFreq(NyqIdx - 1:-1:2), PSD4posFreq];
    else %nSamp为奇数时,如上例中NyqIdx=4，对应f=3
        PSDnorm = [PSD4posFreq(NyqIdx:-1:2), PSD4posFreq];
    end

    Prod = 1 / (nSamp * sampFreq) * (xfftSft ./ PSDnorm * yfftSft');
    finalProd = real(Prod);

end

% 为什么后半部分对应于负频率？
% X[k] = ∑ x[n]·e^(-j2πnk/N), k=0,1,...,N-1

% x[n] = ∑ X[k]·e^(+j2πnk/N), k=0,1,...,N-1
% 我们给e^(+j2πnk/N)乘一个1得： e^(j2πnk/N)*1 = e^(j2πnk/N)·e^(-j2πn) = e^(j2πn*delta(k-N)/(N*delta))，频率f正比于这个index，具体来说是f=(k-N)/(N*delta)=(k-N)/T(总周期长度) <0
%离散内积：$\langle \bar{x}, \bar{y} \rangle = \frac{\Delta}{N} \sum_{m=0}^{N-1} \tilde{x}_m \cdot \frac{\tilde{y}_m^*}{S_n(f_m)}
% =\frac{1}{N f_s} \sum_{m=0}^{N-1} \tilde{x}_m \cdot \frac{\tilde{y}_m^*}{S_n(f_m)}$
