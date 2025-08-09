# 问题一：两种SNR定义的一致性与合理性分析

## 1. 两种定义的形式回顾

- **通用检测统计量的SNR**：对于任意检测统计量$\Gamma(\bar{y})$，其SNR定义为信号存在时统计量的均值与信号不存在时统计量的标准差之比：
  $$\text{SNR} = \frac{E\left[\Gamma \mid H_1\right]}{\sqrt{\text{var}\left(\Gamma \mid H_0\right)}}$$
- **LR检验的SNR（振幅归一化中的$A$）**：对于高斯噪声下的似然比（LR）检验，信号向量$\vec{s}(\theta)$的**Mahalanobis范数**（由噪声协方差矩阵$\mathbf{C}$定义）即为其SNR：
  $$A = \|\vec{s}(\theta)\| = \sqrt{\langle \vec{s}(\theta), \vec{s}(\theta) \rangle} = \sqrt{\vec{s}(\theta)^T \mathbf{C}^{-1} \vec{s}(\theta)}$$

## 2. 两种定义的一致性证明

两种定义的一致性**仅针对LR检验这一特定情况**，核心逻辑是：**LR统计量的SNR（按通用定义计算）恰好等于信号向量的Mahalanobis范数**。以下是严格推导：

对于高斯噪声下的LR检验，数据模型为：
$$\bar{y} =
\begin{cases}
\bar{n} & (H_0, \text{纯噪声}) \\
\vec{s} + \bar{n} & (H_1, \text{信号+噪声})
\end{cases}$$
其中$\bar{n}$是零均值高斯噪声，协方差矩阵为$\mathbf{C}$。

LR统计量（对数形式，忽略常数项）为：
$$\Gamma_{\text{LR}}(\bar{y}) = \langle \bar{y}, \vec{s} \rangle = \bar{y}^T \mathbf{C}^{-1} \vec{s}$$

**步骤1：计算$E\left[\Gamma_{\text{LR}} \mid H_1\right]$**
当$H_1$为真时，$\bar{y} = \vec{s} + \bar{n}$，因此：
$$E\left[\Gamma_{\text{LR}} \mid H_1\right] = E\left[(\vec{s} + \bar{n})^T \mathbf{C}^{-1} \vec{s}\right] = \vec{s}^T \mathbf{C}^{-1} \vec{s} + E\left[\bar{n}^T \mathbf{C}^{-1} \vec{s}\right]$$
由于$\bar{n}$零均值，第二项为0，故：
$$E\left[\Gamma_{\text{LR}} \mid H_1\right] = \langle \vec{s}, \vec{s} \rangle = \|\vec{s}\|^2$$

**步骤2：计算$\text{var}\left(\Gamma_{\text{LR}} \mid H_0\right)$**
当$H_0$为真时，$\bar{y} = \bar{n}$，因此：
$$\text{var}\left(\Gamma_{\text{LR}} \mid H_0\right) = \text{var}\left(\bar{n}^T \mathbf{C}^{-1} \vec{s}\right) = E\left[(\bar{n}^T \mathbf{C}^{-1} \vec{s})^2\right] - \left(E\left[\bar{n}^T \mathbf{C}^{-1} \vec{s}\right]\right)^2$$
由于$\bar{n}$零均值，第二项为0；展开第一项：
$$E\left[(\bar{n}^T \mathbf{C}^{-1} \vec{s})^2\right] = E\left[\vec{s}^T \mathbf{C}^{-1} \bar{n} \bar{n}^T \mathbf{C}^{-1} \vec{s}\right] = \vec{s}^T \mathbf{C}^{-1} E\left[\bar{n} \bar{n}^T\right] \mathbf{C}^{-1} \vec{s}$$
而$E\left[\bar{n} \bar{n}^T\right] = \mathbf{C}$（噪声协方差矩阵定义），因此：
$$\text{var}\left(\Gamma_{\text{LR}} \mid H_0\right) = \vec{s}^T \mathbf{C}^{-1} \mathbf{C} \mathbf{C}^{-1} \vec{s} = \vec{s}^T \mathbf{C}^{-1} \vec{s} = \|\vec{s}\|^2$$

**步骤3：计算LR统计量的SNR**
将上述结果代入通用SNR定义：
$$\text{SNR}_{\text{LR}} = \frac{E\left[\Gamma_{\text{LR}} \mid H_1\right]}{\sqrt{\text{var}\left(\Gamma_{\text{LR}} \mid H_0\right)}} = \frac{\|\vec{s}\|^2}{\sqrt{\|\vec{s}\|^2}} = \|\vec{s}\| = A$$

这直接证明：**LR检验的SNR（按通用定义）等于信号向量的Mahalanobis范数$A$**。

#### 3. 为何都称为“信噪比”？
两种定义的核心一致：**衡量“信号对统计量的贡献”与“噪声对统计量的干扰”的相对强度**。
- 通用定义中，$E\left[\Gamma \mid H_1\right]$是信号存在时统计量的“均值偏移”（信号的贡献），$\sqrt{\text{var}\left(\Gamma \mid H_0\right)}$是信号不存在时统计量的“波动幅度”（噪声的干扰），比值越大，信号越易从噪声中区分。
- LR检验的定义中，$A = \|\vec{s}\|$本质是“信号能量与噪声能量的比值的平方根”（Mahalanobis范数已融入噪声协方差的加权），与通用定义的物理意义完全一致——均反映信号相对于噪声的“可检测性”。
