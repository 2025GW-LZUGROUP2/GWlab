为什么在代码里要对**时域信号**乘上 $\sqrt{F_s}$（而不是对 PSD 做什么），以及这和“以 Hz 为单位给定的目标两边 PSD”之间的单位换算有什么关系。

---

# 1) 基础定义（用 $f$ 表示频率，用 $\Phi$ 表示自协方差）

\*\*连续时间（CT）\*\*宽平稳过程 $x_c(t)$ 的自协方差与 PSD 的维纳–辛钦关系（用 Hz 记频率）：

$$
S_{x_c}(f)=\int_{-\infty}^{\infty}\Phi_{x_c}(\tau)\,e^{-j2\pi f\tau}\,d\tau,\qquad
\Phi_{x_c}(\tau)=\int_{-\infty}^{\infty} S_{x_c}(f)\,e^{j2\pi f\tau}\,df.
$$

这一定义与性质可见于标准教材/讲义。([comm.toronto.edu][1], [probabilitycourse.com][2])

\*\*离散时间（DT）\*\*过程中，令

$$
x_d[n]=x_c(nT),\quad T=\frac1{F_s}.
$$

其自协方差与 PSD（此处先用“**每采样周期**的数字频率”，即 cycles/sample）定义为

$$
\Phi_{x_d}[m]=\mathbb{E}\{x_d[n]\,x_d[n+m]\},\qquad
S_{x_d}^{(\text{cs})}(f_\sim)=\sum_{m=-\infty}^{\infty}\Phi_{x_d}[m]\,e^{-j2\pi f_\sim m},\quad f_\sim\in\left(-\tfrac12,\tfrac12\right].
$$

（上式就是“自协方差的 DTFT”。）([塔夫茨大学工程学院][3])

因为工程上常以 **Hz** 表示频率并和 MATLAB 的 `pwelch(...,Fs)` 对齐，我们还需要“**每 Hz**”的 PSD 记法。两种密度的换算遵循

$$
S_{x_d}^{(\text{Hz})}(f)=\frac{1}{F_s}\,S_{x_d}^{(\text{cs})}\!\left(\frac{f}{F_s}\right),
$$

直观理解是“1 cycles/sample 对应 $F_s$ Hz”，密度换元会除以 $F_s$。`pwelch` 的输出正是“每 Hz”的 PSD。([MathWorks][4], [维基百科][5])

---

# 2) 采样把自协方差“抽样”，再用泊松求和得到频域关系

因 $x_d[n]=x_c(nT)$，有

$$
\Phi_{x_d}[m]=\Phi_{x_c}(mT).
$$

代入上节定义并使用**泊松求和公式**（“时域抽样 $\Leftrightarrow$ 频域周期化”），得到数字频率（cycles/sample）上的关系

$$
\boxed{\;
S_{x_d}^{(\text{cs})}(f_\sim)=\frac{1}{T}\sum_{k=-\infty}^{\infty}
S_{x_c}\!\left(\frac{f_\sim + k}{T}\right)
\;}
$$

把 $f_\sim=f/F_s$ 代回，并换成“每 Hz”的 PSD（即再除以 $F_s$），得到最常用的 **Hz 版别名叠加公式**：

$$
\boxed{\;
S_{x_d}^{(\text{Hz})}(f)=\sum_{k=-\infty}^{\infty} S_{x_c}\!\big(f-kF_s\big)
\;}
$$

这说明：采样会把连续 PSD 以 $F_s$ 为间隔在频域**平移并叠加**（别名化）。([维基百科][6], [Signal Processing Stack Exchange][7])

**无混叠（带限）特例**：若 $S_{x_c}(f)=0$ 对所有 $|f|\ge F_s/2$，则上式只剩 $k=0$ 项，于是

$$
\boxed{\;
S_{x_d}^{(\text{Hz})}(f)=S_{x_c}(f),\qquad |f|<\tfrac{F_s}{2}
\;}
$$

这正是“在 Hz 计量下，采样不会改变带限过程的 PSD 数值”。([ee.iitb.ac.in][8])

---

# 3) 线性系统对 PSD 的作用（CT 与 DT）

对**连续时间**：若 $y_c(t)$ 由 $x_c(t)$ 通过 LTI 滤波器 $H_c(f)$ 得到，

