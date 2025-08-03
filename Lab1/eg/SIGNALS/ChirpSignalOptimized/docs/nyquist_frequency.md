# Nyquist频率详解

## 两种定义及其区别

在信号处理领域，"Nyquist频率"这一术语存在两种常见定义，这常常导致混淆。本文档澄清这两种定义及其应用场景。

### 定义一：临界采样频率（Nyquist Rate）

**数学表达**：$f_s = 2f_B$

其中：
- $f_s$ 是采样频率
- $f_B$ 是信号带宽（对于基带信号，即信号中的最高频率分量）

**严格定义**：根据Nyquist-Shannon采样定理，对于带限信号（频谱在$[-f_B, f_B]$范围内非零），要无损地重建原始信号，采样频率$f_s$必须至少是信号带宽$2f_B$。这个临界采样频率$2f_B$被称为"Nyquist频率"或"Nyquist率"。

**原始表述**：根据PPT中的表述："The critical sampling frequency $f_s = 2f_B$ is called the Nyquist frequency (or Nyquist rate)"。

### 定义二：采样率的一半（Nyquist Limit）

**数学表达**：$f_{Nyq} = \frac{f_s}{2}$

**工程定义**：在给定采样率$f_s$下，可以无混叠地表示的最高频率。超过这个频率的分量会在频谱中发生混叠（别名）。

**应用场景**：在离散信号处理和FFT分析中，采样率的一半通常被称为"Nyquist频率"或"Nyquist限制"。这一值对应于DFT/FFT结果的中点。

## 两种定义的关系与区别

这两个定义从不同角度描述同一现象：

1. **第一种定义**关注的是：给定一个带限信号，至少需要多高的采样率才能完整重建。
2. **第二种定义**关注的是：给定一个采样率，能无混叠重建的信号最高频率是多少。

这两种定义之间存在明确的数学关系：
- 如果$f_B$是信号的最高频率，则需要$f_s \geq 2f_B$（第一种定义）
- 如果$f_s$是已知的采样率，则可表示的最高频率为$f_B \leq f_s/2$（第二种定义）

## 在代码中的具体应用

在`testcrcbgenqcsig.m`中，两种定义都有使用：

### 定义一的应用（临界采样频率）

```matlab
% 计算信号的最大瞬时频率
maxFreq = a1 + 2*a2 + 3*a3;

% 计算Nyquist率（临界采样频率）
nyqFreq = 2*maxFreq;

% 设置实际采样频率（通常高于Nyquist率）
samplFreq = 5*nyqFreq;
```

这里首先计算了信号的最高频率成分（maxFreq，即t=1时的瞬时频率），然后根据第一种定义计算了所需的最小采样频率（nyqFreq = 2*maxFreq）。为了保证充分采样，实际采样频率设为这个最小要求的5倍。

### 定义二的应用（采样率的一半）

```matlab
% 计算FFT索引，对应于采样率一半的频率点
kNyq = floor(nSamples/2) + 1;

% 仅保留正频率部分的FFT结果
fftSig = fftSig(1:kNyq);
```

在FFT处理中，采样率一半（fs/2）对应的索引点是处理频谱的重要分界点。对于实信号，由于其FFT具有共轭对称性，只需保留到这个点的结果即可。

## FFT结果的排列与对称性

理解FFT结果的排列对于正确解释Nyquist频率至关重要：

1. 对于N点FFT，结果的频率排列为：
   ```
   [0, 1*Δf, 2*Δf, ..., (N/2)*Δf, -(N/2-1)*Δf, ..., -2*Δf, -1*Δf]
   ```
   其中Δf = fs/N是频率分辨率

2. 或者用频率表示：
   ```
   [0Hz, 正频率..., Nyquist频率(fs/2), 负频率...]
   ```

3. 使用`fftshift`函数可将零频分量移至中心：
   ```
   [负频率..., 0Hz, 正频率..., Nyquist频率(fs/2)]
   ```

4. 对于实信号，FFT结果满足共轭对称性：X[N-k] = X*[k]，因此只需保留前半部分（包含0到fs/2的频率）即可。

## 混叠效应

当信号中存在超过采样率一半（fs/2）的频率成分时，这些高频分量会被错误地表示为低频分量，产生"混叠"或"别名"现象：

- 频率为f的分量，如果f > fs/2，则会在频谱中表现为|f - n·fs|，其中n是使结果落在[-fs/2, fs/2]范围内的整数

这也是为什么需要确保采样频率至少是信号最高频率的两倍（第一种定义）的根本原因。

## 参考文献

1. C. E. Shannon, "Communication in the presence of noise," Proc. IRE, vol. 37, pp. 10–21, Jan. 1949.
2. H. Nyquist, "Certain topics in telegraph transmission theory," Trans. AIEE, vol. 47, pp. 617–644, Apr. 1928.
3. A. V. Oppenheim and R. W. Schafer, "Discrete-Time Signal Processing", 3rd ed., Pearson, 2014.
