%% 本文件定义了会在Lab1中用到的信号，在Lab1Tasks.m中直接调用即可
% This file defines the signals used in Lab1, which can be directly called in Lab1Tasks.m

%% Quadratic Chirp Signal
% 定义二次调频信号的参数和表达式
% Define parameters and expression for the quadratic chirp signal
coeffNames_qc = {'a_1', 'a_2', 'a_3', 'A'}; % 参数名称
syms(coeffNames_qc{:}); % 定义符号变量
phi_qc = 2 * pi * (a_1 * t + a_2 * t ^ 2 + a_3 * t ^ 3); % 相位表达式
sigExpr_qc = A * sin(phi_qc); % 信号表达式
coeffValues_qc = [10, 3, 3, 10]; % 参数值
Sig_qc = Signal('Quadratic Chirp', timeVec, sigExpr_qc, ...
    t, coeffNames_qc, coeffValues_qc); % 创建信号对象

%% Linear Chirp Signal
% 定义线性调频信号的参数和表达式
% Define parameters and expression for the linear chirp signal
coeffNames_lc = {'A', 'a0', 'a1', 'phi0'}; % 参数名称
syms(coeffNames_lc{:}); % 定义符号变量
phi_lc = 2 * pi * (a0 * t + a1 * t ^ 2) + phi0; % 相位表达式
sigExpr_lc = A * sin(phi_lc); % 信号表达式
coeffValues_lc = [10, 10, 3, 0.5 * pi]; % 参数值
Sig_lc = Signal('Linear Chirp', timeVec, sigExpr_lc, ...
    t, coeffNames_lc, coeffValues_lc); % 创建信号对象

%% Sinusoidal Signal
% 定义正弦信号的参数和表达式
% Define parameters and expression for the sinusoidal signal
coeffNames_ss = {'A', 'a0', 'phi0'}; % 参数名称
syms(coeffNames_ss{:}); % 定义符号变量
phi_ss = 2 * pi * (a0 * t) + phi0; % 相位表达式
sigExpr_ss = A * sin(phi_ss); % 信号表达式
coeffValues_ss = [10, 10, 0.5 * pi]; % 参数值
Sig_ss = Signal('Sinusoidal Signal', timeVec, sigExpr_ss, ...
    t, coeffNames_ss, coeffValues_ss); % 创建信号对象

%% Frequency Modulated (FM) Sinusoid
% 定义频率调制正弦信号的参数和表达式
% Define parameters and expression for the frequency modulated sinusoid
coeffNames_FM = {'A', 'b', 'a0', 'a1'}; % 参数名称
syms(coeffNames_FM{:}); % 定义符号变量
phi_FM = 2 * pi * (a0 * t) + b * cos(2 * pi * a1 * t); % 相位表达式
sigExpr_FM = A * sin(phi_FM); % 信号表达式
coeffValues_FM = [10, 2, 3, 10]; % 参数值
Sig_FM = Signal('FM Signal', timeVec, sigExpr_FM, ...
    t, coeffNames_FM, coeffValues_FM); % 创建信号对象

% 以下是非标准正弦类信号
% The following are non-standard sinusoidal signals

%% Sine-Gaussian signal
% 定义正弦-高斯信号的参数和表达式
% Define parameters and expression for the sine-Gaussian signal
coeffNames_sg = {'A', 't0', 'sigma', 'f0', 'phi0'}; % 参数名称
syms(coeffNames_sg{:}); % 定义符号变量
sigExpr_sg = A * exp(- (t - t0) ^ 2 / (2 * sigma ^ 2)) * sin(2 * pi * f0 * t + phi0); % 信号表达式
coeffValues_sg = [10, 0.5, 0.5, 10, 0.5 * pi]; % 参数值
Sig_Sg = Signal('Sine-Gaussian', timeVec, sigExpr_sg, ...
    t, coeffNames_sg, coeffValues_sg); % 创建信号对象

%% Amplitude modulated (AM) Sinusoid
% 定义幅度调制正弦信号的参数和表达式
% Define parameters and expression for the amplitude modulated sinusoid
coeffNames_AM = {'A', 'a0', 'a1', 'phi0'}; % 参数名称
syms(coeffNames_AM{:}); % 定义符号变量
sigExpr_AM = A * cos(2 * pi * a1 * t) * sin(a0 * t + phi0); % 信号表达式
coeffValues_AM = [10, 0.5, 3, 0.5 * pi]; % 参数值
Sig_AM = Signal('AM Signal', timeVec, sigExpr_AM, ...
    t, coeffNames_AM, coeffValues_AM); % 创建信号对象

%% AM-FM Sinusoid
% 定义幅度调制-频率调制正弦信号的参数和表达式
% Define parameters and expression for the amplitude-frequency modulated sinusoid
coeffNames_AMFM = {'A', 'b', 'a0', 'a1'}; % 参数名称
syms(coeffNames_AMFM{:}); % 定义符号变量
sigExpr_AMFM = A * cos(2 * pi * a1 * t) * sin(2 * pi * a0 * t + b * cos(2 * pi * a1 * t)); % 信号表达式
coeffValues_AMFM = [10, 0.5, 3, 0.5 * pi]; % 参数值
Sig_AMFM = Signal('AM-FM Sinusoid', timeVec, sigExpr_AMFM, ...
    t, coeffNames_AMFM, coeffValues_AMFM); % 创建信号对象