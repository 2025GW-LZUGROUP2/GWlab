function glrt_val = glrtqcsig_white(timeVec, dataVec, Fs, Ppos, qcCoefs)
%GLRTQCSIG_WHITE  先白化后做 GLRT（sin 单模板，未知幅度；GLRT=LLR^2）
% 1) data 白化；2) 模板生成并白化；3) 使用欧氏内积计算 LLR；4) 返回 LLR^2

timeVec = timeVec(:).'; 
dataVec = dataVec(:).';

% 生成模板（只用 sin）
a1 = qcCoefs(1); a2 = qcCoefs(2); a3 = qcCoefs(3);
phi = a1*timeVec + a2*(timeVec.^2) + a3*(timeVec.^3);
s1  = sin(2*pi*phi);

% 白化
xw  = whiten_fft(dataVec, Ppos, Fs);
sw  = whiten_fft(s1,      Ppos, Fs);

% 单位化模板（白化后在欧氏意义下单位能量）
sw = sw / norm(sw);

% LLR 与 GLRT
llr      = real(xw * sw.');   % 欧氏内积
glrt_val = llr^2;
end
