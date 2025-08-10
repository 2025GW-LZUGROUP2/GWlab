function GLRTval= glrtqcsig(DataVec,TimeVec,PSDvec4pos,SigVec)
% glrtqcsig - Calculate the GLRT for a quadratic chirp signal with unknown amplitude
% glrtqcsig - 计算仅幅度未知的二次调频信号的广义似然比检验（GLRT）
%
% Syntax:
%   GLRTval = glrtqcsig(DataVec, TimeVec, PSDvec4pos, SigVec)
%
% Description:
%   This function calculates the Generalized Likelihood Ratio Test (GLRT)
%   for a quadratic chirp signal with unknown amplitude. The GLRT value
%   is computed based on the input data vector, time vector, PSD vector,
%   and the signal vector directly provided as input.
%   此函数计算仅幅度未知的二次调频信号的广义似然比检验（GLRT）。
%   GLRT 值基于输入数据向量、时间向量、PSD 向量和直接提供的信号向量计算。
%
% Inputs:
%   DataVec     - Data vector [double array]
%                 数据向量 [double 数组]
%   TimeVec     - Time samples vector [double array]
%                 时间采样点向量 [double 数组]
%   PSDvec4pos  - PSD vector for positive DFT frequencies [double array]
%                 正 DFT 频率的 PSD 向量 [double 数组]
%   SigVec      - Signal vector [double array]
%                 信号向量 [double 数组]
%
% Outputs:
%   GLRTval     - GLRT value [double scalar]
%                 GLRT 值 [double 数字]
%
% Example:
%   DataVec = randn(1, 1000);
%   TimeVec = linspace(0, 1, 1000);
%   PSDvec4pos = ones(1, 500);
%   SigVec = sin(2 * pi * TimeVec);
%   GLRTval = glrtqcsig(DataVec, TimeVec, PSDvec4pos, SigVec);
%
% See also:
%   normSig4PSD, innerProdPSD
%
% Author:
%   [Your Name], [Date]
%   [Your Name], [日期]


%calculates the GLRT for a quadratic chirp signal with unknown amplitude
% 当仅幅度未知时，记算二次调频信号的广义似然比检验（GLRT）。
% GLRT=glrtqcsig(DataVec,TimeVec,PSDvec4pos,coefVec)

%Inputs:
% DataVec:Data vector
% TimeVec:Time samples vector 
% PSDvec4pos:PSD vector (for positive DFT frequencies)
% coefVec:vector of input parameters e.g. [a1 a2 a3]

%Output:
% GLRTval:GLRT value

nSamples=length(DataVec);
if nSamples~=length(TimeVec)
error('DataVec和TimeVec的长度不匹配')
end
TimeLen=TimeVec(end)-TimeVec(1);
sampFreq=(nSamples-1)/TimeLen;


[templateVec,~] = normSig4PSD(SigVec,sampFreq,PSDvec4pos,1);%归一化到SNR为1
llr=innerProdPSD(DataVec,templateVec,sampFreq,PSDvec4pos);
GLRTval=llr^2;%GLRT是其平方
end