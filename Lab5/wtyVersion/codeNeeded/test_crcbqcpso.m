%% Minimize the fitness function CRCBQCFITFUNC using PSO 使用PSO最小化适应度函数CRCBQCFITFUNC
% Data length 数据长度
nSamples = 512;
% Sampling frequency 采样频率
Fs = 512;
% Signal to noise ratio of the true signal 真实信号的信噪比
snr = 10;
% Phase coefficients parameters of the true signal 真实信号的相位系数参数
a1 = 10;
a2 = 3;
a3 = 3;

% Search range of phase coefficients 相位系数的搜索范围
rmin = [1, 1, 1];
rmax = [15, 5, 5];

% Number of independent PSO runs 独立PSO运行次数
nRuns = 8;
%% Do not change below 不要修改以下内容
% Generate data realization 生成数据实现
dataX = (0:(nSamples-1))/Fs;
% Reset random number generator to generate the same noise realization,
% otherwise comment this line out
% 重置随机数生成器以生成相同的噪声实现，否则注释掉这一行
rng('default');
% Generate data realization 生成数据实现
[dataY, sig] = crcbgenqcdata(dataX,snr,[a1,a2,a3]);

% Input parameters for CRCBQCHRPPSO CRCBQCHRPPSO的输入参数
inParams = struct('dataX', dataX,...
                  'dataY', dataY,...
                  'dataXSq',dataX.^2,...
                  'dataXCb',dataX.^3,...
                  'rmin',rmin,...
                  'rmax',rmax);
% CRCBQCHRPPSO runs PSO on the CRCBQCHRPFITFUNC fitness function. As an
% illustration of usage, we change one of the PSO parameters from its
% default value.
% CRCBQCHRPPSO在CRCBQCHRPFITFUNC适应度函数上运行PSO。
% 作为使用示例，我们将其中一个PSO参数从默认值更改。
outStruct = crcbqcpso(inParams,struct('maxSteps',2000),nRuns);

%%
% Plots 绘图
figure('Name', '二次啁啾信号估计结果');
hold on;
plot(dataX,dataY,'.');
plot(dataX,sig);
for lpruns = 1:nRuns
    plot(dataX,outStruct.allRunsOutput(lpruns).estSig,'Color',[51,255,153]/255,'LineWidth',4.0);
end
plot(dataX,outStruct.bestSig,'Color',[76,153,0]/255,'LineWidth',2.0);
legend('数据点','真实信号',...
       ['估计信号: ',num2str(nRuns),' 次运行'],...
       '估计信号: 最佳运行', 'Location', 'best');
disp(['Estimated parameters: a1=',num2str(outStruct.bestQcCoefs(1)),...
                             '; a2=',num2str(outStruct.bestQcCoefs(2)),...
                             '; a3=',num2str(outStruct.bestQcCoefs(3))]);

