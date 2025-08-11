【批次1处理结果：第1-10页图片内容】

### 第1页内容
"Lab topic 3" [实验主题3]

### 第2页内容
#### Pseudo-random numbers
- "Homework reading: Find an online source to understand how random numbers are generated on a computer" [作业阅读：找到一个在线资源以了解计算机上随机数是如何生成的]
- "Example: https://en.wikipedia.org/wiki/Pseudorandom_number_generator" [示例：https://en.wikipedia.org/wiki/Pseudorandom_number_generator]

### 第3页内容
#### Generating WGN
- "Read the help for the randn function in Matlab and generate a realization of WGN with 10,000 samples and :" [阅读Matlab中randn函数的帮助文档，并生成具有10,000个样本的白噪声（WGN）实现，参数如下：]
  - "$\mu = 0, \sigma = 1$" [均值μ=0，标准差σ=1]
  - "$\mu = 0, \sigma = 2$" [均值μ=0，标准差σ=2]
  - "$\mu = 0, \sigma^2 = 2$" [均值μ=0，方差σ²=2]
  - "$\mu = 2, \sigma^2 = 2$" [均值μ=2，方差σ²=2]
- "Learn to use the histogram function of Matlab to make a histogram of each realization" [学习使用Matlab的histogram函数为每个实现绘制直方图]
- "Obtain the sample mean and standard deviations for each realization" [获取每个实现的样本均值和标准差]
  - "Matlab: mean and std" [Matlab函数：mean和std]

### 第4页内容
#### Challenge exercise
- "Using DATASCIENCE_COURSE / NOISE / bivarnorm.mlx as a model, write a code to generate trials values from a trivariate Normal distribution" [以DATASCIENCE_COURSE / NOISE / bivarnorm.mlx为模板，编写代码从三元正态分布生成试验值]
- "Hint:" [提示：]
  - "Use a linear combination $A \begin{pmatrix} X_1 \\ X_2 \\ X_3 \end{pmatrix}$ where $X_1, X_2, X_3$ are independent Normal random variables." [使用线性组合 $A \begin{pmatrix} X_1 \\ X_2 \\ X_3 \end{pmatrix}$，其中 $X_1, X_2, X_3$ 是独立的正态随机变量]
  - "Given a desired covariance matrix $C$, what should be $A$?" [给定期望的协方差矩阵 $C$，矩阵 $A$ 应如何确定？]

### 第5页内容
"Coloring and whitening" [着色与白化]

### 第6页内容
#### Learning objectives
- "Generate colored Gaussian noise using the Weiner-Khinchin theorem" [使用维纳 - 辛钦定理生成有色高斯噪声]
- "Estimate Power Spectral Density using Welch’s method" [使用Welch方法估计功率谱密度]
- "Learn how to whiten given data" [学习如何对白化给定数据]

### 第7页内容
#### Colored Gaussian Noise
- "See NOISE/colGaussNoiseDemo.m." [查看NOISE/colGaussNoiseDemo.m文件]
- "In this script, we use the Wiener-Khinchin theorem
$S_{out}(f) = S_{in}(f)|T(f)|^2$
with
$S_{in}(f) = const.$ (White noise)
and a filter with transfer function
$T(f) = \sqrt{S_{out}(f)}$
to generate colored noise having a PSD that approximates a target PSD" [在该脚本中，我们使用维纳 - 辛钦定理
$S_{out}(f) = S_{in}(f)|T(f)|^2$
其中
$S_{in}(f) = const.$（白噪声）
以及一个传递函数为
$T(f) = \sqrt{S_{out}(f)}$
的滤波器，来生成功率谱密度（PSD）近似于目标PSD的有色噪声]
- "The target PSD is
$S_{out}(f) = \begin{cases} (f - 100)(300 - f), & f \in [100, 300] \\ 0, & \text{otherwise} \end{cases}$" [目标PSD为
$S_{out}(f) = \begin{cases} (f - 100)(300 - f), & f \in [100, 300] \\ 0, & \text{otherwise} \end{cases}$]
- "The script generates 16384 samples of colored Gaussian noise with a sampling frequency of 1024 Hz" [该脚本生成16384个有色高斯噪声样本，采样频率为1024 Hz]

### 第8页内容
[此处为原图中的图片：“有色高斯噪声生成代码示意图及注释（含Matlab代码片段、红色标记重点行、黄色文本框注释）”]

