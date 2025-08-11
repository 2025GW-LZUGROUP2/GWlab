%本文件将一次性完成Lab1的所有任务
%我们定义了一个类Signal 用于描述和生成参数化数学信号，支持符号表达式、参数替换和信号向量生成。
%请使用命令help Signal;help ExactEstmFreqBW;以帮助你理解此文件

clc; clear;
% 定义符号变量
syms t;
SNR = 10; %信噪比
tIntvl = [0, 1]; % timeInterval 时间区间[0,1]
fsInit = 300; % 先给一个较高的采样率，保证后续分析准确
timeLength = tIntvl(2) - tIntvl(1);
timeVec = (tIntvl(1):1 / fsInit:tIntvl(2));
run(fullfile(fileparts(mfilename('fullpath')), 'Lab1SigDef.m')) %引用Lab1SigDef.m文件(这个文件定义了各个信号)

%% 定义所有信号类型及其属性
% 信号对象数组
SigCho = [Sig_qc, Sig_lc, Sig_ss, Sig_FM, Sig_Sg, Sig_AM, Sig_AMFM];

% 信号类型标识符
SigTypes = {'qc', 'lc', 'ss', 'FM', 'Sg', 'AM', 'AMFM'};

% 标准正弦类信号的phi映射
PhiMap = struct();
PhiMap.qc = phi_qc;
PhiMap.lc = phi_lc;
PhiMap.ss = phi_ss;
PhiMap.FM = phi_FM;

% 信号类型对应的文件夹名称（英文+中文）
signalNames = struct();
signalNames.qc = 'Quadratic Chirp二次调频信号';
signalNames.lc = 'Linear Chirp线性调频信号';
signalNames.ss = 'Sinusoidal Signal正弦信号';
signalNames.FM = 'Frequency Modulated (FM) Sinusoid频率调制正弦信号';
signalNames.Sg = 'Sine-Gaussian Signal正弦-高斯信号';
signalNames.AM = 'Amplitude Modulated (AM) Sinusoid幅度调制正弦信号';
signalNames.AMFM = 'AM-FM Sinusoid幅度-频率调制正弦信号';

% 创建主结果目录
scriptDir = fileparts(mfilename('fullpath'));
resultDir = fullfile(scriptDir, 'result');
if ~exist(resultDir, 'dir')
    mkdir(resultDir);
    fprintf('创建主结果目录: %s\n', resultDir);
end

