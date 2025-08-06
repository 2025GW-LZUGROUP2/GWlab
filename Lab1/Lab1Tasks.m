clc;clear;

%% 基本参数设置

timeInterval=[0,1];
t0=timeInterval(1);t1=timeInterval(2);% 定义要处理的时间区间
% 定义二次调频函数的参数
syms t A a_1 a_2 a_3;
sigExpr = A*sin(2*pi*(a_1*t + a_2*t^2 + a_3*t^3));% 创建信号表达式
coeffNames = {'a_1', 'a_2', 'a_3', 'A'};% 定义系数名称和值
coeffValues = [1, 0.5, 0.1, 2];

qcSig=Signal('QuadraticChirp',[],sigExpr,coeffNames,coeffValues);

[a_1,a_2,a_3]=deal(10,5,8);
A=10;

FreqBW=ExactEstmFreqBW(qcSig.SigExpr,t, timeInterval);
NyqFreq=2*FreqBW;
sampFreq=5*NyqFreq;
sampIntvl=1/sampFreq;
timeVec=t0:sampIntvl:t1;

% 生成调频信号

figure;
plot(timeVec,Sig{1},"marker",".","MarkerSize",24);

