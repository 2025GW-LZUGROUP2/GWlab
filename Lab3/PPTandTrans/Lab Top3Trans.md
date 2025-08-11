【批次1处理结果：第1-10页图片内容】

### 第1页内容

"Lab topic 3" [实验主题3]

### 第2页内容

#### Pseudo-random numbers

- "Homework reading: Find an online source to understand how random numbers are generated on a computer" [作业阅读：找到一个在线资源以了解计算机上随机数是如何生成的]
- "Example: <https://en.wikipedia.org/wiki/Pseudorandom_number_generator>" [示例：https://en.wikipedia.org/wiki/Pseudorandom_number_generator]

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

【本批次处理完毕，可继续发送下一批次图片（格式：“批次2：第11-15页”），或告知“所有批次已提供完毕”以结束处理】

【批次2处理结果：第11-18页图片内容】

### 第11页内容

#### Tasks

- "You have been provided a plain text file: “testData.txt” in the NOISE folder:" [在NOISE文件夹中已提供一个纯文本文件：“testData.txt”]
  - "First column: sampling times" [第一列：采样时间]
  - "Second column: data values" [第二列：数据值]
- "The data contains:" [数据包含：]
  - "A realization of colored Gaussian noise plus ..." [一个有色高斯噪声的实现加上……]
  - "A mystery signal added after $t = 5.0$ sec" [在$t = 5.0$秒后添加的一个神秘信号]
- "You can load the data file using “load(‘testData.txt’)”: Matlab uses the file extension ‘.txt’ to recognize that this is a plain text file." [你可以使用“load(‘testData.txt’)”加载数据文件：Matlab使用文件扩展名“.txt”来识别这是一个纯文本文件]
- "Use the signal - free part of the data to:" [使用数据的无信号部分来：]
  - "Estimate the noise PSD" [估计噪声的功率谱密度（PSD）]
  - "Use the estimated PSD and emulate the code in NOISE/ statgaussnoisegen.m to design a whitening filter" [使用估计的PSD并模仿NOISE/statgaussnoisegen.m中的代码设计一个白化滤波器]
- "Then," [然后，]
  - "Whiten the data" [白化数据]
- "Plot the spectrograms of the data before and after whitening" [绘制数据白化前后的 spectrograms（频谱图）]
- "Plot the data time series before and after whitening" [绘制数据白化前后的数据时间序列]
  - "Is the presence of the signal clearer in the data after whitening?" [白化后数据中信号的存在是否更明显？]

### 第12页内容

"Simulating LIGO noise" [模拟LIGO噪声]

### 第13页内容

#### Objective

- "Simulate the noise of an interferometric detector" [模拟干涉仪探测器的噪声]
- "We will pick the sensitivity curve of the initial LIGO detector as an example for the target PSD" [我们将选择初始LIGO探测器的灵敏度曲线作为目标PSD的示例]
- "The same steps can be used for any other design sensitivity curve (e.g., advanced LIGO, LISA etc)" [相同的步骤可用于任何其他设计的灵敏度曲线（例如，先进LIGO、LISA等）]
[此处为原图中的图片：“LIGO探测器灵敏度曲线（频率 - 根号下PSD关系图）”]

### 第14页内容

#### Initial LIGO design sensitivity

- "The PSD is provided in the file NOISE/iLIGOSensitivity.txt" [PSD在文件NOISE/iLIGOSensitivity.txt中提供]
- "It is a plain text file which can be read into Matlab" [它是一个可读入Matlab的纯文本文件]
- "First column is Frequency $f$ (Hz) and second column is $\sqrt{S_n(f)}$" [第一列是频率$f$（Hz），第二列是$\sqrt{S_n(f)}$]
  Matlab代码示例：
  ">> y = load('iLIGOSensitivity.txt','-ascii');
  >> whos y
    Name Size Bytes Class
    y 97x2 1552 double
  >> loglog(y(:,1),y(:,2))"
  [">> y = load('iLIGOSensitivity.txt','-ascii');
  >> whos y
    Name Size Bytes Class
    y 97x2 1552 double
  >> loglog(y(:,1),y(:,2))" [Matlab代码：加载文件并绘制双对数图]]
[此处为原图中的图片：“初始LIGO设计灵敏度曲线（双对数坐标系下频率 - 根号下PSD关系图）”]

### 第15页内容

#### Initial LIGO design sensitivity

- "The PSD is provided in the file NOISE/iLIGOSensitivity.txt" [PSD在文件NOISE/iLIGOSensitivity.txt中提供]
- "It is a plain text file which can be read into Matlab" [它是一个可读入Matlab的纯文本文件]
- "First column is Frequency $f$ (Hz) and second column is $\sqrt{S_n(f)}$" [第一列是频率$f$（Hz），第二列是$\sqrt{S_n(f)}$]
  Matlab代码示例：
  ">> y = load('iLIGOSensitivity.txt','-ascii');
  >> whos y
    Name Size Bytes Class
    y 97x2 1552 double
  >> loglog(y(:,1),y(:,2))"
  [">> y = load('iLIGOSensitivity.txt','-ascii');
  >> whos y
    Name Size Bytes Class
    y 97x2 1552 double
  >> loglog(y(:,1),y(:,2))" [Matlab代码：加载文件并绘制双对数图]]
[此处为原图中的图片：“初始LIGO设计灵敏度曲线（侧重高频段，含文本框注释‘Design sensitivity is not specified at equally spaced frequencies, but this is not a problem for designing FIR filters’）”]

### 第16页内容

#### Modifications

- "In any data analysis method, the low and high frequency parts will be filtered out $\Rightarrow$ the PSD of the simulated noise need not match the design PSD in those parts" [在任何数据分析方法中，低频和高频部分会被滤除$\Rightarrow$模拟噪声的PSD在这些部分无需与设计PSD匹配]
- "The order of an FIR filter that can reproduce the steeply rising seismic part in its transfer function will be very high $\Rightarrow$ Making the PSD goes smoothly to zero or just be a constant in these parts will help Matlab in designing better filters" [能在传递函数中再现陡升地震波部分的FIR滤波器阶数会很高$\Rightarrow$让这些部分的PSD平滑地变为零或保持恒定将有助于Matlab设计更好的滤波器]
[此处为原图中的图片：“修改后的LIGO噪声PSD曲线（含粉色辅助线示意修改部分）”]

### 第17页内容

#### Modifications

- "For $f \leq 50$ Hz: $S_n(f) \rightarrow S_n(f = 50)$" [对于$f \leq 50$ Hz：$S_n(f)$ 取 $S_n(f = 50)$ 处的值]
- "For $f \geq 700$ Hz: $S_n(f) \rightarrow S_n(f = 700)$" [对于$f \geq 700$ Hz：$S_n(f)$ 取 $S_n(f = 700)$ 处的值]
  - "700 Hz is where the inspiral phase of a binary of double neutron star will terminate" [700 Hz是双中子星双星旋进阶段终止的频率]
  - "No point in keeping noise above this frequency in the data" [在数据中保留该频率以上的噪声没有意义]
- "Remember that you need normalized frequencies of 0 and 1 for input to FIR1" [记住，对于FIR1的输入，你需要0和1的归一化频率]
  - "Add $f = 0, S_n(f = 0)$ and $\frac{f_s}{2}, S_n \left(f = \frac{f_s}{2}\right)$ to the list if these are missing" [如果缺少$f = 0, S_n(f = 0)$和$\frac{f_s}{2}, S_n \left(f = \frac{f_s}{2}\right)$，将其添加到列表中]
- "Task: Use the supplied codes (NOISE/colGaussNoiseDemo.m, statgaussnoisegen.m) to produce a simulated LIGO noise realization and estimate the PSD" [任务：使用提供的代码（NOISE/colGaussNoiseDemo.m、statgaussnoisegen.m）生成模拟的LIGO噪声实现并估计PSD]

### 第18页内容

#### Example of simulated LIGO noise PSD

- "Note that the LIGO design sensitivity plots are logarithmic in frequency while the plot here is on a linear scale" [注意，LIGO设计灵敏度图在频率上是对数刻度，而此处的图是线性刻度]
  - "Also, different truncation and sampling frequencies were used here" [此外，此处使用了不同的截断和采样频率]
- "The “bumpiness” in the PSD near the minimum is an artifact of the approximation inherent in filter design" [PSD最小值附近的“起伏”是滤波器设计中固有近似的产物]
  - "You should try to minimize such artifacts by choosing the design parameters appropriately." [你应通过合理选择设计参数来尽量减少此类产物]
[此处为原图中的图片：“模拟LIGO噪声PSD示例图（线性频率刻度，含红色圈出的起伏区域）”]

【本批次处理完毕，可继续发送下一批次图片（格式：“批次3：第19 - 23页”），或告知“所有批次已提供完毕”以结束处理】
