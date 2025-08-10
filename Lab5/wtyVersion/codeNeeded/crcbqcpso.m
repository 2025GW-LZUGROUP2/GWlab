
function outResults = crcbqcpso(inParams,psoParams,nRuns)
%Regression of quadratic chirp using PSO  % 使用PSO进行二次啁啾信号回归
%O = CRCBQCPPSO(I,P,N)  % O = CRCBQCPPSO(I,P,N)
%I is the input struct with the fields given below.  P is the PSO parameter  % I为输入结构体，字段如下。P为PSO参数结构体
%struct. Setting P to [] will invoke default parameters (see CRCBPSO). N is  % 若P设为[]则使用默认参数（见CRCBPSO）。N为独立PSO运行次数
%the number of independent PSO runs. The output is returned in the struct  % 输出为结构体O
%O. The fields of I are:  % I的字段有：
% 'dataY': The data vector (a uniformly sampled time series).  % 'dataY'：数据向量（均匀采样的时间序列）
% 'dataX': The time stamps of the data samples.  % 'dataX'：数据样本的时间戳
% 'dataXSq': dataX.^2  % 'dataXSq'：dataX的平方
% 'dataXCb': dataX.^3  % 'dataXCb'：dataX的立方
% 'rmin', 'rmax': The minimum and maximum values of the three parameters  % 'rmin', 'rmax'：候选信号中三个参数的最小和最大值
%                 a1, a2, a3 in the candidate signal:  % a1, a2, a3为候选信号参数
%                 a1*dataX+a2*dataXSq+a3*dataXCb  % 信号形式为a1*dataX+a2*dataXSq+a3*dataXCb
%The fields of O are:  % O的字段有：
% 'allRunsOutput': An N element struct array containing results from each PSO  % 'allRunsOutput'：包含每次PSO运行结果的N元素结构体数组
%              run. The fields of this struct are:  % 该结构体的字段有：
%                 'fitVal': The fitness value.  % 'fitVal'：适应度值
%                 'qcCoefs': The coefficients [a1, a2, a3].  % 'qcCoefs'：[a1, a2, a3]系数
%                 'estSig': The estimated signal.  % 'estSig'：估计信号
%                 'totalFuncEvals': The total number of fitness  % 'totalFuncEvals'：适应度函数总评估次数
%                                   evaluations.  %
% 'bestRun': The best run.  % 'bestRun'：最佳运行编号
% 'bestFitness': best fitness from the best run.  % 'bestFitness'：最佳运行的适应度
% 'bestSig' : The signal estimated in the best run.  % 'bestSig'：最佳运行的估计信号
% 'bestQcCoefs' : [a1, a2, a3] found in the best run.  % 'bestQcCoefs'：最佳运行得到的[a1, a2, a3]

%Soumya D. Mohanty, May 2018  % Soumya D. Mohanty, 2018年5月

nSamples = length(inParams.dataX);

fHandle = @(x) crcbqcfitfunc(x,inParams);

nDim = 3;
outStruct = struct('bestLocation',[],...
                   'bestFitness', [],...
                   'totalFuncEvals',[]);
                    
outResults = struct('allRunsOutput',struct('fitVal', [],...
                                           'qcCoefs',zeros(1,3),...
                                           'estSig',zeros(1,nSamples),...
                                           'totalFuncEvals',[]),...
                    'bestRun',[],...
                    'bestFitness',[],...
                    'bestSig', zeros(1,nSamples),...
                    'bestQcCoefs',zeros(1,3));

%Allocate storage for outputs: results from all runs are stored
for lpruns = 1:nRuns
    outStruct(lpruns) = outStruct(1);
    outResults.allRunsOutput(lpruns) = outResults.allRunsOutput(1);
end
%Independent runs of PSO in parallel. Change 'parfor' to 'for' if the
%parallel computing toolbox is not available.
parfor lpruns = 1:nRuns
    %Reset random number generator for each worker
    rng(lpruns);
    outStruct(lpruns)=crcbpso(fHandle,nDim,psoParams);
end

%Prepare output
fitVal = zeros(1,nRuns);
for lpruns = 1:nRuns   
    fitVal(lpruns) = outStruct(lpruns).bestFitness;
    outResults.allRunsOutput(lpruns).fitVal = fitVal(lpruns);
    [~,qcCoefs] = fHandle(outStruct(lpruns).bestLocation);
    outResults.allRunsOutput(lpruns).qcCoefs = qcCoefs;
    estSig = crcbgenqcsig(inParams.dataX,1,qcCoefs);
    estAmp = inParams.dataY*estSig(:);
    estSig = estAmp*estSig;
    outResults.allRunsOutput(lpruns).estSig = estSig;
    outResults.allRunsOutput(lpruns).totalFuncEvals = outStruct(lpruns).totalFuncEvals;
end
%Find the best run
[~,bestRun] = min(fitVal(:));
outResults.bestRun = bestRun;
outResults.bestFitness = outResults.allRunsOutput(bestRun).fitVal;
outResults.bestSig = outResults.allRunsOutput(bestRun).estSig;
outResults.bestQcCoefs = outResults.allRunsOutput(bestRun).qcCoefs;

