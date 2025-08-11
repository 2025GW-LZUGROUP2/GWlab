【批次1处理结果：第1-10页图片内容】

### 第1页 
"Topic 1: Lab" [主题1：实验]

### 第2页 
"Part 1" [第一部分]

### 第3页
#### Signal generation
- "Each team will write code to generate one type of signal" [每个团队将编写代码以生成一种类型的信号]
- "Team leaders will write the code and explain to their team the meaning of their code" [团队负责人将编写代码并向其团队解释代码的含义]
- "Team members can help:" [团队成员可以提供帮助：]
  - "If you know programming, try to implement the code in parallel so that there is a check" [如果你懂编程，尝试并行实现代码以进行检查]
  - "If you don’t know programming, copy the code and try to learn OR learn Matlab using the free mathworks.com coursework" [如果你不懂编程，复制代码并尝试学习，或者使用mathworks.com上的免费课程学习Matlab]


### 第4页
#### Signal generation
- "Write code to generate different types of discrete time signals" [编写代码以生成不同类型的离散时间信号]
- "You will add your code to your team’s copy of the forked repository DATASCIENCE_COURSE" [你将把代码添加到团队分叉的DATASCIENCE_COURSE仓库副本中]
- "Follow the example of the Matlab function DATASCIENCE_COURSE/SIGNALS/crcbgenqcsig.m" [遵循Matlab函数DATASCIENCE_COURSE/SIGNALS/crcbgenqcsig.m的示例]
  - "testcrcbgenqcsig.m : Script in the same folder showing how to use the function" [testcrcbgenqcsig.m：同一文件夹中的脚本，展示如何使用该函数]
  - "Learn elements of good coding: Good documentation, Clean and understandable code" [学习良好编码的要素：良好的文档、简洁且易懂的代码]
- "Once your code is running well:" [一旦你的代码运行良好：]
  - "Use: git pull → git add→ git commit → git push" [使用：git pull → git add→ git commit → git push]
  - "Remember the advice: Pull before Push" [记住建议：推送前先拉取]


### 第5页
#### QUADRATIC CHIRP
- $f(t) = A \sin(2\pi \Phi(t))$ [瞬时频率相关公式：$f(t) = A \sin(2\pi \Phi(t))$]
- "Instantaneous phase:" [瞬时相位：]
  $\Phi(t) = a_1 t + a_2 t^2 + a_3 t^3$ [$\Phi(t) = a_1 t + a_2 t^2 + a_3 t^3$]
- "Parameters of the signal:" [信号参数：]
  $A, a_1, a_2, a_3$ [$A, a_1, a_2, a_3$]
- "Instantaneous frequency:" [瞬时频率：]
  $f(t) = \frac{d\Phi}{dt}$ [$\[f(t) = \frac{d\Phi}{dt}\]$]
  $= a_1 + 2a_2 t + 3a_3 t^2$ [$\[= a_1 + 2a_2 t + 3a_3 t^2\]$]
- "f(t) increases with t
1/f(t) (Instantaneous period) decreases with t" [f(t) 随 t 增加而增加
1/f(t)（瞬时周期）随 t 增加而减少]
[此处为原图中的图片：二次啁啾信号波形图（横轴Independent variable，纵轴Quad. Chirp）]
- "Example taken from textbook ("Swarm intelligence methods for Statistical Regression", Chapter 1)" [示例取自教材《Swarm intelligence methods for Statistical Regression》第1章]
- "BigDat 2019, Cambridge, UK" [BigDat 2019，英国剑桥]


### 第6页
#### Plots
- "Choose a sampling interval (or period) $\Delta$
$t = n\Delta, \quad n = 0,1, ..., N - 1$" [选择采样间隔（或周期）$\Delta$
$t = n\Delta, \quad n = 0,1, ..., N - 1$]
- "Sampling frequency = $1/\Delta$" [采样频率 = $1/\Delta$]
- "Generate the signal for the above set of sample times and make a plot" [针对上述采样时间集合生成信号并绘制图表]


### 第7页
#### More signals
- "Sinusoidal signal" [正弦信号]
  - $s(t) = A \sin(2\pi f_0 t + \phi_0)$ [$s(t) = A \sin(2\pi f_0 t + \phi_0)$]
  - "Parameters: $A, f_0, \phi_0$" [参数：$A, f_0, \phi_0$]
- "Linear chirp signal" [线性啁啾信号]
  - $s(t) = A \sin(2\pi (f_0 t + f_1 t^2) + \phi_0)$ [$s(t) = A \sin(2\pi (f_0 t + f_1 t^2) + \phi_0)$]
  - "Parameters: $A, f_0, f_1, \phi_0$" [参数：$A, f_0, f_1, \phi_0$]
