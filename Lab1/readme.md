
# Lab1 项目说明

---

## 文件说明

- **`estmFreqBW.m`**：用于估计信号的频率带宽。
- **`ExactEstmFreqBW.m`**：精确计算信号的频率带宽。
- **`getEnergy.m`**：计算信号的能量。
- **`Lab1SigDef.m`**：定义了本项目中使用的各种信号，例如正弦信号、调频信号等。
- **`Lab1Tasks_filtering.m`**：演示如何对信号应用低通滤波器并可视化结果。
- **`Lab1Tasks.m`**：Lab1 的主要任务脚本，整合了信号生成、处理和分析的功能。
- **`Signal.m`**：定义了 `Signal` 类，用于表示信号及其相关属性和方法。
- **`testExactEstmFreqBW.m`**：测试 `ExactEstmFreqBW` 函数的脚本，验证其准确性。
- **`testtemp.m`**：临时测试脚本，用于调试和实验。
- **`eg/`**：
  - **`.vscode/`**：VSCode 配置文件。
  - **`SIGNALS/`**：包含信号相关的脚本和示例，例如 `crcbgenqcsig.m` 用于生成二次调频信号。
  - **`ChirpSignalOptimized/`**：优化的调频信号示例及相关文档。

---

## 注意事项

1. **MATLAB 版本**：建议使用 MATLAB R2020b 或更高版本，以确保兼容性。
2. **依赖工具箱**：某些功能可能需要 Signal Processing Toolbox。
3. **路径设置**：运行脚本前，请确保已将项目文件夹添加到 MATLAB 的搜索路径中。
4. **运行顺序**：建议先运行 `Lab1SigDef.m` 定义信号，再运行其他任务脚本。

---