### 第9页内容
#### Estimating PSD
- "The script NOISE/colGaussNoiseDemo.m also plots an estimate of the PSD of the colored noise using the pwelch function in Matlab" [脚本NOISE/colGaussNoiseDemo.m还使用Matlab中的pwelch函数绘制有色噪声PSD的估计图]
- "Note: pwelch produces a one-sided PSD while we designed the filter using a two-sided PSD" [注意：pwelch生成单侧PSD，而我们设计滤波器时使用的是双侧PSD]
- "Hence, there is a factor of 2 difference between the target and estimated PSDs" [因此，目标PSD与估计PSD之间存在2倍的差异]
- "The normalization in NOISE/statgaussnoisegen.m produces the correct two-sided PSD" [NOISE/statgaussnoisegen.m中的归一化可生成正确的双侧PSD]
  代码片段："inNoise = randn(1,nSamples);
  outNoise = sqrt(sampFreq)*fftfilt(b,inNoise);"
  ["inNoise = randn(1,nSamples);
  outNoise = sqrt(sampFreq)*fftfilt(b,inNoise);" [代码：生成输入白噪声并通过滤波器得到输出有色噪声]]
[此处为原图中的图片：“PSD估计结果示意图（含Matlab代码片段、PSD随频率变化的折线图）”]

### 第10页内容
#### Colored Gaussian Noise
- "Run the NOISE/colGaussNoiseDemo.m script" [运行NOISE/colGaussNoiseDemo.m脚本]
- "Examine the target and estimated PSDs: Apart from overall normalization, the shapes should look similar" [检查目标PSD和估计PSD：除整体归一化外，形状应相似]
  - "Note that the estimated PSD is obtained from a noise realization and, hence, has fluctuations in it" [注意，估计PSD由噪声实现得到，因此存在波动]
  - "Increase the number of samples by factors of 2 and 4: examine the figures again" [将样本数量增加2倍和4倍：再次检查图形]
  - "Why does the estimated PSD become smoother?" [为什么估计的PSD会变得更平滑？]
  - "Enhance the script by putting axes labels, plot titles etc." [通过添加坐标轴标签、图标题等增强脚本]
- "Examine the noise time series by zooming in: Does it look like a WGN realization? How does it differ?" [放大检查噪声时间序列：它看起来像白噪声实现吗？有何不同？]
- "Plot the histogram of the noise realization: Is it still a Normal PDF?" [绘制噪声实现的直方图：它仍然是正态概率密度函数（PDF）吗？]



【批次2处理结果：第11 - 15页图片内容】

### 第11页：SNR of LR test for arbitrary signal and Gaussian noise
Original text: "SNR of LR test for arbitrary signal and Gaussian noise" [任意信号与高斯噪声下似然比检验的信噪比]

Original text: "• Gaussian stationary noise and arbitrary additive signal
$$\vec{y} = \begin{cases} \vec{n} & ; H_0 \\ \vec{s} + \vec{n} & ; H_1 \end{cases}$$" [• 高斯平稳噪声与任意加性信号
$$\vec{y} = \begin{cases} \vec{n} & ; H_0 \\ \vec{s} + \vec{n} & ; H_1 \end{cases}$$]

Original text: "• Joint pdf of noise, which is also $p_{\vec{Y}}(\vec{y}|H_0)$:
$$p_{\vec{Y}}(\vec{y}) = \frac{1}{(2\pi)^{N/2}|\mathbf{C}|^{1/2}} \exp\left( -\frac{1}{2} \|\vec{y}\|^2 \right)$$" [• 噪声的联合概率密度函数，即 $p_{\vec{Y}}(\vec{y}|H_0)$：
$$p_{\vec{Y}}(\vec{y}) = \frac{1}{(2\pi)^{N/2}|\mathbf{C}|^{1/2}} \exp\left( -\frac{1}{2} \|\vec{y}\|^2 \right)$$]

Original text: "Let $\langle \vec{z}, \vec{y} \rangle = \vec{z}\mathbf{C}^{-1}\vec{y}^T$ (So, $\|\vec{y}\|^2 = \langle \vec{y}, \vec{y} \rangle$)" [令 $\langle \vec{z}, \vec{y} \rangle = \vec{z}\mathbf{C}^{-1}\vec{y}^T$（因此，$\|\vec{y}\|^2 = \langle \vec{y}, \vec{y} \rangle$）]

