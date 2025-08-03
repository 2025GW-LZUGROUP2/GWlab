# 二次调频信号分析与可视化

## 项目概述

本项目提供了一套用于生成、分析和可视化二次调频信号的MATLAB工具。二次调频信号是一种频率随时间呈非线性变化的信号，在雷达、声纳、通信和生物医学信号处理等领域有广泛应用。

项目包含优化的信号生成函数、全面的分析脚本和详细的文档，特别适合信号处理入门学习和教学演示。

## 文件结构

```
ChirpSignalOptimized/
├── src/                      # 源代码
│   ├── crcbgenqcsig.m        # 二次调频信号生成函数
│   └── testcrcbgenqcsig.m    # 信号分析与可视化脚本
├── docs/                     # 文档
│   ├── README.md             # 本文档
│   ├── theory.md             # 理论背景
│   ├── nyquist_frequency.md  # Nyquist频率解析
│   └── api_reference.md      # API参考文档
└── examples/                 # 示例
    ├── figures/              # 示例图像
    └── results.md            # 结果分析
```

## 快速开始

1. 确保已安装MATLAB（建议R2018b或更高版本）
2. 将项目文件夹添加到MATLAB路径
3. 运行示例脚本：

```matlab
cd('path/to/ChirpSignalOptimized/src');
testcrcbgenqcsig;
```

## 核心功能

- **信号生成**：创建具有可控时间-频率特性的二次调频信号
- **时域分析**：可视化信号的时域特性
- **频域分析**：使用FFT进行频谱分析，支持完整频谱和周期图
- **时频分析**：通过频谱图展示信号的时频特性

## 理论基础简介

二次调频信号的相位函数为时间的三次多项式：
$\phi(t) = a_1t + a_2t^2 + a_3t^3$

其瞬时频率为相位的时间导数：
$f(t) = \frac{1}{2\pi}\frac{d\phi(t)}{dt} = \frac{1}{2\pi}(a_1 + 2a_2t + 3a_3t^2)$

更多理论细节请参阅 [theory.md](theory.md)。

## Nyquist频率说明

本项目特别关注并澄清了Nyquist频率的两种常见定义：
1. 临界采样频率（$f_s = 2f_B$）
2. 采样率的一半（$f_s/2$）

详细解释请参阅 [nyquist_frequency.md](nyquist_frequency.md)。

## 使用示例

### 基本信号生成

```matlab
t = 0:0.001:1;  % 时间向量
A = 10;         % 信号幅度
phaseCoeff = [10, 3, 3];  % 相位参数 [a1, a2, a3]
signal = crcbgenqcsig(t, A, phaseCoeff);
plot(t, signal);
```

### 频域分析

```matlab
Fs = 1000;       % 采样频率
N = length(t);   % 样本数
Y = fft(signal); % 快速傅里叶变换
f = (0:(N/2))/N*Fs;  % 频率向量（仅正频率）
plot(f, abs(Y(1:N/2+1)));
```

## 参考文献

1. S. Kay, "Fundamentals of Statistical Signal Processing: Detection Theory", Prentice Hall, 1998.
2. L. Cohen, "Time-Frequency Analysis", Prentice Hall, 1995.
3. A. V. Oppenheim and R. W. Schafer, "Discrete-Time Signal Processing", Pearson, 2014.

## 贡献

欢迎提出改进建议和贡献代码。请提交issue或pull request。

## 许可

本项目采用MIT许可证。
