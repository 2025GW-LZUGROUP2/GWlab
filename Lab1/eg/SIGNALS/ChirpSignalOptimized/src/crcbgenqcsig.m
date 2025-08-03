function sigVec = crcbgenqcsig(timeVec, A, phaseCoeff)
%CRCBGENQCSIG 生成二次调频(Quadratic Chirp)信号
%   SIGVEC = CRCBGENQCSIG(TIMEVEC, A, PHASECOEFF) 生成一个二次调频信号，
%   其相位是时间的三次多项式。
%
%   输入参数:
%   ---------
%   TIMEVEC    - 时间采样点向量 [t1, t2, ..., tN]
%   A          - 信号幅度（常数）
%   PHASECOEFF - 相位系数向量 [a1, a2, a3]，对应相位函数：
%                φ(t) = a1*t + a2*t^2 + a3*t^3
%                单位分别为：弧度/秒，弧度/秒^2，弧度/秒^3
%
%   输出参数:
%   ---------
%   SIGVEC     - 二次调频信号：s(t) = A*cos(φ(t))
%
%   相关概念:
%   ---------
%   瞬时频率计算为 f(t) = (1/2π)*dφ(t)/dt = (1/2π)*(a1 + 2*a2*t + 3*a3*t^2)
%
%   示例:
%   ------
%   % 生成1秒长的二次调频信号，采样频率为1000Hz
%   t = 0:0.001:1;
%   A = 10;
%   phaseCoeff = [10, 3, 3]; % [a1, a2, a3]
%   sig = crcbgenqcsig(t, A, phaseCoeff);
%   plot(t, sig);
%
%   参考文献:
%   ---------
%   1. S. Kay, "Fundamentals of Statistical Signal Processing: Detection Theory"
%   2. L. Cohen, "Time-Frequency Analysis"
%
%   作者: [您的姓名]
%   版本: 1.0
%   日期: [当前日期]

% 输入参数验证
validateattributes(timeVec, {'numeric'}, {'vector', 'real'}, 'crcbgenqcsig', 'timeVec');
validateattributes(A, {'numeric'}, {'scalar', 'real', 'nonempty'}, 'crcbgenqcsig', 'A');
validateattributes(phaseCoeff, {'numeric'}, {'vector', 'real', 'numel', 3}, 'crcbgenqcsig', 'phaseCoeff');

% 提取相位参数
a1 = phaseCoeff(1);
a2 = phaseCoeff(2);
a3 = phaseCoeff(3);

% 计算相位函数: φ(t) = a1*t + a2*t^2 + a3*t^3
phaseVals = a1*timeVec + a2*timeVec.^2 + a3*timeVec.^3;

% 生成余弦信号: s(t) = A*cos(φ(t))
sigVec = A*cos(phaseVals);

% 输出信息（可选，取消注释以启用）
% fprintf('生成二次调频信号:\n');
% fprintf('- 时间范围: [%.3f, %.3f] 秒\n', min(timeVec), max(timeVec));
% fprintf('- 样本数: %d\n', length(timeVec));
% fprintf('- 相位参数: a1=%.2f, a2=%.2f, a3=%.2f\n', a1, a2, a3);

end
