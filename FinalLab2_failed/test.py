# Write additional MATLAB functions aligned with the GitHub reference (sin-only GLRT, normalized time).
from pathlib import Path

base = Path(__file__).parent

innerprod_m = r"""function inn_prod = innerprod_psd(x_vec, y_vec, Fs, psd_pos)
%INNERPROD_PSD 在指定 PSD 下计算两个序列的频域加权内积
%   inn_prod = INNERPROD_PSD(x, y, Fs, psd_pos)
% 输入：
%   x_vec, y_vec : 两个长度相同的向量（行/列均可）
%   Fs           : 采样频率
%   psd_pos      : 单边 PSD（长度为 floor(N/2)+1，对应 [0,Fs/2] 的DFT正频率）
% 输出：
%   inn_prod     : 频域 PSD 加权内积（实数）
%
% 说明：
%   与参考代码相同的实现思路：先做 FFT，再用单边 PSD 镜像成“双边” PSDnorm，
%   然后按 (1/(N*Fs))*sum( X(f)*conj(Y(f)) ./ PSDnorm ) 计算；取实部。
%
% 作者：你的小伙伴（中文详注）
x_vec = x_vec(:).'; y_vec = y_vec(:).';
N = length(x_vec);
if length(y_vec) ~= N
    error('向量长度必须一致');
end
kNyq = floor(N/2)+1;
if length(psd_pos) ~= kNyq
    error('psd_pos 长度应为 floor(N/2)+1');
end

% 复制单边 PSD 到双边（与参考 function.py 保持一致的顺序）
neg_f_strt = 1 - mod(N,2); % N 偶数->1, 奇数->0
psd_vec_4_norm = [psd_pos, psd_pos(((kNyq-1)-neg_f_strt):-1:1)];

X = fft(x_vec); Y = fft(y_vec);
data_len = N*Fs;
inn_prod = (1/data_len) * sum( (X./psd_vec_4_norm) .* conj(Y) );
inn_prod = real(inn_prod);
end
"""

normsig_m = r"""function [norm_sig_vec, norm_fac] = normsig4psd(sig_vec, Fs, psd_pos, snr)
%NORMSIG4PSD 将信号在给定 PSD 下归一到指定 SNR
%   [y, c] = NORMSIG4PSD(sig_vec, Fs, psd_pos, snr)
% 输入：
%   sig_vec : 待归一化信号
%   Fs      : 采样频率
%   psd_pos : 单边 PSD（正频率）
%   snr     : 目标 SNR
% 输出：
%   norm_sig_vec : 归一后的信号
%   norm_fac     : 归一化因子
%
% 作者：你的小伙伴（中文详注）
sig_vec = sig_vec(:).';
kNyq = floor(length(sig_vec)/2)+1;
if length(psd_pos) ~= kNyq
    error('psd_pos 长度应为 floor(N/2)+1');
end
norm_sig_sq = innerprod_psd(sig_vec, sig_vec, Fs, psd_pos);
norm_fac = snr / sqrt(norm_sig_sq);
norm_sig_vec = norm_fac * sig_vec;
end
"""

crcbgen_m = r"""function sigVec = crcbgenqcsig(timeVec, snr, qcCoefs)
%CRCBGENQCSIG 生成二次啁啾信号（与参考实现一致）
%   sig = CRCBGENQCSIG(timeVec, snr, [a1,a2,a3])
% 相位：phi = a1*t + a2*t^2 + a3*t^3，信号：sin(2*pi*phi)；
% 然后按欧氏范数归一，再乘以 snr（仅生成“形状”时建议 snr=1）。
%
% 作者：你的小伙伴（中文详注）
timeVec = timeVec(:).';
a1 = qcCoefs(1); a2 = qcCoefs(2); a3 = qcCoefs(3);
phaseVec = a1*timeVec + a2*(timeVec.^2) + a3*(timeVec.^3);
sigVec = sin(2*pi*phaseVec);
sigVec = snr * sigVec / norm(sigVec);
end
"""

