function GLRTval= glrtqcsig(DataVec,TimeVec,PSDvec4pos,SigNow)
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
SigVec=SigNow.SigVec;
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