Original text: "• Joint pdf $p_{\vec{Y}}(\vec{y}|H_1)$:
$$p_{\vec{Y}}(\vec{y} | H_1) = \frac{1}{(2\pi)^{N/2}|\mathbf{C}|^{1/2}} \exp\left( -\frac{1}{2} \|\vec{y} - \vec{s}\|^2 \right)$$" [• 联合概率密度函数 $p_{\vec{Y}}(\vec{y}|H_1)$：
$$p_{\vec{Y}}(\vec{y} | H_1) = \frac{1}{(2\pi)^{N/2}|\mathbf{C}|^{1/2}} \exp\left( -\frac{1}{2} \|\vec{y} - \vec{s}\|^2 \right)$$]


### 第12页：SNR of LR test for arbitrary signal and Gaussian noise
Original text: "SNR of LR test for arbitrary signal and Gaussian noise" [任意信号与高斯噪声下似然比检验的信噪比]

Original text: "▸ Log-LR statistic : $\Lambda = \ln \frac{p_{\vec{Y}}(\vec{y}|H_1)}{p_{\vec{Y}}(\vec{y}|H_0)}$
$$\Lambda = \ln \frac{\frac{1}{(2\pi)^{N/2}|\mathbf{C}|^{1/2}} \exp\left( -\frac{1}{2} \|\vec{y} - \vec{s}\|^2 \right)}{\frac{1}{(2\pi)^{N/2}|\mathbf{C}|^{1/2}} \exp\left( -\frac{1}{2} \|\vec{y}\|^2 \right)} = \ln \left[ \exp\left( \frac{1}{2} \|\vec{y}\|^2 - \frac{1}{2} \|\vec{y} - \vec{s}\|^2 \right) \right]$$" [▸ 对数似然比统计量 : $\Lambda = \ln \frac{p_{\vec{Y}}(\vec{y}|H_1)}{p_{\vec{Y}}(\vec{y}|H_0)}$
$$\Lambda = \ln \frac{\frac{1}{(2\pi)^{N/2}|\mathbf{C}|^{1/2}} \exp\left( -\frac{1}{2} \|\vec{y} - \vec{s}\|^2 \right)}{\frac{1}{(2\pi)^{N/2}|\mathbf{C}|^{1/2}} \exp\left( -\frac{1}{2} \|\vec{y}\|^2 \right)} = \ln \left[ \exp\left( \frac{1}{2} \|\vec{y}\|^2 - \frac{1}{2} \|\vec{y} - \vec{s}\|^2 \right) \right]$$]

Original text: "$$\begin{align*} \Lambda &= \frac{1}{2} \|\vec{y}\|^2 - \frac{1}{2} \|\vec{y} - \vec{s}\|^2 = \frac{1}{2} \|\vec{y}\|^2 - \frac{1}{2} \langle \vec{y} - \vec{s}, \vec{y} - \vec{s} \rangle \\ &= \frac{1}{2} \|\vec{y}\|^2 - \frac{1}{2} \langle \vec{y}, \vec{y} \rangle - \frac{1}{2} \langle \vec{s}, \vec{s} \rangle + \frac{1}{2} \times 2 \langle \vec{y}, \vec{s} \rangle \\ &= \langle \vec{y}, \vec{s} \rangle - \frac{1}{2} \langle \vec{s}, \vec{s} \rangle \end{align*}$$" [$$\begin{align*} \Lambda &= \frac{1}{2} \|\vec{y}\|^2 - \frac{1}{2} \|\vec{y} - \vec{s}\|^2 = \frac{1}{2} \|\vec{y}\|^2 - \frac{1}{2} \langle \vec{y} - \vec{s}, \vec{y} - \vec{s} \rangle \\ &= \frac{1}{2} \|\vec{y}\|^2 - \frac{1}{2} \langle \vec{y}, \vec{y} \rangle - \frac{1}{2} \langle \vec{s}, \vec{s} \rangle + \frac{1}{2} \times 2 \langle \vec{y}, \vec{s} \rangle \\ &= \langle \vec{y}, \vec{s} \rangle - \frac{1}{2} \langle \vec{s}, \vec{s} \rangle \end{align*}$$]

Original text: "$\langle \vec{s}, \vec{s} \rangle$ is a constant for the Binary hypotheses: Therefore, the detection statistic can be taken as just $\Lambda = \langle \vec{y}, \vec{s} \rangle$" [$\langle \vec{s}, \vec{s} \rangle$ 在二元假设下为常数：因此，检测统计量可简化为 $\Lambda = \langle \vec{y}, \vec{s} \rangle$]


### 第13页：SNR of LR test for arbitrary signal and Gaussian noise
Original text: "SNR of LR test for arbitrary signal and Gaussian noise" [任意信号与高斯噪声下似然比检验的信噪比]

