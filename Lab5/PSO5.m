% 采样设置
fs = 1024;
T = 1;
N = round(T * fs);
t = (0:N-1) / fs;

% fftfreq函数的实现
fftfreq = @(n, d) [0:floor((n-1)/2), -floor(n/2):-1] / (n * d);

% 多项式调制信号函数
func = @(t, A, a1, a2, a3) A * sin(2 * pi * (a1 * t + a2 * t.^2 + a3 * t.^3));

% 生成信号与噪声
A = 1.0; a1 = 20; a2 = 10; a3 = 10;
signal = func(t, A, a1, a2, a3);
noise = 3 * randn(1, N);  % 标准差为3的高斯白噪声
data = signal + noise;

% 时域图
figure;
plot(t, data, 'b', 'DisplayName', 'Data');
hold on;
plot(t, signal, 'r', 'LineWidth', 1.5, 'DisplayName', 'Signal');
xlabel('Time (sec)');
ylabel('Amplitude');
title('Signal + Noise');
legend('Location', 'best');
grid on;

% 频域图（FFT）
datFFT = abs(fft(data));
sigFFT = abs(fft(signal));
freqs = fftfreq(N, 1/fs);
kNyq = floor(N/2);
posFreq = freqs(1:kNyq);

figure;
plot(posFreq, datFFT(1:kNyq), 'b', 'DisplayName', 'Data FFT');
hold on;
plot(posFreq, sigFFT(1:kNyq), 'r', 'LineWidth', 1.5, 'DisplayName', 'Signal FFT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FFT Spectrum');
legend('Location', 'best');
grid on;

% 时频图（Spectrogram）
[~, f, tt, ps] = spectrogram(data, hamming(64), 60, [], fs);
figure;
surf(tt, f, 10*log10(abs(ps)), 'EdgeColor', 'none');
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
zlabel('Magnitude (dB)');
title('Spectrogram');
colorbar;
view(0, 90);

% 另一种显示方式 - 使用imagesc
figure;
imagesc(tt, f, 10*log10(abs(ps)));
axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
title('Spectrogram (imagesc)');
colorbar;
%1.生成采样时间为1秒、采样频率为1024Hz的信号
%2.创建一个三次多项式调制的正弦信号
%3.添加高斯白噪声（标准差为3）
%4.绘制时域图，显示原始信号和带噪声的信号
%5.计算并绘制FFT频谱图
%6.计算并绘制时频图（spectrogram）