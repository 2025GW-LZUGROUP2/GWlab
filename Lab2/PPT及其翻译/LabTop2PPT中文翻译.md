# Lab Top2 PPT中文翻译

## 幻灯片1：Lab Topic 2

- 英文：Lab Topic 2
- 中文翻译：实验主题2

## 幻灯片2：Learning objectives

- 主标题
  英文：Learning objectives
  中文翻译：学习目标
- 要点
  英文：Learn how to calculate the response of a gravitational wave (GW) detector to a plane GW
  中文翻译：学习如何计算引力波（GW）探测器对平面引力波的响应
  - 子要点1
    英文：Response calculations for both LIGO and LISA
    中文翻译：针对LIGO和LISA的响应计算
  - 子要点2
    英文：Long wavelength approximation
    中文翻译：长波长近似
  - 子要点3
    英文：Detector rotation and motion included for LISA
    中文翻译：包含LISA探测器的旋转和运动

## 幻灯片3：Antenna Patterns: Local frame ← Analytical forms

- 主标题
  英文：Antenna Patterns: Local frame ← Analytical forms
  中文翻译：天线方向图：局部坐标系 ← 解析形式
- 要点
  英文：Long wavelength and static detector approximation throughout this Lab
  中文翻译：本实验全程采用长波长与静态探测器近似
  英文：Write a code to calculate \( F_+ \) and \( F_\times \) in an L - shaped interferometer’s local frame from their analytical formulae
  中文翻译：编写代码，根据解析公式计算L型干涉仪局部坐标系中的\( F_+ \)和\( F_\times \)
  - 子要点1
    英文：Source direction: \( (\theta, \phi) \) in detector frame
    中文翻译：源方向：探测器坐标系下的\( (\theta, \phi) \)
  - 子要点2
    英文：Plot them on a sphere using the GWSC/GW/skyplot.m function
    中文翻译：使用GWSC/GW/skyplot.m函数在球面上绘制它们
  - 子要点3
    英文：\( F_+ \) Demo code: GWSC/GW/formulafp.m, GWSC/GW/testskyplot.m
    中文翻译：\( F_+ \)示例代码：GWSC/GW/formulafp.m、GWSC/GW/testskyplot.m
  英文：Plots should agree with the pictures in the lecture slides
  中文翻译：绘图应与课堂幻灯片中的图片一致
- 公式
  \( F_\times(\theta, \phi) = \cos\theta \sin2\phi \)
  \( F_+(\theta, \phi) = \frac{1}{2}(1 + \cos^2\theta) \cos2\phi \)
- 图片标注
  [图片：两张球型彩色三维图，分别对应\( F_\times \)和\( F_+ \)的天线方向图分布]

## 幻灯片4：Antenna Patterns: Local frame ← using tensors

- 主标题
  英文：Antenna Patterns: Local frame ← using tensors
  中文翻译：天线方向图：局部坐标系 ← 利用张量