- "Sine-Gaussian signal" [正弦-高斯信号]
  - $s(t) = A \exp\left(-\frac{(t - t_0)^2}{2\sigma^2}\right) \sin(2\pi f_0 t + \phi_0)$ [$s(t) = A \exp\left(-\frac{(t - t_0)^2}{2\sigma^2}\right) \sin(2\pi f_0 t + \phi_0)$]
  - "Parameters: $A, t_0, \sigma, f_0, \phi_0$" [参数：$A, t_0, \sigma, f_0, \phi_0$]


### 第8页
#### More signals
- "Frequency modulated (FM) sinusoid" [频率调制（FM）正弦波]
  - $s(t) = A \sin(2\pi f_0 t + b \cos(2\pi f_1 t))$ [$s(t) = A \sin(2\pi f_0 t + b \cos(2\pi f_1 t))$]
  - "Parameters: $A, b, f_0, f_1$" [参数：$A, b, f_0, f_1$]
- "Amplitude modulated (AM) sinusoid" [幅度调制（AM）正弦波]
  - $s(t) = A \cos(2\pi f_1 t) \times \sin(f_0 t + \phi_0)$ [$s(t) = A \cos(2\pi f_1 t) \times \sin(f_0 t + \phi_0)$]
  - "Parameters: $A, f_0, f_1, \phi_0$" [参数：$A, f_0, f_1, \phi_0$]
- "AM-FM sinusoid" [AM-FM正弦波]
  - $s(t) = A \cos(2\pi f_1 t) \times \sin(2\pi f_0 t + b \cos(2\pi f_1 t))$ [$s(t) = A \cos(2\pi f_1 t) \times \sin(2\pi f_0 t + b \cos(2\pi f_1 t))$]
  - "Parameters: $A, b, f_0, f_1$" [参数：$A, b, f_0, f_1$]


### 第9页
#### Linear transient chirp signal
- $s(t) = \begin{cases} 0; & t \notin [t_a, t_a + L] \\ A \sin(2\pi (f_0 (t - t_a) + f_1 (t - t_a)^2) + \phi_0) & \text{otherwise} \end{cases}$
  [$s(t) = \begin{cases} 0; & t \notin [t_a, t_a + L] \\ A \sin(2\pi (f_0 (t - t_a) + f_1 (t - t_a)^2) + \phi_0) & \text{otherwise} \end{cases}$]
- "Parameters: $A, t_a, f_0, f_1, \phi_0, L$" [参数：$A, t_a, f_0, f_1, \phi_0, L$]


### 第10页
#### Format of a Matlab function definition
- "function <output arguments> = <function name>(Input arguments)" [function <输出参数> = <函数名>(输入参数)]
- "function sigVec = crcbgenqcsig(dataX,snr,qcCoefs)" [function sigVec = crcbgenqcsig(dataX,snr,qcCoefs)]
  - "dataX : vector of time stamps $(t_0, t_1, ..., t_{M-1})$ at which the samples of the signal $s(t)$ are to be computed." [dataX：时间戳向量 $(t_0, t_1, ..., t_{M-1})$，信号 $s(t)$ 的采样将在这些时间戳处计算]
  - "qcCoefs: vector of three coefficients [a1, a2, a3] that parametrize the phase of the signal $\Phi(t) = a_1 t + a_2 t^2 + a_3 t^3$" [qcCoefs：三个系数的向量 [a1, a2, a3]，用于参数化信号的相位 $\Phi(t) = a_1 t + a_2 t^2 + a_3 t^3$]
  - "snr: A special way to define the parameter $A$" [snr：定义参数 $A$ 的一种特殊方式]
  - $\Phi(t) = a_1 t + a_2 t^2 + a_3 t^3$ [$\Phi(t) = a_1 t + a_2 t^2 + a_3 t^3$]
  - "phaseVec = qcCoefs(1)*dataX + qcCoefs(2)*dataX.^2 + qcCoefs(3)*dataX.^3;" [phaseVec = qcCoefs(1)*dataX + qcCoefs(2)*dataX.^2 + qcCoefs(3)*dataX.^3;]
  - $\sin(2\pi \Phi(t))$ [$\sin(2\pi \Phi(t))$]
  - "sigVec = sin(2*pi*phaseVec);" [sigVec = sin(2*pi*phaseVec);]
  - $A \sin(2\pi \Phi(t))$ [$A \sin(2\pi \Phi(t))$]
  - "sigVec = snr*sigVec/norm(sigVec);" [sigVec = snr*sigVec/norm(sigVec);]


