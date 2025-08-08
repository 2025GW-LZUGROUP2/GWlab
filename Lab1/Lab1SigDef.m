%% 本文件定义了会在Lab1中用到的信号，在Lab1Tasks.m中直接调用即可
% 创建信号表达式
%% Quadratic Chirp Signal
coeffNames_qc = {'a_1', 'a_2', 'a_3', 'A'};
syms(coeffNames_qc{:});
phi_qc = 2 * pi * (a_1 * t + a_2 * t ^ 2 + a_3 * t ^ 3);
sigExpr_qc = A * sin(phi_qc);
coeffValues_qc = [10, 3, 3, 10];
Sig_qc = Signal('Quadratic Chirp', timeVec, sigExpr_qc, ...
    t, coeffNames_qc, coeffValues_qc);
%% Linear Chirp Signal
coeffNames_lc = {'A', 'a0', 'a1', 'phi0'};
syms(coeffNames_lc{:});
phi_lc = 2 * pi * (a0 * t + a1 * t ^ 2) + phi0;
sigExpr_lc = A * sin(phi_lc);
coeffValues_lc = [10, 10, 3, 0.5 * pi];
Sig_lc = Signal('Linear Chirp', timeVec, sigExpr_lc, ...
    t, coeffNames_lc, coeffValues_lc);
%% Sinusoidal Signal
coeffNames_ss = {'A', 'a0', 'phi0'};
syms(coeffNames_ss{:});
phi_ss = 2 * pi * (a0 * t) + phi0;
sigExpr_ss = A * sin(phi_ss);
coeffValues_ss = [10, 10, 0.5 * pi];
Sig_ss = Signal('Sinusoidal Signal', timeVec, sigExpr_ss, ...
    t, coeffNames_ss, coeffValues_ss);
%% Frequency Modulated (FM) Sinusoid
coeffNames_FM = {'A', 'b', 'a0', 'a1'};
syms(coeffNames_FM{:});
phi_FM = 2 * pi * (a0 * t) +b*cos(2*pi*a1*t);
sigExpr_FM = A * sin(phi_FM);
coeffValues_FM = [10, 2, 3, 10];
Sig_FM = Signal('FM Signal', timeVec, sigExpr_FM, ...
    t, coeffNames_FM, coeffValues_FM);

%以下是非标准正弦类
%% Sine-Gaussian signal
coeffNames_sg = {'A', 't0', 'sigma', 'f0', 'phi0'};
syms(coeffNames_sg{:});
sigExpr_sg = A * exp(- (t - t0) ^ 2 / (2 * sigma ^ 2)) * sin(2 * pi * f0 * t + phi0);
coeffValues_sg = [10, 0.5, 0.5, 10, 0.5 * pi];
Sig_Sg = Signal('Sine-Gaussian', timeVec, sigExpr_sg, ...
    t, coeffNames_sg, coeffValues_sg);
%% Amplitude modulated (AM) Sinusoid
coeffNames_AM = {'A', 'a0', 'a1', 'phi0'};
syms(coeffNames_AM{:});
sigExpr_AM = A * cos(2 * pi * a1 * t) * sin(a0 * t + phi0);
coeffValues_AM = [10, 0.5, 3, 0.5 * pi];
Sig_AM = Signal('AM Signal', timeVec, sigExpr_AM, ...
    t, coeffNames_AM, coeffValues_AM);
%% AM-FM Sinusoid
coeffNames_AMFM = {'A','b', 'a0', 'a1'};
syms(coeffNames_AMFM{:});
sigExpr_AMFM = A * cos(2 * pi * a1 * t) * sin(2*pi*a0 * t + b*cos(2*pi*a1*t));
coeffValues_AMFM = [10, 0.5, 3, 0.5 * pi];
Sig_AMFM = Signal('AM-FM Sinusoid', timeVec, sigExpr_AMFM, ...
    t, coeffNames_AMFM, coeffValues_AMFM);