%% 循环处理每种信号
for sigIdx = 1:length(SigCho)
    try
        % 1. 选择当前信号和设置参数
        SigNow = SigCho(sigIdx);
        currentType = SigTypes{sigIdx};
        
        fprintf('\n\n============================================\n');
        fprintf('处理信号类型: %s - %s\n', currentType, signalNames.(currentType));
        fprintf('============================================\n');
        
        % 设置phiNow - 根据信号类型判断
        if isfield(PhiMap, currentType)
            % 标准正弦类信号
            phiNow = PhiMap.(currentType);
            fprintf('设置标准正弦类信号phi参数\n');
        else
            % 非标准正弦类，置空
            phiNow = [];
            fprintf('设置非标准正弦类信号，phi参数为空\n');
        end
        
        % 2. 信号参数计算
        maxFreq = ExactEstmFreqBW(SigNow);
        NyqFreq = 2 * maxFreq;
        sampFreq = 5 * NyqFreq; %采样频率 5倍安全系数
        sampIntvl = 1 / sampFreq;
        timeVec = tIntvl(1):sampIntvl:tIntvl(2);
        
        % 3. 生成信号
        SigNow.timeVec = timeVec; %更新SigNow，使其生成正确的SigVec
        SigVec = SigNow.SigVec; %取出生成的SigVec
        SigVec = SNR * SigVec / norm(SigVec); %归一化
        N = length(timeVec); %时间向量的分量数
        fftVec = fft(SigVec);
    catch e
        fprintf('处理信号 %s 时发生错误：%s\n', currentType, e.message);
        fprintf('跳过此信号，继续处理下一个\n');
        continue;
    end
    %% 画信号图，信号的Signal-Time图
    fi1=figure('Name', ['信号的Signal-Time图 - ', currentType]);
    plot(timeVec, SigVec, 'Marker', '.', 'MarkerSize', 20);
    xlabel('Time/s');
    ylabel('Signal');
    title(['信号: ', signalNames.(currentType)]);
    
    %% 画Periodogram图，信号的|fft|-f图
    fprintf('判断标准：如果0-NyqFreq区间内，覆盖了|fft|的绝大部分面积，即可认为maxFreq估计正确');
    NyqLimIdx = floor(N / 2) + 1; %Nyquist Limit频率所对应的指数 Nyquist Limit Index(the the index when f=fs/2)
    posFreq = (0:(NyqLimIdx - 1) / timeLength);
    fftVec_posFreq = fftVec(1:NyqLimIdx);
    fi2=figure('Name', ['Periodogram图，信号的|fft|-f图 - ', currentType], 'Position', [100 100 800 600]);
    fftline = plot(posFreq, abs(fftVec_posFreq));
    hold on;
    xlabel("频率Frequency(Hz)");
    ylabel("|fft|");
    title(['信号: ', signalNames.(currentType)]);
    
    % 填充曲线下方的颜色
    fillX = [posFreq(posFreq <= NyqFreq), NyqFreq]; % 添加 NyqFreq 作为最后一个点
    fillY = [abs(fftVec_posFreq(1:sum(posFreq <= NyqFreq))), 0]; % 对应 NyqFreq 的 y 值为 0
    fill([fillX, flip(fillX)], [fillY, zeros(size(fillY))], 'cyan', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    h1 = xline(maxFreq, 'r--', 'LineWidth', 1);
    h2 = xline(NyqFreq, 'b--', 'LineWidth', 1);
    grid on;
    legend([fftline, h1, h2], {'|fft|', 'max Frequency(band width)', 'Nyquist Frequency'});
    
    %% compare
    fi3=figure("Name", ['periodogram - ', currentType]);
    [pxx, w] = periodogram(SigVec, rectwin(N), N, sampFreq); 
    plot(w,sqrt(length(pxx)*abs(pxx)))
    xlabel("频率Frequency(Hz)");
    title(['信号: ', signalNames.(currentType)]);
    
    %% Play the signal!
    % sound(SigNow.SigVec);
    %>> help sound
    %  sound - 将信号数据矩阵转换为声音
    %     此 MATLAB 函数 以默认采样率 8192 Hz 向扬声器发送音频信号 y。
    
    %     语法
    %       sound(y)
    %       sound(y,Fs)
    %       sound(y,Fs,nBits)
    
    %     输入参数
    %       y - 音频数据
    %         数值向量 | 数值矩阵
    %       Fs - 采样率
    %         8192 (默认值) | 正标量
    %       nBits - 采样位数。
    %         16 (默认值) | 8 | 24
    
    %% 画出时频图spectrogram
    fi4=figure("Name", ['spectrogram时频图 - ', currentType]);
    winTlen = 0.2/20; % second
    ovlTlen = 0.1/20; % second
    winSamplN = floor(winTlen * sampFreq * 10);
    ovlSamplN = floor(ovlTlen * sampFreq * 10);
    [S, F, T] = spectrogram(SigVec, winSamplN, ovlSamplN, [], sampFreq * 10);
    imagesc(T, F, abs(S));
    axis xy;
    xlabel('Time /s'); ylabel('Frequency /Hz')
    title(['信号: ', signalNames.(currentType)]);




    %  保存结果到 /result/信号类型 文件夹
    scriptDir = fileparts(mfilename('fullpath'));
    resultDir = fullfile(scriptDir, 'result');
    if ~exist(resultDir, 'dir'), mkdir(resultDir); end
    
    % 确保有效的信号类型标识符
    if ~isfield(signalNames, currentType)
        warning('未知的信号类型标识符: %s，跳过处理', currentType);
        continue;
    end
    
    % 创建当前信号类型的文件夹
    sigDir = fullfile(resultDir, signalNames.(currentType));
    if ~exist(sigDir, 'dir'), mkdir(sigDir); end
    fprintf('为 %s 创建输出目录: %s\n', currentType, sigDir);
    
    % 准备保存图像（三种格式：fig, pdf, jpg）
    % 图1: 信号的Signal-Time图
    sigTimePath_fig = fullfile(sigDir, 'signal_time.fig');
    sigTimePath_pdf = fullfile(sigDir, 'signal_time.pdf');
    sigTimePath_jpg = fullfile(sigDir, 'signal_time.jpg');
    
    % 图2: Periodogram图，信号的|fft|-f图
    fftPath_fig = fullfile(sigDir, 'periodogram.fig');
    fftPath_pdf = fullfile(sigDir, 'periodogram.pdf');
    fftPath_jpg = fullfile(sigDir, 'periodogram.jpg');
    
    % 图3: periodogram比较图
    periPath_fig = fullfile(sigDir, 'periodogram_compare.fig');
    periPath_pdf = fullfile(sigDir, 'periodogram_compare.pdf');
    periPath_jpg = fullfile(sigDir, 'periodogram_compare.jpg');
    
    % 图4: 时频图spectrogram
    specPath_fig = fullfile(sigDir, 'spectrogram.fig');
    specPath_pdf = fullfile(sigDir, 'spectrogram.pdf');
    specPath_jpg = fullfile(sigDir, 'spectrogram.jpg');
    
    % 保存所有图像，三种格式
    try
        % 保存图1 - 移除工具栏并使用更好的导出选项
        saveas(fi1, sigTimePath_fig);
        ax1 = gca(fi1); % 获取当前坐标区
        ax1.Toolbar.Visible = 'off'; % 隐藏工具栏
        exportgraphics(fi1, sigTimePath_pdf, 'Resolution', 300, 'ContentType', 'vector');
        exportgraphics(fi1, sigTimePath_jpg, 'Resolution', 300);
        
        % 保存图2
        saveas(fi2, fftPath_fig);
        ax2 = gca(fi2);
        ax2.Toolbar.Visible = 'off';
        exportgraphics(fi2, fftPath_pdf, 'Resolution', 300, 'ContentType', 'vector');
        exportgraphics(fi2, fftPath_jpg, 'Resolution', 300);
        
        % 保存图3
        saveas(fi3, periPath_fig);
        ax3 = gca(fi3);
        ax3.Toolbar.Visible = 'off';
        exportgraphics(fi3, periPath_pdf, 'Resolution', 300, 'ContentType', 'vector');
        exportgraphics(fi3, periPath_jpg, 'Resolution', 300);
        
        % 保存图4
        saveas(fi4, specPath_fig);
        ax4 = gca(fi4);
        ax4.Toolbar.Visible = 'off';
        exportgraphics(fi4, specPath_pdf, 'Resolution', 300, 'ContentType', 'vector');
        exportgraphics(fi4, specPath_jpg, 'Resolution', 300);
    catch
        % 如果exportgraphics失败，尝试使用saveas作为备选
        try
            if ~exist(sigTimePath_jpg, 'file')
                saveas(fi1, sigTimePath_jpg);
            end
            if ~exist(fftPath_jpg, 'file')
                saveas(fi2, fftPath_jpg);
            end
            if ~exist(periPath_jpg, 'file')
                saveas(fi3, periPath_jpg);
            end
            if ~exist(specPath_jpg, 'file')
                saveas(fi4, specPath_jpg);
            end
            
            if ~exist(sigTimePath_pdf, 'file')
                saveas(fi1, sigTimePath_pdf);
            end
            if ~exist(fftPath_pdf, 'file')
                saveas(fi2, fftPath_pdf);
            end
            if ~exist(periPath_pdf, 'file')
                saveas(fi3, periPath_pdf);
            end
            if ~exist(specPath_pdf, 'file')
                saveas(fi4, specPath_pdf);
            end
        catch
            warning('部分图像保存失败');
        end
    end
    
    %  保存文本结果
    txtPath = fullfile(sigDir, 'signal_info.txt');
    fid = fopen(txtPath, 'w');
    if fid ~= -1
        fprintf(fid, '信号类型: %s\n', signalNames.(currentType));
        fprintf(fid, '信号标识: %s\n', currentType);
        % 尝试获取信号表达式（如果可用）
        try
            fprintf(fid, '信号表达式: %s\n', char(SigNow.SigExp));
        catch
            fprintf(fid, '信号表达式: 不可用\n');
        end
        fprintf(fid, '最大频率: %f Hz\n', maxFreq);
        fprintf(fid, '奈奎斯特频率: %f Hz\n', NyqFreq);
        fprintf(fid, '采样频率: %f Hz\n', sampFreq);
        fprintf(fid, '时间区间: [%f, %f] s\n', tIntvl(1), tIntvl(2));
        fprintf(fid, '信噪比: %f\n', SNR);
        fclose(fid);
    else
        warning('无法写入文本文件：%s', txtPath);
    end
    
    fprintf('文件已保存至：\n  %s\n', sigDir);
    
    % 关闭图形窗口，准备处理下一个信号
    close(fi1);
    close(fi2);
    close(fi3);
    close(fi4);
    
    % 暂停一下，让用户可以查看输出
    pause(1);
end

%% 完成所有信号处理
fprintf('\n\n============================================\n');
fprintf('所有信号处理完毕！\n');
fprintf('结果已保存到目录：%s\n', resultDir);
fprintf('============================================\n');


