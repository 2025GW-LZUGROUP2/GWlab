AD = load('analysisData.mat'); TD = load('TrainingData.mat');
x  = AD.dataVec(:).'; Fs = double(AD.sampFreq); N = numel(x);

% 秒 t；若想测归一化时间 u，改成 u=(0:N-1)/N
t  = (0:N-1)/Fs;     

% Welch -> 单边 -> 插值到 DFT -> (可选)/2
[fpsd,P1] = estimatePSD_welch(TD.trainData, Fs);
Ppos = interpPSD2DFTBins(fpsd,P1,N,Fs);
doHalf = true; 
if doHalf, Ppos = Ppos/2; end

coefs = [50,30,10];     % 或者 [49.25,31.23,9.53]
glrt = glrtqcsig(t, x, Fs, Ppos, coefs);
SNR  = sqrt(glrt);
fprintf('t基准, PSD%s/2:  a=[%.2f,%.2f,%.2f],  SNR=%.6g\n', tern(doHalf,'已','未'), coefs, SNR);

% === 额外：白化后用普通点积做个交叉验证 ===
s     = crcbgenqcsig(t, 1, coefs);
[su,~]= normsig4psd(s, Fs, Ppos, 1); % 单位SNR模板
xw    = whiten_with_psd(x, Ppos, Fs);
sw    = whiten_with_psd(su, Ppos, Fs);
% 在完全白化后，(x|s) ≈ (1/(N*Fs))*sum( FFT(xw).*conj(FFT(sw)) )，
% 也近似于 time-domain 的 <xw, sw> * (Fs/N)（只做数量级对照）
llr_w = (xw*sw.') * (Fs/N);
fprintf('白化后 time-domain 近似 LLR ≈ %.6g（仅数量级参考）\n', llr_w);

function s=tern(c,a,b); if c, s=a; else, s=b; end; end