Original text: "• Here, we will also use $n_i$ to represent the random variable from which the noise realization value is drawn" [• 此处，我们用 $n_i$ 表示噪声实现值所取自的随机变量]

Original text: "• Log-LR statistic : $\Lambda = \ln \frac{p_{\vec{Y}}(\vec{y}|H_1)}{p_{\vec{Y}}(\vec{y}|H_0)} = \frac{1}{2} \|\vec{y}\|^2 - \frac{1}{2} \|\vec{y} - \vec{s}\|^2 = \langle \vec{y}, \vec{s} \rangle - \frac{1}{2} \langle \vec{s}, \vec{s} \rangle \to \Lambda = \langle \vec{y}, \vec{s} \rangle$" [• 对数似然比统计量 : $\Lambda = \ln \frac{p_{\vec{Y}}(\vec{y}|H_1)}{p_{\vec{Y}}(\vec{y}|H_0)} = \frac{1}{2} \|\vec{y}\|^2 - \frac{1}{2} \|\vec{y} - \vec{s}\|^2 = \langle \vec{y}, \vec{s} \rangle - \frac{1}{2} \langle \vec{s}, \vec{s} \rangle \to \Lambda = \langle \vec{y}, \vec{s} \rangle$]

Original text: "• $E[L_{\text{R}} | H_0] = E[\langle \vec{n}, \vec{s} \rangle] = E\left[\sum_{i,j} n_i C_{ij}^{-1} s_j \right] = \sum_{i,j} E[n_i] C_{ij}^{-1} s_j = 0$" [• $E[L_{\text{R}} | H_0] = E[\langle \vec{n}, \vec{s} \rangle] = E\left[\sum_{i,j} n_i C_{ij}^{-1} s_j \right] = \sum_{i,j} E[n_i] C_{ij}^{-1} s_j = 0$]

Original text: "• $E[L_{\text{R}} | H_1] = E[\langle \vec{y}, \vec{s} \rangle|H_1] = E[\langle \vec{s} + \vec{n}, \vec{s} \rangle] = E[\langle \vec{s}, \vec{s} \rangle] + E[\langle \vec{n}, \vec{s} \rangle] = \langle \vec{s}, \vec{s} \rangle$" [• $E[L_{\text{R}} | H_1] = E[\langle \vec{y}, \vec{s} \rangle|H_1] = E[\langle \vec{s} + \vec{n}, \vec{s} \rangle] = E[\langle \vec{s}, \vec{s} \rangle] + E[\langle \vec{n}, \vec{s} \rangle] = \langle \vec{s}, \vec{s} \rangle$]


### 第14页：SNR of LR test for arbitrary signal and Gaussian noise
Original text: "SNR of LR test for arbitrary signal and Gaussian noise" [任意信号与高斯噪声下似然比检验的信噪比]

Original text: "• Here, we will also use $n_i$ to represent the random variables from which the noise realization values are drawn" [• 此处，我们用 $n_i$ 表示噪声实现值所取自的随机变量]

Original text: "• Log-LR statistic : $\Lambda = \ln \frac{p_{\vec{Y}}(\vec{y}|H_1)}{p_{\vec{Y}}(\vec{y}|H_0)} = \frac{1}{2} \|\vec{y}\|^2 - \frac{1}{2} \|\vec{y} - \vec{s}\|^2 = \langle \vec{y}, \vec{s} \rangle - \frac{1}{2} \langle \vec{s}, \vec{s} \rangle \to \Lambda = \langle \vec{y}, \vec{s} \rangle$" [• 对数似然比统计量 : $\Lambda = \ln \frac{p_{\vec{Y}}(\vec{y}|H_1)}{p_{\vec{Y}}(\vec{y}|H_0)} = \frac{1}{2} \|\vec{y}\|^2 - \frac{1}{2} \|\vec{y} - \vec{s}\|^2 = \langle \vec{y}, \vec{s} \rangle - \frac{1}{2} \langle \vec{s}, \vec{s} \rangle \to \Lambda = \langle \vec{y}, \vec{s} \rangle$]

Original text: "• $E[L_{\text{R}} | H_0] = E[\langle \vec{n}, \vec{s} \rangle] = E\left[\sum_{i,j} n_i C_{ij}^{-1} s_j \right] = \sum_{i,j} E[n_i] C_{ij}^{-1} s_j = 0$" [• $E[L_{\text{R}} | H_0] = E[\langle \vec{n}, \vec{s} \rangle] = E\left[\sum_{i,j} n_i C_{ij}^{-1} s_j \right] = \sum_{i,j} E[n_i] C_{ij}^{-1} s_j = 0$]

