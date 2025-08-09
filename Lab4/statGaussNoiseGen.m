
function SGN_with_PSD = statGaussNoiseGen(nSamples, PSDm, filtOrder, sampFreq)
%STATGAUSSNOISEGEN  生成具有指定功率谱密度的平稳高斯噪声
%   SGN_with_PSD = statGaussNoiseGen(nSamples, PSDm, filtOrder, sampFreq)
%
%   输入参数：
%       nSamples   - 输出噪声的样本点数（正整数）
%       PSDm       - 功率谱密度矩阵，第一列为psd所对应的频率，第二列为PSD值
%       filtOrder  - FIR滤波器阶数（正整数）
%       sampFreq   - 采样频率（单位：Hz）
%
%   输出参数：
%       SGN_with_PSD - 具有指定功率谱密度的平稳高斯噪声序列（行向量）
%
%   说明：
%       本函数通过FIR滤波器对白噪声进行滤波，生成具有给定功率谱密度的平稳高斯噪声。
%       PSDm的第一列为归一化频率（0~1），第二列为对应的功率谱密度值。
%       归一化频率=实际频率/（采样频率/2）。
%
%   示例：
%       PSDm = [0 1; 0.5 0.5; 1 0.1];
%       y = statGaussNoiseGen(1000, PSDm, 128, 1000);
%
%   作者：wty
%   日期：2025-08-09
%   版本：1.0
%y(t)-output x(t)-input
%F[y]=T(f)F[x]
%PSD[y]=F[Cov[y]] prop y^2
%S_output=T^2 S_input
%Transfer function T(f)=sqrt(S_Target)
%so S_output=
psdFreqVec=PSDm(:,1);
sqrtPSD=sqrt(PSDm(:,2));
% rng('default'); %注释本行，则噪声种子不固定
WGNoise=randn(1,nSamples);%White Gaussian Noise,input the filter
b=fir2(filtOrder,psdFreqVec/(sampFreq/2),sqrtPSD);%filt系数
SGN_with_PSD=sqrt(sampFreq)*fftfilt(b,WGNoise);%乘sqrt(sampFreq)是为了归一化
%具体如下
%S_output=T^2 S_input
%S_input因为是标准白高斯噪声，S_input是一个窗函数，自变量范围在-fs/2,fs/2，其面积是sigma^2=1，
%所以S_input=1/fs (-fs/2<f<fs/2)
%S_output=T^2 1/fs
%可是我想要的S_output只是T^2=S_Target，多除了一个fs，所以对于S要乘一个fs
%S prop y^2，对于y就是乘sqrt(fs)
end