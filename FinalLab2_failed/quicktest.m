% quicktest.m
AD = load('analysisData.mat'); TD = load('TrainingData.mat');
x  = AD.dataVec(:).'; Fs = double(AD.sampFreq); N = numel(x);
t  = (0:N-1)/Fs; u = (0:N-1)/N;

[fpsd, Pxx_one] = estimatePSD_welch(TD.trainData, Fs);
Ppos = interpPSD2DFTBins(fpsd, Pxx_one, N, Fs);

% ===== 选项1：是否对单边 PSD /2 =====
doHalf = true;        % 与 Python 一致 -> true
if doHalf, Ppos = Ppos/2; end

% ===== 选项2：时间基准 =====
useU = false;         % Python 用 t -> false；若怀疑参数是在 u 下给出的，改 true 试试看
time = ternary(useU, u, t);

% 你要测试的参数（把你 Python 打印的那组贴进来）
coefs = [49.25, 31.23, 9.53];

glrt = glrtqcsig(time, x, Fs, Ppos, coefs);  % GLRT = LLR^2
SNR  = sqrt(glrt);
fprintf('基准=%s, PSD%s/2:  a=[%.2f,%.2f,%.2f],  SNR=%.6g\n', ...
        ternary(useU,'u','t'), ternary(doHalf,'已','未'), coefs, SNR);
