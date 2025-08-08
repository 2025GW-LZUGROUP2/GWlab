clc;clear;
% 定义符号变量
syms  t A a_1 a_2 a_3 ;

% 创建信号表达式
sigExpr = A*sin(2*pi*(a_1*t + a_2*t^2 + a_3*t^3));

% 定义系数名称和值
coeffNames = {'a_1', 'a_2', 'a_3', 'A'};
coeffValues = [1, 0.5, 0.1, 2];

% 定义时间向量
timeVec = 0:0.05:1;

% 创建信号对象
signalObj = Signal('QuadraticChirp', timeVec,sigExpr, t,coeffNames, coeffValues );

% 绘制信号
plot(signalObj.timeVec, signalObj.SigVec);
title(signalObj.name);
xlabel('Time');
ylabel('Amplitude');