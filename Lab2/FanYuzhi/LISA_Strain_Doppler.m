clearvars; close all; clc;

%% Plot strain

% 定义球坐标系位置
theta = pi / 6;   % 极角
phi = 0; % 方位角
psi = 0; % 极化角


% Detector tensors of LISA
[Phi, E, Sp1path, Sp2path, Sp3path, ~, ~, ~, R] = simu_LISA_orbits();
Sp1 = Sp1path(:,1) ; % *10^7 km
Sp2 = Sp2path(:,1) ;
Sp3 = Sp3path(:,1) ;

% 定义时间范围和 h_+(t), h_×(t) 函数
A = 1; % 幅度
B = A/2;
f0 = 0.001; % 频率：1 mHz (周期 1000 秒)
phi0 = pi / 2; % 相位

time = linspace(0, 10800, 1000); % 一天（86400秒），1000帧
hp = SinSigGen(time, A, f0, 0);
hc = SinSigGen(time, B, f0, phi0);

n_wave = - [sin(theta)*cos(phi), sin(theta)*sin(phi), cos(theta)];
x_d = (Sp1 + Sp2 + Sp3)./3;
c = 0.03; % *10^7 km/s
time_ret = time - (n_wave*x_d) / c;
hp_dop = SinSigGen(time_ret, A, f0, 0);
hc_dop = SinSigGen(time_ret, B, f0, phi0);



% 计算臂向量 n1,n2,n3（仅取第一天的数据）
n1 = Sp2 - Sp3;
n2 = Sp3 - Sp1;
n3 = Sp1 - Sp2;

% 仅考虑第一个探测器张量
DetTensor1 = (n1*n1' - n2*n2') ./ 2;
%DetTensor2 = (n1*n1' + n2*n2' - 2*n3*n3') ./ (2*sqrt(3));

% 向量化计算整张球面的 F_+, F_x（仅计算一次）
[Fp1, Fc1] = FpFcinDetFrame(theta, phi, psi, DetTensor1);
%[Fp2, Fc2] = FpFcinDetFrame(theta, phi, psi, DetTensor2);

strain1 = Fp1 * hp + Fc1 * hc;
strain1_dop = Fp1 * hp_dop + Fc1 * hc_dop;
%strain2 = Fp2 * hp + Fc2 * hc;

% 准备绘图
figure('Color', 'w', 'Name', 'Toy LISA response');

plot(time, strain1,'b')
hold on;
plot(time, strain1_dop,'r')


%% Plot periodogram

nSamples = length(time);
%Length of data 
dataLen = time(end)-time(1);
%DFT sample corresponding to Nyquist frequency
kNyq = floor(nSamples/2)+1;
% Positive Fourier frequencies
posFreq = (0:(kNyq-1))*(1/dataLen);

% FFT of signal
FFT_hp = fft(hp);
FFT_strain1 = fft(strain1);
FFT_strain1_dop = fft(strain1_dop);

% Discard negative frequencies
FFT_hp = FFT_hp(1:kNyq);
FFT_strain1 = FFT_strain1(1:kNyq);
FFT_strain1_dop = FFT_strain1_dop(1:kNyq);

figure('Color', 'w', 'Name', 'Periodogram');
plot(posFreq,abs(FFT_hp),'k');
hold on;
plot(posFreq,abs(FFT_strain1),'b');
plot(posFreq,abs(FFT_strain1_dop),'r');
xlabel('Frequency (Hz)');
ylabel('|FFT|');
title('Periodogram');


