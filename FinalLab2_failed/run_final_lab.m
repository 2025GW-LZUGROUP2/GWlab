function results = run_final_lab(useNormalizedTime, rmin, rmax, psoSteps, useSinOnly, nRuns, popSize, halveOneSidedPSD)
% 快速 PSO 版本（去并行，预设接近你的 Python）
% 推荐：
% results = run_final_lab(false, [0,0,0], [100,100,100], 800, true, 8, 100, true);

if nargin<1 || isempty(useNormalizedTime), useNormalizedTime=false; end
if nargin<2 || isempty(rmin), rmin=[0,0,0]; end
if nargin<3 || isempty(rmax), rmax=[100,100,100]; end
if nargin<4 || isempty(psoSteps), psoSteps=800; end
if nargin<5 || isempty(useSinOnly), useSinOnly=true; end
if nargin<6 || isempty(nRuns), nRuns=8; end
if nargin<7 || isempty(popSize), popSize=100; end
if nargin<8 || isempty(halveOneSidedPSD), halveOneSidedPSD=true; end

clc; close all;
TD = load('TrainingData.mat'); AD = load('analysisData.mat');
train = TD.trainData(:).';  x = AD.dataVec(:).';
Fs = double(AD.sampFreq);     N = numel(x);

t = (0:N-1)/Fs; u = (0:N-1)/N;
time = t; if useNormalizedTime, time = u; end
fprintf('时间基准: %s\n', tern(useNormalizedTime,'u','t')); 
fprintf('数据: N=%d, Fs=%g Hz, std(data)=%.3e\n', N, Fs, std(x));

% Welch -> 单边 -> 插值 -> 可选 /2
[fpsd,P1] = estimatePSD_welch(train, Fs);
Ppos = interpPSD2DFTBins(fpsd, P1, N, Fs);
if halveOneSidedPSD, Ppos = Ppos/2; end
fprintf('PSD%s/2\n', tern(halveOneSidedPSD,'已','未'));

% 适应度句柄（-GLRT）——批量评估
fitHandle = @(Xstd) local_fit_batch(Xstd, x, time, Fs, Ppos, rmin, rmax, useSinOnly);

% 多次独立 PSO，取最好（无并行）
bestFit = inf; bestLoc = []; bestAll = [];
for r=1:nRuns
    out = one_pso_run(fitHandle, popSize, psoSteps);
    if out.bestFitness < bestFit
        bestFit = out.bestFitness; bestLoc = out.bestLocation; bestAll = out.allBestFit;
    end
end

% 反标准化
a = bestLoc.*(rmax - rmin) + rmin;
a1=a(1); a2=a(2); a3=a(3);

% 计算 SNR 与拟合（sin-only）
phi = a1*time + a2*(time.^2) + a3*(time.^3);
s   = sin(2*pi*phi);
[su,~] = normsig4psd(s, Fs, Ppos, 1);
llr = innerprod_psd(x, su, Fs, Ppos);
SNR = abs(llr);
recon = llr * su;

% 图
figure; plot((0:N-1)/Fs, x); hold on; plot((0:N-1)/Fs, recon, 'LineWidth',1.4);
grid on; legend('data','fit'); xlabel('s'); ylabel('amp'); title('时域拟合');
figure; plot(bestAll); grid on; xlabel('iter'); ylabel('global best'); title('-GLRT 收敛');

results = struct('a1',a1,'a2',a2,'a3',a3,'SNR',SNR,...
                 'bestFitness',bestFit,'useNormalizedTime',useNormalizedTime,...
                 'rmin',rmin,'rmax',rmax,'useSinOnly',useSinOnly,...
                 'halveOneSidedPSD',halveOneSidedPSD);
fprintf('最优参数：a1=%.6f, a2=%.6f, a3=%.6f,  SNR=%.6f\n', a1,a2,a3,SNR);
end

% ===== 子函数 =====
function out = one_pso_run(fit, pop, steps)
psoParams = struct();
psoParams.popSize     = pop;
psoParams.maxSteps    = steps;
psoParams.c1          = 0.2; 
psoParams.c2          = 0.1;
psoParams.maxVelocity = 0.5;
psoParams.startInertia= 0.99;
psoParams.endInertia  = 0.99;
psoParams.nbrhdSz     = pop;   % 全局邻域
outLvl = 2;
rng('shuffle');
out = crcbpso(fit, 3, psoParams, outLvl);
end

function fval = local_fit_batch(Xstd, x, time, Fs, Ppos, rmin, rmax, useSinOnly)
[nRows,~] = size(Xstd);
fval = zeros(nRows,1);
for i=1:nRows
    a = Xstd(i,:).*(rmax - rmin) + rmin;
    phi = a(1)*time + a(2)*(time.^2) + a(3)*(time.^3);
    s   = sin(2*pi*phi);
    [su,~] = normsig4psd(s, Fs, Ppos, 1);
    llr = innerprod_psd(x, su, Fs, Ppos);
    fval(i) = -(llr^2);  % sin-only 与 Python 一致
end
end

function s=tern(c,a,b); if c, s=a; else, s=b; end; end
