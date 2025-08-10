%% Test harness for CRCBPSO CRCBPSO测试工具
% The fitness function called is CRCBPSOTESTFUNC. 调用的适应度函数是CRCBPSOTESTFUNC
nDim = 20; %Dimensionality of the search space 搜索空间的维度
rmin = -10;% lower bound of search space coordinate 搜索空间坐标的下界
rmax = 10; %Upper bound of search space coordinate 搜索空间坐标的上界
ffparams = struct('rmin',rmin,...
                     'rmax',rmax ...
                  );
% Fitness function handle. 适应度函数句柄
fitFuncHandle = @(x) crcbpsotestfunc(x,ffparams);

%% Default PSO settings 默认PSO设置
disp('Default PSO settings');
disp(crcbpso());

%%
% Call PSO with default settings 使用默认设置调用PSO
disp('Calling PSO with default settings and no optional inputs')
rng('default')
tic;
psoOut1 = crcbpso(fitFuncHandle,nDim);
toc;
% Call PSO with default settings but return more information 使用默认设置调用PSO但返回更多信息
disp('Calling PSO with default settings and optional inputs')
rng('default')
tic;
psoOut1 = crcbpso(fitFuncHandle,nDim,[],2);
toc;
% Best standardized and real coordinates found. 找到的最佳标准化和实际坐标
stdCoord = psoOut1.bestLocation;
[~,realCoord] = fitFuncHandle(stdCoord);
disp([' Best location:',num2str(realCoord)]);
disp([' Best fitness:', num2str(psoOut1.bestFitness)]);

%%
% Override default PSO parameters 覆盖默认PSO参数
disp('Overriding default PSO parameters');
rng('default');
psoParams = struct();
psoParams.maxSteps = 30000; disp(['Changing maxSteps to:',num2str(psoParams.maxSteps)]);
psoParams.maxVelocity = 0.9; disp(['Changing maxVelocity to:',num2str(psoParams.maxVelocity)]);
tic;
psoOut2 = crcbpso(fitFuncHandle,nDim,psoParams,2);
toc;

%% Results 结果
figure('Name', '默认PSO设置收敛曲线');
plot(psoOut1.allBestFit);
xlabel('Iteration number');
ylabel('Global best fitness');
title('Default PSO settings');
figure('Name', '非默认PSO设置收敛曲线');
plot(psoOut2.allBestFit);
xlabel('Iteration number');
ylabel('Global best fitness');
title('Non-default PSO settings');
if nDim == 2
    %Plot the trajectory of the best particle 绘制最佳粒子的轨迹
    figure('Name', '最佳粒子轨迹');
    hold on;
    %Contour plot of the fitness function 适应度函数的等高线图
    %=======================
    %X and Y grids X和Y网格
    xGrid = linspace(rmin,rmax,500);
    yGrid = linspace(rmin,rmax,500);
    [X,Y] = meshgrid(xGrid,yGrid);
    %Standardize 标准化
    Xstd = (X-rmin)/(rmax - rmin);
    Ystd = (Y-rmin)/(rmax - rmin);
    %Get fitness values 获取适应度值
    fitVal4plot = fitFuncHandle([Xstd(:),Ystd(:)]);
    %Reshape array of fitness values 重塑适应度值数组
    fitVal4plot = reshape(fitVal4plot,size(X));
    contour((xGrid-rmin)/(rmax-rmin), (yGrid - rmin)/(rmax - rmin), fitVal4plot);
    %========================
    plot(psoOut2.allBestLoc(:,1),psoOut2.allBestLoc(:,2),'.-');
    title('Trajectory of the best particle');
    legend('适应度等高线', '最佳粒子轨迹', 'Location', 'best');
    figure('Name', '适应度函数三维图');
    title('Plot of fitness function');
    surf(X,Y,fitVal4plot); shading interp;
end
stdCoord = psoOut2.bestLocation;
[~,realCoord] = fitFuncHandle(stdCoord);
disp([' Best location:',num2str(realCoord)]);
disp([' Best fitness:', num2str(psoOut2.bestFitness)]);
