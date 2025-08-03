%% 基本参数设置
% 定义二次调频函数的参数
[a_1,a_2,a_3]=deal(10,5,8);
A=10;

sampFreq=100;
sampIntvl=1/sampFreq;
timeVec=0:sampIntvl:1;

% 生成调频信号
qcSig=gen_qcSig(timeVec,[a_1,a_2,a_3],A);
figure;
plot(timeVec,qcSig,"marker",".","MarkerSize",24)
