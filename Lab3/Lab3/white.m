% 固定随机种子确保结果可复现
rng(0); 

% 参数设置
N = 10000;  % 每组样本数量
groups = {
    struct('name', 'Group 1: μ=0, σ=1',   'mu', 0, 'sigma', 1),  % 标准差=1
    struct('name', 'Group 2: μ=0, σ=2',   'mu', 0, 'sigma', 2),  % 标准差=2
    struct('name', 'Group 3: μ=0, Var=2', 'mu', 0, 'sigma', sqrt(2)), % 方差=2 → 标准差=√2
    struct('name', 'Group 4: μ=2, Var=2', 'mu', 2, 'sigma', sqrt(2))  % 方差=2 → 标准差=√2
};

% 预存储结果
results = cell(length(groups), 1);
figure;

% 生成每组噪声并分析
for i = 1:length(groups)
    % 生成高斯白噪声
    noise = groups{i}.mu + groups{i}.sigma * randn(N, 1);
    
    % 计算样本统计量
    sample_mean = mean(noise);
    sample_std = std(noise);
    
    % 存储结果
    results{i} = table(sample_mean, sample_std, 'RowNames', {groups{i}.name});
    
    % 绘制直方图 (4x1子图)
    subplot(4, 1, i);
    histogram(noise, 50, 'Normalization', 'pdf', 'FaceColor', [0.6 0.8 1]);
    hold on;
    
    % 叠加理论PDF曲线
    x = linspace(min(noise), max(noise), 1000);
    theory_pdf = (1/(groups{i}.sigma*sqrt(2*pi))) * exp(-(x - groups{i}.mu).^2 / (2*groups{i}.sigma^2));
    plot(x, theory_pdf, 'r-', 'LineWidth', 1.5);
    
    title(sprintf('%s\n样本均值: %.4f, 样本标准差: %.4f', groups{i}.name, sample_mean, sample_std));
    xlabel('幅值');
    ylabel('概率密度');
    legend('样本分布', '理论PDF');
    grid on;
    hold off;
end

% 调整布局
set(gcf, 'Position', [100, 100, 800, 1200]); % 设置图像尺寸
sgtitle('不同参数高斯白噪声的分布对比 (N=10,000)'); % 总标题

% 显示统计结果
disp('统计结果:');
cellfun(@disp, results);