- 要点
  英文：Use the expression for (a) polarization tensors, (b) Detector tensor, and (c) Contraction of polarization and detector tensors to obtain \( F_{+,\times} \)
  中文翻译：使用（a）极化张量、（b）探测器张量、（c）极化张量与探测器张量的收缩运算来得到\( F_{+,\times} \)
  英文：All tensor components must be expressed in a common frame before the tensors are contracted → express all unit vector components in a common frame
  中文翻译：在张量收缩前，所有张量分量必须在同一参考系下表示→将所有单位向量分量表示在同一参考系下
  英文：We will use the detector frame as the common one:
  中文翻译：我们将探测器坐标系作为公共参考系：
  - 子要点1
    英文：Detector arm unit vectors and their components in the detector frame: \( \hat{\eta}_X = (1,0,0), \hat{\eta}_Y = (0,1,0) \)
    中文翻译：探测器臂单位向量及其在探测器坐标系下的分量：\( \hat{\eta}_X = (1,0,0), \hat{\eta}_Y = (0,1,0) \)
  - 子要点2
    英文：Detector frame Z vector: \( \hat{Z} = (0,0,1) \)
    中文翻译：探测器坐标系Z向量：\( \hat{Z} = (0,0,1) \)
  - 子要点3
    英文：Source direction vector in detector frame (for polar angles \( \theta \) and \( \phi \)): \( \hat{n} \)
    中文翻译：探测器坐标系下的源方向向量（对应极角\( \theta \)和\( \phi \)）：\( \hat{n} \)
  英文：Wave frame unit vector components for polarization tensor calculation (burst GW convention):
  中文翻译：用于极化张量计算的波坐标系单位向量分量（突发引力波约定）：
  - 子要点1
    英文：Wave frame \( \hat{x} \propto \hat{Z} \times \hat{n} \) (Note: must normalize)
    中文翻译：波坐标系\( \hat{x} \propto \hat{Z} \times \hat{n} \)（注意：必须归一化）
  - 子要点2
    英文：Wave frame \( \hat{y} = \hat{x} \times \hat{n} \)
    中文翻译：波坐标系\( \hat{y} = \hat{x} \times \hat{n} \)
  - 子要点3
    英文：(Use GWSC/GW/vcrossprod.m to obtain vector cross product components numerically)
    中文翻译：（使用GWSC/GW/vcrossprod.m来数值计算向量叉乘分量）
- 图片标注
  [图片：探测器坐标系示意图，包含X,Y,Z轴、源方向向量\( \hat{n} \)及极角\( \theta \)、方位角\( \phi \)]

## 幻灯片5：Strain signal

- 主标题
  英文：Strain signal
  中文翻译：应变信号