【本批次处理完毕，可继续发送下一批次图片（格式：“批次2：第11-15页”），或告知“所有批次已提供完毕”以结束处理】

【批次2处理结果：第11-21页图片内容】

### 第11页 
#### Elements of good coding
- "function sigVec = crcbgenqcsig(dataX,snr,qcCoefs)" [function sigVec = crcbgenqcsig(dataX,snr,qcCoefs)]
- "% Generate a quadratic chirp signal" [% 生成二次啁啾信号]
- "% S = CRCBGENQCSIG(X,SNR,C)" [% S = CRCBGENQCSIG(X,SNR,C)]
- "% Generates a quadratic chirp signal S. X is the vector of time stamps at which the samples of the signal are to be computed. SNR is the matched filtering signal - to - noise ratio of S and C is the vector of three coefficients [a1, a2, a3] that parametrize the phase of the signal: % a1*t + a2*t^2 + a3*t^3." [% 生成二次啁啾信号S。X是用于计算信号采样的时间戳向量。SNR是S的匹配滤波信噪比，C是用于参数化信号相位的三个系数的向量：a1*t + a2*t^2 + a3*t^3。]
- "%Soumya D. Mohanty, May 2018" [%Soumya D. Mohanty，2018年5月]
- "phaseVec = qcCoefs(1)*dataX + qcCoefs(2)*dataX.^2 + qcCoefs(3)*dataX.^3;" [phaseVec = qcCoefs(1)*dataX + qcCoefs(2)*dataX.^2 + qcCoefs(3)*dataX.^3;]
- "sigVec = sin(2*pi*phaseVec);" [sigVec = sin(2*pi*phaseVec);]
- "sigVec = snr*sigVec/norm(sigVec);" [sigVec = snr*sigVec/norm(sigVec);]
- "Function name should be descriptive but short: CRCBook - Generate - Quadratic - Chirp - Signal" [函数名应具有描述性但简洁：CRCBook - Generate - Quadratic - Chirp - Signal]
- "First comment is used by Matlab to generate Contents report" [第一条注释供Matlab生成目录报告使用]
- "Second line shows usage format (input and output arguments); Displayed with command “help crcbgenqcsig”" [第二行展示使用格式（输入和输出参数）；通过命令“help crcbgenqcsig”显示]
- "Describe what the code does and what is the meaning of each input and output argument" [描述代码的功能以及每个输入和输出参数的含义]
- "Author of the code (add additional lines for multiple authors), Date of creation" [代码作者（多个作者时添加额外行），创建日期]
- "Variable names should be descriptive. C++ convention: thisIsAVariableName. Quadratic Chirp Coefficients" [变量名应具有描述性。C++ 惯例：thisIsAVariableName。二次啁啾系数]


### 第12页 
#### Choosing the sampling frequency: Nyquist Sampling theorem
- "What is the bandwidth of your signal?" [你的信号带宽是多少？]
  - "A good starting guess: highest instantaneous frequency in the signal" [一个好的初始猜测：信号中的最高瞬时频率]
  - "Note: Instantaneous frequency is not the same as Fourier frequency!" [注意：瞬时频率与傅里叶频率不同！]
- "Example:" [示例：]
  - "N samples with sampling interval Δ" [N个采样点，采样间隔为Δ]
  - "Quadratic chirp instantaneous frequency increases with time" [二次啁啾的瞬时频率随时间增加]
  - "⇒ Maximum instantaneous frequency is at t = nΔ
$f(t) = a_1 + 2a_2 t + 3a_3 t^2$" [⇒ 最大瞬时频率出现在t = nΔ处
$f(t) = a_1 + 2a_2 t + 3a_3 t^2$]
- "Nyquist theorem ⇒ Sampling rate is ≥ 2 × Max. instantaneous frequency" [奈奎斯特定理 ⇒ 采样率 ≥ 2 × 最大瞬时频率]
- "Anti - aliasing: When doing actual data analysis, we low pass filter our signals and data such that a given sampling frequency becomes the Nyquist frequency" [抗混叠：在进行实际数据分析时，我们对信号和数据进行低通滤波，使得给定的采样频率成为奈奎斯特频率]
  - "Example: LIGO data is low pass filtered to a maximum Fourier frequency of 8192 Hz before it is sampled at 16384 Hz" [示例：LIGO数据在以16384 Hz采样之前，被低通滤波到最大傅里叶频率8192 Hz]


