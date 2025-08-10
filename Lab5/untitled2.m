/ ... existing code ...
%% 9. 尝试手动优化参数以验证适应度函数
fprintf('\n=== 手动参数验证 ===\n');
% 测试几个接近真实值的参数组合
test_params = [
    50, 30, 10;   % 真实参数
    45, 27, 9;    % 稍微偏移
    55, 33, 11;   % 稍微偏移
    48, 29, 10;   % 更接近
    52, 31, 10];  % 更接近

% 创建测试用的inParams副本
test_inParams = inParams;

for i = 1:size(test_params, 1)
    % 计算适应度值
    [~, fitness] = crcbqcfitfunc(test_params(i, :), test_inParams);
    
    % 生成信号
    test_signal_normalized = crcbgenqcsig(test_inParams.dataX, 1, test_params(i, :));
    
    % 修复矩阵乘法维度问题 - 使用点积计算幅度
    % 确保两个向量维度匹配并计算内积
    if size(test_inParams.dataY, 2) > size(test_inParams.dataY, 1)
        data_vec = test_inParams.dataY;  % 行向量
    else
        data_vec = test_inParams.dataY';  % 转换为行向量
    end
    
    if size(test_signal_normalized, 2) > size(test_signal_normalized, 1)
        signal_vec = test_signal_normalized;  % 行向量
    else
        signal_vec = test_signal_normalized';  % 转换为行向量
    end
    
    % 确保两个向量长度相同
    min_len = min(length(data_vec), length(signal_vec));
    data_vec = data_vec(1:min_len);
    signal_vec = signal_vec(1:min_len);
    
    % 计算内积
    test_amp = sum(data_vec .* signal_vec);  % 使用点乘
    
    test_signal_normalized = test_amp * test_signal_normalized;
    
    % 反归一化
    test_signal = test_signal_normalized * analysisData_std + analysisData_mean;
    
    % 计算SNR
    test_signal_energy = sum(test_signal.^2);
    test_residual = test_inParams.dataY * analysisData_std + analysisData_mean - test_signal;
    test_noise_energy = sum(test_residual.^2);
    
    if test_noise_energy > 1e-10
        test_snr = 10 * log10(test_signal_energy / test_noise_energy);
    else
        test_snr = 50;
    end
    
    fprintf('测试参数 [%2d, %2d, %2d]: 适应度 = %8.6f, SNR = %6.2f dB\n', ...
        test_params(i, 1), test_params(i, 2), test_params(i, 3), fitness, test_snr);
end
// ... existing code ...