Original text: "• $E[L_{\text{R}} | H_1] = E[\langle \vec{y}, \vec{s} \rangle|H_1] = E[\langle \vec{s} + \vec{n}, \vec{s} \rangle] = E[\langle \vec{s}, \vec{s} \rangle] + E[\langle \vec{n}, \vec{s} \rangle] = \langle \vec{s}, \vec{s} \rangle$" [• $E[L_{\text{R}} | H_1] = E[\langle \vec{y}, \vec{s} \rangle|H_1] = E[\langle \vec{s} + \vec{n}, \vec{s} \rangle] = E[\langle \vec{s}, \vec{s} \rangle] + E[\langle \vec{n}, \vec{s} \rangle] = \langle \vec{s}, \vec{s} \rangle$]

Original text: "• $var(L_{\text{R}}|H_0) = E\left[(L_{\text{R}} - E[L_{\text{R}}|H_0])^2 | H_0 \right] = E\left[L_{\text{R}}^2 | H_0 \right] = E\left[\langle \vec{n}, \vec{s} \rangle^2 \right] = E\left[\vec{s}\mathbf{C}^{-1}\vec{n}^T \vec{n}\mathbf{C}^{-1}\vec{s}^T \right]$" [• $var(L_{\text{R}}|H_0) = E\left[(L_{\text{R}} - E[L_{\text{R}}|H_0])^2 | H_0 \right] = E\left[L_{\text{R}}^2 | H_0 \right] = E\left[\langle \vec{n}, \vec{s} \rangle^2 \right] = E\left[\vec{s}\mathbf{C}^{-1}\vec{n}^T \vec{n}\mathbf{C}^{-1}\vec{s}^T \right]$]

Original text: "• $E\left[(\vec{n}^T \vec{n})_{ij} \right] = E[n_i n_j] = C_{ij}$" [• $E\left[(\vec{n}^T \vec{n})_{ij} \right] = E[n_i n_j] = C_{ij}$]

Original text: "• $\vec{s}\mathbf{C}^{-1}\vec{n}^T \vec{n}\mathbf{C}^{-1}\vec{s}^T = \vec{s}\mathbf{C}^{-1}\mathbf{C}\mathbf{C}^{-1}\vec{s}^T = \vec{s}\mathbf{C}^{-1}\vec{s}^T = \langle \vec{s}, \vec{s} \rangle$" [• $\vec{s}\mathbf{C}^{-1}\vec{n}^T \vec{n}\mathbf{C}^{-1}\vec{s}^T = \vec{s}\mathbf{C}^{-1}\mathbf{C}\mathbf{C}^{-1}\vec{s}^T = \vec{s}\mathbf{C}^{-1}\vec{s}^T = \langle \vec{s}, \vec{s} \rangle$]

Original text: "• SNR:
$$\frac{E[L_{\text{R}} | H_1]}{\left[ var(L_{\text{R}}|H_0) \right]^{\frac{1}{2}}} = \frac{\langle \vec{s}, \vec{s} \rangle}{\left[ \langle \vec{s}, \vec{s} \rangle \right]^{1/2}} = \sqrt{\langle \vec{s}, \vec{s} \rangle} = \|\vec{s}\|$$" [• 信噪比:
$$\frac{E[L_{\text{R}} | H_1]}{\left[ var(L_{\text{R}}|H_0) \right]^{\frac{1}{2}}} = \frac{\langle \vec{s}, \vec{s} \rangle}{\left[ \langle \vec{s}, \vec{s} \rangle \right]^{1/2}} = \sqrt{\langle \vec{s}, \vec{s} \rangle} = \|\vec{s}\|$$]


### 第15页：Conclusion
Original text: "Conclusion" [结论]

Original text: "▸ The function glrtqcsig.m will serve as the fitness function that will be optimized by PSO to obtain the GLRT
$$L_G = \max_{\Theta} \langle \vec{y}, \vec{q}(\Theta) \rangle^2$$" [▸ 函数 glrtqcsig.m 将作为适应度函数，由粒子群优化（PSO）算法优化以获取广义似然比检验值
$$L_G = \max_{\Theta} \langle \vec{y}, \vec{q}(\Theta) \rangle^2$$]

Original text: "▸ This optimization problem and the results associated with it are fully discussed in the textbook" [▸ 此优化问题及其相关结果在教材中有详细讨论]

Original text: "▸ The main difference is that we have generalized the textbook problem to the case of colored Gaussian noise" [