- 要点
  英文：Detector tensor:
  中文翻译：探测器张量：
  - 公式
    \( \tilde{D} = \frac{1}{2}(\hat{\eta}_X \otimes \hat{\eta}_X - \hat{\eta}_Y \otimes \hat{\eta}_Y) \)
  英文：Wave tensor:
  中文翻译：波张量：
  - 公式
    \( \tilde{W} = h_+(t)\tilde{e}_+ + h_\times(t)\tilde{e}_\times \)
  英文：Polarization tensors: \( \tilde{e}_+ = \hat{x} \otimes \hat{x} - \hat{y} \otimes \hat{y}; \quad \tilde{e}_\times = \hat{x} \otimes \hat{y} + \hat{y} \otimes \hat{x} \)
  中文翻译：极化张量：\( \tilde{e}_+ = \hat{x} \otimes \hat{x} - \hat{y} \otimes \hat{y}; \quad \tilde{e}_\times = \hat{x} \otimes \hat{y} + \hat{y} \otimes \hat{x} \)
  英文：Matlab can calculate direct products of vectors:
  中文翻译：Matlab可计算向量的直积：
  - 示例公式
    若\( a = [a_1, a_2, a_3],\ b = [b_1, b_2, b_3] \)（Matlab中两行向量），则\( a' * b \to \hat{a} \otimes \hat{b} = \begin{pmatrix} a_1 \\ a_2 \\ a_3 \end{pmatrix} (b_1\ b_2\ b_3) = \begin{bmatrix} a_1b_1 & a_1b_2 & a_1b_3 \\ a_2b_1 & a_2b_2 & a_2b_3 \\ a_3b_1 & a_3b_2 & a_3b_3 \end{bmatrix} \)
  英文：Strain signal: “Contraction of wave and detector tensors”
  中文翻译：应变信号：“波张量与探测器张量的收缩”
  - 公式
    \( s(t) = \sum_{i,j=1}^3 W_{ij} D_{ij} = W^{ij} D_{ij} = \tilde{W} : \tilde{D} = h_+(t)\tilde{D}:\tilde{e}_+ + h_\times(t)\tilde{D}:\tilde{e}_\times = h_+(t)F_+(\hat{n}) + h_\times(t)F_\times(\hat{n}) \)
  - 子要点
    英文：Contraction of matrices \( A \) and \( B \) in Matlab → sum(A(:).*B(:))
    中文翻译：Matlab中矩阵\( A \)和\( B \)的收缩→ sum(A(:).*B(:))
  英文：Compare the antenna patterns obtained using tensor contractions and analytical forms
  中文翻译：比较通过张量收缩和解析形式得到的天线方向图
  英文：Demo codes: GWSC / GW/ detframepfc.m and testdetframepfc.m
  中文翻译：示例代码：GWSC / GW/ detframepfc.m 和 testdetframepfc.m

## 幻灯片6：Exercise: Wave frame conventions

- 主标题
  英文：Exercise: Wave frame conventions
  中文翻译：练习：波坐标系约定
- 要点
  英文：Extend the previous exercise to include rotation due to polarization angle into the polarization tensors (Hint: the new wave frame \( X,Y \) vector components will be linear combinations of the old \( X,Y \) components)
  中文翻译：扩展之前的练习，将极化角引起的旋转纳入极化张量中（提示：新波坐标系\( X,Y \)的向量分量将是旧\( X,Y \)分量的线性组合）
- 图片标注
  [图片：两张探测器臂示意图，左图展示X、Y臂的初始方向；右图展示X、Y臂随极化角旋转的椭圆轨迹]

## 幻灯片7：Strain signal from a non - evolving binary

- 主标题
  英文：Strain signal from a non - evolving binary
  中文翻译：非演化双星的应变信号
- 要点
  英文：Use the sinusoidal signal generation function to generate \( h_+(t) = A \sin(2\pi f_0 t) \); \( h_\times(t) = B \sin(2\pi f_0 t + \phi_0) \)
  中文翻译：使用正弦信号生成函数生成\( h_+(t) = A \sin(2\pi f_0 t) \)；\( h_\times(t) = B \sin(2\pi f_0 t + \phi_0) \)
  英文：Pick your own values of \( A,B,f_0,\phi_0 \) (Respect Nyquist theorem!)
  中文翻译：自行选择\( A,B,f_0,\phi_0 \)的值（遵守奈奎斯特定理！）
  英文：Plot the strain signal for different values of \( \theta, \phi, \) and \( \psi \)
  中文翻译：针对\( \theta, \phi, \)和\( \psi \)的不同取值绘制应变信号

## 幻灯片8：General strain signal for a static interferometer

- 主标题
  英文：General strain signal for a static interferometer
  中文翻译：静态干涉仪的通用应变信号
- 要点
  英文：Write a function:
  中文翻译：编写一个函数：
  - 子要点1
    英文：Inputs:
    中文翻译：输入：
    - 子子要点
      英文：\( h_+ \) (vector) and \( h_\times \) (vector): time series of the polarizations (don’t have to be sinusoidal)
      中文翻译：\( h_+ \)（向量）和\( h_\times \)（向量）：极化的时间序列（不必为正弦波）
    - 子子要点
      英文：\( \theta, \phi \)
      中文翻译：\( \theta, \phi \)
  - 子要点2
    英文：Output:
    中文翻译：输出：
    - 子子要点
      英文：Strain signal (for perpendicular arm interferometer)
      中文翻译：应变信号（针对垂直臂干涉仪）

## 幻灯片9：Antenna patterns for LISA

- 主标题
  英文：Antenna patterns for LISA
  中文翻译：LISA的天线方向图

## 幻灯片10：Toy LISA

- 主标题
  英文：Toy LISA
  中文翻译：简易LISA（Toy LISA）
- 要点
  英文：Toy LISA: Rigid equilateral triangle formation of three satellites
  中文翻译：简易LISA：三颗卫星组成的刚性等边三角形结构
  英文：Actual LISA cannot be rigid because the satellites must follow Keplerian orbits
  中文翻译：实际LISA无法保持刚性，因为卫星必须遵循开普勒轨道
  英文：Toy LISA is good for practicing data analysis because it allows fast generation of signals and templates
  中文翻译：简易LISA便于数据分析练习，因为它能快速生成信号和模板
- 图片标注
  [图片：LISA轨道示意图，黑色背景上展示彩色轨道及红色卫星三角形，标注“Orbitography of space interferometer project LISA, following Earth in the solar system”]

## 幻灯片11：Reference frames and rotations

- 主标题
  英文：Reference frames and rotations
  中文翻译：参考系与旋转
- 要点
  英文：The common reference frame to use here is the Solar System Barycentric (SSB) frame
  中文翻译：此处使用的公共参考系为太阳系质心（SSB）参考系
  英文：The polarization tensors will be computed in the same way as for the detector frame (see previous exercises) but now the frame is the SSB
  中文翻译：极化张量的计算方式与探测器参考系相同（见之前的练习），但现在参考系为SSB
  英文：We need to find the components of LISA arm unit vectors in the SSB frame and then obtain the detector tensor from the arm vectors
  中文翻译：我们需要找到LISA臂单位向量在SSB参考系下的分量，然后从臂向量得到探测器张量
  英文：Finally, contract the detector and polarization tensors to get antenna pattern functions
  中文翻译：最后，收缩探测器张量与极化张量以得到天线方向图函数
- 图片标注
  [图片：上半部分为LISA与地球、太阳的位置关系图，标注2.5 million km、19 - 23°、60°、1 AU；下半部分为LISA在太阳轨道上的阵列示意图，展示多个三角形结构]

## 幻灯片12：Obtain the arm components in the SSB frame

- 主标题
  英文：Obtain the arm components in the SSB frame
  中文翻译：获取SSB参考系下的臂分量
- 旋转矩阵公式
  \( \begin{pmatrix} v'_1 \\ v'_2 \\ v'_3 \end{pmatrix} = R_{XYZ \to X'Y'Z'} \begin{pmatrix} v_1 \\ v_2 \\ v_3 \end{pmatrix} \)；\( R_{XYZ \to X'Y'Z'} = \begin{pmatrix} \hat{x}'.\hat{x} & \hat{x}'.\hat{y} & \hat{x}'.\hat{z} \\ \hat{y}'.\hat{x} & \hat{y}'.\hat{y} & \hat{y}'.\hat{z} \\ \hat{z}'.\hat{x} & \hat{z}'.\hat{y} & \hat{z}'.\hat{z} \end{pmatrix} \)；\( RR^T = I \)
- 步骤说明
  - 英文：1: Get rotating arm unit vector components in Blue frame (See Fig. 4 of LDC1 manual)
    中文翻译：1: 获取蓝色参考系下旋转臂的单位向量分量（见LDC1手册图4）
  - 英文：2: get rotation matrix from blue to green frame
    中文翻译：2: 获取从蓝色参考系到绿色参考系的旋转矩阵
  - 英文：3: get rotation matrix from green to black (SSB) frame
    中文翻译：3: 获取从绿色参考系到黑色（SSB）参考系的旋转矩阵
  - 英文：4: use product of rotation matrices to transform arm unit vector components to SSB frame
    中文翻译：4: 使用旋转矩阵的乘积将臂单位向量分量变换到SSB参考系
- 周期说明
  英文：Period = 1 y（两处）
  中文翻译：周期 = 1年
- 臂向量示意图
  [图片：包含X,Y,Z轴、旋转后的X',Y',Z'轴、绿色参考系X'',Y'',Z''轴（标注60°角），以及LISA三颗卫星的臂向量\( \hat{n}_1, \hat{n}_2, \hat{n}_3 \)示意图]

## 幻灯片13：Antenna patterns

- 主标题
  英文：Antenna patterns
  中文翻译：天线方向图
- 要点
  英文：Use the expressions in Sec IIIB of the paper arXiv:1207.4956v1 to obtain the detector tensors for the two Michelson TDI combinations
  中文翻译：使用论文arXiv:1207.4956v1中第IIIB节的表达式，获取两种Michelson TDI组合对应的探测器张量
  - 公式（论文引用内容）
    英文原文及公式：_the GW propagation direction. The two detector tensors are defined as \( D_I \equiv \frac{1}{2}(\hat{n}_1 \otimes \hat{n}_1 - \hat{n}_2 \otimes \hat{n}_2), D_{II} \equiv \frac{1}{2\sqrt{3}}(\hat{n}_1 \otimes \hat{n}_1 + \hat{n}_2 \otimes \hat{n}_2 - 2\hat{n}_3 \otimes \hat{n}_3) \), where \( \hat{n}_1, \hat{n}_2, \hat{n}_3 \) denote the unit vectors along each arm of LISA. Here we assume_
    中文翻译：引力波传播方向。两个探测器张量定义为 \( D_I \equiv \frac{1}{2}(\hat{n}_1 \otimes \hat{n}_1 - \hat{n}_2 \otimes \hat{n}_2) \)，\( D_{II} \equiv \frac{1}{2\sqrt{3}}(\hat{n}_1 \otimes \hat{n}_1 + \hat{n}_2 \otimes \hat{n}_2 - 2\hat{n}_3 \otimes \hat{n}_3) \)，其中\( \hat{n}_1, \hat{n}_2, \hat{n}_3 \)表示LISA各臂的单位向量。此处我们假设
  英文：Obtain the \( F_{+,\times}(t;\hat{n}) \) for each TDI combination by contracting the respective detector tensor above with each polarization tensor
  中文翻译：通过将上述各探测器张量与各极化张量收缩，获取每种TDI组合对应的\( F_{+,\times}(t;\hat{n}) \)
  英文：Write a code:
  中文翻译：编写代码：
  - 子要点1
    英文：Inputs: Source direction, vector of sample times
    中文翻译：输入：源方向、采样时间向量
  - 子要点2
    英文：Outputs: \( F_+, F_\times \) time series for a Michelson TDI combination
    中文翻译：输出：某一Michelson TDI组合的\( F_+, F_\times \)时间序列

## 幻灯片14：Toy LISA response: Partial

- 主标题
  英文：Toy LISA response: Partial
  中文翻译：简易LISA响应：部分实现
- 要点
  英文：Write a Matlab script to do the following
  中文翻译：编写Matlab脚本以完成以下操作
  英文：Generate \( h_+, h_\times \) that are sinusoidal
  中文翻译：生成正弦形式的\( h_+, h_\times \)
  - 子要点
    英文：The script should have user - specified sky location and polarization angle for the GW source
    中文翻译：脚本应包含用户指定的引力波源天区位置和极化角
  英文：Generate any one of the Michelson TDI response (no doppler shift included) using the code from the previous exercise to generate the \( F_{+,\times} \) time series
  中文翻译：使用上一练习的代码生成\( F_{+,\times} \)时间序列，以生成任意一种Michelson TDI响应（不包含多普勒频移）
  - 公式
    \( s(t) = F_+(t;\theta,\phi)h_+(t) + F_\times(t;\theta,\phi)h_\times(t) \)
  英文：Take FFT of the detector response and compare to the FFT of \( h_+ \)
  中文翻译：对探测器响应做快速傅里叶变换（FFT），并与\( h_+ \)的FFT做比较

## 幻灯片15：Toy LISA response: Full

- 主标题
  英文：Toy LISA response: Full
  中文翻译：简易LISA响应：完整实现
- 要点
  英文：LISA detector response including doppler shift
  中文翻译：包含多普勒频移的LISA探测器响应
  - 子要点1（频移公式）
    英文：\( h_{+,\times}(t) \to h_{+,\times}(t - \frac{\hat{n} \cdot \vec{x}_d}{c}) \)
    中文翻译：\( h_{+,\times}(t) \to h_{+,\times}(t - \frac{\hat{n} \cdot \vec{x}_d}{c}) \)
  - 子要点2（符号解释）
    英文：\( \hat{n} \): Wave propagation direction
    中文翻译：\( \hat{n} \)：波传播方向
  - 子要点3（符号解释）
    英文：\( \vec{x}_d(t) \): LISA centroid
    中文翻译：\( \vec{x}_d(t) \)：LISA质心
  英文：Write a code to calculate the components of the position vector, \( \vec{x}_d \), of the LISA centroid (simple circular orbit) in the SSB frame
  中文翻译：编写代码，计算SSB参考系下LISA质心位置向量\( \vec{x}_d \)的分量（简单圆轨道）
  英文：Plot any one of the LISA Michelson responses for a monochromatic source in the SSB frame
  中文翻译：在SSB参考系下，绘制LISA对单色源的任意一种Michelson响应
  - 子要点1（SSB系信号形式）
    英文：In SSB frame: \( h_+(t) = A \sin(\omega_0 t); h_\times(t) = \left( \frac{A}{2} \right) \cos\omega_0 t \)
    中文翻译：在SSB参考系下：\( h_+(t) = A \sin(\omega_0 t); h_\times(t) = \left( \frac{A}{2} \right) \cos\omega_0 t \)
  - 子要点2（多普勒调制信号）
    英文：Generate doppler modulated sinusoids \( h_+, h_\times \):
    中文翻译：生成多普勒调制的正弦信号\( h_+, h_\times \)：
    - 公式
      \( h_+(t) = A \sin\left( \omega_0 \left( t - \frac{\hat{n} \cdot \vec{x}_d}{c} \right) \right) \)
      \( h_\times(t) = B \cos\left( \omega_0 \left( t - \frac{\hat{n} \cdot \vec{x}_d}{c} \right) \right) \)
    - 补充说明
      英文：One parameter is missing here: polarization angle (but we will ignore it)
      中文翻译：此处缺少一个参数：极化角（但我们将忽略它）
  英文：Compare FFT of the response to that of \( h_{+,\times}(t) \) in the SSB frame
  中文翻译：将响应的FFT与SSB参考系下\( h_{+,\times}(t) \)的FFT做比较

## 幻灯片16：Effect of sky location

- 主标题
  英文：Effect of sky location
  中文翻译：天区位置的影响
- 要点
  英文：Take the same SSB frame \( h_+, h_\times \) but at a different sky location and verify that the LISA response is different
  中文翻译：采用同一SSB参考系下的\( h_+, h_\times \)，但更换天区位置，验证LISA响应存在差异
  英文：This allows LISA to have directional sensitivity to long - lived sources.
  中文翻译：这使得LISA对长期存在的源具备方向敏感性

## 幻灯片17：Advanced

- 主标题
  英文：Advanced
  中文翻译：进阶内容
- 要点
  英文：Find out about the Tianqin detector configuration, which is a geocentric one
  中文翻译：了解天琴（Tianqin）探测器构型，其为地心轨道探测器
  - 子要点（参考文献）
    英文：J. Luo et al., “TianQin: a space - borne gravitational wave detector,” _Class. Quant. Grav._, vol. 33, no. 3, p. 035010, 2016.
    中文翻译：J. Luo等人，“TianQin：一款星载引力波探测器”，《Classical and Quantum Gravity》，第33卷，第3期，第035010页，2016年。
  英文：Write code using tensors to compute the response of Tianqin in the long wavelength approximation
  中文翻译：使用张量编写代码，在长波长近似下计算天琴探测器的响应
  英文：(Taiji configuration is essentially the same as LISA and, hence, does not lead to a very different result)
  中文翻译：（太极（Taiji）构型与LISA基本相同，因此结果不会有很大差异）
