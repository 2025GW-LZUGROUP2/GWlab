%% 基本参数设置

t0=0;t1=1;% 定义要处理的时间区间
sampFreq=100;

% 定义二次调频函数的参数
[a_1,a_2,a_3]=deal(10,5,8);
A=10;
% 选择要处理的信号，改变gen_qcSig函数名即可
% （可选qcSig，SineGausSig，linearChirpSig或自定义函数diyfun）
diyfun=@(t) t^2+t;
[SigVec,FreqExpr]=gen_qcSig(timeVec,[a_1,a_2,a_3],A);
 Sig={SigVec,FreqExpr};
InstnFreqfun=@(t) subs(Sig{2},t);
% 猜测信号的频率宽，用最高瞬时频率
[maxpos,maxvalue]=fminbnd(@(t) -InstnFreqfun(t),t0,t1);
maxvalue=-maxvalue;%修正最大值，因为临时取了负号
NyqFreq=2*maxvalue;
sampFreq=5*NyqFreq;
sampIntvl=1/sampFreq;
timeVec=t0:sampIntvl:t1;

% 生成调频信号

figure;
plot(timeVec,Sig{1},"marker",".","MarkerSize",24);

