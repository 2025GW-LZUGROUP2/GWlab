function results = finalLabfast(varargin)
    % 期末Lab（加速版）：PSD预计算 + 批量FFT矢量化 + 多次PSO并行
    % ---------------------------------------------------------------
    % 可选参数（Name-Value）：
    %   'Bounds'       : [rmin; rmax]，默认 [0 0 0; 100 100 100]
    %   'Iters'        : 单次PSO迭代，默认 100
    %   'PopSize'      : 粒子数，默认 100
    %   'NRuns'        : 独立运行次数，默认 200（建议 200~500；再大就开并行）
    %   'UseParallel'  : true/false，默认 true（有并行工具箱则用 parfor）
    %   'WelchNperseg' : Welch nperseg，默认 256（与Python一致）
    %   'PSDHalf'      : 是否对单边PSD除以2，默认 true（与Python一致）
    %
    % 返回：
    %   results: struct(a1,a2,a3,SNR,bestFitness, ...)

    % ---------------- 参数解析 ----------------
    p = inputParser;
addParameter(p,'Bounds',[0 0 0; 100 100 100]);
addParameter(p,'Iters',100);
addParameter(p,'PopSize',100);
addParameter(p,'NRuns',200);
addParameter(p,'UseParallel',true);
addParameter(p,'WelchNperseg',256);
addParameter(p,'PSDHalf',true);
parse(p,varargin{:});
    par = p.Results;

    clc; fprintf('== 加速版 run_final_lab_fast ==\n');

    % ---------------- 读数据 ----------------
    TD = load('TrainingData.mat'); AD = load('analysisData.mat');
    fs = double(AD.sampFreq);
x  = AD.dataVec(:).';
    train = TD.trainData(:).';
N  = numel(x);
t  = (0:N-1)/fs;

    fprintf('N=%d, Fs=%g Hz, std(data)=%.3e\n', N, fs, std(x));

    % ---------------- Welch 单边 PSD（nperseg=par.WelchNperseg）----------------
    [f_psd, Pxx_one] = local_welch(train, fs, par.WelchNperseg);
    Ppos = local_interp_to_dft(f_psd, Pxx_one, N, fs);
if par.PSDHalf, Ppos = Ppos/2; end

    % ---------------- 预计算（一次性）----------------
    pre = local_precompute_pack(x, fs, Ppos);
pre.t   = t;
pre.t2  = t.^2;
pre.t3  = t.^3;
pre.c   = 1/(N*fs);             % 频域内积因子
pre.rmin= par.Bounds(1,:);
pre.rmax= par.Bounds(2,:);

    % ---------------- 适应度：批量 -GLRT（矢量化 + 频域缓存）----------------
    fitHandle = @(Xstd) local_fit_fast_batch(Xstd, pre);

    % ---------------- 多次独立 PSO（可并行）----------------
nRuns   = par.NRuns;
    popSize = par.PopSize;
iters   = par.Iters;

    bestFit = inf; bestLoc = []; bestAllBest = [];

    % 并行开关
    usePar = par.UseParallel && license('test', 'Distrib_Computing_Toolbox');

    if usePar
        ppool = gcp('nocreate');
        if isempty(ppool), parpool; end

        parfor r = 1:nRuns
            out = local_one_pso_run(fitHandle, popSize, iters);
            outs(r) = out; %#ok<AGROW>
        end

    else
        for r = 1:nRuns
            outs(r) = local_one_pso_run(fitHandle, popSize, iters);
        end

    end

    for r = 1:nRuns

        if outs(r).bestFitness < bestFit
        bestFit    = outs(r).bestFitness;
        bestLoc    = outs(r).bestLocation;
        bestAllBest= outs(r).allBestFit;
        end

    end

    % ---------------- 反标准化、计算最终 SNR ----------------
a = bestLoc.*(pre.rmax-pre.rmin)+pre.rmin;
a1=a(1); a2=a(2); a3=a(3);

phi = a1*pre.t + a2*pre.t2 + a3*pre.t3;
s   = sin(2*pi*phi);

    % 单位SNR模板用预计算的PSD内积做归一
E   = local_energy_fft(s, pre);         % (s|s)
su  = s / sqrt(E);                      % 单位SNR模板
llr = local_llr_fft(su, pre);           % (x|su)
    SNR = abs(llr);

    % ---------------- 输出与绘图 ----------------
    fprintf('最优参数：a1=%.6f, a2=%.6f, a3=%.6f,  SNR=%.6f\n', a1, a2, a3, SNR);

    figure; plot(t, x); hold on;
    recon = llr * su;
    plot(t, recon, 'LineWidth', 1.4);
    grid on; xlabel('s'); ylabel('amp'); legend('data', 'fit');
    title('时域拟合');

    figure; plot(bestAllBest); grid on;
    xlabel('iter'); ylabel('global best'); title('PSO 收敛（-GLRT）');

    results = struct('a1', a1, 'a2', a2, 'a3', a3, 'SNR', SNR, ...
        'bestFitness', bestFit, 'rmin', pre.rmin, 'rmax', pre.rmax, ...
        'WelchNperseg', par.WelchNperseg, 'PSDHalf', par.PSDHalf, ...
        'Iters', iters, 'PopSize', popSize, 'NRuns', nRuns, 'UseParallel', usePar);