$$
S_{y_c}(f)=|H_c(f)|^2 S_{x_c}(f).
$$

对**离散时间**：若 $y[n]$ 由 $x[n]$ 通过 DT LTI 滤波器 $H_d(f_\sim)$ 得到（数字频率 $f_\sim$ 单位 cycles/sample），

$$
S_{y}^{(\text{cs})}(f_\sim)=|H_d(f_\sim)|^2 S_{x}^{(\text{cs})}(f_\sim).
$$

换成 Hz 计量，只是变量/单位转换，结论不变：

$$
\boxed{\;S_{y}^{(\text{Hz})}(f)=|H_d(f)|^2 S_{x}^{(\text{Hz})}(f)\;}
$$

（**时域幅度缩放** $z[n]=a\,y[n]$ 视作通过“常数增益”滤波器，PSD 乘 $a^2$。）([塔夫茨大学工程学院][3])

---

# 4) 白噪声的 PSD（DT）

离散**零均值**白噪声 $w[n]$ 若方差为 $\sigma^2$，则

$$
\Phi_w[m]=\sigma^2\delta[m]\quad\Longrightarrow\quad
S_w^{(\text{cs})}(f_\sim)=\sigma^2\ (\text{常数}).
$$

因此“每 Hz”的 PSD 是

$$
\boxed{\;S_w^{(\text{Hz})}(f)=\frac{\sigma^2}{F_s}\;}\qquad(\text{两边 PSD，平的}).
$$

你的代码用的是 $\sigma^2=1$ 的 $w[n]=\texttt{randn}$，于是 $S_w^{(\text{Hz})}(f)=1/F_s$。([培生高等教育][9])

---

# 5) 关键：为什么要把**时域信号**乘 $\sqrt{F_s}$

你用 `fir2` 设计幅频 $|H_d(f)|\approx \sqrt{S_{\text{target}}(f)}$，其中 `f` 以 Hz 表示（`fir2` 的 `f` 入口是**按 Nyquist 归一化**后传入的物理频率，和 `Fs` 的关系由 $f/(F_s/2)$ 归一化得到）。([MathWorks][10])

把**单位方差** DT 白噪声 $w[n]$ 送入这个滤波器：

$$
y[n]=(h*w)[n],\qquad |H_d(f)|=\sqrt{S_{\text{target}}(f)}.
$$

则

$$
S_{y}^{(\text{Hz})}(f)=|H_d(f)|^2\,S_w^{(\text{Hz})}(f)
=\underbrace{S_{\text{target}}(f)}_{\text{你想要的}}\times \underbrace{\frac{1}{F_s}}_{\text{白噪声(每 Hz)PSD}}.
$$

可见它**整体矮了 $F_s$ 倍**。

现在对**时域信号**做幅度缩放：

$$
y'[n]=\sqrt{F_s}\,y[n].
$$

因为 PSD 对应“功率”密度，时域乘 $a\Rightarrow$ PSD 乘 $a^2$，于是