### 第13页 
#### Play the signal!
- "First, pick the correct sampling frequency (> Nyquist rate) for your signal" [首先，为你的信号选择正确的采样频率（>奈奎斯特率）]
- ">> help sound" [>> help sound]
- "sound Play vector as sound." [sound 将向量作为声音播放。]
- "sound(Y,FS) sends the signal in vector Y (with sample frequency FS) out to the speaker on platforms that support sound. Values in Y are assumed to be in the range - 1.0 <= y <= 1.0. Values outside that range are clipped. Stereo sounds are played, on platforms that support it, when Y is an N - by - 2 matrix." [sound(Y,FS) 在支持声音的平台上，将向量Y中的信号（采样频率为FS）发送到扬声器。假设Y中的值在 - 1.0 <= y <= 1.0范围内。超出该范围的值将被截断。当Y是N×2矩阵时，在支持的平台上播放立体声。]
- "sound(Y) plays the sound at the default sample rate of 8192 Hz." [sound(Y) 以默认采样率8192 Hz播放声音。]
- "sound(Y,FS,BITS) plays the sound using BITS bits/sample if possible. Most platforms support BITS = 8 or 16." [sound(Y,FS,BITS) 尽可能使用BITS位/采样播放声音。大多数平台支持BITS = 8或16。]


### 第14页 
"Part 2" [第二部分]


### 第15页 
#### FFT
- "Assuming you are generating the signals with the proper sampling frequency, make plots of the periodogram of each signal" [假设你以合适的采样频率生成信号，绘制每个信号的周期图]
- "Periodogram: Magnitude of the FFT" [周期图：FFT的幅度]


### 第16页 
#### Frequencies in a DFT
- "Generate the correct frequency values for your periodogram plots" [为你的周期图绘制生成正确的频率值]
  - "Positive frequency components of FFT go from index number: 1 to floor(N/2)+1" [FFT的正频率分量索引范围：1到floor(N/2)+1]
  - "Negative frequency components go from index number: floor(N/2)+2 to N" [FFT的负频率分量索引范围：floor(N/2)+2到N]
- "Frequency spacing is 1/(NΔ) where N is the number of samples and Δ is the sampling interval" [频率间隔为1/(NΔ)，其中N是采样点数，Δ是采样间隔]
- "See testcrcbgenqcsig.m for an example" [查看testcrcbgenqcsig.m获取示例]


### 第17页 
"Advanced Lab Topic 1" [高级实验主题1]


### 第18页 
#### Time frequency analysis
- "Use Matlab’s spectrogram function to make time - frequency plots of the signals that have been coded so far" [使用Matlab的spectrogram函数绘制到目前为止已编码信号的时频图]
- "Each team should pick the signal function written by the next team (proceed in a ring)" [每个团队应选择下一个团队编写的信号函数（循环进行）]
  1. "Read the signal generation function help (use “help <functionName>” in Matlab) and the associated test<functionName>.m script if needed" [阅读信号生成函数的帮助文档（在Matlab中使用“help <functionName>”），如果需要，阅读相关的test<functionName>.m脚本]
  2. "If the help/test script are not well documented, inform the author of the function/script to make them better" [如果帮助文档/测试脚本的文档不完善，通知函数/脚本的作者进行改进]
     1. "Authors of each function should add their names to the function file as shown in DSP/crcbgenqcsig.m" [每个函数的作者应像DSP/crcbgenqcsig.m中那样，将自己的名字添加到函数文件中]
  3. "Generate signal time series with appropriate Nyquist sampling frequency" [以合适的奈奎斯特采样频率生成信号时间序列]
  4. "Make spectrograms: When successful, add spectrogram generation to test<functionName>.m script" [制作 spectrogram：成功后，将 spectrogram 生成添加到 test<functionName>.m 脚本中]
- "See DSP/SpecgrmQCDemo.m for an example" [查看DSP/SpecgrmQCDemo.m获取示例]
- "Highly recommended: See the documentation of spectrogram in Matlab (start with “help spectrogram” and follow up with the hyperlink at the end of the help)" [强烈建议：查看Matlab中spectrogram的文档（从“help spectrogram”开始，并跟随帮助文档末尾的超链接）]


### 第19页 
#### Filtering
- "Use the function for generating a sinusoid to generate a signal containing the sum of three sinusoids with the following parameters" [使用生成正弦波的函数生成一个包含三个正弦波之和的信号，参数如下]
- "Number of samples: 2048" [采样点数：2048]
- "Sampling frequency: 1024 Hz" [采样频率：1024 Hz]
  - "What is the maximum frequency of the discrete time sinusoid you can generate with this sampling frequency?" [使用该采样频率，你能生成的离散时间正弦波的最大频率是多少？]