glrt_sin_m = r"""function glrt_val = glrtqcsig(timeVec, dataVec, Fs, psd_pos, qcCoefs)
%GLRTQCSIG  二次啁啾信号（未知幅度，固定相位）GLRT（sin 模板）
%   glrt = GLRTQCSIG(timeVec, dataVec, Fs, psd_pos, [a1,a2,a3])
% 步骤：
%   1) 生成模板 s(t) = sin(2*pi*(a1*t + a2*t^2 + a3*t^3))；
%   2) 用 NORMSIG4PSD 将模板在 PSD 下归一为单位 SNR；
%   3) 计算 llr = (data|template_unit)；返回 glrt = llr^2。
%
% 注：此实现与仓库 function.py/glrtqcsig 的思路一致（仅 sin，无 cos 正交项）。
%
% 作者：你的小伙伴（中文详注）
timeVec = timeVec(:).'; dataVec = dataVec(:).';
% 生成单位 SNR 模板
tmp = crcbgenqcsig(timeVec, 1, qcCoefs);
[template_unit, ~] = normsig4psd(tmp, Fs, psd_pos, 1);
% GLRT
llr = innerprod_psd(dataVec, template_unit, Fs, psd_pos);
glrt_val = llr^2;
end
"""

# Enhanced run script with options
run_final2_m = r"""function results = run_final_lab(useNormalizedTime, rmin, rmax, psoSteps, useSinOnly)
% 期末 Lab 主脚本（对齐参考仓库；默认：归一化时间 + sin-only GLRT）
%   results = run_final_lab(true, [40,20,5], [60,40,15], 800, true);
%
% 输入：
%   useNormalizedTime : 是否用归一化时间 u∈[0,1)（默认 true；与参数规模 50/30/10 匹配）
%   rmin, rmax        : 搜索边界（默认 [0,0,0] 到 [100,50,20]）
%   psoSteps          : PSO 迭代步数（默认 800）
%   useSinOnly        : GLRT 是否使用仅 sin 模板（true，默认）
%
% 输出：
%   results.a1,a2,a3,SNR,Ahat,bestFitness 等
%
% 作者：你的小伙伴（中文详注）

if nargin < 1 || isempty(useNormalizedTime), useNormalizedTime = true; end
if nargin < 2 || isempty(rmin), rmin = [0,0,0]; end
if nargin < 3 || isempty(rmax), rmax = [100,50,20]; end
if nargin < 4 || isempty(psoSteps), psoSteps = 800; end
if nargin < 5 || isempty(useSinOnly), useSinOnly = true; end

clc; close all;
TD = load('TrainingData.mat');      % trainData (1xN), sampFreq
AD = load('analysisData.mat');      % dataVec  (1xN), sampFreq
trainData = TD.trainData(:).';
dataVec   = AD.dataVec(:).';
Fs        = double(AD.sampFreq);
N  = numel(dataVec);

% ------- 时间轴 -------
t  = (0:N-1)/Fs;     % 秒
u  = (0:N-1)/N;      % 归一化时间
if useNormalizedTime
    timeBase = u;
    disp('相位使用归一化时间 u ∈ [0,1)。');
else
    timeBase = t;
    disp('相位使用物理时间 t（秒）。');
end

% ------- Welch PSD -------
[f_psd, Pxx] = estimatePSD_welch(trainData, Fs);
Ppos = interpPSD2DFTBins(f_psd, Pxx, N, Fs);

figure; plot(f_psd, Pxx), grid on;
xlabel('频率 (Hz)'); ylabel('PSD (单位^2/Hz)');
title('Welch 单边 PSD');

% ------- 适应度函数（PSO 最小化 -GLRT 或 -SNR^2） -------
fitHandle = @(xstd) local_fit(xstd, dataVec, timeBase, Fs, Ppos, rmin, rmax, useSinOnly);

% ------- PSO 参数 -------
psoParams = struct();
psoParams.popSize   = 80;
psoParams.maxSteps  = psoSteps;
psoParams.c1        = 2; psoParams.c2 = 2;
psoParams.maxVelocity = 0.5;
psoParams.startInertia = 0.9; psoParams.endInertia = 0.4;
psoParams.nbrhdSz   = 3;
outLvl = 2;

rng(2025);
psoOut = crcbpso(fitHandle, 3, psoParams, outLvl);

% ------- 反标准化得到参数 -------
xstd_best = psoOut.bestLocation;
a_best    = xstd_best.*(rmax - rmin) + rmin;
a1 = a_best(1); a2 = a_best(2); a3 = a_best(3);

% ------- 计算最终 SNR 和重构 -------
phi = a1*timeBase + a2*(timeBase.^2) + a3*(timeBase.^3);
s1  = sin(2*pi*phi);
if useSinOnly
    % 单模板：单位 SNR 模板，SNR = |(x|s_unit)|，幅度 A = (x|s_unit)
    [s_unit, ~] = normsig4psd(s1, Fs, Ppos, 1);
    llr = innerprod_psd(dataVec, s_unit, Fs, Ppos);
    SNR = abs(llr);
    recon = llr * s_unit;  % A*s_unit
    Ahat = llr;
else
    % 正交（sin+cos）：GLRT SNR^2 = b^T G^{-1} b
    s2 = cos(2*pi*phi);
    [snr2, A, ~] = matchedFilterGLRT_quadrature(dataVec, s1, s2, Ppos, Fs);
    SNR = sqrt(snr2);
    recon = A.A1*s1 + A.A2*s2;
    Ahat = [A.A1, A.A2];
end

% ------- 作图与返回 -------
figure; plot(t, dataVec); hold on; plot(t, recon, 'LineWidth', 1.5); grid on;
xlabel('时间 (s)'); ylabel('幅值'); legend('analysisData','最优拟合');
title('数据与最优拟合信号');

figure; plot(psoOut.allBestFit); grid on;
xlabel('迭代'); ylabel('全局最优目标值'); title('PSO 收敛曲线（-GLRT 或 -SNR^2）');

results = struct('a1',a1,'a2',a2,'a3',a3,'SNR',SNR,...
                 'bestFitness',psoOut.bestFitness,'useNormalizedTime',useNormalizedTime,...
                 'rmin',rmin,'rmax',rmax,'useSinOnly',useSinOnly);
fprintf('最优参数：a1=%.6f, a2=%.6f, a3=%.6f,  SNR≈%.3f\n', a1,a2,a3,SNR);
end

function fval = local_fit(xstd, dataVec, timeBase, Fs, Ppos, rmin, rmax, useSinOnly)
% 将标准化坐标映射为真实参数，计算 -GLRT 作为适应度
a = xstd(:)'.*(rmax - rmin) + rmin;
phi = a(1)*timeBase + a(2)*(timeBase.^2) + a(3)*(timeBase.^3);
s1  = sin(2*pi*phi);
if useSinOnly
    [s_unit, ~] = normsig4psd(s1, Fs, Ppos, 1);
    llr = innerprod_psd(dataVec, s_unit, Fs, Ppos);
    fval = -(llr^2);        % 最大化 GLRT -> 最小化 -GLRT
else
    s2 = cos(2*pi*phi);
    [snr2, ~, ~] = matchedFilterGLRT_quadrature(dataVec, s1, s2, Ppos, Fs);
    fval = -snr2;
end
end
"""


# 确保目录存在
for fname in ["innerprod_psd.m", "normsig4psd.m", "crcbgenqcsig.m", "glrtqcsig.m", "run_final_lab.m"]:
    (base / fname).parent.mkdir(parents=True, exist_ok=True)

(base / "innerprod_psd.m").write_text(innerprod_m, encoding="utf-8")
(base / "normsig4psd.m").write_text(normsig_m, encoding="utf-8")
(base / "crcbgenqcsig.m").write_text(crcbgen_m, encoding="utf-8")
(base / "glrtqcsig.m").write_text(glrt_sin_m, encoding="utf-8")
(base / "run_final_lab.m").write_text(run_final2_m, encoding="utf-8")

[str(p) for p in [base/"innerprod_psd.m", base/"normsig4psd.m", base/"crcbgenqcsig.m",
                  base/"glrtqcsig.m", base/"run_final_lab.m"]]