end

% ================== 子函数：Welch ==================
function [f, Pxx_one] = local_welch(trainData, fs, nperseg)
    trainData = trainData(:);
    win = hann(nperseg, 'periodic');
    nover = floor(nperseg / 2);
    nfft = nperseg;
    [Pxx_one, f] = pwelch(trainData, win, nover, nfft, fs, 'onesided', 'psd');
    % ★ 不设地板，与 Python 一致
end

% ============== 子函数：插值到正频 DFT 栅格 ==============
function Ppos = local_interp_to_dft(f, Pxx, N, fs)
    kNyq = floor(N / 2) + 1;
    data_len = N / fs;
    pos_freq = (0:(kNyq - 1)) / data_len; % Hz
    Ppos = interp1(f, Pxx, pos_freq, 'linear', 'extrap');
end

% ============== 子函数：预计算频域缓存 ==============
function pre = local_precompute_pack(x, fs, Ppos)
    N = numel(x);
    kNyq = floor(N / 2) + 1;
    if numel(Ppos) ~= kNyq, error('Ppos length mismatch'); end

    % 双边 PSD：与 Python 完全一致的镜像拼接
    neg_f_strt = 1 - mod(N, 2); % even->1, odd->0
    mirror = Ppos((kNyq - neg_f_strt):-1:2);
    PSDnorm = [Ppos(:).', mirror(:).'];

    % 避免除零（仅把恰为0的点置eps）
    PSDnorm(PSDnorm == 0) = eps;

    pre.N = N;
    pre.fs = fs;
    pre.PSDnorm = PSDnorm;
    pre.invPSD = 1 ./ PSDnorm;
    pre.c = 1 / (N * fs);

    X = fft(x);
    pre.XfftNorm = X ./ PSDnorm; % 以后每次只需和模板FFT点乘
end

% ============== 子函数：模板能量 (s|s)（频域一次性计算） ==============
function E = local_energy_fft(s, pre)
    S = fft(s);
    E = pre.c * sum((abs(S) .^ 2) .* pre.invPSD); % (s|s)
    E = real(E);
end

% ============== 子函数：LLR = (x|s)（频域一次性计算） ==============
function llr = local_llr_fft(s, pre)
    S = fft(s);
    llr = pre.c * sum(pre.XfftNorm .* conj(S)); % (x|s)
    llr = real(llr);
end

% ============== 子函数：批量 -GLRT（矢量化） ==============
function fval = local_fit_fast_batch(Xstd, pre)
    % Xstd: M 粒子 × 3 维（标准化坐标）
    if isempty(Xstd), fval = []; return; end
    M = size(Xstd, 1);

    % 反标准化到真实参数
    a = Xstd .* (pre.rmax - pre.rmin) + pre.rmin; % M×3

    % 批量生成模板：phi = a1*t + a2*t^2 + a3*t^3
    phi = a(:, 1) .* pre.t + a(:, 2) .* pre.t2 + a(:, 3) .* pre.t3; % M×N（隐式扩展）

    % 批量 sin
    s = sin(2 * pi * phi); % M×N

    % 批量 FFT（每行一个模板）
    S = fft(s, [], 2); % M×N

    % 批量 (s|s)
    E = pre.c * sum((abs(S) .^ 2) .* pre.invPSD, 2); % M×1

    % 批量 (x|s)
    LLR = pre.c * sum((pre.XfftNorm) .* conj(S), 2); % M×1

    % 单位SNR模板等效：GLRT = (LLR.^2)./E
    GLRT = (real(LLR) .^ 2) ./ real(E + eps); % M×1
    fval = -GLRT; % PSO最小化 -GLRT
end

% ============== 子函数：单次 PSO 运行 ==============
function out = local_one_pso_run(fitHandle, popSize, iters)
    % 用 crcbpso，但设为“全局邻域”（行为近似 pyswarms.GlobalBestPSO）
    psoParams = struct();
    psoParams.popSize = popSize;
    psoParams.maxSteps = iters;
    psoParams.c1 = 0.2;
    psoParams.c2 = 0.1;
    psoParams.maxVelocity = 0.5;
    psoParams.startInertia = 0.99;
    psoParams.endInertia = 0.99;
    psoParams.nbrhdSz = popSize; % 全局邻域

    outLvl = 2;
    rng('shuffle');
    out = crcbpso(fitHandle, 3, psoParams, outLvl);
end
