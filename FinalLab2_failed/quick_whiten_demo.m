AD = load('analysisData.mat'); TD = load('TrainingData.mat');
x  = AD.dataVec(:).';  Fs = double(AD.sampFreq);  N = numel(x);
train = TD.trainData(:).';

% Welch 单边 PSD -> DFT 栅格
[fpsd, P1] = estimatePSD_welch(train, Fs);
Ppos = interpPSD2DFTBins(fpsd, P1, N, Fs);

% === 是否对单边 PSD 除以 2（Python 是“/2”）===
halveOneSidedPSD = true;
if halveOneSidedPSD, Ppos = Ppos/2; end

% 白化
xw     = whiten_with_psd(x, Ppos, Fs);
trainw = whiten_with_psd(train(1:N), Ppos, Fs);  % 截到同长度便于比较

fprintf('白化后 std(trainw)=%.3f, std(xw)=%.3f\n', std(trainw), std(xw));

% 白化后的 PSD
[Pw,f] = pwelch(trainw, hann(256,'periodic'),128,256,Fs,'onesided','psd');
figure; plot(f,Pw); grid on; title('白化后的 PSD（应近似平坦）'); xlabel('Hz'); ylabel('PSD');

% 白化时域
t = (0:N-1)/Fs;
figure; subplot(2,1,1); plot(t, trainw); grid on; title('白化 trainData（片段）');
subplot(2,1,2); plot(t, xw);     grid on; title('白化 analysisData');
