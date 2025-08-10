% filepath: ./data/load_data_example.m
% 加载 TrainingData.mat 文件
data1 = load('TrainingData.mat');
disp('Keys in the loaded data from TrainingData.mat:');
disp(fieldnames(data1));

% 采样频率
fs = data1.sampFreq;
if isrow(fs)
    fs = fs(1);
else
    fs = fs(1);
end
disp(['sample frequency: ', num2str(fs)]);

% 训练数据
trainData = data1.trainData(:); % 转为列向量
disp(['train data shape: ', mat2str(size(trainData))]);
disp('train data:');
disp(trainData);

disp(' ');

% 加载 analysisData.mat 文件
data2 = load('analysisData.mat');
disp('Keys in the loaded data from analysisData.mat:');
disp(fieldnames(data2));

% 分析数据
analysisData = data2.dataVec(:); % 转为列向量
nsamples = length(analysisData);
disp(['analysis data shape: ', mat2str(size(analysisData))]);
disp('analysis data:');
disp(analysisData);

% 时间向量
time_vec = (0:nsamples-1)' / fs;



% filepath: ./data/estimate_psd.m
% 使用Welch方法估计PSD
nperseg = 256;
[psd_vec, f] = pwelch(trainData, hamming(nperseg), [], nperseg, fs); % 一侧PSD
psd_vec = psd_vec / 2; % 转为双侧PSD

% 将频率插值到DFT所需的频率点
data_len = nsamples / fs;
k_nyq = floor(nsamples / 2) + 1;
pos_freq = (0:k_nyq-1) / data_len;
psd_interp = interp1(f, psd_vec, pos_freq, 'linear', 'extrap');
f = pos_freq;
psd_vec = psd_interp;

% 绘制PSD
figure('Position',[100,100,800,480]);
plot(f, psd_vec);
title('Estimated Power Spectral Density (PSD) using Welch''s Method');
xlabel('Frequency [Hz]');
ylabel('PSD [V^2/Hz]');
grid on;

