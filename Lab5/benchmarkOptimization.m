function benchmarkOptimization()
% 使用crcbpso算法优化基准测试函数
% 尝试不同的迭代次数和运行次数来找到全局最小值

% 清除工作空间
clear; clc; close all;

% 定义测试参数
nDim = 10;  % 问题维度
funcTypes = {'sphere', 'rastrigin', 'rosenbrock', 'griewank'};  % 测试函数类型

% 定义不同迭代次数和运行次数的组合
maxStepsList = [100, 500, 1000];  % 不同迭代次数
runCounts = [5, 10, 20];  % 不同运行次数

% 定义PSO参数
psoParams = struct();
psoParams.popSize = 40;
psoParams.c1 = 2;
psoParams.c2 = 2;
psoParams.maxVelocity = 0.5;
psoParams.startInertia = 0.9;
psoParams.endInertia = 0.4;
psoParams.boundaryCond = '';
psoParams.nbrhdSz = 3;

% 存储结果
results = struct();

% 对每种测试函数进行优化
for f = 1:length(funcTypes)
    funcType = funcTypes{f};
    fprintf('正在测试函数: %s\n', funcType);
    
    % 定义函数参数
    fitFuncParams = struct('funcType', funcType, ...
                           'rmin', -5*ones(1,nDim), ...
                           'rmax', 5*ones(1,nDim));
    
    % 创建适应度函数句柄
    fitFuncHandle = @(x) benchmarkFitnessFunction(x, fitFuncParams);
    
    % 存储当前函数的结果
    results.(funcType) = struct();
    
    % 对不同的迭代次数进行测试
    for s = 1:length(maxStepsList)
        maxSteps = maxStepsList(s);
        fprintf('  迭代次数: %d\n', maxSteps);
        
        % 更新PSO参数
        psoParams.maxSteps = maxSteps;
        psoParams.endInertiaIter = maxSteps;
        
        % 对不同的运行次数进行测试
        for r = 1:length(runCounts)
            runCount = runCounts(r);
            fprintf('    运行次数: %d\n', runCount);
            
            % 存储多次运行的结果
            bestFitnessValues = zeros(runCount, 1);
            bestLocations = zeros(runCount, nDim);
            totalFuncEvals = zeros(runCount, 1);
            
            % 多次运行算法
            for run = 1:runCount
                % 运行PSO算法
                psoOut = crcbpso(fitFuncHandle, nDim, psoParams);
                
                % 存储结果
                bestFitnessValues(run) = psoOut.bestFitness;
                bestLocations(run, :) = psoOut.bestLocation;
                totalFuncEvals(run) = psoOut.totalFuncEvals;
                
                fprintf('      运行 %d: 最佳适应度 = %.6f, 函数评估次数 = %d\n', ...
                        run, psoOut.bestFitness, psoOut.totalFuncEvals);
            end
            
            % 计算统计信息
            meanFitness = mean(bestFitnessValues);
            stdFitness = std(bestFitnessValues);
            minFitness = min(bestFitnessValues);
            maxFitness = max(bestFitnessValues);
            meanEvals = mean(totalFuncEvals);
            
            % 存储结果
            results.(funcType).(sprintf('steps_%d_runs_%d', maxSteps, runCount)) = struct(...
                'bestFitnessValues', bestFitnessValues, ...
                'bestLocations', bestLocations, ...
                'totalFuncEvals', totalFuncEvals, ...
                'meanFitness', meanFitness, ...
                'stdFitness', stdFitness, ...
                'minFitness', minFitness, ...
                'maxFitness', maxFitness, ...
                'meanEvals', meanEvals);
            
            fprintf('      统计结果: 平均=%.6f, 标准差=%.6f, 最小=%.6f, 最大=%.6f\n', ...
                    meanFitness, stdFitness, minFitness, maxFitness);
        end
    end
end

% 显示最终结果汇总
fprintf('\n=== 最终结果汇总 ===\n');
for f = 1:length(funcTypes)
    funcType = funcTypes{f};
    fprintf('\n函数: %s\n', funcType);
    
    % 找到该函数的最佳结果
    bestResult = inf;
    bestConfig = '';
    
    fieldNames = fieldnames(results.(funcType));
    for field = 1:length(fieldNames)
        fieldName = fieldNames{field};
        minVal = results.(funcType).(fieldName).minFitness;
        
        if minVal < bestResult
            bestResult = minVal;
            bestConfig = fieldName;
        end
    end
    
    fprintf('  最佳配置: %s\n', bestConfig);
    fprintf('  最佳适应度值: %.6f\n', bestResult);
end

% 可视化结果
figure;
for f = 1:length(funcTypes)
    funcType = funcTypes{f};
    
    subplot(2, 2, f);
    
    % 绘制不同配置下的最小适应度值
    fieldNames = fieldnames(results.(funcType));
    minValues = zeros(length(fieldNames), 1);
    
    for field = 1:length(fieldNames)
        minValues(field) = results.(funcType).(fieldNames{field}).minFitness;
    end
    
    bar(minValues);
    title(sprintf('函数 %s 的最小适应度值', funcType));
    ylabel('最小适应度值');
    xticklabels({});
    grid on;
end

sgtitle('不同函数和配置下的优化结果比较');
end
%实现了多种常用的基准测试函数：
%Sphere函数：简单的二次函数，全局最小值在原点
%Rastrigin函数：具有许多局部极小值的多模态函数
%Rosenbrock函数：非凸函数，全局最小值在一条弯曲的谷中
%Griewank函数：高度非线性且具有大量局部极小值