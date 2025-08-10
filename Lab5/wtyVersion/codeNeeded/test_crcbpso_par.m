%% Test harness for CRCBPSO CRCBPSO测试工具
% The fitness function called is CRCBPSOTESTFUNC. 调用的适应度函数是CRCBPSOTESTFUNC
ffparams = struct('rmin',-100,...
                     'rmax',100 ...
                  );
% Fitness function handle. 适应度函数句柄
fitFuncHandle = @(x) crcbpsotestfunc(x,ffparams);
%%
% Dimensionality of the search space 搜索空间的维度
nDim = 2;

% Call PSO and use best-of-M-runs 调用PSO并使用M次运行中的最佳结果
nRuns = 4; %Number of PSO runs PSO运行次数
psoOut = struct('totalFuncEvals',[],...
                    'bestLocation',zeros(1,nDim),...
                    'bestFitness',[]);
%We need to have one psoOut struct for each run: make a struct array with
%each element initialized to be the same as the first
% 我们需要为每次运行有一个psoOut结构：创建一个结构数组，每个元素都初始化为与第一个相同
for lpruns = 2:nRuns
    psoOut(lpruns) = psoOut(1);
end
parfor lpruns = 1:nRuns
        %Reset random number generator for each worker such that the
        %pseudo-random sequence is different for them but they repeat
        %everytime this code is run
        % 为每个工作线程重置随机数生成器，使得伪随机序列对它们是不同的，
        % 但每次运行此代码时都会重复
        rng(lpruns);
        %PSO run PSO运行
        psoOut(lpruns) = crcbpso(fitFuncHandle,nDim);
end
%Find best run 找到最佳运行
bestRun = 1;
for lpruns = 2:nRuns
    if psoOut(lpruns).bestFitness < psoOut(bestRun).bestFitness
        bestRun = lpruns;
    end
end
%% Estimated parameters 估计参数
% Best standardized and real coordinates found. 找到的最佳标准化和实际坐标
stdCoord = psoOut(bestRun).bestLocation;
[~,realCoord] = fitFuncHandle(stdCoord);
disp(['Best run:',num2str(bestRun)]);
disp(['Best location:',num2str(realCoord)]);
disp(['Best fitness:', num2str(psoOut(bestRun).bestFitness)]);
disp('Info for all runs:');
for lpruns = 1:nRuns
    stdCoord = psoOut(lpruns).bestLocation;
    [~,realCoord] = fitFuncHandle(stdCoord);
    disp(['Best location for run ',num2str(lpruns),': ',num2str(realCoord)]);
    disp(['Best fitness for run ',num2str(lpruns),': ', num2str(psoOut(lpruns).bestFitness)]);
    disp('*****************');
end