$$
S_{y'}^{(\text{Hz})}(f)=F_s\,S_{y}^{(\text{Hz})}(f)=F_s\times \frac{S_{\text{target}}(f)}{F_s}
=\boxed{\,S_{\text{target}}(f)\,}.
$$

这就证明：**乘的是信号本身的 $\sqrt{F_s}$**，目的是把“每 Hz 的 PSD”校正到目标的数值；这并不是在比较两个 PSD 体系下的某种抽象比例，而是一个很具体的**单位一致性**修正。`pwelch(x,[],[],[],Fs)` 估计出来的 PSD（每 Hz）此时就能与 `psdVals(:,2)` 对齐。([MathWorks][4])

> 换个说法：若一开始就把滤波器的幅度做成
> $|\tilde H_d(f)|=\sqrt{F_s}\,\sqrt{S_{\text{target}}(f)}$，那你**不需要**事后乘 $\sqrt{F_s}$；但用 `fir2` 直接喂 $\sqrt{S_{\text{target}}(f)}$ 更直观，于是选择在**时域**补回 $\sqrt{F_s}$。

---

# 6) 小结（把上面 1–5 串起来）

1. 定义：$S_{x_c}(f)\leftrightarrow \Phi_{x_c}(\tau)$（CT），$S_{x_d}^{(\text{cs})}(f_\sim)\leftrightarrow \Phi_{x_d}[m]$（DT）。([comm.toronto.edu][1], [塔夫茨大学工程学院][3])
2. 采样关系（Hz 计）：$S_{x_d}^{(\text{Hz})}(f)=\sum_k S_{x_c}(f-kF_s)$；带限无混叠时 $S_{x_d}^{(\text{Hz})}(f)=S_{x_c}(f)$。([维基百科][6], [Signal Processing Stack Exchange][7], [ee.iitb.ac.in][8])
3. LTI 滤波：$S_{\text{out}}(f)=|H(f)|^2S_{\text{in}}(f)$（CT/DT 通用）。([塔夫茨大学工程学院][3])
4. DT 单位方差白噪声的“每 Hz” PSD 是 $1/F_s$。([培生高等教育][9])
5. 因此当 $|H_d(f)|=\sqrt{S_{\text{target}}(f)}$ 时，输出 PSD 先得到 $S_{\text{target}}(f)/F_s$，**把时域信号乘 $\sqrt{F_s}$**，PSD 立刻变为 $S_{\text{target}}(f)$。

---

# 7) 与你的 MATLAB 代码对齐（保留 `sqrt(Fs)` 在**时域**）

下面给出一个**完整可跑**的版本（含自检）。我保留了你用 `fir2` + `fftfilt` 的结构，只是把注释、变量名和验证补全了。最后的 `sqrt(Fs)` 明确乘在**时域输出**上。

```matlab
function outNoise = statgaussnoisegen(nSamples, psdVals, fltrOrdr, Fs)
% 生成具有给定“两边/每 Hz”PSD 的平稳高斯噪声
% 输入:
%   nSamples : 输出样本数
%   psdVals  : Mx2 矩阵，[频率(Hz), PSD(f) 每Hz，两边]
%              频率从 0 到 Fs/2（含端点）
%   fltrOrdr : FIR 滤波器阶数
%   Fs       : 采样频率 (Hz)
% 输出:
%   outNoise : 目标 PSD 的一组实现

% 1) 设计 FIR 幅频 |H_d(f)| = sqrt( S_target(f) )
f_Hz   = psdVals(:,1);                     % Hz 频率
sqrtPSD= sqrt(psdVals(:,2));               % 目标 PSD 的平方根（“每 Hz”）
f_nyq  = f_Hz/(Fs/2);                      % fir2 需要 [0,1]，其中 1 代表 Nyquist
b      = fir2(fltrOrdr, f_nyq, sqrtPSD);   % 频率采样法设计 FIR
% 参考: fir2/frequency normalization 文档

% 2) 生成单位方差 DT 白噪声 (其“每 Hz”PSD 为 1/Fs)
inNoise = randn(1, nSamples);

% 3) 通过滤波器得到 y[n]，此时 S_y^{(Hz)}(f) = |H_d(f)|^2 * (1/Fs) = S_target(f)/Fs
y = fftfilt(b, inNoise);

% 4) 单位一致性修正：时域乘 sqrt(Fs)，使 S_{out}^{(Hz)}(f) = S_target(f)
outNoise = sqrt(Fs) * y;
end
```

**数值自检脚本**（比较 `pwelch` 估计与目标 PSD 是否重合；去掉 $\sqrt{F_s}$ 会整体矮一倍 $1/F_s$）：

```matlab
% ==== 参数与目标 PSD ====
Fs = 4096;                    % 采样频率
N  = 2^15;                    % 样本点数
f = linspace(0, Fs/2, 2000).';     % 频率轴 (Hz)
% 目标“两边/每 Hz” PSD（示例：1/f + 噪声地板）
S0 = 1e-6 + 1e-3 ./ max(f,1);       % 自行替换成你的 psdVals(:,2)
psdVals = [f, S0];

% ==== 生成噪声 ====
y_ok = statgaussnoisegen(N, psdVals, 400, Fs);

% ==== 与取消 sqrt(Fs) 的版本做对比 ====
% （仅用于对照，解释为什么要乘 sqrt(Fs)）
y_bad = fftfilt(fir2(400, f/(Fs/2), sqrt(S0)), randn(1, N)); % 不乘 sqrt(Fs)

% ==== 用 pwelch(…,Fs) 估计“每 Hz”的两边 PSD ====
[Py_ok, fy]  = pwelch(y_ok, hamming(8*1024), [], 4*1024, Fs, "twosided");
[Py_bad,~]   = pwelch(y_bad, hamming(8*1024), [], 4*1024, Fs, "twosided");

% ==== 可视化 ====
figure; loglog(fy(fy>0), Py_ok(fy>0), 'LineWidth',1.2); hold on;
loglog(f, S0, '--', 'LineWidth',1.2);
loglog(fy(fy>0), Py_bad(fy>0), ':', 'LineWidth',1.2);
grid on; xlabel('Frequency (Hz)'); ylabel('PSD (per Hz, two-sided)');
legend('pwelch(y\_ok)','target S(f)','pwelch(y\_bad)','Location','best');
title('验证：乘 \surd F_s 后与目标 PSD 对齐；未乘则整体低 1/F_s');
```

> 说明：`pwelch(x,[],[],[],Fs,'twosided')` 的单位就是**每 Hz 的两边 PSD**，与 `psdVals` 一致；而 `fir2` 的频率向量使用的是**按 Nyquist 归一化的物理频率** $f/(F_s/2)$。([MathWorks][4])

---

# 参考要点（给你确认公式出处）

* **维纳–辛钦定理（CT, Hz 记法）**：$S(f)$ 与 $\Phi(\tau)$ 互为傅里叶变换。([comm.toronto.edu][1])
* **DT PSD 定义（DTFT of $\Phi[m]$，频率域为 cycles/sample）**：$\displaystyle S^{(\text{cs})}(f_\sim)=\sum_m \Phi[m]e^{-j2\pi f_\sim m}$。([塔夫茨大学工程学院][3])
* **泊松求和/采样的 PSD 关系**：$\displaystyle S_{x_d}^{(\text{Hz})}(f)=\sum_k S_{x_c}(f-kF_s)$（Hz 版别名叠加）。([维基百科][6], [Signal Processing Stack Exchange][7])
* **LTI 对 PSD 的作用**：$S_{\text{out}}(f)=|H(f)|^2 S_{\text{in}}(f)$（CT 与 DT）。([塔夫茨大学工程学院][3])
* **DT 白噪声的 PSD**：$\Phi[m]=\sigma^2\delta[m]\Rightarrow S^{(\text{cs})}=\sigma^2$ 常数（故“每 Hz”= $\sigma^2/F_s$）。([培生高等教育][9])
* **`pwelch` 的 PSD（每 Hz）与 `fir2` 频率归一化**。([MathWorks][4])

---

[1]: https://www.comm.toronto.edu/frank/notes/wk.pdf?utm_source=chatgpt.com "The Wiener-Khinchin Theorem"
[2]: https://www.probabilitycourse.com/chapter10/10_2_1_power_spectral_density.php?utm_source=chatgpt.com "10.2.1 Power Spectral Density"
[3]: https://www.ece.tufts.edu/~maivu/ES150/8-lti_psd.pdf?utm_source=chatgpt.com "Topic 8: Power spectral density and LTI systems"
[4]: https://www.mathworks.com/help/signal/ref/pwelch.html?utm_source=chatgpt.com "pwelch - Welch's power spectral density estimate - MATLAB"
[5]: https://en.wikipedia.org/wiki/Normalized_frequency_%28signal_processing%29?utm_source=chatgpt.com "Normalized frequency (signal processing)"
[6]: https://en.wikipedia.org/wiki/Poisson_summation_formula?utm_source=chatgpt.com "Poisson summation formula"
[7]: https://dsp.stackexchange.com/questions/36517/derivation-of-psd-of-sampled-bandlimited-random-process?utm_source=chatgpt.com "Derivation of PSD of sampled bandlimited random process"
[8]: https://www.ee.iitb.ac.in/~akumar/courses/ee603-2020/sampling.html?utm_source=chatgpt.com "Chapter 3 Sampling continuous-time signals | EE603"
[9]: https://www.pearsonhighered.com/assets/samplechapter/0/1/3/1/0131988425.pdf?utm_source=chatgpt.com "Discrete-Time Signals and Systems"
[10]: https://www.mathworks.com/help/signal/ug/fir-filter-design.html?utm_source=chatgpt.com "FIR Filter Design - MATLAB & Simulink"