- （表格内容）
  |  | Signal 1 | Signal 2 | Signal 3 |
  | --- | --- | --- | --- |
  | A | 10 | 5 | 2.5 |
  | $f_0$ | 100 | 200 | 300 |
  | $\phi_0$ | 0 | $\pi/6$ | $\pi/4$ |
- "Use Matlab’s fir1 function to design 3 different filters such that filter #i allows only signal #i to pass through" [使用Matlab的fir1函数设计3个不同的滤波器，使得滤波器#i仅允许信号#i通过]
- "Apply each filter to the signal and show the periodogram of the input and outputs (All teams do the same exercise; split filter design among team members)" [将每个滤波器应用于信号，并展示输入和输出的周期图（所有团队进行相同练习；团队成员之间分配滤波器设计任务）]


### 第20页 
#### FIR filter design
- ">> help fir1" [>> help fir1]
- "fir1 FIR filter design using the window method. B = fir1(N,Wn) designs an N'th order lowpass FIR digital filter and returns the filter coefficients in length N + 1 vector B. The cut - off frequency Wn must be between 0 < Wn < 1.0, with 1.0 corresponding to half the sample rate. The filter B is real and has linear phase. The normalized gain of the filter at Wn is - 6 dB." [fir1 使用窗函数法设计FIR滤波器。B = fir1(N,Wn) 设计一个N阶低通FIR数字滤波器，并将滤波器系数返回在长度为N + 1的向量B中。截止频率Wn必须在0 < Wn < 1.0之间，其中1.0对应于采样率的一半。滤波器B是实的且具有线性相位。滤波器在Wn处的归一化增益为 - 6 dB。]
- "B = fir1(N,Wn,'high') designs an N'th order highpass filter. You can also use B = fir1(N,Wn,'low') to design a lowpass filter." [B = fir1(N,Wn,'high') 设计一个N阶高通滤波器。你也可以使用B = fir1(N,Wn,'low') 设计低通滤波器。]
- "If Wn is a two - element vector, Wn = [W1 W2], fir1 returns an order N bandpass filter with passband W1 < W < W2. You can also specify B = fir1(N,Wn,'bandpass'). If Wn = [W1 W2], B = fir1(N,Wn,'stop') will design a bandstop filter." [如果Wn是一个双元素向量，Wn = [W1 W2]，fir1 返回一个N阶带通滤波器，通带为W1 < W < W2。你也可以指定B = fir1(N,Wn,'bandpass')。如果Wn = [W1 W2]，B = fir1(N,Wn,'stop') 将设计一个带阻滤波器。]


### 第21页 
#### Filtering
- "The main thing about Matlab’s filter design functions is that frequencies are specified relative to half the sampling frequency of the input data" [Matlab滤波器设计函数的主要特点是，频率是相对于输入数据采样频率的一半来指定的]
  - ">> help fir1
FIR filter design using the window method. B = fir1(N,Wn) designs an N'th order lowpass FIR digital filter and returns the filter coefficients in length N + 1 vector B. The cut - off frequency Wn must be between 0 < Wn < 1.0, with 1.0 corresponding to half the sample rate." [>> help fir1
使用窗函数法设计FIR滤波器。B = fir1(N,Wn) 设计一个N阶低通FIR数字滤波器，并将滤波器系数返回在长度为N + 1的向量B中。截止频率Wn必须在0 < Wn < 1.0之间，其中1.0对应于采样率的一半。]
- "fir1 is the simplest FIR filter design method (fir2 and fir1s are more sophisticated methods): Good for designing standard low pass, high pass and bandpass filters." [fir1是最简单的FIR滤波器设计方法（fir2和fir1s是更复杂的方法）：适合设计标准的低通、高通和带通滤波器。]
- "For the exercise, you have to design all of the above three types of filters with the appropriate frequency limits" [在本次练习中，你必须设计上述所有三种类型的滤波器，并设置合适的频率限制]
- "Study the script DSP/LowPassFilterDemo.m to see how a low pass filter is designed and how it is applied (to the quadratic chirp signal)" [研究脚本DSP/LowPassFilterDemo.m，了解低通滤波器是如何设计的以及如何应用（于二次啁啾信号）]


【本批次处理完毕，可继续发送下一批次图片（格式：“批次3：第22-26页”），或告知“所有批次已提供完毕”以结束处理】