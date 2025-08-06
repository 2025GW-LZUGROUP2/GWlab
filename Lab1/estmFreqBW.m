function fmaxEst = estmFreqBW(s_t,sym_var, a, b)
%estimate frequency band width 初步估计频率带宽（大致值，可能不准确，需和）
    % 输入：信号表达式s_t如a1*t+a2*t^2+a3*t^3，信号表达式的自变量如sym('t')时间区间[a,b]
    % 输出：fmaxest:估计的信号带宽，乘以二才是Nyq频率
    
    tempFs = 1000;                % 临时高采样率（足够捕捉信号细节）
    tempDelta = 1/tempFs;
    tempTime = a:tempDelta:b;     % 临时时间向量
    tempSVec = double(subs(s_t, sym_var, tempTime)); % 临时离散信号
    
    % 计算临时频域信息
    tempFoufun = fftshift(fft(tempSVec));
    tempFreq = ((0:length(tempTime)-1)-floor(length(tempTime)/2))*(tempFs/length(tempTime));
    tempESD = tempDelta^2 * abs(tempFoufun).^2;%Energy Spectrum Density能量谱密度，乘delta^2是因为离散化
    
    % 找到99%能量对应的频率（估计信号最高频率）
    cumEnergy = cumsum(tempESD)/sum(tempESD);
    [~, idx] = max(cumEnergy >= 0.999);
    fmaxEst = abs(tempFreq(idx));
    
    %fs = 2 * fmaxEst * 2; % Nyquist频率×2（安全系数，避免混叠）
    %fs = max(fs, 100);    % 确保最低采样率100Hz
    fprintf('估计的频率带宽为%.4f \n',fmaxEst);
end
