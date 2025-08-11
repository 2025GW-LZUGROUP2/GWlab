function snr = matched_filter_snr(template, data, sampFreq, psd)
%MATCHED_FILTER_SNR 计算匹配滤波信噪比
%
%   输入参数：
%   template: 模板信号
%   data: 数据
%   sampFreq: 采样频率 (Hz)
%   psd: 功率谱密度
%
%   输出参数：
%   snr: 匹配滤波信噪比

% 确保所有输入都是列向量
template = template(:);
data = data(:);
psd = psd(:);

% 计算模板的傅里叶变换
template_fft = fft(template);
% 计算数据的傅里叶变换
data_fft = fft(data);

% 频率向量
N = length(data);
delta_f = sampFreq/N;

% 计算匹配滤波
integrand = (data_fft .* conj(template_fft)) ./ psd;
integral_val = sum(integrand) * delta_f;

% 计算归一化因子
norm_factor_integrand = (abs(template_fft).^2) ./ psd;
norm_factor_integral = sum(norm_factor_integrand) * delta_f;

% 计算信噪比
snr = abs(4 * (1/N) * integral_val) / sqrt(norm_factor_integral);
end
