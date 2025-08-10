%% 保存和读取数据
% 保存数据为 txt 文件
writematrix(data', "generated_signal.txt");

% 从 txt 文件读取数据
loaded_data = readmatrix("generated_signal.txt");

% 确保时间轴一致
t_loaded = (0:length(loaded_data)-1) / fs;

% 画图：时域
figure;
plot(t_loaded, loaded_data, 'b-', 'LineWidth', 1.2, 'DisplayName', 'Loaded Data from TXT');
xlabel('Time (sec)');
ylabel('Amplitude');
title('Loaded Signal from TXT');
legend('Location', 'best');
grid on;

% 画图：FFT 频谱
loadedFFT = abs(fft(loaded_data));
figure;
plot(posFreq, loadedFFT(1:kNyq), 'b-', 'LineWidth', 1.2, 'DisplayName', 'Loaded Data FFT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FFT of Loaded Signal');
legend('Location', 'best');
grid on;

%% 验证数据一致性
% 检查原始数据和加载数据是否一致
fprintf('原始数据和加载数据是否一致: %d\n', isequal(data, loaded_data'));
fprintf('数据长度: %d\n', length(loaded_data));
%将信号数据保存到文本文件，然后重新加载并验证数据完整性，最后绘制加载数据的时域图和频域图