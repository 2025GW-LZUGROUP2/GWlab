# 图像目录说明

本目录包含二次调频信号分析生成的示例图像。运行 `testcrcbgenqcsig.m` 脚本将会生成以下图像：

1. `time_domain.png` - 信号的时域表示
2. `full_spectrum.png` - 完整频谱（包含正负频率）
3. `periodogram.png` - 信号的周期图（仅正频率）
4. `spectrogram.png` - 信号的时频表示（频谱图）

## 图像保存说明

要保存脚本生成的图像，可以在脚本末尾添加以下代码：

```matlab
% 创建图像目录（如果不存在）
figDir = '../examples/figures';
if ~exist(figDir, 'dir')
    mkdir(figDir);
end

% 保存所有图像
figHandles = findobj('Type', 'figure');
for i = 1:length(figHandles)
    fig = figHandles(i);
    figName = fig.Name;
    
    % 根据图像名称确定文件名
    switch figName
        case '时域信号'
            fileName = 'time_domain.png';
        case '完整频谱'
            fileName = 'full_spectrum.png';
        case '周期图（正频率）'
            fileName = 'periodogram.png';
        case '频谱图'
            fileName = 'spectrogram.png';
        otherwise
            fileName = sprintf('figure%d.png', i);
    end
    
    % 保存图像
    saveas(fig, fullfile(figDir, fileName));
    fprintf('已保存图像：%s\n', fileName);
end
```

## 图像解释

每个图像展示了二次调频信号的不同方面：

- **时域图像**：展示信号随时间的振荡变化，可以直观观察到频率增加导致的波形变化
- **频谱图像**：显示信号的频率成分分布
- **周期图**：重点展示信号能量在频域的分布
- **频谱图**：结合时间和频率维度，展示频率随时间的变化特性

详细的图像解释请参见 [results.md](../results.md) 文档。
