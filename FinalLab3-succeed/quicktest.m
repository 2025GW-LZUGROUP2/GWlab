AD = load('analysisData.mat'); TD = load('TrainingData.mat');
x  = AD.dataVec(:).';  fs = double(AD.sampFreq);  N = numel(x);
t  = (0:N-1)/fs;

[f, P1] = estimatePSD_welch(TD.trainData, fs);
Ppos = interpPSD2DFTBins(f, P1, N, fs);
Ppos = Ppos/2;                        % 与 Python 一致
glrt = glrtqcsig(t, x, fs, Ppos, [50,30,10]);   % GLRT = LLR^2
SNR  = sqrt(glrt)
